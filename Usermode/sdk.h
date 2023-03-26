#pragma once
#include "includes.h"

class SDKComponent {
private:
	UINT64 m_Modbase = 0;
	UINT64 m_World = 0;
	UINT64 m_RscDisplayArray = 0;
	UINT64 m_Scheduler = 0;
	UINT64 m_CameraOn = 0;
	UINT64 m_MissionNamespace = 0;

public:
	UINT64 GetModuleBase()			const { return m_Modbase; }
	UINT64 GetWorldBase()			const { return m_World; }
	UINT64 GetRscDisplayEntry()		const { return m_RscDisplayArray; }
	UINT64 GetSchedulerEntry()		const { return m_Scheduler; }
	UINT64 GetCameraOn()			const { return m_CameraOn; }
	UINT64 GetMissionNamespace()	const { return m_MissionNamespace; }

	void DebugInfo();

	bool InitSDK();
	bool InitComps();
	bool InitMenus();

	~SDKComponent() {}
	SDKComponent() {}
};

extern SDKComponent* SDK;