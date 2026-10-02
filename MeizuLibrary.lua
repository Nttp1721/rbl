--[[
    ╔══════════════════════════════════════════════╗
       MEIZU UI LIBRARY — v2.1
       Hiện đại · Mượt mà · Dễ dùng (chuẩn Fluent)
    ╚══════════════════════════════════════════════╝
    Fix v2.1: cửa sổ không mở lúc load (state minimized sai),
    fallback CanvasGroup, tự unlock animation kẹt.
    Orb thu gọn 50x50 (UDim2.new(0,50,0,50)) góc trái dưới.
]]

local Meizu = {}
Meizu.Version      = "2.1"
Meizu.Flags        = {}
Meizu.CurrentTheme = "Meizu"

-- // Services
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local TextService      = game:GetService("TextService")
local Workspace        = game:GetService("Workspace")
local LocalPlayer      = game:GetService("Players").LocalPlayer

-- // Themes ------------------------------------------------------
local Themes = {
    Meizu    = {Background=Color3.fromRGB(11,12,17),  Sidebar=Color3.fromRGB(15,17,23),  Card=Color3.fromRGB(20,23,31),  Element=Color3.fromRGB(27,31,41),  Stroke=Color3.fromRGB(255,255,255), Text=Color3.fromRGB(235,238,245), Secondary=Color3.fromRGB(140,146,165), Accent=Color3.fromRGB(124,92,255),  Accent2=Color3.fromRGB(62,199,255)},
    Midnight = {Background=Color3.fromRGB(8,12,20),   Sidebar=Color3.fromRGB(11,16,26),  Card=Color3.fromRGB(15,22,35),  Element=Color3.fromRGB(20,29,46),  Stroke=Color3.fromRGB(255,255,255), Text=Color3.fromRGB(224,236,248), Secondary=Color3.fromRGB(120,140,168), Accent=Color3.fromRGB(41,199,255),  Accent2=Color3.fromRGB(99,102,241)},
    Rose     = {Background=Color3.fromRGB(15,11,14),  Sidebar=Color3.fromRGB(19,14,18),  Card=Color3.fromRGB(25,18,24),  Element=Color3.fromRGB(33,24,32),  Stroke=Color3.fromRGB(255,255,255), Text=Color3.fromRGB(245,235,240), Secondary=Color3.fromRGB(165,140,150), Accent=Color3.fromRGB(255,92,128),  Accent2=Color3.fromRGB(255,159,122)},
    Amethyst = {Background=Color3.fromRGB(13,11,18),  Sidebar=Color3.fromRGB(17,14,24),  Card=Color3.fromRGB(23,19,33),  Element=Color3.fromRGB(31,25,44),  Stroke=Color3.fromRGB(255,255,255), Text=Color3.fromRGB(240,236,248), Secondary=Color3.fromRGB(150,145,172), Accent=Color3.fromRGB(168,85,247),  Accent2=Color3.fromRGB(99,102,241)},
    Light    = {Background=Color3.fromRGB(236,239,246),Sidebar=Color3.fromRGB(243,245,250),Card=Color3.fromRGB(255,255,255),Element=Color3.fromRGB(232,236,244),Stroke=Color3.fromRGB(25,28,36),   Text=Color3.fromRGB(22,25,33),  Secondary=Color3.fromRGB(105,112,130), Accent=Color3.fromRGB(91,76,224),  Accent2=Color3.fromRGB(42,166,255)},
}
Meizu.Themes = Themes

-- // Utilities ---------------------------------------------------
local ThemeRegistry = {}
local gradients     = {}
local Connections   = {}
local Root, NotifyContainer

local function Create(className, props, children)
    local inst = Instance.new(className)
    if props then
        for k, v in pairs(props) do
            if k ~= "Parent" then inst[k] = v end
        end
    end
    if children then
        for _, c in ipairs(children) do c.Parent = inst end
    end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Tween(obj, time, props, style, direction, delayTime)
    local info = TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out, 0, false, delayTime or 0)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

-- CanvasGroup nhưng tự fallback về Frame nếu executor không hỗ trợ
local function NewGroup(props)
    local g
    local ok = pcall(function() g = Instance.new("CanvasGroup") end)
    if not ok or not g then g = Instance.new("Frame") end
    if props then
        for k, v in pairs(props) do
            if k ~= "Parent" and k ~= "GroupTransparency" then
                pcall(function() g[k] = v end)
            end
        end
        if props.GroupTransparency then pcall(function() g.GroupTransparency = props.GroupTransparency end) end
    end
    if props and props.Parent then g.Parent = props.Parent end
    return g
end

local function FadeGroup(obj, time, target, style, direction)
    pcall(function()
        TweenService:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quint,
            direction or Enum.EasingDirection.Out), {GroupTransparency = target}):Play()
    end)
end

local function Connect(signal, fn)
    local c = signal:Connect(fn)
    table.insert(Connections, c)
    return c
end

local function RegisterTheme(obj, prop, key)
    local th = Themes[Meizu.CurrentTheme]
    if th and th[key] then obj[prop] = th[key] end
    ThemeRegistry[key] = ThemeRegistry[key] or {}
    table.insert(ThemeRegistry[key], {obj = obj, prop = prop})
end

local function MakeGradient(parent, rotation)
    local g = Instance.new("UIGradient")
    local th = Themes[Meizu.CurrentTheme]
    g.Color = ColorSequence.new(th.Accent, th.Accent2)
    g.Rotation = rotation or 0
    g.Parent = parent
    table.insert(gradients, g)
    return g
end

local function MeasureText(text, size, width)
    local ok, v = pcall(function()
        return TextService:GetTextSize(tostring(text), size, Enum.Font.Gotham, Vector2.new(width, 10000))
    end)
    return ok and math.max(v.Y, size) or size
end

local function Ripple(parent, absPos)
    if not parent or not parent.Parent then return end
    local size = parent.AbsoluteSize
    local pos
    if absPos then
        local rel = Vector2.new(
            math.clamp(absPos.X - parent.AbsolutePosition.X, 0, size.X),
            math.clamp(absPos.Y - parent.AbsolutePosition.Y, 0, size.Y))
        pos = UDim2.fromOffset(rel.X, rel.Y)
    else
        pos = UDim2.fromScale(0.5, 0.5)
    end
    local ripple = Create("Frame", {
        Parent = parent, AnchorPoint = Vector2.new(0.5, 0.5), Position = pos,
        BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.75,
        Size = UDim2.fromOffset(0, 0), ZIndex = 20, BorderSizePixel = 0,
    })
    Create("UICorner", {Parent = ripple, CornerRadius = UDim.new(1, 0)})
    local dist = math.max(size.X, size.Y) * 2
    Tween(ripple, 0.45, {Size = UDim2.fromOffset(dist, dist), BackgroundTransparency = 1}, Enum.EasingStyle.Quint)
    task.delay(0.45, function() if ripple then ripple:Destroy() end end)
end

local function OnClick(button, fn)
    local clickPos
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            clickPos = Vector2.new(input.Position.X, input.Position.Y)
        end
    end)
    button.Activated:Connect(function()
        Ripple(button, clickPos)
        fn()
    end)
end

local function OnHover(obj, inProps, outProps, time)
    obj.MouseEnter:Connect(function() Tween(obj, time or 0.16, inProps) end)
    obj.MouseLeave:Connect(function() Tween(obj, time or 0.16, outProps) end)
end

local function TrackMouse(onUpdate, onEnd)
    local moveConn, endConn
    moveConn = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            onUpdate(Vector2.new(input.Position.X, input.Position.Y))
        end
    end)
    endConn = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            moveConn:Disconnect()
            endConn:Disconnect()
            if onEnd then onEnd() end
        end
    end)
end

local function GetViewport()
    local cam = Workspace.CurrentCamera
    return cam and cam.ViewportSize or Vector2.new(1920, 1080)
end

local function EnsureRoot()
    if Root and Root.Parent then return Root end
    -- hủy gui cũ nếu load lại
    pcall(function()
        local candidates = {}
        local okH, hidden = pcall(function() return gethui and gethui() end)
        if okH and hidden then table.insert(candidates, hidden) end
        table.insert(candidates, game:GetService("CoreGui"))
        if LocalPlayer then
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then table.insert(candidates, pg) end
        end
        for _, parent in ipairs(candidates) do
            for _, v in ipairs(parent:GetChildren()) do
                if v.Name == "MEIZU_GUI" then v:Destroy() end
            end
        end
    end)

    local gui = Instance.new("ScreenGui")
    gui.Name = "MEIZU_GUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- thử lần lượt: gethui() -> CoreGui -> PlayerGui (không bao giờ crash)
    local placed = false
    local okH, hidden = pcall(function() return gethui and gethui() end)
    if okH and hidden then pcall(function() gui.Parent = hidden end) end
    if not gui.Parent then
        pcall(function() gui.Parent = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui") end)
    end
    if not gui.Parent and LocalPlayer then
        pcall(function()
            local pg = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 3)
            if pg then gui.Parent = pg end
        end)
    end

    Root = gui
    Connect(Root.Destroying, function()
        for _, c in ipairs(Connections) do pcall(function() c:Disconnect() end) end
        table.clear(Connections)
    end)
    return Root
end

-- Icon vẽ bằng frame (không phụ thuộc font)
local function MakeIcon(kind, color)
    local holder = Create("Frame", {BackgroundTransparency = 1, Size = UDim2.fromOffset(16, 16), ZIndex = 3})
    local function line(w, h, rot, px, py)
        Create("Frame", {
            Parent = holder, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = color,
            BorderSizePixel = 0, Size = UDim2.fromOffset(w, h), Rotation = rot,
            Position = UDim2.new(0.5, px, 0.5, py), ZIndex = 3,
        })
    end
    if kind == "Check" then
        line(6, 2, 45, -3, 2.5)
        line(10, 2, -45, 1.5, -0.5)
    elseif kind == "Error" then
        line(10, 2, 45, 0, 0)
        line(10, 2, -45, 0, 0)
    elseif kind == "Warning" then
        line(2.5, 7, 0, 0, -2)
        line(3, 3, 0, 0, 4.5)
    else -- Info
        line(3, 3, 0, 0, -4.5)
        line(2.5, 6, 0, 0, 2)
    end
    return holder
end

