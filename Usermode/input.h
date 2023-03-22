#pragma once
#include <Windows.h>
#include <array>

class InputComponent {
    struct t_Key {
        bool Held = false;
        bool Pressed = false;
        bool Released = false;

        DWORD InitialTick = 0;
        DWORD CurrentTick = 0;
    };

    std::array<t_Key, 0xFE> m_Keys;

public:
    void Update() {
        for (auto i = 0; i < 0xFE; i++) {
            auto& Key = m_Keys[i];

            if (GetAsyncKeyState(i)) {
                if (Key.Pressed)
                    Key.Pressed = false;

                if (Key.InitialTick == 0) {
                    // Pressed
                    Key.InitialTick = GetTickCount64();
                    Key.Pressed = true;
                }
                else {
                    Key.CurrentTick = GetTickCount64();

                    constexpr static auto Threshold = 16; // 200ms

                    if (Key.CurrentTick - Key.InitialTick > Threshold) {
                        Key.Held = true;
                        Key.Pressed = false;
                    }
                }
            }
            else {
                if (Key.Released)
                    Key = { 0,0,0,0,0 };

                if (Key.InitialTick != 0)
                    Key.Released = true;
            }
        }
    }

    bool IsKeyHeld(int Key)         const { return m_Keys[(int)Key].Held; }
    bool IsKeyPressed(int Key)      const { return m_Keys[(int)Key].Pressed; }
    bool IsKeyReleased(int Key)     const { return m_Keys[(int)Key].Released; }
};

extern InputComponent* Input;