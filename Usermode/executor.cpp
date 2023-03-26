#include "executor.h"

ExecutorComponent* Executor = new ExecutorComponent(0);

bool ExecutorComponent::IsScriptInjected() {
	return m_ScriptInjected;
}

std::string ExecutorComponent::GetScriptFromFile() {
	std::fstream f(TARGETFILE);
	std::stringstream buffer;
	buffer << f.rdbuf();
	return buffer.str();
}

bool ExecutorComponent::PlaceScript(std::string Script) {
	auto* GameOptionDisplay = RscDisplayManager->GetDisplayFromName(TARGETDISPLAY);

	if (!GameOptionDisplay->PlacePayloadOnLoad(Script.c_str()))
		return false;

	m_ScriptInjected = true;
	return true;
}

bool ExecutorComponent::RemoveScript() {
	bool Result = RscDisplayManager->GetDisplayFromName(TARGETDISPLAY)->RemovePayloadOnLoad();
	m_ScriptInjected = Result == true ? false : true;
	return Result;
}

bool ExecutorComponent::PlaceScript() {
	return PlaceScript(GetScriptFromFile().c_str());
}

void ExecutorComponent::RenderMenu() {
	ImGui::BeginChild("Auugh", ImGui::GetContentRegionAvail(), false);
	
	if (m_ScriptInjected)
		ImGui::TextColored(ImColor(0, 255, 0), "Script Injected");
	else
		ImGui::TextColored(ImColor(255, 0, 0), "Script Not Injected");

	ImGui::SameLine();

	ImGui::Text("TargetDisplay: %s", TARGETDISPLAY);

	if (ImGui::Button("Inject Script")) {
		if(!m_ScriptInjected)
			PlaceScript();
		else
			LogFailure("Tried to place script onto existing script \n");
	}
	
	ImGui::SameLine();

	if (ImGui::Button("Remove Script")) {
		if (m_ScriptInjected)
			RemoveScript();
		else
			LogFailure("Tried to remove non-existing script \n");
	}

	ImGui::SameLine();

	if (ImGui::Button("Save File")) {
		std::ofstream f(TARGETFILE);
		
		if (f.good()) {
			f << SQFCodeEditor.GetText();
		}
		
		f.close();
	}

	ImGui::Separator();

	auto cpos = SQFCodeEditor.GetCursorPosition();
	
	ImGui::Text("%6d/%-6d %6d lines  | %s | %s | %s | %s", cpos.mLine + 1, cpos.mColumn + 1, SQFCodeEditor.GetTotalLines(),
		SQFCodeEditor.IsOverwrite() ? "Ovr" : "Ins",
		SQFCodeEditor.CanUndo() ? "*" : " ",
		SQFCodeEditor.GetLanguageDefinition().mName.c_str(), TARGETFILE);
	
	SQFCodeEditor.Render("SQF Editor", ImGui::GetContentRegionAvail(), false);

	ImGui::EndChild();
}