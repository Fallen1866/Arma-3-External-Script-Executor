#pragma once
#include "includes.h"
#include "mem.h"

class ModuleComponent;
class Module;
class Section;

class ModuleComponent {
	std::unordered_map<std::string, Module> m_Modules;

public:
	bool Init();


	Module GetModule(const char* ModuleName);
};

class Module {
	UINT64 m_Base = 0;


public:


};

class Section {
	UINT64 m_Base = 0;

public:



};


extern ModuleComponent* ModuleManager;
