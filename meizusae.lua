--[[
    Meizu Hub - Steal An Eggs
    Script by: Nttphu1721
]]

local VALID_GAME_ID = 107778070777162

-- Kiểm tra game ID ngay khi khởi động
if game.PlaceId ~= VALID_GAME_ID then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Meizu Hub",
        Text = "Script Cho Steal An Eggs!",
        Icon = "rbxassetid://94377325741905",
        Duration = 5
    })
    wait(1.5)
    game:Shutdown()
    return
end

-- Thông báo bắt đầu load
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Meizu Hub",
    Text = "Loading...",
    Icon = "rbxassetid://94377325741905",
    Duration = 9
})

shared.LoaderTitle = "Thanks For Using Meizu"
shared.LoaderKeyFrames = {
    [1] = {1, 10},
    [2] = {2, 30},
    [3] = {3, 60},
    [4] = {2, 100}
}

local LoaderConfig = {
    LoaderData = {
        Name = shared.LoaderTitle or "A Loader",
        Colors = shared.LoaderColors or {
            Main = Color3.fromRGB(0, 0, 0),
            Topic = Color3.fromRGB(200, 200, 200),
            Title = Color3.fromRGB(255, 255, 255),
            LoaderBackground = Color3.fromRGB(40, 40, 40),
            LoaderSplash = Color3.fromRGB(3, 252, 3)
        }
    },
    Keyframes = shared.LoaderKeyFrames or {
        [1] = {1, 10},
        [2] = {2, 30},
        [3] = {3, 60},
        [4] = {2, 100}
    }
}
local StepMessages = {
    [1] = "Meizu Hub",
    [2] = "Meizu Hub",
    [3] = "Meizu Hub.",
    [4] = "Thanks For Using Meizu!"
}


local function TweenObject(Object, Duration, Properties)
    local Tween = game.TweenService:Create(
        Object,
        TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
        Properties
    )
    Tween:Play()
end

local function CreateObject(ClassName, Properties)
    local NewObject = Instance.new(ClassName)
    local ParentObject

    for PropertyName, Value in pairs(Properties) do
        if PropertyName ~= "Parent" then
            NewObject[PropertyName] = Value
        else
            ParentObject = Value
        end
    end

    NewObject.Parent = ParentObject
    return NewObject
end

local function AddCorner(Radius, Parent)
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, Radius)
    Corner.Parent = Parent
    return Corner
end

local ScreenGui = CreateObject("ScreenGui", {
    Name = "MeizuLoader",
    Parent = game.CoreGui,
    ResetOnSpawn = false
})

local LoaderFrame = CreateObject("Frame", {
    Name = "Main",
    Parent = ScreenGui,
    BackgroundColor3 = LoaderConfig.LoaderData.Colors.Main,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 0, 0, 0)
})
AddCorner(12, LoaderFrame)

local UserImage = CreateObject("ImageLabel", {
    Name = "UserImage",
    Parent = LoaderFrame,
    BackgroundTransparency = 1,
    Image = "rbxassetid://94377325741905",
    Position = UDim2.new(0, 15, 0, 10),
    Size = UDim2.new(0, 50, 0, 50)
})
AddCorner(25, UserImage)

local UserName = CreateObject("TextLabel", {
    Name = "UserName",
    Parent = LoaderFrame,
    BackgroundTransparency = 1,
    Text = "Meizu Hub",
    Position = UDim2.new(0, 75, 0, 10),
    Size = UDim2.new(0, 200, 0, 50),
    Font = Enum.Font.GothamBold,
    TextColor3 = LoaderConfig.LoaderData.Colors.Title,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
})

local LoaderTop = CreateObject("TextLabel", {
    Name = "Top",
    Parent = LoaderFrame,
    TextTransparency = 1,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 30, 0, 70),
    Size = UDim2.new(0, 301, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "Loader",
    TextColor3 = LoaderConfig.LoaderData.Colors.Topic,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left
})

