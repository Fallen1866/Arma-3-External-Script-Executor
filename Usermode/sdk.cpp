#include "sdk.h"
#include "rscdisplay.h"
#include "scheduler.h"
#include "sqf.h"

SDKComponent* SDK = new SDKComponent();

void SDKComponent::DebugInfo() {
	LogInfo("ModuleBase \t-> 0x%llx \n", SDK->GetModuleBase());
	LogInfo("WorldBase  \t-> 0x%llx \n", SDK->GetWorldBase());
	LogInfo("RscDisplay \t-> 0x%llx \n", SDK->GetRscDisplayEntry());
	LogInfo("Scheduler  \t-> 0x%llx \n", SDK->GetSchedulerEntry());
	LogInfo("CameraOn	\t-> 0x%llx \n", SDK->GetCameraOn());
}

bool SDKComponent::InitSDK() {
	m_Modbase			= coms->GetModuleBase("Arma3_x64.exe");			// Modulebase duh.
	m_World				= coms->Read<UINT64>(m_Modbase + 0x26733A0);	// WorldOffset
	m_RscDisplayArray	= coms->Read<UINT64>(m_Modbase + 0x233F468);	// RscDisplay.
	m_Scheduler			= m_World + 0x1858;
	m_CameraOn			= coms->Read<UINT64>(coms->Read<UINT64>(m_World + 0x2B00) + 0x8);

	return m_Modbase;
} 

bool SDKComponent::InitComps() {
	RscDisplayManager->Init(SDK->GetRscDisplayEntry());
	ScheduleManager->Init(SDK->GetSchedulerEntry());
	SQFInterface->Init();

	return true;
}