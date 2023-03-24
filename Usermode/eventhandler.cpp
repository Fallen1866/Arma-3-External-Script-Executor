#include "eventhandler.h"

EventManager* HandlerManager = new EventManager();

std::vector<EventHandlerContainer*> EventManager::GetObjectScripts(UINT64 Object) {
	auto EventHandlerArray = GAutoArray(Object + 0x610);

	if (EventHandlerArray.InvalidList())
		return {};

	auto Buffer = std::vector<EventHandlerContainer*>();

	for (auto i = 0; i < EventHandlerArray.GetSize(); i++)
		if (auto HandlerEntry = EventHandlerArray.GetClass<EventHandlerContainer*>(i, 0x30))
			Buffer.push_back(HandlerEntry);

	return Buffer;
}