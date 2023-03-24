#include "sqf.h"

SQFManager* SQFInterface = new SQFManager();

void SQFManager::InitScripts() {
	for (auto& ScriptOffset : ScriptOffsets)
		m_BinaryOperators[ScriptOffset.first] = BinaryOperator(coms->Read<UINT64>(SDK->GetModuleBase() + ScriptOffset.second));
}

void SQFManager::Init() {
	InitScripts();
}

BinaryOperator* SQFManager::GetSQFScript(SQFScript Script) {
	if (m_BinaryOperators.find(Script) != m_BinaryOperators.end())
		return &m_BinaryOperators[Script];

	return nullptr;
}

void BinaryOperator::ChangeFunction(UINT64 Destination) {
	coms->Write<UINT64>(m_Base + 0x10, Destination);
}

void BinaryOperator::PlaceOriginal() {
	ChangeFunction(m_Original);
}

void BinaryOperator::SwapBinaryOperator(BinaryOperator* Operator) {
	this->ChangeFunction(Operator->GetFunction());
}

UINT64 BinaryOperator::GetFunction() {
	return coms->Read<UINT64>(m_Base + 0x10);
}