#include "sdk.h"
#include "rscdisplay.h"

SDKComponent* SDK = new SDKComponent();

void SDKComponent::DebugInfo() {
	LogInfo("ModuleBase -> 0x%llx \n", SDK->GetModuleBase());
	LogInfo("RscDisplay -> 0x%llx \n", SDK->GetRscDisplayEntry());
}

bool SDKComponent::InitSDK() {
	m_Modbase			= coms->GetModuleBase("Arma3_x64.exe");			// Modulebase duh.
	m_World				= coms->Read<UINT64>(m_Modbase + 0x26733A0);	// WorldOffset
	m_RscDisplayArray	= coms->Read<UINT64>(m_Modbase + 0x233F468);	// RscDisplay.
	
	return m_Modbase;
}

bool SDKComponent::InitComps() {
	RscDisplayManager->Init(SDK->GetRscDisplayEntry());

	return true;
}