#pragma once
#include "includes.h"

enum class VariableType : int {	// https://community.bistudio.com/wiki/Category:Data_Types
	// Augh
	Array,
	Boolean,
	Group,
	Number,
	Object,
	Side,
	String,
	Code,
	Config,
	Control,
	Display,
	Location,
	ScriptHandle,
	StructuredText,
	DiaryRecord,
	Task,
	TeamMember,
	Namespace,
	Invalid = -1
};

class Variable {
public:
	// Get shit
	virtual void CacheVariableName()  = 0;
	virtual void CacheVariableValue() = 0;
};
