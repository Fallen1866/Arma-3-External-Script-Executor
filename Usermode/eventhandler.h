#pragma once
#include "includes.h"
#include "structs.h"
#include "sdk.h"

enum HandlerType {
	BASIC,
	MULTIPLAYER,
	MISSION,
	USERACTION,
	PROJECTILE,
	GROUP,
	PLAYERUI,
	UI,
	MUSIC,
};

class EventHandlerSerialized {
public:
	std::string GetScript() { 
		return GArmaString((UINT64)this + 0x10).Get();
	};

};

class EventHandlerContainer {
public:

	EventHandlerSerialized* GetSerialized() { return coms->Read<EventHandlerSerialized*>((UINT64)this + 0x10); }
	unsigned int GetType() { return coms->Read<unsigned int>((UINT64)this + 0x8); }
};

class ObjectEventHandler : public EventHandlerSerialized {
public:
	
};

class EventManager {
public:
	std::vector<EventHandlerContainer*> GetObjectScripts(UINT64 Object);
	
	

};

extern EventManager* HandlerManager;