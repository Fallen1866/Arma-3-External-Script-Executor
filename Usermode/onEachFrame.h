#pragma once
#include "tab.h"
#include "vardumper.h"

class Frame : public MenuTab {
	UINT64 Base = 0;
	std::string CodeBuffer = "";
	TextEditor SQFCodeEditor;

	UINT64 GetFrameCodeData() { return coms->Read<UINT64>(Base); }

	UINT64 OriginalPtr = 0x0;

public:

	void UpdateOnEachFrame() {
		if (!GetFrameCodeData()) 
			return;

		VariableCode TempCode;
		TempCode.init(GetFrameCodeData());

		//Log("OnEachFrameEntry -> 0x%llx \n", GetFrameCodeData());

		auto StringEntry = GetFrameCodeData() + 0x18;
		//Log("StringEntry: 0x%llx \n", StringEntry);

		auto StringBuffer = GArmaString(StringEntry).Get();
		//Log("StringBuffer: %s \n", StringBuffer.c_str());

		CodeBuffer = StringBuffer;
	}

	void Init(UINT64 base) {
		Base = base;
		SQFCodeEditor.SetLanguageDefinition(TextEditor::LanguageDefinition::SQF());
		SQFCodeEditor.SetReadOnly(true);
		SQFCodeEditor.SetText(CodeBuffer.c_str());

		MenuTab::Init();
	}

	const char* GetTitle() override { return "FRM"; }
	void RenderMenu() override;

	Frame(int Index) : MenuTab(Index) {}
	~Frame() {}
};

extern Frame* OnEachFrame;