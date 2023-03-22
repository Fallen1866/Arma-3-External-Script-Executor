#include "rscdisplay.h"

DisplayManager* RscDisplayManager = new DisplayManager();


void DisplayManager::InitRscDispalys() {
	constexpr int RscDisplayLength = 1357;
	
	for (auto i = 0; i < RscDisplayLength; i++) {
		const auto RscDisplayEntry = coms->Read<UINT64>(m_Base + (0x8 * i));

		RscDisplay Display;
		Display.Init(RscDisplayEntry);

		if (Display.GetDisplayName().find("Display") == std::string::npos)
			continue;
		
		m_Displays[Display.GetDisplayName()] = Display;
	}
}

void DisplayManager::Init(UINT64 Base) {
	m_Base = Base;

	InitRscDispalys();

}

void DisplayManager::DebugAllDisplays() {
	auto DisplayNames = GetAllDisplayNames();

	for (auto& DisplayName : DisplayNames)
		Log("Display: %s \n", DisplayName.c_str());
}

std::vector<std::string> DisplayManager::GetAllDisplayNames() {
	auto buffer = std::vector<std::string>();
	
	for (auto& DisplayEntry : m_Displays) {
		buffer.push_back(DisplayEntry.first);
	}

	return buffer;
}

std::vector<RscDisplay*> DisplayManager::GetAllDisplays() {
	auto buffer = std::vector<RscDisplay*>();

	for (auto& DisplayEntry : m_Displays) {
		buffer.push_back(&DisplayEntry.second);
	}

	return buffer;
}

RscDisplay* DisplayManager::GetDisplayFromName(std::string DisplayName) {
	if (m_Displays.find(DisplayName) != m_Displays.end())
		return &m_Displays[DisplayName];

	return {};
}


void RscDisplay::CacheTraits() {
	auto TraitArray = GAutoArray(m_Base + 0x48);

	if (TraitArray.InvalidList(99)) {
		return;	// return false in reality, but we dont really care.
	}

	auto buffer = std::unordered_map<std::string, RscDisplayTrait>();

	for (auto i = 0; i < TraitArray.GetSize(); i++) {
		const auto TraitEntry = TraitArray.Get<UINT64>(i);

		if (!TraitEntry || TraitEntry == 0x0)
			continue;

		RscDisplayTrait Trait;
		Trait.Init(TraitEntry);

		buffer[Trait.GetTraitName()] = Trait;
	}

	m_Traits = buffer;
}

bool RscDisplay::CachePayloadOnLoad() {
	if (!HasOnLoadTrait())
		return false;

	auto* OnLoad = &m_Traits[std::string("onLoad")];
	OrigOnLoad = OnLoad->GetStringValue();

	return true;
}

bool RscDisplay::CachePayloadOnUnLoad() {
	if (!HasOnUnloadTrait())
		return false;

	auto* OnUnload = &m_Traits[std::string("onUnload")];
	OrigOnLoad = OnUnload->GetStringValue();

	return true;
}

bool RscDisplay::CacheOverwrittenOnLoad(SIZE_T size) {
	if (!HasOnLoadTrait())
		return false;

	auto* OnLoad = &m_Traits[std::string("onLoad")];

	OverwrittenBytesOnLoad = new UINT8[size];

	UINT64 StringEntry = coms->Read<UINT64>(OnLoad->Get() + 0x10);
	UINT64 StringStart = StringEntry + 0x10;
	UINT64 StringEnd = StringStart + OrigOnLoad.size();

	OverwrittenBytesOnLoadSize = size;
	return coms->ReadBuffer(StringEnd, size, (PVOID)OverwrittenBytesOnLoad);
}

bool RscDisplay::CacheOverwrittenOnUnLoad(SIZE_T size) {
	if (!HasOnUnloadTrait())
		return false;

	auto* OnLoad = &m_Traits[std::string("onUnload")];

	OverwrittenBytesOnUnLoad = new UINT8[size];

	UINT64 StringEntry = coms->Read<UINT64>(OnLoad->Get() + 0x10);
	UINT64 StringStart = StringEntry + 0x10;
	UINT64 StringEnd = StringStart + OrigOnLoad.size();

	OverwrittenBytesOnUnLoadSize = size;
	return coms->ReadBuffer(StringEnd, size, (PVOID)OverwrittenBytesOnUnLoad);
}


