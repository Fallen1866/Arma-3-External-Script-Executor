#pragma once
#include "includes.h"
#include "structs.h"
#include "tab.h"
#include "sdk.h"

class Param {
protected:

	UINT64		m_Base			= 0;
	UINT64		m_VTableType	= 0;
	std::string m_Name			= "";

	enum Type {
		CLASS,
		VALUE
	}m_Type;

public:

	Param() {}

	Param(UINT64 Base) {
		m_Base = Base;
	}

	UINT64			GetBase();
	std::string*	GetName();
	Type			GetType();

	UINT64			GetVTableType();
	void			ReadName();
	void			ReadType();

	virtual void	Render() {};
};

class ParamValue : public Param {
private:

	std::string m_Value = "";

public:

	ParamValue(UINT64 Base) {
		m_Base			= Base;
	}

	ParamValue(Param Param) {
		m_Base			= Param.GetBase();
		m_Name			=*Param.GetName();
		m_Type			= Param.GetType();
		m_VTableType	= Param.GetVTableType();
	}

	void ReadValue();
	void Render(int depth = 0);
};

class ParamClass : public Param {
private:

	std::vector<ParamClass>m_ParamClasses;
	std::vector<ParamValue>m_ParamValues;

public:
	ParamClass() {}

	ParamClass(UINT64 Base) {
		m_Base	= Base;
	}

	ParamClass(Param Param) {
		m_Base	= Param.GetBase();
		m_Name	=*Param.GetName();
		m_Type	= Param.GetType();
	}

	void ReadContents();
	void Render(int depth = 0);
};

class ConfigComponent : public MenuTab {
private:

	UINT64		m_Base = 0;
	ParamClass	m_MissionSQM;

	UINT64		GetNewDescriptionExt();
	ParamClass	GetMissionSQM();

public:

	void Update() override;
	void Init(UINT64 Base) {
		m_Base = Base;

		//
		// we could put GetMissionSQM() here
		// 

		MenuTab::Init();
	}
	void RenderMenu() override;

	// CONFIG - CFG
	const char* GetTitle() override { return "CFG"; }

	~ConfigComponent() {}
	ConfigComponent(int Index) : MenuTab(Index) {}
};

extern ConfigComponent* ConfigManager;