#pragma once
#include "includes.h"

class GAutoArray {
	unsigned __int64 m_ArrayEntry = 0;
	unsigned __int32 m_ArrayCount = 0;

public:
	template<typename T>
	T Get(int index, int offset = 0x8) {
		return coms->Read<T>(m_ArrayEntry + (index * offset));
	}

	template<typename T>
	T GetClass(int index, int offset) {
		return (T)(m_ArrayEntry + (index * offset));
	}

	bool InvalidList(unsigned __int32 MaxSize = 0x9999) {
		return MaxSize < m_ArrayCount;
	}

	unsigned __int32 GetSize() const {
		return m_ArrayCount;
	}

	GAutoArray(unsigned __int64 Base) {
		if (Base) {
			typedef struct temp { unsigned __int64 a1; unsigned __int64 a2; };
			auto _temp = temp(); _temp = coms->Read<temp>(Base);	// this is just to do it, in one read. will save performance if you have a lot of lists that you cache regulary.
			m_ArrayEntry = _temp.a1;
			m_ArrayCount = _temp.a2;
		}
	}
};

class GArmaString {
	UINT64 m_StringEntry;
	UINT32 m_StringSize;
	UINT32 m_StringRefs;

public:
	std::string Get() {
		return coms->ReadString(m_StringEntry + 0x10, m_StringSize);
	}

	GArmaString(unsigned __int64 Base) {
		if (Base) {
			m_StringEntry = coms->Read<UINT64>(Base);
			m_StringRefs = coms->Read<UINT32>(m_StringEntry + 0x0);	// should be 0x0
			m_StringSize = coms->Read<UINT32>(m_StringEntry + 0x8);
		}
	}

};