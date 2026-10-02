--[[
    Meizu Hub - Steal An Eggs
    Script by: Nttphu1721
    Phiên bản: 1.1 (khung sườn / skeleton)

    CẤU TRÚC FILE:
      1. Cấu hình + Services
      2. Kiểm tra PlaceId (sai game -> shutdown ngay)
      3. Chống chạy trùng script
      4. Loader (hiệu ứng tải)
      5. Tải thư viện Fluent
      6. Tạo Window + Tabs
      7. UI từng tab (có chỗ TODO để bạn thêm code)
      8. SaveManager / InterfaceManager
      9. Nút tròn bên trái (bấm để mở/đóng menu, không bao giờ mất)
     10. Fluent Notify báo đã tải xong
]]

----------------------------------------------------------------------
-- 1. CẤU HÌNH + SERVICES
----------------------------------------------------------------------
local VALID_GAME_ID = 107778070777162

local CONFIG = {
    Name       = "Meizu Hub",
    SubTitle   = "Steal An Eggs",
    Author     = "Nttphu1721",
    Version    = "1.1",
    Discord    = "https://discord.gg/5GynHCJZXr",
    LogoAsset  = "rbxassetid://94377325741905",  -- logo dùng cho thông báo/loader
    ToggleIcon = "rbxassetid://94377325741905", -- hình nút tròn bên góc trái (giữ nguyên)
    MenuKey    = Enum.KeyCode.End,
    SaveFolder = "MeizuHub/StealAnEggs",
}

local Players          = game:GetService("Players")
local StarterGui       = game:GetService("StarterGui")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    task.wait()
    LocalPlayer = Players.LocalPlayer
end

-- Helper: gọi an toàn
local function Try(fn, ...)
    local ok, result = pcall(fn, ...)
    return ok, result
end

-- Helper: gửi thông báo hệ thống Roblox
local function SystemNotify(text, duration)
    Try(function()
        StarterGui:SetCore("SendNotification", {
            Title    = CONFIG.Name,
            Text     = text,
            Icon     = CONFIG.LogoAsset,
            Duration = duration or 5,
        })
    end)
end

-- Helper: chọn nơi đặt GUI an toàn nhất
local function GetGuiParent()
    local ok, parent = pcall(function()
        if typeof(gethui) == "function" then
            return gethui()
        end
        return CoreGui
    end)
    if ok and parent then
        return parent
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

----------------------------------------------------------------------
-- 2. KIỂM TRA GAME ID  (sai game -> shutdown NGAY LẬP TỨC)
----------------------------------------------------------------------
if game.PlaceId ~= VALID_GAME_ID then
    SystemNotify("Script chỉ dành cho Steal An Eggs!", 3)
    game:Shutdown()
    return
end

----------------------------------------------------------------------
-- 3. CHỐNG CHẠY TRÙNG SCRIPT
----------------------------------------------------------------------
local Env = (typeof(getgenv) == "function" and getgenv()) or _G

if Env.MeizuHubLoaded and typeof(Env.MeizuHubUnload) == "function" then
    Try(Env.MeizuHubUnload)
    task.wait(0.2)
end
Env.MeizuHubLoaded = true

-- Maid: gom connection / instance để dọn khi unload
local Maid = { _tasks = {} }
function Maid:Give(item)
    table.insert(self._tasks, item)
    return item
end
function Maid:Clean()
    for _, item in ipairs(self._tasks) do
        local t = typeof(item)
        if t == "RBXScriptConnection" then
            Try(function() item:Disconnect() end)
        elseif t == "Instance" then
            Try(function() item:Destroy() end)
        elseif t == "function" then
            Try(item)
        end
    end
    table.clear(self._tasks)
end

local Running = true -- cờ để dừng các vòng lặp khi unload

SystemNotify("Loading...", 9)

----------------------------------------------------------------------
-- 4. LOADER (HIỆU ỨNG TẢI)
----------------------------------------------------------------------
local LoaderColors = {
    Main             = Color3.fromRGB(0, 0, 0),
    Topic            = Color3.fromRGB(200, 200, 200),
    Title            = Color3.fromRGB(255, 255, 255),
    LoaderBackground = Color3.fromRGB(40, 40, 40),
    LoaderSplash     = Color3.fromRGB(3, 252, 3),
}

