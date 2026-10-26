--[[
    ███╗   ███╗███████╗██╗███████╗██╗   ██╗
    ████╗ ████║██╔════╝██║██╔════╝╚██╗ ██╔╝
    ██╔████╔██║█████╗  ██║███████╗ ╚████╔╝
    ██║╚██╔╝██║██╔══╝  ██║╚════██║  ╚██╔╝
    ██║ ╚═╝ ██║███████╗██║███████║   ██║
    ╚═╝     ╚═╝╚══════╝╚═╝╚══════╝   ╚═╝
    MEIZU LIBRARY v2.5 — LIQUID GLASS EDITION (Fluent-inspired)
    =========================================================
    API:
      Library:CreateWindow{Title, SubTitle, Logo, Theme, Accent, ToggleKeybind,
                           ToggleUIButton, ToggleImage, ToggleText, Size, InfoPanel}
      Window:CreateTab(name, iconId, order, desc) / Window:SelectTab(1)
      Window:Toggle(state) / Window:Dialog{Title, Content, Buttons}
      Window:SetToggleImage(assetId | số | URL | nil)  -- đổi hình nút nổi (mặc định = LOGO CŨ của bạn)
      Window:GetToggleImage()                          -- lấy hình nút nổi đang dùng
      Window:SetTabInfo(desc)                          -- đặt dòng giải thích cho tab hiện tại (panel bên phải)
      Tab/Section:CreateButton / CreateToggle / CreateSlider / CreateDropdown
                  CreateMultiDropdown / CreateKeybind / CreateInput
                  CreateColorPicker / CreateParagraph / CreateSection
      Library:Notify{Title, Content, Duration} / Library:ApplyTheme("Dark")
      Library:ApplyAccent(Color3) / Library:SetRainbow(bool)
      Library:SaveSettings(name) / Library:LoadSettings(name) / Library:Destroy()
      Library.Flags --> giá trị theo Flag
]]

--// ================== CẤU HÌNH NHANH ==================
local TOGGLE_BUTTON_SIZE     = UDim2.new(0, 50, 0, 50)                                  -- Nút nổi
local TOGGLE_BUTTON_POSITION = UDim2.new(0.120833337 - 0.1, 0, 0.0952890813 + 0.01, 0)  -- Vị trí

-- LOGO CŨ CỦA BẠN cho nút nổi (giữ NGUYÊN như bản gốc — không thay bằng icon khác)
-- Người dùng vẫn có thể đổi trong tab Settings → "Toggle Button Image"
local DEFAULT_TOGGLE_IMG     = "https://i.ibb.co/S7rpHJJN/meizuxp.png"
local TOGGLE_BUTTON_IMAGE    = DEFAULT_TOGGLE_IMG
-- Chỉ dùng khi link logo tải lỗi (executor không hỗ trợ getcustomasset) → không để nút trống
local FALLBACK_TOGGLE_IMG    = "rbxassetid://10734950309"

-- ICON CÀI ĐẶT Ở TRONG MENU (tab Settings trên sidebar dùng icon này)
local SETTINGS_TAB_ICON      = "rbxassetid://10734950309"

-- Panel bên phải: hiện TÊN TAB + GIẢI THÍCH (đặt InfoPanel = false trong CreateWindow để tắt)
local INFO_PANEL_WIDTH       = 148

-- Bo góc nút nổi kiểu Liquid Glass (squircle iOS — không tròn hoàn hảo)
local TOGGLE_BUTTON_RADIUS   = 15

--// ========== FONT HỖ TRỢ TIẾNG VIỆT (FIX LỖI DẤU) ==========
-- ⚠ Font Gotham của Roblox THIẾU ký tự tiếng Việt (ậ, ế, ở, ữ, ộ...)
--   khiến chữ hiển thị lỗi dấu / mất chữ. Toàn library chuyển sang SourceSans:
--   hiển thị dấu tiếng Việt CHUẨN 100% trên PC lẫn mobile.
local FONT_MAIN   = Enum.Font.SourceSans           -- chữ thường
local FONT_MEDIUM = Enum.Font.SourceSansSemibold   -- chữ bán đậm
local FONT_BOLD   = Enum.Font.SourceSansBold       -- tiêu đề / chữ đậm
local FONT_BLACK  = Enum.Font.SourceSansBold       -- thay thế GothamBlack
-- ====================================================
--// ====================================================

local MeizuLibrary = {
    Version       = "2.5",
    Flags         = {},
    Theme         = "Dark",
    Accent        = Color3.fromRGB(88, 101, 242),
    ToggleKeybind = Enum.KeyCode.RightControl,
    SoundEnabled  = true,
    Folder        = "MeizuLibrary",
    _FlagElems    = {},
    _ThemeObjs    = {},
    _AccentObjs   = {},
    _ThemeHooks   = {},
    _Connections  = {},
    _ActiveDrags  = {},
    _NotifCount   = 0,
    _ToggleImage  = nil,
    Destroyed     = false,
}

local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local HttpService      = game:GetService("HttpService")
local TextService      = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer


--// ====================== LANGUAGE SYSTEM ======================
MeizuLibrary.Language = "vi"
MeizuLibrary.Languages = { vi = "Tiếng Việt", en = "English" }
MeizuLibrary._LocEntries = {}

MeizuLibrary.LanguageMap = {
    ["Settings"] = {vi="Cài đặt", en="Settings"},
    ["Theme"] = {vi="Chủ đề", en="Theme"},
    ["Accent Color"] = {vi="Màu nhấn", en="Accent Color"},
    ["Rainbow Accent"] = {vi="Màu nhấn cầu vồng", en="Rainbow Accent"},
    ["Sound Effects"] = {vi="Âm thanh", en="Sound Effects"},
    ["Toggle UI Keybind"] = {vi="Phím bật/tắt UI", en="Toggle UI Keybind"},
    ["Config Name"] = {vi="Tên config", en="Config Name"},
    ["Save Config"] = {vi="Lưu config", en="Save Config"},
    ["Load Config"] = {vi="Tải config", en="Load Config"},
    ["Unload Library"] = {vi="Gỡ Library", en="Unload Library"},
    ["Language"] = {vi="Ngôn ngữ", en="Language"},
    ["Search..."] = {vi="Tìm kiếm...", en="Search..."},
    ["Toggle Button Image"] = {vi="Hình nút nổi", en="Toggle Button Image"},
    ["Apply Image"] = {vi="Áp dụng hình nút nổi", en="Apply Toggle Image"},
    ["Reset Image"] = {vi="Về logo cũ", en="Reset to Old Logo"},
    ["Current Tab"] = {vi="TAB HIỆN TẠI", en="CURRENT TAB"},
}

function MeizuLibrary:_Translate(key)
    local row = self.LanguageMap[key]
    if type(row) == "table" then
        return row[self.Language] or row.en or key
    end
    return key
end

function MeizuLibrary:_ApplyLocalization()
    if not self._ScreenGui then return end
    for _, obj in ipairs(self._ScreenGui:GetDescendants()) do
        local key = obj:GetAttribute("MeizuLocKey")
        if key and self.LanguageMap[key]
        and (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
            pcall(function() obj.Text = self:_Translate(key) end)
        end
        local descKey = obj:GetAttribute("MeizuLocDesc")
        if descKey and self.LanguageMap[descKey]
        and (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
            pcall(function() obj.Text = self:_Translate(descKey) end)
        end
    end
    -- Cập nhật panel thông tin tab (tên + mô tả tự động theo ngôn ngữ mới)
    local w = self._Window
    if w and w._InfoRefresh and w._CurrentTab then
        pcall(w._InfoRefresh, w._CurrentTab)
    end
end

function MeizuLibrary:SetLanguage(lang)
    lang = tostring(lang or "vi"):lower()
    if lang ~= "vi" and lang ~= "en" then lang = "vi" end
    self.Language = lang
    self.Flags["__language"] = lang
    if type(writefile) == "function" and type(isfolder) == "function" and type(makefolder) == "function" then
        pcall(function()
            if not isfolder(self.Folder) then makefolder(self.Folder) end
            writefile(self.Folder .. "/language.json", HttpService:JSONEncode({Language=lang}))
        end)
    end
    self:_ApplyLocalization()
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

local function New(class, props, children)
    local obj = Instance.new(class)
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
    task.spawn(function()
        local ok, err = pcall(fn, unpack(args))
        if not ok then warn("[MeizuLibrary] Callback error: " .. tostring(err)) end
    end)
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
        BorderSizePixel = 0,
        ZIndex = 50,
        Parent = parent,
    })
    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = circle})
    Tween(circle, 0.55, {Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1}, Enum.EasingStyle.Quad)
    task.delay(0.6, function() if circle then circle:Destroy() end end)
end

--// ==================== KÉO THẢ v2.4 (clamp + fix lỗi vùng kéo trên mobile) ====================
-- ClampMode:
--   "full"    → vật thể nhỏ (nút nổi): luôn nằm trọn trong màn hình, không bao giờ tuột mất
--   "partial" → cửa sổ chính: mép trên luôn với tới được (nút Close không tụt khỏi màn hình),
--               mép trái/phải luôn chừa 110px nhìn thấy, đáy không lọt xuống dưới màn hình
local function MakeDraggable(handle, target, opts)
    opts = opts or {}
    local guardGP = (opts.GuardGameProcessed == true)
    local clampMode = opts.ClampMode or "none"

    local function GetViewport()
        local gui = MeizuLibrary._ScreenGui
        if gui and gui.Parent then return gui.AbsoluteSize end
        local cam = workspace.CurrentCamera
        if cam then return cam.ViewportSize end
        return Vector2.new(1280, 720)
    end

    local ClampPos = nil
    if clampMode == "full" then
        ClampPos = function(p)
            local vp = GetViewport()
            local s = target.AbsoluteSize
            local minX, maxX = 8 + s.X * 0.5, vp.X - 8 - s.X * 0.5
            local minY, maxY = 8 + s.Y * 0.5, vp.Y - 8 - s.Y * 0.5
            if maxX < minX then minX, maxX = vp.X * 0.5, vp.X * 0.5 end
            if maxY < minY then minY, maxY = vp.Y * 0.5, vp.Y * 0.5 end
            return Vector2.new(math.clamp(p.X, minX, maxX), math.clamp(p.Y, minY, maxY))
        end
    elseif clampMode == "partial" then
        ClampPos = function(p)
            local vp = GetViewport()
            local s = target.AbsoluteSize
            local minX, maxX = 110 - s.X * 0.5, vp.X + s.X * 0.5 - 110
            if maxX < minX then minX, maxX = vp.X * 0.5, vp.X * 0.5 end
            local minY = s.Y * 0.5             -- đỉnh cửa sổ không vượt quá mép trên → luôn kéo lên tới được
            local maxY = vp.Y - s.Y * 0.5      -- đáy cửa sổ không lọt xuống dưới màn hình
            if maxY < minY then maxY = minY end
            return Vector2.new(math.clamp(p.X, minX, maxX), math.clamp(p.Y, minY, maxY))
        end
    end

    local dragging = false
    local dragStart, startPos

    handle.InputBegan:Connect(function(input, gp)
        if guardGP and gp then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            -- đổi sang toạ độ offset tuyệt đối để clamp chính xác trên mọi thiết bị
            local ax = target.AbsolutePosition.X + target.AbsoluteSize.X * target.AnchorPoint.X
            local ay = target.AbsolutePosition.Y + target.AbsoluteSize.Y * target.AnchorPoint.Y
            startPos = Vector2.new(ax, ay)
            if ClampPos then startPos = ClampPos(startPos) end
            target.Position = UDim2.fromOffset(startPos.X, startPos.Y)
        end
    end)

    table.insert(MeizuLibrary._Connections, UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart
        local np = Vector2.new(startPos.X + delta.X, startPos.Y + delta.Y)
        if ClampPos then np = ClampPos(np) end
        target.Position = UDim2.fromOffset(np.X, np.Y)
    end))

    table.insert(MeizuLibrary._Connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
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
        gui.Parent = parent
    end)
    if not ok or not gui then
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
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
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

