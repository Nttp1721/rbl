--[[
    ███████╗███╗   ██╗████████╗██████╗  ██████╗
    ██╔════╝████╗  ██║╚══██╔══╝██╔══██╗██╔═══██╗
    █████╗  ██╔██╗ ██║   ██║   ██████╔╝██║   ██║
    ██╔══╝  ██║╚██╗██║   ██║   ██╔══██╗██║   ██║
    ███████╗██║ ╚████║   ██║   ██║  ██║╚██████╔╝
    ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝
    MEIZU HUB — INTRO + MEIZULIBRARY v2.2
    (Bản y chang tinh thần testtintro.lua gốc, nhưng dùng MeizuLibrary)
]]

--// ============ LOAD LIBRARY ============
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/MeizuLibrary.lua"))()

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local LocalPlayer      = Players.LocalPlayer

local LOGO_URL = "https://i.ibb.co/S7rpHJJN/meizuxp.png"

--// Màu đồng bộ theme Dark của library
local C = {
    Window   = Color3.fromRGB(18, 20, 28),
    Sidebar  = Color3.fromRGB(13, 15, 21),
    Element  = Color3.fromRGB(27, 30, 42),
    Stroke   = Color3.fromRGB(45, 50, 66),
    Text     = Color3.fromRGB(240, 242, 248),
    SubText  = Color3.fromRGB(148, 153, 168),
    Input    = Color3.fromRGB(21, 24, 33),
    Accent   = Color3.fromRGB(88, 101, 242),
}

local RADIUS = 12 -- ⬅ bo góc kiểu testtintro (KHÔNG tròn hoàn hảo)

--// ============ HELPERS ============
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
    local t = TweenService:Create(obj,
        TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
        props)
    t:Play()
    return t
end

local function Corner(parent, r)
    return New("UICorner", {CornerRadius = UDim.new(0, r or RADIUS), Parent = parent})
end

