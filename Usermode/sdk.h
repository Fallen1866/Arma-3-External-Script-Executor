#pragma once
#include "includes.h"

class SDKComponent {
private:
	UINT64 m_Modbase = 0;
	UINT64 m_RscDisplayArray = 0;
	UINT64 m_World = 0;

public:
	UINT64 GetModuleBase() const { return m_Modbase; }
	UINT64 GetWorldBase() const { return m_World; }
	UINT64 GetRscDisplayEntry() const { return m_RscDisplayArray; }

	void DebugInfo();

	bool InitSDK();
	bool InitComps();

	~SDKComponent() {}
	SDKComponent() {}
};

extern SDKComponent* SDK;