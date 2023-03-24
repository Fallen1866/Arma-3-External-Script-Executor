#include "includes.h"
#include "sdk.h"
#include "hook.h"
#include "executor.h"
#include "scheduler.h"
#include "eventhandler.h"

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

	
	UINT64 BinaryOperator = coms->Read<UINT64>(SDK->GetModuleBase() + 0x2565150);

	const auto AllocatedMemory = coms->AllocateMemory(0x100);
	
	

	//Log("Allocated Memory -> 0x%llx \n", AllocatedMemory);
	//
	//coms->Write<UINT64>(AllocatedMemory, 0xFFDEADFFDEADFF);
}