-- {thời gian chờ (giây), phần trăm}
local LoaderKeyframes = {
    { 1, 10 },
    { 2, 30 },
    { 3, 60 },
    { 2, 100 },
}

local StepMessages = {
    [1] = "Meizu Hub",
    [2] = "Meizu Hub",
    [3] = "Meizu Hub.",
    [4] = "Thanks For Using Meizu!",
}

local function Tween(object, duration, properties)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
        properties
    )
    tween:Play()
    return tween
end

local function Create(className, properties)
    local obj = Instance.new(className)
    local parent
    for prop, value in pairs(properties) do
        if prop == "Parent" then
            parent = value
        else
            obj[prop] = value
        end
    end
    obj.Parent = parent
    return obj
end

local function AddCorner(radius, parent)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius),
        Parent = parent,
    })
end

local LoaderGui = Create("ScreenGui", {
    Name = "MeizuLoader",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 999,
    Parent = GetGuiParent(),
})

local LoaderFrame = Create("Frame", {
    Name = "Main",
    Parent = LoaderGui,
    BackgroundColor3 = LoaderColors.Main,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, 0, 0, 0),
})
AddCorner(12, LoaderFrame)

local LoaderLogo = Create("ImageLabel", {
    Name = "Logo",
    Parent = LoaderFrame,
    BackgroundTransparency = 1,
    Image = CONFIG.LogoAsset,
    Position = UDim2.new(0, 15, 0, 10),
    Size = UDim2.new(0, 50, 0, 50),
})
AddCorner(25, LoaderLogo)

Create("TextLabel", {
    Name = "HubName",
    Parent = LoaderFrame,
    BackgroundTransparency = 1,
    Text = CONFIG.Name,
    Position = UDim2.new(0, 75, 0, 10),
    Size = UDim2.new(0, 200, 0, 50),
    Font = Enum.Font.GothamBold,
    TextColor3 = LoaderColors.Title,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local LoaderTitle = Create("TextLabel", {
    Name = "Title",
    Parent = LoaderFrame,
    TextTransparency = 1,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 66),
    Size = UDim2.new(1, -30, 0, 18),
    Font = Enum.Font.Gotham,
    RichText = true,
    Text = "<b>Thanks For Using Meizu</b>",
    TextColor3 = LoaderColors.Title,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local ProgressBG = Create("Frame", {
    Name = "BG",
    Parent = LoaderFrame,
    AnchorPoint = Vector2.new(0.5, 0),
    BackgroundTransparency = 1,
    BackgroundColor3 = LoaderColors.LoaderBackground,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, 0, 0, 90),
    Size = UDim2.new(0.9, 0, 0, 14),
})
AddCorner(7, ProgressBG)

local ProgressBar = Create("Frame", {
    Name = "Progress",
    Parent = ProgressBG,
    BackgroundColor3 = LoaderColors.LoaderSplash,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 0, 1, 0),
})
AddCorner(7, ProgressBar)

local StepLabel = Create("TextLabel", {
    Name = "StepLabel",
    Parent = LoaderFrame,
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 108),
    Size = UDim2.new(1, -20, 0, 18),
    Font = Enum.Font.Gotham,
    Text = "",
    TextColor3 = LoaderColors.Topic,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Center,
})

local function UpdateLoader(percent, step)
    Tween(ProgressBar, 0.5, { Size = UDim2.new(percent / 100, 0, 1, 0) })
    StepLabel.Text = StepMessages[step] or ""
end

-- Mở loader
Tween(LoaderFrame, 0.25, { Size = UDim2.new(0, 346, 0, 132) })
task.wait(0.3)
Tween(LoaderTitle, 0.5, { TextTransparency = 0 })
Tween(ProgressBG, 0.5, { BackgroundTransparency = 0 })
Tween(ProgressBar, 0.5, { BackgroundTransparency = 0 })

-- Chạy từng mốc (dùng ipairs để đúng thứ tự)
for index, data in ipairs(LoaderKeyframes) do
    task.wait(data[1])
    UpdateLoader(data[2], index)
end

UpdateLoader(100, 4)
task.wait(0.8)

