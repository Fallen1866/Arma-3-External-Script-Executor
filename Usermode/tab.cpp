#include "tab.h"

std::vector<MenuTab*>	TabManager::m_Tabs = {};
MenuTab*				TabManager::m_Tab = nullptr;

void TabManager::RegisterTab(MenuTab* Tab) {
	if(Tab)
		m_Tabs.push_back(Tab);
}

MenuTab* TabManager::GetTab(int index) {
	if (m_Tabs.size() < index)
		return nullptr;

	return m_Tabs[index];
}


void TabManager::RenderTabsTitle() {
	ImGui::SetCursorPosX(ImGui::GetCursorPosX() + 20);
	ImGui::SetCursorPosY(ImGui::GetCursorPosY() + 30);

	for (auto Tab : m_Tabs) {
		if (ImGui::Button(Tab->GetTitle(), ImVec2(61, 35)))
			m_Tab = Tab;

		ImGui::SetCursorPosX(ImGui::GetCursorPosX() + 20);
		ImGui::SetCursorPosY(ImGui::GetCursorPosY() + 10);
	}
}

void TabManager::RenderTabMenu() {
	if (!m_Tab)
		return;

	ImGui::SetCursorPosX(ImGui::GetWindowPos().x + 113);
	ImGui::SetCursorPosY(ImGui::GetWindowPos().y + 53);
	ImGui::BeginChild(m_Tab->GetTitle(), ImVec2(ImGui::GetContentRegionAvail()));
	m_Tab->RenderMenu();
	ImGui::EndChild();
}