--// ==================== RESOLVE IMAGE (ID hoặc URL .png) ====================
local function ResolveImageAsset(id, fname)
    if type(id) == "number" then return "rbxassetid://" .. tostring(id) end
    if type(id) ~= "string" then return nil end
    id = id:match("^%s*(.-)%s*$") or ""
    if id == "" then return nil end
    if tonumber(id) then return "rbxassetid://" .. id end
    if id:sub(1, 8) == "rbxasset" then return id end
    if id:sub(1, 4) == "http" then
        local ok, content = pcall(function() return game:HttpGet(id, true) end)
        if not ok or not content then return nil end
        if writefile and getcustomasset then
            local ext = (id:lower():match("%.jpe?g$") and ".jpg") or ".png"
            local path = MeizuLibrary.Folder .. "/" .. (fname or "image") .. ext
            local okW = pcall(function()
                if isfolder and not isfolder(MeizuLibrary.Folder) then makefolder(MeizuLibrary.Folder) end
                writefile(path, content)
            end)
            if okW then
                local okA, asset = pcall(getcustomasset, path)
                if okA and asset then return asset end
            end
        end
        return nil
    end
    return nil
end

--// ============================ NOTIFICATIONS (fix — không dùng AutomaticSize) ============================
MeizuLibrary.Notify = function(a, b)
    local cfg = (a == MeizuLibrary) and b or a
    if type(cfg) == "string" then cfg = {Content = cfg, Duration = tonumber(b)} end
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
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Parent = holder,
        })
        MeizuLibrary._NotifHolder = holder
    end

    MeizuLibrary._NotifCount = MeizuLibrary._NotifCount + 1

    -- Tính kích thước thủ công
    local WIDTH = 300
    local PAD_T, PAD_B, PAD_L, PAD_R = 12, 14, 14, 10
    local textW = WIDTH - PAD_L - 6 - PAD_R
    local titleH = 16
    local contentH = 0
    if cfg.Content then
        contentH = math.min(MeasureTextHeight(cfg.Content, FONT_MAIN, 12, textW) + 2, 96)
    end
    local cardH = PAD_T + titleH + (cfg.Content and (5 + contentH) or 0) + PAD_B + 3

    local Card = New("CanvasGroup", {
        BackgroundColor3 = T("Notification"),
        Size = UDim2.fromOffset(WIDTH, cardH),
        GroupTransparency = 1,
        ClipsDescendants = true,
        LayoutOrder = -MeizuLibrary._NotifCount,
        BorderSizePixel = 0,
        ZIndex = 200,
        Parent = holder,
    })
    Register(Card, {BackgroundColor3 = "Notification"})
    New("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Card})
    local CardStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.4, Parent = Card})
    Register(CardStroke, {Color = "Stroke"})

    local Bar = New("Frame", {
        BackgroundColor3 = MeizuLibrary.Accent,
        Position = UDim2.new(0, 0, 0, PAD_T),
        Size = UDim2.new(0, 3, 0, cardH - PAD_T - PAD_B),
        BorderSizePixel = 0, ZIndex = 201, Parent = Card,
    })
    RegisterAccent(Bar, "BackgroundColor3")
    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Bar})

    local NTitle = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, PAD_L + 6, 0, PAD_T),
        Size = UDim2.new(1, -(PAD_L + 6 + PAD_R + 22), 0, titleH),
        Font = FONT_BOLD, TextSize = 13,
        TextColor3 = T("Text"), TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Text = cfg.Title or "Notification",
        ZIndex = 201, Parent = Card,
    })
    Register(NTitle, {TextColor3 = "Text"})

    local NClose = New("TextButton", {
        Text = "X", AutoButtonColor = false, BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -6, 0, PAD_T - 2),
        Size = UDim2.fromOffset(22, 20),
        Font = FONT_BOLD, TextSize = 12,
        TextColor3 = T("SubText"), ZIndex = 201, Parent = Card,
    })
    Register(NClose, {TextColor3 = "SubText"})
    NClose.MouseEnter:Connect(function() Tween(NClose, 0.15, {TextColor3 = T("Text")}) end)
    NClose.MouseLeave:Connect(function() Tween(NClose, 0.2, {TextColor3 = T("SubText")}) end)

    if cfg.Content then
        local NContent = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, PAD_L + 6, 0, PAD_T + titleH + 5),
            Size = UDim2.new(1, -(PAD_L + 6 + PAD_R), 0, contentH),
            Font = FONT_MAIN, TextSize = 12,
            TextColor3 = T("SubText"),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true, RichText = true,
            Text = cfg.Content, ZIndex = 201, Parent = Card,
        })
        Register(NContent, {TextColor3 = "SubText"})
    end

    local ProgTrack = New("Frame", {
        BackgroundColor3 = T("Track"), BackgroundTransparency = 0.5,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 3),
        BorderSizePixel = 0, ZIndex = 200, Parent = Card,
    })
    Register(ProgTrack, {BackgroundColor3 = "Track"})
    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ProgTrack})
    local ProgFill = New("Frame", {
        BackgroundColor3 = MeizuLibrary.Accent,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 3),
        BorderSizePixel = 0, ZIndex = 201, Parent = Card,
    })
    RegisterAccent(ProgFill, "BackgroundColor3")
    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ProgFill})

    local closed = false
    local function Close()
        if closed then return end
        closed = true
        local sc = Card:FindFirstChildOfClass("UIScale")
        Tween(Card, 0.2, {GroupTransparency = 1})
        if sc then Tween(sc, 0.2, {Scale = 0.88}, Enum.EasingStyle.Quint) end
        task.delay(0.22, function() if Card then Card:Destroy() end end)
    end
    NClose.Activated:Connect(Close)

    local scale = New("UIScale", {Scale = 0.85, Parent = Card})
    Tween(Card, 0.25, {GroupTransparency = 0})
    Tween(scale, 0.35, {Scale = 1}, Enum.EasingStyle.Back)
    PlaySound("rbxasset://sounds/electronicpingshort.wav", 0.25, 1.15)

    local dur = tonumber(cfg.Duration) or 5
    if dur > 0 then
        Tween(ProgFill, dur, {Size = UDim2.new(0, 0, 0, 3)}, Enum.EasingStyle.Linear)
        task.delay(dur, Close)
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

