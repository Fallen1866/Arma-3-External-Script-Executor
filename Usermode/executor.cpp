#include "executor.h"

ExecutorComponent* Executor = new ExecutorComponent();

bool ExecutorComponent::IsScriptInjected() {
	return m_ScriptInjected;
}

std::string ExecutorComponent::GetScriptFromFile() {
	std::fstream f(TARGETFILE);
	std::stringstream buffer;
	buffer << f.rdbuf();
	return buffer.str();
}

bool ExecutorComponent::PlaceScript(std::string Script) {
	auto* GameOptionDisplay = RscDisplayManager->GetDisplayFromName(TARGETDISPLAY);

	if (!GameOptionDisplay->PlacePayloadOnLoad(Script.c_str()))
		return false;

	m_ScriptInjected = true;
	return true;
}

bool ExecutorComponent::RemoveScript() {
	return RscDisplayManager->GetDisplayFromName(TARGETDISPLAY)->RemovePayloadOnLoad();
}

bool ExecutorComponent::PlaceScript() {
	return PlaceScript(GetScriptFromFile().c_str());
}