--// Resolve ảnh (URL .png cần executor có getcustomasset, rbxassetid luôn chạy)
local function ResolveImageAsset(id)
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
            local path = "MeizuHub/intro_logo.png"
            local okW = pcall(function()
                if isfolder and not isfolder("MeizuHub") then makefolder("MeizuHub") end
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

local function CreateGui(name)
    local gui
    local ok = pcall(function()
        gui = Instance.new("ScreenGui")
        gui.Name = name
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.DisplayOrder = 9998
        gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
    end)
    if not ok or not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = name
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    return gui
end

--// FPS + Ping counter
local FPSConn = RunService.RenderStepped:Connect(function() end)
local frameCount = 0
FPSConn:Disconnect()
FPSConn = RunService.RenderStepped:Connect(function() frameCount = frameCount + 1 end)
local function GetFPS()
    local f = frameCount
    frameCount = 0
    return f
end
local function GetPing()
    local ok, ping = pcall(function() return LocalPlayer:GetNetworkPing() * 1000 end)
    return ok and math.floor(ping) or 0
end

--// ============================================================
--//                    INTRO SCREEN
--// ============================================================
local introAlive = true

task.spawn(function()
    local IntroGui = CreateGui("MeizuIntro")

    local Overlay = New("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0, ZIndex = 1, Parent = IntroGui,
    })

    local Card = New("CanvasGroup", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(280, 330),
        BackgroundColor3 = C.Window,
        GroupTransparency = 1,
        BorderSizePixel = 0, ZIndex = 2, Parent = IntroGui,
    })
    Corner(Card, 14)
    New("UIStroke", {Color = C.Stroke, Thickness = 1, Transparency = 0.3, Parent = Card})
    local CardScale = New("UIScale", {Scale = 0.85, Parent = Card})

    -- Bóng đổ
    New("ImageLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 70, 1, 70),
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = 0, Parent = Card,
    })

    -- Logo (bo góc 12 kiểu testtintro)
    local LogoHolder = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 22),
        Size = UDim2.fromOffset(92, 92),
        BackgroundColor3 = C.Sidebar,
        BorderSizePixel = 0, ZIndex = 3, Parent = Card,
        ClipsDescendants = true,
    })
    Corner(LogoHolder, RADIUS)
    New("UIStroke", {Color = C.Accent, Thickness = 1.5, Transparency = 0.35, Parent = LogoHolder})
    local LogoScale = New("UIScale", {Scale = 0.5, Parent = LogoHolder})

    local Logo = New("ImageLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ScaleType = Enum.ScaleType.Fit,
        Visible = false, ZIndex = 3, Parent = LogoHolder,
    })
    Corner(Logo, RADIUS)

    local LogoLetter = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Font = Enum.Font.GothamBlack, TextSize = 38,
        Text = "M", TextColor3 = C.Accent,
        ZIndex = 3, Parent = LogoHolder,
    })

    -- Title / Subtitle
    New("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 128),
        Size = UDim2.fromOffset(240, 24),
        Font = Enum.Font.GothamBold, TextSize = 21,
        Text = "Meizu Hub", TextColor3 = C.Text,
        ZIndex = 3, Parent = Card,
    })
    New("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 154),
        Size = UDim2.fromOffset(240, 14),
        Font = Enum.Font.Gotham, TextSize = 11,
        Text = "v2.2 • by Nttp1721", TextColor3 = C.SubText,
        ZIndex = 3, Parent = Card,
    })

    -- Status
    local Status = New("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 182),
        Size = UDim2.fromOffset(240, 14),
        Font = Enum.Font.Gotham, TextSize = 11,
        Text = "Đang khởi động...", TextColor3 = C.SubText,
        ZIndex = 3, Parent = Card,
    })

    -- Progress bar
    local BarTrack = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 210),
        Size = UDim2.fromOffset(200, 6),
        BackgroundColor3 = C.Element,
        BorderSizePixel = 0, ZIndex = 3, Parent = Card,
    })
    Corner(BarTrack, 3)
    local BarFill = New("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = C.Accent,
        BorderSizePixel = 0, ZIndex = 4, Parent = BarTrack,
    })
    Corner(BarFill, 3)

    local Percent = New("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 222),
        Size = UDim2.fromOffset(240, 12),
        Font = Enum.Font.GothamBold, TextSize = 10,
        Text = "0%", TextColor3 = C.SubText,
        ZIndex = 3, Parent = Card,
    })

    -- FPS / Ping
    local NetRow = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 254),
        Size = UDim2.fromOffset(220, 44),
        BackgroundColor3 = C.Sidebar,
        BorderSizePixel = 0, ZIndex = 3, Parent = Card,
    })
    Corner(NetRow, 10)
    local Ava = New("ImageLabel", {
        Position = UDim2.new(0, 7, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.fromOffset(30, 30),
        BackgroundColor3 = C.Element,
        BorderSizePixel = 0, ZIndex = 4, Parent = NetRow,
    })
    Corner(Ava, 15) -- avatar tròn
    pcall(function()
        Ava.Image = Players:GetUserThumbnailAsync(
            LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    end)
    local FPSLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 46, 0, 6),
        Size = UDim2.new(1, -54, 0, 16),
        Font = Enum.Font.GothamBold, TextSize = 12,
        Text = "-- FPS", TextColor3 = C.Accent,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4, Parent = NetRow,
    })
    local PingLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 46, 0, 22),
        Size = UDim2.new(1, -54, 0, 16),
        Font = Enum.Font.Gotham, TextSize = 11,
        Text = "-- MS Ping", TextColor3 = C.SubText,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4, Parent = NetRow,
    })

    local Credit = New("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -10),
        Size = UDim2.fromOffset(240, 12),
        Font = Enum.Font.Gotham, TextSize = 10,
        Text = "Powered by Meizu Library", TextColor3 = C.SubText,
        TextTransparency = 0.4, ZIndex = 3, Parent = Card,
    })

    --// Vào animation
    Tween(Overlay, 0.3, {BackgroundTransparency = 0.35})
    Tween(CardScale, 0.45, {Scale = 1}, Enum.EasingStyle.Back)
    Tween(Card, 0.3, {GroupTransparency = 0})
    Tween(LogoScale, 0.55, {Scale = 1}, Enum.EasingStyle.Back)

    -- Load logo
    task.spawn(function()
        local asset = ResolveImageAsset(LOGO_URL)
        if asset then
            Logo.Image = asset
            Logo.Visible = true
            LogoLetter.Visible = false
        end
    end)

    -- FPS/Ping updater
    task.spawn(function()
        while introAlive and IntroGui.Parent do
            task.wait(1)
            FPSLabel.Text = GetFPS() .. " FPS"
            PingLabel.Text = GetPing() .. " MS Ping"
        end
    end)

    --// Loading steps
    local steps = {
        {0.15, 12,  "Đang khởi động..."},
        {0.40, 38,  "Đang tải MeizuLibrary v2.2..."},
        {0.35, 64,  "Kiểm tra executor..."},
        {0.30, 86,  "Kết nối server..."},
        {0.25, 100, "Hoàn tất! Chào mừng!"},
    }

    for _, st in ipairs(steps) do
        Status.Text = st[3]
        Tween(BarFill, st[1], {Size = UDim2.new(st[2] / 100, 0, 1, 0)}, Enum.EasingStyle.Quad)
        -- percent chạy mượt theo
        task.spawn(function()
            local start = tonumber(Percent.Text:match("%d+")) or 0
            local t0 = tick()
            while tick() - t0 < st[1] do
                local cur = start + (st[2] - start) * math.min((tick() - t0) / st[1], 1)
                Percent.Text = tostring(math.floor(cur)) .. "%"
                task.wait()
            end
            Percent.Text = tostring(st[2]) .. "%"
        end)
        task.wait(st[1])
    end

    task.wait(0.4)

    --// Fade out intro
    Tween(CardScale, 0.3, {Scale = 0.9}, Enum.EasingStyle.Quint)
    Tween(Card, 0.28, {GroupTransparency = 1})
    Tween(Overlay, 0.3, {BackgroundTransparency = 1})
    task.wait(0.32)
    introAlive = false
    FPSConn:Disconnect()
    IntroGui:Destroy()