-- Đóng loader
Tween(LoaderTitle, 0.5, { TextTransparency = 1 })
Tween(ProgressBG, 0.5, { BackgroundTransparency = 1 })
Tween(ProgressBar, 0.5, { BackgroundTransparency = 1 })
task.wait(0.5)
Tween(LoaderFrame, 0.25, { Size = UDim2.new(0, 0, 0, 0) })
task.wait(0.3)
LoaderGui:Destroy()

----------------------------------------------------------------------
-- 5. TẢI THƯ VIỆN FLUENT
----------------------------------------------------------------------
local function LoadRemote(url)
    local okGet, source = pcall(game.HttpGet, game, url)
    if not okGet then
        return nil, "HttpGet lỗi: " .. tostring(source)
    end
    local fn, compileErr = loadstring(source)
    if not fn then
        return nil, "loadstring lỗi: " .. tostring(compileErr)
    end
    local okRun, result = pcall(fn)
    if not okRun then
        return nil, "Chạy thư viện lỗi: " .. tostring(result)
    end
    return result
end

local Fluent, errFluent = LoadRemote("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua")
local SaveManager, errSave = LoadRemote("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua")
local InterfaceManager, errInterface = LoadRemote("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua")

if not Fluent or not SaveManager or not InterfaceManager then
    warn("[Meizu Hub] Không tải được thư viện UI:",
        errFluent or errSave or errInterface)
    SystemNotify("Lỗi tải thư viện UI! Hãy thử chạy lại script.", 6)
    Env.MeizuHubLoaded = false
    return
end

----------------------------------------------------------------------
-- 6. TẠO WINDOW + TABS
----------------------------------------------------------------------
local Window = Fluent:CreateWindow({
    Title       = CONFIG.Name,
    SubTitle    = CONFIG.SubTitle,
    TabWidth    = 160,
    Size        = UDim2.fromOffset(530, 350),
    Acrylic     = false,
    Theme       = "Dark",
    MinimizeKey = CONFIG.MenuKey,
})

local Tabs = {
    Author = Window:AddTab({ Title = "Author", Icon = "user" }),
    Main   = Window:AddTab({ Title = "Main",   Icon = "home" }),
    ESP    = Window:AddTab({ Title = "ESP",    Icon = "eye" }),
    Misc   = Window:AddTab({ Title = "Misc",   Icon = "settings" }),
}

local Options = Fluent.Options

local function Notify(text, title, duration)
    Fluent:Notify({
        Title    = title or CONFIG.Name,
        Content  = text,
        Duration = duration or 4,
    })
end

----------------------------------------------------------------------
-- 7. UI TỪNG TAB
----------------------------------------------------------------------

-- ============================== AUTHOR ==============================
Tabs.Author:AddParagraph({
    Title   = "Thông tin",
    Content = "Script by " .. CONFIG.Author .. "\nGame: " .. CONFIG.SubTitle
        .. "\nVersion: " .. CONFIG.Version,
})

Tabs.Author:AddButton({
    Title       = "Copy Discord",
    Description = CONFIG.Discord,
    Callback    = function()
        local ok = pcall(function()
            setclipboard(CONFIG.Discord)
        end)
        if ok then
            Notify("Đã sao chép link Discord vào clipboard.", "Success", 3)
        else
            Notify("Executor không hỗ trợ setclipboard.\n" .. CONFIG.Discord, "Error", 5)
        end
    end,
})

-- ============================== MAIN ================================
Tabs.Main:AddParagraph({
    Title   = "Main",
    Content = "Khu vực dành cho các tính năng chính của script.",
})

local MainSection = Tabs.Main:AddSection("Tính năng chính")

local MainToggle = Tabs.Main:AddToggle("MainToggle", {
    Title    = "Enable Main Feature",
    Default  = false,
})

MainToggle:OnChanged(function(value)
    -- TODO: thêm logic bật/tắt tính năng chính tại đây
    print("[Meizu Hub] Main feature:", value)
end)

-- Ví dụ vòng lặp chuẩn (tự dừng khi tắt toggle hoặc khi unload):
task.spawn(function()
    while Running do
        if Options.MainToggle and Options.MainToggle.Value then
            -- TODO: code lặp của bạn đặt ở đây
        end
        task.wait(0.25)
    end
end)

Tabs.Main:AddButton({
    Title       = "Example Button",
    Description = "Nút mẫu để bạn thêm logic sau này",
    Callback    = function()
        -- TODO: logic của nút
        Notify("Tính năng mẫu đang được phát triển.", "Info", 3)
    end,
})

