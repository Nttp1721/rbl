--[[
    ███╗   ███╗███████╗██╗███████╗██╗   ██╗
    ██╔████╔██║██╔════╝██║██╔════╝╚██╗ ██╔╝
    ██║██╔╝██╗█████╗  ██║███████╗ ╚████╔╝
    ██║███╗██║██╔══╝  ██║╚════██║  ╚██╔╝
    ███╔███╔██║██║███╗██║███████║   ██║
    ╚═╝ ╚══╝ ╚═╝╚════╝╚═╝╚══════╝   ╚═╝
    MEIZU EXTRAS v2.0 "Aurora" — Bản nâng cấp lớn cho Meizu Library v3.0
    ===========================================================================
    THAY THẾ HOÀN TOÀN bản v1.0. Dán file này xuống CUỐI file library
    (hoặc loadstring riêng). KHÔNG sửa gì file library.

    ── TIỆN ÍCH CŨ (giữ nguyên từ v1.0) ──
      Extras:EnableWatermark{Text, ShowFPS, ShowPing, ShowClock, ShowUptime}
      Extras:EnableKeyVisualizer()        Extras:EnableLogger{Keybind, Max}
      Extras:Log / :ClearLog              Extras:AttachTooltip(obj, text)
      Extras:NewContextMenu(obj, items)   Extras:SetPanicKey(KeyCode)
      Extras:ToggleFPSBoost(bool)         Extras:EnableAntiAFK(bool)

    ── MỚI TRONG v2.0 "AURORA" ──
      Extras:Attach(MeizuLibrary)         -- BẮT BUỘC gọi sau CreateWindow
      -- Element mới (where = Tab hoặc kết quả CreateCollapsible):
      Extras:CreateLabel(where, {Title, Description})
      Extras:CreateDivider(where, {Title})
      Extras:CreateProgress(where, {Name, Flag, Default, Max, ShowPercent, Callback})
      Extras:CreateStepper(where, {Name, Flag, Default, Min, Max, Step, Callback})
      Extras:CreateSegmented(where, {Name, Flag, Options, Default, Callback})
      -- Section gập/mở (trả về pseudo-section truyền vào element phía trên):
      Extras:CreateCollapsible(tab, "Ten muc", coGapSan)  -> sec
      -- Cửa sổ & hệ thống:
      Extras:EnableAutoSave{Name, Interval}     -- tự lưu/tải toàn bộ Flag
      Extras:EnableRememberWindow()             -- nhớ vị trí + kích thước
      Extras:EnableResize{MinW, MinH}           -- kéo góc đổi kích thước (double-click reset)
      Extras:EnableSnapButton{Window, Icon, Text} -- nút kính hít mép + huy hiệu thông báo
      Extras:EnableBlur{Radius}                 -- làm mờ nền game khi mở UI
      Extras:EnablePowerSave(bool)              -- chế độ tiết kiệm pin
      Extras:SetBadge(n) / SnapshotNow() / SyncTheme() / Destroy()
]]

local Extras = {
    Version = "2.0",
    Library = nil,
    _Gui = nil,
    SoundEnabled = true,
    PowerSave = false,
    _Container = nil,
    _FlagSetters = {},
    _LocalFlags = {},
    _Collapsibles = {},
    _WinFrame = nil,
    _WinObj = nil,
    _WinVisible = true,
    _State = {},
    _StateLoaded = false,
    _StateName = "extras_state",
    _Conn = {},
    _BlurFx = nil,
    _BlurRadius = 8,
}

local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local TextService      = game:GetService("TextService")
local Players          = game:GetService("Players")
local Lighting         = game:GetService("Lighting")
local HttpService      = game:GetService("HttpService")
local SoundService     = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer

-- ===== BẢNG MÀU (SyncTheme tự cập nhật theo library) =====
local C = {
    Bg     = Color3.fromRGB(18, 20, 28),
    Panel  = Color3.fromRGB(22, 25, 34),
    Text   = Color3.fromRGB(240, 242, 248),
    Sub    = Color3.fromRGB(148, 153, 168),
    Stroke = Color3.fromRGB(45, 50, 66),
    Accent = Color3.fromRGB(88, 101, 242),
    Ok     = Color3.fromRGB(80, 200, 120),
    Warn   = Color3.fromRGB(255, 184, 77),
    Err    = Color3.fromRGB(255, 95, 95),
}

-- ===== HELPERS =====
local function New(class, props, children)
    local obj = Instance.new(class)
    local parent = nil
    if props then
        for k, v in pairs(props) do
            if k == "Parent" then parent = v else obj[k] = v end
        end
    end
    if children then
        for _, ch in ipairs(children) do ch.Parent = obj end
    end
    if parent then obj.Parent = parent end
    return obj
end

local function Tween(obj, time, props, style, dir)
    if not obj then return end
    pcall(function()
        TweenService:Create(obj,
            TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
            props):Play()
    end)
end

local function Round(obj, px)
    New("UICorner", {CornerRadius = UDim.new(0, px or 8), Parent = obj})
end

local function Lighten(color, t)
    return color:Lerp(Color3.new(1, 1, 1), t)
end

local function Measure(text, size, font, width)
    local ok, v = pcall(function()
        return TextService:GetTextSize(tostring(text), size, font or Enum.Font.SourceSans,
            Vector2.new(width or 2000, 10000))
    end)
    if ok and v then return math.max(math.ceil(v.X), 4), math.max(math.ceil(v.Y), size) end
    return #tostring(text) * math.floor(size * 0.55), size
end

local function MousePos()
    local ok, p = pcall(function() return UserInputService:GetMouseLocation() end)
    if ok and p then return p end
    return Vector2.new(0, 0)
end

local function ScreenSize()
    local ok, v = pcall(function() return workspace.CurrentCamera.ViewportSize end)
    if ok and v then return v end
    return Vector2.new(1920, 1080)
end

local function PlayClick(vol, speed)
    if not Extras.SoundEnabled then return end
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxasset://sounds/electronicpingshort.wav"
        s.Volume = vol or 0.15
        s.PlaybackSpeed = speed or 1.3
        s.Parent = SoundService
        s:Play()
        task.delay(2, function() if s then s:Destroy() end end)
    end)
end

local function GetGui()
    if Extras._Gui and Extras._Gui.Parent then return Extras._Gui end
    local gui = Instance.new("ScreenGui")
    gui.Name = "MeizuExtras"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 9998
    local ok = pcall(function()
        if type(syn) == "table" and type(syn.protect_gui) == "function" then syn.protect_gui(gui) end
        local parent = (type(gethui) == "function" and gethui()) or game:GetService("CoreGui")
        gui.Parent = parent
    end)
    if not ok or not gui.Parent then
        local lp = Players.LocalPlayer
        if lp then gui.Parent = lp:WaitForChild("PlayerGui") end
    end
    Extras._Gui = gui
    return gui
end

local function Draggable(handle, target)
    handle.Active = true
    handle.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local startPos = target.Position
        local sx, sy = input.Position.X, input.Position.Y
        local moveConn, upConn
        moveConn = UserInputService.InputChanged:Connect(function(inp)
            if inp.UserInputType ~= Enum.UserInputType.MouseMovement
            and inp.UserInputType ~= Enum.UserInputType.Touch then return end
            local dx, dy = inp.Position.X - sx, inp.Position.Y - sy
            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + dx,
                startPos.Y.Scale, startPos.Y.Offset + dy)
        end)
        upConn = UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                if moveConn then moveConn:Disconnect() end
                if upConn then upConn:Disconnect() end
            end
        end)
    end)
end

local function ResolveTarget(target)
    if type(target) == "table" then
        for _, k in ipairs({"Frame", "Main", "Container", "Button", "Hitbox", "Object", "Instance", "Element"}) do
            local v = target[k]
            if typeof(v) == "Instance" and v:IsA("GuiObject") then return v end
        end
        return nil
    end
    if typeof(target) == "Instance" and target:IsA("GuiObject") then return target end
    return nil
end

-- ===== GHI NHỚ THEME CHO ELEMENT MỚI =====
local ThemeRefs = {}
local function OnThemeRefresh(objs, fn)
    table.insert(ThemeRefs, {Objs = objs, Fn = fn})
end

local function RefreshThemes()
    for i = #ThemeRefs, 1, -1 do
        local e = ThemeRefs[i]
        local alive = false
        for _, o in ipairs(e.Objs) do
            if o and o.Parent then
                alive = true
                break
            end
        end
        if not alive then
            table.remove(ThemeRefs, i)
        else
            pcall(e.Fn)
        end
    end
end

-- ===== LƯU / ĐỌC TRẠNG THÁI (JSON) =====
local function SanitizeFileName(s)
    s = tostring(s or ""):gsub("[^%w_%-]", "_")
    if #s > 40 then s = s:sub(1, 40) end
    if s == "" then s = "extras_state" end
    return s
end

local function StateFolder()
    local lib = Extras.Library
    local folder = (lib and lib.Folder) or "MeizuLibrary"
    if type(isfolder) == "function" and type(makefolder) == "function" then
        pcall(function()
            if not isfolder(folder) then makefolder(folder) end
        end)
        return folder
    end
    return nil
end

local function SaveState()
    if not Extras._StateLoaded then return false end
    local folder = StateFolder()
    if not folder or type(writefile) ~= "function" then return false end
    return pcall(function()
        writefile(folder .. "/" .. Extras._StateName .. ".json", HttpService:JSONEncode(Extras._State))
    end)
end

