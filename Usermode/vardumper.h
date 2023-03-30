#pragma once
#include "includes.h"
#include "variable.h"
#include "structs.h"
#include "tab.h"

class VariableDumper : public MenuTab {
	UINT64 m_MissionNamespace = 0;
	
	// MENU
	bool ExcludeBIS = true;
	char InputSearchBuffer[256] = {};
	TextEditor SQFCodeEditor;

	// Restoring.
	std::pair<std::string, UINT64> CopiedPtr = { "",0 };
	std::unordered_map<std::string, UINT64> RestorePtrs = {};

public:

	std::vector<GameValue> GetMissionVariables();
	std::vector<GameValue> GetObjectVariables(UINT64 Object);	// Do later.

	// we need ui variables too, cause some servers are cringe :o
	// pub-variables too, cause they also cringe.

	void Init(UINT64 Base) {
		m_MissionNamespace = Base;
		
		SQFCodeEditor.SetLanguageDefinition(TextEditor::LanguageDefinition::SQF());
		SQFCodeEditor.SetReadOnly(true);
		SQFCodeEditor.SetText("");

		MenuTab::Init();
	}

	const char* GetTitle() override { return "VAR"; }
	void RenderMenu() override;

	VariableDumper(int Index) : MenuTab(Index) {}
	~VariableDumper() {}
};

extern VariableDumper* VariableManager;