#pragma once
#include "includes.h"
#include "window.h"

class MenuTab;

namespace TabManager {
	extern std::vector<MenuTab*>	m_Tabs;
	extern MenuTab*					m_Tab;

	MenuTab* GetTab(int index);
	void RegisterTab(MenuTab* Tab);
	void RenderTabsTitle();
	void RenderTabMenu();
}

class MenuTab {
private:
	int Index = 0;

public:
	int GetIndex() const { return Index; }
	
	virtual const char* GetTitle() { return "INV"; }
	virtual void RenderMenu() {}

	virtual void Update() {}
	virtual void Init() {
		TabManager::RegisterTab(this);
	}

	MenuTab(int index) : Index(index) {}
	~MenuTab() {}
};