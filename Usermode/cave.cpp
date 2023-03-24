#include "cave.h"

Cave* CaveManager = new Cave();

std::vector<CodeCaveInfo> Cave::GetCodeCave(UINT64 ModuleBase, UINT32 MinSize) {
	auto Buffer = std::vector<CodeCaveInfo>();

	PEHeader ArmaPE = PEHeader(ModuleBase);
	const auto Sections = ArmaPE.GetSections();

	for (auto& Section : Sections) {
		//Log("Section: %s \n", (char*)Section.Name);
		//Log("\t-Start:\t0x%llx \n", Section.VirtualAddress);
		//Log("\t-End:  \t0x%llx \n", Section.VirtualAddress + Section.SizeOfRawData);
		//Log("\t-Size: \t0x%llx \n", Section.SizeOfRawData);

		UINT32 Counter = 0;

		BYTE* SectionData = new BYTE[Section.SizeOfRawData];
		coms->ReadBuffer(ModuleBase + Section.VirtualAddress, Section.SizeOfRawData, SectionData);

		for (int i = 0; i < Section.SizeOfRawData; i++) {
			const auto Address = ModuleBase + Section.VirtualAddress + i;

			if (SectionData[i] == 0xCC) {
				Counter++;
			}
			else {
				if (Counter >= MinSize) {
					Buffer.push_back({ Address - Counter, Address - 1, Counter, std::string((char*)Section.Name) });
				}

				Counter = 0;
			}
		}

		delete[] SectionData;
	}

	return Buffer;
}