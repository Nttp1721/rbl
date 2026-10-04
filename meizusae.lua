--// MeizuLibrary1 - Simple Test Script
--// Library source:
--// https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/meizulibrary1.lua

local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/meizulibrary1.lua"
))()

--// Create Window
local Window = Library:CreateWindow({
    Title = "Meizu Test",
    SubTitle = "Library v2.3 Test",

    Theme = "Dark", -- Dark / Light / Midnight / Void
    Accent = Color3.fromRGB(88, 101, 242),

    ToggleKeybind = Enum.KeyCode.RightControl,
    ToggleUIButton = true,
    ToggleText = "M",

    Size = UDim2.fromOffset(620, 460),
    Language = "vi",

    -- Để false cho test nhanh.
    -- Đổi thành true để test Loading Screen của library.
    Loader = false,
    LoaderTitle = "Meizu Test Loader",
    LoaderColor = Color3.fromRGB(88, 101, 242),
})

--// Main Tab
local MainTab = Window:CreateTab("Test", "rbxassetid://6026568198", 1)

local MainSection = MainTab:CreateSection("Controls")

--// Button test
MainSection:CreateButton({
    Title = "Test Button",
    Description = "Bấm nút này để test callback + notification.",
    Callback = function()
        print("[MEIZU TEST] Button clicked")

        Library:Notify({
            Title = "Button",
            Content = "Bạn vừa bấm Test Button!",
            Duration = 3,
        })
    end,
})

--// Toggle test
MainSection:CreateToggle({
    Title = "Test Toggle",
    Description = "Bật/tắt để kiểm tra trạng thái toggle.",
    Default = false,
    Flag = "TestToggle",
    Callback = function(value)
        print("[MEIZU TEST] Toggle =", value)

        Library:Notify({
            Title = "Toggle",
            Content = "Trạng thái: " .. tostring(value),
            Duration = 2,
        })
    end,
})

--// Slider test
MainSection:CreateSlider({
    Title = "Test Slider",
    Description = "Kéo từ 0 đến 100 để test slider.",
    Min = 0,
    Max = 100,
    Default = 50,
    Rounding = 0,
    Flag = "TestSlider",
    Callback = function(value)
        print("[MEIZU TEST] Slider =", value)
    end,
})

--// Dropdown test
MainSection:CreateDropdown({
    Title = "Test Dropdown",
    Description = "Chọn một option.",
    Options = {"Option A", "Option B", "Option C", "Option D"},
    Default = "Option A",
    Flag = "TestDropdown",
    Callback = function(value)
        print("[MEIZU TEST] Dropdown =", value)
    end,
})

--// Multi Dropdown test
MainSection:CreateMultiDropdown({
    Title = "Test Multi Dropdown",
    Description = "Chọn nhiều option cùng lúc.",
    Options = {"Red", "Green", "Blue", "Yellow"},
    Default = {"Red", "Blue"},
    Flag = "TestMultiDropdown",
    Callback = function(values)
        print("[MEIZU TEST] MultiDropdown =", table.concat(values, ", "))
    end,
})

--// Input test
MainSection:CreateInput({
    Title = "Test Input",
    Description = "Nhập text rồi Enter hoặc click ra ngoài.",
    Placeholder = "Nhập gì đó...",
    Default = "Hello Meizu",
    Flag = "TestInput",
    Callback = function(value)
        print("[MEIZU TEST] Input =", value)

        Library:Notify({
            Title = "Input",
            Content = "Bạn nhập: " .. tostring(value),
            Duration = 3,
        })
    end,
})

local ExtraSection = MainTab:CreateSection("Extra")

--// Color Picker test
ExtraSection:CreateColorPicker({
    Title = "Test Color Picker",
    Description = "Kéo ô màu để test HSV + callback.",
    Default = Color3.fromRGB(255, 80, 120),
    Flag = "TestColor",
    Callback = function(color)
        print("[MEIZU TEST] Color =", color)
    end,
})

--// Keybind test
ExtraSection:CreateKeybind({
    Title = "Test Keybind",
    Description = "Bấm vào ô bên phải rồi nhấn một phím.",
    Default = Enum.KeyCode.F,
    Flag = "TestKeybind",
    ChangedCallback = function(key)
        print("[MEIZU TEST] Keybind changed =", key.Name)

        Library:Notify({
            Title = "Keybind",
            Content = "Phím mới: " .. key.Name,
            Duration = 2,
        })
    end,
})

--// Paragraph test
ExtraSection:CreateParagraph({
    Title = "Paragraph Test",
    Content = "Đây là paragraph dùng để kiểm tra text wrapping, kích thước tự động và giao diện của library.",
})

--// Dialog test
ExtraSection:CreateButton({
    Title = "Test Dialog",
    Description = "Mở hộp thoại xác nhận.",
    Callback = function()
        Window:Dialog({
            Title = "Meizu Dialog",
            Content = "Dialog hoạt động bình thường không? Hãy thử bấm từng nút.",
            Buttons = {
                {
                    Title = "Cancel",
                },
                {
                    Title = "OK",
                    Variant = "Primary",
                    Callback = function()
                        print("[MEIZU TEST] Dialog OK")
                        Library:Notify({
                            Title = "Dialog",
                            Content = "Bạn đã bấm OK.",
                            Duration = 2,
                        })
                    end,
                },
            },
        })
    end,
})

--// API test tab
local APITab = Window:CreateTab("API", "rbxassetid://6022668898", 2)
local APISection = APITab:CreateSection("Library API")

APISection:CreateButton({
    Title = "Theme: Light",
    Callback = function()
        Library:ApplyTheme("Light")
    end,
})

APISection:CreateButton({
    Title = "Theme: Midnight",
    Callback = function()
        Library:ApplyTheme("Midnight")
    end,
})

APISection:CreateButton({
    Title = "Theme: Void",
    Callback = function()
        Library:ApplyTheme("Void")
    end,
})

APISection:CreateButton({
    Title = "Accent: Purple",
    Callback = function()
        Library:ApplyAccent(Color3.fromRGB(170, 85, 255))
    end,
})

APISection:CreateButton({
    Title = "Accent: Green",
    Callback = function()
        Library:ApplyAccent(Color3.fromRGB(60, 220, 120))
    end,
})

APISection:CreateToggle({
    Title = "Rainbow Accent",
    Default = false,
    Callback = function(value)
        Library:SetRainbow(value)
    end,
})

APISection:CreateDropdown({
    Title = "Language",
    Options = {"Tiếng Việt", "English"},
    Default = "Tiếng Việt",
    Callback = function(value)
        Library:SetLanguage(value == "English" and "en" or "vi")
    end,
})

APISection:CreateButton({
    Title = "Notify Test",
    Callback = function()
        Library:Notify({
            Title = "Notification Test",
            Content = "Notify API đang hoạt động.",
            Duration = 4,
        })
    end,
})

--// Ready callback
Window:OnReady(function()
    print("[MEIZU TEST] UI READY")

    Library:Notify({
        Title = "Meizu Test",
        Content = "UI đã load xong. Hãy test từng control.",
        Duration = 4,
    })
end)
