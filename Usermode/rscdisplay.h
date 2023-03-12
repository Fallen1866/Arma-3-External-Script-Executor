#pragma once
#include "includes.h"
#include "structs.h"

class RscDisplay;
class RscDisplayTrait;

class RscDisplayTrait {
	UINT64 m_Base = 0;

public:
	UINT64 Get() const { return m_Base; }

	std::string GetTraitName();
	std::string GetStringValue();

	void Init(UINT64 Base);
	


	~RscDisplayTrait() {}
	RscDisplayTrait() {}
};

class RscDisplay {
private:
	UINT64 m_Base = 0;
	std::unordered_map<std::string, RscDisplayTrait> m_Traits = {};

	// ASSUMES THERE IS A PAYLOAD
	std::string OrigOnLoad = "";
	std::string OrigOnUnload = "";

	UINT8* OverwrittenBytesOnLoad = nullptr;
	SIZE_T OverwrittenBytesOnLoadSize = 0;

	UINT8* OverwrittenBytesOnUnLoad = nullptr;
	SIZE_T OverwrittenBytesOnUnLoadSize = 0;

	void CacheTraits();
	bool CachePayloadOnLoad();
	bool CachePayloadOnUnLoad();

	bool CacheOverwrittenOnLoad(SIZE_T size = 0x0);
	bool CacheOverwrittenOnUnLoad(SIZE_T size = 0x0);

public:

	std::vector<std::string> GetAllTraitNames();
	std::string GetDisplayName();
	
	bool HasOnLoadTrait();
	bool HasOnUnloadTrait();
	
	bool PlacePayloadOnLoad(std::string Payload);
	bool RemovePayloadOnLoad();


	// Debugs and shit.
	void DebugAllTraits();
	void DebugOnLoadPayload();
	void DebugOnUnloadPayload();
	void DebugPotentialPayload() {
		DebugOnLoadPayload();
		DebugOnUnloadPayload();
	}

	void Init(UINT64 Base);

	~RscDisplay() {}
	RscDisplay() {}
};

class DisplayManager {
private:
	UINT64 m_Base = 0;
	std::unordered_map<std::string, RscDisplay> m_Displays = {};
	
public:

	std::vector<std::string> GetAllDisplayNames();
	std::vector<RscDisplay*> GetAllDisplays();
	RscDisplay* GetDisplayFromName(std::string DisplayName);



	void DebugAllDisplays();

	void InitRscDispalys();
	void Init(UINT64 Base);

	~DisplayManager() {}
	DisplayManager() {}
};

extern DisplayManager* RscDisplayManager;