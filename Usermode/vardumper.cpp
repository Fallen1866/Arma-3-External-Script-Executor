#include "vardumper.h"

VariableDumper* VariableManager = new VariableDumper(2);


std::vector<GameValue> VariableDumper::GetMissionVariables() {
	auto Buffer = std::vector<GameValue>();

	auto CurrentNamespace = GAutoArray(m_MissionNamespace + 0x20);

	//Log("CurrentNamespace Size: %i \n", CurrentNamespace.GetSize());

	for (auto i = 0; i < CurrentNamespace.GetSize(); i++) {
		auto NamespaceEntry = GAutoArray(CurrentNamespace.GetAddr<UINT64>(i, 0x18));

		for (auto j = 0; j < NamespaceEntry.GetSize(); j++) {
			auto ValueEntry = NamespaceEntry.GetAddr<UINT64>(j, 0x28);
			
			auto Value = GameValue();
			Value.init(ValueEntry);

			if (ExcludeBIS && Value.GetVariableName().find("bis") != std::string::npos)
				continue;

			if (ExcludeBIS && Value.GetVariableName().find("bin") != std::string::npos)
				continue;

			Buffer.push_back(Value);
		}
	}

	return Buffer;
}


void VariableDumper::RenderMenu() {
	static auto Variables = std::vector<GameValue>(); //GetMissionVariables();
	static int VariableTarget = 0;

	if (Variables.size() == 0)
		ImGui::TextColored(ImColor(255, 0, 0), "Variables: %i", Variables.size());
	else
		ImGui::TextColored(ImColor(0, 255, 0), "Variables: %i", Variables.size());
	
	auto Prev = ImGui::GetCursorPos();

	ImGui::SameLine();

	ImGui::SetCursorPosX(ImGui::GetContentRegionAvail().x - 100);

	if (ImGui::Button("Dump Variables")) {
		Variables = GetMissionVariables();
	}

	ImGui::SameLine();

	if (ImGui::Button("Dump Functions")) {
		for (auto& GameValue : Variables) {
			if (GameValue.Type != VariableType::CODE)
				continue;

			auto Variable = (VariableCode*)&GameValue;
			logger::WriteLogFile("DumpedFunctions", (Variable->GetVariableName() + ".sqf").c_str(), Variable->GetValue().c_str());
		}
	}

	ImGui::SetCursorPos(Prev);

	if (ImGui::BeginListBox("##VARIABLES", ImVec2(350, ImGui::GetContentRegionAvail().y - 40))) {

		for (int i = 0; i < Variables.size(); i++) {
			bool Selected = VariableTarget == i;
			
			if (Variables[i].Name.find(InputSearchBuffer) == std::string::npos)
				continue;

			if (ImGui::Selectable(std::to_string(i).c_str(), Selected)) {
				VariableTarget = i;

				if (Variables[VariableTarget].Type == VariableType::CODE) {
					auto Variable = (VariableCode*)&Variables[VariableTarget];
					SQFCodeEditor.SetText(Variable->GetValue());
				}
			}

			ImGui::SameLine();

			switch (Variables[i].Type)
			{
			case VariableType::SCALAR:	{ ImGui::TextColored(ImColor(000, 255, 000),	"%s - Number",		Variables[i].Name.c_str());	} break;
			case VariableType::ARRAY:	{ ImGui::TextColored(ImColor(000, 255, 255),	"%s - Array",		Variables[i].Name.c_str());	} break;
			case VariableType::STRING:	{ ImGui::TextColored(ImColor(128, 255, 128),	"%s - String",		Variables[i].Name.c_str());	} break;
			case VariableType::CODE:	{ ImGui::TextColored(ImColor(255, 255, 000),	"%s - Code",		Variables[i].Name.c_str());	} break;
			case VariableType::BOOL:	{ ImGui::TextColored(ImColor(255, 255, 255),	"%s - Bool",		Variables[i].Name.c_str());	} break;
			case VariableType::GROUP:	{ ImGui::TextColored(ImColor(255, 000, 255),	"%s - Group",		Variables[i].Name.c_str());	} break;
			case VariableType::OBJECT:	{ ImGui::TextColored(ImColor(255, 000, 255),	"%s - Object",		Variables[i].Name.c_str());	} break;
			default:					{ ImGui::TextColored(ImColor(255, 000, 000),	"%s - Unkn",		Variables[i].Name.c_str());	} break;
			}


			// Check if Array
			// If Array print childs
			// Loop until we unnest the entire fucking array. -> I dont care about it really

			if (Selected)
				ImGui::SetItemDefaultFocus();
		}

		ImGui::EndListBox();

		if (Variables.size() == 0)
			return;

		auto EndCursor = ImGui::GetCursorPos();

		// Weird formatting here wtf.
		ImGui::SameLine();
		auto CursorPos = ImGui::GetCursorPos();
		ImGui::NewLine();
		ImGui::SetCursorPos(CursorPos);
		ImGui::Checkbox("Exclude BIS", &ExcludeBIS);
		
		ImGui::SetCursorPosX(CursorPos.x);
		//ImGui::Checkbox("Exclude BIN", &ExcludeBIN);
		
		switch (Variables[VariableTarget].Type) {
		case VariableType::SCALAR:	{
			auto Variable = (VariableNumber*)&Variables[VariableTarget];
			float Value = Variable->GetValue();
			ImGui::PushItemWidth(ImGui::GetContentRegionAvail().x-10);
			if (ImGui::InputFloat("##VALUE", &Value, 0.5f, 1.0f, "%.3f"))
				Variable->SetValue(Value);
		}break;
		case VariableType::BOOL:	{
			auto Variable = (VariableBool*)&Variables[VariableTarget];
			bool Value = Variable->GetValue();

			if (ImGui::Checkbox("Value", &Value))
				Variable->SetValue(Value);
		}break;
		case VariableType::STRING:	{
			auto Variable = (VariableString*)&Variables[VariableTarget];
			std::string Value = Variable->GetValue();

			
			//ImGui::PushTextWrapPos(ImGui::GetContentRegionAvail().x - 10);
			ImGui::PushItemWidth(ImGui::GetContentRegionAvail().x - 10);
			ImGui::TextWrapped(Value.c_str());


		}break;
		case VariableType::CODE:	{
			auto Variable = (VariableCode*)&Variables[VariableTarget];
			
			if(CopiedPtr.second != 0)
				ImGui::TextColored(ImColor(0,255,0), "Copy: %s \n", CopiedPtr.first.c_str());
			else 
				ImGui::TextColored(ImColor(255,0,0),"Copy: NOTCOPIED \n");
			
			ImGui::SetCursorPosX(CursorPos.x);
			
			if (RestorePtrs.size() != 0) {
				std::string Buffer;
			
			
				int i = 0;
				for (auto& RestorePtr : RestorePtrs) {
					Buffer += RestorePtr.first;
					
					if (i != RestorePtrs.size()-1)
						Buffer += " - ";
					
					i++;
				}
			
				ImGui::TextColored(ImColor(0, 255, 0), "Restore: %s \n", Buffer.c_str());
			}
			else {
				ImGui::TextColored(ImColor(255, 0, 0), "Restore: NONCOPIED \n");
			}
			
			ImGui::SetCursorPosX(CursorPos.x);
			
			if (ImGui::Button("Copy Ptr")) {
				CopiedPtr.first = Variable->GetVariableName();
				CopiedPtr.second = Variable->GetValuePtr();
			}
			
			ImGui::SameLine();
			
			if (ImGui::Button("Place Ptr")) {
				RestorePtrs[Variable->Name] = Variable->GetValuePtr();
				Variable->SetValuePtr(CopiedPtr.second);
				SQFCodeEditor.SetText(Variable->GetValue());
			}
			
			ImGui::SameLine();
			
			if (ImGui::Button("Restore Ptr")) {
				if (RestorePtrs.find(Variable->Name) != RestorePtrs.end()) {
					Variable->SetValuePtr(RestorePtrs[Variable->Name]);
					RestorePtrs.erase(Variable->Name);
					SQFCodeEditor.SetText(Variable->GetValue());
				}
				else {
					LogFailure("Tried restoring on wrong variable");
				}
			}
			
			ImGui::SetCursorPosX(CursorPos.x);

			SQFCodeEditor.Render("Editor", ImVec2(ImGui::GetContentRegionAvail().x -10, ImGui::GetContentRegionAvail().y-10));

		}break;
		case VariableType::ARRAY:	{
			
		}break;
		}

		ImGui::PushItemWidth(350);
		ImGui::SetCursorPos(EndCursor);
		ImGui::InputText("##SEARCH", InputSearchBuffer, 256);
	}
}