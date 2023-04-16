#pragma once
#include "includes.h"
#include "structs.h"
#include "tab.h"
#include "sdk.h"

class Param {
protected:

	UINT64 m_Base = 0;
	UINT64 vTableType = 0;
	std::string name = "";

	enum Type {
		CLASS,
		VALUE
	}type;

public:

	Param() {}

	Param(UINT64 Base) {
		m_Base = Base;
	}

	UINT64 GetBase() {
		return m_Base;
	}

	UINT64 GetVTableType() {
		return vTableType;
	}

	void ReadName() {
		name = GArmaString(m_Base + 0x8).Get();
	}

	std::string* GetName() {
		return &name;
	}

	void ReadType() {
		vTableType = coms->Read<UINT64>(m_Base) - SDK->GetModuleBase();
		if (vTableType == 0x1DC28D0) {
			type = CLASS;
		}
		else
		{
			type = VALUE;
		}
	}

	Type GetType() {
		return type;
	}

	virtual void Render() {};
};

class ParamValue : public Param {
private:

	std::string value = "";

public:

	ParamValue(UINT64 Base) {
		m_Base = Base;
	}

	ParamValue(Param Param) {
		m_Base = Param.GetBase();
		name = *Param.GetName();
		type = Param.GetType();
		vTableType = Param.GetVTableType();
	}

	void ReadValue() {
		switch (vTableType)
		{
		case 0x1DC4A78:
			value = std::to_string(coms->Read<UINT32>(m_Base + 0x10));
			break;
		case 0x1DC4528:
			value += "\"" + GArmaString(m_Base + 0x10).Get() + "\"";
			break;
		case 0x1DC5108:
			value = "ARRAY";	// todo read array (its an autoArray)
			break;
		case 0x1DC47D0:
			value = std::to_string(coms->Read<float>(m_Base + 0x10));
			break;
		default:
			value = "INVALID";
			break;
		}		
	}

	void Render(int depth = 0) {
		if (!this->name.size()) {
			return;
		}

		std::string indentation = "";
		for (int i = 0; i < depth; ++i) {
			indentation += "\t";
		}

		ImGui::Text("%s%s = %s;", indentation, this->name.c_str(), this->value.c_str());
	}
};

class ParamClass : public Param {
private:

	std::vector<ParamClass>paramClasses;
	std::vector<ParamValue>paramValues;

public:
	ParamClass() {}

	ParamClass(UINT64 Base) {
		m_Base = Base;
	}

	ParamClass(Param Param) {
		m_Base = Param.GetBase();
		name = *Param.GetName();
		type = Param.GetType();
	}

	void ReadContents() {
		GAutoArray contentArray(m_Base + 0x48);
		if (contentArray.InvalidList(10000)) {
			return;
		}

		for (int i = 0; i < contentArray.GetSize(); ++i) {
			Param value(contentArray.Get<UINT64>(i));

			value.ReadName();
			if (!value.GetName()->size()) {
				continue;
			}

			value.ReadType();
			if (value.GetType() == CLASS) {
				ParamClass paramClass(value);
				paramClass.ReadContents();

				paramClasses.push_back(paramClass);
			}
			else {
				ParamValue paramValue(value);
				paramValue.ReadValue();

				paramValues.push_back(paramValue);
			}
		}
	}

	void Render(int depth = 0) {
		for (ParamValue& paramValue : paramValues) {
			paramValue.Render(depth);
		}

		for (ParamClass& paramClass : paramClasses) {
			std::string contentName = *paramClass.GetName();
			if (!contentName.size()) {
				continue;
			}

			std::string indentation = "";
			for (int i = 0; i < depth; ++i) {
				indentation += "\t";
			}

			std::string name = indentation + "class " + contentName;
			ImGui::Text(name.c_str());

			if (paramClass.paramClasses.size() || paramClass.paramValues.size()) {
				std::string openingBrace = indentation + "{";
				ImGui::Text(openingBrace.c_str());
			}

			paramClass.Render(depth + 1);

			if (paramClass.paramClasses.size() || paramClass.paramValues.size()) {
				std::string closingBrace = indentation + "};";
				ImGui::Text(closingBrace.c_str());
			}
		}
	}
};

class ConfigComponent : public MenuTab {
private:

	UINT64 m_Base = 0;
	ParamClass MissionSQM;

	UINT64		GetNewDescriptionExt();
	ParamClass	GetMissionSQM();

public:

	void Update() override;
	void Init(UINT64 Base) {
		m_Base = Base;

		MenuTab::Init();
	}
	void RenderMenu() override;

	// CONFIG - CFG
	const char* GetTitle() override { return "CFG"; }

	~ConfigComponent() {}
	ConfigComponent(int Index) : MenuTab(Index) {}
};

extern ConfigComponent* ConfigManager;