-- // Theme switching --------------------------------------------
function Meizu.SetTheme(name)
    local theme = Themes[name]
    if not theme then return false end
    Meizu.CurrentTheme = name
    for key, list in pairs(ThemeRegistry) do
        local color = theme[key]
        if color then
            for _, entry in ipairs(list) do
                if entry.obj and entry.obj.Parent then
                    pcall(function() Tween(entry.obj, 0.35, {[entry.prop] = color}) end)
                end
            end
        end
    end
    for _, g in ipairs(gradients) do
        if g.Parent then g.Color = ColorSequence.new(theme.Accent, theme.Accent2) end
    end
    return true
end

function Meizu.ThemeList()
    local out = {}
    for k in pairs(Themes) do table.insert(out, k) end
    table.sort(out)
    return out
end

-- // Notifications ----------------------------------------------
local NotifyColors = {
    Success = Color3.fromRGB(43, 213, 118), Error = Color3.fromRGB(255, 92, 92),
    Warning = Color3.fromRGB(255, 176, 32), Info = Color3.fromRGB(124, 92, 255),
}
local NotifyIcons = {Success = "Check", Error = "Error", Warning = "Warning", Info = "Info"}

local function EnsureNotifyContainer()
    if NotifyContainer and NotifyContainer.Parent then return NotifyContainer end
    EnsureRoot()
    NotifyContainer = Create("Frame", {
        Parent = Root, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 14),
        Size = UDim2.new(0, 300, 1, -28), BackgroundTransparency = 1, ZIndex = 200,
    })
    Create("UIListLayout", {Parent = NotifyContainer, SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8), HorizontalAlignment = Enum.HorizontalAlignment.Right})
    return NotifyContainer
end

function Meizu.Notify(info)
    if type(info) == "string" then info = {Title = info} end
    info = info or {}
    local container = EnsureNotifyContainer()
    local theme = Themes[Meizu.CurrentTheme]
    local nType = info.Type or "Info"
    local nColor = NotifyColors[nType] or NotifyColors.Info
    local duration = info.Duration or 4

    local toasts = {}
    for _, v in ipairs(container:GetChildren()) do
        if v:IsA("Frame") then table.insert(toasts, v) end
    end
    if #toasts >= 5 then toasts[1]:Destroy() end

    local wrap = Create("Frame", {Parent = container, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 201})
    local toast = NewGroup({
        Parent = wrap, BackgroundColor3 = theme.Card, BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        Position = UDim2.new(1, 40, 0, 0), GroupTransparency = 1, ZIndex = 202,
    })
    Create("UICorner", {Parent = toast, CornerRadius = UDim.new(0, 10)})
    local stroke = Create("UIStroke", {Parent = toast, Thickness = 1, Transparency = 0.86})
    RegisterTheme(toast, "BackgroundColor3", "Card")
    RegisterTheme(stroke, "Color", "Stroke")
    Create("UIPadding", {Parent = toast, PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)})
    Create("UIListLayout", {Parent = toast, FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 10), VerticalAlignment = Enum.VerticalAlignment.Center})

    local iconBg = Create("Frame", {Parent = toast, BackgroundColor3 = nColor, BackgroundTransparency = 0.85,
        Size = UDim2.fromOffset(28, 28), ZIndex = 203, BorderSizePixel = 0})
    Create("UICorner", {Parent = iconBg, CornerRadius = UDim.new(1, 0)})
    local icon = MakeIcon(NotifyIcons[nType] or "Info", nColor)
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.Position = UDim2.fromScale(0.5, 0.5)
    icon.Parent = iconBg

    local textBlock = Create("Frame", {Parent = toast, BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 203})
    Create("UIListLayout", {Parent = textBlock, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
    local title = Create("TextLabel", {Parent = textBlock, BackgroundTransparency = 1, Font = Enum.Font.GothamSemibold,
        Text = info.Title or "Thông báo", TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = theme.Text, Size = UDim2.new(1, 0, 0, 16), ZIndex = 203})
    RegisterTheme(title, "TextColor3", "Text")
    if info.Content then
        local content = Create("TextLabel", {Parent = textBlock, BackgroundTransparency = 1, Font = Enum.Font.Gotham,
            Text = tostring(info.Content), TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = theme.Secondary, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 203})
        RegisterTheme(content, "TextColor3", "Secondary")
    end

    local progress = Create("Frame", {Parent = toast, BackgroundColor3 = nColor, BorderSizePixel = 0,
        Size = UDim2.new(1, -24, 0, 3), Position = UDim2.new(0, 12, 1, -8), ZIndex = 204})
    Create("UICorner", {Parent = progress, CornerRadius = UDim.new(1, 0)})

    local dismissed = false
    local function dismiss()
        if dismissed then return end
        dismissed = true
        Tween(toast, 0.3, {Position = UDim2.new(1, 40, 0, 0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        FadeGroup(toast, 0.3, 1, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        task.delay(0.32, function() wrap:Destroy() end)
    end
    toast.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dismiss()
        end
    end)
    Tween(toast, 0.45, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Quint)
    FadeGroup(toast, 0.45, 0)
    Tween(progress, duration, {Size = UDim2.new(0, 0, 0, 3)}, Enum.EasingStyle.Linear)
    task.delay(duration, dismiss)
end

-- // Prompt (hộp thoại xác nhận) ---------------------------------
function Meizu.Prompt(info)
    info = info or {}
    EnsureRoot()
    local theme = Themes[Meizu.CurrentTheme]
    local overlay = Create("Frame", {Parent = Root, BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 300})
    local card = NewGroup({Parent = overlay, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 16), BackgroundColor3 = theme.Card, BorderSizePixel = 0,
        Size = UDim2.new(0, 320, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        GroupTransparency = 1, ZIndex = 301})
    Create("UICorner", {Parent = card, CornerRadius = UDim.new(0, 12)})
    local cstroke = Create("UIStroke", {Parent = card, Thickness = 1, Transparency = 0.88})
    RegisterTheme(card, "BackgroundColor3", "Card")
    RegisterTheme(cstroke, "Color", "Stroke")
    Create("UIPadding", {Parent = card, PaddingTop = UDim.new(0, 16), PaddingBottom = UDim.new(0, 16),
        PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16)})
    Create("UIListLayout", {Parent = card, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})

    local title = Create("TextLabel", {Parent = card, BackgroundTransparency = 1, Font = Enum.Font.GothamSemibold,
        Text = info.Title or "Xác nhận", TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = theme.Text, Size = UDim2.new(1, 0, 0, 18), ZIndex = 302})
    RegisterTheme(title, "TextColor3", "Text")
    if info.Content then
        local content = Create("TextLabel", {Parent = card, BackgroundTransparency = 1, Font = Enum.Font.Gotham,
            Text = tostring(info.Content), TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = theme.Secondary, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 302})
        RegisterTheme(content, "TextColor3", "Secondary")
    end

    local btnRow = Create("Frame", {Parent = card, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34), ZIndex = 302})
    Create("UIListLayout", {Parent = btnRow, FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8), HorizontalAlignment = Enum.HorizontalAlignment.Right})

    local closed = false
    local function close(ok)
        if closed then return end
        closed = true
        Tween(overlay, 0.25, {BackgroundTransparency = 1})
        Tween(card, 0.25, {Position = UDim2.new(0.5, 0, 0.5, 10)}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        FadeGroup(card, 0.25, 1, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        task.delay(0.28, function()
            overlay:Destroy()
            if info.Callback then info.Callback(ok == true) end
        end)
    end

    local cancel = Create("TextButton", {Parent = btnRow, Size = UDim2.new(0, 90, 1, 0),
        BackgroundColor3 = theme.Element, Text = info.CancelText or "Hủy", Font = Enum.Font.GothamMedium,
        TextSize = 12, TextColor3 = theme.Text, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 303})
    Create("UICorner", {Parent = cancel, CornerRadius = UDim.new(0, 8)})
    RegisterTheme(cancel, "BackgroundColor3", "Element")
    RegisterTheme(cancel, "TextColor3", "Text")

    local confirm = Create("TextButton", {Parent = btnRow, Size = UDim2.new(0, 110, 1, 0),
        BackgroundColor3 = Color3.new(1, 1, 1), Text = info.ConfirmText or "Xác nhận", Font = Enum.Font.GothamSemibold,
        TextSize = 12, TextColor3 = theme.Background, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 303})
    Create("UICorner", {Parent = confirm, CornerRadius = UDim.new(0, 8)})
    MakeGradient(confirm)
    RegisterTheme(confirm, "TextColor3", "Background")

    OnClick(cancel, function() close(false) end)
    OnClick(confirm, function() close(true) end)
    overlay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            close(false)
        end
    end)

    Tween(overlay, 0.25, {BackgroundTransparency = 0.45})
    Tween(card, 0.35, {Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 340, 0, 0)}, Enum.EasingStyle.Back)
    FadeGroup(card, 0.35, 0)
end

-- // Splash ------------------------------------------------------
local function ShowSplash()
    EnsureRoot()
    local splash = NewGroup({Parent = Root, Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.15,
        GroupTransparency = 1, ZIndex = 400, BorderSizePixel = 0})
    local title = Create("TextLabel", {Parent = splash, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.44), BackgroundTransparency = 1, Font = Enum.Font.GothamBlack,
        Text = "MEIZU", TextSize = 46, TextColor3 = Color3.new(1, 1, 1), Size = UDim2.fromOffset(500, 52)})
    MakeGradient(title)
    Create("TextLabel", {Parent = splash, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.52), BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = "UI LIBRARY  ·  v" .. Meizu.Version, TextSize = 12,
        TextColor3 = Color3.fromRGB(150, 155, 170), Size = UDim2.fromOffset(400, 14)})
    local line = Create("Frame", {Parent = splash, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.585), BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.fromOffset(0, 2), BorderSizePixel = 0})
    MakeGradient(line)
    FadeGroup(splash, 0.4, 0)
    Tween(line, 0.7, {Size = UDim2.fromOffset(240, 2)})
    task.delay(1.25, function()
        if not splash.Parent then return end
        FadeGroup(splash, 0.4, 1)
        task.delay(0.42, function() splash:Destroy() end)
    end)
end

-- // Element builders --------------------------------------------
local ElementBuilders = {}
local function RegisterFlag(info, element)
    local key = (info and (info.ConfigKey or info.Flag))
    if key then Meizu.Flags[key] = element end