local function LoadState()
    local folder = StateFolder()
    if not folder or type(readfile) ~= "function" then return nil end
    local ok, data = pcall(function()
        local path = folder .. "/" .. Extras._StateName .. ".json"
        if isfile and isfile(path) then
            return HttpService:JSONDecode(readfile(path))
        end
        return nil
    end)
    if ok and type(data) == "table" then return data end
    return nil
end

-- ===== DÒ CỬA SỔ / CONTAINER CỦA LIBRARY =====
local function IsWindowLike(g)
    return g:IsA("GuiObject")
        and g.BackgroundTransparency < 0.9
        and g.Name ~= "Notifications"
        and g.AbsoluteSize.X >= 280
end

local function FindWindowFrame(source)
    if typeof(source) == "Instance" then
        if source:IsA("GuiObject") then return source end
        if source:IsA("ScreenGui") then
            local best, bestSize = nil, 0
            for _, ch in ipairs(source:GetChildren()) do
                if (ch:IsA("Frame") or ch:IsA("CanvasGroup")) and IsWindowLike(ch) then
                    local s = ch.AbsoluteSize.X * ch.AbsoluteSize.Y
                    if s > bestSize then
                        best, bestSize = ch, s
                    end
                end
            end
            return best
        end
        return nil
    end
    if type(source) ~= "table" then return nil end
    local best, bestSize, gui = nil, 0, nil
    for _, v in pairs(source) do
        if typeof(v) == "Instance" then
            if v:IsA("ScreenGui") then
                gui = v
            elseif v:IsA("GuiObject") and IsWindowLike(v) then
                local s = v.AbsoluteSize.X * v.AbsoluteSize.Y
                if s > bestSize then
                    best, bestSize = v, s
                end
            end
        end
    end
    if gui then return FindWindowFrame(gui) end
    return best
end

local function FindWindowObj(source)
    if type(source) == "table" then
        if type(source.Toggle) == "function" then return source end
        for _, k in ipairs({"Window", "_Window", "_Win", "Main", "Root"}) do
            local v = source[k]
            if type(v) == "table" and type(v.Toggle) == "function" then return v end
        end
    end
    return nil
end

local function FindContainer(x)
    -- pseudo-section do CreateCollapsible tạo
    if type(x) == "table" and typeof(x.Content) == "Instance" and x.Content.Parent then
        return x.Content
    end
    if type(x) == "table" then
        local best, bestSize = nil, 0
        for _, v in pairs(x) do
            if typeof(v) == "Instance" and v:IsA("GuiObject") and v.Parent then
                if v:IsA("ScrollingFrame") then return v end
                local s = v.AbsoluteSize.X * v.AbsoluteSize.Y
                if s > bestSize then
                    best, bestSize = v, s
                end
            end
        end
        return best
    end
    if typeof(x) == "Instance" then
        if x:IsA("GuiObject") then return x end
        for _, ch in ipairs(x:GetChildren()) do
            if ch:IsA("ScrollingFrame") then return ch end
        end
    end
    return nil
end

function Extras:Mount(where)
    local c = FindContainer(where)
    if c then
        self._Container = c
        return true
    end
    return false
end

function Extras:_ContainerOf(where)
    if where == nil then where = self._Container end
    local c = FindContainer(where)
    if c then
        self._Container = c
        return c
    end
    warn("[MeizuExtras] Khong tim thay container — hay truyen Tab hoac goi Extras:Mount() truoc")
    return nil
end

local rowOrder = 0
local function NextOrder()
    rowOrder = rowOrder + 1
    return 100000 + rowOrder
end

-- ===== GHI FLAG CHUNG CHO MỌI ELEMENT MỚI =====
local function PutFlag(flag, v)
    if not flag then return end
    Extras._LocalFlags[flag] = v
    if Extras.Library then
        pcall(function() Extras.Library.Flags[flag] = v end)
    end
end

local function FireCallback(cfg, ...)
    if type(cfg.Callback) ~= "function" then return end
    local args = {...}
    task.spawn(function()
        local ok, err = pcall(cfg.Callback, unpack(args))
        if not ok then warn("[MeizuExtras] Callback error: " .. tostring(err)) end
    end)
end

-- ===== KHUNG DÒNG CHUNG =====
local function NewRow(container, height, order)
    local Row = New("Frame", {
        Name = "MeizuRow",
        BackgroundColor3 = C.Panel,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, height),
        LayoutOrder = order,
        ClipsDescendants = true,
        Parent = container,
    })
    Round(Row, 10)
    New("UIStroke", {Color = C.Stroke, Thickness = 1, Transparency = 0.45, Parent = Row})
    return Row
end

local function AddText(Row, cfg, ctrlWidth)
    local w = ctrlWidth or 0
    local Title = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 8),
        Size = UDim2.new(1, -(24 + w), 0, 16),
        Font = Enum.Font.SourceSansSemibold,
        TextSize = 14,
        TextColor3 = C.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Text = tostring(cfg.Name or cfg.Title or ""),
        Parent = Row,
    })
    local descH = 0
    if cfg.Description then
        local _, dh = Measure(tostring(cfg.Description), 12, Enum.Font.SourceSans, 420)
        descH = dh
        local D = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 27),
            Size = UDim2.new(1, -(24 + w), 0, dh),
            Font = Enum.Font.SourceSans, TextSize = 12,
            TextColor3 = C.Sub,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            Text = tostring(cfg.Description),
            Parent = Row,
        })
        OnThemeRefresh({Title, D}, function()
            Title.TextColor3 = C.Text
            D.TextColor3 = C.Sub
        end)
    else
        OnThemeRefresh({Title}, function() Title.TextColor3 = C.Text end)
    end
    return Title, descH
end

--// ==================== ELEMENT: LABEL ====================
function Extras:CreateLabel(where, cfg)
    cfg = cfg or {}
    local container = self:_ContainerOf(where)
    if not container then return nil end

    local title = tostring(cfg.Title or cfg.Name or cfg.Text or "")
    local desc = cfg.Description and tostring(cfg.Description) or nil
    local _, th = Measure(title, 14, Enum.Font.SourceSansSemibold, 420)
    local dh = 0
    if desc then _, dh = Measure(desc, 12, Enum.Font.SourceSans, 420) end

    local Row = New("Frame", {
        Name = "MeizuLabel",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, th + (desc and (dh + 5) or 0) + 8),
        LayoutOrder = NextOrder(),
        Parent = container,
    })
    local T = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 4, 0, 2),
        Size = UDim2.new(1, -8, 0, th),
        Font = Enum.Font.SourceSansSemibold, TextSize = 14,
        TextColor3 = C.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true, Text = title,
        Parent = Row,
    })
    if desc then
        local D = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 4, 0, th + 5),
            Size = UDim2.new(1, -8, 0, dh),
            Font = Enum.Font.SourceSans, TextSize = 12,
            TextColor3 = C.Sub,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true, Text = desc,
            Parent = Row,
        })
        OnThemeRefresh({T, D}, function()
            T.TextColor3 = C.Text
            D.TextColor3 = C.Sub
        end)
    else
        OnThemeRefresh({T}, function() T.TextColor3 = C.Text end)
    end

    return {
        Row = Row,
        Set = function(text)
            title = tostring(text or "")
            T.Text = title
            if desc then D.Text = desc end
        end,
    }
end

--// ==================== ELEMENT: DIVIDER ====================
function Extras:CreateDivider(where, cfg)
    cfg = cfg or {}
    local container = self:_ContainerOf(where)
    if not container then return nil end

    local title = cfg.Title and tostring(cfg.Title) or nil
    local Row = New("Frame", {
        Name = "MeizuDivider",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, title and 26 or 12),
        LayoutOrder = NextOrder(),
        Parent = container,
    })

    if not title then
        local Line = New("Frame", {
            BackgroundColor3 = C.Stroke,
            BackgroundTransparency = 0.35,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 2, 0.5, 0),
            Size = UDim2.new(1, -4, 0, 1),
            BorderSizePixel = 0, Parent = Row,
        })
        OnThemeRefresh({Line}, function() Line.BackgroundColor3 = C.Stroke end)
    else
        local lw = Measure(title, 12, Enum.Font.SourceSansSemibold)
        local Lab = New("TextLabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.fromOffset(lw + 12, 16),
            Font = Enum.Font.SourceSansSemibold, TextSize = 12,
            TextColor3 = C.Sub, Text = title,
            Parent = Row,
        })
        local L1 = New("Frame", {
            BackgroundColor3 = C.Stroke, BackgroundTransparency = 0.35,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 2, 0.5, 0),
            Size = UDim2.new(0.5, -(lw / 2 + 14), 0, 1),
            BorderSizePixel = 0, Parent = Row,
        })
        local L2 = New("Frame", {
            BackgroundColor3 = C.Stroke, BackgroundTransparency = 0.35,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -2, 0.5, 0),
            Size = UDim2.new(0.5, -(lw / 2 + 14), 0, 1),
            BorderSizePixel = 0, Parent = Row,
        })
        OnThemeRefresh({Lab, L1, L2}, function()
            Lab.TextColor3 = C.Sub
            L1.BackgroundColor3 = C.Stroke
            L2.BackgroundColor3 = C.Stroke
        end)
    end
    return {Row = Row}
end

