--[[
    ███╗   ███╗███████╗██╗███████╗██╗   ██╗
    ████╗ ████║██╔════╝██║██╔════╝╚██╗ ██╔╝
    ██╔████╔██║█████╗  ██║███████╗ ╚████╔╝
    ██║╚██╔╝██║██╔══╝  ██║╚════██║  ╚██╔╝
    ██║ ╚═╝ ██║███████╗██║███████║   ██║
    ╚═╝     ╚═╝╚══════╝╚═╝╚══════╝   ╚═╝
    MEIZU LIBRARY v2.3 — Modern UI Library (Fluent-inspired)
    =========================================================
    v2.3 (CHANGELOG)
      + Nút nổi: hình CỐ ĐỊNH (meizuxp.png), đã xoá chức năng đổi hình
      + Ngôn ngữ: Tiếng Việt / English (chọn trong Settings, tự ghi nhớ)
      + Màn hình loading (giống testtintro.lua) trước khi mở UI
      + Animation mượt hơn: mở/đóng, đổi tab, nhấn nút, toggle, thông báo...
      + Fix: Settings tab chiếm index 1 | keybind bật/tắt bị gọi 2 lần |
             bóng đổ bị cắt | kéo slider/colorpicker hỏng sau khi tạo lại UI

    API:
      Library:CreateWindow{Title, SubTitle, Theme, Accent, ToggleKeybind,
                           ToggleUIButton, ToggleText, Size, Language,
                           Loader, LoaderTitle, LoaderColor}
      Window:CreateTab(name, iconId, order) / Window:SelectTab(1)
      Window:Toggle(state) / Window:Dialog{Title, Content, Buttons}
      Window:OnReady(fn)                  -- chạy khi loading xong & UI đã mở
      Tab/Section:CreateButton / CreateToggle / CreateSlider / CreateDropdown
                  CreateMultiDropdown / CreateKeybind / CreateInput
                  CreateColorPicker / CreateParagraph / CreateSection
      Library:Notify{Title, Content, Duration} / Library:ApplyTheme("Dark")
      Library:ApplyAccent(Color3) / Library:SetRainbow(bool)
      Library:SetLanguage("vi" | "en") / Library:GetLanguage()
      Library:SaveSettings(name) / Library:LoadSettings(name) / Library:Destroy()
      Library.Flags --> giá trị theo Flag

    ĐA NGÔN NGỮ CHO SCRIPT CỦA BẠN:
      Mọi Title / Description / Content / Placeholder đều nhận 2 dạng:
        Title = "Auto Farm"                       -- chuỗi thường
        Title = {vi = "Tự động farm", en = "Auto Farm"}   -- tự đổi khi đổi ngôn ngữ
]]

--// ================== CẤU HÌNH NHANH ==================
local TOGGLE_BUTTON_SIZE     = UDim2.new(0, 50, 0, 50)                                  -- Nút nổi
local TOGGLE_BUTTON_POSITION = UDim2.new(0.120833337 - 0.1, 0, 0.0952890813 + 0.01, 0)  -- Vị trí mặc định
local TOGGLE_BUTTON_RADIUS   = 12                                                       -- Bo góc kiểu testtintro

-- HÌNH NÚT NỔI: CỐ ĐỊNH, không đổi được
local LOGO_URL = "https://i.ibb.co/S7rpHJJN/meizuxp.png"
--// ====================================================

local MeizuLibrary = {
    Version       = "2.3",
    Flags         = {},
    Theme         = "Dark",
    Accent        = Color3.fromRGB(88, 101, 242),
    ToggleKeybind = Enum.KeyCode.RightControl,
    SoundEnabled  = true,
    Language      = "vi",
    Folder        = "MeizuLibrary",
    _FlagElems    = {},
    _ThemeObjs    = {},
    _AccentObjs   = {},
    _ThemeHooks   = {},
    _LangObjs     = {},
    _LangHooks    = {},
    _Connections  = {},
    _ActiveDrags  = {},
    _Notifs       = {},
    _NotifCount   = 0,
    _Gen          = 0,
    Destroyed     = false,
}

local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local HttpService      = game:GetService("HttpService")
local TextService      = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    task.wait()
    LocalPlayer = Players.LocalPlayer
end

--// ============================ NGÔN NGỮ ============================
local Strings = {
    -- chung
    search_placeholder = {vi = "Tìm kiếm...", en = "Search..."},
    select_placeholder = {vi = "Chọn...", en = "Select..."},
    none_selected      = {vi = "Chưa chọn", en = "None selected"},
    input_placeholder  = {vi = "Nhập tại đây...", en = "Type here..."},
    key_none           = {vi = "Không", en = "None"},
    notification       = {vi = "Thông báo", en = "Notification"},
    dialog             = {vi = "Hộp thoại", en = "Dialog"},
    btn_ok             = {vi = "OK", en = "OK"},
    btn_cancel         = {vi = "Hủy", en = "Cancel"},
    btn_close          = {vi = "Đóng", en = "Close"},
    btn_unload         = {vi = "Gỡ", en = "Unload"},
    close_title        = {vi = "Đóng giao diện", en = "Close UI"},
    close_content      = {vi = "Bạn có muốn tắt hoàn toàn giao diện không?", en = "Do you want to completely close the UI?"},

    -- Settings
    tab_settings   = {vi = "Cài đặt", en = "Settings"},
    about_content  = {
        vi = "Thư viện UI hiện đại — lấy cảm hứng từ Fluent Design.\nCảm ơn bạn đã sử dụng!",
        en = "Modern UI Library — Inspired by Fluent Design.\nThank you for using it!",
    },
    sec_interface  = {vi = "Giao diện", en = "Interface"},
    sec_config     = {vi = "Cấu hình", en = "Config"},
    sec_system     = {vi = "Hệ thống", en = "System"},
    language       = {vi = "Ngôn ngữ", en = "Language"},
    language_desc  = {vi = "Chọn ngôn ngữ hiển thị của giao diện", en = "Choose the interface language"},
    language_changed = {vi = "Đã chuyển sang Tiếng Việt", en = "Switched to English"},
    theme          = {vi = "Chủ đề màu", en = "Theme"},
    accent         = {vi = "Màu nhấn", en = "Accent Color"},
    rainbow        = {vi = "Màu nhấn cầu vồng", en = "Rainbow Accent"},
    sound          = {vi = "Hiệu ứng âm thanh", en = "Sound Effects"},
    keybind_toggle = {vi = "Phím ẩn/hiện UI", en = "Toggle UI Keybind"},
    config_name    = {vi = "Tên cấu hình", en = "Config Name"},
    save_config    = {vi = "Lưu cấu hình", en = "Save Config"},
    load_config    = {vi = "Tải cấu hình", en = "Load Config"},
    config_title   = {vi = "Cấu hình", en = "Config"},
    config_saved   = {vi = "Đã lưu cấu hình '<b>%s</b>'!", en = "Saved config '<b>%s</b>'!"},
    config_loaded  = {vi = "Đã tải cấu hình '<b>%s</b>'!", en = "Loaded config '<b>%s</b>'!"},
    config_nosave  = {vi = "Executor không hỗ trợ writefile!", en = "Your executor doesn't support writefile!"},
    config_notfound = {vi = "Không tìm thấy cấu hình!", en = "Config not found!"},
    unload         = {vi = "Gỡ thư viện", en = "Unload Library"},
    unload_desc    = {vi = "Xoá toàn bộ giao diện khỏi game", en = "Remove the entire UI from the game"},
    unload_title   = {vi = "Gỡ giao diện", en = "Unload"},
    unload_content = {vi = "Bạn có chắc muốn gỡ giao diện không?", en = "Are you sure you want to unload the UI?"},

    -- Loader
    loader_title = {vi = "Cảm ơn bạn đã sử dụng Meizu", en = "Thanks For Using Meizu"},
    loader_step_1 = {vi = "Đang khởi tạo thư viện...", en = "Initializing library..."},
    loader_step_2 = {vi = "Đang tải tài nguyên...", en = "Loading assets..."},
    loader_step_3 = {vi = "Đang dựng giao diện...", en = "Building interface..."},
    loader_step_4 = {vi = "Hoàn tất! Chúc bạn vui vẻ", en = "Done! Have fun"},
}
MeizuLibrary.Strings = Strings

-- Lấy chuỗi theo ngôn ngữ hiện tại (nhận string hoặc {vi=,en=})
local function Resolve(v)
    if type(v) == "table" then
        local s = v[MeizuLibrary.Language] or v.en or v.vi
        if s == nil then
            local _, first = next(v)
            s = first
        end
        return s ~= nil and tostring(s) or ""
    end
    if v == nil then return "" end
    return tostring(v)
end

local function S(key) return Strings[key] or key end

local function LS(key, ...)
    local s = Resolve(Strings[key] or key)
    if select("#", ...) > 0 then
        local ok, r = pcall(string.format, s, ...)
        if ok then return r end
    end
    return s
end

-- Gán text + tự cập nhật khi đổi ngôn ngữ (chỉ khi value là bảng {vi=,en=})
local function BindText(obj, prop, value, transform)
    local function apply()
        local s = Resolve(value)
        if transform then s = transform(s) end
        obj[prop] = s
    end
    apply()
    if type(value) == "table" then
        table.insert(MeizuLibrary._LangObjs, {Object = obj, Apply = apply})
    end
end

local function OnLangChange(fn)
    table.insert(MeizuLibrary._LangHooks, fn)
end

-- Chuỗi tìm kiếm gom cả 2 ngôn ngữ
local function SearchText(v)
    if type(v) == "table" then
        local parts = {}
        for _, s in pairs(v) do table.insert(parts, tostring(s)) end
        return string.lower(table.concat(parts, " "))
    end
    return string.lower(tostring(v or ""))
end

-- Viết hoa chỉ khi chuỗi thuần ASCII (tránh vỡ dấu tiếng Việt)
local function UpperSafe(s)
    if string.find(s, "[\128-\255]") then return s end
    return string.upper(s)
end

local function PrefPath() return MeizuLibrary.Folder .. "/language.txt" end

local function LoadLangPref()
    if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then return nil end
    local ok, v = pcall(function()
        if isfile(PrefPath()) then return readfile(PrefPath()) end
        return nil
    end)
    if ok and type(v) == "string" then
        local code = v:match("^%s*(%a+)%s*$")
        if code == "vi" or code == "en" then return code end
    end
    return nil
end

local function SaveLangPref(code)
    if typeof(writefile) ~= "function" then return end
    pcall(function()
        if typeof(isfolder) == "function" and typeof(makefolder) == "function" and not isfolder(MeizuLibrary.Folder) then
            makefolder(MeizuLibrary.Folder)
        end
        writefile(PrefPath(), code)
    end)
end

--// ============================ THEMES ============================
MeizuLibrary.Themes = {
    Dark = {
        Window = Color3.fromRGB(18, 20, 28),   Sidebar = Color3.fromRGB(13, 15, 21),
        Tab = Color3.fromRGB(26, 29, 40),      Element = Color3.fromRGB(27, 30, 42),
        Stroke = Color3.fromRGB(45, 50, 66),   Track = Color3.fromRGB(45, 50, 66),
        Text = Color3.fromRGB(240, 242, 248),  SubText = Color3.fromRGB(148, 153, 168),
        Placeholder = Color3.fromRGB(105, 110, 125),
        Input = Color3.fromRGB(21, 24, 33),    Dropdown = Color3.fromRGB(21, 24, 33),
        ToggleOff = Color3.fromRGB(52, 57, 73),
        Overlay = Color3.fromRGB(8, 9, 13),    Notification = Color3.fromRGB(25, 28, 38),
    },
    Light = {
        Window = Color3.fromRGB(246, 247, 251), Sidebar = Color3.fromRGB(238, 240, 246),
        Tab = Color3.fromRGB(255, 255, 255),    Element = Color3.fromRGB(255, 255, 255),
        Stroke = Color3.fromRGB(215, 219, 230), Track = Color3.fromRGB(210, 215, 227),
        Text = Color3.fromRGB(35, 38, 48),      SubText = Color3.fromRGB(120, 126, 142),
        Placeholder = Color3.fromRGB(160, 165, 180),
        Input = Color3.fromRGB(243, 244, 250),  Dropdown = Color3.fromRGB(250, 251, 253),
        ToggleOff = Color3.fromRGB(205, 210, 222),
        Overlay = Color3.fromRGB(120, 125, 140), Notification = Color3.fromRGB(255, 255, 255),
    },
    Midnight = {
        Window = Color3.fromRGB(15, 19, 32),   Sidebar = Color3.fromRGB(11, 14, 25),
        Tab = Color3.fromRGB(22, 27, 45),      Element = Color3.fromRGB(23, 28, 47),
        Stroke = Color3.fromRGB(40, 48, 78),   Track = Color3.fromRGB(42, 50, 80),
        Text = Color3.fromRGB(232, 238, 255),  SubText = Color3.fromRGB(140, 150, 185),
        Placeholder = Color3.fromRGB(100, 110, 140),
        Input = Color3.fromRGB(17, 21, 36),    Dropdown = Color3.fromRGB(17, 21, 36),
        ToggleOff = Color3.fromRGB(48, 56, 88),
        Overlay = Color3.fromRGB(6, 8, 14),    Notification = Color3.fromRGB(21, 26, 44),
    },
    Void = {
        Window = Color3.fromRGB(10, 10, 12),   Sidebar = Color3.fromRGB(7, 7, 9),
        Tab = Color3.fromRGB(16, 16, 19),      Element = Color3.fromRGB(16, 16, 20),
        Stroke = Color3.fromRGB(32, 32, 38),   Track = Color3.fromRGB(34, 34, 42),
        Text = Color3.fromRGB(235, 235, 240),  SubText = Color3.fromRGB(130, 130, 140),
        Placeholder = Color3.fromRGB(90, 90, 100),
        Input = Color3.fromRGB(13, 13, 16),    Dropdown = Color3.fromRGB(13, 13, 16),
        ToggleOff = Color3.fromRGB(40, 40, 48),
        Overlay = Color3.fromRGB(0, 0, 0),     Notification = Color3.fromRGB(14, 14, 18),
    },
}

