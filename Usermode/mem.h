#ifndef _MEMORY
#define _MEMORY

#include "includes.h"
#include <TlHelp32.h>

#define USERMODE 0
#define KERNEL   1

#define TYPE USERMODE

#if TYPE

// KERNEL

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