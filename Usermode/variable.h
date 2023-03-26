#pragma once
#include "includes.h"
#include "structs.h"

enum class VariableType : int {
    SCALAR,
    BOOL,
    ARRAY,
    STRING,
    NOTHING,
    ANY,
    NAMESPACE,
    NaN,
    CODE,
    OBJECT,
    SIDE,
    GROUP,
    TEXT,
    SCRIPT,
    TARGET,
    CONFIG,
    DISPLAY,
    CONTROL,
    NetObject,
    SUBGROUP,
    TEAM_MEMBER,
    HASHMAP,
    TASK,
    DIARY_RECORD,
    LOCATION,
    end
};

class GameValue {
protected:
    UINT64 GetValueEntry();

public:
	// Get shit
    VariableType GetVariableType();
	std::string GetVariableName();

    UINT64 GetValuePtr();
    void SetValuePtr(UINT64 Value);
};

class VariableArray : public GameValue {
public:
	std::vector<GameValue*> GetContents();

};

class VariableBool : public GameValue {
public:
	bool GetValue();
    void SetValue(bool Value);

};

class VariableNumber : public GameValue {
public:
    float GetValue();
    void SetValue(float Value);
};

class VariableString : public GameValue {
public:
    std::string GetValue();
    void SetValue(std::string Value);

};

class VariableCode : public GameValue {
public:
    std::string GetValue();

};

