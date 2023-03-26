#pragma once
#include "includes.h"
#include "tab.h"

#include <d3d11.h>
#pragma comment(lib, "d3d11.lib")

#include "imgui/imgui.h"
#include "imgui/imgui_impl_win32.h"
#include "imgui/imgui_impl_dx11.h"
#include "CodeEditor/TextEditor.h"

extern IMGUI_IMPL_API LRESULT ImGui_ImplWin32_WndProcHandler(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);
LRESULT WINAPI WndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

class Window {
public:
	ID3D11Device*			m_Device;
	ID3D11DeviceContext*	m_Context;
	IDXGISwapChain*			m_SwapChain;
	ID3D11RenderTargetView* m_RenderTarget;

	WNDCLASSEXA m_WindowClass;
	HWND	    m_Hwnd;

	bool m_Running = true;

public:
	bool RegisterWindow(const char* WindowName);
	bool CreateMenuWindow(const char* WindowName);

	bool CreateDirectX();
	bool CleanupDirectX();

	bool CreateRenderTarget();
	bool CleanupRenderTarget();

	bool RegisterImGui();

private:
	void SetupImGuiStyle();

public:
	bool StartWindow() {
		if (!RegisterWindow("Bison x Manware"))
			return false;

		if (!CreateMenuWindow("Arma 3 Script Executor"))
			return false;

		if (!CreateDirectX())
			return false;

		if (!RegisterImGui())
			return false;

		return true;
	}

	void ShowWindow() { ::ShowWindow(m_Hwnd, SW_SHOWDEFAULT); }
	void HideWindow() { ::ShowWindow(m_Hwnd, SW_MINIMIZE); }

	void RenderLoop();
};

extern Window* MenuWindow;