--// ==================== ELEMENT: PROGRESS ====================
function Extras:CreateProgress(where, cfg)
    cfg = cfg or {}
    local container = self:_ContainerOf(where)
    if not container then return nil end

    local max = math.max(tonumber(cfg.Max) or 100, 1)
    local dh = 0
    if cfg.Description then _, dh = Measure(tostring(cfg.Description), 12, Enum.Font.SourceSans, 420) end

    local Row = NewRow(container, 60 + dh, NextOrder())
    AddText(Row, cfg, 70)
    local Pct = New("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -12, 0, 8),
        Size = UDim2.fromOffset(60, 16),
        Font = Enum.Font.SourceSansBold, TextSize = 13,
        TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Right,
        Text = "0%", Parent = Row,
    })
    local Track = New("Frame", {
        BackgroundColor3 = C.Stroke,
        BackgroundTransparency = 0.3,
        ClipsDescendants = true,
        Position = UDim2.new(0, 12, 1, -20),
        Size = UDim2.new(1, -24, 0, 6),
        BorderSizePixel = 0, Parent = Row,
    })
    Round(Track, 3)
    local Fill = New("Frame", {
        BackgroundColor3 = C.Accent,
        Size = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0, Parent = Track,
    })
    Round(Fill, 3)
    local Grad = New("UIGradient", {
        Color = ColorSequence.new(Lighten(C.Accent, 0.35), C.Accent),
        Parent = Fill,
    })

    local state = {Value = math.clamp(tonumber(cfg.Default) or 0, 0, max)}

    local function Apply(v, silent)
        v = math.clamp(tonumber(v) or 0, 0, max)
        state.Value = v
        local p = v / max
        Tween(Fill, 0.3, {Size = UDim2.new(p, 0, 1, 0)})
        if cfg.ShowPercent == false then
            Pct.Text = string.format("%g / %g", v, max)
        else
            Pct.Text = string.format("%.0f%%", p * 100)
        end
        if cfg.Flag then PutFlag(cfg.Flag, v) end
        if not silent then FireCallback(cfg, v) end
    end

    Apply(state.Value, true)
    if cfg.Flag then
        self._FlagSetters[cfg.Flag] = function(v) Apply(v, true) end
    end
    OnThemeRefresh({Fill, Grad}, function()
        Fill.BackgroundColor3 = C.Accent
        Grad.Color = ColorSequence.new(Lighten(C.Accent, 0.35), C.Accent)
    end)

    return {
        Row = Row,
        Set = function(v) Apply(v, false) end,
        Get = function() return state.Value end,
    }
end

--// ==================== ELEMENT: STEPPER ====================
function Extras:CreateStepper(where, cfg)
    cfg = cfg or {}
    local container = self:_ContainerOf(where)
    if not container then return nil end

    local min = tonumber(cfg.Min) or 0
    local max = tonumber(cfg.Max) or 100
    if max < min then max = min end
    local step = math.abs(tonumber(cfg.Step) or 1)
    local value = math.clamp(tonumber(cfg.Default) or min, min, max)

    local dh = 0
    if cfg.Description then _, dh = Measure(tostring(cfg.Description), 12, Enum.Font.SourceSans, 420) end

    local Row = NewRow(container, 46 + dh, NextOrder())
    AddText(Row, cfg, 140)

    local function MakeBtn(txt, xOff)
        local B = New("TextButton", {
            BackgroundColor3 = C.Bg,
            BackgroundTransparency = 0.25,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, xOff, 0.5, -dh / 2),
            Size = UDim2.fromOffset(30, 30),
            Font = Enum.Font.SourceSansBold, TextSize = 17,
            TextColor3 = C.Text, Text = txt,
            AutoButtonColor = false,
            Parent = Row,
        })
        Round(B, 8)
        New("UIStroke", {Color = C.Stroke, Thickness = 1, Transparency = 0.4, Parent = B})
        return B
    end

    local Minus = MakeBtn("-", 140)
    local Plus = MakeBtn("+", 36)
    local Val = New("TextButton", {
        BackgroundColor3 = C.Bg,
        BackgroundTransparency = 0.15,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -100, 0.5, -dh / 2),
        Size = UDim2.fromOffset(60, 30),
        Font = Enum.Font.SourceSansBold, TextSize = 14,
        TextColor3 = C.Text, Text = "%g",
        AutoButtonColor = false,
        Parent = Row,
    })
    Round(Val, 8)
    New("UIStroke", {Color = C.Stroke, Thickness = 1, Transparency = 0.35, Parent = Val})

    local function Apply(v, silent)
        v = tonumber(v) or min
        v = math.clamp(v, min, max)
        if step >= 1 then v = math.floor(v + 0.5) end
        value = v
        Val.Text = string.format("%g", v)
        if cfg.Flag then PutFlag(cfg.Flag, v) end
        if not silent then FireCallback(cfg, v) end
    end

    local function Nudge(dir)
        Apply(value + dir * step, false)
        PlayClick(0.08, dir > 0 and 1.4 or 1.2)
    end

    -- giữ phím = tăng/giảm nhanh dần
    local function BindHold(B, dir)
        B.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
            Nudge(dir)
            local held = true
            local upConn
            upConn = UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch then
                    held = false
                    if upConn then upConn:Disconnect() end
                end
            end)
            task.spawn(function()
                task.wait(0.4)
                local speed = 0.15
                while held and B.Parent do
                    Nudge(dir)
                    task.wait(speed)
                    speed = math.max(speed * 0.85, 0.05)
                end
                if upConn then upConn:Disconnect() end
            end)
        end)
    end
    BindHold(Minus, -1)
    BindHold(Plus, 1)

    Apply(value, true)
    if cfg.Flag then
        self._FlagSetters[cfg.Flag] = function(v) Apply(v, true) end
    end
    OnThemeRefresh({Minus, Plus, Val}, function()
        Minus.BackgroundColor3 = C.Bg
        Plus.BackgroundColor3 = C.Bg
        Val.BackgroundColor3 = C.Bg
        Minus.TextColor3 = C.Text
        Plus.TextColor3 = C.Text
        Val.TextColor3 = C.Text
    end)

    return {
        Row = Row,
        Set = function(v) Apply(v, false) end,
        Get = function() return value end,
    }
end

--// ==================== ELEMENT: SEGMENTED (KÍNH TRƯỢT) ====================
function Extras:CreateSegmented(where, cfg)
    cfg = cfg or {}
    local container = self:_ContainerOf(where)
    if not container then return nil end

    local options = cfg.Options or {}
    if type(options) ~= "table" or #options < 2 then
        warn("[MeizuExtras] Segmented can it nhat 2 Options")
        return nil
    end
    local n = math.min(#options, 5)

    local dh = 0
    if cfg.Description then _, dh = Measure(tostring(cfg.Description), 12, Enum.Font.SourceSans, 420) end

    local Row = NewRow(container, (cfg.Name and 68 or 48) + dh, NextOrder())
    if cfg.Name then AddText(Row, cfg, 0) end

    local Ctrl = New("Frame", {
        BackgroundColor3 = C.Bg,
        BackgroundTransparency = 0.3,
        ClipsDescendants = true,
        Position = UDim2.new(0, 10, 1, -42 - dh / 2),
        Size = UDim2.new(1, -20, 0, 32),
        BorderSizePixel = 0, Parent = Row,
    })
    Round(Ctrl, 10)
    New("UIStroke", {Color = C.Stroke, Thickness = 1, Transparency = 0.4, Parent = Ctrl})

    local Thumb = New("Frame", {
        BackgroundColor3 = C.Accent,
        BackgroundTransparency = 0.78,
        Position = UDim2.new(0, 3, 0, 3),
        Size = UDim2.new(1 / n, -6, 1, -6),
        BorderSizePixel = 0, ZIndex = 2, Parent = Ctrl,
    })
    Round(Thumb, 8)
    local ThumbStroke = New("UIStroke", {Color = C.Accent, Thickness = 1, Transparency = 0.35, Parent = Thumb})

    local Cells = {}
    for i = 1, n do
        local Cell = New("TextButton", {
            BackgroundTransparency = 1,
            Position = UDim2.new((i - 1) / n, 2, 0, 2),
            Size = UDim2.new(1 / n, -4, 1, -4),
            Font = Enum.Font.SourceSansSemibold, TextSize = 13,
            TextColor3 = C.Sub,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Text = tostring(options[i]),
            ZIndex = 3,
            Parent = Ctrl,
        })
        Cell.Activated:Connect(function()
            Apply(i, false)
            PlayClick(0.1, 1.45)
        end)
        table.insert(Cells, Cell)
    end

    local sel = 1
    local function Apply(i, silent)
        if type(i) == "string" then
            for oi, ov in ipairs(options) do
                if tostring(ov) == i then
                    i = oi
                    break
                end
            end
        end
        i = math.clamp(math.floor(tonumber(i) or 1), 1, n)
        sel = i
        Tween(Thumb, 0.3, {Position = UDim2.new((i - 1) / n, 3, 0, 3)}, Enum.EasingStyle.Back)
        for ci, cb in ipairs(Cells) do
            cb.TextColor3 = (ci == i) and C.Text or C.Sub
        end
        if cfg.Flag then PutFlag(cfg.Flag, tostring(options[i])) end
        if not silent then FireCallback(cfg, tostring(options[i]), i) end
    end

    sel = tonumber(cfg.Default) or 1
    Apply(sel, true)
    if cfg.Flag then
        self._FlagSetters[cfg.Flag] = function(v) Apply(v, true) end
    end
    OnThemeRefresh({Thumb, ThumbStroke}, function()
        Thumb.BackgroundColor3 = C.Accent
        ThumbStroke.Color = C.Accent
        for ci, cb in ipairs(Cells) do
            cb.TextColor3 = (ci == sel) and C.Text or C.Sub
        end
    end)

    return {
        Row = Row,
        Set = function(v) Apply(v, false) end,
        Get = function() return tostring(options[sel]) end,
    }
end

--// ==================== SECTION GẬP / MỞ ====================
function Extras:CreateCollapsible(where, title, startClosed)
    local container = self:_ContainerOf(where)
    if not container then return nil end
    title = tostring(title or "Muc")

    local open = not startClosed
    local saved = self._State.collapse
    if type(saved) == "table" and saved[title] ~= nil then
        open = not saved[title]
    end

    local Header = New("TextButton", {
        Name = "MeizuCollapseHeader",
        BackgroundColor3 = C.Panel,
        BackgroundTransparency = 0.15,
        Size = UDim2.new(1, 0, 0, 36),
        Text = "", AutoButtonColor = false,
        LayoutOrder = NextOrder(),
        Parent = container,
    })
    Round(Header, 10)
    New("UIStroke", {Color = C.Stroke, Thickness = 1, Transparency = 0.45, Parent = Header})

    local Title = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -48, 1, 0),
        Font = Enum.Font.SourceSansBold, TextSize = 14,
        TextColor3 = C.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = title, Parent = Header,
    })

    local Chev = New("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0.5, 0),
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        Rotation = open and 0 or 180,
        Parent = Header,
    })
    New("Frame", {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(0.5, -1, 0.6, 0),
        Size = UDim2.fromOffset(9, 2),
        Rotation = 45,
        BackgroundColor3 = C.Sub, BorderSizePixel = 0, ZIndex = 2, Parent = Chev,
    })
    New("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0.5, 1, 0.6, 0),
        Size = UDim2.fromOffset(9, 2),
        Rotation = -45,
        BackgroundColor3 = C.Sub, BorderSizePixel = 0, ZIndex = 2, Parent = Chev,
    })

    local Content = New("Frame", {
        Name = "MeizuCollapseContent",
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Size = UDim2.new(1, 0, 0, 0),
        LayoutOrder = NextOrder(),
        Parent = container,
    })
    local List = New("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = Content,
    })

    local function SyncSize()
        if open then
            Content.Size = UDim2.new(1, 0, 0, List.AbsoluteContentSize.Y)
        end
    end
    List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(SyncSize)

    local pseudo
    local function SetOpen(o)
        open = o == true
        self._State.collapse = self._State.collapse or {}
        self._State.collapse[title] = not open
        SaveState()
        Tween(Chev, 0.3, {Rotation = open and 0 or 180})
        if open then
            SyncSize()
        else
            Tween(Content, 0.28, {Size = UDim2.new(1, 0, 0, 0)})
        end
    end

    Header.Activated:Connect(function()
        SetOpen(not open)
        PlayClick(0.1, 1.35)
    end)

    pseudo = {
        Content = Content,
        Header = Header,
        Title = Title,
        Set = SetOpen,
        IsOpen = function() return open end,
    }
    self._Collapsibles[title] = pseudo

    if open then task.defer(SyncSize) end
    OnThemeRefresh({Header, Title}, function()
        Header.BackgroundColor3 = C.Panel
        Title.TextColor3 = C.Text
    end)
    return pseudo
