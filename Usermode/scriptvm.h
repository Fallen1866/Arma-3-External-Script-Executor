#pragma once
#include "includes.h"
#include "structs.h"

class ScriptVM {
public:
	bool ToggleScript();// return current state

	bool TerminateScript();
	bool IsTerminated();


	std::string GetParentScript();
	std::string GetScript();

	UINT64 GetNamespace();	// Replace this with shit

};