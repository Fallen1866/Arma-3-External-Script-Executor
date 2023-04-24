#include "config.h"

ConfigComponent* ConfigManager = new ConfigComponent(1);

UINT64 ConfigComponent::GetNewDescriptionExt() {
	return coms->Read<UINT64>(m_Base + 0x100);
}

ParamClass ConfigComponent::GetMissionSQM() {
	// doing it like this cause thats what arma dose (will be easier to understand if anything breaks)
	//																	v		v
	ParamClass MissionSQM(coms->Read<UINT64>(GetNewDescriptionExt() + 0x18 + 0xF8));
	MissionSQM.ReadName();
	MissionSQM.ReadContents();

	return MissionSQM;
}

void ConfigComponent::Update() {

}

void ConfigComponent::RenderMenu() {
	if (ImGui::BeginChild("Config")) {
		if (ImGui::Button("Update")) {
			m_MissionSQM = GetMissionSQM();
		}

		if (ImGui::BeginListBox("##Config", ImVec2(ImGui::GetContentRegionAvail().x - 10, ImGui::GetContentRegionAvail().y - 10))) {
			m_MissionSQM.Render();
			ImGui::EndListBox();
		}

		ImGui::EndChild();
	}
}

UINT64 Param::GetBase() {
	return m_Base;
}

UINT64 Param::GetVTableType() {
	return m_VTableType;
}

void Param::ReadName() {
	m_Name = GArmaString(m_Base + 0x8).Get();
}

std::string* Param::GetName() {
	return &m_Name;
}

void Param::ReadType() {
	m_VTableType = coms->Read<UINT64>(m_Base) - SDK->GetModuleBase();
	if (m_VTableType == 0x1DC28D0) {
		m_Type = CLASS;
	}
	else {
		m_Type = VALUE;
	}
}

Param::Type Param::GetType() {
	return m_Type;
}

void ParamValue::ReadValue() {
	switch (m_VTableType)
	{
	case 0x1DC4A78:
		m_Value = std::to_string(coms->Read<UINT32>(m_Base + 0x10));
		break;
	case 0x1DC4528:
		m_Value += "\"" + GArmaString(m_Base + 0x10).Get() + "\"";
		break;
	case 0x1DC5108:
		m_Value = "ARRAY";	// todo read array (its an autoArray)
		break;
	case 0x1DC47D0:
		m_Value = std::to_string(coms->Read<float>(m_Base + 0x10));
		break;
	default:
		m_Value = "INVALID";
		break;
	}
}

void ParamValue::Render(int Depth) {
	if (!this->m_Name.size()) {
		return;
	}

	std::string indentation = "";
	for (int i = 0; i < Depth; ++i) {
		indentation += "\t";
	}

	ImGui::Text("%s%s = %s;", indentation.c_str(), this->m_Name.c_str(), this->m_Value.c_str());
}

void ParamClass::ReadContents() {
	GAutoArray ContentArray(m_Base + 0x48);
	if (ContentArray.InvalidList(10000)) {
		return;
	}

	for (int i = 0; i < ContentArray.GetSize(); ++i) {
		Param Value(ContentArray.Get<UINT64>(i));

		Value.ReadName();
		if (!Value.GetName()->size()) {
			continue;
		}

		Value.ReadType();
		if (Value.GetType() == CLASS) {
			ParamClass ParamClass(Value);
			ParamClass.ReadContents();

			m_ParamClasses.push_back(ParamClass);
		}
		else {
			ParamValue ParamValue(Value);
			ParamValue.ReadValue();

			m_ParamValues.push_back(ParamValue);
		}
	}
}

void ParamClass::Render(int Depth) {
	for (ParamValue& ParamValue : m_ParamValues) {
		ParamValue.Render(Depth);
	}

	for (ParamClass& ParamClass : m_ParamClasses) {
		std::string ContentName = *ParamClass.GetName();
		if (!ContentName.size()) {
			continue;
		}

		std::string Indentation = "";
		for (int i = 0; i < Depth; ++i) {
			Indentation += "\t";
		}

		ImGui::Text("%sclass %s", Indentation.c_str(), ContentName.c_str());

		if (ParamClass.m_ParamClasses.size() || ParamClass.m_ParamValues.size()) {
			ImGui::Text("%s{", Indentation.c_str());
		}

		ParamClass.Render(Depth + 1);

		if (ParamClass.m_ParamClasses.size() || ParamClass.m_ParamValues.size()) {
			ImGui::Text("%s};", Indentation.c_str());
		}
	}
}
