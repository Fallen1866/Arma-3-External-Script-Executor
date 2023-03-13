#ifndef _MEMORY
#define _MEMORY

#include "includes.h"
#include <TlHelp32.h>
#include <Windows.h>
#include "log.h"
#include <iostream>

#define USERMODE 0
#define KERNEL   1

#define TYPE KERNEL

#if TYPE
typedef struct _KERNEL_MEMORY_REQUEST {
	ULONG request_type;
	ULONG pid;
	PVOID source;
	PVOID buffer;
	SIZE_T size;
	const char* module_name;
	UINT64 overlay_info;
} KERNEL_MEMORY_REQUEST, * PKERNEL_MEMORY_REQUEST;

#define STANDARD_COM_KEY 0x691337
#define SECURITY_TOKEN 0xDEADBEEF
#define STREAM_UNLOCK 0x103
#define STREAMED_UNLOCK_KEY 0x5183
#define READ 0xFACC
#define WRITE 0xBACF
#define MODULE_BASE 0xEAC
#define PROCESS_BASE 0xBE
#define USERMODE_PROCESS_SET 0xDECL
#define UNLOAD_HOOK 0xDA
#define INIT_BE_HOOK 0xD5
#define IS_ACTIVE 0x5837A
#define ACTIVATE_OVERLAY_PROTECTION 0x01041

// KERNEL
class KernelInterface {
	DWORD m_Pid;

	// Driver Needed Stuff
	uintptr_t(__stdcall* DriverFunction)(int unlock, PKERNEL_MEMORY_REQUEST buffer_pointer);
	int Commkey = 0x691337;
	bool ZwQueryHook;

	DWORD InternalGetProcessID(const char* Target);
	


	bool InitBypass() {
		LoadLibraryA("user32.dll");
		void* hooked_function = GetProcAddress(LoadLibraryA("win32u.dll"), "NtGdiGetStats");

		if (hooked_function) {
			*(void**)&DriverFunction = static_cast<int(_stdcall*)()>(hooked_function);

			KERNEL_MEMORY_REQUEST unlock = {};
			unlock.pid = unlock.pid = 0X1337;

			Commkey = DriverFunction(Commkey, &unlock);

			KERNEL_MEMORY_REQUEST unlock_driver_buffer = {};
			unlock_driver_buffer.request_type = STREAM_UNLOCK;
			unlock_driver_buffer.buffer = (PVOID)STREAMED_UNLOCK_KEY;

			DriverFunction(Commkey, &unlock_driver_buffer);

			unlock_driver_buffer.request_type = USERMODE_PROCESS_SET;
			unlock_driver_buffer.buffer = &ZwQueryHook;
			unlock_driver_buffer.pid = GetCurrentProcessId();

			DriverFunction(Commkey, &unlock_driver_buffer);

			unlock_driver_buffer.request_type = IS_ACTIVE;
			unlock_driver_buffer.buffer = 0;


			if (DriverFunction(Commkey, &unlock_driver_buffer) == IS_ACTIVE)
				return true;
		}

		return false;
	}

public:
	template<typename T>
	void Write(UINT64 Address, T Buffer) {
		KERNEL_MEMORY_REQUEST request = { 0 };
		request.request_type = WRITE;
		request.pid = m_Pid;
		request.source = (PVOID)Address;
		request.buffer = &Buffer;
		request.size = sizeof(T);

		DriverFunction(Commkey, &request);
	}

	template<typename T>
	T Read(UINT64 Address) {
		T buffer = {};
		KERNEL_MEMORY_REQUEST request = { 0 };
		request.request_type = READ;
		request.pid = m_Pid;
		request.source = (PVOID)Address;
		request.buffer = &buffer;
		request.size = sizeof(T);

		DriverFunction(Commkey, &request);

		return buffer;
	}

	bool ReadBuffer(UINT64 Address, SIZE_T Size, PVOID Buffer) {
		_KERNEL_MEMORY_REQUEST request = { 0 };
		request.request_type = READ;
		request.pid = m_Pid;
		request.source = (PVOID)Address;
		request.buffer = (PVOID)Buffer;
		request.size = Size;

		DriverFunction(Commkey, &request);

		return true;
	}

	std::string ReadString(UINT64 Address, SIZE_T Size) {
		if (Size <= 0)
			return "";

		const char* buffer = new char[Size];
		ReadBuffer(Address, Size, (PVOID)buffer);

		std::string ret = std::string(buffer);

		delete[] buffer;
		return ret;
	}

	UINT64 GetModuleBase(const char* ModuleName) {
		KERNEL_MEMORY_REQUEST request = {};

		request.request_type = MODULE_BASE;
		request.pid = m_Pid;
		request.module_name = ModuleName;

		return DriverFunction(Commkey, &request);
	}

	bool SetupInterface(const char* TargetApplication) {
		if (!InitBypass()) {
			LogFailure("Failed to setup bypass \n");
			return false;
		}

		while (true) {
			if (m_Pid = InternalGetProcessID(TargetApplication))
				return true;

			Sleep(250);
		}
	}

};

extern KernelInterface* coms;

#else
// USERMODE

class UsermodeInterface {
	HANDLE m_hProc;
	DWORD  m_ProcessID;

	UINT64 InternalGetModuleBase(const char* ModuleName);
	DWORD InternalGetProcessID(const char* Target);
	BOOL InternalOpenHandle();

public:
	template<typename T>
	void Write(UINT64 Address, T Buffer) {
		WriteProcessMemory(m_hProc, (BYTE*)Address, &Buffer, sizeof(Buffer), nullptr);
	}

	template<typename T>
	T Read(UINT64 Address) {
		T Buffer = {};
		ReadProcessMemory(m_hProc, (BYTE*)Address, &Buffer, sizeof(Buffer), nullptr);
		return Buffer;
	}

	bool ReadBuffer(UINT64 Address, SIZE_T Size, PVOID Buffer) {
		return (bool)ReadProcessMemory(m_hProc, (BYTE*)Address, Buffer, Size, nullptr);
	}

	std::string ReadString(UINT64 Address, SIZE_T Size) {
		char* StringBuffer = new char[Size + 1];
		StringBuffer[Size] = '\x00';

		ReadProcessMemory(m_hProc, (BYTE*)Address, StringBuffer, Size, nullptr);

		std::string Buffer = std::string(StringBuffer);
		delete[] StringBuffer;	// keine memory leak bitte.
		return Buffer;
	}

	UINT64 GetModuleBase(const char* ModuleName) {
		return InternalGetModuleBase(ModuleName);
	}

	bool SetupInterface(const char* TargetApplication) {
		while (true) {
			if (m_ProcessID = InternalGetProcessID(TargetApplication))
				return InternalOpenHandle();


			Sleep(250);
		}
	}
};

extern UsermodeInterface* coms;
#endif
#endif 