end

local function BuildCard(tab, info, controlHeight, rightSlot)
    info = info or {}
    local theme = Themes[Meizu.CurrentTheme]
    local innerW = tab._innerWidth or 480
    local descH = info.Description and MeasureText(info.Description, 12, innerW) or 0
    local h = 12
    if info.Title or rightSlot then h += 26 end
    if info.Description then h += 6 + descH end
    if controlHeight and controlHeight > 0 then h += 8 + controlHeight end
    h += 12

    tab._order = (tab._order or 0) + 1
    local card = Create("Frame", {Parent = tab.list, Size = UDim2.new(1, 0, 0, h),
        BackgroundColor3 = theme.Card, BorderSizePixel = 0, LayoutOrder = tab._order, ZIndex = 101})
    card:SetAttribute("CardHeight", h)
    Create("UICorner", {Parent = card, CornerRadius = UDim.new(0, 10)})
    local stroke = Create("UIStroke", {Parent = card, Thickness = 1, Transparency = 0.92})
    RegisterTheme(card, "BackgroundColor3", "Card")
    RegisterTheme(stroke, "Color", "Stroke")
    Create("UIPadding", {Parent = card, PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)})
    Create("UIListLayout", {Parent = card, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder})

    local titleRow
    if info.Title or rightSlot then
        titleRow = Create("Frame", {Parent = card, Size = UDim2.new(1, 0, 0, 26),
            BackgroundTransparency = 1, ZIndex = 102})
        if info.Title then
            local titleLabel = Create("TextLabel", {Parent = titleRow, Size = UDim2.new(1, rightSlot and -66 or 0, 1, 0),
                BackgroundTransparency = 1, Font = Enum.Font.GothamSemibold, Text = info.Title, TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
                TextColor3 = theme.Text, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 102})
            RegisterTheme(titleLabel, "TextColor3", "Text")
        end
    end
    if info.Description then
        local d = Create("TextLabel", {Parent = card, Size = UDim2.new(1, 0, 0, descH), BackgroundTransparency = 1,
            Font = Enum.Font.Gotham, Text = info.Description, TextSize = 12, TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
            TextColor3 = theme.Secondary, ZIndex = 102})
        RegisterTheme(d, "TextColor3", "Secondary")
    end

    return {
        frame = card, titleRow = titleRow, h = h, innerW = innerW,
        setHeight = function(newH)
            card:SetAttribute("CardHeight", newH)
            Tween(card, 0.26, {Size = UDim2.new(1, 0, 0, newH)}, Enum.EasingStyle.Quint)
        end,
    }
end

-- Button ---------------------------------------------------------
ElementBuilders.AddButton = function(tab, info)
    info = info or {}
    local theme = Themes[Meizu.CurrentTheme]
    local parts = BuildCard(tab, {Description = info.Description}, 34)
    local button = Create("TextButton", {Parent = parts.frame, Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = theme.Element, Text = info.Title or "Button", Font = Enum.Font.GothamMedium,
        TextSize = 13, TextColor3 = theme.Text, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 102})
    Create("UICorner", {Parent = button, CornerRadius = UDim.new(0, 8)})

    if info.Primary then
        MakeGradient(button)
        RegisterTheme(button, "TextColor3", "Background")
        local stroke = Create("UIStroke", {Parent = button, Thickness = 1, Transparency = 1})
        RegisterTheme(stroke, "Color", "Accent")
        OnHover(button, {Transparency = 0.35}, {Transparency = 1}, 0.2)
    else
        RegisterTheme(button, "BackgroundColor3", "Element")
        RegisterTheme(button, "TextColor3", "Text")
        OnHover(button,
            {BackgroundColor3 = Themes[Meizu.CurrentTheme].Accent, BackgroundTransparency = 0.82},
            {BackgroundColor3 = Themes[Meizu.CurrentTheme].Element, BackgroundTransparency = 0})
    end

    OnClick(button, function()
        if info.Callback then info.Callback() end
    end)
    return {Set = function(_, title) button.Text = title end, Button = button}
end

-- Toggle ---------------------------------------------------------
ElementBuilders.AddToggle = function(tab, info)
    info = info or {}
    local theme = Themes[Meizu.CurrentTheme]
    local parts = BuildCard(tab, info, 0, true)
    local card = parts.frame

    local switch = Create("Frame", {Parent = parts.titleRow, AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(46, 24),
        BackgroundTransparency = 1, ZIndex = 102})
    local off = Create("Frame", {Parent = switch, Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = theme.Element, BorderSizePixel = 0, ZIndex = 102})
    Create("UICorner", {Parent = off, CornerRadius = UDim.new(1, 0)})
    RegisterTheme(off, "BackgroundColor3", "Element")
    local on = Create("Frame", {Parent = switch, Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 103})
    MakeGradient(on)
    Create("UICorner", {Parent = on, CornerRadius = UDim.new(1, 0)})
    local knob = Create("Frame", {Parent = switch, Position = UDim2.fromOffset(4, 3),
        Size = UDim2.fromOffset(18, 18), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 104})
    Create("UICorner", {Parent = knob, CornerRadius = UDim.new(1, 0)})
    local knobStroke = Create("UIStroke", {Parent = knob, Thickness = 1, Transparency = 0.55})
    RegisterTheme(knobStroke, "Color", "Stroke")

    local state = info.Default == true
    local element = {}

    local function render(animated)
        local knobX = state and 24 or 4
        if animated then
            knob.Size = UDim2.fromOffset(13, 13)
            Tween(on, 0.25, {BackgroundTransparency = state and 0 or 1})
            Tween(off, 0.25, {BackgroundTransparency = state and 1 or 0})
            Tween(knob, 0.3, {Position = UDim2.fromOffset(knobX, 3), Size = UDim2.fromOffset(18, 18)}, Enum.EasingStyle.Back)
        else
            on.BackgroundTransparency = state and 0 or 1
            off.BackgroundTransparency = state and 1 or 0
            knob.Position = UDim2.fromOffset(knobX, 3)
            knob.Size = UDim2.fromOffset(18, 18)
        end
    end

    function element:Set(value, noCallback)
        state = value == true
        render(true)
        if not noCallback and info.Callback then info.Callback(state) end
    end
    function element:Get() return state end

    local hit = Create("TextButton", {Parent = card, Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 105})
    OnClick(hit, function() element:Set(not state) end)

    render(false)
    RegisterFlag(info, element)
    return element
end

-- Slider ---------------------------------------------------------
ElementBuilders.AddSlider = function(tab, info)
    info = info or {}
    local theme = Themes[Meizu.CurrentTheme]
    local min, max = info.Min or 0, info.Max or 100
    local decimals = info.Decimals or info.Rounding or 0
    local suffix = info.Suffix or ""
    local parts = BuildCard(tab, info, 22, true)

    local valueBox = Create("TextBox", {Parent = parts.titleRow, AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(64, 24), BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = theme.Secondary,
        TextXAlignment = Enum.TextXAlignment.Right, ClearTextOnFocus = false, ZIndex = 103})
    RegisterTheme(valueBox, "TextColor3", "Secondary")

    local track = Create("Frame", {Parent = parts.frame, AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0, 6),
        BackgroundColor3 = theme.Element, BorderSizePixel = 0, ZIndex = 102})
    Create("UICorner", {Parent = track, CornerRadius = UDim.new(1, 0)})
    RegisterTheme(track, "BackgroundColor3", "Element")
    local fill = Create("Frame", {Parent = track, Size = UDim2.fromScale(0, 1),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 103})
    MakeGradient(fill)
    Create("UICorner", {Parent = fill, CornerRadius = UDim.new(1, 0)})
    local thumb = Create("Frame", {Parent = track, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 104})
    Create("UICorner", {Parent = thumb, CornerRadius = UDim.new(1, 0)})
    local thumbStroke = Create("UIStroke", {Parent = thumb, Thickness = 1, Transparency = 0.6})
    RegisterTheme(thumbStroke, "Color", "Stroke")

    local value = tonumber(info.Default) or min
    local element = {}

    local function fmt(v)
        local s = (decimals <= 0) and tostring(math.floor(v + 0.5))
            or string.format("%." .. decimals .. "f", v)
        return s .. suffix
    end
    local function render(animated)
        local range = (max - min)
        local rel = range > 0 and math.clamp((value - min) / range, 0, 1) or 0
        if animated then
            Tween(fill, 0.12, {Size = UDim2.new(rel, 0, 1, 0)})
            Tween(thumb, 0.12, {Position = UDim2.new(rel, 0, 0.5, 0)})
        else
            fill.Size = UDim2.new(rel, 0, 1, 0)
            thumb.Position = UDim2.new(rel, 0, 0.5, 0)
        end
        valueBox.Text = fmt(value)
    end
    local function setValue(v, noCallback, animated)
        v = tonumber(v) or value
        v = math.clamp(v, min, max)
        if decimals <= 0 then
            v = math.floor(v + 0.5)
        else
            local step = 10 ^ (-decimals)
            v = math.floor(v / step + 0.5) * step
        end
        value = v
        render(animated)
        if not noCallback and info.Callback then info.Callback(value) end
    end

    local function beginDrag()
        Tween(thumb, 0.15, {Size = UDim2.fromOffset(18, 18)}, Enum.EasingStyle.Back)
        TrackMouse(function(mouse)
            if not track.Parent then return end
            local rel = math.clamp((mouse.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            setValue(min + rel * (max - min))
        end, function()
            if thumb.Parent then
                Tween(thumb, 0.25, {Size = UDim2.fromOffset(14, 14)})
            end
        end)
    end
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            beginDrag()
        end
    end)
    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            beginDrag()
        end
    end)
    valueBox.FocusLost:Connect(function()
        setValue(tonumber(valueBox.Text) or value)
    end)

    function element:Set(v, noCallback) setValue(v, noCallback, true) end
    function element:Get() return value end

    render(false)
    RegisterFlag(info, element)
    return element
end

