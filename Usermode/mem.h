#ifndef _MEMORY
#define _MEMORY

#include "includes.h"
#include <TlHelp32.h>
#include <iostream>
#include <Windows.h>
#pragma comment(lib, "onecore.lib")

#define USERMODE 0
#define KERNEL   1

#define TYPE USERMODE

#if TYPE

struct ComPacket
{
	const UINT32 key = 0x187;

	enum Type
	{
		baseAddress,
		write,
		protectVirtualMemory,
		isLoaded
	} type;

	bool sucsess = false;
};

struct BaseAddressPacket : ComPacket
{
	wchar_t moduleName[0x100];
	UINT32 targetPID = 0;
	UINT64 moduleBase = 0;
	UINT64 moduleSize = 0;
};

struct WritePacket : ComPacket
{
	UINT32 sourcePID = 0;
	UINT32 targetPID = 0;
	PVOID sourceAddr = 0;
	PVOID targetAddr = 0;
	SIZE_T size = 0;
};

struct ProtectVirtualMemoryPacket : ComPacket
{
	UINT32  targetPID = 0;
	PVOID   address = 0;
	SIZE_T  size = 0;
	ULONG   newAccessProtection;
	ULONG   oldAccessProtection;
};

typedef UINT32 t_NtGdiFlush(void* ComPacket);
static t_NtGdiFlush* NtGdiFlush = nullptr;

class KernelInterface {
private:
	DWORD m_PID = -1;

	DWORD InternalGetProcessID(const char* Target);

private:
	void CallHook(ComPacket* packet);

public:
	bool InitHook();

public:
	template<typename T>
	T Read(UINT64 Address) {
		T Buffer = {};
		
		static auto CurrentProcessID = GetCurrentProcessId();

		WritePacket Request = {};

		Request.type = ComPacket::Type::write;
		Request.targetPID = CurrentProcessID;
		Request.targetAddr = &Buffer;
		Request.sourcePID = m_PID;
		Request.sourceAddr = (PVOID)Address;
		Request.size = sizeof(T);

		CallHook((ComPacket*)&Request);

		return Buffer;
	}

	template<typename T>
	void Write(UINT64 Address, T Buffer) {
		static auto CurrentProcessID = GetCurrentProcessId();

		WritePacket Request = {};

		Request.type = ComPacket::Type::write;
		Request.sourcePID = CurrentProcessID;
		Request.sourceAddr = &Buffer;
		Request.targetPID = m_PID;
		Request.targetAddr = (PVOID)Address;
		Request.size = sizeof(T);

		CallHook((ComPacket*)&Request);
	}

	bool ReadBuffer(UINT64 Address, SIZE_T Size, PVOID Buffer) {
		static auto CurrentProcessID = GetCurrentProcessId();

		WritePacket Request = {};

		Request.type = ComPacket::Type::write;
		Request.targetPID = CurrentProcessID;
		Request.targetAddr = Buffer;
		Request.sourcePID = m_PID;
		Request.sourceAddr = (PVOID)Address;
		Request.size = Size;

		CallHook((ComPacket*)&Request);

		return Request.sucsess;
	}

	std::string ReadString(UINT64 Address, SIZE_T Size) {
		char* StringBuffer = new char[Size + 1];
		StringBuffer[Size] = '\x00';

		ReadBuffer(Address, Size, StringBuffer);

		std::string Buffer = std::string(StringBuffer);
		delete[] StringBuffer;	// keine memory leak bitte.
		return Buffer;
	}

	UINT64 GetModuleBase(const char* ModuleName) {
		BaseAddressPacket packet;

		packet.type = ComPacket::Type::baseAddress;
		packet.targetPID = m_PID;

		const size_t cSize = strlen(ModuleName) + 1;
		wchar_t* wString = new wchar_t[cSize];
		mbstowcs(wString, ModuleName, cSize);

		wcscpy_s(packet.moduleName, 256, wString);

		delete[] wString;

		CallHook(((ComPacket*)&packet));

		return packet.moduleBase;
	}

	bool SetupInterface(const char* TargetApplication) {
		while (true) {
			if (m_PID = InternalGetProcessID(TargetApplication))
				return InitHook();

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

	UINT64 AllocateMemory(SIZE_T Size = 0x30, ULONG AllocFlags = MEM_COMMIT | MEM_RESERVE, ULONG PageProtect = PAGE_EXECUTE_READWRITE) {
		return (UINT64)VirtualAlloc2(m_hProc, nullptr, Size, AllocFlags, PageProtect, nullptr, 0);
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