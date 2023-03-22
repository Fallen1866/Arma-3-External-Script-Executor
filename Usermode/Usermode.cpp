#include "includes.h"
#include "sdk.h"
#include "executor.h"
#include "scheduler.h"


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
	
	if (!SDK->InitComps()) {
		LogFailure("Failed to setup Components \n");
		return -3;
	}
	
	auto Scripts = ScheduleManager->GetAllScripts();
	
	//for (int i = 0; i < Scripts.size(); i++)
	//	logger::WriteLogFile(std::string(std::to_string(i) + ".txt").c_str(), Scripts[i]->GetScript().c_str());

	if (Executor->PlaceScript())
		LogSuccess("Placed Script \n");
	
	while (!GetAsyncKeyState(VK_END)) {
		Sleep(100);
	}
	
	if (Executor->RemoveScript())
		LogSuccess("Successfully cleaned up \n");

	getchar();

	//if (ScheduleManager->KillAllScripts())
	//	LogSuccess("Killed all scripts \n");
	//else
	//	LogFailure("Failed to kill all scripts \n");

	/*
	if (Executor->PlaceScript()) {
		LogSuccess("Sucessfully Placed Script \n");
	
		while (!GetAsyncKeyState(VK_END))
			Sleep(250);
	
		if (Executor->RemoveScript())
			LogSuccess("Sucessfully Removed Script \n");
	}
	else
		LogFailure("Failure Placing Script \n");
	*/
}