-- Dropdown -------------------------------------------------------
ElementBuilders.AddDropdown = function(tab, info)
    info = info or {}
    local theme = Themes[Meizu.CurrentTheme]
    local values = info.Values or {}
    local multi = info.Multi == true
    local allowSearch = info.AllowSearch
    if allowSearch == nil then allowSearch = #values > 10 end
    local maxVisible = math.min(math.max(#values, 1), 6)
    local parts = BuildCard(tab, info, 34)
    local baseH = parts.h

    local state
    if multi then
        state = {}
        for _, v in ipairs(info.Default or {}) do state[v] = true end
    else
        state = (info.Default and table.find(values, info.Default)) and info.Default or values[1]
    end

    local header = Create("TextButton", {Parent = parts.frame, Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = theme.Element, Text = "", AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 102})
    Create("UICorner", {Parent = header, CornerRadius = UDim.new(0, 8)})
    RegisterTheme(header, "BackgroundColor3", "Element")
    local valueLabel = Create("TextLabel", {Parent = header, Position = UDim2.fromOffset(10, 0),
        Size = UDim2.new(1, -34, 1, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
        TextColor3 = theme.Text, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 103})
    RegisterTheme(valueLabel, "TextColor3", "Text")
    local chev = Create("Frame", {Parent = header, AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(12, 12),
        BackgroundTransparency = 1, ZIndex = 103})
    for _, rot in ipairs({45, -45}) do
        local ln = Create("Frame", {Parent = chev, AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(8, 2), Rotation = rot, BackgroundColor3 = theme.Secondary,
            BorderSizePixel = 0, Position = rot == 45 and UDim2.new(0.5, -2, 0.5, 1) or UDim2.new(0.5, 2, 0.5, 1), ZIndex = 103})
        RegisterTheme(ln, "BackgroundColor3", "Secondary")
    end

    local searchBox, searchH = nil, 0
    if allowSearch then
        searchH = 32
        searchBox = Create("TextBox", {Parent = parts.frame, Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = theme.Element, PlaceholderText = "Tìm…", Text = "", Font = Enum.Font.Gotham,
            TextSize = 12, TextColor3 = theme.Text, PlaceholderColor3 = theme.Secondary,
            ClearTextOnFocus = false, BorderSizePixel = 0, ZIndex = 102})
        Create("UICorner", {Parent = searchBox, CornerRadius = UDim.new(0, 8)})
        Create("UIPadding", {Parent = searchBox, PaddingLeft = UDim.new(0, 10)})
        RegisterTheme(searchBox, "BackgroundColor3", "Element")
        RegisterTheme(searchBox, "TextColor3", "Text")
    end

    local holder = Create("ScrollingFrame", {Parent = parts.frame, Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 3, ScrollBarImageColor3 = theme.Secondary,
        ScrollBarImageTransparency = 0.5, ZIndex = 102})
    Create("UIListLayout", {Parent = holder, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})

    local items = {}
    local element = {}
    -- FIX: khai báo local trước (tránh ghi đè global khi có nhiều dropdown)
    local renderStates, updateLabel

    local function applyFilter(q)
        q = (q or ""):lower()
        local visibleCount = 0
        for _, item in ipairs(items) do
            local match = q == "" or item.value:lower():find(q, 1, true) ~= nil
            item.frame.Visible = match
            if match then visibleCount += 1 end
        end
        return visibleCount
    end

    local function currentValue()
        if multi then
            local out = {}
            for _, item in ipairs(items) do
                if state[item.value] then table.insert(out, item.value) end
            end
            return out
        end
        return state
    end
    local function fireCallback()
        if info.Callback then info.Callback(currentValue()) end
    end

    for i, v in ipairs(values) do
        local item = Create("TextButton", {Parent = holder, Size = UDim2.new(1, 0, 0, 26),
            BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
            LayoutOrder = i, ZIndex = 102})
        local back = Create("Frame", {Parent = item, Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = theme.Element, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 102})
        Create("UICorner", {Parent = back, CornerRadius = UDim.new(0, 6)})
        local dot = Create("Frame", {Parent = item, Position = UDim2.fromOffset(8, 10),
            Size = UDim2.fromOffset(6, 6), BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 103})
        Create("UICorner", {Parent = dot, CornerRadius = UDim.new(1, 0)})
        local lbl = Create("TextLabel", {Parent = item, Position = UDim2.fromOffset(24, 0),
            Size = UDim2.new(1, -32, 1, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham,
            TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
            Text = tostring(v), TextColor3 = theme.Text, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 103})
        RegisterTheme(lbl, "TextColor3", "Text")

        item.MouseEnter:Connect(function() Tween(back, 0.15, {BackgroundTransparency = 0.45}) end)
        item.MouseLeave:Connect(function() Tween(back, 0.2, {BackgroundTransparency = 1}) end)
        OnClick(item, function()
            if multi then
                state[v] = not state[v]
            else
                state = v
            end
            renderStates()
            updateLabel()
            fireCallback()
        end)
        items[i] = {frame = item, back = back, dot = dot, value = v}
    end

    function renderStates()
        for _, item in ipairs(items) do
            local selected = multi and (state[item.value] == true) or (not multi and state == item.value)
            local th = Themes[Meizu.CurrentTheme]
            Tween(item.back, 0.18, {BackgroundColor3 = selected and th.Accent or th.Element,
                BackgroundTransparency = selected and 0.75 or 1})
            Tween(item.dot, 0.18, {BackgroundTransparency = selected and 0 or 1})
        end
    end
    function updateLabel()
        if multi then
            local n = 0
            for _ in pairs(state) do n += 1 end
            valueLabel.Text = n == 0 and "Chọn…" or (n .. " mục đã chọn")
        else
            valueLabel.Text = state ~= nil and tostring(state) or "Chọn…"
        end
    end

    local open = false
    local function setOpen(next)
        if open == next then return end
        open = next
        local visible = applyFilter(searchBox and searchBox.Text or "")
        local count = math.min(visible, maxVisible)
        Tween(chev, 0.25, {Rotation = open and 180 or 0})
        if open then
            holder.CanvasSize = UDim2.new(0, 0, 0, visible * 28)
            parts.setHeight(baseH + (allowSearch and searchH or 0) + count * 28 + 4)
            Tween(holder, 0.28, {Size = UDim2.new(1, 0, 0, (allowSearch and searchH or 0) + count * 28 + 4)})
        else
            parts.setHeight(baseH)
            Tween(holder, 0.22, {Size = UDim2.new(1, 0, 0, 0)})
            task.delay(0.24, function()
                if not open then holder.CanvasSize = UDim2.new(0, 0, 0, 0) end
            end)
        end
    end
    OnClick(header, function() setOpen(not open) end)

    if searchBox then
        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            if not open then return end
            local visible = applyFilter(searchBox.Text)
            local count = math.min(visible, maxVisible)
            holder.CanvasSize = UDim2.new(0, 0, 0, visible * 28)
            parts.setHeight(baseH + searchH + count * 28 + 4)
            Tween(holder, 0.25, {Size = UDim2.new(1, 0, 0, searchH + count * 28 + 4)})
        end)
    end

    function element:Set(v, noCallback)
        if multi then
            state = {}
            for _, x in ipairs(v or {}) do state[x] = true end
        else
            state = v
        end
        renderStates()
        updateLabel()
        if not noCallback then fireCallback() end
    end
    function element:Get() return currentValue() end

    renderStates()
    updateLabel()
    RegisterFlag(info, element)
    return element
end

-- Input ----------------------------------------------------------
ElementBuilders.AddInput = function(tab, info)
    info = info or {}
    local theme = Themes[Meizu.CurrentTheme]
    local parts = BuildCard(tab, info, 34)
    local box = Create("TextBox", {Parent = parts.frame, Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = theme.Element, Text = tostring(info.Default or ""),
        PlaceholderText = info.PlaceholderText or "Nhập…", Font = Enum.Font.Gotham, TextSize = 12,
        TextColor3 = theme.Text, PlaceholderColor3 = theme.Secondary, ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0, ZIndex = 102})
    Create("UICorner", {Parent = box, CornerRadius = UDim.new(0, 8)})
    Create("UIPadding", {Parent = box, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
    local stroke = Create("UIStroke", {Parent = box, Thickness = 1, Transparency = 1})
    RegisterTheme(box, "BackgroundColor3", "Element")
    RegisterTheme(box, "TextColor3", "Text")
    RegisterTheme(stroke, "Color", "Accent")

    box.Focused:Connect(function() Tween(stroke, 0.2, {Transparency = 0.25}) end)
    box.FocusLost:Connect(function()
        Tween(stroke, 0.3, {Transparency = 1})
        if info.Numeric then
            local n = tonumber(box.Text)
            if n then box.Text = tostring(n) else box.Text = info.Default and tostring(info.Default) or "0" end
            if info.Callback then info.Callback(tonumber(box.Text)) end
        else
            if info.Callback then info.Callback(box.Text) end
        end
    end)

    local element = {}
    function element:Set(v, noCallback)
        box.Text = tostring(v or "")
        if not noCallback and info.Callback then
            info.Callback(info.Numeric and tonumber(box.Text) or box.Text)
        end
    end
    function element:Get()
        return info.Numeric and (tonumber(box.Text) or 0) or box.Text
    end
    RegisterFlag(info, element)
    return element
end

-- Keybind --------------------------------------------------------
ElementBuilders.AddKeybind = function(tab, info)
    info = info or {}
    local theme = Themes[Meizu.CurrentTheme]
    local parts = BuildCard(tab, info, 0, true)
    local mode = info.Mode or "Toggle" -- Toggle / Hold / Always
    local key = info.Default
    local listening = false
    local active = false

    local slot = Create("TextButton", {Parent = parts.titleRow, AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(84, 24),
        BackgroundColor3 = theme.Element, Text = key and key.Name or "None",
        Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = theme.Secondary,
        AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 103})
    Create("UICorner", {Parent = slot, CornerRadius = UDim.new(0, 6)})
    RegisterTheme(slot, "BackgroundColor3", "Element")
    RegisterTheme(slot, "TextColor3", "Secondary")
    OnHover(slot, {BackgroundTransparency = 0.25}, {BackgroundTransparency = 0})

    local element = {}
    local function setKey(newKey)
        key = newKey
        slot.Text = key and key.Name or "None"
    end

    OnClick(slot, function()
        if listening then return end
        listening = true
        slot.Text = "…"
        local conn
        conn = UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
                conn:Disconnect()
                listening = false
                setKey(input.KeyCode)
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                conn:Disconnect()
                listening = false
                slot.Text = key and key.Name or "None"
            end
        end)
    end)

    Connect(UserInputService.InputBegan, function(input, processed)
        if processed or listening then return end
        if key and input.KeyCode == key then
            if mode == "Toggle" then
                active = not active
                if info.Callback then info.Callback(active) end
            elseif mode == "Hold" then
                active = true
                if info.Callback then info.Callback(true) end
            else
                if info.Callback then info.Callback() end
            end
        end
    end)
    Connect(UserInputService.InputEnded, function(input)
        if mode == "Hold" and key and input.KeyCode == key then
            active = false
            if info.Callback then info.Callback(false) end
        end
    end)

    function element:Set(v) setKey(v) end
    function element:Get() return key end
    RegisterFlag(info, element)
    return element
end

-- ColorPicker ----------------------------------------------------
ElementBuilders.AddColorPicker = function(tab, info)
    info = info or {}
    local theme = Themes[Meizu.CurrentTheme]
    local parts = BuildCard(tab, info, 0, true)
    local color = info.Default or Color3.fromRGB(124, 92, 255)
    local h, s, v = Color3.toHSV(color)

    local swatch = Create("TextButton", {Parent = parts.titleRow, AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(52, 22),
        BackgroundColor3 = color, Text = "", AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 103})
    Create("UICorner", {Parent = swatch, CornerRadius = UDim.new(0, 6)})

    local popup, svBox, hueBar, svCursor, hueCursor, hexBox, preview, blocker
    local element = {}

    local function updateColor(noCallback)
        color = Color3.fromHSV(h, s, v)
        if svBox then
            svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            svCursor.Position = UDim2.fromScale(s, 1 - v)
            hueCursor.Position = UDim2.new(h, 0, 0.5, 0)
            preview.BackgroundColor3 = color
            hexBox.Text = string.format("#%02X%02X%02X",
                math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
        end
        swatch.BackgroundColor3 = color
        if not noCallback and info.Callback then info.Callback(color) end
    end

    local function buildPopup()
        EnsureRoot()
        popup = NewGroup({Parent = Root, Size = UDim2.fromOffset(228, 236),
            BackgroundColor3 = theme.Card, BorderSizePixel = 0, ZIndex = 250, Visible = false, GroupTransparency = 1})
        Create("UICorner", {Parent = popup, CornerRadius = UDim.new(0, 12)})
        local pstroke = Create("UIStroke", {Parent = popup, Thickness = 1, Transparency = 0.88})
        RegisterTheme(popup, "BackgroundColor3", "Card")
        RegisterTheme(pstroke, "Color", "Stroke")
        Create("UIPadding", {Parent = popup, PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)})
        Create("UIListLayout", {Parent = popup, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})

        local row = Create("Frame", {Parent = popup, Size = UDim2.new(1, 0, 0, 26),
            BackgroundTransparency = 1, ZIndex = 251})
        preview = Create("Frame", {Parent = row, Size = UDim2.fromOffset(40, 26),
            BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 251})
        Create("UICorner", {Parent = preview, CornerRadius = UDim.new(0, 6)})
        hexBox = Create("TextBox", {Parent = row, Position = UDim2.fromOffset(48, 0),
            Size = UDim2.new(1, -48, 0, 26), BackgroundColor3 = theme.Element, Text = "",
            Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = theme.Text,
            PlaceholderText = "#RRGGBB", ClearTextOnFocus = false, BorderSizePixel = 0, ZIndex = 251})
        Create("UICorner", {Parent = hexBox, CornerRadius = UDim.new(0, 6)})
        Create("UIPadding", {Parent = hexBox, PaddingLeft = UDim.new(0, 8)})
        RegisterTheme(hexBox, "BackgroundColor3", "Element")
        RegisterTheme(hexBox, "TextColor3", "Text")

        svBox = Create("Frame", {Parent = popup, Size = UDim2.new(1, 0, 0, 120),
            BackgroundColor3 = Color3.fromHSV(h, 1, 1), BorderSizePixel = 0, ZIndex = 251})
        Create("UICorner", {Parent = svBox, CornerRadius = UDim.new(0, 8)})
        local satLayer = Create("Frame", {Parent = svBox, Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 252})
        Create("UIGradient", {Parent = satLayer, Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})})
        local valLayer = Create("Frame", {Parent = svBox, Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, ZIndex = 253})
        Create("UIGradient", {Parent = valLayer, Rotation = 90, Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})})
        svCursor = Create("Frame", {Parent = svBox, AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(s, 1 - v), Size = UDim2.fromOffset(10, 10),
            BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 254})
        Create("UICorner", {Parent = svCursor, CornerRadius = UDim.new(1, 0)})
        Create("UIStroke", {Parent = svCursor, Thickness = 1.5, Color = Color3.new(0, 0, 0), Transparency = 0.25})

        hueBar = Create("Frame", {Parent = popup, Size = UDim2.new(1, 0, 0, 14),
            BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 251})
        Create("UICorner", {Parent = hueBar, CornerRadius = UDim.new(1, 0)})
        Create("UIGradient", {Parent = hueBar, Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(1/6, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(2/6, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(3/6, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(4/6, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(5/6, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
        })})
        hueCursor = Create("Frame", {Parent = hueBar, AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(h, 0, 0.5, 0), Size = UDim2.fromOffset(6, 18),
            BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 254})
        Create("UICorner", {Parent = hueCursor, CornerRadius = UDim.new(1, 0)})
        Create("UIStroke", {Parent = hueCursor, Thickness = 1.5, Color = Color3.new(0, 0, 0), Transparency = 0.25})

        svBox.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                TrackMouse(function(mouse)
                    if not svBox.Parent then return end
                    s = math.clamp((mouse.X - svBox.AbsolutePosition.X) / math.max(svBox.AbsoluteSize.X, 1), 0, 1)
                    v = 1 - math.clamp((mouse.Y - svBox.AbsolutePosition.Y) / math.max(svBox.AbsoluteSize.Y, 1), 0, 1)
                    updateColor()
                end)
            end
        end)
        hueBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                TrackMouse(function(mouse)
                    if not hueBar.Parent then return end
                    h = math.clamp((mouse.X - hueBar.AbsolutePosition.X) / math.max(hueBar.AbsoluteSize.X, 1), 0, 1)
                    updateColor()
                end)
            end
        end)
        hexBox.FocusLost:Connect(function()
            local t = hexBox.Text:gsub("#", ""):gsub(" ", "")
            if #t == 6 then
                local r, g, b = tonumber(t:sub(1, 2), 16), tonumber(t:sub(3, 4), 16), tonumber(t:sub(5, 6), 16)
                if r and g and b then
                    color = Color3.fromRGB(r, g, b)
                    h, s, v = Color3.toHSV(color)
                    updateColor()
                    return
                end
            end
            updateColor(true)
        end)
        updateColor(true)
    end

    local function closePopup()
        if popup and popup.Visible then
            FadeGroup(popup, 0.2, 1)
            task.delay(0.22, function() if popup and popup.Parent then popup.Visible = false end end)
        end
        if blocker then blocker:Destroy() blocker = nil end
    end
    local function openPopup()
        if not popup then buildPopup() end
        if popup.Visible then return end
        popup.Visible = true
        local pos = swatch.AbsolutePosition
        local size = swatch.AbsoluteSize
        local vs = GetViewport()
        local targetX, targetY = pos.X, pos.Y + size.Y + 8
        if targetX + 228 > vs.X then targetX = vs.X - 236 end
        if targetY + 236 > vs.Y then targetY = pos.Y - 244 end
        popup.Position = UDim2.fromOffset(targetX, targetY + 8)
        Tween(popup, 0.25, {Position = UDim2.fromOffset(targetX, targetY)}, Enum.EasingStyle.Quint)
        FadeGroup(popup, 0.25, 0)
        blocker = Create("TextButton", {Parent = Root, Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 240})
        blocker.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                closePopup()
            end
        end)
    end

    OnClick(swatch, function()
        if popup and popup.Visible then closePopup() else openPopup() end
    end)

    function element:Set(v, noCallback)
        if typeof(v) == "Color3" then
            color = v
            h, s, v = Color3.toHSV(color)
            updateColor(noCallback)
        end
    end
    function element:Get() return color end
    RegisterFlag(info, element)
    return element
