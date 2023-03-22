#include "scheduler.h"

ScheduleComponent* ScheduleManager = new ScheduleComponent();

void ScheduleComponent::Update() {
	printf("update ran \n");
}

auto ScheduleComponent::GetAllScripts() -> std::vector<ScriptVM*> {
	auto ScriptList = GAutoArray(m_Base);

	if (ScriptList.InvalidList())
		return {};

	auto Buffer = std::vector<ScriptVM*>();

	for (auto i = 0; i < ScriptList.GetSize(); i++)
		Buffer.push_back(ScriptList.Get<ScriptVM*>(i, 0x10));

	return Buffer;
}

bool ScheduleComponent::KillAllScripts() {
	auto ScriptList = GAutoArray(m_Base);

	if (ScriptList.InvalidList())
		return false;

	for (auto i = 0; i < ScriptList.GetSize(); i++)
		if (!ScriptList.Get<ScriptVM*>(i, 0x10)->TerminateScript())
			return false;

	return true;
}