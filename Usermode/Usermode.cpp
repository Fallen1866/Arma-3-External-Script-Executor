#include "includes.h"
#include "sdk.h"
#include "rscdisplay.h"

int main() {
	if (!coms->SetupInterface("arma3_x64.exe")) {
		LogFailure("Failed to setup interface \n");
		return -1;
	}

	if (!SDK->InitSDK()) {
		LogFailure("Failed to setup SDK \n");
		return -2;
	}

	SDK->DebugInfo();

	LogSuccess("Succesfully setup. \n");

	if (!SDK->InitComps())
		return -3;

	auto* GameOptionDisplay = RscDisplayManager->GetDisplayFromName("RscDisplayGameOptions");

	GameOptionDisplay->PlacePayloadOnLoad("hint \"Hi this a very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very long text to see if it patches it self after\"\x3B");
	
	while (!GetAsyncKeyState(VK_END))
		Sleep(500);
	
	GameOptionDisplay->RemovePayloadOnLoad();
}