-- =============================== ESP ================================
Tabs.ESP:AddParagraph({
    Title   = "ESP",
    Content = "Khu vực chứa các chức năng ESP, highlight, line, box, v.v.",
})

local ESPToggle = Tabs.ESP:AddToggle("ESPToggle", {
    Title   = "Enable ESP",
    Default = false,
})

ESPToggle:OnChanged(function(value)
    -- TODO: bật/tắt ESP tại đây
    print("[Meizu Hub] ESP enabled:", value)
end)

local ESPSlider = Tabs.ESP:AddSlider("ESPDistance", {
    Title    = "ESP Distance",
    Min      = 10,
    Max      = 500,
    Default  = 100,
    Rounding = 1,
})

ESPSlider:OnChanged(function(value)
    -- TODO: cập nhật khoảng cách ESP tại đây
    print("[Meizu Hub] ESP Distance:", value)
end)

-- =============================== MISC ===============================
Tabs.Misc:AddParagraph({
    Title   = "Misc",
    Content = "Tùy chọn phụ trợ, cài đặt lưu trữ và tiện ích khác.",
})

Tabs.Misc:AddToggle("AutoSave", {
    Title    = "Auto Save",
    Default  = true,
    Callback = function(value)
        print("[Meizu Hub] AutoSave:", value)
    end,
})

Tabs.Misc:AddButton({
    Title       = "Clear Settings",
    Description = "Xoá cài đặt đã lưu",
    Callback    = function()
        -- TODO: thêm logic xoá config nếu cần
        Notify("Tính năng clear settings sẽ được cài sau.", "Info", 3)
    end,
})

Tabs.Misc:AddButton({
    Title       = "Unload Script",
    Description = "Tắt hoàn toàn script (sẽ xoá cả nút tròn bên trái)",
    Callback    = function()
        Window:Dialog({
            Title   = "Unload Script",
            Content = "Bạn có chắc muốn tắt script không?",
            Buttons = {
                {
                    Title    = "Có",
                    Callback = function()
                        if typeof(Env.MeizuHubUnload) == "function" then
                            Env.MeizuHubUnload()
                        end
                    end,
                },
                { Title = "Không", Callback = function() end },
            },
        })
    end,
})

----------------------------------------------------------------------
-- 8. SAVEMANAGER + INTERFACEMANAGER
----------------------------------------------------------------------
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("MeizuHub")
SaveManager:SetFolder(CONFIG.SaveFolder)

InterfaceManager:BuildInterfaceSection(Tabs.Misc)
SaveManager:BuildConfigSection(Tabs.Misc)

Window:SelectTab(1)

----------------------------------------------------------------------
-- 9. NÚT TRÒN BÊN TRÁI (BẤM ĐỂ MỞ/ĐÓNG MENU - KHÔNG BAO GIỜ MẤT)
----------------------------------------------------------------------
-- Mở/đóng menu Fluent
local function ToggleMenu()
    local ok = pcall(function()
        Window:Minimize()
    end)
    if not ok then
        -- Dự phòng: giả lập phím End
        Try(function()
            local vim = game:GetService("VirtualInputManager")
            vim:SendKeyEvent(true, CONFIG.MenuKey, false, game)
            task.wait()
            vim:SendKeyEvent(false, CONFIG.MenuKey, false, game)
        end)
    end
end

-- Vị trí gốc (giữ nguyên như bản cũ)
local TOGGLE_POSITION = UDim2.new(0.120833337 - 0.1, 0, 0.0952890813 + 0.01, 0)
local TOGGLE_SIZE = UDim2.new(0, 50, 0, 50)

local ToggleGui, ToggleButton
local ToggleConnections = {}

local function DisconnectToggleConnections()
    for _, conn in ipairs(ToggleConnections) do
        Try(function() conn:Disconnect() end)
    end
    table.clear(ToggleConnections)
end

local CreateToggleButton -- khai báo trước để dùng trong hàm tự hồi sinh

local function Respawn()
    if Running then
        task.defer(CreateToggleButton)
    end
end

