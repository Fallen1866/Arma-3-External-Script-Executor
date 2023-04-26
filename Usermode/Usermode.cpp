#include "includes.h"
#include "sdk.h"
#include "sqf.h"
#include "hook.h"
#include "window.h"
#include "executor.h"
#include "scheduler.h"
#include "eventhandler.h"
#include "vardumper.h"

void UpdateThread() {
	while (MenuWindow->m_Running) {
		for (auto Tab : TabManager::m_Tabs)
			Tab->Update();
		Sleep(16);
	}
}

void RemoveScriptRestrictions() {
	const auto NetworkManager = coms->Read<UINT64>(SDK->GetModuleBase() + 0x26305E8);

	const auto NetworkClient = coms->Read<UINT64>(NetworkManager + 0x48);

	const auto Callback = coms->Read<UINT64>(NetworkClient + 0x548);

	const auto NewCallback = Callback - 0x1D;

	if (coms->Read<int>(NewCallback) == 0xCCCCCCC3) {
		if (coms->Read<UINT64>(NetworkClient) != Callback) {
			coms->Write<UINT64>(NetworkClient + 0x548, NewCallback);
			LogSuccess("Patched :) \n");
		}
	}
}

bool isRunningAsAdmin()
{
	BOOL bIsAdmin = FALSE;
	PSID pAdminSid = NULL;

	// Allocate and initialize the SID for the Administrators group
	SID_IDENTIFIER_AUTHORITY NtAuthority = SECURITY_NT_AUTHORITY;
	if (!AllocateAndInitializeSid(&NtAuthority, 2, SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS, 0, 0, 0, 0, 0, 0, &pAdminSid))
	{
		return false;
	}

	// Check if the current process token is a member of the Administrators group
	if (!CheckTokenMembership(NULL, pAdminSid, &bIsAdmin))
	{
		bIsAdmin = FALSE;
	}

	// Free the SID
	FreeSid(pAdminSid);

	return bIsAdmin != FALSE;
}

int main() 
{
	if (!isRunningAsAdmin())
	{
		LogFailure("Run as admin \n");
		system("pause");
		return -1;
	}

	if (!coms->SetupInterface("arma3_x64.exe")) {
		LogFailure("Failed to setup interface \n");
		system("pause");
		return -1;
	}

	if (!SDK->InitSDK()) {
		LogFailure("Failed to setup SDK \n");
		system("pause");
		return -2;
	}

	RemoveScriptRestrictions();

	SDK->DebugInfo();

	if (!SDK->InitComps()) {
		LogFailure("Failed to setup Components \n");
		system("pause");
		return -3;
	}

	if (!MenuWindow->StartWindow())
	{
		LogFailure("Failed to create window\n");
		system("pause");
		return -4;
	}

	LogSuccess("Successfully setup window\n");

	// CreateThread(0, 0, (LPTHREAD_START_ROUTINE)UpdateThread, 0, 0, 0);

	MenuWindow->RenderLoop();
}