end)

--// ============================================================
--//          NETWORK WIDGET (giống panel trong testtintro)
--// ============================================================
local function CreateNetworkWidget()
    local Gui = CreateGui("MeizuNetwork")

    local Root = New("Frame", {
        Position = UDim2.new(0, 14, 0, 140),
        Size = UDim2.fromOffset(180, 96),
        BackgroundColor3 = C.Sidebar,
        BorderSizePixel = 0, Active = true, ZIndex = 100,
        Parent = Gui,
    })
    Corner(Root, RADIUS)
    New("UIStroke", {Color = C.Stroke, Thickness = 1, Transparency = 0.4, Parent = Root})

    -- Header (kéo được + collapse)
    local Header = New("TextButton", {
        Text = "", AutoButtonColor = false,
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1, ZIndex = 101, Parent = Root,
    })
    New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -40, 1, 0),
        Font = Enum.Font.GothamBold, TextSize = 12,
        Text = "Network", TextColor3 = C.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 101, Parent = Header,
    })
    local ColBtn = New("TextButton", {
        Text = "−", AutoButtonColor = false,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.fromOffset(20, 20),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, TextSize = 14,
        TextColor3 = C.SubText, ZIndex = 101, Parent = Header,
    })

    -- Body
    local Body = New("Frame", {
        Position = UDim2.new(0, 0, 0, 26),
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundTransparency = 1, ZIndex = 101, Parent = Root,
    })
    local Ava = New("ImageLabel", {
        Position = UDim2.new(0, 10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.fromOffset(38, 38),
        BackgroundColor3 = C.Element,
        BorderSizePixel = 0, ZIndex = 102, Parent = Body,
    })
    Corner(Ava, 19)
    pcall(function()
        Ava.Image = Players:GetUserThumbnailAsync(
            LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    end)
    local FPSLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 58, 0, 12),
        Size = UDim2.new(1, -66, 0, 18),
        Font = Enum.Font.GothamBold, TextSize = 13,
        Text = "-- FPS", TextColor3 = C.Accent,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 102, Parent = Body,
    })
    local PingLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 58, 0, 34),
        Size = UDim2.new(1, -66, 0, 18),
        Font = Enum.Font.Gotham, TextSize = 12,
        Text = "-- MS Ping", TextColor3 = C.SubText,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 102, Parent = Body,
    })

    -- Kéo widget bằng header
    do
        local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
        Header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = Root.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        Header.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input == dragInput then
                local delta = input.Position - dragStart
                Root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    -- Collapse
    local collapsed = false
    ColBtn.Activated:Connect(function()
        collapsed = not collapsed
        ColBtn.Text = collapsed and "+" or "−"
        Tween(Root, 0.3, {Size = UDim2.fromOffset(180, collapsed and 26 or 96)}, Enum.EasingStyle.Quint)
        Tween(Body, 0.3, {Size = UDim2.new(1, 0, 0, collapsed and 0 or 70)}, Enum.EasingStyle.Quint)
    end)

    -- FPS/Ping updater
    task.spawn(function()
        while Root.Parent do
            task.wait(1)
            FPSLabel.Text = frameCount .. " FPS"
            frameCount = 0
            PingLabel.Text = GetPing() .. " MS Ping"
        end
    end)

    return Root
