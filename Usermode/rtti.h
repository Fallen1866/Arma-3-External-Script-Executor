#pragma once
#include "includes.h"
#include "pattern.h"
#include "pe.h"

class RTTITable {
public:
	void* GetFunction(int index) { return nullptr; }	// do this shit.

};

namespace rtti {
	RTTITable* GetVTable(const char* ModuleName, const char* ClassName);



}