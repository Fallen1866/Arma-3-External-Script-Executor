#include "includes.h"
#include "sdk.h"
#include "sqf.h"
#include "hook.h"
#include "executor.h"
#include "scheduler.h"
#include "eventhandler.h"

// To Do:
// - Auto SQF Functions
//		- Automaticaly get SQF Functions.
//		- Automaticaly get BinaryOperator for SQF Functions
//		- Sort SQF Functions with BinaryOperators.
//
//	- ImGui Debug Window
//		- Setup Window
//		- Setup ImGui :barf:
//		- Create the fucking menu thing.
//		- Kill myself :sunglasses:
// 

int main() {
	
	// Prologue.

	if (!coms->SetupInterface("arma3_x64.exe")) {
		LogFailure("Failed to setup interface \n");
		return -1;
	}
	
	if (!SDK->InitSDK()) {
		LogFailure("Failed to setup SDK \n");
		return -2;
	}
	
	SDK->DebugInfo();
	
	LogSuccess("Succesfully setup. \n");
	
	if (!SDK->InitComps()) {
		LogFailure("Failed to setup Components \n");
		return -3;
	}
	 
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