local LoaderTitleLabel = CreateObject("TextLabel", {
    Name = "Title",
    Parent = LoaderFrame,
    TextTransparency = 1,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 30, 0, 90),
    Size = UDim2.new(0, 301, 0, 46),
    Font = Enum.Font.Gotham,
    RichText = true,
    Text = "<b>" .. LoaderConfig.LoaderData.Name .. "</b>",
    TextColor3 = LoaderConfig.LoaderData.Colors.Title,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
})

local ProgressBackground = CreateObject("Frame", {
    Name = "BG",
    Parent = LoaderFrame,
    AnchorPoint = Vector2.new(0.5, 0),
    BackgroundTransparency = 1,
    BackgroundColor3 = LoaderConfig.LoaderData.Colors.LoaderBackground,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, 0, 0, 70),
    Size = UDim2.new(0.85, 0, 0, 24)
})
AddCorner(8, ProgressBackground)

local ProgressBar = CreateObject("Frame", {
    Name = "Progress",
    Parent = ProgressBackground,
    BackgroundColor3 = LoaderConfig.LoaderData.Colors.LoaderSplash,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 0, 0, 24)
})
AddCorner(8, ProgressBar)

local StepLabel = CreateObject("TextLabel", {
    Name = "StepLabel",
    Parent = LoaderFrame,
    BackgroundTransparency = 1,
    Position = UDim2.new(0.5, 0, 1, -25),
    Size = UDim2.new(1, -20, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "",
    TextColor3 = LoaderConfig.LoaderData.Colors.Topic,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Center,
    AnchorPoint = Vector2.new(0.5, 0.5)
})

local function UpdateStepText(StepNumber)
    StepLabel.Text = StepMessages[StepNumber] or ""
end

local function UpdatePercentage(Percent, StepNumber)
    TweenObject(ProgressBar, 0.5, {
        Size = UDim2.new(Percent / 100, 0, 0, 24)
    })
    UpdateStepText(StepNumber)
end

TweenObject(LoaderFrame, 0.25, {
    Size = UDim2.new(0, 346, 0, 121)
})
wait()

TweenObject(LoaderTop, 0.5, {TextTransparency = 0})
TweenObject(LoaderTitleLabel, 0.5, {TextTransparency = 0})
TweenObject(ProgressBackground, 0.5, {BackgroundTransparency = 0})
TweenObject(ProgressBar, 0.5, {BackgroundTransparency = 0})

for Index, Data in pairs(LoaderConfig.Keyframes) do
    wait(Data[1])
    UpdatePercentage(Data[2], Index)
end

UpdatePercentage(100, 4)

wait(0.8)
TweenObject(LoaderTop, 0.5, {TextTransparency = 1})
TweenObject(LoaderTitleLabel, 0.5, {TextTransparency = 1})
TweenObject(ProgressBackground, 0.5, {BackgroundTransparency = 1})
TweenObject(ProgressBar, 0.5, {BackgroundTransparency = 1})
wait(0.5)
TweenObject(LoaderFrame, 0.25, {Size = UDim2.new(0, 0, 0, 0)})
wait(0.25)
ScreenGui:Destroy()

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Meizu Hub",
    SubTitle = "Steal An Eggs",
    TabWidth = 160,
    Size = UDim2.fromOffset(530, 350),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.End
})

local Tabs = {
    Author = Window:AddTab({Title = "Author", Icon = ""}),
    Main = Window:AddTab({Title = "Main", Icon = ""}),
    ESP = Window:AddTab({Title = "ESP", Icon = ""}),
    Misc = Window:AddTab({Title = "Misc", Icon = ""})
}

local Options = Fluent.Options

local function Notify(Text, Title, Duration)
    Fluent:Notify({
        Title = Title or "Meizu Hub",
        Content = Text,
        Duration = Duration or 4
    })
end

-- Tab Author
Tabs.Author:AddParagraph({
    Title = "Thông tin",
    Content = "Script by Nttphu1721.\nSteal An Eggs."
})

