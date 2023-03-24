#pragma once
#include "includes.h"

class PEHeader {
	UINT64 m_Base = 0;

public:
	// Getters
	IMAGE_DOS_HEADER GetDosHeader() { return coms->Read<IMAGE_DOS_HEADER>(m_Base); }
	IMAGE_NT_HEADERS GetNtHeader() { return coms->Read<IMAGE_NT_HEADERS>(m_Base + GetDosHeader().e_lfanew); }
	
	IMAGE_SECTION_HEADER GetSection(const char* Section) {
		const auto DosHeader = GetDosHeader();
		const auto NtHeader = GetNtHeader();

		for (auto i = 0; i < NtHeader.FileHeader.NumberOfSections; i++) {
			const auto SectionHeader = coms->Read<IMAGE_SECTION_HEADER>(m_Base + DosHeader.e_lfanew + sizeof(IMAGE_NT_HEADERS) + (i * sizeof(IMAGE_SECTION_HEADER)));
		
			if (!strcmp((char*)SectionHeader.Name, Section))
				return SectionHeader;
		}
	}

	std::vector<IMAGE_SECTION_HEADER> GetSections() {
		const auto DosHeader = GetDosHeader();
		const auto NtHeader = GetNtHeader();

		auto Buffer = std::vector<IMAGE_SECTION_HEADER>();

		for (auto i = 0; i < NtHeader.FileHeader.NumberOfSections; i++) {
			const auto SectionHeader = coms->Read<IMAGE_SECTION_HEADER>(m_Base + DosHeader.e_lfanew + sizeof(IMAGE_NT_HEADERS) + (i * sizeof(IMAGE_SECTION_HEADER)));
			Buffer.push_back(SectionHeader);
		}

		return Buffer;
	}

	PEHeader() {}
	PEHeader(UINT64 Base) : m_Base(Base) {};
	~PEHeader() {}
};