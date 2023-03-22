#pragma once
#include "includes.h"
#include "scriptvm.h"
#include "structs.h"

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

class ScheduleComponent {
	UINT64 m_Base = 0;

public:
	void Update();

	std::vector<ScriptVM*> GetAllScripts();

	bool KillAllScripts();

	void Init(UINT64 Base) { m_Base = Base; }

	~ScheduleComponent() {}
	ScheduleComponent() {}
};

extern ScheduleComponent* ScheduleManager;