end

--// ==================== TỰ LƯU / TỰ TẢI CẤU HÌNH ====================
function Extras:EnableAutoSave(cfg)
    cfg = cfg or {}
    self._StateName = SanitizeFileName(cfg.Name or "extras_state")

    local data = LoadState()
    if data then
        self._State = data
    end
    self._StateLoaded = true
    self:_ApplyState()

    local lastSnap = nil
    local acc = 0
    local interval = math.max(tonumber(cfg.Interval) or 20, 5)
    local c = RunService.Heartbeat:Connect(function(dt)
        acc = acc + dt
        if acc < interval then return end
        acc = 0
        local snap = {}
        local lib = self.Library
        if lib then
            pcall(function()
                for k, v in pairs(lib.Flags) do
                    if type(v) == "string" or type(v) == "boolean" or type(v) == "number" then
                        snap[k] = v
                    elseif typeof(v) == "Color3" then
                        snap[k] = {R = v.R, G = v.G, B = v.B}
                    end
                end
            end)
        end
        for k, v in pairs(self._LocalFlags) do
            snap[k] = v
        end
        local enc = nil
        pcall(function() enc = HttpService:JSONEncode(snap) end)
        if enc and enc ~= lastSnap then
            lastSnap = enc
            self._State.flags = snap
            SaveState()
        end
    end)
    table.insert(self._Conn, c)
    return true
end

function Extras:_ApplyState()
    local st = self._State
    -- 1) flag của element mới
    if type(st.flags) == "table" then
        for k, v in pairs(st.flags) do
            local fn = self._FlagSetters[k]
            if type(fn) == "function" then
                pcall(fn, v)
            else
                PutFlag(k, v)
            end
        end
        -- cố gắng đánh thức element gốc của library (best-effort)
        local lib = self.Library
        if lib and type(lib._FlagElems) == "table" then
            for _, el in pairs(lib._FlagElems) do
                if type(el) == "table" then
                    local f = el.Flag or el.flag
                    if f and st.flags[f] ~= nil and type(el.Set) == "function" then
                        pcall(el.Set, el, st.flags[f])
                    end
                end
            end
        end
    end
    -- 2) trạng thái gập section
    if type(st.collapse) == "table" then
        for title, closed in pairs(st.collapse) do
            local p = self._Collapsibles[title]
            if p and type(p.Set) == "function" then
                pcall(p.Set, not closed)
            end
        end
    end
    -- 3) vị trí/kích thước cửa sổ
    if type(st.win) == "table" and tonumber(st.win.w) and self._WinFrame then
        pcall(function()
            if st.win.w >= 200 and st.win.h >= 150 then
                self._WinFrame.Size = UDim2.fromOffset(st.win.w, st.win.h)
            end
            if st.win.x and st.win.y then
                local vp = ScreenSize()
                local x = math.clamp(st.win.x, -self._WinFrame.Size.X.Offset + 120, vp.X - 120)
                local y = math.clamp(st.win.y, 8, vp.Y - 80)
                self._WinFrame.Position = UDim2.fromOffset(x, y)
            end
        end)
    end
end

--// ==================== NHỚ VỊ TRÍ / KÍCH THƯỚC CỬA SỔ ====================
function Extras:_SnapshotWindow()
    local f = self._WinFrame
    if not f or not f.Parent then return end
    pcall(function()
        self._State.win = {
            x = math.floor(f.Position.X.Offset),
            y = math.floor(f.Position.Y.Offset),
            w = math.floor(f.Size.X.Offset),
            h = math.floor(f.Size.Y.Offset),
        }
    end)
end

function Extras:_BindWindowFrame(frame)
    self._WinFrame = frame
    local w = self._State.win
    if type(w) == "table" and tonumber(w.w) and w.w >= 200 then
        pcall(function()
            frame.Size = UDim2.fromOffset(w.w, w.h)
            if w.x and w.y then
                local vp = ScreenSize()
                frame.Position = UDim2.fromOffset(
                    math.clamp(w.x, -w.w + 120, vp.X - 120),
                    math.clamp(w.y, 8, vp.Y - 80))
            end
        end)
    end
    if self._WinTrackConn then
        self._WinTrackConn:Disconnect()
        self._WinTrackConn = nil
    end
    local lastPos, lastSize = nil, nil
    local dirty = false
    local saveAt = 0
    local acc = 0
    self._WinTrackConn = RunService.Heartbeat:Connect(function(dt)
        local f = self._WinFrame
        if not f or not f.Parent then return end
        acc = acc + dt
        if acc < 0.5 then return end
        acc = 0
        local p, s = f.Position, f.Size
        if lastPos and (p ~= lastPos or s ~= lastSize) then
            dirty = true
            saveAt = os.clock() + 1.5
        end
        lastPos, lastSize = p, s
        if dirty and os.clock() >= saveAt then
            dirty = false
            self:_SnapshotWindow()
            SaveState()
        end
    end)
    table.insert(self._Conn, self._WinTrackConn)
end

function Extras:EnableRememberWindow(windowLike)
    self._RememberWin = true
    local source = windowLike or self.Library or self._WinObj
    local frame = FindWindowFrame(source)
    if frame then
        self:_BindWindowFrame(frame)
        return true
    end
    task.spawn(function()
        for _ = 1, 40 do
            task.wait(0.25)
            local f = FindWindowFrame(self.Library or self._WinObj)
            if f then
                self:_BindWindowFrame(f)
                if self._ResizeCfg then self:_BindResizeGrip(f, self._ResizeCfg) end
                return
            end
        end
        warn("[MeizuExtras] Khong tim thay cua so library de nho vi tri")
    end)
    return false
end

