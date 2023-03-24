#pragma once
#include "includes.h"
#include "cave.h"

class Hook {	// POINTERSWAP HOOK
	UINT64 m_Address = 0;
	UINT64 m_Original = 0;
	UINT64 m_Tampered = 0;
	bool HookPlaced = false;
public:
	UINT64 GetOriginal() const { return m_Original; }

private:
	UINT64 PlaceHook(UINT64 Destination) {
		const auto Prev = coms->Read<UINT64>(m_Address);
		coms->Write<UINT64>(m_Address, Destination);

		return Prev;
	}
public:

	bool ToggleHook(bool State) {
		if (HookPlaced == State)
			return false;

		if (State)
			m_Original = PlaceHook(m_Tampered);
		else 
			PlaceHook(m_Original);

		return true;
	}

	void Init() {
		m_Original = coms->Read<UINT64>(m_Address);
	}

	Hook(){}
	Hook(UINT64 Address, UINT64 Destination) : m_Address(Address), m_Tampered((UINT64)Destination) {}
	~Hook(){}
};