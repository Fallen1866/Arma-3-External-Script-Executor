#pragma once
#include "tab.h"
#include "sdk.h"

class ServerInfoComponent : public MenuTab {
public:
	
	const char* GetTitle() override { return "SVR"; }
	void RenderMenu() override;

	
	ServerInfoComponent(int Index) : MenuTab(Index) {}
	~ServerInfoComponent() {}
};

extern ServerInfoComponent* ServerInfo;