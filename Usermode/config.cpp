#include "config.h"

ConfigComponent* ConfigManager = new ConfigComponent(1);

UINT64 ConfigComponent::GetNewDescriptionExt() {
	return coms->Read<UINT64>(m_Base + 0x100);
}

ParamClass ConfigComponent::GetMissionSQM() {
	//												doing it like this cause thats what arma dose
	//																	v		v
	ParamClass MissionSQM(coms->Read<UINT64>(GetNewDescriptionExt() + 0x18 + 0xF8));
	MissionSQM.ReadName();
	MissionSQM.ReadContents();

	return MissionSQM;
}

void ConfigComponent::Update() {

}

void ConfigComponent::RenderMenu() {
	if (ImGui::BeginChild("Config")) {
		if (ImGui::Button("Update")) {
			MissionSQM = GetMissionSQM();
		}

		if (ImGui::BeginListBox("##Config", ImVec2(ImGui::GetContentRegionAvail().x - 10, ImGui::GetContentRegionAvail().y - 10))) {
			MissionSQM.Render();

			ImGui::EndListBox();
		}

		ImGui::EndChild();
	}
}