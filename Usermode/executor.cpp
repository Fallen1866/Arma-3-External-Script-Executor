#include "executor.h"
#include "vardumper.h"
#include "sdk.h"
#include <commdlg.h> // For OPENFILENAME and GetOpenFileName

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

bool ExecutorComponent::CheckIfPayloadExecuted() {
	while (true) {
		if (!Executor->m_ScriptInjected)
			return true;
		
		// do shit.
		auto GameVariables = VariableManager->GetMissionVariables();
		
		for (auto& Variable : GameVariables) {
			auto VariableName = Variable.Name;

			if (!VariableName.compare("bred_inject")) {	// do shit with hashmap, way faster.
				
				if (VariableBool* BoolValue = (VariableBool*)(&Variable); BoolValue->GetValue()) {
					Executor->RemoveScript();
					BoolValue->SetValue(false);
					return true;
				}
			}
		}
		
		Sleep(1);
	}

	return true;
}

bool ExecutorComponent::SaveFile() {
	
	return true;
}

bool ExecutorComponent::PlaceScript() {
	return PlaceScript(GetScriptFromFile().c_str());
}

void ShowConsole(bool show)
{
	HWND consoleWindow = GetConsoleWindow();
	if (consoleWindow == NULL) return;

	if (show)
	{
		ShowWindow(consoleWindow, SW_SHOW);
	}
	else
	{
		ShowWindow(consoleWindow, SW_HIDE);
	}
}

void ExecutorComponent::RenderMenu() {
	ImGui::BeginChild("Auugh", ImGui::GetContentRegionAvail(), false);
	
	static std::string gamepath = "";

	static bool alreadyCheckedGamepath = false;

	if (!alreadyCheckedGamepath)
	{
		// Read the game path from the file, if it exists
		std::ifstream infile("a3_gamepath.txt");
		if (infile)
		{
			getline(infile, gamepath);
		}

		alreadyCheckedGamepath = true;
	}

	static bool consolestatus = true;

	if (ImGui::Button("Toggle Console"))
	{
		consolestatus = !consolestatus;
		ShowConsole(consolestatus);
	}

	if (gamepath.empty())
	{
		static char arma3_x64_path[256];

		ImGui::InputText("arma3_x64 file path", arma3_x64_path, 256);

		if (ImGui::Button("Set Path"))
		{
			if (!std::string(arma3_x64_path).empty())
			{
				gamepath = arma3_x64_path;

				std::ofstream f("a3_gamepath.txt");

				if (f.good()) {
					f << gamepath.data();
				}

				f.close();
			}
		}
	}
	else
	{
		if (m_ScriptInjected)
			ImGui::TextColored(ImColor(0, 255, 0), "Script Injected");
		else
			ImGui::TextColored(ImColor(255, 0, 0), "Script Not Injected");

		ImGui::SameLine();

		ImGui::Text("TargetDisplay: %s", TARGETDISPLAY);

		if (m_AutoUninject && GetAsyncKeyState(VK_HOME))
		{
			if (!m_ScriptInjected) {
				// haram double code >:(
				std::ofstream f(TARGETFILE);

				if (f.good()) {
					f << SQFCodeEditor.GetText();
				}

				f.close();

				// Add inbound rule
				std::string addRuleInCmd = "netsh advfirewall firewall add rule name=\"UCLagSwitch\" dir=in action=block program=\"" + gamepath + "\" enable=yes";
				system(addRuleInCmd.c_str());

				// Add outbound rule
				std::string addRuleOutCmd = "netsh advfirewall firewall add rule name=\"UCLagSwitch\" dir=out action=block program=\"" + gamepath + "\" enable=yes";
				system(addRuleOutCmd.c_str());

				// Play beep and print to console
				Beep(500, 100);
				std::cout << "Firewall rules added" << std::endl;

				Sleep(1500);

				PlaceScript();

				Sleep(300);

				mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
				Sleep(1);
				mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);

				Sleep(300);

				if (m_ScriptInjected)
				{
					RemoveScript();
				}

				Sleep(1500);

				// Delete rule
				std::string deleteRuleCmd = "netsh advfirewall firewall delete rule name=\"UCLagSwitch\" program=\"" + gamepath + "\"";
				system(deleteRuleCmd.c_str());

				// Play beep and print to console
				Beep(1000, 100);
				std::cout << "Firewall rules deleted" << std::endl;
			}
			else
				LogFailure("Tried to place script onto existing script \n");
		}

		if (ImGui::Button("Inject Script")) {
			if (!m_ScriptInjected) {
				// haram double code >:(
				std::ofstream f(TARGETFILE);

				if (f.good()) {
					f << SQFCodeEditor.GetText();
				}

				f.close();

				if (PlaceScript())
				{

				}
			}
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

		ImGui::Checkbox("Auto Uninject", &m_AutoUninject);

		ImGui::Separator();

		auto cpos = SQFCodeEditor.GetCursorPosition();

		ImGui::Text("%6d/%-6d %6d lines  | %s | %s | %s | %s", cpos.mLine + 1, cpos.mColumn + 1, SQFCodeEditor.GetTotalLines(),
			SQFCodeEditor.IsOverwrite() ? "Ovr" : "Ins",
			SQFCodeEditor.CanUndo() ? "*" : " ",
			SQFCodeEditor.GetLanguageDefinition().mName.c_str(), TARGETFILE);

		SQFCodeEditor.Render("SQF Editor", ImGui::GetContentRegionAvail(), false);
	}

	ImGui::EndChild();
}