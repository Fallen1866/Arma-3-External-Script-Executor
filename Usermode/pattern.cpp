#include "pattern.h"

bool pattern::DataCompare(BYTE* Data, BYTE* Pattern, const char* Mask) {
	for (; *Pattern; ++Mask, ++Data, ++Pattern)
		if (*Mask == 'x' && *Data != *Pattern)
			return false;

	return (*Mask == NULL);
}

UINT64 pattern::PatternScan(UINT64 Start, UINT64 Size, BYTE* Pattern, const char* Mask) {
	UINT64 Buffer = 0;

	
	BYTE* ModuleDump = new BYTE[Size];
	Log("Allocated Memory: 0x%p \n\t-Size: 0x%llx \n", ModuleDump, Size);

	coms->ReadBuffer(Start, Size, ModuleDump);

	for (int i = 0; i < (int)Size; i++) 
		if (DataCompare((BYTE*)(ModuleDump + i), Pattern, Mask))
			Buffer = Start + i;
	

	delete[] ModuleDump;
	return Buffer;
}


