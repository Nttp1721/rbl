--[[
    Meizu Library Edition - Basic Test
    -----------------------------------
    Test nhanh các API chính của bản MeizuLibrary Edition mới.

    LƯU Ý:
    - Nếu bản Library Edition mới chưa được push lên GitHub,
      hãy đổi LIBRARY_URL thành URL raw chứa bản mới của bạn.
]]

local LIBRARY_URL = "https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/auu.lua"

local function safeLoadLibrary(url)
    local ok, source = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok or type(source) ~= "string" then
        warn("[Meizu Test] Không tải được MeizuLibrary.lua:", source)
        return nil
    end

    local loader, err = loadstring(source)
    if not loader then
        warn("[Meizu Test] Library compile lỗi:", err)
        return nil
    end

    local okRun, library = pcall(loader)
    if not okRun or type(library) ~= "table" then
        warn("[Meizu Test] Library trả về lỗi:", library)
        return nil
    end

    return library
end

local Meizu = safeLoadLibrary(LIBRARY_URL)
if not Meizu then
    return
end

-- Tạo Window
local Window = Meizu:CreateWindow({
    Title = "Meizu Library Test",
    SubTitle = "Edition Basic Test",
    Theme = "Dark",
    Accent = Color3.fromRGB(124, 92, 255),
    Size = UDim2.fromOffset(620, 450),
})

-- =========================================================
-- TAB 1: HOME
-- =========================================================
local Home = Window:CreateTab("Home")

Home:CreateSection("Welcome")

Home:CreateParagraph({
    Title = "Meizu Library Edition",
    Content = "Nếu bạn thấy được tab này + các control bên dưới thì bộ khung Library đang hoạt động.",
})

Home:CreateButton({
    Title = "Test Notification",
    Description = "Bấm để kiểm tra hệ thống notification.",
    Callback = function()
        Meizu:Notify({
            Title = "Meizu Test",
            Content = "Notification hoạt động bình thường!",
            Duration = 3,
        })
    end,
})

Home:CreateButton({
    Title = "Test Dialog",
    Description = "Kiểm tra animation dialog.",
    Callback = function()
        Window:Dialog({
            Title = "Meizu Dialog",
            Content = "Đây là dialog test của Library Edition.",
            Buttons = {
                {
                    Title = "Đóng",
                },
                {
                    Title = "OK",
                    Variant = "Primary",
                    Callback = function()
                        Meizu:Notify({
                            Title = "Dialog",
                            Content = "Bạn vừa bấm OK.",
                            Duration = 2,
                        })
                    end,
                },
            },
        })
    end,
})

-- =========================================================
-- TAB 2: CONTROLS
-- =========================================================
local Controls = Window:CreateTab("Controls")

local MainSection = Controls:CreateSection("Basic Controls")

Controls:CreateToggle({
    Title = "Test Toggle",
    Description = "Kiểm tra toggle + callback.",
    Default = false,
    Flag = "test_toggle",
    Callback = function(value)
        Meizu:Notify({
            Title = "Toggle",
            Content = "State = " .. tostring(value),
            Duration = 1.5,
        })
    end,
})

Controls:CreateSlider({
    Title = "Test Slider",
    Description = "Kéo thanh này để kiểm tra slider.",
    Min = 0,
    Max = 100,
    Default = 50,
    Rounding = 0,
    Flag = "test_slider",
    Callback = function(value)
        -- Test callback
    end,
})

Controls:CreateDropdown({
    Title = "Test Dropdown",
    Description = "Kiểm tra dropdown animation.",
    Options = {
        "Option A",
        "Option B",
        "Option C",
        "Option D",
    },
    Default = "Option A",
    Flag = "test_dropdown",
    Callback = function(value)
        print("[Meizu Test] Dropdown:", value)
    end,
})

Controls:CreateMultiDropdown({
    Title = "Test Multi Dropdown",
    Description = "Kiểm tra chọn nhiều option.",
    Options = {
        "Alpha",
        "Beta",
        "Gamma",
        "Delta",
    },
    Default = {},
    Flag = "test_multi",
    Callback = function(values)
        print("[Meizu Test] Multi:", values)
    end,
})

Controls:CreateInput({
    Title = "Test Input",
    Description = "Nhập thử một đoạn text.",
    Placeholder = "Gõ gì đó...",
    Default = "",
    Flag = "test_input",
    Callback = function(value)
        print("[Meizu Test] Input:", value)
    end,
})

Controls:CreateKeybind({
    Title = "Test Keybind",
    Description = "Bấm nút rồi nhấn phím bất kỳ.",
    Default = Enum.KeyCode.RightShift,
    Callback = function()
        Window:Toggle()
    end,
    ChangedCallback = function(key)
        print("[Meizu Test] Keybind:", key)
    end,
})

-- =========================================================
-- TAB 3: SETTINGS TEST
-- =========================================================
local Settings = Window:CreateTab("Settings Test")

Settings:CreateSection("Theme")

local themes = {}
for name in pairs(Meizu.Themes or {}) do
    table.insert(themes, name)
end
table.sort(themes)

Settings:CreateDropdown({
    Title = "Theme",
    Options = themes,
    Default = Meizu.Theme,
    Callback = function(theme)
        Meizu:ApplyTheme(theme)
    end,
})

Settings:CreateColorPicker({
    Title = "Accent",
    Default = Meizu.Accent,
    Callback = function(color)
        Meizu._UserAccent = color
        Meizu:ApplyAccent(color)
    end,
})

Settings:CreateToggle({
    Title = "Rainbow Accent",
    Default = false,
    Callback = function(value)
        Meizu:SetRainbow(value)
    end,
})

Settings:CreateSection("Language")

-- Bản Edition mới hỗ trợ vi/en qua SetLanguage()
Settings:CreateDropdown({
    Title = "Language",
    Options = {
        "Vietnamese",
        "English",
    },
    Default = (Meizu.Language == "en") and "English" or "Vietnamese",
    Callback = function(language)
        if type(Meizu.SetLanguage) == "function" then
            Meizu:SetLanguage(language == "English" and "en" or "vi")
        end
    end,
})

Settings:CreateSection("Window")

Settings:CreateButton({
    Title = "Toggle Window",
    Description = "Ẩn / hiện cửa sổ để test animation.",
    Callback = function()
        Window:Toggle()
    end,
})

Settings:CreateButton({
    Title = "Test Save Config",
    Description = "Lưu các flag test.",
    Callback = function()
        local ok = Meizu:SaveSettings("meizu_edition_test")
        Meizu:Notify({
            Title = "Config",
            Content = ok and "Đã lưu config test." or "Executor không hỗ trợ writefile.",
            Duration = 3,
        })
    end,
})

Settings:CreateButton({
    Title = "Test Load Config",
    Description = "Load lại các flag test.",
    Callback = function()
        local ok = Meizu:LoadSettings("meizu_edition_test")
        Meizu:Notify({
            Title = "Config",
            Content = ok and "Đã load config test." or "Không tìm thấy config test.",
            Duration = 3,
        })
    end,
})

-- =========================================================
-- READY
-- =========================================================
Window:SelectTab(1)

Meizu:Notify({
    Title = "Meizu Library Test",
    Content = "Basic test loaded thành công.",
    Duration = 4,
})
