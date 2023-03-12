#include "modules.h"

ModuleComponent* ModuleManager = new ModuleComponent();

bool ModuleComponent::Init() {
	


	return false;
}

Module ModuleComponent::GetModule(const char* ModuleName) {
	if (m_Modules.find(ModuleName) != m_Modules.end())
		return m_Modules[ModuleName];

	return {};
}