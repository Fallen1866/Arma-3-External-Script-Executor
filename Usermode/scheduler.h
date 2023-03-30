#pragma once
#include "includes.h"
#include "scriptvm.h"
#include "structs.h"
#include "tab.h"

// - - - Code that is not scheduled.
// - Debug Console
// - Triggers
// - Waypoints(conditionand activation)
// - All pre - init code executions including functions with preInit attribute
// - FSM conditions
// - Event Handlers on units and in GUI
// - EachFrame code(Event Handler / Scripted EH / onEachFrame)
// - Object initialisation fields
// - Expressions of Eden Editor entity / mission attributes
// - Code execution with call from an unscheduled environment
// - Code executed with remoteExecCall
// - Code inside isNil
// - SQF code called from SQS code
// - Conversation Event Handler
// - Code inside collect3DENHistory

// - - - Code that is scheduled
// - Spawn
// - ExecVM

// Note: "While Do" loops is limited to 10.000 iterations.

// 0x000 Callstack			Pointer
// 0x488 Script				String
// 0x490 Script Parent		String
// 0x4E8 Namespace			Pointer

class ScheduleComponent : public MenuTab {
	UINT64 m_Base = 0;

	TextEditor SQFCodeEditor;

	bool DumpRunningScripts = true;

public:

	std::vector<ScriptVM*> GetAllScripts();

	bool KillAllScripts();

	void Update() override;
	void Init(UINT64 Base) { 
		m_Base = Base; 
		
		SQFCodeEditor.SetLanguageDefinition(TextEditor::LanguageDefinition::SQF());
		SQFCodeEditor.SetReadOnly(true);

		MenuTab::Init(); 
	}
	void RenderMenu() override;
	
	// SCHEDULE - SHDL
	const char* GetTitle() override { return "SCHL"; }

	

	~ScheduleComponent() {}
	ScheduleComponent(int Index) : MenuTab(Index) {}
};

extern ScheduleComponent* ScheduleManager;