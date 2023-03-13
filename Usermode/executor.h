#pragma once
#include "rscdisplay.h"
#include <sstream>
#include <fstream>

#define TARGETDISPLAY "RscDisplayGameOptions"
#define TARGETFILE "scripts.txt"

class ExecutorComponent {
	bool m_ScriptInjected;

	bool PlaceScript(std::string Script);
public:
	bool IsScriptInjected();
	std::string GetScriptFromFile();

	bool PlaceScript();
	bool RemoveScript();
};

extern ExecutorComponent* Executor;