end

-- Label / Paragraph / Section / Divider / ProgressBar ------------
ElementBuilders.AddLabel = function(tab, info)
    info = info or {}
    local theme = Themes[Meizu.CurrentTheme]
    local w = tab._innerWidth or 480
    local th = MeasureText(info.Title or "", 13, w)
    local dh = info.Description and (MeasureText(info.Description, 12, w) + 2) or 0
    tab._order = (tab._order or 0) + 1
    local holder = Create("Frame", {Parent = tab.list, Size = UDim2.new(1, 0, 0, th + dh),
        BackgroundTransparency = 1, LayoutOrder = tab._order, ZIndex = 101})
    holder:SetAttribute("CardHeight", th + dh)
    local t = Create("TextLabel", {Parent = holder, Size = UDim2.new(1, 0, 0, th), BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold, Text = info.Title or "", TextSize = 13, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Text, ZIndex = 102})
    RegisterTheme(t, "TextColor3", "Text")
    if info.Description then
        local d = Create("TextLabel", {Parent = holder, Position = UDim2.fromOffset(0, th),
            Size = UDim2.new(1, 0, 0, dh), BackgroundTransparency = 1, Font = Enum.Font.Gotham,
            Text = info.Description, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top, TextColor3 = theme.Secondary, ZIndex = 102})
        RegisterTheme(d, "TextColor3", "Secondary")
    end
    return {Set = function(_, text) t.Text = text end}
end

ElementBuilders.AddParagraph = function(tab, info)
    return ElementBuilders.AddLabel(tab, {Title = info and info.Title, Description = info and (info.Content or info.Description)})
end

ElementBuilders.AddSection = function(tab, info)
    info = info or {}
    local theme = Themes[Meizu.CurrentTheme]
    tab._order = (tab._order or 0) + 1
    local holder = Create("Frame", {Parent = tab.list, Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1, LayoutOrder = tab._order, ZIndex = 101})
    holder:SetAttribute("CardHeight", 30)
    local line = Create("Frame", {Parent = holder, Position = UDim2.new(0, 0, 1, -3),
        Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = theme.Stroke, BackgroundTransparency = 0.95,
        BorderSizePixel = 0, ZIndex = 102})
    RegisterTheme(line, "BackgroundColor3", "Stroke")
    local t = Create("TextLabel", {Parent = holder, Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, Text = info.Title or "Section", TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
        TextColor3 = theme.Text, ZIndex = 102})
    RegisterTheme(t, "TextColor3", "Text")
    return holder
