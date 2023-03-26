#include "window.h"

Window* MenuWindow = new Window;

bool Window::RegisterWindow(const char* ClassName) {
	m_WindowClass = {
		sizeof(m_WindowClass),
		CS_CLASSDC,
		WndProc,
		0, 0,
		GetModuleHandle(NULL),
		0,0,0,0,
		ClassName,
		0
	};

	RegisterClassEx(&m_WindowClass);
	return true;
}

bool Window::CreateMenuWindow(const char* WindowName) {
	m_Hwnd = CreateWindow(
		m_WindowClass.lpszClassName,
		WindowName,
		WS_OVERLAPPEDWINDOW,
		100, 100, 720, 480,
		0, 0, m_WindowClass.hInstance, 0
	);

	return m_Hwnd;
}

bool Window::CreateDirectX() {
	DXGI_SWAP_CHAIN_DESC SwapChainDesc;
	SwapChainDesc.BufferCount = 2;
	SwapChainDesc.BufferDesc.Width = 0;
	SwapChainDesc.BufferDesc.Height = 0;
	SwapChainDesc.BufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
	SwapChainDesc.BufferDesc.RefreshRate.Numerator = 60;
	SwapChainDesc.BufferDesc.RefreshRate.Denominator = 1;
	SwapChainDesc.Flags = DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH;
	SwapChainDesc.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
	SwapChainDesc.OutputWindow = m_Hwnd;
	SwapChainDesc.SampleDesc.Count = 1;
	SwapChainDesc.SampleDesc.Quality = 0;
	SwapChainDesc.Windowed = TRUE;
	SwapChainDesc.SwapEffect = DXGI_SWAP_EFFECT_DISCARD;

	UINT createDeviceFlags = 0;
	
	D3D_FEATURE_LEVEL featureLevel;
	const D3D_FEATURE_LEVEL featureLevelArray[2] = { D3D_FEATURE_LEVEL_11_0, D3D_FEATURE_LEVEL_10_0, };
	
	HRESULT res = D3D11CreateDeviceAndSwapChain(NULL, D3D_DRIVER_TYPE_HARDWARE, NULL, createDeviceFlags, featureLevelArray, 2, D3D11_SDK_VERSION, &SwapChainDesc, &m_SwapChain, &m_Device, &featureLevel, &m_Context);
	
	if (res == DXGI_ERROR_UNSUPPORTED) // Try high-performance WARP software driver if hardware is not available.
		res = D3D11CreateDeviceAndSwapChain(NULL, D3D_DRIVER_TYPE_WARP, NULL, createDeviceFlags, featureLevelArray, 2, D3D11_SDK_VERSION, &SwapChainDesc, &m_SwapChain, &m_Device, &featureLevel, &m_Context);
	
	if (res != S_OK)
		return false;

	return CreateRenderTarget();
}

bool Window::CleanupDirectX() {
	CleanupRenderTarget();

	if (m_SwapChain) {
		m_SwapChain->Release();
		m_SwapChain = nullptr;
	}

	if (m_Context) {
		m_Context->Release();
		m_Context = nullptr;
	}

	if (m_Device) {
		m_Device->Release();
		m_Device = nullptr;
	}

	return true;
}

bool Window::CreateRenderTarget() {
	ID3D11Texture2D* BackBuffer;
	m_SwapChain->GetBuffer(0, IID_PPV_ARGS(&BackBuffer));
	m_Device->CreateRenderTargetView(BackBuffer, NULL, &m_RenderTarget);
	BackBuffer->Release();

	return true;
}

bool Window::CleanupRenderTarget() {
	if (m_RenderTarget) {
		m_RenderTarget->Release();
		m_RenderTarget = nullptr;
	}

	return m_RenderTarget == nullptr;
}

bool Window::RegisterImGui() {
	IMGUI_CHECKVERSION();
	ImGui::CreateContext();
	
	ImGuiIO& io = ImGui::GetIO(); (void)io;
	io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;
	
	io.IniFilename = "";

	ImGui::StyleColorsDark();
	SetupImGuiStyle();

	ImGui_ImplWin32_Init(m_Hwnd);
	ImGui_ImplDX11_Init(m_Device, m_Context);

	return true;
}

