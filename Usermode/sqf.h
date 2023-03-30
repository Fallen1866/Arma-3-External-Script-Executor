#pragma once
#include "includes.h"
#include "structs.h"
#include "tab.h"
#include "sdk.h"

enum class SQFScript {
	IsDamageAllowed,
	IsObjectHidden,
	IsBurning,
	IsAwake,
	CompileFinal,
	Compile,

	INVALID = -1,
};

// Todo: find dynamic way to get this shit.

static std::unordered_map<SQFScript, std::string> ScriptNames = {
	{SQFScript::IsDamageAllowed,	"IsDamageAllowed"},
	{SQFScript::IsObjectHidden,		"IsObjectHidden"},
	{SQFScript::IsBurning,			"IsBurning"},	
	{SQFScript::IsAwake,			"IsAwake"},	
	{SQFScript::CompileFinal,		"CompileFinal"},	
	{SQFScript::Compile,			"Compile"},	
};

static std::pair<SQFScript, UINT64> ScriptOffsets[] = {
	{SQFScript::IsDamageAllowed,	0x258B838},
	{SQFScript::IsObjectHidden,		0x256EED0},
	{SQFScript::IsBurning,			0x2586D68},	// should always be false
	{SQFScript::IsAwake,			0x2590500},	// should always be true.
	{SQFScript::CompileFinal,		0x26A19C0},
	{SQFScript::Compile,			0x26A1918},
	
};

class BinaryOperator {
	BinaryOperator* Swap = nullptr;
	UINT64 m_Base = 0;
	UINT64 m_Original = 0;
	
	//std::string RETTYPE = "INVALID";
	//std::string ARG1TYPE = "INVALID";
	//std::string ARG2TYPE = "INVALID";
	//std::string ARG3TYPE = "INVALID";

	//SQFScript m_Type = SQFScript::INVALID;

	void ChangeFunction(UINT64 Destination);

public:
	BinaryOperator* GetSwapped() const { return Swap; }
	bool IsSwapped() const { return Swap != nullptr; }

	UINT64 Get() const { return m_Base;}
	UINT64 GetOriginal() const { return m_Original; }
	
	void PlaceOriginal();
	void SwapBinaryOperator(BinaryOperator* Operator);
	UINT64 GetFunction();
	

	std::string GetReturnType();
	std::string GetArg1Type();
	std::string GetArg2Type();


	BinaryOperator() {}
	BinaryOperator(UINT64 Base) : m_Base(Base) { m_Original = GetFunction(); }
	~BinaryOperator() {}
};

class SQFManager : public MenuTab {
	std::unordered_map<SQFScript, BinaryOperator> m_BinaryOperators;
	std::unordered_map<BinaryOperator*, std::string> m_BinaryOperatorsName;

	BinaryOperator* Copied = nullptr;

	char InputSearchBuffer[256];

	void InitScripts();

public:
	void Init();
	
	std::vector<BinaryOperator*> GetSQFScripts();
	BinaryOperator* GetSQFScript(SQFScript Script);
	std::string GetScriptName(BinaryOperator* Binary);

	const char* GetTitle() override { return "SQF"; }
	void RenderMenu() override;

	SQFManager(int Index) : MenuTab(Index) {}
	~SQFManager() {}
};

extern SQFManager* SQFInterface;