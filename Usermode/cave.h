#pragma once
#include "includes.h"
#include "pe.h"

struct CodeCaveInfo {
	UINT64 Start;
	UINT64 End;
	UINT32 Size;
	std::string Section;

	void DebugInfo() {
		Log("CodeCave - %s \n", Section.c_str());
		Log("\t-Start: 0x%llx \n", Start);
		Log("\t-End: 0x%llx \n", End);
		Log("\t-Size: 0x%llx \n", Size);
	}
};

class Cave {
public:
	std::vector<CodeCaveInfo> GetCodeCave(UINT64 ModuleBase, UINT32 MinSize = 0x10);
};

extern Cave* CaveManager;