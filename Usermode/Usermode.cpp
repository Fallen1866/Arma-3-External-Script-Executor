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
// - Auto SQF Functions
//		- Automaticaly get SQF Functions.
//		- Automaticaly get BinaryOperator for SQF Functions
//		- Sort SQF Functions with BinaryOperators.
//
//	- Variable Editor / Dumper
//		- Get All Variables
//			- Mission Namespace
//			- Object Namespace -> Needs Select Player / Object | Do CursorTarget / LocalPlayer for now
//		- Filter Variables by Type
//		- Display Variables in Tree
//
//	- Do Shitenz
//		- Do more Shitenz

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
	
	// Setup Menu Shit

	//auto Variables = VariableManager->GetMissionVariables();
	//
	//for (auto Variable : Variables) {
	//	Log("Var: %i \n", Variable->GetVariableType());
	//}

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