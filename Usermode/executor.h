#pragma once
#include "rscdisplay.h"
#include "tab.h"
#include <sstream>
#include <fstream>

#define TARGETDISPLAY "RscDisplayGameOptions"
#define TARGETFILE "scripts.txt"

class ExecutorComponent : public MenuTab {
	bool m_ScriptInjected = false;
public:
	bool m_AutoUninject = false;
private:

	TextEditor SQFCodeEditor;
	bool SQFCodeEditorOpen;

	bool PlaceScript(std::string Script);
public:
	bool IsScriptInjected();
	std::string GetScriptFromFile();

	bool PlaceScript();
	bool RemoveScript();

private:

	static bool CheckIfPayloadExecuted();
	bool SaveFile();

public:
	const char* GetTitle() override { return "EXEC"; }
	void RenderMenu() override;

	void Init() override {
		// Load Current File
		std::ifstream t(TARGETFILE);
		
		if (t.good()) {
			std::string str((std::istreambuf_iterator<char>(t)), std::istreambuf_iterator<char>());
			SQFCodeEditor.SetText(str);
		}

		// Set Language for shit.
		SQFCodeEditor.SetLanguageDefinition(TextEditor::LanguageDefinition::SQF()); // <-- we made this augh.

		MenuTab::Init();
	}

	ExecutorComponent(int Index) : MenuTab(Index) {}
};

extern ExecutorComponent* Executor;
