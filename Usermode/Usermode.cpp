#include "includes.h"
#include "sdk.h"
#include "executor.h"



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

	LogSuccess("Succesfully setup. \n");

	if (!SDK->InitComps())
		return -3;
	
	Executor->PlaceScript();

	while (!GetAsyncKeyState(VK_END))
		Sleep(250);

	Executor->RemoveScript();
}