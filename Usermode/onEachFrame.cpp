#include "onEachFrame.h"

Frame* OnEachFrame = new Frame(3);

void Frame::RenderMenu() {
	static GameValue* EachFrameHook = nullptr;

	if (GetFrameCodeData())
		ImGui::TextColored(ImColor(0, 255, 0), "OnEachFrame: ACTIVE");
	else 
		ImGui::TextColored(ImColor(255, 0, 0), "OnEachFrame: INACTIVE");

	ImGui::SameLine();
	
	if (EachFrameHook)
		ImGui::TextColored(ImColor(0, 255, 0), "OnEachFrameHook: FOUND");
	else
		ImGui::TextColored(ImColor(255, 0, 0), "OnEachFrameHook: NOT FOUND");

	ImGui::SameLine();

	if(OriginalPtr)
		ImGui::TextColored(ImColor(0, 255, 0), "CanRestore: TRUE");
	else
		ImGui::TextColored(ImColor(0, 255, 0), "CanRestore: FALSE");

	if (ImGui::Button("Search for EachFrameHook")) {
		static auto Variables = VariableManager->GetMissionVariables();
		
		for (auto& Variable : Variables) {
			if (!Variable.Name.compare("oneachframe_hk"))
				EachFrameHook = &Variable;
		}
	}

	if (ImGui::Button("Place Ptr") && EachFrameHook) {
		OriginalPtr = GetFrameCodeData();
		coms->Write<UINT64>(Base, EachFrameHook->GetValuePtr());
	}

	if (ImGui::Button("Restore Ptr")) {
		coms->Write<UINT64>(Base, OriginalPtr);
		OriginalPtr = 0;
	}

	if (ImGui::Button("Update EachFrame")) {
		UpdateOnEachFrame();

		Log("Base -> 0x%llx \n", Base);
	}

	SQFCodeEditor.SetText(CodeBuffer);
	SQFCodeEditor.Render("SQF EDITOR");

	

}