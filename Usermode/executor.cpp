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

bool ExecutorComponent::PlaceScriptFromString(std::string Script) {
	auto* GameOptionDisplay = RscDisplayManager->GetDisplayFromName(TARGETDISPLAY);

	if (!GameOptionDisplay->PlacePayloadOnLoad(Script.c_str()))
	{
		return false;
	}

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

bool ExecutorComponent::PlaceScriptFromFile() {
	return PlaceScriptFromString(GetScriptFromFile().c_str());
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

		if (GetAsyncKeyState(VK_NUMLOCK) && !SQFCodeEditor.GetText().empty())
		{
			if (!m_ScriptInjected) 
			{
				// Add inbound rule
				std::string addRuleInCmd = "netsh advfirewall firewall add rule name=\"UCLagSwitch\" dir=in action=block program=\"" + gamepath + "\" enable=yes";
				system(addRuleInCmd.c_str());

				// Add outbound rule
				std::string addRuleOutCmd = "netsh advfirewall firewall add rule name=\"UCLagSwitch\" dir=out action=block program=\"" + gamepath + "\" enable=yes";
				system(addRuleOutCmd.c_str());

				// Play beep and print to console
				Beep(500, 100);
				std::cout << "Firewall rules added" << std::endl;

				if (m_AutoUninject)
				{
					Sleep(2500);

					PlaceScriptFromString(SQFCodeEditor.GetText());

					Sleep(1);

					mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
					Sleep(1);
					mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);

					Sleep(100);

					RemoveScript();

					Sleep(2500);
				}
				else
				{
					Sleep(5000);
				}

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

		ImGui::Checkbox("Inject On VK_NUMLOCK", &m_AutoUninject);

		ImGui::SameLine();

		static bool consolestatus = true;

		if (ImGui::Button("Toggle Console"))
		{
			consolestatus = !consolestatus;
			ShowConsole(consolestatus);
		}

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