--// ============================ HELPERS ============================
local function T(key)
    local theme = MeizuLibrary.Themes[MeizuLibrary.Theme]
    return (theme and theme[key]) or Color3.fromRGB(255, 255, 255)
end

local function Shade(color, mult)
    mult = mult or 1
    if mult >= 1 then
        return color:Lerp(Color3.new(1, 1, 1), math.min(mult - 1, 1))
    end
    return color:Lerp(Color3.new(0, 0, 0), 1 - mult)
end

local ClassDefaults = {
    Frame          = {BorderSizePixel = 0},
    CanvasGroup    = {BorderSizePixel = 0},
    ScrollingFrame = {BorderSizePixel = 0},
    TextLabel      = {BorderSizePixel = 0, Text = ""},
    TextButton     = {BorderSizePixel = 0, AutoButtonColor = false, Text = ""},
    TextBox        = {BorderSizePixel = 0},
    ImageLabel     = {BorderSizePixel = 0},
    ImageButton    = {BorderSizePixel = 0, AutoButtonColor = false},
}

local function New(class, props, children)
    local obj = Instance.new(class)
    local defaults = ClassDefaults[class]
    if defaults then
        for k, v in pairs(defaults) do obj[k] = v end
    end
    local parent = nil
    if props then
        for k, v in pairs(props) do
            if k == "Parent" then parent = v else obj[k] = v end
        end
    end
    if children then
        for _, c in ipairs(children) do c.Parent = obj end
    end
    if parent then obj.Parent = parent end
    return obj
end

local function Tween(obj, time, props, style, dir)
    local tween = TweenService:Create(obj,
        TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
        props)
    tween:Play()
    return tween
end

local function Register(obj, map)
    local theme = MeizuLibrary.Themes[MeizuLibrary.Theme]
    if theme then
        for prop, key in pairs(map) do
            if theme[key] then obj[prop] = theme[key] end
        end
    end
    table.insert(MeizuLibrary._ThemeObjs, {Object = obj, Map = map})
end

local function RegisterAccent(obj, prop, mult)
    mult = mult or 1
    obj[prop] = Shade(MeizuLibrary.Accent, mult)
    table.insert(MeizuLibrary._AccentObjs, {Object = obj, Prop = prop, Mult = mult})
end

local function OnThemeChange(fn)
    table.insert(MeizuLibrary._ThemeHooks, fn)
end

local function SafeCall(fn, ...)
    if type(fn) ~= "function" then return end
    local args = {...}
    local n = select("#", ...)
    task.spawn(function()
        local ok, err = pcall(fn, unpack(args, 1, n))
        if not ok then warn("[MeizuLibrary] Callback error: " .. tostring(err)) end
    end)
end

local function IsPointer(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
end

local function Ripple(parent, x, y)
    if not parent or not parent.Parent then return end
    local size = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.4
    local circle = New("Frame", {
        Name = "Ripple",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, x, 0, y),
        Size = UDim2.fromOffset(0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.8,
        ZIndex = 50,
        Parent = parent,
    })
    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = circle})
    Tween(circle, 0.6, {Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1}, Enum.EasingStyle.Quad)
    task.delay(0.65, function() if circle then circle:Destroy() end end)
end

-- Hiệu ứng nhấn: thẻ co nhẹ rồi bật lại mượt
local function AddPress(card)
    local sc = New("UIScale", {Scale = 1, Parent = card})
    local function release()
        Tween(sc, 0.35, {Scale = 1}, Enum.EasingStyle.Back)
    end
    card.InputBegan:Connect(function(input)
        if IsPointer(input) then
            Tween(sc, 0.09, {Scale = 0.985}, Enum.EasingStyle.Quad)
        end
    end)
    card.InputEnded:Connect(function(input)
        if IsPointer(input) then release() end
    end)
    card.MouseLeave:Connect(release)
    return sc
end

local function MakeDraggable(handle, target)
    local dragging = false
    local dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if IsPointer(input) then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    table.insert(MeizuLibrary._Connections, UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))
end

local function PlaySound(id, volume, speed)
    if not MeizuLibrary.SoundEnabled then return end
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = id or "rbxasset://sounds/electronicpingshort.wav"
        s.Volume = volume or 0.3
        s.PlaybackSpeed = speed or 1
        s.Parent = game:GetService("SoundService")
        s:Play()
        task.delay(3, function() if s then s:Destroy() end end)
    end)
end

-- Đo chiều cao text khi wrap (thay cho AutomaticSize — fix lỗi Android)
local function MeasureTextHeight(text, font, size, width)
    local ok, res = pcall(function()
        return TextService:GetTextSize(tostring(text), size, font, Vector2.new(width, 10000))
    end)
    if ok and res then
        return math.max(math.ceil(res.Y), size)
    end
    return size
end

local function Serialize(v)
    if typeof(v) == "Color3" then
        return {__color = true, R = v.R, G = v.G, B = v.B}
    end
    return v
end

local function Deserialize(v)
    if type(v) == "table" and v.__color then
        return Color3.new(v.R, v.G, v.B)
    end
    return v
end

local function CreateScreenGui()
    local gui
    local ok = pcall(function()
        local parent = (gethui and gethui()) or game:GetService("CoreGui")
        gui = Instance.new("ScreenGui")
        gui.Name = "MeizuLibrary_" .. tostring(math.random(100000, 999999))
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.DisplayOrder = 9999
        if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
        gui.Parent = parent
    end)
    if not ok or not gui or not gui.Parent then
        if gui then pcall(function() gui:Destroy() end) end
        gui = Instance.new("ScreenGui")
        gui.Name = "MeizuLibrary"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.DisplayOrder = 9999
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    return gui
end

--// ==================== DRAG PIPELINE (fix kéo trên mobile) ====================
local function FindScrollAncestor(obj)
    local p = obj and obj.Parent
    while p and p ~= game do
        if p:IsA("ScrollingFrame") then return p end
        p = p.Parent
    end
    return nil
end

local function BeginGuard(card)
    local sf = FindScrollAncestor(card)
    if not sf then return function() end end
    sf.ScrollingEnabled = false
    return function()
        if sf and sf.Parent then sf.ScrollingEnabled = true end
    end
end

local function EnsureDragPipeline()
    if MeizuLibrary._DragPipelineInit then return end
    MeizuLibrary._DragPipelineInit = true
    table.insert(MeizuLibrary._Connections, UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        for _, h in ipairs(MeizuLibrary._ActiveDrags) do
            pcall(h.OnChanged, input)
        end
    end))
    table.insert(MeizuLibrary._Connections, UserInputService.InputEnded:Connect(function(input)
        if IsPointer(input) then
            local drags = MeizuLibrary._ActiveDrags
            MeizuLibrary._ActiveDrags = {}
            for _, h in ipairs(drags) do pcall(h.OnEnd, input) end
        end
    end))
end

local function AddDrag(handlers)
    EnsureDragPipeline()
    table.insert(MeizuLibrary._ActiveDrags, handlers)
end

--// ==================== LOGO CỐ ĐỊNH (tải 1 lần, dùng cho loader + nút nổi) ====================
local LogoState = {Asset = "", Ready = false, Started = false, Listeners = {}}

local function IsPng(data)
    return type(data) == "string" and #data > 100 and data:sub(2, 4) == "PNG"
end

-- Tải PNG -> lưu file -> getcustomasset. Trả "" nếu executor không hỗ trợ / lỗi mạng
local function FetchLogo()
    local getAsset = getcustomasset or getsynasset
    if typeof(getAsset) ~= "function" or typeof(writefile) ~= "function" then
        return ""
    end
    local folder = MeizuLibrary.Folder
    local path = folder .. "/meizuxp.png"
    local ok, result = pcall(function()
        if typeof(isfolder) == "function" and typeof(makefolder) == "function" and not isfolder(folder) then
            makefolder(folder)
        end
        -- Dùng lại file đã tải nếu còn hợp lệ
        if typeof(isfile) == "function" and typeof(readfile) == "function" and isfile(path) then
            local cached = readfile(path)
            if IsPng(cached) then return getAsset(path) end
        end
        local data
        local okGet, body = pcall(game.HttpGet, game, LOGO_URL)
        if okGet and IsPng(body) then
            data = body
        else
            local req = request or http_request or (syn and syn.request)
            if req then
                local res = req({Url = LOGO_URL, Method = "GET"})
                if res and IsPng(res.Body) then data = res.Body end
            end
        end
        if not data then error("Tải logo thất bại") end
        writefile(path, data)
        return getAsset(path)
    end)
    if ok and type(result) == "string" and result ~= "" then
        return result
    end
    return ""
end

local function StartLogoLoad()
    if LogoState.Started then return end
    LogoState.Started = true
    task.spawn(function()
        LogoState.Asset = FetchLogo()
        LogoState.Ready = true
        for _, fn in ipairs(LogoState.Listeners) do pcall(fn, LogoState.Asset) end
        LogoState.Listeners = {}
    end)
end

local function OnLogo(fn)
    if LogoState.Ready then
        task.spawn(fn, LogoState.Asset)
    else
        table.insert(LogoState.Listeners, fn)
    end
end

StartLogoLoad() -- bắt đầu tải ngầm ngay khi nạp thư viện

