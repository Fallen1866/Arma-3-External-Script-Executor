#include "scheduler.h"

ScheduleComponent* ScheduleManager = new ScheduleComponent(1);

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


void ScheduleComponent::Update() {
	
}

void ScheduleComponent::RenderMenu() {
	if (ImGui::BeginChild("Scheduler")) {
		auto Scripts = GetAllScripts();
		static int ScriptIndex = 0;

		if (Scripts.size() == 0)
			ImGui::TextColored(ImColor(255, 0, 0), "Total $cripts: %i", Scripts.size());
		else
			ImGui::TextColored(ImColor(0, 255, 0), "Total $cripts: %i", Scripts.size());

		ImGui::SameLine();

		if (ImGui::Button("Toggle Script") && Scripts.size() != 0) {
			Scripts[ScriptIndex]->ToggleScript();
		}

		ImGui::SameLine();

		if (ImGui::Button("Dump to Log") && Scripts.size() != 0) {
			logger::WriteLogFile(std::string("SPECIFIC SCRIPTDUMP.sqf").c_str(), (Scripts[ScriptIndex]->GetScript().c_str()));
		}

		if(ImGui::BeginListBox("##SCRIPTS", ImVec2(100, ImGui::GetContentRegionAvail().y-10))) {
			for (int i = 0; i < Scripts.size(); i++) {
				bool Selected = ScriptIndex == i;
		
				if (ImGui::Selectable(std::to_string(i).c_str(), Selected)) {
					ScriptIndex = i;
					SQFCodeEditor.SetText(Scripts[ScriptIndex]->GetScript());
				}
				
				ImGui::SameLine();

				if(Scripts[i]->IsTerminated())
					ImGui::TextColored(ImColor(255, 0, 0), "STOPPED");
				else 
					ImGui::TextColored(ImColor(0, 255, 0), "RUNNING");


				if (Selected)
					ImGui::SetItemDefaultFocus();
			}
	
			ImGui::EndListBox();
		}

		ImGui::SameLine();

		//SQFCodeEditor.SetText("");
		//if (Scripts.size() == 0)
		//	SQFCodeEditor.SetText("");
		//else
		//	SQFCodeEditor.SetText(Scripts[ScriptIndex]->GetScript());

		SQFCodeEditor.Render("Script");




		ImGui::EndChild();
	}
}