--// ==================== KÉO GÓC ĐỔI KÍCH THƯỚC ====================
function Extras:_BindResizeGrip(frame, cfg)
    self._WinFrame = frame
    local minW = math.max(tonumber(cfg.MinW) or 420, 260)
    local minH = math.max(tonumber(cfg.MinH) or 300, 180)
    local startSize = frame.Size
    local gui = GetGui()

    local Grip = New("Frame", {
        Name = "MeizuResizeGrip",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 1),
        Size = UDim2.fromOffset(22, 22),
        ZIndex = 500, Parent = gui,
    })
    local Bars = {}
    for i = 1, 3 do
        local b = New("Frame", {
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -3 - (i - 1) * 5, 1, -3 - (i - 1) * 5),
            Size = UDim2.fromOffset(10, 2),
            Rotation = -45,
            BackgroundColor3 = C.Stroke,
            BorderSizePixel = 0,
            ZIndex = 501, Parent = Grip,
        })
        table.insert(Bars, b)
    end
    Grip.MouseEnter:Connect(function()
        for _, b in ipairs(Bars) do Tween(b, 0.15, {BackgroundColor3 = C.Accent}) end
    end)
    Grip.MouseLeave:Connect(function()
        for _, b in ipairs(Bars) do Tween(b, 0.2, {BackgroundColor3 = C.Stroke}) end
    end)
    OnThemeRefresh({}, function()
        for _, b in ipairs(Bars) do b.BackgroundColor3 = C.Stroke end
    end)

    -- bám sát góc cửa sổ (đúng cả khi library đang dùng UIScale)
    local function Sync()
        if not frame.Parent then return end
        local off = frame.Size.X.Offset
        if off <= 0 then return end
        local k = frame.AbsoluteSize.X / off
        if k <= 0 then k = 1 end
        Grip.Size = UDim2.fromOffset(22 * k, 22 * k)
        local ap, as = frame.AbsolutePosition, frame.AbsoluteSize
        Grip.Position = UDim2.fromOffset(ap.X + as.X, ap.Y + as.Y)
    end
    local syncConn = RunService.Heartbeat:Connect(Sync)
    table.insert(self._Conn, syncConn)

    local lastClick = 0
    Grip.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local sx, sy = input.Position.X, input.Position.Y
        local sw, sh = frame.Size.X.Offset, frame.Size.Y.Offset
        local vp = ScreenSize()
        local moved = 0
        local moveConn, upConn
        moveConn = UserInputService.InputChanged:Connect(function(inp)
            if inp.UserInputType ~= Enum.UserInputType.MouseMovement
            and inp.UserInputType ~= Enum.UserInputType.Touch then return end
            local dx = inp.Position.X - sx
            local dy = inp.Position.Y - sy
            moved = math.abs(dx) + math.abs(dy)
            local nw = math.clamp(sw + dx, minW, math.floor(vp.X * 0.95))
            local nh = math.clamp(sh + dy, minH, math.floor(vp.Y * 0.95))
            pcall(function() frame.Size = UDim2.fromOffset(nw, nh) end)
        end)
        upConn = UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                if moveConn then moveConn:Disconnect() end
                if upConn then upConn:Disconnect() end
                if moved < 6 then
                    -- click đơn / đúp: đúp = trả kích thước gốc
                    if os.clock() - lastClick < 0.4 then
                        lastClick = 0
                        pcall(function() frame.Size = startSize end)
                        self:_SnapshotWindow()
                        SaveState()
                    else
                        lastClick = os.clock()
                    end
                else
                    self:_SnapshotWindow()
                    SaveState()
                end
            end
        end)
    end)
end

function Extras:EnableResize(cfg)
    cfg = cfg or {}
    self._ResizeCfg = cfg
    local frame = FindWindowFrame(cfg.Window or cfg.Frame or self.Library)
    if frame then
        self:_BindResizeGrip(frame, cfg)
        return true
    end
    task.spawn(function()
        for _ = 1, 40 do
            task.wait(0.25)
            local f = FindWindowFrame(cfg.Window or self.Library)
            if f then
                self:_BindResizeGrip(f, cfg)
                return
            end
        end
        warn("[MeizuExtras] Khong tim thay cua so library de resize")
    end)
    return false
end

--// ==================== NÚT KÍNH HÍT MÉP + HUY HIỆU ====================
function Extras:SetBadge(n)
    if self._SetBadge then self._SetBadge(tonumber(n) or 0) end
end

function Extras:_OnWinVisible()
    if self._WinVisible then
        self._Unread = 0
        self:SetBadge(0)
        self:_UpdateBlur(true)
    else
        self:_UpdateBlur(false)
    end
end

function Extras:EnableSnapButton(cfg)
    cfg = cfg or {}
    local win = cfg.Window
    if not win then win = FindWindowObj(self.Library) end
    if win and type(win.Toggle) == "function" then
        self._WinObj = win
        if not self._TogglePatched then
            local oldToggle = win.Toggle
            win.Toggle = function(w, s)
                local r = oldToggle(w, s)
                task.defer(function()
                    local f = self._WinFrame or FindWindowFrame(self.Library)
                    if f then
                        local vis = f.Visible
                        if vis ~= self._WinVisible then
                            self._WinVisible = vis
                            self:_OnWinVisible()
                        end
                    end
                end)
                return r
            end
            self._TogglePatched = true
        end
    end

    local gui = GetGui()
    local size = math.clamp(tonumber(cfg.Size) or 56, 40, 90)
    local Unread = 0

    local Btn = New("CanvasGroup", {
        Name = "MeizuSnapButton",
        BackgroundColor3 = C.Bg,
        BackgroundTransparency = 0.22,
        Position = cfg.Position or UDim2.new(0, 16, 0.5, -size / 2),
        Size = UDim2.fromOffset(size, size),
        GroupTransparency = 1,
        BorderSizePixel = 0, ZIndex = 90, Parent = gui,
    })
    Round(Btn, math.floor(size * 0.3))
    New("UIStroke", {Color = C.Stroke, Thickness = 1.4, Transparency = 0.3, Parent = Btn})

    if cfg.Icon then
        New("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, size * 0.18, 0, size * 0.18),
            Size = UDim2.new(1, -size * 0.36, 1, -size * 0.36),
            Image = tostring(cfg.Icon),
            ImageColor3 = C.Text,
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 91, Parent = Btn,
        })
    else
        New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.SourceSansBold, TextSize = math.floor(size * 0.36),
            TextColor3 = C.Text,
            Text = string.sub(tostring(cfg.Text or "M"), 1, 2),
            ZIndex = 91, Parent = Btn,
        })
    end

    local Badge = New("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -2, 0, -2),
        Size = UDim2.fromOffset(18, 18),
        BackgroundColor3 = C.Err,
        Visible = false,
        ZIndex = 92, Parent = Btn,
    })
    Round(Badge, 9)
    local BadgeT = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.SourceSansBold, TextSize = 11,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = "", ZIndex = 93, Parent = Badge,
    })

    local function UpdateBadge()
        if Unread <= 0 then
            Badge.Visible = false
            return
        end
        Badge.Visible = true
        BadgeT.Text = Unread > 99 and "99+" or tostring(Unread)
        Badge.Size = UDim2.fromOffset(Unread > 9 and 24 or 18, 18)
    end
    self._SetBadge = function(num)
        Unread = tonumber(num) or 0
        UpdateBadge()
    end

    -- theo dõi thông báo chưa đọc
    if self.Library and not self._NotifyPatched then
        local lib = self.Library
        local oldNotify = lib.Notify
        lib.Notify = function(a, b, c)
            local r = oldNotify(a, b, c)
            if not self._WinVisible then
                Unread = Unread + 1
                UpdateBadge()
            end
            return r
        end
        self._NotifyPatched = true
    end

    -- kéo thả + hít mép
    local side = self._State.snapSide or "left"
    local moved = 0
    local function SnapTo(s, spring)
        local vp = ScreenSize()
        local x = (s == "left") and 16 or (vp.X - size - 16)
        local y = math.clamp(Btn.Position.Y.Offset, 16, vp.Y - size - 16)
        Tween(Btn, spring and 0.4 or 0.25, {Position = UDim2.fromOffset(x, y)},
            spring and Enum.EasingStyle.Back or nil)
    end

    Btn.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        moved = 0
        local startPos = Btn.Position
        local sx, sy = input.Position.X, input.Position.Y
        local moveConn, upConn
        moveConn = UserInputService.InputChanged:Connect(function(inp)
            if inp.UserInputType ~= Enum.UserInputType.MouseMovement
            and inp.UserInputType ~= Enum.UserInputType.Touch then return end
            local dx = inp.Position.X - sx
            local dy = inp.Position.Y - sy
            moved = math.abs(dx) + math.abs(dy)
            Btn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + dx,
                startPos.Y.Scale, startPos.Y.Offset + dy)
        end)
        upConn = UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                if moveConn then moveConn:Disconnect() end
                if upConn then upConn:Disconnect() end
                if moved >= 6 then
                    local vp = ScreenSize()
                    side = (Btn.Position.X.Offset + size / 2 < vp.X / 2) and "left" or "right"
                    self._State.snapSide = side
                    SaveState()
                    SnapTo(side, true)
                    PlayClick(0.08, 0.9)
                end
            end
        end)
    end)

    Btn.Activated:Connect(function()
        if moved >= 6 then return end
        local w = self._WinObj
        if w and type(w.Toggle) == "function" then
            pcall(function() w:Toggle(not self._WinVisible) end)
            self._WinVisible = not self._WinVisible
            self:_OnWinVisible()
            PlayClick(0.12, 1.4)
        else
            warn("[MeizuExtras] Khong biet Window — hay truyen Window = Window khi EnableSnapButton")
        end
    end)

    SnapTo(side, false)
    Tween(Btn, 0.3, {GroupTransparency = 0})

    -- poll dự phòng trạng thái cửa sổ
    task.spawn(function()
        while Btn and Btn.Parent do
            task.wait(1)
            local f = self._WinFrame or FindWindowFrame(self.Library)
            if f then
                local vis = f.Visible
                if vis ~= self._WinVisible then
                    self._WinVisible = vis
                    self:_OnWinVisible()
                end
            end
        end
    end)

    return {
        SetBadge = function(num) self:SetBadge(num) end,
        Destroy = function() if Btn then Btn:Destroy() end end,
    }