end

--// ============================================================
--//              ĐỢI INTRO XONG → MỞ MEIZU UI
--// ============================================================
repeat task.wait(0.1) until not introAlive

local Window = Library:CreateWindow({
    Title = "Meizu Hub",
    SubTitle = "v2.2 • by Nttp1721",
    Theme = "Dark",
    Accent = C.Accent,
    ToggleKeybind = Enum.KeyCode.RightControl,
    ToggleUIButton = true,
    -- ToggleImage mặc định đã là meizuxp.png trong library
    Size = UDim2.fromOffset(600, 430),
})

CreateNetworkWidget()

Library:Notify({
    Title = "Meizu Hub",
    Content = "Chào <b>" .. LocalPlayer.DisplayName .. "</b>! Intro đã chạy xong, UI sẵn sàng.",
    Duration = 5,
})

--// ================= TAB: MAIN =================
local Main = Window:CreateTab("Main", "rbxassetid://10723407389")

local Combat = Main:CreateSection("Combat")
Combat:CreateToggle({
    Title = "Kill Aura",
    Description = "Tự động tấn công kẻ địch xung quanh",
    Default = false,
    Flag = "KillAura",
    Callback = function(v) print("[Hub] Kill Aura =", v) end,
})
Combat:CreateSlider({
    Title = "Kill Aura Range",
    Min = 10, Max = 500, Default = 120, Rounding = 0,
    Flag = "AuraRange",
    Callback = function(v) print("[Hub] Range =", v) end,
})
Combat:CreateDropdown({
    Title = "Target Mode",
    Options = {"Closest", "Lowest HP", "Random", "All"},
    Default = "Closest",
    Flag = "TargetMode",
    Callback = function(v) print("[Hub] Target =", v) end,
})
Combat:CreateMultiDropdown({
    Title = "Auto Collect",
    Options = {"Coins", "Gems", "Chests", "Orbs", "Keys"},
    Default = {"Coins", "Gems"},
    Flag = "AutoCollect",
    Callback = function(list) print("[Hub] Collect:", table.concat(list, ", ")) end,
})

local Misc = Main:CreateSection("Misc")
Misc:CreateButton({
    Title = "Replay Intro",
    Description = "Chạy lại màn hình intro",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/testtintro.lua"))()
    end,
})
Misc:CreateButton({
    Title = "Open Dialog",
    Callback = function()
        Window:Dialog({
            Title = "Teleport",
            Content = "Bạn có muốn teleport đến Boss không?",
            Buttons = {
                {Title = "Cancel"},
                {Title = "Teleport", Variant = "Primary", Callback = function()
                    Library:Notify({Title = "Teleported!", Content = "Đã dịch chuyển thành công!"})
                end},
            },
        })
    end,
})
Misc:CreateKeybind({
    Title = "Toggle Kill Aura",
    Default = Enum.KeyCode.E,
    Flag = "AuraKey",
    Callback = function()
        Library.Flags.KillAura = not Library.Flags.KillAura
        print("[Hub] Kill Aura toggled:", Library.Flags.KillAura)
    end,
})

--// ================= TAB: PLAYER =================
local Player = Window:CreateTab("Player")
local Movement = Player:CreateSection("Movement")
Movement:CreateToggle({Title = "Enable Character Mods", Flag = "CharMods", Default = false})
Movement:CreateSlider({
    Title = "WalkSpeed", Min = 16, Max = 300, Default = 16, Flag = "WalkSpeed",
    Callback = function(v)
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and Library.Flags.CharMods then hum.WalkSpeed = v end
    end,
})
Movement:CreateSlider({
    Title = "JumpPower", Min = 50, Max = 300, Default = 50, Flag = "JumpPower",
    Callback = function(v)
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and Library.Flags.CharMods then
            hum.UseJumpPower = true
            hum.JumpPower = v
        end
    end,
})

--// ================= TAB: VISUALS =================
local Visuals = Window:CreateTab("Visuals")
Visuals:CreateColorPicker({
    Title = "ESP Color",
    Default = C.Accent,
    Flag = "ESPColor",
    Callback = function(c) print("[Visuals] Color:", c) end,
})
Visuals:CreateParagraph({
    Title = "Meizu Hub",
    Content = "Bản test intro + MeizuLibrary v2.2.\nBo góc kiểu testtintro, logo meizuxp.png, FPS/Ping realtime.",
})

print("✅ Meizu Hub (testtintro + MeizuLibrary) loaded!")