void Window::SetupImGuiStyle() {
	ImGuiStyle& style = ImGui::GetStyle();
	style.Alpha = 1.0f;
	style.WindowPadding = ImVec2(0, 0);
	style.WindowMinSize = ImVec2(32, 32);
	style.WindowRounding = 0;
	style.WindowTitleAlign = ImVec2(0.0f, 0.5f);
	//style.ChildWindowRounding = 0.0f;
	style.FramePadding = ImVec2(4, 3);
	style.FrameRounding = 0.0f;
	style.ItemSpacing = ImVec2(8, 8);
	style.ItemInnerSpacing = ImVec2(8, 8);
	style.TouchExtraPadding = ImVec2(0, 0);
	style.IndentSpacing = 21.0f;
	style.ColumnsMinSpacing = 0.0f;
	style.ScrollbarSize = 6.0f;
	style.ScrollbarRounding = 0.0f;
	style.GrabMinSize = 5.0f;
	style.GrabRounding = 0.0f;
	style.ButtonTextAlign = ImVec2(0.5f, 0.5f);
	style.DisplayWindowPadding = ImVec2(22, 22);
	style.DisplaySafeAreaPadding = ImVec2(4, 4);
	style.AntiAliasedLines = true;
	style.CurveTessellationTol = 1.f;

	ImVec4* colors = ImGui::GetStyle().Colors;
	colors[ImGuiCol_Text] = ImVec4(.6f, .6f, .6f, 1.00f); // grey
	colors[ImGuiCol_TextDisabled] = ImVec4(0.60f, 0.60f, 0.60f, 1.00f);
	colors[ImGuiCol_TextSelectedBg] = ImVec4(0.00f, 0.00f, 1.00f, 0.35f);
	colors[ImGuiCol_WindowBg] = ImVec4(10 / 255.f, 9 / 255.f, 13 / 255.f, 1.00f);
	colors[ImGuiCol_ChildBg] = ImVec4(11 / 255.f, 10 / 255.f, 13 / 255.f, 1.0f);
	colors[ImGuiCol_PopupBg] = ImVec4(0.05f, 0.05f, 0.10f, 0.90f);
	colors[ImGuiCol_Border] = ImColor(25, 20, 36, 255); // 149, 20, 255
	colors[ImGuiCol_BorderShadow] = ImVec4(0.f, 0, 0, 1.00f);
	colors[ImGuiCol_FrameBg] = ImVec4(0.101, 0.101, 0.101, 1.0f);
	colors[ImGuiCol_FrameBgHovered] = ImVec4(.6f, .6f, .6f, 0.40f);
	colors[ImGuiCol_FrameBgActive] = ImVec4(0.20f, 0.25f, 0.30f, 1.0f);
	colors[ImGuiCol_TitleBg] = ImVec4(0.10f, 0.10f, 0.10f, 1.00f);
	colors[ImGuiCol_TitleBgCollapsed] = ImVec4(0.20f, 0.20f, 0.20f, 1.00f);
	colors[ImGuiCol_TitleBgActive] = ImVec4(0.20f, 0.20f, 0.20f, 1.00f);
	colors[ImGuiCol_MenuBarBg] = ImVec4(0.40f, 0.40f, 0.55f, 0.80f);
	colors[ImGuiCol_ScrollbarBg] = ImVec4(32 / 255.f, 58 / 255.f, 67 / 255.f, 1.f);
	colors[ImGuiCol_ScrollbarGrab] = ImVec4(149 / 255.f, 20 / 255.f, 225 / 255.f, 1.f);
	colors[ImGuiCol_ScrollbarGrabHovered] = ImVec4(149 / 255.f, 20 / 255.f, 255 / 255.f, 1.f);
	colors[ImGuiCol_ScrollbarGrabActive] = ImVec4(149 / 255.f, 20 / 255.f, 255 / 255.f, 1.f);
	//colors[ImGuiCol_Separator] = ImVec4(0.654, 0.094, 0.278, 1.f);
	colors[ImGuiCol_Separator] = ImVec4(255 / 255.f, 126 / 255.f, 0, 1.f);
	colors[ImGuiCol_CheckMark] = ImColor(255, 124, 0, 255);
	colors[ImGuiCol_SliderGrab] = ImVec4(1.00f, 1.00f, 1.00f, 0.30f);
	colors[ImGuiCol_SliderGrabActive] = ImVec4(255 / 255.f, 126 / 255.f, 0, 1.f); //ImVec4(0.80f, 0.50f, 0.50f, 1.00f);
	//colors[ImGuiCol_Button] = ImVec4(0.10f, 0.10f, 0.10f, 1.00f);
	colors[ImGuiCol_Button] = ImVec4(0.117f, 0.117f, 0.152f, 1.f); //ImVec4(1.00f, 0.3f, 0.f, 1.00f);
	colors[ImGuiCol_ButtonHovered] = ImColor(255, 110, 0, 135);
	colors[ImGuiCol_ButtonActive] = ImColor(255, 126, 0, 255);

	/* MENU */
	colors[ImGuiCol_Header] = ImColor(255, 126, 0, 170);
	colors[ImGuiCol_HeaderHovered] = ImVec4(0.26f, 0.26f, 0.26f, 1.f);
	colors[ImGuiCol_HeaderActive] = ImColor(0.2f, 0.2f, 0.2f, 1.f);

	colors[ImGuiCol_ResizeGrip] = ImVec4(1.00f, 1.00f, 1.00f, 0.30f);
	colors[ImGuiCol_ResizeGripHovered] = ImVec4(1.00f, 1.00f, 1.00f, 0.60f);
	colors[ImGuiCol_ResizeGripActive] = ImVec4(1.00f, 1.00f, 1.00f, 0.90f);
	colors[ImGuiCol_PlotLines] = ImVec4(1.00f, 1.00f, 1.00f, 1.00f);
	colors[ImGuiCol_PlotLinesHovered] = ImVec4(0.90f, 0.70f, 0.00f, 1.00f);
	colors[ImGuiCol_PlotHistogram] = ImVec4(0.90f, 0.70f, 0.00f, 1.00f);
	colors[ImGuiCol_PlotHistogramHovered] = ImVec4(1.00f, 0.30f, 0.00f, 1.00f);
}

