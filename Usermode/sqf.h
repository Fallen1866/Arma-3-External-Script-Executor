#pragma once
#include "includes.h"
#include "sdk.h"

enum class SQFScript {
	IsDamageAllowed,
	IsObjectHidden,
	IsBurning,
	IsAwake,
};

static std::pair<SQFScript, UINT64> ScriptOffsets[] = {
	{SQFScript::IsDamageAllowed,	0x258B838},
	{SQFScript::IsObjectHidden,		0x256EED0},
	{SQFScript::IsBurning,			0x2586D68},	// should always be false
	{SQFScript::IsAwake,			0x2590500}	// should always be true.
};

class BinaryOperator {
	UINT64 m_Base = 0;
	UINT64 m_Original = 0;

	void ChangeFunction(UINT64 Destination);

public:
	void PlaceOriginal();
	void SwapBinaryOperator(BinaryOperator* Operator);
	UINT64 GetFunction();

	UINT64 GetOriginal() const { return m_Original; }

	BinaryOperator() {}
	BinaryOperator(UINT64 Base) : m_Base(Base) { m_Original = GetFunction(); }
	~BinaryOperator() {}
};

class SQFManager {
	std::unordered_map<SQFScript, BinaryOperator> m_BinaryOperators;
	
	void InitScripts();

public:
	void Init();

	BinaryOperator* GetSQFScript(SQFScript Script);
	
};

extern SQFManager* SQFInterface;