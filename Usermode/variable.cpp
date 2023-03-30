#include "variable.h"

UINT64 GameValue::GetValueEntry() {
	return coms->Read<UINT64>((UINT64)m_Base + 0x18);
}

VariableType GameValue::GetVariableType() {
	const auto VariableValue	= GetValueEntry();
	const auto ValueVTable		= coms->Read<UINT64>(VariableValue + 0x0);

	std::string Check1 = coms->ReadString(ValueVTable + 0x0F8, 8);
	std::string Check2 = coms->ReadString(ValueVTable + 0x200, 8);
	std::string Check3 = coms->ReadString(ValueVTable + 0xB10, 8);
	std::string Check4 = coms->ReadString(ValueVTable + 0x100, 21);
	std::string Check5 = coms->ReadString(ValueVTable + 0x18C, 4);
	std::string Check6 = coms->ReadString(ValueVTable + 0x2F8, 6);

	if (Check1.find("float") != std::string::npos)
		return VariableType::SCALAR;

	if (Check1.find("array") != std::string::npos)
		return VariableType::ARRAY;

	if (Check1.find("object") != std::string::npos)
		return VariableType::OBJECT;

	if (Check6.find("Switch") != std::string::npos)
		return VariableType::STRING;

	if (Check2.find("invisibl") != std::string::npos)
		return VariableType::BOOL;

	if (Check3.find("Count co") != std::string::npos)
		return VariableType::CODE;

	if (Check4.find("SQFC file has 0 const") != std::string::npos)
		return VariableType::CODE;

	if (Check5.find("Mine") != std::string::npos)
		return VariableType::GROUP;

	return VariableType::end;
}

std::string GameValue::GetVariableName() {
	return GArmaString((UINT64)m_Base + 0x08).Get();
}


UINT64 GameValue::GetValuePtr() {
	return GetValueEntry();
}

void GameValue::SetValuePtr(UINT64 Value) {
	coms->Write<UINT64>((UINT64)m_Base + 0x18, Value);
}

// VARIABLE TYPES ---


std::vector<GameValue*> VariableArray::GetContents() {
	auto Elements = GAutoArray((UINT64)this + 0x18);
	auto Buffer = std::vector<GameValue*>();

	for (int i = 0; i < Elements.GetSize(); i++) {
		//Buffer.push_back(Elements.GetClass<UINT64>(i, 0x10));
	}

	return Buffer;
}

bool VariableBool::GetValue() {
	return coms->Read<bool>(GetValueEntry() + 0x18);
}

void VariableBool::SetValue(bool Value) {
	coms->Write<bool>(GetValueEntry() + 0x18, Value);
}

float VariableNumber::GetValue() {
	return coms->Read<float>(GetValueEntry() + 0x18);
}

void VariableNumber::SetValue(float Value) {
	coms->Write<float>(GetValueEntry() + 0x18, Value);
}

std::string VariableString::GetValue() {
	return GArmaString(GetValueEntry() + 0x18).Get();
}

void VariableString::SetValue(std::string Value) {
	
}

std::string VariableCode::GetValue() {
	return GArmaString(GetValueEntry() + 0x18).Get();
}