CreateToggleButton = function()
    if not Running then return end

    -- Dọn bản cũ (nếu còn)
    DisconnectToggleConnections()
    if ToggleGui then
        Try(function() ToggleGui:Destroy() end)
    end

    ToggleGui = Create("ScreenGui", {
        Name = "MeizuToggleGui",
        ResetOnSpawn = false,                       -- không mất khi chết/respawn
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 1000,
        IgnoreGuiInset = false,
        Parent = GetGuiParent(),
    })

    ToggleButton = Create("ImageButton", {
        Name = "MeizuToggleButton",
        Parent = ToggleGui,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = TOGGLE_POSITION,
        Size = TOGGLE_SIZE,
        Image = CONFIG.ToggleIcon,
        AutoButtonColor = true,
    })
    Create("UICorner", { Parent = ToggleButton })

    -- Bấm = mở/đóng menu; kéo = di chuyển nút (phân biệt bằng ngưỡng kéo)
    local dragging, dragStart, startPos, moved = false, nil, nil, false
    local DRAG_THRESHOLD = 6

    table.insert(ToggleConnections, ToggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = ToggleButton.Position
        end
    end))

    table.insert(ToggleConnections, UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            if delta.Magnitude >= DRAG_THRESHOLD then
                moved = true
            end
            if moved then
                ToggleButton.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end
    end))

    table.insert(ToggleConnections, UserInputService.InputEnded:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if not moved then
                ToggleMenu()
            end
        end
    end))

    -- Nếu bị xoá bởi game/anti-cheat -> tự tạo lại ngay
    table.insert(ToggleConnections, ToggleGui.Destroying:Connect(Respawn))
    table.insert(ToggleConnections, ToggleButton.Destroying:Connect(Respawn))
end

CreateToggleButton()

-- Watchdog: mỗi 0.5 giây kiểm tra, mất là dựng lại
task.spawn(function()
    while Running do
        task.wait(0.5)
        if Running then
            local gone = (not ToggleGui)
                or (not ToggleGui.Parent)
                or (not ToggleButton)
                or (not ToggleButton.Parent)
                or (not ToggleButton.Visible)
            if gone then
                CreateToggleButton()
            end
        end
    end
end)

-- Hồi sinh nút khi nhân vật respawn (phòng trường hợp GUI nằm ở PlayerGui)
Maid:Give(LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Running and (not ToggleGui or not ToggleGui.Parent) then
        CreateToggleButton()
    end
end))

----------------------------------------------------------------------
-- UNLOAD (dọn sạch mọi thứ khi tắt script)
----------------------------------------------------------------------
Env.MeizuHubUnload = function()
    Running = false
    DisconnectToggleConnections()
    Maid:Clean()
    Try(function() if ToggleGui then ToggleGui:Destroy() end end)
    Try(function() Fluent:Destroy() end)
    Env.MeizuHubLoaded = false
    Env.MeizuHubUnload = nil
    Env.MeizuHub = nil
end

----------------------------------------------------------------------
-- BIẾN TOÀN CỤC (để bạn truy cập từ các phần code thêm sau này)
----------------------------------------------------------------------
Env.MeizuHub = {
    Version  = CONFIG.Version,
    PlaceId  = game.PlaceId,
    Author   = CONFIG.Author,
    Config   = CONFIG,
    Window   = Window,
    Tabs     = Tabs,
    Options  = Options,
    Fluent   = Fluent,
    Notify   = Notify,
    Maid     = Maid,
    IsRunning = function() return Running end,
}
_G.MeizuHub = Env.MeizuHub

----------------------------------------------------------------------
-- KHU VỰC CODE CHÍNH CỦA BẠN (thêm logic quan trọng vào đây)
----------------------------------------------------------------------
-- Gợi ý:
--   local Player = LocalPlayer
--   local function MainLoop()
--       while Running do
--           -- TODO: code của bạn
--           task.wait(0.25)
--       end
--   end
--   task.spawn(MainLoop)
--
-- Nhớ dùng Maid:Give(connection) cho mọi connection để unload dọn sạch.

----------------------------------------------------------------------
-- 10. FLUENT NOTIFY: BÁO ĐÃ TẢI XONG, SẴN SÀNG CHẠY
----------------------------------------------------------------------
Fluent:Notify({
    Title      = CONFIG.Name,
    Content    = "Loading Successfully! Script đã tải xong và sẵn sàng chạy.",
    SubContent = "Script By " .. CONFIG.Author,
    Duration   = 6,
})