function MeizuLibrary:SaveSettings(name)
    if not writefile then return false end
    name = tostring(name or "config")
    local data = {}
    for flag, el in pairs(self._FlagElems) do
        local ok, v = pcall(el.Get)
        if ok and type(v) ~= "function" then
            data[flag] = Serialize(v)
        end
    end
    data["__language"] = self.Language
    if self._ToggleImage then
        data["__toggleimage"] = self._ToggleImage
    end
    local ok = pcall(function()
        if isfolder and not isfolder(self.Folder) then makefolder(self.Folder) end
        writefile(self.Folder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    end)
    return ok
end

function MeizuLibrary:LoadSettings(name)
    if not readfile then return false end
    name = tostring(name or "config")
    local okR, content = pcall(readfile, self.Folder .. "/" .. name .. ".json")
    if not okR then return false end
    local okD, data = pcall(function() return HttpService:JSONDecode(content) end)
    if not okD or type(data) ~= "table" then return false end
    for flag, v in pairs(data) do
        if flag == "__language" then
            self.Language = (v == "en") and "en" or "vi"
        elseif flag == "__toggleimage" then
            -- Khôi phục hình nút nổi đã lưu trong config
            if type(v) == "string" and v ~= "" and type(self._ApplyToggleImage) == "function" then
                pcall(self._ApplyToggleImage, v)
            end
        else
            local el = self._FlagElems[flag]
            if el then pcall(el.Set, Deserialize(v)) end
        end
    end
    pcall(function() self:_ApplyLocalization() end)
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
    if self._ScreenGui then
        pcall(function() self._ScreenGui:Destroy() end)
        self._ScreenGui = nil
    end
    self._ThemeObjs, self._AccentObjs, self._ThemeHooks, self._FlagElems = {}, {}, {}, {}
    self._NotifHolder = nil
end

--// ============================ CREATE WINDOW ============================
MeizuLibrary.CreateWindow = function(a, b)
    local config
    if a == MeizuLibrary then config = b else config = a end
    config = config or {}

    if MeizuLibrary._ScreenGui then MeizuLibrary:Destroy() end
    MeizuLibrary.Destroyed = false

    if config.Theme and MeizuLibrary.Themes[config.Theme] then MeizuLibrary.Theme = config.Theme end
    if typeof(config.Accent) == "Color3" then MeizuLibrary.Accent = config.Accent end
    if config.ToggleKeybind then MeizuLibrary.ToggleKeybind = config.ToggleKeybind end
    if config.Language == "en" or config.Language == "vi" then MeizuLibrary.Language = config.Language end

    local Window = {_Tabs = {}, _CurrentTab = nil, _BootSelected = false}
    MeizuLibrary._Window = Window

    local ScreenGui = CreateScreenGui()
    MeizuLibrary._ScreenGui = ScreenGui

    local WinSize = config.Size or UDim2.fromOffset(660, 440)
    local W, H = WinSize.X.Offset, WinSize.Y.Offset
    local SIDEBAR_W = 185

    local isOpen = false
    local IconWrap

    local Main = New("CanvasGroup", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(W, H),
        BackgroundColor3 = T("Window"),
        BorderSizePixel = 0,
        GroupTransparency = 1,
        Visible = false,
        Parent = ScreenGui,
    })
    Register(Main, {BackgroundColor3 = "Window"})
    New("UICorner", {CornerRadius = UDim.new(0, 14), Parent = Main})
    local MainStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.3, Parent = Main})
    Register(MainStroke, {Color = "Stroke"})
    local MainScale = New("UIScale", {Scale = 0.92, Parent = Main})

    New("ImageLabel", {
        Name = "Shadow", BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 80, 1, 80),
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.45,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = 0, Parent = Main,
    })

    local Sidebar = New("Frame", {
        Name = "Sidebar", BackgroundColor3 = T("Sidebar"),
        Size = UDim2.new(0, SIDEBAR_W, 1, 0), BorderSizePixel = 0, Parent = Main,
    })
    Register(Sidebar, {BackgroundColor3 = "Sidebar"})
    New("UICorner", {CornerRadius = UDim.new(0, 14), Parent = Sidebar})

    local Content = New("Frame", {
        Name = "Content", BackgroundColor3 = T("Window"),
        Position = UDim2.new(0, SIDEBAR_W - 14, 0, 0),
        Size = UDim2.new(1, -(SIDEBAR_W + INFO_PANEL_WIDTH + 6), 1, 0),
        BorderSizePixel = 0, Parent = Main,
    })
    Register(Content, {BackgroundColor3 = "Window"})
    New("UICorner", {CornerRadius = UDim.new(0, 14), Parent = Content})

    --// ============ PANEL BÊN PHẢI — TÊN TAB + GIẢI THÍCH ============
    -- Như Maru Hub: cột phải hiển thị tab đang chọn & dòng mô tả tác dụng của nó
    local InfoPanel, InfoBadge, InfoIcon, InfoLetter, InfoName, InfoDesc, InfoBadgeScale
    if config.InfoPanel ~= false then
        InfoPanel = New("Frame", {
            Name = "InfoPanel",
            BackgroundColor3 = T("Sidebar"),
            Position = UDim2.new(1, -(INFO_PANEL_WIDTH + 10), 0, 44),
            Size = UDim2.new(0, INFO_PANEL_WIDTH, 1, -54),
            BorderSizePixel = 0, Parent = Main,
        })
        Register(InfoPanel, {BackgroundColor3 = "Sidebar"})
        New("UICorner", {CornerRadius = UDim.new(0, 12), Parent = InfoPanel})
        local IPStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.4, Parent = InfoPanel})
        Register(IPStroke, {Color = "Stroke"})

        local InfoCaption = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 12),
            Size = UDim2.new(1, -28, 0, 12),
            Font = FONT_BOLD, TextSize = 10,
            TextColor3 = T("SubText"), TextXAlignment = Enum.TextXAlignment.Left,
            Text = MeizuLibrary:_Translate("Current Tab"),
            Parent = InfoPanel,
        })
        Register(InfoCaption, {TextColor3 = "SubText"})
        pcall(function() InfoCaption:SetAttribute("MeizuLocKey", "Current Tab") end)

        InfoBadge = New("Frame", {
            Name = "InfoBadge",
            Position = UDim2.new(0, 14, 0, 30),
            Size = UDim2.fromOffset(46, 46),
            BackgroundColor3 = T("Tab"),
            BorderSizePixel = 0, Parent = InfoPanel,
        })
        Register(InfoBadge, {BackgroundColor3 = "Tab"})
        New("UICorner", {CornerRadius = UDim.new(0, 13), Parent = InfoBadge})
        local IBStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.35, Parent = InfoBadge})
        Register(IBStroke, {Color = "Stroke"})
        New("UIGradient", {
            Rotation = 115,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.25),
                NumberSequenceKeypoint.new(0.6, 0.7),
                NumberSequenceKeypoint.new(1, 0.92),
            }),
            Parent = InfoBadge,
        })
        InfoBadgeScale = New("UIScale", {Scale = 1, Parent = InfoBadge})

        InfoIcon = New("ImageLabel", {
            Name = "InfoIcon",
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(27, 27),
            ScaleType = Enum.ScaleType.Fit,
            Visible = false, Parent = InfoBadge,
        })
        InfoLetter = New("TextLabel", {
            Name = "InfoLetter",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Font = FONT_BOLD, TextSize = 20,
            TextColor3 = MeizuLibrary.Accent,
            Text = "—", Parent = InfoBadge,
        })
        RegisterAccent(InfoLetter, "TextColor3")

        InfoName = New("TextLabel", {
            Name = "InfoName",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 86),
            Size = UDim2.new(1, -28, 0, 38),
            Font = FONT_BOLD, TextSize = 15,
            TextColor3 = T("Text"),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Text = "—", Parent = InfoPanel,
        })
        Register(InfoName, {TextColor3 = "Text"})

        local InfoDivider = New("Frame", {
            Name = "InfoDivider",
            BackgroundColor3 = T("Stroke"),
            BackgroundTransparency = 0.45,
            Position = UDim2.new(0, 14, 0, 130),
            Size = UDim2.new(1, -28, 0, 1),
            BorderSizePixel = 0, Parent = InfoPanel,
        })
        Register(InfoDivider, {BackgroundColor3 = "Stroke"})

        InfoDesc = New("TextLabel", {
            Name = "InfoDesc",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 138),
            Size = UDim2.new(1, -28, 1, -150),
            Font = FONT_MAIN, TextSize = 11,
            TextColor3 = T("SubText"),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            Text = "", Parent = InfoPanel,
        })
        Register(InfoDesc, {TextColor3 = "SubText"})
    end

    --// VÙNG LOGO + TÊN SCRIPT (như Maru Hub — logo tròn bên trái, tên + phiên bản bên phải)
    local LogoBadge = New("Frame", {
        Name = "LogoBadge",
        Position = UDim2.new(0, 12, 0, 10),
        Size = UDim2.fromOffset(36, 36),
        BackgroundColor3 = T("Element"),
        BorderSizePixel = 0, Parent = Sidebar,
    })
    Register(LogoBadge, {BackgroundColor3 = "Element"})
    New("UICorner", {CornerRadius = UDim.new(0, 11), Parent = LogoBadge})
    local LBStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.35, Parent = LogoBadge})
    Register(LBStroke, {Color = "Stroke"})
    New("UIGradient", {
        Rotation = 115,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(0.6, 0.65),
            NumberSequenceKeypoint.new(1, 0.9),
        }),
        Parent = LogoBadge,
    })
    local LogoLetter = New("TextLabel", {
        Name = "LogoLetter",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Font = FONT_BOLD, TextSize = 16,
        TextColor3 = MeizuLibrary.Accent,
        Text = "M", Parent = LogoBadge,
    })
    RegisterAccent(LogoLetter, "TextColor3")
    local LogoImage = New("ImageLabel", {
        Name = "LogoImage",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -8, 1, -8),
        ScaleType = Enum.ScaleType.Fit,
        Visible = false, Parent = LogoBadge,
    })
    task.spawn(function()
        local src = config.Logo or TOGGLE_BUTTON_IMAGE
        local asset = ResolveImageAsset(src, "logo")
        if asset and LogoImage.Parent then
            LogoImage.Image = asset
            LogoImage.Visible = true
            LogoLetter.Visible = false
        end
    end)

    local TitleLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 58, 0, 11),
        Size = UDim2.new(1, -68, 0, 18),
        Font = FONT_BOLD, TextSize = 15,
        TextColor3 = T("Text"), TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Text = config.Title or "Meizu Library",
        Parent = Sidebar,
    })
    Register(TitleLabel, {TextColor3 = "Text"})
    local SubLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 58, 0, 31),
        Size = UDim2.new(1, -68, 0, 13),
        Font = FONT_MAIN, TextSize = 11,
        TextColor3 = T("SubText"), TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Text = config.SubTitle or ("v" .. MeizuLibrary.Version),
        Parent = Sidebar,
    })
    Register(SubLabel, {TextColor3 = "SubText"})

    local SearchBox = New("TextBox", {
        Position = UDim2.new(0, 14, 0, 56),
        Size = UDim2.new(1, -28, 0, 30),
        BackgroundColor3 = T("Input"),
        Text = "", PlaceholderText = MeizuLibrary:_Translate("Search..."),
        PlaceholderColor3 = T("Placeholder"),
        TextColor3 = T("Text"),
        Font = FONT_MAIN, TextSize = 12,
        ClearTextOnFocus = false, BorderSizePixel = 0,
        Parent = Sidebar,
    })
    Register(SearchBox, {BackgroundColor3 = "Input", PlaceholderColor3 = "Placeholder", TextColor3 = "Text"})
    New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = SearchBox})
    New("UIPadding", {PaddingLeft = UDim.new(0, 10), Parent = SearchBox})
    pcall(function() SearchBox:SetAttribute("MeizuLocKey", "Search...") end)

    local TabsHolder = New("ScrollingFrame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 96),
        Size = UDim2.new(1, -20, 1, -150),
        ScrollBarThickness = 2,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BorderSizePixel = 0, Parent = Sidebar,
    })
    RegisterAccent(TabsHolder, "ScrollBarImageColor3")
    New("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = TabsHolder})

    local PlayerCard = New("Frame", {
        Position = UDim2.new(0, 10, 1, -46),
        Size = UDim2.new(1, -20, 0, 38),
        BackgroundColor3 = T("Element"),
        BorderSizePixel = 0, Parent = Sidebar,
    })
    Register(PlayerCard, {BackgroundColor3 = "Element"})
    New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = PlayerCard})
    local Avatar = New("ImageLabel", {
        BackgroundColor3 = T("Tab"),
        Position = UDim2.new(0, 5, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.fromOffset(28, 28), BorderSizePixel = 0, Parent = PlayerCard,
    })
    Register(Avatar, {BackgroundColor3 = "Tab"})
    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Avatar})
    task.spawn(function()
        local ok, thumb = pcall(function()
            return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        end)
        if ok then Avatar.Image = thumb end
    end)
    local PName = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 40, 0, 0),
        Size = UDim2.new(1, -48, 1, 0),
        Font = FONT_BOLD, TextSize = 12,
        TextColor3 = T("Text"), TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Text = LocalPlayer.DisplayName,
        Parent = PlayerCard,
    })
    Register(PName, {TextColor3 = "Text"})

    local function CircleBtn(xoff)
        local btn = New("TextButton", {
            Text = "", AutoButtonColor = false, BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, xoff, 0, 10),
            Size = UDim2.fromOffset(22, 22),
            ZIndex = 40, BorderSizePixel = 0, Parent = Main,
        })
        Register(btn, {BackgroundColor3 = "Tab"})
        New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = btn})
        btn.MouseEnter:Connect(function() Tween(btn, 0.15, {BackgroundTransparency = 0.3}) end)
        btn.MouseLeave:Connect(function() Tween(btn, 0.2, {BackgroundTransparency = 1}) end)
        return btn
    end
    local MinBtn = CircleBtn(-62)
    local MinBar = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(0, 8, 0, 2), BackgroundColor3 = T("SubText"),
        BorderSizePixel = 0, ZIndex = 41, Parent = MinBtn,
    })
    Register(MinBar, {BackgroundColor3 = "SubText"})
    local CloseBtn = CircleBtn(-34)
    for _, rot in ipairs({45, -45}) do
        local l = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(0, 10, 0, 2), Rotation = rot,
            BackgroundColor3 = T("SubText"), BorderSizePixel = 0, ZIndex = 41, Parent = CloseBtn,
        })
        Register(l, {BackgroundColor3 = "SubText"})
    end

    --// KHOẢNG KHÔNG KÉO (fix lỗi vùng trên — hình 2)
    -- Dải kéo full-width, sạch, cao 36px: kéo Ở ĐÂU trong dải này cũng ăn,
    -- không đè lên nút Close/Min (ZIndex 40) và không chạm vào SearchBox (y=56)
    local DragHandle = New("Frame", {
        Name = "DragHandle",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 36),
        Active = true,           -- hút input: cứ nhả vào dải này là kéo được
        ZIndex = 30,             -- thấp hơn nút Min/Close (40) để không chèn ép
        Parent = Main,
    })
    MakeDraggable(DragHandle, Main, {GuardGameProcessed = true, ClampMode = "partial"})

    -- Thanh grip nhỏ ở giữa trên (affordance kiểu iOS — báo hiệu "kéo vào đây")
    local Grip = New("Frame", {
        Name = "Grip",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 5),
        Size = UDim2.new(0, 36, 0, 4),
        BackgroundColor3 = T("SubText"),
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0, ZIndex = 31, Parent = DragHandle,
    })
    Register(Grip, {BackgroundColor3 = "SubText"})
    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Grip})
    Grip.MouseEnter:Connect(function() Tween(Grip, 0.15, {BackgroundTransparency = 0.3, Size = UDim2.new(0, 48, 0, 4)}) end)
    Grip.MouseLeave:Connect(function() Tween(Grip, 0.2, {BackgroundTransparency = 0.6, Size = UDim2.new(0, 36, 0, 4)}) end)

    local TabContainer = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Parent = Content,
    })

    --// ============ BỘ MÔ TẢ TAB TỰ ĐỘNG (cho panel bên phải) ============
    -- Tác dụng của từng nhóm tab — chọn theo từ khoá trong tên tab, hỗ trợ vi/en
    local TAB_AUTO_DESC = {
        _default = {
            vi = "Các tuỳ chọn của tab này nằm ở cột bên trái — bật/tắt từng dòng bằng công tắc ở bên phải.",
            en = "Options for this tab are in the left column — toggle each row with the switch on the right.",
        },
        ["farm"] = {
            vi = "Bật/tắt và tinh chỉnh tính năng tự động canh tác: chọn mục tiêu, thứ tự nhiệm vụ và tối ưu thời gian farm.",
            en = "Toggle and fine-tune auto-farming: pick targets, quest order and optimise farming time.",
        },
        ["trạng th"] = {
            vi = "Theo dõi trạng thái server: sự kiện đảo, pha trăng, tiến độ boss và các chỉ số quan trọng trong phiên.",
            en = "Track server status: island events, moon phase, boss progress and key session stats.",
        },
        ["status"] = {
            vi = "Theo dõi trạng thái server: sự kiện đảo, pha trăng, tiến độ boss và các chỉ số quan trọng trong phiên.",
            en = "Track server status: island events, moon phase, boss progress and key session stats.",
        },
        ["teleport"] = {
            vi = "Dịch chuyển tức thời đến đảo, NPC hoặc khu vực đã mở khoá — không cần bay thủ công.",
            en = "Instantly teleport to islands, NPCs or unlocked areas — no manual flying.",
        },
        ["esp"] = {
            vi = "Hiển thị người chơi, vật phẩm và mục tiêu xuyên tường bằng khung tên và đường kẻ hỗ trợ.",
            en = "See players, items and targets through walls with highlight boxes and helper lines.",
        },
        ["pvp"] = {
            vi = "Hỗ trợ chiến đấu PvP: tự né, combo kỹ năng và khoá mục tiêu khi giao tranh.",
            en = "PvP combat aids: auto-dodge, skill combos and target locking during fights.",
        },
        ["player"] = {
            vi = "Tinh chỉnh nhân vật của bạn: tốc độ chạy, lực nhảy, vô hại và các chỉ số cơ thể.",
            en = "Tune your character: walk speed, jump power, noclip and body stats.",
        },
        ["misc"] = {
            vi = "Các tiện ích bổ sung: tự bán đồ, tự lưu kịch bản và hàng trăm tính năng linh tinh khác.",
            en = "Extra utilities: auto-sell, auto-join and many miscellaneous quality-of-life features.",
        },
        ["setting"] = {
            vi = "Cấu hình library: đổi theme, màu nhấn, ngôn ngữ, phím tắt, hình nút nổi và quản lý config.",
            en = "Library settings: theme, accent color, language, keybinds, toggle image and config management.",
        },
        ["cài đặt"] = {
            vi = "Cấu hình library: đổi theme, màu nhấn, ngôn ngữ, phím tắt, hình nút nổi và quản lý config.",
            en = "Library settings: theme, accent color, language, keybinds, toggle image and config management.",
        },
        ["shop"] = {
            vi = "Mua nhanh vật phẩm, trái ác quỷ và nâng cấp từ các NPC bán hàng trong game.",
            en = "Quickly buy items, fruits and upgrades from in-game shop NPCs.",
        },
        ["vật phẩm"] = {
            vi = "Danh sách vật phẩm: sử dụng, hợp nhất và theo dõi đồ bạn đã nhặt được trong phiên.",
            en = "Item list: use, merge and track the loot you collected this session.",
        },
        ["quest"] = {
            vi = "Tự động nhận và hoàn thành nhiệm vụ theo cấp độ hiện tại của bạn.",
            en = "Automatically accept and complete quests matching your current level.",
        },
        ["nhiệm vụ"] = {
            vi = "Tự động nhận và hoàn thành nhiệm vụ theo cấp độ hiện tại của bạn.",
            en = "Automatically accept and complete quests matching your current level.",
        },
        ["main"] = {
            vi = "Nhóm tính năng chính của script — những công dụng quan trọng nhất nên bật trước.",
            en = "The script's main features — the most important toggles to enable first.",
        },
        ["chính"] = {
            vi = "Nhóm tính năng chính của script — những công dụng quan trọng nhất nên bật trước.",
            en = "The script's main features — the most important toggles to enable first.",
        },
    }

    --// ============ CẬP NHẬT PANEL THÔNG TIN (tên tab + giải thích) ============
    local function UpdateInfoPanel(tab)
        if not InfoPanel or not tab then return end
        local locName = MeizuLibrary:_Translate(tab._Name or "")
        InfoName.Text = locName
        pcall(function() InfoName:SetAttribute("MeizuLocKey", tab._Name) end)

        -- Icon: ưu tiên icon của tab, không có thì dùng chữ cái đầu
        if tab._Icon then
            InfoIcon.Image = tab._Icon
            InfoIcon.Visible = true
            InfoLetter.Visible = false
        else
            local first = (utf8 and utf8.sub) and utf8.sub(locName, 1, 1) or string.sub(locName, 1, 1)
            InfoLetter.Text = string.upper(first)
            InfoLetter.Visible = true
            InfoIcon.Visible = false
        end

        -- Mô tả: mô tả tuỳ chỉnh > từ khoá tự động > mặc định
        local desc = tab._Desc
        if not desc then
            local lname = string.lower(tab._Name or "")
            for kw, pair in pairs(TAB_AUTO_DESC) do
                if kw ~= "_default" and string.find(lname, kw, 1, true) then
                    desc = pair[MeizuLibrary.Language] or pair.vi
                    break
                end
            end
        end
        if not desc then
            local d = TAB_AUTO_DESC._default
            desc = d[MeizuLibrary.Language] or d.vi
        end
        InfoDesc.Text = desc

        -- Hiệu ứng nhẹ mỗi lần đổi tab: icon nảy, chữ hiện dần
        InfoBadgeScale.Scale = 0.78
        Tween(InfoBadgeScale, 0.35, {Scale = 1}, Enum.EasingStyle.Back)
        InfoName.TextTransparency = 1
        InfoDesc.TextTransparency = 1
        Tween(InfoName, 0.28, {TextTransparency = 0})
        task.delay(0.06, function()
            if InfoDesc and InfoDesc.Parent then
                Tween(InfoDesc, 0.32, {TextTransparency = 0})
            end
        end)
    end
    Window._InfoRefresh = UpdateInfoPanel

    function Window:SetTabInfo(desc)
        local t = Window._CurrentTab
        if t then
            t._Desc = desc
            UpdateInfoPanel(t)
        end
    end

    --// ==================== ELEMENT FACTORY ====================
    local function BindElements(target, container, tab)
        if target.CreateSection then return end

        local function MakeCard(height, interactive)
            local Card
            if interactive then
                Card = New("TextButton", {
                    Text = "", AutoButtonColor = false,
                    BackgroundColor3 = T("Element"),
                    Size = UDim2.new(1, 0, 0, height),
                    ClipsDescendants = true, BorderSizePixel = 0,
                    Parent = container,
                })
            else
                Card = New("Frame", {
                    BackgroundColor3 = T("Element"),
                    Size = UDim2.new(1, 0, 0, height),
                    ClipsDescendants = true, BorderSizePixel = 0,
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
                    ZIndex = 5, BorderSizePixel = 0, Parent = Card,
                })
                New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Hover})
                Card.MouseEnter:Connect(function() Tween(Hover, 0.15, {BackgroundTransparency = 0.93}) end)
                Card.MouseLeave:Connect(function() Tween(Hover, 0.25, {BackgroundTransparency = 1}) end)
            end
            return Card
        end

        local function AddText(Card, title, desc, rightSpace)
            rightSpace = rightSpace or 70
            local Title = New("TextLabel", {
                BackgroundTransparency = 1,
                Font = FONT_MEDIUM, TextSize = 14,
                Text = title or "",
                TextColor3 = T("Text"),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = desc and UDim2.new(0, 12, 0, 8) or UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -rightSpace, desc and 0 or 1, desc and 14 or 0),
                Parent = Card,
            })
            Register(Title, {TextColor3 = "Text"})
            pcall(function() Title:SetAttribute("MeizuLocKey", title) end)
            if desc then
                local Desc = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = FONT_MAIN, TextSize = 12,
                    Text = desc, TextColor3 = T("SubText"),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Position = UDim2.new(0, 12, 0, 24),
                    Size = UDim2.new(1, -rightSpace, 0, 12),
                    Parent = Card,
                })
                Register(Desc, {TextColor3 = "SubText"})
                pcall(function() Desc:SetAttribute("MeizuLocDesc", desc) end)
            end
        end

        local function AddSearch(Card, text)
            table.insert(tab._Elements, {Frame = Card, Text = string.lower(tostring(text or ""))})
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
                BorderSizePixel = 0, Parent = Head,
            })
            RegisterAccent(Bar, "BackgroundColor3")
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Bar})
            local SecLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 13, 0, 0),
                Size = UDim2.new(1, -13, 1, 0),
                Font = FONT_BOLD, TextSize = 11,
                Text = string.upper(tostring(name or "Section")),
                TextColor3 = T("SubText"),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Head,
            })
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
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
                BorderSizePixel = 0, Parent = Card,
            })
            Register(Track, {BackgroundColor3 = "ToggleOff"})
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Track})
            local Knob = New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 3, 0.5, 0),
                Size = UDim2.fromOffset(16, 16),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0, Parent = Track,
            })
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Knob})

            local state = (cfg.Default == true)
            local function Render(v)
                if not Track.Parent then return end
                Tween(Track, 0.25, {BackgroundColor3 = v and MeizuLibrary.Accent or T("ToggleOff")})
                Tween(Knob, 0.3, {Position = UDim2.new(0, v and 23 or 3, 0.5, 0)}, Enum.EasingStyle.Back)
            end
            local function Set(v, fire)
                v = (v == true)
                state = v
                Render(v)
                if cfg.Flag then MeizuLibrary.Flags[cfg.Flag] = v end
                if fire then SafeCall(cfg.Callback, v) end
            end
            Card.Activated:Connect(function() Set(not state, true) end)
            Render(state)
            OnThemeChange(function() Render(state) end)

            local el = {Frame = Card, Get = function() return state end, Set = function(v) Set(v, false) end}
            BindFlag(el, cfg.Flag, state)
            AddSearch(Card, cfg.Title)
            return el
        end

        --// SLIDER (kéo mượt trên mobile)
        function target:CreateSlider(cfg)
            cfg = cfg or {}
            local min, max = cfg.Min or 0, cfg.Max or 100
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
                Font = FONT_BOLD, TextSize = 12,
                TextColor3 = T("Text"), Text = "",
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
                BorderSizePixel = 0, Parent = Holder,
            })
            Register(Track, {BackgroundColor3 = "Track"})
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Track})
            local Fill = New("Frame", {
                BackgroundColor3 = MeizuLibrary.Accent,
                Size = UDim2.new(0, 0, 1, 0), BorderSizePixel = 0, Parent = Track,
            })
            RegisterAccent(Fill, "BackgroundColor3")
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Fill})
            local Knob = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.fromOffset(14, 14),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0, ZIndex = 3, Parent = Holder,
            })
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Knob})
            local KnobStroke = New("UIStroke", {Color = MeizuLibrary.Accent, Thickness = 2, Parent = Knob})
            RegisterAccent(KnobStroke, "Color")

            local value = cfg.Default or min
            local function Format(v)
                if rounding > 0 then return string.format("%." .. rounding .. "f", v) end
                return tostring(math.floor(v + 0.5))
            end
            local function Set(v, fire)
                v = math.clamp(tonumber(v) or min, min, max)
                value = v
                local pct = math.clamp((v - min) / (max - min), 0, 1)
                Fill.Size = UDim2.new(pct, 0, 1, 0)
                Knob.Position = UDim2.new(pct, 0, 0.5, 0)
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
                Set(v, true)
            end
            Holder.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    releaseGuard = BeginGuard(Card)
                    Tween(Knob, 0.15, {Size = UDim2.fromOffset(16, 16)})
                    UpdateFromX(input.Position.X)
                    AddDrag({
                        OnChanged = function(inp)
                            if dragging then UpdateFromX(inp.Position.X) end
                        end,
                        OnEnd = function()
                            dragging = false
                            if releaseGuard then releaseGuard() releaseGuard = nil end
                            Tween(Knob, 0.2, {Size = UDim2.fromOffset(14, 14)})
                        end,
                    })
                end
            end)

            local el = {Frame = Card, Get = function() return value end, Set = function(v) Set(v, false) end}
            Set(value, false)
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
                Font = FONT_MAIN, TextSize = 12,
                TextColor3 = T("SubText"),
                TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Text = multi and "0 selected" or "Select...",
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
                    BorderSizePixel = 0, Parent = Arrow,
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
                Position = UDim2.new(0, 8, 0, headH + 2),
                Size = UDim2.new(1, -16, 0, 0),
                CanvasSize = UDim2.new(),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 3, ScrollBarImageTransparency = 0.4,
                Visible = false, ClipsDescendants = true,
                BorderSizePixel = 0, ZIndex = 8, Parent = Card,
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
                Tween(Card, 0.28, {Size = UDim2.new(1, 0, 0, headH + (v and (listH + 6) or 0))}, Enum.EasingStyle.Quint)
                Tween(List, 0.28, {Size = UDim2.new(1, -16, 0, v and listH or 0)}, Enum.EasingStyle.Quint)
                Tween(Arrow, 0.25, {Rotation = v and 180 or 0})
                if v then
                    for i, Opt in ipairs(OptionBtns) do
                        Opt.TextTransparency = 1
                        task.delay(i * 0.02, function()
                            if Opt.Parent then Tween(Opt, 0.15, {TextTransparency = 0}) end
                        end)
                    end
                else
                    task.delay(0.3, function()
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
                    SelectedLabel.Text = (#list > 0) and table.concat(list, ", ") or "0 selected"
                    for _, Opt in ipairs(OptionBtns) do
                        local isSel = selected[Opt.Text] == true
                        local d = Opt:FindFirstChild("Dot")
                        if d then
                            Tween(d, 0.2, {
                                BackgroundTransparency = isSel and 0 or 1,
                                Size = UDim2.fromOffset(isSel and 12 or 6, isSel and 12 or 6),
                            })
                        end
                    end
                else
                    SelectedLabel.Text = selected and tostring(selected) or "Select..."
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
                        Text = tostring(optName), AutoButtonColor = false,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 24),
                        Font = FONT_MAIN, TextSize = 12,
                        TextColor3 = T("Text"),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 9, LayoutOrder = i,
                        BorderSizePixel = 0, Parent = List,
                    })
                    New("UIPadding", {PaddingLeft = UDim.new(0, 8), Parent = Opt})
                    if multi then
                        local Dot = New("Frame", {
                            Name = "Dot",
                            AnchorPoint = Vector2.new(1, 0.5),
                            Position = UDim2.new(1, -6, 0.5, 0),
                            Size = UDim2.fromOffset(6, 6),
                            BackgroundColor3 = MeizuLibrary.Accent,
                            BackgroundTransparency = 1,
                            ZIndex = 10, BorderSizePixel = 0, Parent = Opt,
                        })
                        RegisterAccent(Dot, "BackgroundColor3")
                        New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Dot})
                    end
                    Opt.MouseEnter:Connect(function() Tween(Opt, 0.12, {BackgroundTransparency = 0.92}) end)
                    Opt.MouseLeave:Connect(function() Tween(Opt, 0.2, {BackgroundTransparency = 1}) end)
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

            --// Cập nhật danh sách option động (hỗ trợ cả dd:Refresh(list) lẫn dd.Refresh(list))
            local function UpdateOptions(newOptions)
                if not Card.Parent then return end
                if newOptions == nil then newOptions = options end
                local copy = {}
                if typeof(newOptions) == "table" then
                    for _, v in ipairs(newOptions) do table.insert(copy, v) end
                end
                options = copy

                -- bỏ lựa chọn không còn tồn tại trong list mới
                local valid = {}
                for _, v in ipairs(options) do valid[v] = true end
                if multi then
                    for k in pairs(selected) do
                        if not valid[k] then selected[k] = nil end
                    end
                elseif selected ~= nil and not valid[selected] then
                    selected = nil
                end

                listH = math.min(#options * 26 + 10, 150)
                BuildOptions()
                Refresh(false)

                -- nếu đang mở thì co/giãn lại cho khớp list mới
                if open then
                    Tween(Card, 0.2, {Size = UDim2.new(1, 0, 0, headH + listH + 6)}, Enum.EasingStyle.Quint)
                    Tween(List, 0.2, {Size = UDim2.new(1, -16, 0, listH)}, Enum.EasingStyle.Quint)
                end
            end

            local function ArgOf(a, b)
                -- gọi bằng dấu ":" thì tham số đầu là chính el
                if a == el then return b end
                return a
            end

            el.UpdateOptions = function(a, b) UpdateOptions(ArgOf(a, b)) end
            el.Refresh       = el.UpdateOptions
            el.SetOptions    = el.UpdateOptions
            el.GetOptions = function() return options end
            el.AddOption = function(a, b)
                local opt = ArgOf(a, b)
                if opt == nil then return end
                local new = {}
                for _, v in ipairs(options) do table.insert(new, v) end
                table.insert(new, opt)
                UpdateOptions(new)
            end
            el.RemoveOption = function(a, b)
                local opt = ArgOf(a, b)
                local new = {}
                for _, v in ipairs(options) do
                    if v ~= opt then table.insert(new, v) end
                end
                UpdateOptions(new)
            end
            el.Clear = function() UpdateOptions({}) end

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
                Text = currentKey and currentKey.Name or "None",
                AutoButtonColor = false,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(90, 26),
                BackgroundColor3 = T("Input"),
                Font = FONT_MEDIUM, TextSize = 12,
                TextColor3 = T("SubText"),
                BorderSizePixel = 0, Parent = Card,
            })
            Register(BindBtn, {BackgroundColor3 = "Input"})
            New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = BindBtn})
            BindBtn.MouseEnter:Connect(function() Tween(BindBtn, 0.15, {TextColor3 = T("Text")}) end)
            BindBtn.MouseLeave:Connect(function() Tween(BindBtn, 0.2, {TextColor3 = T("SubText")}) end)

            BindBtn.Activated:Connect(function()
                if listening then return end
                listening = true
                BindBtn.Text = "..."
                local conn
                conn = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        conn:Disconnect()
                        listening = false
                        if input.KeyCode ~= Enum.KeyCode.Escape then
                            currentKey = input.KeyCode
                            BindBtn.Text = currentKey.Name
                            if cfg.Flag then MeizuLibrary.Flags[cfg.Flag] = currentKey.Name end
                            SafeCall(cfg.ChangedCallback, currentKey)
                        else
                            BindBtn.Text = currentKey and currentKey.Name or "None"
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
                PlaceholderText = cfg.Placeholder or "Type here...",
                PlaceholderColor3 = T("Placeholder"),
                TextColor3 = T("Text"),
                Font = FONT_MAIN, TextSize = 12,
                ClearTextOnFocus = false, ClipsDescendants = true,
                BorderSizePixel = 0, Parent = Card,
            })
            Register(Box, {BackgroundColor3 = "Input", PlaceholderColor3 = "Placeholder", TextColor3 = "Text"})
            New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Box})
            New("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = Box})

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
            Box.Focused:Connect(function() Tween(Box, 0.2, {Size = UDim2.fromOffset(180, 28)}) end)
            Box.FocusLost:Connect(function(enter)
                Tween(Box, 0.2, {Size = UDim2.fromOffset(160, 26)})
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
                Text = "", AutoButtonColor = false, BackgroundTransparency = 1,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(1, 0, 0, headH),
                ZIndex = 2, BorderSizePixel = 0, Parent = Card,
            })
            New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Header})
            Header.MouseEnter:Connect(function() Tween(Header, 0.15, {BackgroundTransparency = 0.94}) end)
            Header.MouseLeave:Connect(function() Tween(Header, 0.2, {BackgroundTransparency = 1}) end)

            AddText(Card, cfg.Title or "Color", cfg.Description, 60)

            local h, s, v = Color3.toHSV(cfg.Default or MeizuLibrary.Accent)
            local color = Color3.fromHSV(h, s, v)

            local Swatch = New("TextButton", {
                Text = "", AutoButtonColor = false,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(34, 22),
                BackgroundColor3 = color,
                ZIndex = 3, BorderSizePixel = 0, Parent = Card,
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
                ClipsDescendants = true, BorderSizePixel = 0,
                Active = true, ZIndex = 3, Parent = Panel,
            })
            New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SV})
            local GW = New("Frame", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, ZIndex = 4, Parent = SV})
            New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = GW})
            New("UIGradient", {Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}), Parent = GW})
            local GB = New("Frame", {BackgroundColor3 = Color3.fromRGB(0, 0, 0), Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, ZIndex = 5, Parent = SV})
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
                BorderSizePixel = 0, Active = true, ZIndex = 3, Parent = Panel,
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
                ZIndex = 4, BorderSizePixel = 0, Parent = HueBar,
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
                if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
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
                    Text = "", AutoButtonColor = false,
                    Size = UDim2.fromOffset(16, 16),
                    BackgroundColor3 = c, BorderSizePixel = 0, ZIndex = 3, Parent = PresetRow,
                })
                New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = p})
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
                Tween(Card, 0.3, {Size = UDim2.new(1, 0, 0, open and (panelY + PANEL_H + 8) or headH)}, Enum.EasingStyle.Quint)
                Tween(Panel, 0.3, {Size = UDim2.new(1, -24, 0, open and PANEL_H or 0)}, Enum.EasingStyle.Quint)
                if not open then
                    task.delay(0.32, function()
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

        --// PARAGRAPH (robust fixed-height layout)
        function target:CreateParagraph(cfg)
            cfg = cfg or {}
            local PAD_X, PAD_T, PAD_B, GAP = 12, 10, 10, 4
            local Card = MakeCard(40, false)

            local TitleLabel
            local ContentLabel

            local function ApplyLayout()
                if not Card or not Card.Parent then return end
                local width = math.max(120, Card.AbsoluteSize.X - (PAD_X * 2))
                local titleH = 0
                local contentH = 0

                if TitleLabel then
                    titleH = MeasureTextHeight(TitleLabel.Text, FONT_BOLD, 13, width)
                    TitleLabel.Size = UDim2.new(1, 0, 0, titleH)
                end
                if ContentLabel then
                    contentH = MeasureTextHeight(ContentLabel.Text, FONT_MAIN, 12, width) + 2
                    ContentLabel.Size = UDim2.new(1, 0, 0, contentH)
                end

                local total = PAD_T + titleH
                if TitleLabel and ContentLabel then
                    total = total + GAP
                end
                total = total + contentH + PAD_B
                Card.Size = UDim2.new(1, 0, 0, math.max(36, total))
            end

            Card.Size = UDim2.new(1, 0, 0, 40)
            Card.ClipsDescendants = false

            New("UIPadding", {
                PaddingTop = UDim.new(0, PAD_T),
                PaddingBottom = UDim.new(0, PAD_B),
                PaddingLeft = UDim.new(0, PAD_X),
                PaddingRight = UDim.new(0, PAD_X),
                Parent = Card,
            })
            local Layout = New("UIListLayout", {
                Padding = UDim.new(0, GAP),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = Card,
            })

            if cfg.Title then
                TitleLabel = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = FONT_BOLD, TextSize = 13,
                    Text = tostring(cfg.Title), TextColor3 = T("Text"),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    TextWrapped = true, RichText = false,
                    LayoutOrder = 1, Parent = Card,
                })
                Register(TitleLabel, {TextColor3 = "Text"})
            end

            if cfg.Content ~= nil then
                ContentLabel = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = FONT_MAIN, TextSize = 12,
                    Text = tostring(cfg.Content), TextColor3 = T("SubText"),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    TextWrapped = true, RichText = true,
                    LayoutOrder = 2, Parent = Card,
                })
                Register(ContentLabel, {TextColor3 = "SubText"})
            end

            AddSearch(Card, cfg.Title or cfg.Content)

            local element = {
                Frame = Card,
                TitleLabel = TitleLabel,
                ContentLabel = ContentLabel,
                SetTitle = function(self, text)
                    if TitleLabel and TitleLabel.Parent then
                        TitleLabel.Text = tostring(text or "")
                        ApplyLayout()
                    end
                end,
                SetContent = function(self, text, textColor)
                    if ContentLabel and ContentLabel.Parent then
                        ContentLabel.Text = tostring(text or "")
                        if textColor then ContentLabel.TextColor3 = textColor end
                        ApplyLayout()
                    end
                end,
            }

            local lastWidth = 0
            Card:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                local width = Card.AbsoluteSize.X
                if math.abs(width - lastWidth) > 0.5 then
                    lastWidth = width
                    task.defer(ApplyLayout)
                end
            end)

            task.defer(ApplyLayout)
            return element
        end
    end

    --// ==================== CREATE TAB ====================
    function Window:CreateTab(name, icon, order, desc)
        local Tab = {_Elements = {}}
        local btnOrder = order or (#Window._Tabs + 1)

        local Btn = New("TextButton", {
            Text = "", AutoButtonColor = false,
            BackgroundColor3 = T("Tab"), BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 34),
            LayoutOrder = btnOrder,
            BorderSizePixel = 0, Parent = TabsHolder,
        })
        Register(Btn, {BackgroundColor3 = "Tab"})
        New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Btn})

        local Indicator = New("Frame", {
            BackgroundColor3 = MeizuLibrary.Accent,
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(0, 3, 0, 0),
            BorderSizePixel = 0, Parent = Btn,
        })
        RegisterAccent(Indicator, "BackgroundColor3")
        New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Indicator})

        local xOffset = 14
        if icon then
            local Icon = New("ImageLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.fromOffset(18, 18),
                Image = icon, ImageTransparency = 0.2,
                ImageColor3 = T("SubText"),
                Parent = Btn,
            })
            Register(Icon, {ImageColor3 = "SubText"})
            xOffset = 38
        end

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, xOffset, 0, 0),
            Size = UDim2.new(1, xOffset - 10, 1, 0),
            Font = FONT_MEDIUM, TextSize = 13,
            Text = MeizuLibrary:_Translate(name), TextColor3 = T("SubText"),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = Btn,
        })
        Register(Label, {TextColor3 = "SubText"})
        pcall(function() Label:SetAttribute("MeizuLocKey", name) end)

        Btn.MouseEnter:Connect(function()
            if Window._CurrentTab ~= Tab then Tween(Btn, 0.15, {BackgroundTransparency = 0.55}) end
        end)
        Btn.MouseLeave:Connect(function()
            if Window._CurrentTab ~= Tab then Tween(Btn, 0.2, {BackgroundTransparency = 1}) end
        end)

        local Page = New("CanvasGroup", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Visible = false, GroupTransparency = 1,
            BorderSizePixel = 0, Parent = TabContainer,
        })
        local Scroll = New("ScrollingFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 3, ScrollBarImageTransparency = 0.3,
            BorderSizePixel = 0, Parent = Page,
        })
        RegisterAccent(Scroll, "ScrollBarImageColor3")
        New("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Scroll})
        New("UIPadding", {
            PaddingTop = UDim.new(0, 36), PaddingBottom = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = Scroll})

        function Tab:Select()
            if Window._CurrentTab == Tab then return end
            local prev = Window._CurrentTab
            Window._CurrentTab = Tab
            if prev then
                prev._Btn.BackgroundTransparency = 1
                Tween(prev._Label, 0.2, {TextColor3 = T("SubText")})
                Tween(prev._Indicator, 0.2, {Size = UDim2.new(0, 3, 0, 0)})
                prev._Page.Visible = false
            end
            Tween(Btn, 0.2, {BackgroundTransparency = 0})
            Tween(Label, 0.2, {TextColor3 = T("Text")})
            Tween(Indicator, 0.25, {Size = UDim2.new(0, 3, 0, 18)}, Enum.EasingStyle.Back)
            Page.Visible = true
            Page.GroupTransparency = 1
            Page.Position = UDim2.new(0, 18, 0, 0)
            Tween(Page, 0.3, {GroupTransparency = 0})
            Tween(Page, 0.35, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Quint)
            if Window._InfoRefresh then pcall(Window._InfoRefresh, Tab) end
        end

        Tab._Btn = Btn
        Tab._Label = Label
        Tab._Indicator = Indicator
        Tab._Page = Page
        Tab._Name = name
        Tab._Icon = icon
        Tab._Desc = desc
        Btn.Activated:Connect(function() Tab:Select() end)

        OnThemeChange(function()
            if not Btn.Parent then return end
            if Window._CurrentTab == Tab then
                Label.TextColor3 = T("Text")
            else
                Label.TextColor3 = T("SubText")
            end
        end)

        table.insert(Window._Tabs, Tab)
        BindElements(Tab, Scroll, Tab)
        return Tab
    end

    function Window:SelectTab(index)
        if type(index) == "string" then
            for _, t in ipairs(Window._Tabs) do
                if string.lower(t._Name or "") == string.lower(index) then
                    t:Select()
                    return
                end
            end
        else
            local t = Window._Tabs[tonumber(index) or 1]
            if t then t:Select() end
        end
    end

    --// ==================== OPEN / CLOSE ====================
    local function SetOpen(state)
        if state == isOpen then return end
        isOpen = state
        if state then
            Main.Visible = true
            Main.GroupTransparency = 1
            MainScale.Scale = 0.9
            Tween(MainScale, 0.4, {Scale = 1}, Enum.EasingStyle.Back)
            Tween(Main, 0.25, {GroupTransparency = 0})
            if not Window._BootSelected then
                Window._BootSelected = true
                if Window._Tabs[1] then Window._Tabs[1]:Select() end
            end
        else
            Tween(MainScale, 0.25, {Scale = 0.9}, Enum.EasingStyle.Quint)
            local tw = Tween(Main, 0.22, {GroupTransparency = 1})
            tw.Completed:Connect(function()
                if not isOpen and Main.Parent then Main.Visible = false end
            end)
        end
        if IconWrap then
            Tween(IconWrap, 0.5, {Rotation = state and 180 or 0}, Enum.EasingStyle.Back)
        end
        PlaySound("rbxasset://sounds/electronicpingshort.wav", 0.2, state and 1.1 or 0.9)
    end

    function Window:Toggle(state)
        if state == nil then state = not isOpen end
        SetOpen(state)
    end

    MinBtn.Activated:Connect(function() Window:Toggle(false) end)
    CloseBtn.Activated:Connect(function()
        Window:Dialog({
            Title = "Close UI",
            Content = "Bạn có muốn tắt hoàn toàn UI không?",
            Buttons = {
                {Title = "Cancel"},
                {Title = "Close", Variant = "Primary", Callback = function() MeizuLibrary:Destroy() end},
            },
        })
    end)

    --// ==================== KEYBIND TOẦN CỤC ====================
    table.insert(MeizuLibrary._Connections, UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if UserInputService:GetFocusedTextBox() then return end
        if input.UserInputType == Enum.UserInputType.Keyboard
        and input.KeyCode == MeizuLibrary.ToggleKeybind then
            Window:Toggle()
        end
    end))

    --// ==================== DIALOG (kích thước thủ công — fix) ====================
    function Window:Dialog(cfg)
        cfg = cfg or {}
        local DW = 340
        local PAD = 16
        local titleH = 18
        local contentH = 0
        if cfg.Content and cfg.Content ~= "" then
            contentH = MeasureTextHeight(cfg.Content, FONT_MAIN, 12, DW - PAD * 2) + 2
        end
        local buttons = cfg.Buttons or {{Title = "OK", Variant = "Primary"}}
        local gap, btnH = 8, 32
        local btnW = math.min(math.floor((DW - PAD * 2 - (#buttons - 1) * gap) / #buttons), 110)
        local rowW = #buttons * btnW + (#buttons - 1) * gap
        local cardH = PAD + titleH + (contentH > 0 and (8 + contentH) or 0) + 14 + btnH + PAD

        local Overlay = New("Frame", {
            BackgroundColor3 = T("Overlay"),
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ZIndex = 300, BorderSizePixel = 0,
            Parent = ScreenGui,
        })
        local Card = New("CanvasGroup", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(DW, cardH),
            BackgroundColor3 = T("Window"),
            GroupTransparency = 1,
            ZIndex = 301, BorderSizePixel = 0,
            Parent = Overlay,
        })
        Register(Card, {BackgroundColor3 = "Window"})
        New("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Card})
        local scale = New("UIScale", {Scale = 0.9, Parent = Card})

        local DTitle = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, PAD, 0, PAD),
            Size = UDim2.new(1, -PAD * 2, 0, titleH),
            Font = FONT_BOLD, TextSize = 15,
            TextColor3 = T("Text"), TextXAlignment = Enum.TextXAlignment.Left,
            Text = cfg.Title or "Dialog", ZIndex = 302, Parent = Card,
        })
        Register(DTitle, {TextColor3 = "Text"})

        if contentH > 0 then
            local DContent = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, PAD, 0, PAD + titleH + 8),
                Size = UDim2.new(1, -PAD * 2, 0, contentH),
                Font = FONT_MAIN, TextSize = 12,
                TextColor3 = T("SubText"), TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true, RichText = true, Text = cfg.Content,
                ZIndex = 302, Parent = Card,
            })
            Register(DContent, {TextColor3 = "SubText"})
        end

        local function Dismiss()
            Tween(Overlay, 0.2, {BackgroundTransparency = 1})
            Tween(scale, 0.18, {Scale = 0.92}, Enum.EasingStyle.Quint)
            Tween(Card, 0.18, {GroupTransparency = 1})
            task.delay(0.2, function() if Overlay then Overlay:Destroy() end end)
        end

        for i, bn in ipairs(buttons) do
            local isPrimary = (bn.Variant == "Primary")
            local B = New("TextButton", {
                Text = bn.Title or "OK", AutoButtonColor = false,
                Position = UDim2.new(0, DW - PAD - rowW + (i - 1) * (btnW + gap), 0, cardH - PAD - btnH),
                Size = UDim2.fromOffset(btnW, btnH),
                BackgroundColor3 = isPrimary and MeizuLibrary.Accent or T("Input"),
                Font = FONT_BOLD, TextSize = 12,
                TextColor3 = isPrimary and Color3.fromRGB(255, 255, 255) or T("SubText"),
                ZIndex = 302, BorderSizePixel = 0, Parent = Card,
            })
            New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = B})
            if not isPrimary then
                Register(B, {BackgroundColor3 = "Input"})
                Register(B, {TextColor3 = "SubText"})
                B.MouseEnter:Connect(function() Tween(B, 0.15, {TextColor3 = T("Text")}) end)
                B.MouseLeave:Connect(function() Tween(B, 0.2, {TextColor3 = T("SubText")}) end)
            else
                B.MouseEnter:Connect(function() Tween(B, 0.15, {BackgroundTransparency = 0.12}) end)
                B.MouseLeave:Connect(function() Tween(B, 0.2, {BackgroundTransparency = 0}) end)
            end
            B.Activated:Connect(function()
                Dismiss()
                SafeCall(bn.Callback)
            end)
        end

        Tween(Overlay, 0.2, {BackgroundTransparency = 0.4})
        Tween(scale, 0.3, {Scale = 1}, Enum.EasingStyle.Back)
        Tween(Card, 0.25, {GroupTransparency = 0})
    end

    --// ============ NÚT NỔI — LIQUID GLASS (iOS 26 style) ============
    -- Cấu trúc 5 lớp: bóng đổ → thân kính mờ → màu nhấn loang → vệt sáng specular → rim viền kính
    if config.ToggleUIButton ~= false then
        local RADIUS = TOGGLE_BUTTON_RADIUS or 15

        local ToggleBtn = New("Frame", {
            Name = "ToggleButton",
            Size = TOGGLE_BUTTON_SIZE,
            Position = TOGGLE_BUTTON_POSITION,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Active = true,
            ZIndex = 150,
            Parent = ScreenGui,
        })
        -- Bo góc TRÊN CHÍNH nút: trước đây thiếu UICorner ở đây khiến 2 UIStroke viền kính
        -- vẽ thành HÌNH VUÔNG bao quanh nút bo tròn → nhìn lệch/lỗi. Đây là 1 trong 2 lý do
        -- chính khiến Liquid Glass trước đây trông "không có hiệu ứng".
        New("UICorner", {CornerRadius = UDim.new(0, RADIUS), Parent = ToggleBtn})

        -- Bóng đổ mềm (đặt TRONG nút để tự theo khi kéo)
        New("ImageLabel", {
            Name = "Shadow", BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1, 44, 1, 44),
            Image = "rbxassetid://6014261993",
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            ImageTransparency = 0.5,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(49, 49, 450, 450),
            ZIndex = 148, Parent = ToggleBtn,
        })

        -- Lớp 0: thân kính TỐNG MÀU (tinted glass base) — nền kính thật sự,
        -- hiện rõ trên mọi nền game sáng/tối, không còn "tan biến" vào cảnh
        local GlassBase = New("Frame", {
            Name = "GlassBase",
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(14, 16, 24),
            BackgroundTransparency = 0.22,
            BorderSizePixel = 0, ZIndex = 150, Parent = ToggleBtn,
        })
        New("UICorner", {CornerRadius = UDim.new(0, RADIUS), Parent = GlassBase})
        New("UIGradient", {
            Rotation = 90,
            Color = ColorSequence.new(
                Color3.fromRGB(44, 48, 64),   -- đỉnh hửng sáng (bắt sáng trời)
                Color3.fromRGB(13, 15, 22)    -- đáy trầm xuống (chiều sâu kính)
            ),
            Parent = GlassBase,
        })
        New("UIStroke", {
            Color = Color3.fromRGB(255, 255, 255),
            Thickness = 1, Transparency = 0.86, Parent = GlassBase,
        })

        -- Lớp 1: màng frosted trắng loang từ đỉnh (frosted film)
        local GlassSheen = New("Frame", {
            Name = "GlassSheen",
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0,
            BorderSizePixel = 0, ZIndex = 151, Parent = ToggleBtn,
        })
        New("UICorner", {CornerRadius = UDim.new(0, RADIUS), Parent = GlassSheen})
        New("UIGradient", {
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.55),
                NumberSequenceKeypoint.new(0.5, 0.85),
                NumberSequenceKeypoint.new(1, 0.94),
            }),
            Parent = GlassSheen,
        })

        -- Lớp 2: điểm sáng khúc xạ (caustic light) góc trên — như ánh kính thật
        New("ImageLabel", {
            Name = "Caustic", BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.32, 0, 0.28, 0),
            Size = UDim2.new(0.62, 0, 0.44, 0),
            Image = "rbxassetid://6014261993",
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = 0.8,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(49, 49, 450, 450),
            ZIndex = 152, Parent = ToggleBtn,
        })

        -- Viền kính: rim sáng trắng + halo màu nhấn — GIỜ ĐÃ BO TRÒN ĐÚNG nhờ UICorner của ToggleBtn
        local RimStroke = New("UIStroke", {
            Color = Color3.fromRGB(255, 255, 255),
            Thickness = 1.5, Transparency = 0.25, Parent = ToggleBtn,
        })
        local rimGrad = New("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.05),
                NumberSequenceKeypoint.new(0.6, 0.45),
                NumberSequenceKeypoint.new(1, 0.85),
            }),
            Rotation = 40, Parent = RimStroke,
        })
        local GlowStroke = New("UIStroke", {
            Color = MeizuLibrary.Accent,
            Thickness = 3, Transparency = 0.8, Parent = ToggleBtn,
        })
        RegisterAccent(GlowStroke, "Color")
        -- (Rim xoay liên tục được điều khiển trong vòng Heartbeat phía dưới — mượt, không bị giật vòng lặp)

        -- Khung chứa icon (clip theo bo góc kính)
        IconWrap = New("Frame", {
            Name = "IconWrap",
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1, -12, 1, -12),
            ClipsDescendants = true,
            ZIndex = 153, Parent = ToggleBtn,
        })
        New("UICorner", {CornerRadius = UDim.new(0, math.max(RADIUS - 5, 4)), Parent = IconWrap})

        local ToggleImageL = New("ImageLabel", {
            Name = "ToggleImage",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Visible = false,
            ScaleType = Enum.ScaleType.Fit,
            ImageTransparency = 0,
            ZIndex = 154, Parent = IconWrap,
        })

        -- Vệt sáng quét chéo (liquid shimmer) — "linh hồn" của Liquid Glass
        local ShimmerClip = New("Frame", {
            Name = "ShimmerClip",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ClipsDescendants = true,
            ZIndex = 157, Parent = ToggleBtn,
        })
        New("UICorner", {CornerRadius = UDim.new(0, RADIUS), Parent = ShimmerClip})
        local Shimmer = New("Frame", {
            Name = "Shimmer",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(-0.35, 0, 0.5, 0),
            Size = UDim2.new(0, 24, 2.4, 0),
            Rotation = 22,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.42,
            BorderSizePixel = 0, ZIndex = 157, Parent = ShimmerClip,
        })
        New("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.5, 0.25),
                NumberSequenceKeypoint.new(1, 1),
            }),
            Parent = Shimmer,
        })
        task.spawn(function()
            while ShimmerClip.Parent and not MeizuLibrary.Destroyed do
                if Shimmer.Parent then
                    Shimmer.Position = UDim2.new(-0.35, 0, 0.5, 0)
                    Tween(Shimmer, 0.9, {Position = UDim2.new(1.35, 0, 0.5, 0)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                end
                task.wait(3.2)
            end
        end)

        local ToggleLetter = New("TextLabel", {
            Name = "ToggleLetter",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Font = FONT_BOLD, TextSize = 22,
            Text = "M",
            TextColor3 = MeizuLibrary.Accent,
            Visible = true,
            ZIndex = 153, Parent = IconWrap,
        })
        RegisterAccent(ToggleLetter, "TextColor3")

        -- Lớp 3: gloss TRÀN TRÊN LOGO — thành phần quyết định chất "kính lỏng"
        -- Trước đây mọi lớp kính đều nằm DƯỚI logo (logo che kín) → nhìn như không có hiệu ứng.
        -- Giờ gloss + phản chiếu màu nhấn ĐẶT TRÊN logo → nhìn logo xuyên qua lớp kính thật.
        local TopGloss = New("Frame", {
            Name = "TopGloss",
            Size = UDim2.new(1, 0, 0.48, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0,
            BorderSizePixel = 0, ZIndex = 156, Parent = ToggleBtn,
        })
        New("UICorner", {CornerRadius = UDim.new(0, RADIUS), Parent = TopGloss})
        New("UIGradient", {
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.62),
                NumberSequenceKeypoint.new(0.5, 0.88),
                NumberSequenceKeypoint.new(1, 1),
            }),
            Parent = TopGloss,
        })

        -- Lớp 4: phản chiếu màu nhấn ở đáy kính (bottom refraction)
        local BottomGlow = New("Frame", {
            Name = "BottomGlow",
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0.42, 0),
            BackgroundColor3 = MeizuLibrary.Accent,
            BackgroundTransparency = 0,
            BorderSizePixel = 0, ZIndex = 156, Parent = ToggleBtn,
        })
        RegisterAccent(BottomGlow, "BackgroundColor3")
        New("UICorner", {CornerRadius = UDim.new(0, RADIUS), Parent = BottomGlow})
        New("UIGradient", {
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.4, 0.93),
                NumberSequenceKeypoint.new(1, 0.8),
            }),
            Parent = BottomGlow,
        })

        --// Áp dụng hình nút nổi: nhận "rbxassetid://ID", số ID, hoặc URL PNG
        -- Nếu load thất bại → tự động fallback về icon mặc định (không bao giờ để nút trống)
        local function ApplyImage(source)
            if not ToggleImageL or not ToggleImageL.Parent then return false end
            source = tostring(source or "")
            if source == "" then source = DEFAULT_TOGGLE_IMG end
            local asset = ResolveImageAsset(source, "toggle_image")
            if not asset then
                source = DEFAULT_TOGGLE_IMG
                asset = ResolveImageAsset(source, "toggle_image")
            end
            if not asset and FALLBACK_TOGGLE_IMG then
                -- Chỉ rơi vào đây khi logo cũ tải lỗi thật sự (mất mạng / executor kém)
                source = FALLBACK_TOGGLE_IMG
                asset = ResolveImageAsset(source, "toggle_image")
            end
            if asset then
                ToggleImageL.Image = asset
                ToggleImageL.Visible = true
                ToggleLetter.Visible = false
                MeizuLibrary._ToggleImage = source
                return true
            end
            return false
        end
        MeizuLibrary._ApplyToggleImage = ApplyImage

        -- API công khai (đã hứa trong doc header từ hồi v2.2, giờ mới có thật 😄)
        function Window:SetToggleImage(v)
            return ApplyImage(v)
        end
        function Window:GetToggleImage()
            return MeizuLibrary._ToggleImage
        end
        task.spawn(function() ApplyImage(TOGGLE_BUTTON_IMAGE) end)

        --// Vật lý mềm kiểu Liquid: nhịp thở + nhấn nén + hover nở ra
        local BtnScale = New("UIScale", {Scale = 0, Parent = ToggleBtn})
        local pressCur, pressTarget = 0, 1   -- mở màn: nút "phồng" lên từ 0
        local hoverCur, hoverTarget = 1, 1
        local breathT = 0
        local rimRot = 0
        local beatConn = RunService.Heartbeat:Connect(function(dt)
            breathT = breathT + dt
            rimRot = (rimRot + dt * 42) % 360           -- rim sáng xoay LIÊN TỤC (kính lỏng chuyển động)
            if rimGrad and rimGrad.Parent then rimGrad.Rotation = rimRot end
            local k = math.min(dt * 9, 1)
            pressCur  = pressCur  + (pressTarget  - pressCur)  * k
            hoverCur  = hoverCur  + (hoverTarget  - hoverCur)  * k
            local breath = 1 + 0.03 * math.sin(breathT * 1.9)  -- thở nhẹ như jelly
            BtnScale.Scale = pressCur * hoverCur * breath
        end)
        table.insert(MeizuLibrary._Connections, beatConn)

        ToggleBtn.MouseEnter:Connect(function() hoverTarget = 1.06 end)
        ToggleBtn.MouseLeave:Connect(function() hoverTarget = 1 end)

        --// Click vs Drag + hiệu ứng nén khi giữ
        local pressedPos = nil
        ToggleBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                pressedPos = input.Position
                pressTarget = 0.86  -- nén nhẹ khi ngón đặt xuống
            end
        end)
        ToggleBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                pressTarget = 1
                if pressedPos and (input.Position - pressedPos).Magnitude < 8 then
                    Window:Toggle()
                end
                pressedPos = nil
            end
        end)
        -- Kéo được, clamp "full": nút luôn nằm trọn trong màn hình, không tuột mất
        MakeDraggable(ToggleBtn, ToggleBtn, {ClampMode = "full"})

        -- Pulse sóng lan khi UI ẩn
        local PulseRing = New("Frame", {
            Name = "PulseRing",
            BackgroundColor3 = MeizuLibrary.Accent,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = TOGGLE_BUTTON_SIZE,
            ZIndex = 149, BorderSizePixel = 0, Parent = ToggleBtn,
        })
        RegisterAccent(PulseRing, "BackgroundColor3")
        New("UICorner", {CornerRadius = UDim.new(0, RADIUS), Parent = PulseRing})

        task.spawn(function()
            while ToggleBtn.Parent and not MeizuLibrary.Destroyed do
                if not isOpen and PulseRing.Parent then
                    PulseRing.Size = TOGGLE_BUTTON_SIZE
                    PulseRing.BackgroundTransparency = 0.7
                    Tween(PulseRing, 1.1, {
                        Size = UDim2.new(
                            TOGGLE_BUTTON_SIZE.X.Scale, TOGGLE_BUTTON_SIZE.X.Offset + 40,
                            TOGGLE_BUTTON_SIZE.Y.Scale, TOGGLE_BUTTON_SIZE.Y.Offset + 40),
                        BackgroundTransparency = 1,
                    }, Enum.EasingStyle.Quad)
                end
                task.wait(1.7)
            end
        end)
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

    -- Tab cài đặt dùng ICON CÀI ĐẶT Ở TRONG MENU (rbxassetid://10734950309) — đúng yêu cầu
    -- (Nút nổi ở NGOÀI vẫn giữ logo cũ, không đụng tới)
    local SettingsTab = Window:CreateTab("Settings", SETTINGS_TAB_ICON, 9999)
    SettingsTab:CreateParagraph({
        Title = "Meizu Library v" .. MeizuLibrary.Version,
        Content = "<b>Liquid Glass Edition</b> — kính lỏng chân thực: thân kính tối, gloss tràn trên logo, rim xoay liên tục, shimmer quét chéo.\nNút nổi GIỮ LOGO CŨ của bạn; icon cài đặt trong menu dùng rbxassetid://10734950309.\nMới: vùng logo + tên script góc trái và panel bên phải hiện tên tab + giải thích.\nDesign by NTTP1721. Cảm ơn bạn đã sử dụng!",
    })
    SettingsTab:CreateKeybind({
        Title = "Toggle UI Keybind",
        Default = MeizuLibrary.ToggleKeybind,
        Callback = function() Window:Toggle() end,
        ChangedCallback = function(key) MeizuLibrary.ToggleKeybind = key end,
    })
    SettingsTab:CreateDropdown({
        Title = "Theme",
        Options = themeNames,
        Default = MeizuLibrary.Theme,
        Callback = function(v) MeizuLibrary:ApplyTheme(v) end,
    })
    SettingsTab:CreateColorPicker({
        Title = "Accent Color",
        Default = MeizuLibrary.Accent,
        Callback = function(c)
            MeizuLibrary._UserAccent = c
            MeizuLibrary:ApplyAccent(c)
        end,
    })
    SettingsTab:CreateToggle({
        Title = "Rainbow Accent",
        Default = false,
        Callback = function(v) MeizuLibrary:SetRainbow(v) end,
    })
    SettingsTab:CreateToggle({
        Title = "Sound Effects",
        Default = MeizuLibrary.SoundEnabled,
        Callback = function(v) MeizuLibrary.SoundEnabled = v end,
    })

    --// ============ HÌNH NÚT NỔI (Liquid Glass) ============
    -- Đổi hình biểu tượng nút nổi — nhận rbxassetid://ID, số ID hoặc link PNG
    -- Mặc định: LOGO CŨ của bạn (i.ibb.co/S7rpHJJN/meizuxp.png) — không còn bị thay bởi icon khác
    local imgInput = SettingsTab:CreateInput({
        Title = "Toggle Button Image",
        Placeholder = "rbxassetid://ID hoặc link PNG",
        Default = MeizuLibrary._ToggleImage or TOGGLE_BUTTON_IMAGE,
    })
    SettingsTab:CreateButton({
        Title = "Apply Image",
        Description = "rbxassetid://ID, số ID hoặc link PNG",
        Callback = function()
            local ok = Window:SetToggleImage(imgInput.Get())
            MeizuLibrary:Notify({
                Title = "Toggle Image",
                Content = ok and "Đã áp dụng hình nút nổi mới!" or "Không tải được hình — đã dùng hình mặc định.",
                Duration = 4,
            })
        end,
    })
    SettingsTab:CreateButton({
        Title = "Reset Image",
        Description = "Quay lại logo cũ của bạn",
        Callback = function()
            imgInput.Set(DEFAULT_TOGGLE_IMG)
            Window:SetToggleImage(DEFAULT_TOGGLE_IMG)
            MeizuLibrary:Notify({
                Title = "Toggle Image",
                Content = "Đã trả lại logo cũ của bạn!",
                Duration = 3,
            })
        end,
    })

    local LanguageNames = {"Tiếng Việt", "English"}
    SettingsTab:CreateDropdown({
        Title = "Language",
        Options = LanguageNames,
        Default = (MeizuLibrary.Language == "vi") and "Tiếng Việt" or "English",
        Callback = function(v)
            MeizuLibrary:SetLanguage(v == "Tiếng Việt" and "vi" or "en")
        end,
    })

    local nameInput = SettingsTab:CreateInput({
        Title = "Config Name",
        Placeholder = "config",
        Default = "config",
    })
    SettingsTab:CreateButton({
        Title = "Save Config",
        Callback = function()
            local v = nameInput.Get()
            local ok = MeizuLibrary:SaveSettings(v)
            MeizuLibrary:Notify({
                Title = "Config",
                Content = ok and ("Đã lưu config '<b>" .. v .. "</b>'!") or "Executor không hỗ trợ writefile!",
                Duration = 4,
            })
        end,
    })
    SettingsTab:CreateButton({
        Title = "Load Config",
        Callback = function()
            local v = nameInput.Get()
            local ok = MeizuLibrary:LoadSettings(v)
            MeizuLibrary:Notify({
                Title = "Config",
                Content = ok and ("Đã load config '<b>" .. v .. "</b>'!") or "Không tìm thấy config!",
                Duration = 4,
            })
        end,
    })
    SettingsTab:CreateButton({
        Title = "Unload Library",
        Description = "Xoá toàn bộ UI khỏi game",
        Callback = function()
            Window:Dialog({
                Title = "Unload",
                Content = "Bạn có chắc muốn gỡ UI?",
                Buttons = {
                    {Title = "Cancel"},
                    {Title = "Unload", Variant = "Primary", Callback = function() MeizuLibrary:Destroy() end},
                },
            })
        end,
    })

    --// Intro animation
    task.delay(0.15, function()
        Window:Toggle(true)
    end)

    Window.Main = Main
    task.defer(function() MeizuLibrary:_ApplyLocalization() end)
    return Window
end

return MeizuLibrary
