----------------------------------------------------------------------
-- 1. CẤU HÌNH + SERVICES
----------------------------------------------------------------------
local VALID_GAME_ID = 107778070777162

local CONFIG = {
    Name       = "Meizu Hub",
    SubTitle   = "Steal An Eggs",
    Author     = "Nttphu1721",
    Version    = "1.2",
    Discord    = "https://discord.gg/5GynHCJZXr",
    ImageUrl   = "https://i.ibb.co/S7rpHJJN/meizuxp.png", -- ảnh dùng cho toàn bộ script
    ImageFolder = "MeizuHub",
    ImageFile   = "MeizuHub/meizuxp.png",
    MenuKey    = Enum.KeyCode.End,
    SaveFolder = "MeizuHub/StealAnEggs",
}

local Players          = game:GetService("Players")
local StarterGui       = game:GetService("StarterGui")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    task.wait()
    LocalPlayer = Players.LocalPlayer
end

local function Try(fn, ...)
    local ok, result = pcall(fn, ...)
    return ok, result
end

-- Ảnh sau khi tải sẽ nằm ở đây ("" = chưa có / không hỗ trợ)
local Assets = { Logo = "" }

local function SystemNotify(text, duration)
    Try(function()
        local data = {
            Title    = CONFIG.Name,
            Text     = text,
            Duration = duration or 5,
        }
        if Assets.Logo ~= "" then
            data.Icon = Assets.Logo
        end
        StarterGui:SetCore("SendNotification", data)
    end)
end

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
-- 3. CHỐNG CHẠY TRÙNG + TẢI ẢNH PNG TỪ LINK
----------------------------------------------------------------------
local Env = (typeof(getgenv) == "function" and getgenv()) or _G

if Env.MeizuHubLoaded and typeof(Env.MeizuHubUnload) == "function" then
    Try(Env.MeizuHubUnload)
    task.wait(0.2)
end
Env.MeizuHubLoaded = true

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

local Running = true

-- Tải ảnh PNG từ URL -> lưu file -> getcustomasset -> trả về asset dùng được trong Image
-- Trả về "" nếu executor không hỗ trợ hoặc tải lỗi (script vẫn chạy bình thường)
local function LoadImageAsset(url, folder, path)
    local getAsset = getcustomasset or getsynasset
    if typeof(getAsset) ~= "function" or typeof(writefile) ~= "function" then
        warn("[Meizu Hub] Executor không hỗ trợ getcustomasset/writefile -> bỏ qua ảnh.")
        return ""
    end

    local ok, result = pcall(function()
        if typeof(isfolder) == "function" and typeof(makefolder) == "function" then
            if not isfolder(folder) then
                makefolder(folder)
            end
        end

        -- Dùng lại file đã tải nếu còn hợp lệ (header PNG)
        if typeof(isfile) == "function" and typeof(readfile) == "function" and isfile(path) then
            local cached = readfile(path)
            if #cached > 100 and cached:sub(2, 4) == "PNG" then
                return getAsset(path)
            end
        end

        -- Tải mới
        local data
        local okGet, body = pcall(game.HttpGet, game, url)
        if okGet and type(body) == "string" and #body > 100 then
            data = body
        else
            local req = request or http_request or (syn and syn.request)
            if req then
                local res = req({ Url = url, Method = "GET" })
                if res and type(res.Body) == "string" then
                    data = res.Body
                end
            end
        end

        if not data or #data < 100 or data:sub(2, 4) ~= "PNG" then
            error("Tải ảnh thất bại hoặc không phải file PNG")
        end

        writefile(path, data)
        return getAsset(path)
    end)

    if ok and type(result) == "string" and result ~= "" then
        return result
    end
    warn("[Meizu Hub] Lỗi tải ảnh:", tostring(result))
    return ""
end

-- Tải ảnh NGẦM (không chặn loader). Xong thì tự gắn vào logo loader.
local LoaderLogo -- gán ở phần loader bên dưới
local ImageReady = false