void RscDisplay::Init(UINT64 Base) {
	m_Base = Base;

	CacheTraits();
}


bool RscDisplay::PlacePayloadOnLoad(std::string Payload) {
	auto* OnLoad = &m_Traits[std::string("onLoad")];

	if (!CachePayloadOnLoad()) {
		LogFailure("Failed to get original code");
		return false;
	}

	UINT64 StringEntry = coms->Read<UINT64>(OnLoad->Get() + 0x10);
	UINT64 StringStart = StringEntry + 0x10;
	UINT64 StringEnd = StringStart + OrigOnLoad.size();

	std::string TruePayload = '\x3B' + Payload + '\x90';
	const char* TruePayloadString = TruePayload.c_str();

	if (!CacheOverwrittenOnLoad(TruePayload.size())) {
		LogFailure("Failed to get overwritten bytes");
		return false;
	}

	for (auto i = 0; i < TruePayload.size(); i++) {	// should be as a buffer write but who cares.
		coms->Write<char>(StringEnd + i, TruePayloadString[i]);
	}

	return true;
}

bool RscDisplay::RemovePayloadOnLoad() {
	auto* OnLoad = &m_Traits[std::string("onLoad")];

	//if (OnLoad->GetTraitName().compare("onLoad"))
	//	return false;

	UINT64 StringEntry = coms->Read<UINT64>(OnLoad->Get() + 0x10);
	UINT64 StringStart = StringEntry + 0x10;
	UINT64 StringEnd = StringStart + OrigOnLoad.size();

	coms->Write<char>(StringEnd, '\x90');

	for (auto i = 0; i < OverwrittenBytesOnLoadSize; i++) {
		coms->Write<UINT8>(StringEnd + i, (UINT8)OverwrittenBytesOnLoad[i]);
	}

	return true;
}


void RscDisplay::DebugAllTraits() {
	auto TraitNames = GetAllTraitNames();

	for (auto& TraitName : TraitNames)
		Log("\tTraitName: %s \n", TraitName.c_str());
}


void RscDisplay::DebugOnLoadPayload() {
	if (!HasOnLoadTrait())
		return;


	auto* OnLoad = &m_Traits[std::string("onLoad")];
	Log("Display: %s \n", GetDisplayName().c_str());
	Log("\t %s: %s \n", OnLoad->GetTraitName().c_str(), OnLoad->GetStringValue().c_str());
	

}

void RscDisplay::DebugOnUnloadPayload() {
	if (!HasOnUnloadTrait())
		return;

	auto* OnUnload = &m_Traits[std::string("onUnload")];
	Log("\t %s: %s \n", OnUnload->GetTraitName().c_str(), OnUnload->GetStringValue().c_str());
}

bool RscDisplay::HasOnLoadTrait() {
	if (m_Traits.find(std::string("onLoad")) == m_Traits.end())
		return false;
	
	return true;
}

bool RscDisplay::HasOnUnloadTrait() {
	if (m_Traits.find(std::string("onUnload")) == m_Traits.end())
		return false;

	return true;
}


std::vector<std::string> RscDisplay::GetAllTraitNames() {
	auto buffer = std::vector<std::string>();

	for (auto& TraitEntry : m_Traits) {
		buffer.push_back(TraitEntry.first);
	}

	return buffer;
}

std::string RscDisplay::GetDisplayName() {
	return GArmaString(m_Base + 0x8).Get();
}

void RscDisplayTrait::Init(UINT64 Base) {
	m_Base = Base;
}

std::string RscDisplayTrait::GetTraitName() {
	return GArmaString(m_Base + 0x8).Get();
}


std::string RscDisplayTrait::GetStringValue() {
	return GArmaString(m_Base + 0x10).Get();
}