end

ElementBuilders.AddDivider = function(tab)
    local theme = Themes[Meizu.CurrentTheme]
    tab._order = (tab._order or 0) + 1
    local holder = Create("Frame", {Parent = tab.list, Size = UDim2.new(1, 0, 0, 10),
        BackgroundTransparency = 1, LayoutOrder = tab._order, ZIndex = 101})
    holder:SetAttribute("CardHeight", 10)
    local line = Create("Frame", {Parent = holder, AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = theme.Stroke, BackgroundTransparency = 0.95, BorderSizePixel = 0, ZIndex = 102})
    RegisterTheme(line, "BackgroundColor3", "Stroke")
    return holder
end

ElementBuilders.AddProgressBar = function(tab, info)
    info = info or {}
    local theme = Themes[Meizu.CurrentTheme]
    local parts = BuildCard(tab, {Title = info.Title, Description = info.Description}, 18, true)
    local pctLabel = Create("TextLabel", {Parent = parts.titleRow, AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(64, 24), BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right,
        TextColor3 = theme.Secondary, Text = "0%", ZIndex = 103})
    RegisterTheme(pctLabel, "TextColor3", "Secondary")
    local track = Create("Frame", {Parent = parts.frame, Size = UDim2.new(1, 0, 0, 8),
        BackgroundColor3 = theme.Element, BorderSizePixel = 0, ZIndex = 102})
    Create("UICorner", {Parent = track, CornerRadius = UDim.new(1, 0)})
    RegisterTheme(track, "BackgroundColor3", "Element")
    local fill = Create("Frame", {Parent = track, Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 103})
    MakeGradient(fill)
    Create("UICorner", {Parent = fill, CornerRadius = UDim.new(1, 0)})

    local value = info.Default or 0
    local element = {}
    local function render(animated)
        local rel = math.clamp(value, 0, 1)
        if animated then
            Tween(fill, 0.35, {Size = UDim2.new(rel, 0, 1, 0)})
        else
            fill.Size = UDim2.new(rel, 0, 1, 0)
        end
        pctLabel.Text = string.format("%.0f%%", rel * 100)
    end
    function element:Set(v)
        value = v
        render(true)
        if info.Callback then info.Callback(value) end
    end
    function element:Get() return value end
    render(false)
    RegisterFlag(info, element)
    return element
end

-- // Config system -----------------------------------------------
local ConfigFolder = "MeizuConfigs"
local function SerializeValue(v)
    local t = typeof(v)
    if t == "Color3" then
        return {__type = "Color3", R = math.floor(v.R * 255 + 0.5), G = math.floor(v.G * 255 + 0.5), B = math.floor(v.B * 255 + 0.5)}
    elseif t == "EnumItem" then
        return {__type = "EnumItem", EnumType = v.EnumType, Name = v.Name}
    end
    return v
end
local function DeserializeValue(v)
    if type(v) == "table" and v.__type == "Color3" then
        return Color3.fromRGB(v.R, v.G, v.B)
    elseif type(v) == "table" and v.__type == "EnumItem" then
        local ok, item = pcall(function() return Enum[v.EnumType][v.Name] end)
        return ok and item or nil
    end
    return v
end
local function ConfigPath(name) return ConfigFolder .. "/" .. tostring(name) .. ".json" end

function Meizu.SaveConfig(name)
    if not writefile then return false, "Executor không hỗ trợ file" end
    if isfolder and not isfolder(ConfigFolder) and makefolder then makefolder(ConfigFolder) end
    local data = {}
    for key, element in pairs(Meizu.Flags) do
        data[key] = SerializeValue(element:Get())
    end
    pcall(function() writefile(ConfigPath(name), HttpService:JSONEncode(data)) end)
    return true
end

function Meizu.LoadConfig(name)
    if not (readfile and isfile) or not isfile(ConfigPath(name)) then return false end
    local ok, decoded = pcall(function() return HttpService:JSONDecode(readfile(ConfigPath(name))) end)
    if not ok or type(decoded) ~= "table" then return false end
    for key, value in pairs(decoded) do
        local element = Meizu.Flags[key]
        if element and element.Set then
            local v = DeserializeValue(value)
            if v ~= nil then element:Set(v) end
        end
    end
    return true
end

function Meizu.GetConfigs()
    if not (listfiles and isfolder and isfolder(ConfigFolder)) then return {} end
    local out = {}
    for _, path in ipairs(listfiles(ConfigFolder)) do
        local name = path:match("([^/\\]+)%.json$")
        if name then table.insert(out, name) end
    end
    table.sort(out)
    return out
end

function Meizu.DeleteConfig(name)
    if isfile and isfile(ConfigPath(name)) and delfile then
        pcall(function() delfile(ConfigPath(name)) end)
        return true
    end
    return false
end

