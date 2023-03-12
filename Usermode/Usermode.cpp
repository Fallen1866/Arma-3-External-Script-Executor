#include "includes.h"
#include "sdk.h"
#include "rscdisplay.h"

void DebugInfo() {

}

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

	//RscDisplayManager->DebugAllDisplays();


	auto* GameOptionDisplay = RscDisplayManager->GetDisplayFromName("RscDisplayGameOptions");
	//Log("Display Found -> %s \n", GameOptionDisplay->GetDisplayName().c_str());

	GameOptionDisplay->PlacePayloadOnLoad("hint \"Hi this a very long text to see if it patches it self after\";");
	
	while (!GetAsyncKeyState(VK_END)) {
		Sleep(500);
	}
	GameOptionDisplay->RemovePayloadOnLoad();

	//GameOptionDisplay->DebugAllTraits();

}