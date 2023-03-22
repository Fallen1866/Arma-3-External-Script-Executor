#include "scriptvm.h"

bool ScriptVM::TerminateScript() {
	coms->Write<UINT8>((UINT64)(this) + 0x508, 0x00);
	return IsTerminated();
}

bool ScriptVM::IsTerminated() {
	return !coms->Read<bool>((UINT64)this + 0x508);
}

std::string ScriptVM::GetParentScript() {
	return GArmaString((UINT64)this + 0x490).Get();
}

std::string ScriptVM::GetScript() {
	return GArmaString((UINT64)this + 0x488).Get();
}

UINT64 ScriptVM::GetNamespace() {

	return 0;
}