--// ============================ NOTIFICATIONS ============================
MeizuLibrary.Notify = function(a, b, c)
    local cfg, dur
    if a == MeizuLibrary then cfg, dur = b, c else cfg, dur = a, b end
    if type(cfg) == "string" or (type(cfg) == "table" and cfg.Title == nil and cfg.Content == nil and (cfg.vi or cfg.en)) then
        cfg = {Content = cfg, Duration = tonumber(dur)}
    end
    cfg = cfg or {}

    local ScreenGui = MeizuLibrary._ScreenGui
    if not ScreenGui or MeizuLibrary.Destroyed then return end

    local holder = MeizuLibrary._NotifHolder
    if not holder or not holder.Parent then
        holder = New("Frame", {
            Name = "Notifications",
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -14, 0, 14),
            Size = UDim2.fromOffset(320, 800),
            ZIndex = 200,
            Parent = ScreenGui,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Parent = holder,
        })
        MeizuLibrary._NotifHolder = holder
    end

    MeizuLibrary._NotifCount = MeizuLibrary._NotifCount + 1

    local title = Resolve(cfg.Title ~= nil and cfg.Title or S("notification"))
    local content = cfg.Content ~= nil and Resolve(cfg.Content) or nil

    -- Tính kích thước thủ công
    local WIDTH = 300
    local PAD_T, PAD_B, PAD_L, PAD_R = 12, 14, 14, 10
    local textW = WIDTH - PAD_L - 6 - PAD_R
    local titleH = 16
    local contentH = 0
    if content then
        contentH = math.min(MeasureTextHeight(content, Enum.Font.Gotham, 12, textW) + 2, 96)
    end
    local cardH = PAD_T + titleH + (content and (5 + contentH) or 0) + PAD_B + 3

    -- Wrap cao hơn card 8px (làm khoảng cách) -> khi đóng thì co lại mượt, không bị giật
    local Wrap = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(WIDTH, cardH + 8),
        LayoutOrder = -MeizuLibrary._NotifCount,
        ZIndex = 200,
        Parent = holder,
    })

    local Card = New("CanvasGroup", {
        BackgroundColor3 = T("Notification"),
        Size = UDim2.fromOffset(WIDTH, cardH),
        Position = UDim2.fromOffset(70, 0),
        GroupTransparency = 1,
        ZIndex = 200,
        Parent = Wrap,
    })
    Register(Card, {BackgroundColor3 = "Notification"})
    New("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Card})
    local CardStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.4, Parent = Card})
    Register(CardStroke, {Color = "Stroke"})
    local scale = New("UIScale", {Scale = 0.9, Parent = Card})

    local Bar = New("Frame", {
        BackgroundColor3 = MeizuLibrary.Accent,
        Position = UDim2.new(0, 0, 0, PAD_T),
        Size = UDim2.new(0, 3, 0, cardH - PAD_T - PAD_B),
        ZIndex = 201, Parent = Card,
    })
    RegisterAccent(Bar, "BackgroundColor3")
    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Bar})

    local NTitle = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, PAD_L + 6, 0, PAD_T),
        Size = UDim2.new(1, -(PAD_L + 6 + PAD_R + 22), 0, titleH),
        Font = Enum.Font.GothamBold, TextSize = 13,
        TextColor3 = T("Text"), TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Text = title,
        ZIndex = 201, Parent = Card,
    })
    Register(NTitle, {TextColor3 = "Text"})

    local NClose = New("TextButton", {
        Text = "X", BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -6, 0, PAD_T - 2),
        Size = UDim2.fromOffset(22, 20),
        Font = Enum.Font.GothamBold, TextSize = 12,
        TextColor3 = T("SubText"), ZIndex = 201, Parent = Card,
    })
    Register(NClose, {TextColor3 = "SubText"})
    NClose.MouseEnter:Connect(function() Tween(NClose, 0.15, {TextColor3 = T("Text")}) end)
    NClose.MouseLeave:Connect(function() Tween(NClose, 0.2, {TextColor3 = T("SubText")}) end)

    if content then
        local NContent = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, PAD_L + 6, 0, PAD_T + titleH + 5),
            Size = UDim2.new(1, -(PAD_L + 6 + PAD_R), 0, contentH),
            Font = Enum.Font.Gotham, TextSize = 12,
            TextColor3 = T("SubText"),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true, RichText = true,
            Text = content, ZIndex = 201, Parent = Card,
        })
        Register(NContent, {TextColor3 = "SubText"})
    end

    local ProgTrack = New("Frame", {
        BackgroundColor3 = T("Track"), BackgroundTransparency = 0.5,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 3),
        ZIndex = 200, Parent = Card,
    })
    Register(ProgTrack, {BackgroundColor3 = "Track"})
    local ProgFill = New("Frame", {
        BackgroundColor3 = MeizuLibrary.Accent,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 3),
        ZIndex = 201, Parent = Card,
    })
    RegisterAccent(ProgFill, "BackgroundColor3")

    local closed = false
    local closer = {}
    local function Close()
        if closed then return end
        closed = true
        for i, e in ipairs(MeizuLibrary._Notifs) do
            if e == closer then table.remove(MeizuLibrary._Notifs, i) break end
        end
        Tween(Card, 0.28, {Position = UDim2.fromOffset(70, 0), GroupTransparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        Tween(scale, 0.28, {Scale = 0.92}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        task.delay(0.26, function()
            if not Wrap.Parent then return end
            local tw = Tween(Wrap, 0.25, {Size = UDim2.fromOffset(WIDTH, 0)}, Enum.EasingStyle.Quint)
            tw.Completed:Connect(function() if Wrap then Wrap:Destroy() end end)
            task.delay(0.5, function() if Wrap and Wrap.Parent then Wrap:Destroy() end end)
        end)
    end
    closer.Close = Close
    table.insert(MeizuLibrary._Notifs, closer)
    -- Giới hạn tối đa 6 thông báo cùng lúc
    while #MeizuLibrary._Notifs > 6 do
        local oldest = table.remove(MeizuLibrary._Notifs, 1)
        if oldest and oldest.Close then oldest.Close() end
    end
    NClose.Activated:Connect(Close)

    Tween(Card, 0.35, {GroupTransparency = 0})
    Tween(Card, 0.5, {Position = UDim2.fromOffset(0, 0)}, Enum.EasingStyle.Quint)
    Tween(scale, 0.45, {Scale = 1}, Enum.EasingStyle.Back)
    PlaySound("rbxasset://sounds/electronicpingshort.wav", 0.25, 1.15)

    local d = tonumber(cfg.Duration) or 5
    if d > 0 then
        Tween(ProgFill, d, {Size = UDim2.new(0, 0, 0, 3)}, Enum.EasingStyle.Linear)
        task.delay(d, Close)
    end
end

--// ============================ LIBRARY API ============================
function MeizuLibrary:ApplyTheme(name)
    local theme = self.Themes[name]
    if not theme then return end
    self.Theme = name
    for _, e in ipairs(self._ThemeObjs) do
        pcall(function()
            for prop, key in pairs(e.Map) do
                if theme[key] then e.Object[prop] = theme[key] end
            end
        end)
    end
    for _, fn in ipairs(self._ThemeHooks) do
        pcall(fn)
    end
end

function MeizuLibrary:ApplyAccent(color)
    self.Accent = color
    for _, e in ipairs(self._AccentObjs) do
        pcall(function() e.Object[e.Prop] = Shade(color, e.Mult or 1) end)
    end
end

function MeizuLibrary:SetRainbow(enabled)
    if enabled then
        if not self._RainbowConn then
            local t = 0
            self._RainbowConn = RunService.Heartbeat:Connect(function(dt)
                t = (t + dt * 0.35) % 1
                self:ApplyAccent(Color3.fromHSV(t, 0.65, 1))
            end)
        end
    else
        if self._RainbowConn then
            self._RainbowConn:Disconnect()
            self._RainbowConn = nil
        end
        self:ApplyAccent(self._UserAccent or Color3.fromRGB(88, 101, 242))
    end
end

function MeizuLibrary:GetLanguage()
    return self.Language
end

function MeizuLibrary:SetLanguage(code, silent)
    if code ~= "vi" and code ~= "en" then return false end
    self.Language = code
    for i = #self._LangObjs, 1, -1 do
        local e = self._LangObjs[i]
        if not e.Object or not e.Object.Parent then
            table.remove(self._LangObjs, i)
        else
            pcall(e.Apply)
        end
    end
    for _, fn in ipairs(self._LangHooks) do pcall(fn) end
    if not silent then SaveLangPref(code) end
    return true
end

function MeizuLibrary:SaveSettings(name)
    if typeof(writefile) ~= "function" then return false end
    name = tostring(name or "config")
    local data = {}
    for flag, el in pairs(self._FlagElems) do
        local ok, v = pcall(el.Get)
        if ok and type(v) ~= "function" then
            data[flag] = Serialize(v)
        end
    end
    local ok = pcall(function()
        if typeof(isfolder) == "function" and typeof(makefolder) == "function" and not isfolder(self.Folder) then
            makefolder(self.Folder)
        end
        writefile(self.Folder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    end)
    return ok
end

function MeizuLibrary:LoadSettings(name)
    if typeof(readfile) ~= "function" then return false end
    name = tostring(name or "config")
    local okR, content = pcall(readfile, self.Folder .. "/" .. name .. ".json")
    if not okR then return false end
    local okD, data = pcall(function() return HttpService:JSONDecode(content) end)
    if not okD or type(data) ~= "table" then return false end
    for flag, v in pairs(data) do
        local el = self._FlagElems[flag]
        if el then pcall(el.Set, Deserialize(v)) end
    end
    return true
end

function MeizuLibrary:Destroy()
    if self.Destroyed then return end
    self.Destroyed = true
    if self._RainbowConn then self._RainbowConn:Disconnect() self._RainbowConn = nil end
    for _, c in ipairs(self._Connections) do
        pcall(function() c:Disconnect() end)
    end
    self._Connections = {}
    self._ActiveDrags = {}
    self._DragPipelineInit = false -- FIX: cho phép kéo slider/colorpicker sau khi tạo lại UI
    if self._ScreenGui then
        pcall(function() self._ScreenGui:Destroy() end)
        self._ScreenGui = nil
    end
    self._ThemeObjs, self._AccentObjs, self._ThemeHooks, self._FlagElems = {}, {}, {}, {}
    self._LangObjs, self._LangHooks, self._Notifs = {}, {}, {}
    self._NotifHolder = nil
    self._Window = nil
end

--// ============================ CREATE WINDOW ============================
MeizuLibrary.CreateWindow = function(a, b)
    local config
    if a == MeizuLibrary then config = b else config = a end
    config = config or {}

    if MeizuLibrary._ScreenGui then MeizuLibrary:Destroy() end
    MeizuLibrary.Destroyed = false
    MeizuLibrary._Gen = MeizuLibrary._Gen + 1
    local gen = MeizuLibrary._Gen

    local Window = {_Tabs = {}, _UserTabs = {}, _CurrentTab = nil, _ReadyCbs = {}, _Ready = false, _SwitchToken = 0, _OpenToken = 0}
    MeizuLibrary._Window = Window

    local ScreenGui = CreateScreenGui()
    MeizuLibrary._ScreenGui = ScreenGui

    local function Alive()
        return MeizuLibrary._Gen == gen and not MeizuLibrary.Destroyed and MeizuLibrary._ScreenGui == ScreenGui
    end

    -- Ngôn ngữ: ưu tiên lựa chọn đã lưu > config > mặc định Tiếng Việt
    local savedLang = LoadLangPref()
    if savedLang then
        MeizuLibrary.Language = savedLang
    elseif config.Language == "vi" or config.Language == "en" then
        MeizuLibrary.Language = config.Language
    end

    if config.Theme and MeizuLibrary.Themes[config.Theme] then MeizuLibrary.Theme = config.Theme end
    if typeof(config.Accent) == "Color3" then
        MeizuLibrary.Accent = config.Accent
        MeizuLibrary._UserAccent = config.Accent
    end
    if config.ToggleKeybind then MeizuLibrary.ToggleKeybind = config.ToggleKeybind end

    StartLogoLoad()

    local WinSize = config.Size or UDim2.fromOffset(600, 430)
    local W, H = WinSize.X.Offset, WinSize.Y.Offset
    local vp = ScreenGui.AbsoluteSize
    if vp.X > 0 and vp.Y > 0 then
        W = math.min(W, vp.X - 24)
        H = math.min(H, vp.Y - 24)
    end
    W = math.max(W, 420)
    H = math.max(H, 280)
    local SIDEBAR_W = (W < 520) and 150 or 185

    local isOpen = false
    local SetToggleVisual -- gán ở phần nút nổi

    -- Root (trong suốt) chứa bóng đổ + cửa sổ -> bóng không bị CanvasGroup cắt
    local Root = New("Frame", {
        Name = "Root",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(W, H),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = ScreenGui,
    })
    local MainScale = New("UIScale", {Scale = 0.92, Parent = Root})

    local Shadow = New("ImageLabel", {
        Name = "Shadow", BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 80, 1, 80),
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = 0, Parent = Root,
    })

    local Main = New("CanvasGroup", {
        Name = "Main",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = T("Window"),
        GroupTransparency = 1,
        ZIndex = 1,
        Parent = Root,
    })
    Register(Main, {BackgroundColor3 = "Window"})
    New("UICorner", {CornerRadius = UDim.new(0, 14), Parent = Main})
    local MainStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.3, Parent = Main})
    Register(MainStroke, {Color = "Stroke"})

    local Sidebar = New("Frame", {
        Name = "Sidebar", BackgroundColor3 = T("Sidebar"),
        Size = UDim2.new(0, SIDEBAR_W, 1, 0), Parent = Main,
    })
    Register(Sidebar, {BackgroundColor3 = "Sidebar"})
    New("UICorner", {CornerRadius = UDim.new(0, 14), Parent = Sidebar})

    local Content = New("Frame", {
        Name = "Content", BackgroundColor3 = T("Window"),
        Position = UDim2.new(0, SIDEBAR_W - 14, 0, 0),
        Size = UDim2.new(1, -SIDEBAR_W + 14, 1, 0),
        Parent = Main,
    })
    Register(Content, {BackgroundColor3 = "Window"})
    New("UICorner", {CornerRadius = UDim.new(0, 14), Parent = Content})

    local TitleLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 10),
        Size = UDim2.new(1, -24, 0, 20),
        Font = Enum.Font.GothamBold, TextSize = 17,
        TextColor3 = T("Text"), TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = Sidebar,
    })
    BindText(TitleLabel, "Text", config.Title or "Meizu Library")
    Register(TitleLabel, {TextColor3 = "Text"})
    local SubLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 32),
        Size = UDim2.new(1, -24, 0, 14),
        Font = Enum.Font.Gotham, TextSize = 11,
        TextColor3 = T("SubText"), TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = Sidebar,
    })
    BindText(SubLabel, "Text", config.SubTitle or ("v" .. MeizuLibrary.Version))
    Register(SubLabel, {TextColor3 = "SubText"})

    local SearchBox = New("TextBox", {
        Position = UDim2.new(0, 14, 0, 56),
        Size = UDim2.new(1, -28, 0, 30),
        BackgroundColor3 = T("Input"),
        Text = "",
        PlaceholderColor3 = T("Placeholder"),
        TextColor3 = T("Text"),
        Font = Enum.Font.Gotham, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = Sidebar,
    })
    BindText(SearchBox, "PlaceholderText", S("search_placeholder"))
    Register(SearchBox, {BackgroundColor3 = "Input", PlaceholderColor3 = "Placeholder", TextColor3 = "Text"})
    New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = SearchBox})
    New("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = SearchBox})
    local SearchStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 1, Parent = SearchBox})
    SearchBox.Focused:Connect(function()
        Tween(SearchStroke, 0.2, {Color = MeizuLibrary.Accent, Transparency = 0.2})
    end)
    SearchBox.FocusLost:Connect(function()
        Tween(SearchStroke, 0.25, {Transparency = 1})
    end)

    local TabsHolder = New("ScrollingFrame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 96),
        Size = UDim2.new(1, -20, 1, -150),
        ScrollBarThickness = 2,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = Sidebar,
    })
    RegisterAccent(TabsHolder, "ScrollBarImageColor3")
    New("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = TabsHolder})

    local PlayerCard = New("Frame", {
        Position = UDim2.new(0, 10, 1, -46),
        Size = UDim2.new(1, -20, 0, 38),
        BackgroundColor3 = T("Element"),
        Parent = Sidebar,
    })
    Register(PlayerCard, {BackgroundColor3 = "Element"})
    New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = PlayerCard})
    local Avatar = New("ImageLabel", {
        BackgroundColor3 = T("Tab"),
        Position = UDim2.new(0, 5, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.fromOffset(28, 28), Parent = PlayerCard,
    })
    Register(Avatar, {BackgroundColor3 = "Tab"})
    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Avatar})
    task.spawn(function()
        local ok, thumb = pcall(function()
            return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        end)
        if ok and Avatar.Parent then Avatar.Image = thumb end
    end)
    local PName = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 40, 0, 0),
        Size = UDim2.new(1, -48, 1, 0),
        Font = Enum.Font.GothamBold, TextSize = 12,
        TextColor3 = T("Text"), TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Text = LocalPlayer.DisplayName,
        Parent = PlayerCard,
    })
    Register(PName, {TextColor3 = "Text"})

    local function CircleBtn(xoff)
        local btn = New("TextButton", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, xoff, 0, 10),
            Size = UDim2.fromOffset(22, 22),
            ZIndex = 40, Parent = Main,
        })
        Register(btn, {BackgroundColor3 = "Tab"})
        New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = btn})
        local sc = New("UIScale", {Scale = 1, Parent = btn})
        btn.MouseEnter:Connect(function()
            Tween(btn, 0.15, {BackgroundTransparency = 0.3})
            Tween(sc, 0.2, {Scale = 1.1}, Enum.EasingStyle.Back)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, 0.2, {BackgroundTransparency = 1})
            Tween(sc, 0.25, {Scale = 1})
        end)
        btn.InputBegan:Connect(function(i) if IsPointer(i) then Tween(sc, 0.08, {Scale = 0.9}) end end)
        btn.InputEnded:Connect(function(i) if IsPointer(i) then Tween(sc, 0.25, {Scale = 1.05}, Enum.EasingStyle.Back) end end)
        return btn
    end
    local MinBtn = CircleBtn(-62)
    local MinBar = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(0, 8, 0, 2), BackgroundColor3 = T("SubText"),
        ZIndex = 41, Parent = MinBtn,
    })
    Register(MinBar, {BackgroundColor3 = "SubText"})
    local CloseBtn = CircleBtn(-34)
    for _, rot in ipairs({45, -45}) do
        local l = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(0, 10, 0, 2), Rotation = rot,
            BackgroundColor3 = T("SubText"), ZIndex = 41, Parent = CloseBtn,
        })
        Register(l, {BackgroundColor3 = "SubText"})
    end

    -- Vùng kéo cửa sổ: thanh trên của sidebar + thanh trên của nội dung
    local DragHandle = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, SIDEBAR_W, 0, 54),
        Parent = Main,
    })
    MakeDraggable(DragHandle, Root)
    local DragHandle2 = New("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, SIDEBAR_W, 0, 0),
        Size = UDim2.new(1, -SIDEBAR_W, 0, 36),
        Parent = Main,
    })
    MakeDraggable(DragHandle2, Root)

    local TabContainer = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Parent = Content,
    })

    --// ==================== ELEMENT FACTORY ====================
    local function BindElements(target, container, tab)
        if target.CreateSection then return end

        local function MakeCard(height, interactive)
            local Card
            if interactive then
                Card = New("TextButton", {
                    BackgroundColor3 = T("Element"),
                    Size = UDim2.new(1, 0, 0, height),
                    ClipsDescendants = true,
                    Parent = container,
                })
            else
                Card = New("Frame", {
                    BackgroundColor3 = T("Element"),
                    Size = UDim2.new(1, 0, 0, height),
                    ClipsDescendants = true,
                    Parent = container,
                })
            end
            New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Card})
            local Stroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.4, Parent = Card})
            Register(Card, {BackgroundColor3 = "Element"})
            Register(Stroke, {Color = "Stroke"})
            if interactive then
                local Hover = New("Frame", {
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.fromScale(1, 1),
                    ZIndex = 5, Parent = Card,
                })
                New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Hover})
                Card.MouseEnter:Connect(function()
                    Tween(Hover, 0.18, {BackgroundTransparency = 0.93})
                    Tween(Stroke, 0.2, {Transparency = 0.15})
                end)
                Card.MouseLeave:Connect(function()
                    Tween(Hover, 0.28, {BackgroundTransparency = 1})
                    Tween(Stroke, 0.3, {Transparency = 0.4})
                end)
                AddPress(Card)
            end
            return Card
        end

        local function AddText(Card, title, desc, rightSpace)
            rightSpace = rightSpace or 70
            local hasDesc = desc ~= nil
            local Title = New("TextLabel", {
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamMedium, TextSize = 13,
                TextColor3 = T("Text"),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = hasDesc and UDim2.new(0, 12, 0, 8) or UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -rightSpace, hasDesc and 0 or 1, hasDesc and 14 or 0),
                Parent = Card,
            })
            BindText(Title, "Text", title ~= nil and title or "")
            Register(Title, {TextColor3 = "Text"})
            if hasDesc then
                local Desc = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Enum.Font.Gotham, TextSize = 11,
                    TextColor3 = T("SubText"),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Position = UDim2.new(0, 12, 0, 24),
                    Size = UDim2.new(1, -rightSpace, 0, 12),
                    Parent = Card,
                })
                BindText(Desc, "Text", desc)
                Register(Desc, {TextColor3 = "SubText"})
            end
        end

        local function AddSearch(Card, text)
            table.insert(tab._Elements, {Frame = Card, Text = SearchText(text)})
        end

        local function BindFlag(el, flag, initial)
            if flag then
                MeizuLibrary._FlagElems[flag] = el
                MeizuLibrary.Flags[flag] = initial
            end
        end

        --// SECTION
        function target:CreateSection(name)
            local Sec = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = container,
            })
            New("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Sec})
            local Head = New("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), Parent = Sec})
            local Bar = New("Frame", {
                BackgroundColor3 = MeizuLibrary.Accent,
                Position = UDim2.new(0, 2, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 3, 0, 12),
                Parent = Head,
            })
            RegisterAccent(Bar, "BackgroundColor3")
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Bar})
            local SecLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 13, 0, 0),
                Size = UDim2.new(1, -13, 1, 0),
                Font = Enum.Font.GothamBold, TextSize = 11,
                TextColor3 = T("SubText"),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Head,
            })
            BindText(SecLabel, "Text", name ~= nil and name or "Section", UpperSafe)
            Register(SecLabel, {TextColor3 = "SubText"})
            local SectionObj = {}
            BindElements(SectionObj, Sec, tab)
            return SectionObj
        end

        --// BUTTON
        function target:CreateButton(cfg)
            cfg = cfg or {}
            local hasDesc = cfg.Description ~= nil
            local h = hasDesc and 54 or 40
            local Card = MakeCard(h, true)
            AddText(Card, cfg.Title or "Button", cfg.Description, 30)
            Card.InputBegan:Connect(function(input)
                if IsPointer(input) then
                    local pos = input.Position
                    Ripple(Card, pos.X - Card.AbsolutePosition.X, pos.Y - Card.AbsolutePosition.Y)
                end
            end)
            Card.Activated:Connect(function() SafeCall(cfg.Callback) end)
            AddSearch(Card, cfg.Title)
            return {Frame = Card}
        end

        --// TOGGLE
        function target:CreateToggle(cfg)
            cfg = cfg or {}
            local hasDesc = cfg.Description ~= nil
            local h = hasDesc and 54 or 40
            local Card = MakeCard(h, true)
            AddText(Card, cfg.Title or "Toggle", cfg.Description, 70)

            local Track = New("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(42, 22),
                BackgroundColor3 = T("ToggleOff"),
                Parent = Card,
            })
            Register(Track, {BackgroundColor3 = "ToggleOff"})
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Track})
            local Knob = New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 3, 0.5, 0),
                Size = UDim2.fromOffset(16, 16),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = Track,
            })
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Knob})

            local state = (cfg.Default == true)
            local function Render(v, instant)
                if not Track.Parent then return end
                local goal = v and 23 or 3
                if instant then
                    Track.BackgroundColor3 = v and MeizuLibrary.Accent or T("ToggleOff")
                    Knob.Position = UDim2.new(0, goal, 0.5, 0)
                    Knob.Size = UDim2.fromOffset(16, 16)
                else
                    Tween(Track, 0.28, {BackgroundColor3 = v and MeizuLibrary.Accent or T("ToggleOff")})
                    Tween(Knob, 0.35, {Position = UDim2.new(0, goal, 0.5, 0), Size = UDim2.fromOffset(16, 16)}, Enum.EasingStyle.Back)
                end
            end
            local function Set(v, fire)
                v = (v == true)
                state = v
                Render(v)
                if cfg.Flag then MeizuLibrary.Flags[cfg.Flag] = v end
                if fire then SafeCall(cfg.Callback, v) end
            end

            -- Hiệu ứng nhấn: núm kéo dài (kiểu iOS)
            Card.InputBegan:Connect(function(input)
                if IsPointer(input) then
                    Tween(Knob, 0.12, {
                        Size = UDim2.fromOffset(21, 16),
                        Position = UDim2.new(0, state and 18 or 3, 0.5, 0),
                    }, Enum.EasingStyle.Quad)
                end
            end)
            Card.MouseLeave:Connect(function()
                if Knob.Size.X.Offset ~= 16 then Render(state) end
            end)
            Card.Activated:Connect(function() Set(not state, true) end)

            Render(state, true)
            OnThemeChange(function() Render(state, true) end)

            local el = {Frame = Card, Get = function() return state end, Set = function(v) Set(v, false) end}
            BindFlag(el, cfg.Flag, state)
            AddSearch(Card, cfg.Title)
            return el
        end

        --// SLIDER (kéo mượt trên mobile)
        function target:CreateSlider(cfg)
            cfg = cfg or {}
            local min, max = cfg.Min or 0, cfg.Max or 100
            if max <= min then max = min + 1 end
            local rounding = cfg.Rounding or 0
            local hasDesc = cfg.Description ~= nil
            local h = hasDesc and 64 or 50
            local Card = MakeCard(h, false)
            AddText(Card, cfg.Title or "Slider", cfg.Description, 90)

            local ValueLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -12, 0, hasDesc and 8 or 0),
                Size = UDim2.new(0, 70, hasDesc and 0 or 1, hasDesc and 14 or 0),
                Font = Enum.Font.GothamBold, TextSize = 12,
                TextColor3 = T("Text"), TextXAlignment = Enum.TextXAlignment.Right,
                Parent = Card,
            })
            Register(ValueLabel, {TextColor3 = "Text"})

            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 1, -(hasDesc and 18 or 16)),
                Size = UDim2.new(1, -24, 0, 12),
                Parent = Card,
            })
            local Track = New("Frame", {
                BackgroundColor3 = T("Track"),
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 0, 6),
                Parent = Holder,
            })
            Register(Track, {BackgroundColor3 = "Track"})
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Track})
            local Fill = New("Frame", {
                BackgroundColor3 = MeizuLibrary.Accent,
                Size = UDim2.new(0, 0, 1, 0), Parent = Track,
            })
            RegisterAccent(Fill, "BackgroundColor3")
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Fill})
            local Knob = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.fromOffset(14, 14),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = 3, Parent = Holder,
            })
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Knob})
            local KnobStroke = New("UIStroke", {Color = MeizuLibrary.Accent, Thickness = 2, Parent = Knob})
            RegisterAccent(KnobStroke, "Color")

            -- Vùng chạm lớn hơn thanh trượt (dễ bấm trên điện thoại)
            local Hit = New("TextButton", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, -8, 0, -12),
                Size = UDim2.new(1, 16, 1, 24),
                ZIndex = 6, Parent = Holder,
            })

            local value = cfg.Default or min
            local function Format(v)
                if rounding > 0 then return string.format("%." .. rounding .. "f", v) end
                return tostring(math.floor(v + 0.5))
            end
            local function Set(v, fire, animTime)
                v = math.clamp(tonumber(v) or min, min, max)
                value = v
                local pct = math.clamp((v - min) / (max - min), 0, 1)
                if animTime and animTime > 0 then
                    Tween(Fill, animTime, {Size = UDim2.new(pct, 0, 1, 0)}, Enum.EasingStyle.Quad)
                    Tween(Knob, animTime, {Position = UDim2.new(pct, 0, 0.5, 0)}, Enum.EasingStyle.Quad)
                else
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    Knob.Position = UDim2.new(pct, 0, 0.5, 0)
                end
                ValueLabel.Text = Format(v)
                if cfg.Flag then MeizuLibrary.Flags[cfg.Flag] = v end
                if fire then SafeCall(cfg.Callback, v) end
            end

            local dragging = false
            local releaseGuard = nil
            local function UpdateFromX(x)
                local pct = math.clamp((x - Track.AbsolutePosition.X) / math.max(Track.AbsoluteSize.X, 1), 0, 1)
                local v = min + (max - min) * pct
                if rounding == 0 then
                    v = math.floor(v + 0.5)
                else
                    v = tonumber(string.format("%." .. rounding .. "f", v))
                end
                Set(v, true, 0.07)
            end
            Hit.InputBegan:Connect(function(input)
                if IsPointer(input) then
                    dragging = true
                    releaseGuard = BeginGuard(Card)
                    Tween(Knob, 0.18, {Size = UDim2.fromOffset(18, 18)}, Enum.EasingStyle.Back)
                    UpdateFromX(input.Position.X)
                    AddDrag({
                        OnChanged = function(inp)
                            if dragging then UpdateFromX(inp.Position.X) end
                        end,
                        OnEnd = function()
                            dragging = false
                            if releaseGuard then releaseGuard() releaseGuard = nil end
                            Tween(Knob, 0.25, {Size = UDim2.fromOffset(14, 14)}, Enum.EasingStyle.Back)
                        end,
                    })
                end
            end)

            local el = {Frame = Card, Get = function() return value end, Set = function(v) Set(v, false, 0.3) end}
            Set(value, false, 0)
            BindFlag(el, cfg.Flag, value)
            AddSearch(Card, cfg.Title)
            return el
        end

        --// DROPDOWN / MULTI DROPDOWN
        local function MakeDropdown(cfg, multi)
            cfg = cfg or {}
            local options = cfg.Options or {}
            local hasDesc = cfg.Description ~= nil
            local headH = hasDesc and 54 or 40
            local Card = MakeCard(headH, true)
            AddText(Card, cfg.Title or "Dropdown", cfg.Description, 200)

            local SelectedLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -32, 0, hasDesc and 8 or 0),
                Size = UDim2.new(0, 160, hasDesc and 0 or 1, hasDesc and 14 or 0),
                Font = Enum.Font.Gotham, TextSize = 12,
                TextColor3 = T("SubText"),
                TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = Card,
            })
            Register(SelectedLabel, {TextColor3 = "SubText"})

            local Arrow = New("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(12, 12),
                BackgroundTransparency = 1, Parent = Card,
            })
            for i, rot in ipairs({-45, 45}) do
                local bar = New("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5 + (i == 1 and -0.18 or 0.18), 0, 0.5, 0),
                    Size = UDim2.fromOffset(2, 7),
                    Rotation = rot,
                    BackgroundColor3 = T("SubText"),
                    Parent = Arrow,
                })
                Register(bar, {BackgroundColor3 = "SubText"})
            end

            local open = false
            local listH = math.min(#options * 26 + 10, 150)
            local selected
            if multi then
                selected = {}
                if typeof(cfg.Default) == "table" then
                    for _, v in ipairs(cfg.Default) do selected[v] = true end
                end
            else
                selected = cfg.Default
            end

            local List = New("ScrollingFrame", {
                BackgroundColor3 = T("Dropdown"),
                BackgroundTransparency = 0,
                Position = UDim2.new(0, 8, 0, headH + 2),
                Size = UDim2.new(1, -16, 0, 0),
                CanvasSize = UDim2.new(),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 3, ScrollBarImageTransparency = 0.4,
                Visible = false, ClipsDescendants = true,
                ZIndex = 8, Parent = Card,
            })
            Register(List, {BackgroundColor3 = "Dropdown"})
            New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = List})
            New("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = List})
            New("UIPadding", {
                PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = List})

            local OptionBtns = {}
            local SetOpen, Refresh

            local function GetSelected()
                if multi then
                    local list = {}
                    for k in pairs(selected) do table.insert(list, k) end
                    table.sort(list)
                    return list
                end
                return selected
            end

            SetOpen = function(v)
                if not Card.Parent then return end
                open = v
                List.Visible = true
                Tween(Card, 0.32, {Size = UDim2.new(1, 0, 0, headH + (v and (listH + 6) or 0))}, Enum.EasingStyle.Quint)
                Tween(List, 0.32, {Size = UDim2.new(1, -16, 0, v and listH or 0)}, Enum.EasingStyle.Quint)
                Tween(Arrow, 0.3, {Rotation = v and 180 or 0}, Enum.EasingStyle.Back)
                if v then
                    for i, Opt in ipairs(OptionBtns) do
                        Opt.TextTransparency = 1
                        task.delay(0.03 + i * 0.025, function()
                            if Opt.Parent then Tween(Opt, 0.2, {TextTransparency = 0}) end
                        end)
                    end
                else
                    task.delay(0.34, function()
                        if not open and List.Parent then List.Visible = false end
                    end)
                end
            end

            Refresh = function(fire)
                if not Card.Parent then return end
                if multi then
                    local list = {}
                    for k in pairs(selected) do table.insert(list, tostring(k)) end
                    table.sort(list)
                    SelectedLabel.Text = (#list > 0) and table.concat(list, ", ") or Resolve(S("none_selected"))
                    for _, Opt in ipairs(OptionBtns) do
                        local isSel = selected[Opt.Text] == true
                        local d = Opt:FindFirstChild("Dot")
                        if d then
                            Tween(d, 0.25, {
                                BackgroundTransparency = isSel and 0 or 1,
                                Size = UDim2.fromOffset(isSel and 12 or 6, isSel and 12 or 6),
                            }, Enum.EasingStyle.Back)
                        end
                    end
                else
                    SelectedLabel.Text = selected and tostring(selected) or Resolve(S("select_placeholder"))
                    for _, Opt in ipairs(OptionBtns) do
                        local isSel = Opt.Text == tostring(selected)
                        Tween(Opt, 0.2, {TextColor3 = isSel and MeizuLibrary.Accent or T("Text")})
                    end
                end
                if cfg.Flag then MeizuLibrary.Flags[cfg.Flag] = GetSelected() end
                if fire then SafeCall(cfg.Callback, GetSelected()) end
            end

            local function BuildOptions()
                for _, c in ipairs(OptionBtns) do c:Destroy() end
                OptionBtns = {}
                for i, optName in ipairs(options) do
                    local Opt = New("TextButton", {
                        Text = tostring(optName),
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Size = UDim2.new(1, 0, 0, 24),
                        Font = Enum.Font.Gotham, TextSize = 12,
                        TextColor3 = T("Text"),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 9, LayoutOrder = i, Parent = List,
                    })
                    New("UIPadding", {PaddingLeft = UDim.new(0, 8), Parent = Opt})
                    New("UICorner", {CornerRadius = UDim.new(0, 5), Parent = Opt})
                    if multi then
                        local Dot = New("Frame", {
                            Name = "Dot",
                            AnchorPoint = Vector2.new(1, 0.5),
                            Position = UDim2.new(1, -6, 0.5, 0),
                            Size = UDim2.fromOffset(6, 6),
                            BackgroundColor3 = MeizuLibrary.Accent,
                            BackgroundTransparency = 1,
                            ZIndex = 10, Parent = Opt,
                        })
                        RegisterAccent(Dot, "BackgroundColor3")
                        New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Dot})
                    end
                    Opt.MouseEnter:Connect(function() Tween(Opt, 0.12, {BackgroundTransparency = 0.92}) end)
                    Opt.MouseLeave:Connect(function() Tween(Opt, 0.22, {BackgroundTransparency = 1}) end)
                    Opt.Activated:Connect(function()
                        if multi then
                            if selected[optName] then selected[optName] = nil else selected[optName] = true end
                        else
                            selected = optName
                        end
                        Refresh(true)
                        if not multi then SetOpen(false) end
                    end)
                    table.insert(OptionBtns, Opt)
                end
            end

            Card.Activated:Connect(function() SetOpen(not open) end)
            BuildOptions()
            Refresh(false)
            OnThemeChange(function() Refresh(false) end)
            OnLangChange(function() Refresh(false) end)

            local el = {
                Frame = Card,
                Get = GetSelected,
                Set = function(v)
                    if multi then
                        selected = {}
                        if typeof(v) == "table" then
                            for _, x in ipairs(v) do selected[x] = true end
                        end
                    else
                        selected = v
                    end
                    Refresh(false)
                end,
            }
            BindFlag(el, cfg.Flag, GetSelected())
            AddSearch(Card, cfg.Title)
            return el
        end

        function target:CreateDropdown(cfg) return MakeDropdown(cfg, false) end
        function target:CreateMultiDropdown(cfg) return MakeDropdown(cfg, true) end

        --// KEYBIND
        function target:CreateKeybind(cfg)
            cfg = cfg or {}
            local hasDesc = cfg.Description ~= nil
            local h = hasDesc and 54 or 40
            local Card = MakeCard(h, false)
            AddText(Card, cfg.Title or "Keybind", cfg.Description, 120)

            local currentKey = cfg.Default
            local listening = false
            local BindBtn = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(90, 26),
                BackgroundColor3 = T("Input"),
                Font = Enum.Font.GothamMedium, TextSize = 12,
                TextColor3 = T("SubText"),
                Parent = Card,
            })
            Register(BindBtn, {BackgroundColor3 = "Input"})
            New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = BindBtn})
            local BindStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 1, Parent = BindBtn})
            local function KeyText()
                return currentKey and currentKey.Name or Resolve(S("key_none"))
            end
            BindBtn.Text = KeyText()
            OnLangChange(function() if not listening then BindBtn.Text = KeyText() end end)
            BindBtn.MouseEnter:Connect(function() Tween(BindBtn, 0.15, {TextColor3 = T("Text")}) end)
            BindBtn.MouseLeave:Connect(function() Tween(BindBtn, 0.2, {TextColor3 = T("SubText")}) end)

            BindBtn.Activated:Connect(function()
                if listening then return end
                listening = true
                BindBtn.Text = "..."
                Tween(BindStroke, 0.2, {Color = MeizuLibrary.Accent, Transparency = 0.1})
                local conn
                conn = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        conn:Disconnect()
                        listening = false
                        Tween(BindStroke, 0.25, {Transparency = 1})
                        if input.KeyCode ~= Enum.KeyCode.Escape then
                            currentKey = input.KeyCode
                            BindBtn.Text = currentKey.Name
                            if cfg.Flag then MeizuLibrary.Flags[cfg.Flag] = currentKey.Name end
                            SafeCall(cfg.ChangedCallback, currentKey)
                        else
                            BindBtn.Text = KeyText()
                        end
                    end
                end)
            end)

            local triggerConn = UserInputService.InputBegan:Connect(function(input, gp)
                if listening or gp then return end
                if UserInputService:GetFocusedTextBox() then return end
                if input.UserInputType == Enum.UserInputType.Keyboard and currentKey and input.KeyCode == currentKey then
                    SafeCall(cfg.Callback, currentKey)
                end
            end)
            table.insert(MeizuLibrary._Connections, triggerConn)

            local el = {
                Frame = Card,
                Get = function() return currentKey and currentKey.Name or "None" end,
                Set = function(v)
                    local key
                    if typeof(v) == "EnumItem" then
                        key = v
                    elseif type(v) == "string" then
                        pcall(function() key = Enum.KeyCode[v] end)
                    end
                    if key then
                        currentKey = key
                        BindBtn.Text = key.Name
                        if cfg.Flag then MeizuLibrary.Flags[cfg.Flag] = key.Name end
                        SafeCall(cfg.ChangedCallback, key)
                    end
                end,
            }
            BindFlag(el, cfg.Flag, el.Get())
            AddSearch(Card, cfg.Title)
            return el
        end

        --// INPUT
        function target:CreateInput(cfg)
            cfg = cfg or {}
            local hasDesc = cfg.Description ~= nil
            local h = hasDesc and 54 or 40
            local Card = MakeCard(h, false)
            AddText(Card, cfg.Title or "Input", cfg.Description, 200)

            local Box = New("TextBox", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(160, 26),
                BackgroundColor3 = T("Input"),
                Text = cfg.Default or "",
                PlaceholderColor3 = T("Placeholder"),
                TextColor3 = T("Text"),
                Font = Enum.Font.Gotham, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false, ClipsDescendants = true,
                Parent = Card,
            })
            BindText(Box, "PlaceholderText", cfg.Placeholder ~= nil and cfg.Placeholder or S("input_placeholder"))
            Register(Box, {BackgroundColor3 = "Input", PlaceholderColor3 = "Placeholder", TextColor3 = "Text"})
            New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Box})
            New("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = Box})
            local BoxStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 1, Parent = Box})

            if cfg.Numeric then
                Box:GetPropertyChangedSignal("Text"):Connect(function()
                    local t = string.gsub(Box.Text, "[^%d]", "")
                    if t ~= Box.Text then Box.Text = t end
                end)
            end

            local function Commit()
                if cfg.Flag then MeizuLibrary.Flags[cfg.Flag] = Box.Text end
                SafeCall(cfg.Callback, Box.Text)
            end
            Box.Focused:Connect(function()
                Tween(Box, 0.25, {Size = UDim2.fromOffset(180, 28)}, Enum.EasingStyle.Quint)
                Tween(BoxStroke, 0.2, {Color = MeizuLibrary.Accent, Transparency = 0.1})
            end)
            Box.FocusLost:Connect(function(enter)
                Tween(Box, 0.25, {Size = UDim2.fromOffset(160, 26)}, Enum.EasingStyle.Quint)
                Tween(BoxStroke, 0.25, {Transparency = 1})
                if enter then Commit() end
            end)

            local el = {Frame = Card, Get = function() return Box.Text end, Set = function(v) Box.Text = tostring(v) end}
            BindFlag(el, cfg.Flag, Box.Text)
            AddSearch(Card, cfg.Title)
            return el
        end

        --// COLOR PICKER (kéo được cả ô đậm/nhạt trên mọi thiết bị)
        function target:CreateColorPicker(cfg)
            cfg = cfg or {}
            local hasDesc = cfg.Description ~= nil
            local headH = hasDesc and 54 or 40
            local panelY = headH + 6
            local PANEL_H = 130
            local Card = MakeCard(headH, false)

            -- Header bấm mở/đóng (không đè panel màu)
            local Header = New("TextButton", {
                BackgroundTransparency = 1,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(1, 0, 0, headH),
                ZIndex = 2, Parent = Card,
            })
            New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Header})
            Header.MouseEnter:Connect(function() Tween(Header, 0.15, {BackgroundTransparency = 0.94}) end)
            Header.MouseLeave:Connect(function() Tween(Header, 0.25, {BackgroundTransparency = 1}) end)

            AddText(Card, cfg.Title or "Color", cfg.Description, 60)

            local h, s, v = Color3.toHSV(cfg.Default or MeizuLibrary.Accent)
            local color = Color3.fromHSV(h, s, v)

            local Swatch = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(34, 22),
                BackgroundColor3 = color,
                ZIndex = 3, Parent = Card,
            })
            New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Swatch})
            local SwStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.3, Parent = Swatch})
            Register(SwStroke, {Color = "Stroke"})

            local Panel = New("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, panelY),
                Size = UDim2.new(1, -24, 0, 0),
                Visible = false, ClipsDescendants = true,
                Parent = Card,
            })

            -- Ô SV (đậm/nhạt)
            local SV = New("Frame", {
                Size = UDim2.new(1, 0, 0, 84),
                BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                ClipsDescendants = true,
                Active = true, ZIndex = 3, Parent = Panel,
            })
            New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SV})
            local GW = New("Frame", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), Size = UDim2.fromScale(1, 1), ZIndex = 4, Parent = SV})
            New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = GW})
            New("UIGradient", {Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}), Parent = GW})
            local GB = New("Frame", {BackgroundColor3 = Color3.fromRGB(0, 0, 0), Size = UDim2.fromScale(1, 1), ZIndex = 5, Parent = SV})
            New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = GB})
            New("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}), Parent = GB})
            local SVKnob = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.fromOffset(10, 10),
                BackgroundTransparency = 1, ZIndex = 6, Parent = SV,
            })
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SVKnob})
            New("UIStroke", {Color = Color3.new(1, 1, 1), Thickness = 2, Parent = SVKnob})

            -- Thanh Hue (màu)
            local HueBar = New("Frame", {
                Position = UDim2.new(0, 0, 0, 92),
                Size = UDim2.new(1, 0, 0, 12),
                BackgroundColor3 = Color3.new(1, 1, 1),
                Active = true, ZIndex = 3, Parent = Panel,
            })
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = HueBar})
            New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
                }),
                Parent = HueBar,
            })
            local HueKnob = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(h, 0, 0.5, 0),
                Size = UDim2.fromOffset(4, 16),
                BackgroundColor3 = Color3.new(1, 1, 1),
                ZIndex = 4, Parent = HueBar,
            })
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = HueKnob})

            local function Apply(fire)
                color = Color3.fromHSV(h, s, v)
                SV.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                Swatch.BackgroundColor3 = color
                SVKnob.Position = UDim2.new(s, 0, 1 - v, 0)
                HueKnob.Position = UDim2.new(h, 0, 0.5, 0)
                if cfg.Flag then MeizuLibrary.Flags[cfg.Flag] = color end
                if fire then SafeCall(cfg.Callback, color) end
            end

            local draggingSV, draggingHue = false, false
            local releaseGuard = nil

            local function UpdateSV(pos)
                local rel = pos - SV.AbsolutePosition
                s = math.clamp(rel.X / math.max(SV.AbsoluteSize.X, 1), 0, 1)
                v = 1 - math.clamp(rel.Y / math.max(SV.AbsoluteSize.Y, 1), 0, 1)
                Apply(true)
            end
            local function UpdateHue(pos)
                h = math.clamp((pos.X - HueBar.AbsolutePosition.X) / math.max(HueBar.AbsoluteSize.X, 1), 0, 1)
                Apply(true)
            end

            local function StartDrag(kind, input)
                if not IsPointer(input) then return end
                if kind == "sv" then
                    draggingSV = true
                    UpdateSV(input.Position)
                else
                    draggingHue = true
                    UpdateHue(input.Position)
                end
                if not releaseGuard then
                    releaseGuard = BeginGuard(Card)
                    AddDrag({
                        OnChanged = function(inp)
                            if draggingSV then UpdateSV(inp.Position) end
                            if draggingHue then UpdateHue(inp.Position) end
                        end,
                        OnEnd = function()
                            draggingSV = false
                            draggingHue = false
                            if releaseGuard then releaseGuard() releaseGuard = nil end
                        end,
                    })
                end
            end

            SV.InputBegan:Connect(function(input) StartDrag("sv", input) end)
            GW.InputBegan:Connect(function(input) StartDrag("sv", input) end)
            GB.InputBegan:Connect(function(input) StartDrag("sv", input) end)
            HueBar.InputBegan:Connect(function(input) StartDrag("hue", input) end)

            -- Presets
            local presets = {
                Color3.fromRGB(255, 255, 255), Color3.fromRGB(180, 180, 190), Color3.fromRGB(30, 30, 35),
                Color3.fromRGB(255, 86, 86), Color3.fromRGB(255, 165, 60), Color3.fromRGB(255, 220, 90),
                Color3.fromRGB(90, 220, 120), Color3.fromRGB(88, 101, 242), Color3.fromRGB(170, 90, 255),
            }
            local PresetRow = New("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 112),
                Size = UDim2.new(1, 0, 0, 16),
                Parent = Panel,
            })
            New("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), Parent = PresetRow})
            for _, c in ipairs(presets) do
                local p = New("TextButton", {
                    Size = UDim2.fromOffset(16, 16),
                    BackgroundColor3 = c, ZIndex = 3, Parent = PresetRow,
                })
                New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = p})
                local psc = New("UIScale", {Scale = 1, Parent = p})
                p.MouseEnter:Connect(function() Tween(psc, 0.15, {Scale = 1.2}, Enum.EasingStyle.Back) end)
                p.MouseLeave:Connect(function() Tween(psc, 0.2, {Scale = 1}) end)
                p.Activated:Connect(function()
                    h, s, v = Color3.toHSV(c)
                    Apply(true)
                end)
            end

            local open = false
            local function TogglePanel()
                if not Card.Parent then return end
                open = not open
                Panel.Visible = true
                Tween(Card, 0.34, {Size = UDim2.new(1, 0, 0, open and (panelY + PANEL_H + 8) or headH)}, Enum.EasingStyle.Quint)
                Tween(Panel, 0.34, {Size = UDim2.new(1, -24, 0, open and PANEL_H or 0)}, Enum.EasingStyle.Quint)
                if not open then
                    task.delay(0.36, function()
                        if not open and Panel.Parent then Panel.Visible = false end
                    end)
                end
            end
            Header.Activated:Connect(TogglePanel)
            Swatch.Activated:Connect(TogglePanel)

            local el = {
                Frame = Card,
                Get = function() return color end,
                Set = function(c)
                    if typeof(c) == "Color3" then
                        h, s, v = Color3.toHSV(c)
                        Apply(false)
                    end
                end,
            }
            Apply(false)
            BindFlag(el, cfg.Flag, color)
            AddSearch(Card, cfg.Title)
            return el
        end

        --// PARAGRAPH
        function target:CreateParagraph(cfg)
            cfg = cfg or {}
            local Card = MakeCard(36, false)
            Card.Size = UDim2.new(1, 0, 0, 0)
            Card.AutomaticSize = Enum.AutomaticSize.Y
            New("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Card})
            New("UIPadding", {
                PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = Card})
            if cfg.Title ~= nil then
                local T1 = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Enum.Font.GothamBold, TextSize = 13,
                    TextColor3 = T("Text"),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    LayoutOrder = 1, Parent = Card,
                })
                BindText(T1, "Text", cfg.Title)
                Register(T1, {TextColor3 = "Text"})
            end
            if cfg.Content ~= nil then
                local T2 = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Enum.Font.Gotham, TextSize = 12,
                    TextColor3 = T("SubText"),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true, RichText = true,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    LayoutOrder = 2, Parent = Card,
                })
                BindText(T2, "Text", cfg.Content)
                Register(T2, {TextColor3 = "SubText"})
            end
            AddSearch(Card, cfg.Title)
            return {Frame = Card}
        end
    end

    --// ==================== CREATE TAB ====================
    local SettingsTab -- gán ở phần Settings

    local function MakeTab(name, icon, order, internal)
        local Tab = {_Elements = {}, _Internal = internal == true}
        local btnOrder = order or (#Window._UserTabs + 1)

        local Btn = New("TextButton", {
            BackgroundColor3 = T("Tab"), BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 34),
            LayoutOrder = btnOrder,
            Parent = TabsHolder,
        })
        Register(Btn, {BackgroundColor3 = "Tab"})
        New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Btn})

        local Indicator = New("Frame", {
            BackgroundColor3 = MeizuLibrary.Accent,
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(0, 3, 0, 0),
            Parent = Btn,
        })
        RegisterAccent(Indicator, "BackgroundColor3")
        New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Indicator})

        local xOffset = 14
        local Icon
        if icon then
            Icon = New("ImageLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.fromOffset(18, 18),
                Image = icon, ImageTransparency = 0.2,
                ImageColor3 = T("SubText"),
                Parent = Btn,
            })
            xOffset = 38
        end

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, xOffset, 0, 0),
            Size = UDim2.new(1, -(xOffset + 8), 1, 0),
            Font = Enum.Font.GothamMedium, TextSize = 13,
            TextColor3 = T("SubText"),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = Btn,
        })
        BindText(Label, "Text", name ~= nil and name or "Tab")

        -- Tên các ngôn ngữ (để SelectTab("Tên") hoạt động cho cả vi/en)
        Tab._Names = {}
        if type(name) == "table" then
            for _, s in pairs(name) do table.insert(Tab._Names, string.lower(tostring(s))) end
        else
            table.insert(Tab._Names, string.lower(tostring(name or "")))
        end

        local function VisualSelected(sel, instant)
            local textColor = sel and T("Text") or T("SubText")
            if instant then
                Label.TextColor3 = textColor
                if Icon then Icon.ImageColor3 = textColor end
            else
                Tween(Label, 0.22, {TextColor3 = textColor})
                if Icon then Tween(Icon, 0.22, {ImageColor3 = textColor}) end
            end
        end

        Btn.MouseEnter:Connect(function()
            if Window._CurrentTab ~= Tab then Tween(Btn, 0.15, {BackgroundTransparency = 0.55}) end
            Tween(Label, 0.2, {Position = UDim2.new(0, xOffset + 3, 0, 0)})
        end)
        Btn.MouseLeave:Connect(function()
            if Window._CurrentTab ~= Tab then Tween(Btn, 0.22, {BackgroundTransparency = 1}) end
            Tween(Label, 0.25, {Position = UDim2.new(0, xOffset, 0, 0)})
        end)
        AddPress(Btn)

        local Page = New("CanvasGroup", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Visible = false, GroupTransparency = 1,
            Parent = TabContainer,
        })
        local Scroll = New("ScrollingFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 3, ScrollBarImageTransparency = 0.3,
            Parent = Page,
        })
        RegisterAccent(Scroll, "ScrollBarImageColor3")
        New("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Scroll})
        New("UIPadding", {
            PaddingTop = UDim.new(0, 36), PaddingBottom = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = Scroll})

        function Tab:Select()
            if Window._CurrentTab == Tab then return end
            Window._SwitchToken = Window._SwitchToken + 1
            local token = Window._SwitchToken
            local prev = Window._CurrentTab
            Window._CurrentTab = Tab

            if prev then
                Tween(prev._Btn, 0.22, {BackgroundTransparency = 1})
                Tween(prev._Indicator, 0.22, {Size = UDim2.new(0, 3, 0, 0)})
                prev._VisualSelected(false)
                local pp = prev._Page
                Tween(pp, 0.14, {GroupTransparency = 1, Position = UDim2.new(0, -10, 0, 0)}, Enum.EasingStyle.Quad)
                task.delay(0.15, function()
                    if Window._CurrentTab ~= prev and pp.Parent then pp.Visible = false end
                end)
            end

            Tween(Btn, 0.22, {BackgroundTransparency = 0})
            Tween(Indicator, 0.35, {Size = UDim2.new(0, 3, 0, 18)}, Enum.EasingStyle.Back)
            VisualSelected(true)

            Page.Position = UDim2.new(0, 16, 0, 0)
            Page.GroupTransparency = 1
            Page.Visible = true
            task.delay(prev and 0.08 or 0, function()
                if Window._SwitchToken ~= token or not Page.Parent then return end
                Tween(Page, 0.3, {GroupTransparency = 0}, Enum.EasingStyle.Quad)
                Tween(Page, 0.45, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Quint)
            end)
        end

        Tab._Btn = Btn
        Tab._Label = Label
        Tab._Indicator = Indicator
        Tab._Page = Page
        Tab._VisualSelected = VisualSelected
        Btn.Activated:Connect(function() Tab:Select() end)

        OnThemeChange(function()
            if not Btn.Parent then return end
            VisualSelected(Window._CurrentTab == Tab, true)
        end)

        table.insert(Window._Tabs, Tab)
        if not Tab._Internal then table.insert(Window._UserTabs, Tab) end
        BindElements(Tab, Scroll, Tab)
        return Tab
    end

    function Window:CreateTab(name, icon, order)
        return MakeTab(name, icon, order, false)
    end

    function Window:SelectTab(index)
        if type(index) == "string" then
            local q = string.lower(index)
            for _, t in ipairs(Window._Tabs) do
                for _, n in ipairs(t._Names or {}) do
                    if n == q then t:Select() return end
                end
            end
        else
            local t = Window._UserTabs[tonumber(index) or 1] or SettingsTab
            if t then t:Select() end
        end
    end

    function Window:OnReady(fn)
        if type(fn) ~= "function" then return end
        if Window._Ready then SafeCall(fn) else table.insert(Window._ReadyCbs, fn) end
    end

    function Window:Notify(cfg)
        MeizuLibrary:Notify(cfg)
    end

    --// ==================== OPEN / CLOSE ====================
    local function SetOpen(state)
        if state == isOpen then return end
        isOpen = state
        Window._OpenToken = Window._OpenToken + 1
        local token = Window._OpenToken
        if state then
            Root.Visible = true
            Tween(MainScale, 0.5, {Scale = 1}, Enum.EasingStyle.Quint)
            Tween(Main, 0.32, {GroupTransparency = 0}, Enum.EasingStyle.Quad)
            Tween(Shadow, 0.5, {ImageTransparency = 0.45}, Enum.EasingStyle.Quad)
            if not Window._CurrentTab then
                local first = Window._UserTabs[1] or SettingsTab
                if first then first:Select() end
            end
        else
            Tween(MainScale, 0.32, {Scale = 0.93}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            Tween(Main, 0.26, {GroupTransparency = 1}, Enum.EasingStyle.Quad)
            Tween(Shadow, 0.26, {ImageTransparency = 1}, Enum.EasingStyle.Quad)
            task.delay(0.34, function()
                if not isOpen and token == Window._OpenToken and Root.Parent then
                    Root.Visible = false
                end
            end)
        end
        if SetToggleVisual then SetToggleVisual(state) end
        PlaySound("rbxasset://sounds/electronicpingshort.wav", 0.2, state and 1.1 or 0.9)
    end

    function Window:Toggle(state)
        if state == nil then state = not isOpen end
        SetOpen(state)
    end

    MinBtn.Activated:Connect(function() Window:Toggle(false) end)
    CloseBtn.Activated:Connect(function()
        Window:Dialog({
            Title = S("close_title"),
            Content = S("close_content"),
            Buttons = {
                {Title = S("btn_cancel")},
                {Title = S("btn_close"), Variant = "Primary", Callback = function() MeizuLibrary:Destroy() end},
            },
        })
    end)

    --// ==================== KEYBIND TOÀN CỤC ====================
    table.insert(MeizuLibrary._Connections, UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if UserInputService:GetFocusedTextBox() then return end
        if input.UserInputType == Enum.UserInputType.Keyboard
        and input.KeyCode == MeizuLibrary.ToggleKeybind then
            Window:Toggle()
        end
    end))

    --// ==================== DIALOG ====================
    function Window:Dialog(cfg)
        cfg = cfg or {}
        local DW = 340
        local PAD = 16
        local titleH = 18
        local contentText = cfg.Content ~= nil and Resolve(cfg.Content) or ""
        local contentH = 0
        if contentText ~= "" then
            contentH = MeasureTextHeight(contentText, Enum.Font.Gotham, 12, DW - PAD * 2) + 2
        end
        local buttons = cfg.Buttons or {{Title = S("btn_ok"), Variant = "Primary"}}
        local gap, btnH = 8, 32
        local btnW = math.min(math.floor((DW - PAD * 2 - (#buttons - 1) * gap) / #buttons), 110)
        local rowW = #buttons * btnW + (#buttons - 1) * gap
        local cardH = PAD + titleH + (contentH > 0 and (8 + contentH) or 0) + 14 + btnH + PAD

        local Overlay = New("Frame", {
            BackgroundColor3 = T("Overlay"),
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Active = true, -- chặn click xuyên xuống UI bên dưới
            ZIndex = 300,
            Parent = ScreenGui,
        })
        local Card = New("CanvasGroup", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(DW, cardH),
            BackgroundColor3 = T("Window"),
            GroupTransparency = 1,
            ZIndex = 301,
            Parent = Overlay,
        })
        Register(Card, {BackgroundColor3 = "Window"})
        New("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Card})
        local DStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.3, Parent = Card})
        Register(DStroke, {Color = "Stroke"})
        local scale = New("UIScale", {Scale = 0.88, Parent = Card})

        local DTitle = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, PAD, 0, PAD),
            Size = UDim2.new(1, -PAD * 2, 0, titleH),
            Font = Enum.Font.GothamBold, TextSize = 15,
            TextColor3 = T("Text"), TextXAlignment = Enum.TextXAlignment.Left,
            Text = Resolve(cfg.Title ~= nil and cfg.Title or S("dialog")),
            ZIndex = 302, Parent = Card,
        })
        Register(DTitle, {TextColor3 = "Text"})

        if contentH > 0 then
            local DContent = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, PAD, 0, PAD + titleH + 8),
                Size = UDim2.new(1, -PAD * 2, 0, contentH),
                Font = Enum.Font.Gotham, TextSize = 12,
                TextColor3 = T("SubText"), TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true, RichText = true, Text = contentText,
                ZIndex = 302, Parent = Card,
            })
            Register(DContent, {TextColor3 = "SubText"})
        end

        local dismissed = false
        local function Dismiss()
            if dismissed then return end
            dismissed = true
            Tween(Overlay, 0.22, {BackgroundTransparency = 1})
            Tween(scale, 0.22, {Scale = 0.92}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            Tween(Card, 0.2, {GroupTransparency = 1})
            task.delay(0.24, function() if Overlay then Overlay:Destroy() end end)
        end

        for i, bn in ipairs(buttons) do
            local isPrimary = (bn.Variant == "Primary")
            local B = New("TextButton", {
                Text = Resolve(bn.Title ~= nil and bn.Title or S("btn_ok")),
                Position = UDim2.new(0, DW - PAD - rowW + (i - 1) * (btnW + gap), 0, cardH - PAD - btnH),
                Size = UDim2.fromOffset(btnW, btnH),
                BackgroundColor3 = isPrimary and MeizuLibrary.Accent or T("Input"),
                Font = Enum.Font.GothamBold, TextSize = 12,
                TextColor3 = isPrimary and Color3.fromRGB(255, 255, 255) or T("SubText"),
                ZIndex = 302, Parent = Card,
            })
            New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = B})
            local bsc = New("UIScale", {Scale = 1, Parent = B})
            if not isPrimary then
                Register(B, {BackgroundColor3 = "Input"})
                Register(B, {TextColor3 = "SubText"})
                B.MouseEnter:Connect(function() Tween(B, 0.15, {TextColor3 = T("Text")}) end)
                B.MouseLeave:Connect(function() Tween(B, 0.2, {TextColor3 = T("SubText")}) end)
            else
                B.MouseEnter:Connect(function() Tween(B, 0.15, {BackgroundTransparency = 0.12}) end)
                B.MouseLeave:Connect(function() Tween(B, 0.2, {BackgroundTransparency = 0}) end)
            end
            B.InputBegan:Connect(function(input) if IsPointer(input) then Tween(bsc, 0.08, {Scale = 0.94}) end end)
            B.InputEnded:Connect(function(input) if IsPointer(input) then Tween(bsc, 0.25, {Scale = 1}, Enum.EasingStyle.Back) end end)
            B.Activated:Connect(function()
                Dismiss()
                SafeCall(bn.Callback)
            end)
        end

        Tween(Overlay, 0.25, {BackgroundTransparency = 0.4})
        Tween(scale, 0.4, {Scale = 1}, Enum.EasingStyle.Back)
        Tween(Card, 0.28, {GroupTransparency = 0})
    end

    --// ==================== NÚT NỔI (HÌNH CỐ ĐỊNH: meizuxp.png) ====================
    local ShowToggleButton = function() end
    if config.ToggleUIButton ~= false then
        local RADIUS = TOGGLE_BUTTON_RADIUS

        local ToggleBtn = New("Frame", {
            Name = "ToggleButton",
            Size = TOGGLE_BUTTON_SIZE,
            Position = TOGGLE_BUTTON_POSITION,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0), -- nền đen giống testtintro
            Active = true,
            Visible = false,
            ZIndex = 150,
            Parent = ScreenGui,
        })
        New("UICorner", {CornerRadius = UDim.new(0, RADIUS), Parent = ToggleBtn})
        local BtnStroke = New("UIStroke", {Color = MeizuLibrary.Accent, Thickness = 1.5, Transparency = 0.35, Parent = ToggleBtn})
        RegisterAccent(BtnStroke, "Color")

        New("ImageLabel", {
            Name = "Shadow", BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1, 40, 1, 40),
            Image = "rbxassetid://6014261993",
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            ImageTransparency = 0.45,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(49, 49, 450, 450),
            ZIndex = 148, Parent = ToggleBtn,
        })

        -- Hình cố định (lấp đầy nút, bo góc theo nút)
        local ToggleImageL = New("ImageLabel", {
            Name = "ToggleImage",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Visible = false,
            ScaleType = Enum.ScaleType.Crop,
            ImageTransparency = 1,
            ZIndex = 153, Parent = ToggleBtn,
        })
        New("UICorner", {CornerRadius = UDim.new(0, RADIUS), Parent = ToggleImageL})

        -- Chữ dự phòng (chỉ hiện khi executor không tải được hình)
        local ToggleLetter = New("TextLabel", {
            Name = "ToggleLetter",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Font = Enum.Font.GothamBlack, TextSize = 22,
            Text = config.ToggleText or "M",
            TextXAlignment = Enum.TextXAlignment.Center,
            TextColor3 = MeizuLibrary.Accent,
            ZIndex = 153, Parent = ToggleBtn,
        })
        RegisterAccent(ToggleLetter, "TextColor3")

        OnLogo(function(asset)
            if not ToggleBtn.Parent then return end
            if asset ~= "" then
                ToggleImageL.Image = asset
                ToggleImageL.Visible = true
                Tween(ToggleImageL, 0.4, {ImageTransparency = 0})
                Tween(ToggleLetter, 0.3, {TextTransparency = 1})
            end
        end)

        local BtnScale = New("UIScale", {Scale = 0, Parent = ToggleBtn})

        -- Bấm = mở/đóng, kéo = di chuyển (tự kéo lại vào trong màn hình)
        local pressed, moved, activeInput, dragStart, startPos = false, false, nil, nil, nil
        local DRAG_THRESHOLD = 6

        local function ClampIntoScreen()
            if not ToggleBtn.Parent then return end
            local screen = ScreenGui.AbsoluteSize
            local size = ToggleBtn.AbsoluteSize
            local pos = ToggleBtn.AbsolutePosition
            local cx = math.clamp(pos.X, 8, math.max(screen.X - size.X - 8, 8))
            local cy = math.clamp(pos.Y, 8, math.max(screen.Y - size.Y - 8, 8))
            if math.abs(cx - pos.X) > 0.5 or math.abs(cy - pos.Y) > 0.5 then
                Tween(ToggleBtn, 0.35, {Position = UDim2.fromOffset(cx, cy)}, Enum.EasingStyle.Back)
            end
        end

        local function FinishPress()
            if not pressed then return end
            pressed = false
            Tween(BtnScale, 0.3, {Scale = 1}, Enum.EasingStyle.Back)
            if moved then
                ClampIntoScreen()
            else
                Window:Toggle()
            end
            activeInput = nil
        end

        ToggleBtn.InputBegan:Connect(function(input)
            if IsPointer(input) and not pressed then
                pressed = true
                moved = false
                activeInput = input
                dragStart = input.Position
                startPos = ToggleBtn.Position
                Tween(BtnScale, 0.1, {Scale = 0.9}, Enum.EasingStyle.Quad)
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then FinishPress() end
                end)
            end
        end)
        table.insert(MeizuLibrary._Connections, UserInputService.InputChanged:Connect(function(input)
            if not pressed then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input == activeInput then
                local delta = input.Position - dragStart
                if delta.Magnitude >= DRAG_THRESHOLD then moved = true end
                if moved then
                    ToggleBtn.Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + delta.X,
                        startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end
        end))

        ToggleBtn.MouseEnter:Connect(function()
            if not pressed then Tween(BtnScale, 0.22, {Scale = 1.08}, Enum.EasingStyle.Back) end
        end)
        ToggleBtn.MouseLeave:Connect(function()
            if not pressed then Tween(BtnScale, 0.25, {Scale = 1}) end
        end)

        -- Sóng lan khi UI đang ẩn
        local PulseRing = New("Frame", {
            Name = "PulseRing",
            BackgroundColor3 = MeizuLibrary.Accent,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(50, 50),
            ZIndex = 149, Parent = ToggleBtn,
        })
        RegisterAccent(PulseRing, "BackgroundColor3")
        New("UICorner", {CornerRadius = UDim.new(0, RADIUS), Parent = PulseRing})

        task.spawn(function()
            while Alive() and ToggleBtn.Parent do
                if not isOpen and ToggleBtn.Visible and PulseRing.Parent then
                    PulseRing.Size = UDim2.fromOffset(50, 50)
                    PulseRing.BackgroundTransparency = 0.65
                    Tween(PulseRing, 1.2, {Size = UDim2.fromOffset(90, 90), BackgroundTransparency = 1}, Enum.EasingStyle.Quad)
                end
                task.wait(1.8)
            end
        end)

        SetToggleVisual = function(open)
            if not ToggleBtn.Parent then return end
            Tween(BtnStroke, 0.35, {
                Transparency = open and 0 or 0.35,
                Thickness = open and 2.2 or 1.5,
            })
        end

        ShowToggleButton = function()
            if not ToggleBtn.Parent then return end
            ToggleBtn.Visible = true
            Tween(BtnScale, 0.6, {Scale = 1}, Enum.EasingStyle.Back)
        end
    end

    --// ==================== SEARCH FILTER ====================
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = string.lower(SearchBox.Text)
        for _, t in ipairs(Window._Tabs) do
            for _, e in ipairs(t._Elements) do
                if e.Frame and e.Frame.Parent then
                    e.Frame.Visible = (q == "") or (string.find(e.Text, q, 1, true) ~= nil)
                end
            end
        end
    end)

    --// ==================== SETTINGS TAB (TỰ ĐỘNG) ====================
    local themeNames = {}
    for k in pairs(MeizuLibrary.Themes) do table.insert(themeNames, k) end
    table.sort(themeNames)

    SettingsTab = MakeTab(S("tab_settings"), nil, 9999, true)

    SettingsTab:CreateParagraph({
        Title = "Meizu Library v" .. MeizuLibrary.Version,
        Content = S("about_content"),
    })

    local SecInterface = SettingsTab:CreateSection(S("sec_interface"))

    -- Chọn ngôn ngữ
    local LANG_NAMES = {vi = "Tiếng Việt", en = "English"}
    local LANG_CODES = {["Tiếng Việt"] = "vi", ["English"] = "en"}
    local LanguageDropdown
    LanguageDropdown = SecInterface:CreateDropdown({
        Title = S("language"),
        Description = S("language_desc"),
        Options = {"Tiếng Việt", "English"},
        Default = LANG_NAMES[MeizuLibrary.Language] or "Tiếng Việt",
        Callback = function(v)
            local code = LANG_CODES[v]
            if code and code ~= MeizuLibrary.Language then
                MeizuLibrary:SetLanguage(code)
                MeizuLibrary:Notify({
                    Title = S("language"),
                    Content = S("language_changed"),
                    Duration = 3,
                })
            end
        end,
    })
    -- Nếu đổi ngôn ngữ bằng code (Library:SetLanguage) thì dropdown cũng cập nhật theo
    OnLangChange(function()
        local want = LANG_NAMES[MeizuLibrary.Language]
        if want and LanguageDropdown.Get() ~= want then LanguageDropdown.Set(want) end
    end)

    SecInterface:CreateDropdown({
        Title = S("theme"),
        Options = themeNames,
        Default = MeizuLibrary.Theme,
        Callback = function(v) MeizuLibrary:ApplyTheme(v) end,
    })
    SecInterface:CreateColorPicker({
        Title = S("accent"),
        Default = MeizuLibrary.Accent,
        Callback = function(c)
            MeizuLibrary._UserAccent = c
            MeizuLibrary:ApplyAccent(c)
        end,
    })
    SecInterface:CreateToggle({
        Title = S("rainbow"),
        Default = false,
        Callback = function(v) MeizuLibrary:SetRainbow(v) end,
    })
    SecInterface:CreateToggle({
        Title = S("sound"),
        Default = MeizuLibrary.SoundEnabled,
        Callback = function(v) MeizuLibrary.SoundEnabled = v end,
    })
    -- LƯU Ý: không gắn Callback ở đây, phím bật/tắt đã được xử lý toàn cục (tránh bật rồi tắt ngay)
    SecInterface:CreateKeybind({
        Title = S("keybind_toggle"),
        Default = MeizuLibrary.ToggleKeybind,
        ChangedCallback = function(key) MeizuLibrary.ToggleKeybind = key end,
    })

    local SecConfig = SettingsTab:CreateSection(S("sec_config"))
    local nameInput = SecConfig:CreateInput({
        Title = S("config_name"),
        Placeholder = "config",
        Default = "config",
    })
    SecConfig:CreateButton({
        Title = S("save_config"),
        Callback = function()
            local v = nameInput.Get()
            local ok = MeizuLibrary:SaveSettings(v)
            MeizuLibrary:Notify({
                Title = S("config_title"),
                Content = ok and LS("config_saved", v) or S("config_nosave"),
                Duration = 4,
            })
        end,
    })
    SecConfig:CreateButton({
        Title = S("load_config"),
        Callback = function()
            local v = nameInput.Get()
            local ok = MeizuLibrary:LoadSettings(v)
            MeizuLibrary:Notify({
                Title = S("config_title"),
                Content = ok and LS("config_loaded", v) or S("config_notfound"),
                Duration = 4,
            })
        end,
    })

    local SecSystem = SettingsTab:CreateSection(S("sec_system"))
    SecSystem:CreateButton({
        Title = S("unload"),
        Description = S("unload_desc"),
        Callback = function()
            Window:Dialog({
                Title = S("unload_title"),
                Content = S("unload_content"),
                Buttons = {
                    {Title = S("btn_cancel")},
                    {Title = S("btn_unload"), Variant = "Primary", Callback = function() MeizuLibrary:Destroy() end},
                },
            })
        end,
    })

    --// ==================== LOADING SCREEN (giống testtintro.lua) ====================
    local function RunLoader()
        local LC = {
            Main   = Color3.fromRGB(0, 0, 0),
            Topic  = Color3.fromRGB(200, 200, 200),
            Title  = Color3.fromRGB(255, 255, 255),
            Bar    = Color3.fromRGB(40, 40, 40),
            Splash = (typeof(config.LoaderColor) == "Color3") and config.LoaderColor or Color3.fromRGB(3, 252, 3),
        }

        local Frame = New("Frame", {
            Name = "MeizuLoader",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(0, 0),
            BackgroundColor3 = LC.Main,
            ClipsDescendants = true,
            ZIndex = 500,
            Parent = ScreenGui,
        })
        New("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Frame})
        local FStroke = New("UIStroke", {Color = Color3.fromRGB(60, 60, 60), Thickness = 1, Transparency = 1, Parent = Frame})

        -- Logo (tròn) + chữ M dự phòng
        local LogoHolder = New("Frame", {
            Position = UDim2.fromOffset(15, 10),
            Size = UDim2.fromOffset(50, 50),
            BackgroundColor3 = Color3.fromRGB(26, 26, 26),
            BackgroundTransparency = 1,
            ZIndex = 501, Parent = Frame,
        })
        New("UICorner", {CornerRadius = UDim.new(0, 25), Parent = LogoHolder})
        local LogoLetter = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Font = Enum.Font.GothamBlack, TextSize = 22,
            Text = config.ToggleText or "M",
            TextXAlignment = Enum.TextXAlignment.Center,
            TextColor3 = LC.Splash, TextTransparency = 1,
            ZIndex = 502, Parent = LogoHolder,
        })
        local LogoImage = New("ImageLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ScaleType = Enum.ScaleType.Crop,
            ImageTransparency = 1, Visible = false,
            ZIndex = 503, Parent = LogoHolder,
        })
        New("UICorner", {CornerRadius = UDim.new(0, 25), Parent = LogoImage})

        local HubName = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(75, 10),
            Size = UDim2.fromOffset(190, 50),
            Font = Enum.Font.GothamBold, TextSize = 16,
            TextColor3 = LC.Title, TextTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 501, Parent = Frame,
        })
        BindText(HubName, "Text", config.Title or "Meizu Library")

        local Percent = New("TextLabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -15, 0, 10),
            Size = UDim2.fromOffset(60, 50),
            Font = Enum.Font.GothamBold, TextSize = 14,
            Text = "0%",
            TextColor3 = LC.Splash, TextTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 501, Parent = Frame,
        })

        local LoaderTitle = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(15, 66),
            Size = UDim2.new(1, -30, 0, 18),
            Font = Enum.Font.Gotham, TextSize = 13,
            RichText = true,
            TextColor3 = LC.Title, TextTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 501, Parent = Frame,
        })
        local function TitleText()
            local t = config.LoaderTitle ~= nil and Resolve(config.LoaderTitle) or Resolve(S("loader_title"))
            return "<b>" .. t .. "</b>"
        end
        LoaderTitle.Text = TitleText()

        local ProgressBG = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 90),
            Size = UDim2.new(0.9, 0, 0, 14),
            BackgroundColor3 = LC.Bar, BackgroundTransparency = 1,
            ZIndex = 501, Parent = Frame,
        })
        New("UICorner", {CornerRadius = UDim.new(0, 7), Parent = ProgressBG})
        local ProgressBar = New("Frame", {
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = LC.Splash, BackgroundTransparency = 1,
            ZIndex = 502, Parent = ProgressBG,
        })
        New("UICorner", {CornerRadius = UDim.new(0, 7), Parent = ProgressBar})

        local StepLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 108),
            Size = UDim2.new(1, -20, 0, 18),
            Font = Enum.Font.Gotham, TextSize = 12,
            TextColor3 = LC.Topic, TextTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 501, Parent = Frame,
        })

        -- Logo thật: nhận khi tải xong
        local Revealed = false
        OnLogo(function(asset)
            if not LogoImage.Parent then return end
            if asset ~= "" then
                LogoImage.Image = asset
                LogoImage.Visible = true
                if Revealed then
                    Tween(LogoImage, 0.35, {ImageTransparency = 0})
                    Tween(LogoLetter, 0.25, {TextTransparency = 1})
                end
            end
        end)

        -- Số % chạy theo thanh tiến trình
        local pctConn = RunService.Heartbeat:Connect(function()
            if Percent.Parent then
                Percent.Text = tostring(math.floor(ProgressBar.Size.X.Scale * 100 + 0.5)) .. "%"
            end
        end)

        local function SetStep(index, pct)
            Tween(ProgressBar, 0.5, {Size = UDim2.new(pct / 100, 0, 1, 0)}, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            StepLabel.Text = Resolve(S("loader_step_" .. index))
            StepLabel.TextTransparency = 0.7
            Tween(StepLabel, 0.3, {TextTransparency = 0})
        end

        local ok, err = pcall(function()
            -- 1) Khung mở rộng
            Tween(Frame, 0.5, {Size = UDim2.fromOffset(346, 132)}, Enum.EasingStyle.Quint)
            Tween(FStroke, 0.5, {Transparency = 0.4})
            task.wait(0.45)
            if not Alive() then return end

            -- 2) Hiện nội dung
            Revealed = true
            if LogoImage.Visible then
                Tween(LogoImage, 0.45, {ImageTransparency = 0})
            else
                Tween(LogoLetter, 0.45, {TextTransparency = 0})
            end
            Tween(LogoHolder, 0.45, {BackgroundTransparency = LogoImage.Visible and 1 or 0})
            Tween(HubName, 0.5, {TextTransparency = 0})
            Tween(Percent, 0.5, {TextTransparency = 0})
            Tween(LoaderTitle, 0.5, {TextTransparency = 0})
            Tween(ProgressBG, 0.5, {BackgroundTransparency = 0})
            Tween(ProgressBar, 0.5, {BackgroundTransparency = 0})
            Tween(StepLabel, 0.5, {TextTransparency = 0})
            task.wait(0.35)

            -- 3) Các bước tải
            local keyframes = {
                {0.25, 12}, {0.4, 38}, {0.4, 72}, {0.35, 100},
            }
            for i, kf in ipairs(keyframes) do
                task.wait(kf[1])
                if not Alive() then return end
                SetStep(i, kf[2])
                if i == 2 then
                    -- chờ logo tải xong (tối đa 4 giây) để nút nổi có hình ngay từ đầu
                    local waited = 0
                    while not LogoState.Ready and waited < 4 and Alive() do
                        task.wait(0.05)
                        waited = waited + 0.05
                    end
                end
            end
            task.wait(0.8)
            if not Alive() then return end

            -- 4) Ẩn dần rồi thu nhỏ
            Tween(LoaderTitle, 0.4, {TextTransparency = 1})
            Tween(ProgressBG, 0.4, {BackgroundTransparency = 1})
            Tween(ProgressBar, 0.4, {BackgroundTransparency = 1})
            Tween(StepLabel, 0.4, {TextTransparency = 1})
            Tween(Percent, 0.4, {TextTransparency = 1})
            Tween(HubName, 0.4, {TextTransparency = 1})
            Tween(LogoImage, 0.4, {ImageTransparency = 1})
            Tween(LogoLetter, 0.4, {TextTransparency = 1})
            Tween(LogoHolder, 0.4, {BackgroundTransparency = 1})
            task.wait(0.45)
            Tween(FStroke, 0.35, {Transparency = 1})
            Tween(Frame, 0.4, {Size = UDim2.fromOffset(0, 0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            task.wait(0.42)
        end)

        pctConn:Disconnect()
        if Frame and Frame.Parent then Frame:Destroy() end
        if not ok then warn("[MeizuLibrary] Loader error: " .. tostring(err)) end
    end

    --// ==================== KHỞI ĐỘNG ====================
    task.defer(function()
        if not Alive() then return end
        if config.Loader ~= false then
            RunLoader()
        end
        if not Alive() then return end
        Window._Ready = true
        Window:Toggle(true)
        ShowToggleButton()
        for _, fn in ipairs(Window._ReadyCbs) do SafeCall(fn) end
        Window._ReadyCbs = {}
    end)

    Window.Root = Root
    Window.Main = Main
    return Window
end

return MeizuLibrary