-- // Window ------------------------------------------------------
function Meizu.CreateWindow(options)
    options = options or {}
    if options.Theme and Themes[options.Theme] then Meizu.CurrentTheme = options.Theme end
    EnsureRoot()
    local theme = Themes[Meizu.CurrentTheme]

    local windowSize = options.Size or UDim2.fromOffset(600, 430)
    local tabWidth = options.TabWidth or 160
    local toggleKey = options.ToggleKey or Enum.KeyCode.RightShift
    local vs = GetViewport()

    ------------------------------------------------ ORB 50x50 (góc trái dưới)
    local orb = Create("ImageButton", {Parent = Root, Name = "ToggleOrb",
        Position = UDim2.new(0, 18, 1, -18), AnchorPoint = Vector2.new(0, 1),
        Size = UDim2.new(0, 50, 0, 50), BackgroundTransparency = 1,
        AutoButtonColor = false, ZIndex = 150, Visible = false})
    local glow = Create("ImageLabel", {Parent = orb, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(72, 72),
        BackgroundTransparency = 1, Image = "rbxassetid://6014261993",
        ImageColor3 = theme.Accent, ImageTransparency = 0.6, ZIndex = 149})
    RegisterTheme(glow, "ImageColor3", "Accent")
    local circle = Create("Frame", {Parent = orb, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(44, 44),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 150})
    MakeGradient(circle)
    Create("UICorner", {Parent = circle, CornerRadius = UDim.new(1, 0)})
    local letter = Create("TextLabel", {Parent = circle, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 1, Font = Enum.Font.GothamBlack,
        Text = "M", TextSize = 20, TextColor3 = theme.Background, Size = UDim2.fromOffset(30, 30)})
    RegisterTheme(letter, "TextColor3", "Background")

    task.spawn(function()
        while orb.Parent do
            local up = Tween(circle, 1.1, {Size = UDim2.fromOffset(48, 48)}, Enum.EasingStyle.Sine)
            Tween(glow, 1.1, {ImageTransparency = 0.35})
            up.Completed:Wait()
            if not orb.Parent then break end
            local down = Tween(circle, 1.1, {Size = UDim2.fromOffset(44, 44)}, Enum.EasingStyle.Sine)
            Tween(glow, 1.1, {ImageTransparency = 0.6})
            down.Completed:Wait()
        end
    end)

    ------------------------------------------------ Window frame
    local winFrame = Create("Frame", {Parent = Root, Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(vs.X / 2, vs.Y / 2),
        Size = windowSize, BackgroundTransparency = 1, ZIndex = 100, Visible = false})
    local shadow = Create("ImageLabel", {Parent = winFrame, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, 60, 1, 60), BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993", ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 1, ZIndex = 99})
    local scaler = Create("Frame", {Parent = winFrame, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, ZIndex = 101})
    local body = Create("Frame", {Parent = scaler, Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = theme.Background, ClipsDescendants = true, BorderSizePixel = 0, ZIndex = 101})
    RegisterTheme(body, "BackgroundColor3", "Background")
    local bodyCorner = Create("UICorner", {Parent = body, CornerRadius = UDim.new(0, 14)})
    local bodyStroke = Create("UIStroke", {Parent = body, Thickness = 1, Transparency = 0.92})
    RegisterTheme(bodyStroke, "Color", "Stroke")

    ------------------------------------------------ Title bar
    local titleBar = Create("Frame", {Parent = body, Size = UDim2.new(1, 0, 0, 46),
        BackgroundTransparency = 1, ZIndex = 102})
    local logo = Create("Frame", {Parent = titleBar, Position = UDim2.fromOffset(14, 11),
        Size = UDim2.fromOffset(24, 24), BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0, ZIndex = 103})
    MakeGradient(logo)
    Create("UICorner", {Parent = logo, CornerRadius = UDim.new(1, 0)})
    local logoText = Create("TextLabel", {Parent = logo, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 1, Font = Enum.Font.GothamBlack,
        Text = "M", TextSize = 13, TextColor3 = theme.Background, Size = UDim2.fromOffset(20, 20)})
    RegisterTheme(logoText, "TextColor3", "Background")
    local titleLabel = Create("TextLabel", {Parent = titleBar, Position = UDim2.fromOffset(48, 6),
        Size = UDim2.new(1, -190, 0, 20), BackgroundTransparency = 1, Font = Enum.Font.GothamSemibold,
        Text = options.Title or "Meizu", TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = theme.Text, ZIndex = 103, TextTruncate = Enum.TextTruncate.AtEnd})
    RegisterTheme(titleLabel, "TextColor3", "Text")
    local subLabel = Create("TextLabel", {Parent = titleBar, Position = UDim2.fromOffset(48, 25),
        Size = UDim2.new(1, -190, 0, 14), BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = options.SubTitle or "", TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = theme.Secondary, ZIndex = 103, TextTruncate = Enum.TextTruncate.AtEnd})
    RegisterTheme(subLabel, "TextColor3", "Secondary")

    -- FIX CHÍNH: khởi tạo đúng trạng thái — cửa sổ đang ẩn = đang minimized
    local minimized = true
    local animBusy = false

    local function titleButton(icon, xPos, isClose)
        local btn = Create("TextButton", {Parent = titleBar, AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, xPos, 0.5, 0), Size = UDim2.fromOffset(28, 28),
            BackgroundTransparency = 1, Text = icon, Font = Enum.Font.GothamBold, TextSize = 14,
            TextColor3 = theme.Text, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 103})
        Create("UICorner", {Parent = btn, CornerRadius = UDim.new(1, 0)})
        local hoverColor = isClose and Color3.fromRGB(255, 92, 92) or theme.Text
        btn.MouseEnter:Connect(function()
            Tween(btn, 0.15, {BackgroundTransparency = 0.86, TextColor3 = hoverColor})
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, 0.2, {BackgroundTransparency = 1, TextColor3 = Themes[Meizu.CurrentTheme].Text})
        end)
        return btn
    end
    local minBtn = titleButton("—", -12, false)
    local closeBtn = titleButton("×", -46, true)

    ------------------------------------------------ Sidebar + content
    local bodyFrame = Create("Frame", {Parent = body, Position = UDim2.fromOffset(0, 46),
        Size = UDim2.new(1, 0, 1, -46), BackgroundTransparency = 1, ZIndex = 101})
    local sidebar = Create("Frame", {Parent = bodyFrame, Size = UDim2.new(0, tabWidth, 1, 0),
        BackgroundColor3 = theme.Sidebar, BorderSizePixel = 0, ZIndex = 101})
    RegisterTheme(sidebar, "BackgroundColor3", "Sidebar")
    local searchBox = Create("TextBox", {Parent = sidebar, Position = UDim2.fromOffset(10, 10),
        Size = UDim2.new(1, -20, 0, 30), BackgroundColor3 = theme.Element, Text = "",
        PlaceholderText = "Tìm tab…", Font = Enum.Font.Gotham, TextSize = 12,
        TextColor3 = theme.Text, PlaceholderColor3 = theme.Secondary, ClearTextOnFocus = false,
        BorderSizePixel = 0, ZIndex = 102})
    Create("UICorner", {Parent = searchBox, CornerRadius = UDim.new(0, 8)})
    Create("UIPadding", {Parent = searchBox, PaddingLeft = UDim.new(0, 8)})
    RegisterTheme(searchBox, "BackgroundColor3", "Element")
    RegisterTheme(searchBox, "TextColor3", "Text")

    local tabScroll = Create("ScrollingFrame", {Parent = sidebar, Position = UDim2.fromOffset(10, 48),
        Size = UDim2.new(1, -20, 1, -58), BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = theme.Secondary,
        ScrollBarImageTransparency = 0.4, CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 102})
    RegisterTheme(tabScroll, "ScrollBarImageColor3", "Secondary")
    local listHolder = Create("Frame", {Parent = tabScroll, Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, ZIndex = 102})
    local tabList = Create("Frame", {Parent = listHolder, Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1, ZIndex = 102})
    local tabLayout = Create("UIListLayout", {Parent = tabList, Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder})
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabScroll.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
        tabList.Size = UDim2.new(1, 0, 0, tabLayout.AbsoluteContentSize.Y)
    end)
    local indicator = Create("Frame", {Parent = listHolder, Position = UDim2.fromOffset(4, 8),
        Size = UDim2.fromOffset(3, 16), BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0, ZIndex = 103})
    MakeGradient(indicator)
    Create("UICorner", {Parent = indicator, CornerRadius = UDim.new(1, 0)})

    local divider = Create("Frame", {Parent = bodyFrame, Position = UDim2.fromOffset(tabWidth, 0),
        Size = UDim2.new(0, 1, 1, 0), BackgroundColor3 = theme.Stroke,
        BackgroundTransparency = 0.92, BorderSizePixel = 0, ZIndex = 101})
    RegisterTheme(divider, "BackgroundColor3", "Stroke")
    local content = Create("Frame", {Parent = bodyFrame, Position = UDim2.fromOffset(tabWidth + 1, 0),
        Size = UDim2.new(1, -(tabWidth + 1), 1, 0), BackgroundTransparency = 1, ZIndex = 101})

    ------------------------------------------------ Tabs
    local Window = {}
    local tabs = {}
    local firstTab = nil

    local function selectTab(tab, force)
        if Window.ActiveTab == tab and not force then return end
        Window.ActiveTab = tab
        for _, t in ipairs(tabs) do
            if t ~= tab and t.canvas.Visible then
                FadeGroup(t.canvas, 0.18, 1)
                task.delay(0.2, function()
                    if t.canvas ~= tab.canvas then t.canvas.Visible = false end
                end)
            end
        end
        tab.canvas.Visible = true
        FadeGroup(tab.canvas, 0.24, 0)
        local th = Themes[Meizu.CurrentTheme]
        for _, t in ipairs(tabs) do
            local active = (t == tab)
            Tween(t.button.back, 0.2, {BackgroundTransparency = active and 0.65 or 1})
            Tween(t.button.label, 0.2, {TextColor3 = active and th.Text or th.Secondary})
        end
        local btnAbs = tab.button.holder.AbsolutePosition
        local listAbs = tabList.AbsolutePosition
        if btnAbs.Y > 0 or listAbs.Y > 0 then
            Tween(indicator, 0.35, {Position = UDim2.fromOffset(4, btnAbs.Y - listAbs.Y + 8)}, Enum.EasingStyle.Back)
        end
        if not tab._staggered then
            tab._staggered = true
            task.spawn(function()
                local cards = {}
                for _, c in ipairs(tab.list:GetChildren()) do
                    if c:IsA("Frame") and c:GetAttribute("CardHeight") then table.insert(cards, c) end
                end
                table.sort(cards, function(a, b) return (a.LayoutOrder or 0) < (b.LayoutOrder or 0) end)
                for i, card in ipairs(cards) do
                    if not card.Parent then break end
                    local h = card:GetAttribute("CardHeight")
                    card.Size = UDim2.new(1, 0, 0, 0)
                    Tween(card, 0.34, {Size = UDim2.new(1, 0, 0, h)}, Enum.EasingStyle.Quint,
                        Enum.EasingDirection.Out, (i - 1) * 0.03)
                end
            end)
        end
    end

    function Window:AddTab(info)
        info = info or {}
        local title = info.Title or "Tab"
        local holder = Create("Frame", {Parent = tabList, Size = UDim2.new(1, 0, 0, 32),
            BackgroundTransparency = 1, LayoutOrder = #tabs + 1, ZIndex = 102})
        local back = Create("Frame", {Parent = holder, Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = theme.Element, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 102})
        Create("UICorner", {Parent = back, CornerRadius = UDim.new(0, 8)})
        RegisterTheme(back, "BackgroundColor3", "Element")
        local btn = Create("TextButton", {Parent = holder, Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 103})
        local labelX = 14
        if info.Icon then
            Create("ImageLabel", {Parent = btn, Position = UDim2.fromOffset(14, 8),
                Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1, Image = info.Icon, ZIndex = 103})
            labelX = 38
        end
        local label = Create("TextLabel", {Parent = btn, Position = UDim2.fromOffset(labelX, 0),
            Size = UDim2.new(1, -labelX - 6, 1, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamMedium,
            Text = title, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center, TextColor3 = theme.Secondary,
            TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 103})
        RegisterTheme(label, "TextColor3", "Secondary")

        local canvas = NewGroup({Parent = content, Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1, GroupTransparency = 1, Visible = false,
            BorderSizePixel = 0, ZIndex = 101})
        local scroll = Create("ScrollingFrame", {Parent = canvas, Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
            ScrollBarImageColor3 = theme.Secondary, ScrollBarImageTransparency = 0.5,
            CanvasSize = UDim2.new(0, 0, 0, 0), ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 101})
        RegisterTheme(scroll, "ScrollBarImageColor3", "Secondary")
        Create("UIPadding", {Parent = scroll, PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 14),
            PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 10)})
        local list = Create("Frame", {Parent = scroll, Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1, ZIndex = 101})
        local layout = Create("UIListLayout", {Parent = list, Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder})
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
        end)

        local tab = {
            Title = title, canvas = canvas, list = list, _staggered = false,
            _innerWidth = windowSize.X.Offset - tabWidth - 1 - 22 - 3 - 24,
            button = {holder = holder, back = back, label = label, btn = btn},
        }
        for name, builder in pairs(ElementBuilders) do
            tab[name] = function(_, info2) return builder(tab, info2) end
        end
        table.insert(tabs, tab)
        btn.Activated:Connect(function() selectTab(tab) end)
        btn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= tab then Tween(back, 0.15, {BackgroundTransparency = 0.75}) end
        end)
        btn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= tab then Tween(back, 0.2, {BackgroundTransparency = 1}) end
        end)
        if not firstTab then firstTab = tab end
        return tab
    end

    function Window:SelectTab(target)
        local tab = (type(target) == "number") and tabs[target] or target
        if tab then selectTab(tab) end
    end
    function Window:SetTitle(t) titleLabel.Text = t end
    function Window:SetSubTitle(t) subLabel.Text = t end

    ------------------------------------------------ Minimize / morph orb
    local lastWindowPos = nil
    local function setMinimized(state)
        if animBusy or state == minimized then return end
        animBusy = true
        -- khóa an toàn: nếu animation bị lỗi/kẹt thì tự mở khóa
        task.delay(1.3, function() animBusy = false end)
        minimized = state
        if state then
            lastWindowPos = winFrame.Position
            local orbCenter = orb.AbsolutePosition + orb.AbsoluteSize / 2
            Tween(bodyStroke, 0.3, {Transparency = 1})
            Tween(shadow, 0.3, {ImageTransparency = 1})
            Tween(bodyCorner, 0.4, {CornerRadius = UDim.new(0, 25)})
            local shrink = Tween(winFrame, 0.4, {
                Size = UDim2.fromOffset(50, 50),
                Position = UDim2.fromOffset(orbCenter.X, orbCenter.Y),
            }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            pcall(function() shrink.Completed:Wait() end)
            if not winFrame.Parent then animBusy = false return end
            winFrame.Visible = false
            orb.Visible = true
            circle.Size = UDim2.fromOffset(26, 26)
            Tween(circle, 0.45, {Size = UDim2.fromOffset(44, 44)}, Enum.EasingStyle.Back)
        else
            if orb.Visible then
                local orbCenter = orb.AbsolutePosition + orb.AbsoluteSize / 2
                local shrinkOrb = Tween(circle, 0.28, {Size = UDim2.fromOffset(26, 26)},
                    Enum.EasingStyle.Back, Enum.EasingDirection.In)
                pcall(function() shrinkOrb.Completed:Wait() end)
                if not orb.Parent then animBusy = false return end
                orb.Visible = false
                winFrame.Visible = true
                winFrame.Size = UDim2.fromOffset(50, 50)
                winFrame.Position = UDim2.fromOffset(orbCenter.X, orbCenter.Y)
                bodyCorner.CornerRadius = UDim.new(0, 25)
                Tween(bodyStroke, 0.35, {Transparency = 0.92})
                Tween(shadow, 0.45, {ImageTransparency = 0.35})
                Tween(bodyCorner, 0.5, {CornerRadius = UDim.new(0, 14)})
                Tween(winFrame, 0.5, {Size = windowSize, Position = lastWindowPos or UDim2.fromOffset(vs.X / 2, vs.Y / 2)},
                    Enum.EasingStyle.Back)
            else
                -- mở lần đầu từ giữa màn hình
                winFrame.Visible = true
                winFrame.Position = lastWindowPos or UDim2.fromOffset(vs.X / 2, vs.Y / 2)
                winFrame.Size = windowSize
                scaler.Size = UDim2.fromScale(0.6, 0.6)
                Tween(bodyStroke, 0.3, {Transparency = 0.92})
                Tween(shadow, 0.5, {ImageTransparency = 0.35})
                Tween(scaler, 0.55, {Size = UDim2.fromScale(1, 1)}, Enum.EasingStyle.Back)
            end
        end
        animBusy = false
    end

    function Window:Toggle() setMinimized(not minimized) end
    function Window:Minimize() setMinimized(true) end

    local function destroyGui()
        animBusy = true
        orb.Visible = false
        Tween(shadow, 0.3, {ImageTransparency = 1})
        Tween(bodyStroke, 0.3, {Transparency = 1})
        local t = Tween(scaler, 0.32, {Size = UDim2.fromScale(0, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        pcall(function() t.Completed:Wait() end)
        if Root then Root:Destroy() end
        Root, NotifyContainer = nil, nil
        Meizu.Flags = {}
        ThemeRegistry, gradients = {}, {}
    end
    function Window:Destroy() task.spawn(destroyGui) end

    ------------------------------------------------ Events
    OnClick(minBtn, function() setMinimized(true) end)
    OnClick(closeBtn, function() task.spawn(destroyGui) end)

    -- kéo cửa sổ (lerp mượt + snap-back)
    titleBar.InputBegan:Connect(function(input)
        if (input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch)
            or minimized or animBusy then return end
        local start = Vector2.new(input.Position.X, input.Position.Y)
        winFrame.Position = UDim2.fromOffset(
            winFrame.AbsolutePosition.X + winFrame.AbsoluteSize.X / 2,
            winFrame.AbsolutePosition.Y + winFrame.AbsoluteSize.Y / 2)
        local startPos = winFrame.Position
        local current = start
        local moveConn = UserInputService.InputChanged:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                current = Vector2.new(inp.Position.X, inp.Position.Y)
            end
        end)
        local rs = RunService.RenderStepped:Connect(function(dt)
            if not winFrame.Parent then rs:Disconnect() return end
            local target = UDim2.fromOffset(
                startPos.X.Offset + (current.X - start.X),
                startPos.Y.Offset + (current.Y - start.Y))
            winFrame.Position = winFrame.Position:Lerp(target, math.clamp(dt * 20, 0, 1))
        end)
        local endConn = UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                moveConn:Disconnect() rs:Disconnect() endConn:Disconnect()
                if not winFrame.Parent then return end
                local vs = GetViewport()
                local abs, size = winFrame.AbsolutePosition, winFrame.AbsoluteSize
                local targetX = math.clamp(abs.X, -size.X + 80, vs.X - 80)
                local targetY = math.clamp(abs.Y, 0, vs.Y - 44)
                local newCenter = UDim2.fromOffset(targetX + size.X / 2, targetY + size.Y / 2)
                if math.abs(newCenter.X.Offset - winFrame.Position.X.Offset) > 1
                    or math.abs(newCenter.Y.Offset - winFrame.Position.Y.Offset) > 1 then
                    Tween(winFrame, 0.45, {Position = newCenter}, Enum.EasingStyle.Back)
                else
                    winFrame.Position = newCenter
                end
            end
        end)
    end)

    -- kéo orb + click mở
    local orbMoved = false
    orb.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        orbMoved = false
        local start = Vector2.new(input.Position.X, input.Position.Y)
        orb.AnchorPoint = Vector2.new(0, 0)
        orb.Position = UDim2.fromOffset(orb.AbsolutePosition.X, orb.AbsolutePosition.Y)
        local startPos = orb.Position
        TrackMouse(function(mouse)
            local dx, dy = mouse.X - start.X, mouse.Y - start.Y
            if math.abs(dx) + math.abs(dy) > 6 then orbMoved = true end
            if orbMoved and orb.Parent then
                orb.Position = UDim2.fromOffset(startPos.X.Offset + dx, startPos.Y.Offset + dy)
            end
        end, function()
            if orbMoved and orb.Parent then
                local vs = GetViewport()
                local newX = math.clamp(orb.AbsolutePosition.X, 8, vs.X - 58)
                local newY = math.clamp(orb.AbsolutePosition.Y, 8, vs.Y - 58)
                Tween(orb, 0.4, {Position = UDim2.fromOffset(newX, newY)}, Enum.EasingStyle.Back)
            end
        end)
    end)
    orb.Activated:Connect(function()
        if not orbMoved then setMinimized(false) end
    end)

    -- phím tắt mở/đóng
    Connect(UserInputService.InputBegan, function(input, processed)
        if processed then return end
        if input.KeyCode == toggleKey then setMinimized(not minimized) end
    end)

    -- tìm tab
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = searchBox.Text:lower()
        for _, t in ipairs(tabs) do
            t.button.holder.Visible = (q == "" or t.Title:lower():find(q, 1, true) ~= nil)
        end
    end)

    ------------------------------------------------ Config tab helper
    function Window:AddConfigTab()
        local tab = self:AddTab({Title = "Lưu trữ"})
        tab:AddSection({Title = "Cấu hình"})
        local nameInput = tab:AddInput({Title = "Tên cấu hình", PlaceholderText = "my-config"})
        local list = tab:AddDropdown({Title = "Danh sách file", Values = Meizu.GetConfigs(), AllowSearch = false})
        tab:AddButton({Title = "Lưu cấu hình", Primary = true, Description = "Lưu toàn bộ giá trị các phần tử có ConfigKey vào file",
            Callback = function()
                local name = nameInput:Get()
                if name == "" then
                    Meizu.Notify({Title = "Lưu cấu hình", Content = "Vui lòng nhập tên cấu hình", Type = "Warning"})
                    return
                end
                local ok = Meizu.SaveConfig(name)
                Meizu.Notify({Title = "Lưu cấu hình", Content = ok and ("Đã lưu: " .. name) or "Executor không hỗ trợ file",
                    Type = ok and "Success" or "Error"})
                list:Set(Meizu.GetConfigs())
            end})
        tab:AddButton({Title = "Tải cấu hình", Callback = function()
                local name = list:Get()
                if not name then Meizu.Notify({Title = "Tải cấu hình", Content = "Chọn một file trước", Type = "Warning"}) return end
                local ok = Meizu.LoadConfig(name)
                Meizu.Notify({Title = "Tải cấu hình", Content = ok and ("Đã tải: " .. name) or "Không tìm thấy file",
                    Type = ok and "Success" or "Error"})
            end})
        tab:AddButton({Title = "Xóa cấu hình", Callback = function()
                local name = list:Get()
                if not name then return end
                Meizu.DeleteConfig(name)
                Meizu.Notify({Title = "Xóa cấu hình", Content = "Đã xóa: " .. name, Type = "Info"})
                list:Set(Meizu.GetConfigs())
            end})
        return tab
    end

    ------------------------------------------------ Khởi động
    task.spawn(function()
        if options.Splash ~= false then
            pcall(ShowSplash)
            task.wait(1.15)
        end
        pcall(function() setMinimized(false) end)
        task.wait(0.08)
        if firstTab then pcall(function() selectTab(firstTab, true) end) end
        -- BẢO HIỂM: vì lý do gì đó cửa sổ chưa hiện thì ép hiện
        task.delay(0.4, function()
            if not minimized and winFrame.Parent and not winFrame.Visible then
                winFrame.Visible = true
                winFrame.Size = windowSize
                scaler.Size = UDim2.fromScale(1, 1)
                winFrame.Position = winFrame.Position == UDim2.new() and UDim2.fromOffset(vs.X / 2, vs.Y / 2) or winFrame.Position
            end
        end)
    end)

    Window.Gui = Root
    Window._frame = winFrame
    return Window