end

--// ==================== LÀM MỜ NỀN GAME ====================
function Extras:_UpdateBlur(on)
    local fx = self._BlurFx
    if not fx or not fx.Parent then return end
    if self.PowerSave then on = false end
    Tween(fx, 0.45, {Size = on and self._BlurRadius or 0})
end

function Extras:EnableBlur(cfg)
    cfg = cfg or {}
    self:DisableBlur()
    local fx = Instance.new("BlurEffect")
    fx.Name = "MeizuExtrasBlur"
    fx.Size = 0
    fx.Enabled = true
    pcall(function() fx.Parent = Lighting end)
    self._BlurFx = fx
    self._BlurRadius = math.clamp(tonumber(cfg.Radius) or 8, 1, 24)

    if cfg.AutoToggle == false then
        Tween(fx, 0.5, {Size = self._BlurRadius})
    else
        self:_UpdateBlur(self._WinVisible)
        if not self._WinObj then
            task.spawn(function()
                while self._BlurFx == fx and fx.Parent do
                    task.wait(1)
                    local f = self._WinFrame or FindWindowFrame(self.Library)
                    if f then
                        local vis = f.Visible
                        if vis ~= self._WinVisible then
                            self._WinVisible = vis
                            self:_OnWinVisible()
                        end
                    end
                end
            end)
        end
    end
    return true
end

function Extras:DisableBlur()
    if self._BlurFx then
        pcall(function() self._BlurFx:Destroy() end)
        self._BlurFx = nil
    end
end

--// ==================== CHẾ ĐỘ TIẾT KIỆM ====================
function Extras:EnablePowerSave(on)
    self.PowerSave = on == true
    if self.PowerSave then
        self:_UpdateBlur(false)
        local lib = self.Library
        if lib and type(lib.SetRainbow) == "function" then
            pcall(function() lib:SetRainbow(false) end)
        end
    end
    self._State.power = self.PowerSave
    SaveState()
    return self.PowerSave
end

--// ==================== TIỆN ÍCH CŨ (TỪ v1.0) ====================
local WM = nil

function Extras:DisableWatermark()
    if not WM then return end
    if WM._c1 then WM._c1:Disconnect() end
    if WM._c2 then WM._c2:Disconnect() end
    if WM.Card then WM.Card:Destroy() end
    WM = nil
end

function Extras:EnableWatermark(cfg)
    cfg = cfg or {}
    self:DisableWatermark()
    local gui = GetGui()

    local showText  = cfg.Text ~= nil and cfg.Text ~= false
    local showFPS   = cfg.ShowFPS ~= false
    local showPing  = cfg.ShowPing ~= false
    local showClock = cfg.ShowClock ~= false
    local showUp    = cfg.ShowUptime ~= false

    local Card = New("CanvasGroup", {
        Name = "Watermark",
        BackgroundColor3 = C.Bg,
        BackgroundTransparency = 0.15,
        Position = cfg.Position or UDim2.new(0, 16, 0, 16),
        Size = UDim2.fromOffset(160, 34),
        GroupTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 50, Parent = gui,
    })
    Round(Card, 10)
    New("UIStroke", {Color = C.Stroke, Thickness = 1, Transparency = 0.25, Parent = Card})

    local Dot = New("Frame", {
        BackgroundColor3 = C.Accent,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 10, 0.5, 0),
        Size = UDim2.fromOffset(8, 8),
        BorderSizePixel = 0, ZIndex = 51, Parent = Card,
    })
    Round(Dot, 4)

    local Label = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 26, 0, 0),
        Size = UDim2.new(1, -32, 1, 0),
        Font = Enum.Font.SourceSansSemibold,
        TextSize = 14,
        TextColor3 = C.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "", ZIndex = 51, Parent = Card,
    })

    local frames, acc, fps, ping = 0, 0, 60, 0
    local t0 = os.clock()

    local c1 = RunService.RenderStepped:Connect(function(dt)
        frames = frames + 1
        acc = acc + dt
        if acc >= 0.5 then
            fps = math.floor(frames / acc + 0.5)
            frames = 0
            acc = 0
        end
    end)

    local function Refresh()
        local parts = {}
        if showText and cfg.Text then table.insert(parts, tostring(cfg.Text)) end
        if showFPS then table.insert(parts, fps .. " FPS") end
        if showPing then table.insert(parts, string.format("%.0f ms", ping * 1000)) end
        if showUp then
            local up = os.clock() - t0
            table.insert(parts, string.format("%d:%02d:%02d",
                math.floor(up / 3600), math.floor(up / 60) % 60, math.floor(up) % 60))
        end
        if showClock then table.insert(parts, os.date("%H:%M:%S")) end
        Label.Text = table.concat(parts, "  •  ")
        local w = Measure(Label.Text, 14, Enum.Font.SourceSansSemibold)
        Card.Size = UDim2.fromOffset(w + 40, 34)
    end

    local tAcc = 1
    local c2 = RunService.Heartbeat:Connect(function(dt)
        pcall(function()
            local p = LocalPlayer:GetNetworkPing()
            if p >= 0 and p < 5 then ping = p end
        end)
        tAcc = tAcc + dt
        if tAcc >= (Extras.PowerSave and 1 or 0.5) then
            tAcc = 0
            Refresh()
        end
    end)

    Draggable(Card, Card)
    WM = {Card = Card, Dot = Dot, Label = Label, _c1 = c1, _c2 = c2}

    task.spawn(function()
        while WM and WM.Card == Card and Card.Parent do
            if Extras.PowerSave then break end
            Tween(Dot, 0.8, {BackgroundTransparency = 0.45})
            task.wait(0.8)
            if not (WM and WM.Card == Card) then break end
            Tween(Dot, 0.8, {BackgroundTransparency = 0})
            task.wait(0.8)
        end
    end)

    Tween(Card, 0.3, {GroupTransparency = 0})
    Refresh()

    return {
        SetText = function(s)
            cfg.Text = s
            Refresh()
        end,
        Destroy = function() Extras:DisableWatermark() end,
    }
end

local KV = nil

function Extras:DisableKeyVisualizer()
    if not KV then return end
    if KV._c then KV._c:Disconnect() end
    if KV.Holder then KV.Holder:Destroy() end
    KV = nil
end

function Extras:EnableKeyVisualizer(cfg)
    cfg = cfg or {}
    self:DisableKeyVisualizer()
    local gui = GetGui()

    local Holder = New("Frame", {
        Name = "KeyVisualizer",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = cfg.Position or UDim2.new(0.5, 0, 1, -70),
        Size = UDim2.fromOffset(500, 60),
        ZIndex = 60, Parent = gui,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 6),
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = Holder,
    })

    local count, order = 0, 0
    local function AddPill(name)
        if count >= 12 then return end
        count = count + 1
        order = order + 1
        local Pill = New("CanvasGroup", {
            BackgroundColor3 = C.Bg,
            BackgroundTransparency = 0.1,
            Size = UDim2.fromOffset(0, 30),
            ClipsDescendants = true,
            LayoutOrder = order,
            GroupTransparency = 0,
            BorderSizePixel = 0, ZIndex = 61, Parent = Holder,
        })
        Round(Pill, 8)
        New("UIStroke", {Color = C.Stroke, Thickness = 1, Transparency = 0.3, Parent = Pill})
        New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 4, 0, 0),
            Size = UDim2.new(1, -8, 1, 0),
            Font = Enum.Font.SourceSansSemibold, TextSize = 14,
            TextColor3 = C.Text, Text = name,
            ZIndex = 62, Parent = Pill,
        })
        local w = Measure(name, 14, Enum.Font.SourceSansSemibold)
        local sc = New("UIScale", {Scale = 0.7, Parent = Pill})
        Tween(sc, 0.25, {Scale = 1}, Enum.EasingStyle.Back)
        Tween(Pill, 0.18, {Size = UDim2.fromOffset(w + 16, 30)})
        task.delay(1.1, function()
            count = count - 1
            Tween(Pill, 0.3, {GroupTransparency = 1})
            task.delay(0.32, function() if Pill then Pill:Destroy() end end)
        end)
    end

    local function KeyName(input)
        local t = input.UserInputType
        if t == Enum.UserInputType.Keyboard then
            local nm = input.KeyCode.Name
            if nm ~= "Unknown" then return nm end
            return nil
        end
        if t == Enum.UserInputType.MouseButton1 then return "LMB" end
        if t == Enum.UserInputType.MouseButton2 then return "RMB" end
        if t == Enum.UserInputType.MouseButton3 then return "MMB" end
        if t == Enum.UserInputType.Touch then return "TAP" end
        return nil
    end

    local c = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        local name = KeyName(input)
        if name then AddPill(name) end
    end)

    KV = {Holder = Holder, _c = c}
    return {Destroy = function() Extras:DisableKeyVisualizer() end}
end

local LOG = nil

function Extras:DisableLogger()
    if not LOG then return end
    if LOG._c then LOG._c:Disconnect() end
    if LOG.Panel then LOG.Panel:Destroy() end
    LOG = nil
end

function Extras:Log(msg, tag)
    if LOG and LOG.AddLine then LOG.AddLine(msg, tag) end
end

function Extras:ClearLog()
    if LOG and LOG.Clear then LOG.Clear() end
end

