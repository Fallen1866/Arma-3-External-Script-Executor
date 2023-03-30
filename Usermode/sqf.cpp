#include "sqf.h"

SQFManager* SQFInterface = new SQFManager(5);

void SQFManager::InitScripts() {
	for (auto& ScriptOffset : ScriptOffsets) {
		m_BinaryOperators[ScriptOffset.first] = BinaryOperator(coms->Read<UINT64>(SDK->GetModuleBase() + ScriptOffset.second));
		m_BinaryOperatorsName[&m_BinaryOperators[ScriptOffset.first]] = ScriptNames[ScriptOffset.first];
	}
}

void SQFManager::Init() {
	InitScripts();

	MenuTab::Init();
}


std::vector<BinaryOperator*> SQFManager::GetSQFScripts() {
	auto BinOperators = std::vector<BinaryOperator*>();

	for (auto& Operators : m_BinaryOperators)
		BinOperators.push_back(&Operators.second);

	return BinOperators;
}

BinaryOperator* SQFManager::GetSQFScript(SQFScript Script) {
	if (m_BinaryOperators.find(Script) != m_BinaryOperators.end())
		return &m_BinaryOperators[Script];

	return nullptr;
}

std::string SQFManager::GetScriptName(BinaryOperator* Binary) {
	if (m_BinaryOperatorsName.find(Binary) != m_BinaryOperatorsName.end())
		return m_BinaryOperatorsName[Binary];
	return "INVALID";
}

void BinaryOperator::ChangeFunction(UINT64 Destination) {
	coms->Write<UINT64>(m_Base + 0x10, Destination);
}

void BinaryOperator::PlaceOriginal() {
	ChangeFunction(m_Original);
	Swap = nullptr;
}

void BinaryOperator::SwapBinaryOperator(BinaryOperator* Operator) {
	ChangeFunction(Operator->GetFunction());
	Swap = Operator;
}

UINT64 BinaryOperator::GetFunction() {
	return coms->Read<UINT64>(m_Base + 0x10);
}

std::string BinaryOperator::GetReturnType() {
	if (const auto ReturnTypeHeap = coms->Read<UINT64>(m_Base + 0x20))
		return GArmaString(ReturnTypeHeap + 0x0).Get();

	return "INVALID";
}

std::string BinaryOperator::GetArg1Type() {
	if (const auto ArgTypeHeap = coms->Read<UINT64>(m_Base + 0x38))
		return GArmaString(ArgTypeHeap + 0x0).Get();

	return "INVALID";
}


void SQFManager::RenderMenu() {
	static auto SQFBinaries = this->GetSQFScripts();
	static BinaryOperator* SelectedSQF = nullptr;

	ImGui::BeginListBox("##SQFFUNC", ImVec2(350, ImGui::GetContentRegionAvail().y - 40));

	for (auto Binary : SQFBinaries) {
		bool Selected = SelectedSQF == Binary;

		std::string FinalName = GetScriptName(Binary);

		if (FinalName.find(InputSearchBuffer) == std::string::npos)
			continue;

		if (ImGui::Selectable(FinalName.c_str(), &Selected)) {
			SelectedSQF = Binary;

			Log("Selected -> 0x%llx\n", Binary->Get());
		}

		if (Binary->IsSwapped()) {
			ImGui::SameLine();
			ImGui::TextColored(ImColor(0,255,0), " -> %s", GetScriptName(Binary->GetSwapped()).c_str());
		}

		if (Selected)
			ImGui::SetItemDefaultFocus();
	}

	ImGui::EndListBox();

	auto EndCursor = ImGui::GetCursorPos();
	if (SelectedSQF != nullptr) {
		ImGui::SameLine();

		ImGui::BeginChild("##RIGHTPANEL", ImGui::GetContentRegionAvail());

		if (ImGui::Button("Copy")) {
			Copied = SelectedSQF;
		}
	
		ImGui::SameLine();
	
		if (ImGui::Button("Place")) {
			if (SelectedSQF->IsSwapped())
				SelectedSQF->PlaceOriginal();

			SelectedSQF->SwapBinaryOperator(Copied);
			Copied = nullptr;
		}
	
		ImGui::SameLine();
	
		if (ImGui::Button("Recover")) {
			if (SelectedSQF->IsSwapped())
				SelectedSQF->PlaceOriginal();
		}
	
		if (Copied == nullptr)
			ImGui::TextColored(ImColor(255, 0, 0), "Copied : NONCOPIED");
		else
			ImGui::TextColored(ImColor(0, 255, 0), "Copied : %s", GetScriptName(Copied).c_str());
	
		ImGui::Text("If you have bison injected, \ndo not mess with:\n - IsDamageAllowed\n - IsObjectHidden");
		ImGui::NewLine();
		ImGui::Text("Return Type: %s \n", SelectedSQF->GetReturnType().c_str());
		ImGui::Text("Argument Type 1: %s \n", SelectedSQF->GetArg1Type().c_str());


		ImGui::EndChild();
	}

	ImGui::PushItemWidth(350);
	ImGui::SetCursorPos(EndCursor);
	ImGui::InputText("##SEARCH", InputSearchBuffer, 256);
}