#include "includes.h"
#include "sdk.h"
#include "sqf.h"
#include "hook.h"
#include "window.h"
#include "executor.h"
#include "scheduler.h"
#include "eventhandler.h"
#include "vardumper.h"

// To Do:
// - SQF Functions
//		- get SQF Functions.
//		- get BinaryOperator for SQF Functions
//
//	- Eventhandlers
//		- Get Multiplayer Eventhandler
//		- Get Unit EventHandlers
//		- Get UI EventHandlers
//
//		- Get All Displays?
//	- Displays
//	
//	- GTA
//		- gta_fnc_createVehicle ??
//		- 

void UpdateThread() {
	while (MenuWindow->m_Running) {
		for (auto Tab : TabManager::m_Tabs)
			Tab->Update();
		Sleep(16);
	}
}

typedef struct t_ScriptEntry {
	UINT64 DisplayName;				//0x0000
	char pad_0008[16];				//0x0008
	PVOID CodeFnc1;					//0x0018
	char pad_0020[16];				//0x0020
	PVOID CodeFnc2;					//0x0030
	char pad_0038[16];				//0x0038
	PVOID CodeFnc3;					//0x0048
	char pad_0050[8];				//0x0050
	UINT64 LoweredName;				//0x0058
	UINT64 Operation;				//0x0060
	UINT64 Description;				//0x0068
	UINT64 Example;					//0x0070
	char pad_0078[8];				//0x0078
	UINT64 VersionAdded;			//0x0080
	char pad_0088[8];				//0x0088
	UINT64 Category;				//0x0090
	char pad_0098[8];				//0x0098
};

int main() {
	if (!coms->SetupInterface("arma3_x64.exe")) {
		LogFailure("Failed to setup interface \n");
		return -1;
	}
	
	if (!SDK->InitSDK()) {
		LogFailure("Failed to setup SDK \n");
		return -2;
	}
	
	SDK->DebugInfo();
	
	if (!SDK->InitComps()) {
		LogFailure("Failed to setup Components \n");
		return -3;
	}

	if (!MenuWindow->StartWindow())
		LogFailure("Failed to create window\n");
	
	LogSuccess("Successfully setup window\n");
	
	//const auto ModuleBase = SDK->GetModuleBase();
	//const auto Offset = 0x25631F0i64;
	//const auto SQFSize = 100;
	//
	//for (int i = 0; i < 100; i++) {
	//	const auto ScriptEntry = ModuleBase + Offset + i * sizeof(t_ScriptEntry);
	//	
	//	Log("Script[%i] -> 0x%llx \n", i, ScriptEntry);
	//	Log("\t- %s \n", GArmaString(ScriptEntry).Get().c_str());
	//
	//	//Log("Script[%i]: %s \n", i, GArmaString(ScriptEntry).Get().c_str());
	//}

	// - Dumping GameValue Tyeps
	//const auto ModuleBase = SDK->GetModuleBase();
	//
	//int Offset = 0x232E538;
	//
	//for (int i = 0; i < 16; i++, Offset += 0x18) {
	//	const auto GameType = ModuleBase + Offset;
	//	const auto TypeName = GArmaString(coms->Read<UINT64>(GameType + 0x8)).Get();
	//
	//	Log("&off_0x%x: %s\n", Offset, TypeName.c_str());
	//}

	// - Dumping Unkn String List.
	//auto ListOfLists= GAutoArray(ModuleBase + 0x2340430);
	//for (auto i = 0; i < ListOfLists.GetSize(); i++) {
	//	auto ListOfStrings = GAutoArray(ListOfLists.GetAddr<UINT64>(i, 0x18));
	//
	//	for (auto j = 0; j < ListOfStrings.GetSize(); j++) {
	//		auto Text = GArmaString(ListOfStrings.GetAddr<UINT64>(i, 0x8)).Get();
	//
	//		if (Text.find("sqf") != std::string::npos)
	//			logger::WriteLogFile("stringdump", std::string(std::to_string(i) + std::to_string(j) + ".sqf").c_str(), Text.c_str());
	//			//Log("[%i][%i] -> %s \n", i, j, Text.c_str());
	//	}
	//}

	CreateThread(0, 0, (LPTHREAD_START_ROUTINE)UpdateThread, 0, 0, 0);
	
	MenuWindow->RenderLoop(); 

	

	// Create Window.

	//auto IsBurning		= SQFInterface->GetSQFScript(SQFScript::IsBurning);
	//auto IsAwake			= SQFInterface->GetSQFScript(SQFScript::IsAwake);
	//auto IsHidden			= SQFInterface->GetSQFScript(SQFScript::IsObjectHidden);
	//auto IsDamageAllowed	= SQFInterface->GetSQFScript(SQFScript::IsDamageAllowed);
	//
	//IsDamageAllowed->SwapBinaryOperator(IsAwake);
	//IsHidden->SwapBinaryOperator(IsBurning);
	//
	//while (!GetAsyncKeyState(VK_END)) {
	//	Sleep(250);
	//}
	//
	//
	//IsDamageAllowed->PlaceOriginal();
	//IsHidden->PlaceOriginal();
}