void Window::RenderLoop() {
	this->ShowWindow();

	while (m_Running) {
		MSG msg;
		while (::PeekMessageA(&msg, NULL, 0, 0, PM_REMOVE)) {
			::TranslateMessage(&msg);
			::DispatchMessageA(&msg);

			if (msg.message == WM_QUIT)
				m_Running = false;
		}


		ImGui_ImplDX11_NewFrame();
		ImGui_ImplWin32_NewFrame();
		ImGui::NewFrame();

		ImGui::SetNextWindowPos(ImVec2(0, 0), ImGuiCond_Once);
		ImGui::SetNextWindowSize(ImGui::GetMainViewport()->Size);

		ImGui::Begin("MENINATTIRE", (bool*)false, ImGuiWindowFlags_NoMove | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoTitleBar);

		ImVec2 CursorPos = ImGui::GetCursorScreenPos();
		ImColor BarColors1 = ImColor(255, 127, 0, 255);
		ImColor BarColors2 = ImColor(255, 111, 0, 255);
		ImColor BarColors3 = ImColor(255, 96, 0, 255);

		ImGui::GetWindowDrawList()->AddRectFilledMultiColor(
			ImVec2(CursorPos.x - 10, CursorPos.y + 40), ImVec2(CursorPos.x + ImGui::GetWindowWidth(), CursorPos.y + 42), 
			ImColor(255, 34, 0, 255), BarColors1, BarColors2, BarColors3
		);

		ImGui::GetWindowDrawList()->AddRectFilledMultiColor(
			ImVec2(CursorPos.x + 98, CursorPos.y + 42), ImVec2(CursorPos.x + 100, CursorPos.y + ImGui::GetWindowHeight()), 
			ImColor(255, 34, 0, 255), BarColors1, BarColors2, BarColors3);


		auto MainTitle = "MANWARE - THAT FRAALI EXECUTOR";
		auto MainTitleSize = ImGui::CalcTextSize(MainTitle);
		auto MainTitleCenterX = ImGui::GetWindowSize().x / 2 - MainTitleSize.x / 2;
		auto MainTitleCenterY = 38 / 2 - MainTitleSize.y / 2;
		ImGui::SetCursorPos(ImVec2(MainTitleCenterX, MainTitleCenterY));
		ImGui::TextColored(BarColors1, MainTitle);
		
		// Do shit
		// Do shit
		

		TabManager::RenderTabsTitle();

		// Do shit with brush

		TabManager::RenderTabMenu();


		ImGui::End();

		ImGui::Render();
		ImVec4 clear_color = ImVec4(0.45f, 0.55f, 0.60f, 1.00f);
		const float clear_color_with_alpha[4] = { clear_color.x * clear_color.w, clear_color.y * clear_color.w, clear_color.z * clear_color.w, clear_color.w };
        m_Context->OMSetRenderTargets(1, &m_RenderTarget, nullptr);
		m_Context->ClearRenderTargetView(m_RenderTarget, clear_color_with_alpha);

		ImGui_ImplDX11_RenderDrawData(ImGui::GetDrawData());
		m_SwapChain->Present(1, 0);
	}

	ImGui_ImplDX11_Shutdown();
	ImGui_ImplWin32_Shutdown();
	ImGui::DestroyContext();

	CleanupDirectX();
	DestroyWindow(m_Hwnd);
	UnregisterClassA(m_WindowClass.lpszClassName, m_WindowClass.hInstance);
}

LRESULT WINAPI WndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam) {
	if (ImGui_ImplWin32_WndProcHandler(hWnd, msg, wParam, lParam))
		return true;

	switch (msg) {

	case WM_SIZE: {

		if (MenuWindow->m_Device && wParam != SIZE_MINIMIZED) {
			MenuWindow->CleanupRenderTarget();
			MenuWindow->m_SwapChain->ResizeBuffers(0, (UINT)LOWORD(lParam), (UINT)HIWORD(lParam), DXGI_FORMAT_UNKNOWN, 0);
			MenuWindow->CreateRenderTarget();
		}

	}break;

	case WM_SYSCOMMAND: {

		if ((wParam & 0xFFF0) == SC_KEYMENU)
			return 0;

	}break;

	case WM_DESTROY: {
		PostQuitMessage(0);
		return 0;
	}break;

	}

	// Our codenz.


	return DefWindowProcA(hWnd, msg, wParam, lParam);
}
