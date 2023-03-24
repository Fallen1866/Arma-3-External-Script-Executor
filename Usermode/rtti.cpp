#include "rtti.h"

RTTITable* rtti::GetVTable(const char* ModuleName, const char* ClassName) {
	const auto ModuleBase = coms->GetModuleBase(ModuleName);

	if (!ModuleBase)
		return nullptr;

	std::string RealName = ".?AV" + std::string(ClassName) + "@@";

	// honestly, fuck man
	std::string RealNameMask;
	for (int i = 0; i < RealName.size(); i++) { RealNameMask += "?"; }

	const auto DataSection = PEHeader(ModuleBase).GetSection(".data");

	if (!DataSection.VirtualAddress)
		return nullptr;

	//UINT64 RTTIDescriptor = pattern::PatternScan(ModuleBase + DataSection.VirtualAddress, DataSection.SizeOfRawData, (BYTE*)RealName.c_str(), RealNameMask.c_str());




	// Do this shit laterz
	
	const auto RDataSection = PEHeader(ModuleBase).GetSection(".rdata");

	if (!RDataSection.VirtualAddress)
		return nullptr;




	return nullptr;
}