function Extras:EnableLogger(cfg)
    cfg = cfg or {}
    self:DisableLogger()
    local gui = GetGui()
    local maxEntries = math.max(cfg.Max or 60, 10)
    local W = cfg.Width or 340

    local Panel = New("CanvasGroup", {
        Name = "Logger",
        BackgroundColor3 = C.Bg,
        BackgroundTransparency = 0.05,
        AnchorPoint = Vector2.new(0, 1),
        Position = cfg.Position or UDim2.new(0, 16, 1, -16),
        Size = UDim2.fromOffset(W, cfg.Height or 180),
        ClipsDescendants = true,
        BorderSizePixel = 0, ZIndex = 70, Parent = gui,
    })
    Round(Panel, 10)
    New("UIStroke", {Color = C.Stroke, Thickness = 1, Transparency = 0.25, Parent = Panel})

    local Header = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 28),
        ZIndex = 71, Parent = Panel,
    })
    New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -90, 1, 0),
        Font = Enum.Font.SourceSansBold, TextSize = 13,
        TextColor3 = C.Text, TextXAlignment = Enum.TextXAlignment.Left,
        Text = "MEIZU LOGGER", ZIndex = 72, Parent = Header,
    })
    local ClearBtn = New("TextButton", {
        BackgroundTransparency = 1, AutoButtonColor = false,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -50, 0, 0),
        Size = UDim2.fromOffset(42, 28),
        Font = Enum.Font.SourceSansSemibold, TextSize = 11,
        TextColor3 = C.Sub, Text = "CLEAR",
        ZIndex = 72, Parent = Header,
    })
    local HideBtn = New("TextButton", {
        BackgroundTransparency = 1, AutoButtonColor = false,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -8, 0, 0),
        Size = UDim2.fromOffset(22, 28),
        Font = Enum.Font.SourceSansBold, TextSize = 13,
        TextColor3 = C.Sub, Text = "X",
        ZIndex = 72, Parent = Header,
    })

    local List = New("ScrollingFrame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 1, -32),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.Stroke,
        BorderSizePixel = 0, ZIndex = 71, Parent = Panel,
    })
    local Layout = New("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = List,
    })
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        List.CanvasSize = UDim2.fromOffset(0, Layout.AbsoluteContentSize + 8)
        List.CanvasPosition = Vector2.new(0,
            math.max(Layout.AbsoluteContentSize - List.AbsoluteSize.Y + 8, 0))
    end)

    local entries, order = 0, 0
    local function AddLine(msg, tag)
        tag = tostring(tag or "info")
        local color = (tag == "ok" and C.Ok) or (tag == "warn" and C.Warn)
                     or (tag == "err" and C.Err) or C.Accent
        order = order + 1
        local full = os.date("%H:%M:%S") .. "  " .. tostring(msg)
        local _, h = Measure(full, 12, Enum.Font.SourceSans, W - 26)
        local Row = New("Frame", {
            BackgroundColor3 = C.Panel,
            BackgroundTransparency = 0.35,
            Size = UDim2.new(1, -8, 0, h + 8),
            LayoutOrder = -order,
            BorderSizePixel = 0, ZIndex = 71, Parent = List,
        })
        Round(Row, 5)
        New("Frame", {
            BackgroundColor3 = color,
            Position = UDim2.new(0, 4, 0, 4),
            Size = UDim2.new(0, 2, 1, -8),
            BorderSizePixel = 0, ZIndex = 72, Parent = Row,
        })
        New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 4),
            Size = UDim2.new(1, -16, 1, -8),
            Font = Enum.Font.SourceSans, TextSize = 12,
            TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true, Text = full,
            ZIndex = 72, Parent = Row,
        })
        entries = entries + 1
        if entries > maxEntries then
            for _, ch in ipairs(List:GetChildren()) do
                if ch:IsA("Frame") then
                    ch:Destroy()
                    entries = entries - 1
                    break
                end
            end
        end
    end

    local function ClearAll()
        for _, ch in ipairs(List:GetChildren()) do
            if ch:IsA("Frame") then ch:Destroy() end
        end
        entries = 0
    end
    ClearBtn.Activated:Connect(function()
        ClearAll()
        PlayClick(0.1, 1.5)
    end)

    local hidden = false
    local function Toggle()
        hidden = not hidden
        if hidden then
            Tween(Panel, 0.22, {GroupTransparency = 1})
            task.delay(0.24, function()
                if hidden then Panel.Visible = false end
            end)
        else
            Panel.Visible = true
            Tween(Panel, 0.22, {GroupTransparency = 0})
        end
    end
    HideBtn.Activated:Connect(Toggle)

    local key = cfg.Keybind or Enum.KeyCode.F4
    local c = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == key then Toggle() end
    end)

    Draggable(Header, Panel)
    LOG = {Panel = Panel, List = List, AddLine = AddLine, Clear = ClearAll, _c = c}
    self:Log("Logger san sang — nhan " .. key.Name .. " de an/hien", "ok")
    return {
        Toggle = Toggle,
        Destroy = function() Extras:DisableLogger() end,
    }
end

local TT = nil
local function EnsureTooltip()
    if TT and TT.Card.Parent then return TT end
    local Card = New("CanvasGroup", {
        Name = "Tooltip",
        BackgroundColor3 = C.Bg,
        BackgroundTransparency = 0.05,
        Size = UDim2.fromOffset(20, 20),
        Visible = false,
        GroupTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 300, Parent = GetGui(),
    })
    Round(Card, 6)
    New("UIStroke", {Color = C.Stroke, Thickness = 1, Transparency = 0.2, Parent = Card})
    local Label = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 5),
        Size = UDim2.new(1, -16, 1, -10),
        Font = Enum.Font.SourceSans, TextSize = 13,
        TextColor3 = C.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true, Text = "",
        ZIndex = 301, Parent = Card,
    })
    TT = {Card = Card, Label = Label}
    return TT
end

function Extras:AttachTooltip(target, text)
    if text == nil then return nil end
    target = ResolveTarget(target)
    if not target then return nil end

    local tip = EnsureTooltip()
    local shown = false
    local moveConn = nil

    local function Place(w, h)
        local m = MousePos()
        local sw = ScreenSize()
        local x, y = m.X + 14, m.Y + 18
        if x + w > sw.X - 8 then x = m.X - w - 14 end
        if y + h > sw.Y - 8 then y = m.Y - h - 16 end
        if x < 8 then x = 8 end
        if y < 8 then y = 8 end
        tip.Card.Position = UDim2.fromOffset(x, y)
    end

    target.MouseEnter:Connect(function()
        tip.Label.Text = tostring(text)
        local w, h = Measure(text, 13, Enum.Font.SourceSans, 260)
        w = math.min(w + 16, 276)
        h = h + 10
        tip.Card.Size = UDim2.fromOffset(w, h)
        Place(w, h)
        shown = true
        tip.Card.Visible = true
        Tween(tip.Card, 0.15, {GroupTransparency = 0})
        if moveConn then moveConn:Disconnect() end
        moveConn = UserInputService.InputChanged:Connect(function(inp)
            if inp.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            Place(tip.Card.Size.X.Offset, tip.Card.Size.Y.Offset)
        end)
    end)

    target.MouseLeave:Connect(function()
        shown = false
        if moveConn then moveConn:Disconnect() moveConn = nil end
        Tween(tip.Card, 0.12, {GroupTransparency = 1})
        task.delay(0.14, function()
            if not shown and TT == tip then tip.Card.Visible = false end
        end)
    end)
    return target
end

local OpenMenu = nil

