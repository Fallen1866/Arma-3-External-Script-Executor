#include "mem.h"


#if TYPE
// kernel shit if you want.
#else

DWORD UsermodeInterface::InternalGetProcessID(const char* Target) {
	HANDLE hSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);

	if (hSnap == INVALID_HANDLE_VALUE) {
		CloseHandle(hSnap);
		return -1;
	}

	PROCESSENTRY32 pe32;
	pe32.dwSize = sizeof(pe32);

	if (Process32First(hSnap, &pe32)) {
		do {
			if (!strcmp(Target, pe32.szExeFile)) {
				CloseHandle(hSnap);
				return pe32.th32ProcessID;
			}
		} while (Process32Next(hSnap, &pe32));
	}
	CloseHandle(hSnap);
	return 0;
}

BOOL UsermodeInterface::InternalOpenHandle() {
	m_hProc = OpenProcess(PROCESS_ALL_ACCESS, 0, m_ProcessID);
	return true;
}


UINT64 UsermodeInterface::InternalGetModuleBase(const char* ModuleName) {
	HANDLE hSnap = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE | TH32CS_SNAPMODULE32, this->m_ProcessID);

	if (hSnap == INVALID_HANDLE_VALUE) {
		CloseHandle(hSnap);
		return -1;
	}

	MODULEENTRY32 me32;
	me32.dwSize = sizeof(me32);

	if (Module32First(hSnap, &me32)) {
		do {
			if (!strcmp(ModuleName, me32.szModule)) {
				CloseHandle(hSnap);
				return (UINT64)me32.modBaseAddr;
			}
		} while (Module32Next(hSnap, &me32));
	}

	CloseHandle(hSnap);
	return 0;
}

UsermodeInterface* coms = new UsermodeInterface();

#endif