Tabs.Author:AddButton({
    Title = "Copy Credit",
    Description = "Sao chép tên tác giả",
    Callback = function()
        setclipboard("Nttphu1721")
        Notify("Đã sao chép tên tác giả vào clipboard.", "Success", 3)
    end
})

-- Tab Main
Tabs.Main:AddParagraph({
    Title = "Main",
    Content = "Khu vực dành cho các tính năng chính của script. Bạn có thể thêm logic mới ở đây."
})

Tabs.Main:AddToggle("MainToggle", {
    Title = "Enable Main Feature",
    Default = false,
    Callback = function(Value)
        print("Main feature:", Value)
    end
})

Tabs.Main:AddButton({
    Title = "Example Button",
    Description = "Nút mẫu để bạn thêm logic sau này",
    Callback = function()
        Notify("Tính năng mẫu đang được phát triển.", "Info", 3)
    end
})

-- Tab ESP
Tabs.ESP:AddParagraph({
    Title = "ESP",
    Content = "Khu vực này sẽ chứa các chức năng ESP, highlight, line, box, v.v."
})

Tabs.ESP:AddToggle("ESPToggle", {
    Title = "Enable ESP",
    Default = false,
    Callback = function(Value)
        print("ESP enabled:", Value)
    end
})

Tabs.ESP:AddSlider("ESPDistance", {
    Title = "ESP Distance",
    Min = 10,
    Max = 500,
    Default = 100,
    Rounding = 1,
    Callback = function(Value)
        print("ESP Distance:", Value)
    end
})

-- Tab Misc
Tabs.Misc:AddParagraph({
    Title = "Misc",
    Content = "Tùy chọn phụ trợ, cài đặt lưu trữ và tiện ích khác."
})

Tabs.Misc:AddToggle("AutoSave", {
    Title = "Auto Save",
    Default = true,
    Callback = function(Value)
        print("AutoSave:", Value)
    end
})

Tabs.Misc:AddButton({
    Title = "Clear Settings",
    Description = "Xoá cài đặt đã lưu",
    Callback = function()
        Notify("Tính năng clear settings sẽ được cài sau.", "Info", 3)
    end
})

-- SaveManager + InterfaceManager setup
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:BuildInterfaceSection(Tabs.Misc)
SaveManager:BuildConfigSection(Tabs.Misc)

Window:SelectTab(1)
local a=Instance.new("ScreenGui")local b=Instance.new("ImageButton")local c=Instance.new("UICorner")a.Parent=game.Players.LocalPlayer:WaitForChild("PlayerGui")a.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;b.Parent=a;b.BackgroundColor3=Color3.fromRGB(255,255,255)b.BorderColor3=Color3.fromRGB(0,0,0)b.BorderSizePixel=0;b.Position=UDim2.new(0.120833337 - 0.1, 0, 0.0952890813 + 0.01, 0)b.Size=UDim2.new(0,50,0,50)b.Image="rbxassetid://132336058081263"c.Parent=b;local function d()local e=Instance.new('LocalScript',b)e.Parent.MouseButton1Click:Connect(function()game:GetService("VirtualInputManager"):SendKeyEvent(true,Enum.KeyCode.End,false,game)end)end;coroutine.wrap(d)()
Fluent:Notify({
    Title = "Meizu Hub",
    Content = "Loading Successfully!",
    SubContent = "Script By Nttphu1721",
    Duration = 5
})

-- Tạo biến toàn cục để truy cập dễ hơn sau này
_G.MeizuHub = {
    Version = "1.0",
    PlaceId = game.PlaceId,
    Author = "Nttphu1721",
    Tabs = Tabs,
    Options = Options,
    Fluent = Fluent,
    Notify = Notify
}


-- Khu vực dành cho code chính của bạn
-- Ví dụ:
-- local Players = game:GetService("Players")
-- local LocalPlayer = Players.LocalPlayer
-- local function mainLoop()
--     -- Thêm code tùy chỉnh tại đây
-- end
-- task.spawn(mainLoop)