function Extras:NewContextMenu(target, items)
    if type(items) ~= "table" then return nil end
    target = ResolveTarget(target)
    if not target then return nil end
    local handle = {Close = function()
        if OpenMenu and OpenMenu.Owner == handle then OpenMenu.Close() end
    end}

    target.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
        if OpenMenu then OpenMenu.Close() end

        local rowH, width, totalH = 30, 0, 0
        for _, it in ipairs(items) do
            if type(it) == "table" then
                if it.Separator then
                    totalH = totalH + 9
                else
                    local w = Measure(tostring(it.Text or "..."), 13, Enum.Font.SourceSansSemibold)
                    if w + 44 > width then width = w + 44 end
                    totalH = totalH + rowH
                end
            end
        end
        if totalH == 0 then return end
        width = math.max(width, 130)

        local m, sw = MousePos(), ScreenSize()
        local x, y = m.X, m.Y
        if x + width > sw.X - 8 then x = sw.X - width - 8 end
        if y + totalH > sw.Y - 8 then y = sw.Y - totalH - 8 end
        if x < 8 then x = 8 end
        if y < 8 then y = 8 end

        local Menu = New("CanvasGroup", {
            Name = "ContextMenu",
            BackgroundColor3 = C.Bg,
            BackgroundTransparency = 0.05,
            Position = UDim2.fromOffset(x, y),
            Size = UDim2.fromOffset(width, totalH),
            GroupTransparency = 1,
            ClipsDescendants = true,
            BorderSizePixel = 0, ZIndex = 400, Parent = GetGui(),
        })
        Round(Menu, 8)
        New("UIStroke", {Color = C.Stroke, Thickness = 1, Transparency = 0.2, Parent = Menu})

        local closed = false
        local globalConn
        local function Close()
            if closed then return end
            closed = true
            if globalConn then globalConn:Disconnect() globalConn = nil end
            Tween(Menu, 0.15, {GroupTransparency = 1})
            task.delay(0.17, function()
                if Menu then Menu:Destroy() end
            end)
            if OpenMenu and OpenMenu.Owner == handle then OpenMenu = nil end
        end
        handle.Close = Close

        globalConn = UserInputService.InputBegan:Connect(function(inp)
            local t = inp.UserInputType
            if t ~= Enum.UserInputType.MouseButton1 and t ~= Enum.UserInputType.Touch then return end
            local px, py = inp.Position.X, inp.Position.Y
            if px >= x and px <= x + width and py >= y and py <= y + totalH then return end
            Close()
        end)

        local oy = 0
        for _, it in ipairs(items) do
            if type(it) == "table" and it.Separator then
                New("Frame", {
                    BackgroundColor3 = C.Stroke,
                    Position = UDim2.new(0, 8, 0, oy + 4),
                    Size = UDim2.new(1, -16, 0, 1),
                    BorderSizePixel = 0, ZIndex = 401, Parent = Menu,
                })
                oy = oy + 9
            elseif type(it) == "table" then
                local disabled = it.Disabled == true
                local Item = New("TextButton", {
                    BackgroundColor3 = C.Accent,
                    BackgroundTransparency = 1,
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 4, 0, oy),
                    Size = UDim2.new(1, -8, 0, rowH),
                    Text = "", ZIndex = 401, Parent = Menu,
                })
                Round(Item, 6)
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -20, 1, 0),
                    Font = Enum.Font.SourceSansSemibold, TextSize = 13,
                    TextColor3 = disabled and C.Sub or C.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Text = tostring(it.Text or "..."),
                    ZIndex = 402, Parent = Item,
                })
                Item.MouseEnter:Connect(function()
                    if not disabled then Tween(Item, 0.12, {BackgroundTransparency = 0.82}) end
                end)
                Item.MouseLeave:Connect(function()
                    Tween(Item, 0.12, {BackgroundTransparency = 1})
                end)
                Item.Activated:Connect(function()
                    if disabled then return end
                    Close()
                    PlayClick(0.12, 1.5)
                    if type(it.Callback) == "function" then
                        task.spawn(function()
                            local ok, err = pcall(it.Callback)
                            if not ok then warn("[MeizuExtras] Menu error: " .. tostring(err)) end
                        end)
                    end
                end)
                oy = oy + rowH
            end
        end

        OpenMenu = {Owner = handle, Close = Close}
        Tween(Menu, 0.18, {GroupTransparency = 0})
        PlayClick(0.1, 1.35)
    end)
    return handle
end

local Panic = {Conn = nil, Hidden = false, Affected = {}}

function Extras:SetPanicKey(key)
    if Panic.Conn then Panic.Conn:Disconnect() Panic.Conn = nil end
    if not key then return end
    Panic.Conn = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == key then Extras:TogglePanic() end
    end)
end

function Extras:TogglePanic()
    if not Panic.Hidden then
        Panic.Affected = {}
        if Extras._Gui and Extras._Gui.Parent then
            table.insert(Panic.Affected, {Gui = Extras._Gui, Was = Extras._Gui.Enabled})
            Extras._Gui.Enabled = false
        end
        local function Scan(parent)
            if not parent then return end
            pcall(function()
                for _, ch in ipairs(parent:GetChildren()) do
                    if ch:IsA("ScreenGui")
                    and (ch.Name == "MeizuLibrary" or ch.Name:sub(1, 13) == "MeizuLibrary_") then
                        table.insert(Panic.Affected, {Gui = ch, Was = ch.Enabled})
                        ch.Enabled = false
                    end
                end
            end)
        end
        if type(gethui) == "function" then pcall(function() Scan(gethui()) end) end
        if LocalPlayer then
            pcall(function() Scan(LocalPlayer:FindFirstChild("PlayerGui")) end)
        end
        Panic.Hidden = true
    else
        for _, e in ipairs(Panic.Affected) do
            if e.Gui and e.Gui.Parent then e.Gui.Enabled = e.Was end
        end
        Panic.Affected = {}
        Panic.Hidden = false
    end
    return Panic.Hidden
end

local Boost = {On = false, Saved = {}}

function Extras:ToggleFPSBoost(on)
    on = (on == nil) and (not Boost.On) or (on == true)
    if on == Boost.On then return Boost.On end
    if on then
        Boost.Saved = {}
        pcall(function()
            Boost.Saved.Quality = settings().Rendering.QualityLevel
            settings().Rendering.QualityLevel = 1
        end)
        pcall(function()
            Boost.Saved.Shadows = Lighting.GlobalShadows
            Lighting.GlobalShadows = false
        end)
        pcall(function()
            local t = workspace:FindFirstChildOfClass("Terrain")
            if t then
                Boost.Saved.Decoration = t.Decoration
                t.Decoration = false
            end
        end)
        Boost.On = true
    else
        pcall(function()
            if Boost.Saved.Quality then settings().Rendering.QualityLevel = Boost.Saved.Quality end
        end)
        pcall(function()
            if Boost.Saved.Shadows ~= nil then Lighting.GlobalShadows = Boost.Saved.Shadows end
        end)
        pcall(function()
            local t = workspace:FindFirstChildOfClass("Terrain")
            if t and Boost.Saved.Decoration ~= nil then t.Decoration = Boost.Saved.Decoration end
        end)
        Boost.On = false
        Boost.Saved = {}
    end
    return Boost.On
end

function Extras:IsFPSBoosted()
    return Boost.On
end

local AntiAFK = {Conn = nil}

function Extras:EnableAntiAFK(on)
    on = (on == nil) and true or (on == true)
    if on then
        if AntiAFK.Conn then return true end
        if not LocalPlayer then return false end
        AntiAFK.Conn = LocalPlayer.Idled:Connect(function()
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end)
    else
        if AntiAFK.Conn then AntiAFK.Conn:Disconnect() AntiAFK.Conn = nil end
    end
    return on
end

--// ==================== KẾT NỐI LIBRARY ====================
function Extras:SyncTheme()
    local lib = self.Library
    if lib then
        local th = lib.Themes and lib.Themes[lib.Theme]
        if th then
            C.Bg     = th.Window or C.Bg
            C.Panel  = th.Element or C.Panel
            C.Text   = th.Text or C.Text
            C.Sub    = th.SubText or C.Sub
            C.Stroke = th.Stroke or C.Stroke
        end
        if lib.Accent then C.Accent = lib.Accent end
    end
    if WM and WM.Card then
        WM.Card.BackgroundColor3 = C.Bg
        WM.Label.TextColor3 = C.Text
        WM.Dot.BackgroundColor3 = C.Accent
    end
    if LOG and LOG.Panel then
        LOG.Panel.BackgroundColor3 = C.Bg
    end
    RefreshThemes()
end

function Extras:Init(library)
    self.Library = library
    if not library then return self end
    if library.SoundEnabled ~= nil then self.SoundEnabled = library.SoundEnabled end

    -- bám theme / màu nhấn của library
    if not self._ThemePatched and type(library.ApplyTheme) == "function" then
        local oldTheme = library.ApplyTheme
        library.ApplyTheme = function(lib, name)
            local r = oldTheme(lib, name)
            Extras:SyncTheme()
            return r
        end
        self._ThemePatched = true
    end
    if not self._AccentPatched and type(library.ApplyAccent) == "function" then
        local oldAccent = library.ApplyAccent
        library.ApplyAccent = function(lib, color)
            local r = oldAccent(lib, color)
            Extras:SyncTheme()
            return r
        end
        self._AccentPatched = true
    end
    -- library gỡ -> extras tự dọn theo
    if not self._DestroyPatched and type(library.Destroy) == "function" then
        local oldDestroy = library.Destroy
        library.Destroy = function(lib, ...)
            oldDestroy(lib, ...)
            pcall(function() Extras:Destroy() end)
        end
        self._DestroyPatched = true
    end

    -- nạp trạng thái đã lưu
    local data = LoadState()
    if data then
        self._State = data
        self._StateLoaded = true
        if data.power == true then self.PowerSave = true end
    end

    -- dò sẵn cửa sổ nếu đã tạo
    local frame = FindWindowFrame(library)
    if frame then self._WinFrame = frame end
    local wobj = FindWindowObj(library)
    if wobj then self._WinObj = wobj end

    self:SyncTheme()
    return self
end
Extras.Attach = Extras.Init

function Extras:SnapshotNow()
    if self._WinFrame then self:_SnapshotWindow() end
    SaveState()
end

function Extras:Destroy()
    pcall(function() self:SnapshotNow() end)
    for _, c in ipairs(self._Conn) do
        pcall(function() c:Disconnect() end)
    end
    self._Conn = {}
    if self._WinTrackConn then
        self._WinTrackConn:Disconnect()
        self._WinTrackConn = nil
    end
    self:DisableBlur()
    if Panic.Conn then Panic.Conn:Disconnect() end
    if AntiAFK.Conn then AntiAFK.Conn:Disconnect() end
    if Boost.On then self:ToggleFPSBoost(false) end
    if OpenMenu then OpenMenu.Close() end
    self:DisableWatermark()
    self:DisableKeyVisualizer()
    self:DisableLogger()
    if self._Gui then
        self._Gui:Destroy()
        self._Gui = nil
    end
end

-- chống chồng bản: chạy lại script -> gỡ bản extras cũ
pcall(function()
    if type(getgenv) == "function" then
        local old = getgenv().MeizuExtras
        if old and old ~= Extras and type(old.Destroy) == "function" then old:Destroy() end
        getgenv().MeizuExtras = Extras
    end
end)

return Extras
