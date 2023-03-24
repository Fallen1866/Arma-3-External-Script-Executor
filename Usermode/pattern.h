#pragma once
#include "includes.h"

namespace pattern {
	bool DataCompare(BYTE* Data, BYTE* Pattern, const char* Mask);
	UINT64 PatternScan(UINT64 Start, UINT64 Size, BYTE* Pattern, const char* Mask);
	
	// Find xRefs -> DataType
	// 

}