end

Meizu.CreateGui = Meizu.CreateWindow

function Meizu.Destroy()
    if Root then Root:Destroy() end
    Root, NotifyContainer = nil, nil
end

return Meizu

--[[
==================== VÍ DỤ SỬ DỤNG ====================
local Meizu = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/Meizu.lua"))()

local Window = Meizu.CreateWindow({
    Title = "Meizu Hub",
    SubTitle = "v2.1 · by Nttp1721",
    Theme = "Meizu",
    ToggleKey = Enum.KeyCode.RightShift,
})

local Main = Window:AddTab({Title = "Trang chính"})
Main:AddSection({Title = "Tính năng"})
Main:AddToggle({Title = "Auto Farm", ConfigKey = "autofarm", Callback = print})
Main:AddSlider({Title = "Tốc độ", Min = 16, Max = 200, Default = 16, Suffix = " ws", ConfigKey = "walkspeed"})
Main:AddDropdown({Title = "Vũ khí", Values = {"Kiếm","Súng","Cung"}, ConfigKey = "weapon"})
Main:AddButton({Title = "Bắt đầu", Primary = true, Callback = function() end})

local Set = Window:AddTab({Title = "Cài đặt"})
Set:AddDropdown({Title = "Theme", Values = Meizu.ThemeList(),
    Callback = function(name) Meizu.SetTheme(name) end})

Window:AddConfigTab()
========================================================
]]