task.spawn(function()
    Assets.Logo = LoadImageAsset(CONFIG.ImageUrl, CONFIG.ImageFolder, CONFIG.ImageFile)
    ImageReady = true
    if LoaderLogo and LoaderLogo.Parent and Assets.Logo ~= "" then
        LoaderLogo.Image = Assets.Logo
    end
end)

-- Tải thư viện UI NGẦM song song, trong lúc loader đang chạy
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

local Libs = {}
local LibsPending = 3

local function Prefetch(key, url)
    task.spawn(function()
        local result, err = LoadRemote(url)
        Libs[key] = { result, err }
        LibsPending = LibsPending - 1
    end)
end

Prefetch("Fluent", "https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua")
Prefetch("Save", "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua")
Prefetch("Interface", "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua")

SystemNotify("Loading...", 4)

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
-- (đã rút ngắn: tổng ~2 giây; muốn chậm lại thì tăng số giây ở cột 1)
local LoaderKeyframes = {
    { 0.3, 10 },
    { 0.5, 30 },
    { 0.6, 60 },
    { 0.5, 100 },
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

LoaderLogo = Create("ImageLabel", {
    Name = "Logo",
    Parent = LoaderFrame,
    BackgroundTransparency = 1,
    Image = Assets.Logo, -- "" nếu không tải được
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

Tween(LoaderFrame, 0.25, { Size = UDim2.new(0, 346, 0, 132) })
task.wait(0.3)
Tween(LoaderTitle, 0.5, { TextTransparency = 0 })
Tween(ProgressBG, 0.5, { BackgroundTransparency = 0 })
Tween(ProgressBar, 0.5, { BackgroundTransparency = 0 })

for index, data in ipairs(LoaderKeyframes) do
    task.wait(data[1])
    UpdateLoader(data[2], index)
end

UpdateLoader(100, 4)
task.wait(0.8)

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
-- Thư viện đã được tải ngầm từ lúc loader bắt đầu, ở đây chỉ chờ cho xong (tối đa 20s)
local waited = 0
while LibsPending > 0 and waited < 20 do
    task.wait(0.05)
    waited = waited + 0.05
end

local Fluent, errFluent = unpack(Libs.Fluent or {})
local SaveManager, errSave = unpack(Libs.Save or {})
local InterfaceManager, errInterface = unpack(Libs.Interface or {})

if not Fluent or not SaveManager or not InterfaceManager then
    warn("[Meizu Hub] Không tải được thư viện UI:",
        errFluent or errSave or errInterface)
    SystemNotify("Lỗi tải thư viện UI! Hãy thử chạy lại script.", 6)
    Env.MeizuHubLoaded = false
    return
end

-- Lưu hàm Destroy gốc của Fluent (chỉ dùng khi Unload thật sự)
local RealFluentDestroy = Fluent.Destroy

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

Tabs.Main:AddSection("Tính năng chính")

local MainToggle = Tabs.Main:AddToggle("MainToggle", {
    Title   = "Enable Main Feature",
    Default = false,
})

MainToggle:OnChanged(function(value)
    -- TODO: thêm logic bật/tắt tính năng chính tại đây
    print("[Meizu Hub] Main feature:", value)
end)

-- Vòng lặp mẫu (tự dừng khi unload)
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
    Description = "Tắt hẳn script (xoá cả nút tròn bên trái)",
    Callback    = function()
        Window:Dialog({
            Title   = "Unload Script",
            Content = "Bạn có chắc muốn tắt hẳn script không?",
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
-- 9A. ẨN / HIỆN MENU + CHẶN NÚT X (X = ẨN, KHÔNG HUỶ)
----------------------------------------------------------------------
local function IsMenuHidden()
    return Window.Minimized == true
end

local function HideMenu()
    if not IsMenuHidden() then
        Try(function() Window:Minimize() end)
    end
end

local function ShowMenu()
    if IsMenuHidden() then
        Try(function() Window:Minimize() end)
    end
end

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

-- Cách 1: chặn hộp thoại "Close" của Fluent -> bấm X là ẩn menu luôn
local OriginalDialog = Window.Dialog
Window.Dialog = function(self, config, ...)
    if type(config) == "table" and config.Title == "Close" then
        HideMenu()
        return
    end
    return OriginalDialog(self, config, ...)
end

-- Cách 2 (dự phòng): nếu Fluent vẫn gọi Destroy thì chỉ ẩn menu, không huỷ
-- (Unload thật dùng RealFluentDestroy ở bên dưới)
Fluent.Destroy = function()
    if Running then
        HideMenu()
    else
        Try(function() RealFluentDestroy(Fluent) end)
    end
end

----------------------------------------------------------------------
-- 9B. NÚT TRÒN BÊN TRÁI (BẤM ĐỂ MỞ/ĐÓNG MENU - KHÔNG BAO GIỜ MẤT)
----------------------------------------------------------------------
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

local CreateToggleButton

local function Respawn()
    if Running then
        task.defer(CreateToggleButton)
    end
end

CreateToggleButton = function()
    if not Running then return end

    -- Giữ lại vị trí nếu người chơi đã kéo nút đi chỗ khác
    local lastPosition = TOGGLE_POSITION
    if ToggleButton and ToggleButton.Parent then
        lastPosition = ToggleButton.Position
    end

    DisconnectToggleConnections()
    if ToggleGui then
        Try(function() ToggleGui:Destroy() end)
    end

    ToggleGui = Create("ScreenGui", {
        Name = "MeizuToggleGui",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 1000,
        Parent = GetGuiParent(),
    })

    ToggleButton = Create("ImageButton", {
        Name = "MeizuToggleButton",
        Parent = ToggleGui,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0), -- nền đen
        BackgroundTransparency = 0,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = lastPosition,
        Size = TOGGLE_SIZE,
        Image = Assets.Logo, -- ảnh PNG từ link
        AutoButtonColor = true,
    })
    Create("UICorner", { Parent = ToggleButton })

    -- Nếu không tải được ảnh thì hiện chữ "M" để nút vẫn nhìn thấy và bấm được
    if Assets.Logo == "" then
        Create("TextLabel", {
            Name = "Fallback",
            Parent = ToggleButton,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = "M",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 24,
        })
    end

    -- Bấm = mở/đóng menu; kéo = di chuyển nút
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

    -- Bị xoá bởi game/anti-cheat -> tự tạo lại ngay
    table.insert(ToggleConnections, ToggleGui.Destroying:Connect(Respawn))
    table.insert(ToggleConnections, ToggleButton.Destroying:Connect(Respawn))
end

-- Chờ ảnh tải xong (tối đa 5s) để nút tròn có hình ngay từ đầu
local imageWaited = 0
while not ImageReady and imageWaited < 5 do
    task.wait(0.1)
    imageWaited = imageWaited + 0.1
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

Maid:Give(LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Running and (not ToggleGui or not ToggleGui.Parent) then
        CreateToggleButton()
    end
end))

----------------------------------------------------------------------
-- UNLOAD (tắt hẳn script, dọn sạch mọi thứ)
----------------------------------------------------------------------
Env.MeizuHubUnload = function()
    Running = false
    DisconnectToggleConnections()
    Maid:Clean()
    Try(function() if ToggleGui then ToggleGui:Destroy() end end)
    Try(function() RealFluentDestroy(Fluent) end)
    Env.MeizuHubLoaded = false
    Env.MeizuHubUnload = nil
    Env.MeizuHub = nil
end

----------------------------------------------------------------------
-- BIẾN TOÀN CỤC (để truy cập từ code thêm sau này)
----------------------------------------------------------------------
Env.MeizuHub = {
    Version   = CONFIG.Version,
    PlaceId   = game.PlaceId,
    Author    = CONFIG.Author,
    Config    = CONFIG,
    Assets    = Assets,
    Window    = Window,
    Tabs      = Tabs,
    Options   = Options,
    Fluent    = Fluent,
    Notify    = Notify,
    Maid      = Maid,
    ShowMenu  = ShowMenu,
    HideMenu  = HideMenu,
    IsRunning = function() return Running end,
}
_G.MeizuHub = Env.MeizuHub

----------------------------------------------------------------------
-- KHU VỰC CODE CHÍNH CỦA BẠN (thêm logic quan trọng vào đây)
----------------------------------------------------------------------
-- Gợi ý:
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
