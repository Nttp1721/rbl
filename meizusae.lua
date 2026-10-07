--[==[
╔════════════════════════════════════════════════════════════════╗
║ MEIZU HUB • PRIMEVAL EARTH — BẢN KAITUN v2.12 (21-22/22 items) ║
║ Sinh tự động bởi Kaitun Control Panel                          ║
╠════════════════════════════════════════════════════════════════╣
║ HIDE SPOT 1 = (-965.171, 114.720, -418.536)   [#20]            ║
║ HIDE SPOT 2 = (-589.342, 93.005, -1322.879)   [#21]            ║
║ SKY = CHỜ CẤP TỌA ĐỘ (#22)                                     ║
║ Chế độ ăn mặc định: None (#4) • Kaitun khởi động: OFF          ║
║ v2.12: FIX cú pháp Lua + RAW loadstring cho executor           ║
╚════════════════════════════════════════════════════════════════╝
]==]
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Meizu Hub";
    Text = "Loading..."; -- what the text says (ofc)
    Icon = "rbxassetid://94377325741905",
    Duration = 9;
})
shared.LoaderTitle = "Thanks For Using Meizu";
shared.LoaderKeyFrames = {
    [1] = {
        1,
        10
    },
    [2] = {
        2,
        30
    },
    [3] = {
        3,
        60
    },
    [4] = {
        2,
        100
    }
};
local v2 = {
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
        [1] = {
            1,
            10
        },
        [2] = {
            2,
            30
        },
        [3] = {
            3,
            60
        },
        [4] = {
            2,
            100
        }
    }
};
local v3 = {
    [1] = "",
    [2] = "",
    [3] = "",
    [4] = ""
};
function TweenObject(v178, v179, v180)
    game.TweenService:Create(v178, TweenInfo.new(v179, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), v180):Play();
end
function CreateObject(v181, v182)
    local v183 = Instance.new(v181);
    local v184;
    for v416, v417 in pairs(v182) do
        if (v416 ~= "Parent") then
            v183[v416] = v417;
        else
            v184 = v417;
        end
    end
    v183.Parent = v184;
    return v183;
end
local function v4(v186, v187)
    local v188 = Instance.new("UICorner");
    v188.CornerRadius = UDim.new(0, v186);
    v188.Parent = v187;
end
local v5 = CreateObject("ScreenGui", {
    Name = "Core",
    Parent = game.CoreGui
});
local v6 = CreateObject("Frame", {
    Name = "Main",
    Parent = v5,
    BackgroundColor3 = v2.LoaderData.Colors.Main,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 0, 0, 0)
});
v4(12, v6);
local v7 = CreateObject("ImageLabel", {
    Name = "UserImage",
    Parent = v6,
    BackgroundTransparency = 1,
    Image = "rbxassetid://132336058081263",
    Position = UDim2.new(0, 15, 0, 10),
    Size = UDim2.new(0, 50, 0, 50)
});
v4(25, v7);
local v8 = CreateObject("TextLabel", {
    Name = "UserName",
    Parent = v6,
    BackgroundTransparency = 1,
    Text = "Meizu Hub",
    Position = UDim2.new(0, 75, 0, 10),
    Size = UDim2.new(0, 200, 0, 50),
    Font = Enum.Font.GothamBold,
    TextColor3 = v2.LoaderData.Colors.Title,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
});
local v9 = CreateObject("TextLabel", {
    Name = "Top",
    TextTransparency = 1,
    Parent = v6,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 30, 0, 70),
    Size = UDim2.new(0, 301, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "Loader",
    TextColor3 = v2.LoaderData.Colors.Topic,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left
});
local v10 = CreateObject("TextLabel", {
    Name = "Title",
    Parent = v6,
    TextTransparency = 1,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 30, 0, 90),
    Size = UDim2.new(0, 301, 0, 46),
    Font = Enum.Font.Gotham,
    RichText = true,
    Text = "<b>" .. v2.LoaderData.Name .. "</b>",
    TextColor3 = v2.LoaderData.Colors.Title,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
});
local v11 = CreateObject("Frame", {
    Name = "BG",
    Parent = v6,
    AnchorPoint = Vector2.new(0.5, 0),
    BackgroundTransparency = 1,
    BackgroundColor3 = v2.LoaderData.Colors.LoaderBackground,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, 0, 0, 70),
    Size = UDim2.new(0.8500000238418579, 0, 0, 24)
});
v4(8, v11);
local v12 = CreateObject("Frame", {
    Name = "Progress",
    Parent = v11,
    BackgroundColor3 = v2.LoaderData.Colors.LoaderSplash,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 0, 0, 24)
});
v4(8, v12);
local v13 = CreateObject("TextLabel", {
    Name = "StepLabel",
    Parent = v6,
    BackgroundTransparency = 1,
    Position = UDim2.new(0.5, 0, 1, - 25),
    Size = UDim2.new(1, - 20, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "",
    TextColor3 = v2.LoaderData.Colors.Topic,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Center,
    AnchorPoint = Vector2.new(0.5, 0.5)
});
function UpdateStepText(v191)
    v13.Text = v3[v191] or "" ;
end
function UpdatePercentage(v193, v194)
    TweenObject(v12, 0.5, {
        Size = UDim2.new(v193 / 100, 0, 0, 24)
    });
    UpdateStepText(v194);
end
TweenObject(v6, 0.25, {
    Size = UDim2.new(0, 346, 0, 121)
});
wait();
TweenObject(v9, 0.5, {
    TextTransparency = 0
});
TweenObject(v10, 0.5, {
    TextTransparency = 0
});
TweenObject(v11, 0.5, {
    BackgroundTransparency = 0
});
TweenObject(v12, 0.5, {
    BackgroundTransparency = 0
});
for v195, v196 in pairs(v2.Keyframes) do
    wait(v196[1]);
    UpdatePercentage(v196[2], v195);
end
UpdatePercentage(100, 4);
TweenObject(v9, 0.5, {
    TextTransparency = 1
});
TweenObject(v10, 0.5, {
    TextTransparency = 1
});
TweenObject(v11, 0.5, {
    BackgroundTransparency = 1
});
TweenObject(v12, 0.5, {
    BackgroundTransparency = 1
});
wait(0.5);
TweenObject(v6, 0.25, {
    Size = UDim2.new(0, 0, 0, 0)
});
wait(0.25);
v5:Destroy();
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

local MEIZU_LIBRARY_URL = "https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/meizulibrary1.lua"

----------------------------------------------------
-- LOAD HUD LOADER — đồng bộ theo tiến trình thật
----------------------------------------------------
local LoaderColors = {
    Main             = Color3.fromRGB(0, 0, 0),
    Topic            = Color3.fromRGB(200, 200, 200),
    Title            = Color3.fromRGB(255, 255, 255),
    LoaderBackground = Color3.fromRGB(40, 40, 40),
    LoaderSplash     = Color3.fromRGB(3, 252, 3),
    Error            = Color3.fromRGB(255, 90, 90),
}

local function GetGuiParent()
    if type(gethui) == "function" then
        local ok, gui = pcall(gethui)
        if ok and gui then return gui end
    end
    return game:GetService("CoreGui")
end

local GuiParent = GetGuiParent()

-- Cleanup những instance của bản Primeval/Meizu trước đó để re-run không chồng UI.
pcall(function()
    for _, child in ipairs(GuiParent:GetChildren()) do
        if child:IsA("ScreenGui") then
            if child.Name == "MeizuLoader"
            or child.Name == "PrimevalFOVOverlay"
            or child.Name:match("^MeizuLibrary") then
                child:Destroy()
            end
        end
    end
end)

pcall(function()
    RunService:UnbindFromRenderStep("AimbotSystem")
end)

local function Create(className, properties)
    local obj = Instance.new(className)
    local parent
    for prop, value in pairs(properties or {}) do
        if prop == "Parent" then
            parent = value
        else
            obj[prop] = value
        end
    end
    if parent then obj.Parent = parent end
    return obj
end

local function AddCorner(radius, parent)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius),
        Parent = parent,
    })
end

local function LoaderTween(object, duration, properties)
    local tw = TweenService:Create(
        object,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    )
    tw:Play()
    return tw
end

local LoaderGui = Create("ScreenGui", {
    Name = "MeizuLoader",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100000,
    Parent = GuiParent,
})

-- Chặn input vào UI phía sau trong lúc loader chạy.
Create("Frame", {
    Name = "InputBlocker",
    BackgroundTransparency = 1,
    Active = true,
    Size = UDim2.fromScale(1, 1),
    ZIndex = 1,
    Parent = LoaderGui,
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
    ZIndex = 10,
})
AddCorner(12, LoaderFrame)

local LoaderStroke = Create("UIStroke", {
    Color = LoaderColors.LoaderSplash,
    Thickness = 1.25,
    Transparency = 0.25,
    Parent = LoaderFrame,
})

local LoaderLogo = Create("ImageLabel", {
    Name = "Logo",
    Parent = LoaderFrame,
    BackgroundTransparency = 1,
    Image = "",
    Position = UDim2.new(0, 15, 0, 10),
    Size = UDim2.new(0, 50, 0, 50),
    ZIndex = 11,
})
AddCorner(25, LoaderLogo)

Create("TextLabel", {
    Name = "HubName",
    Parent = LoaderFrame,
    BackgroundTransparency = 1,
    Text = "Primeval Earth Hub",
    Position = UDim2.new(0, 75, 0, 10),
    Size = UDim2.new(0, 240, 0, 50),
    Font = Enum.Font.GothamBold,
    TextColor3 = LoaderColors.Title,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 11,
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
    Text = "<b>Đang khởi tạo Primeval...</b>",
    TextColor3 = LoaderColors.Title,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 11,
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
    ZIndex = 11,
})
AddCorner(7, ProgressBG)

local ProgressBar = Create("Frame", {
    Name = "Progress",
    Parent = ProgressBG,
    BackgroundColor3 = LoaderColors.LoaderSplash,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 0, 1, 0),
    ZIndex = 12,
})
AddCorner(7, ProgressBar)

local PercentLabel = Create("TextLabel", {
    Name = "Percent",
    Parent = LoaderFrame,
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -20, 0, 108),
    Size = UDim2.new(0, 52, 0, 18),
    Font = Enum.Font.GothamBold,
    Text = "0%",
    TextColor3 = LoaderColors.LoaderSplash,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Right,
    ZIndex = 11,
})

local StepLabel = Create("TextLabel", {
    Name = "StepLabel",
    Parent = LoaderFrame,
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0, 0),
    Position = UDim2.new(0, 15, 0, 108),
    Size = UDim2.new(1, -85, 0, 18),
    Font = Enum.Font.Gotham,
    Text = "Đang chuẩn bị...",
    TextColor3 = LoaderColors.Topic,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 11,
})

local LoaderSteps = {
    {5,  "Đã load xong: Core Services"},
    {15, "Đã load xong: MeizuLibrary"},
    {25, "Đã load xong: State + FOV"},
    {40, "Đã load xong: Aimbot + ESP"},
    {52, "Đã load xong: Movement + Fly"},
    {66, "Đã dựng xong: Tab Di Chuyển + Teleport"},
    {80, "Đã dựng xong: ESP + PVP + Fossils + Utility"},
    {94, "Đã load xong: Runtime + Background Systems"},
    {100, "Đã load xong toàn bộ Primeval Earth Hub"},
}

local LoaderStageIndex = 0
local LoaderComplete = false

local function UpdateLoader(percent, message)
    percent = math.clamp(tonumber(percent) or 0, 0, 100)
    PercentLabel.Text = string.format("%d%%", math.floor(percent))
    StepLabel.Text = "✓ " .. tostring(message or "")
    LoaderTween(ProgressBar, 0.18, {Size = UDim2.new(percent / 100, 0, 1, 0)})
end

local function LoaderStage(index)
    local data = LoaderSteps[index]
    if not data then return end
    if index <= LoaderStageIndex then return end
    LoaderStageIndex = index
    UpdateLoader(data[1], data[2])
end

LoaderTween(LoaderFrame, 0.25, {Size = UDim2.new(0, 346, 0, 132)})
task.defer(function()
    LoaderTween(LoaderTitle, 0.25, {TextTransparency = 0})
    LoaderTween(ProgressBG, 0.25, {BackgroundTransparency = 0})
    LoaderTween(ProgressBar, 0.25, {BackgroundTransparency = 0})
end)

LoaderStage(1)

----------------------------------------------------
-- LOAD MEIZU LIBRARY — chỉ load source, chưa tạo Window
----------------------------------------------------
local function LoadMeizuLibrary()
    local okHttp, source = pcall(function()
        return game:HttpGet(MEIZU_LIBRARY_URL, true)
    end)
    if not okHttp or type(source) ~= "string" or source == "" then
        error("[Primeval] Khong the tai MeizuLibrary: " .. tostring(source))
    end

    local chunk, compileErr = loadstring(source)
    if type(chunk) ~= "function" then
        error("[Primeval] MeizuLibrary compile error: " .. tostring(compileErr))
    end

    local okLoad, library = pcall(chunk)
    if not okLoad or type(library) ~= "table" then
        error("[Primeval] MeizuLibrary load error: " .. tostring(library))
    end

    return library
end

local okLibrary, MeizuLibraryOrError = pcall(LoadMeizuLibrary)
if not okLibrary then
    UpdateLoader(100, "Lỗi: Không thể load MeizuLibrary")
    task.wait(0.4)
    if LoaderGui then LoaderGui:Destroy() end
    error(MeizuLibraryOrError)
end

local MeizuLibrary = MeizuLibraryOrError
LoaderStage(2)

----------------------------------------------------
-- PRIMEVAL STATE
----------------------------------------------------
_G.AutoDrinkRunning = false
_G.AutoRestRunning = false
_G.AutoZoneRunning = false
_G.AutoFarmAmmo = false
_G.AutoAttackRunning = false
_G.AutoEatActive = false
_G.AutoHerbActive = false
_G.CurrentQuest = "None"

local AimSettings = {
    Enabled = false,
    ShowFOV = false,
    FOVRadius = 150,
    Smoothness = 0.2,
    MaxDistance = 150,
}

local EspSettings = {
    Enabled = false,
    ShowName = true,
    ShowHealth = true,
    ShowDistance = true,
}

local hasTargetInFOV = false
local AmmoStatusLabel
local QuestStatusLabel
local lowServerBtn
local noclipConn = nil

----------------------------------------------------
-- FOV OVERLAY — không phải menu
----------------------------------------------------
local oldFovGui = GuiParent:FindFirstChild("PrimevalFOVOverlay")
if oldFovGui then pcall(function() oldFovGui:Destroy() end) end

local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "PrimevalFOVOverlay"
FOVGui.ResetOnSpawn = false
FOVGui.IgnoreGuiInset = true
FOVGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
FOVGui.DisplayOrder = 9998
FOVGui.Parent = GuiParent

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.fromScale(0.5, 0.5)
FOVCircle.Size = UDim2.fromOffset(AimSettings.FOVRadius * 2, AimSettings.FOVRadius * 2)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
FOVCircle.ZIndex = 2
FOVCircle.Parent = FOVGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircle

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(255, 255, 255)
FOVStroke.Thickness = 1
FOVStroke.Transparency = 0.2
FOVStroke.Parent = FOVCircle

LoaderStage(3)


-- 3. LOGIC ESP, AIMBOT, AUTO ATTACK & AUTO NHẶT ĐẠN
----------------------------------------------------
local targetAmmoCFrame = CFrame.new(637.3, 94.3, -56.5)
local ammoMaxDistance = 15

local function triggerAttack()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    for _, gui in pairs(playerGui:GetDescendants()) do
        if (gui:IsA("ImageButton") or gui:IsA("TextButton")) and gui.Name == "Attack" then
            if getconnections then
                for _, conn in pairs(getconnections(gui.Activated)) do 
                    conn:Fire() 
                end
                for _, conn in pairs(getconnections(gui.MouseButton1Click)) do 
                    conn:Fire() 
                end
            end
        end
    end
end

local function getPromptPosition(prompt)
    local parent = prompt.Parent
    if parent:IsA("BasePart") then
        return parent.Position
    elseif parent:IsA("Attachment") then
        return parent.WorldPosition
    end
    return nil
end

local function isFullyVisible(gui)
    if not gui or not gui:IsDescendantOf(game) then return false end
    if gui.AbsoluteSize.X <= 0 or gui.AbsoluteSize.Y <= 0 then return false end
    
    local current = gui
    while current and current:IsA("GuiObject") do
        if not current.Visible then return false end
        if current:IsA("CanvasGroup") and current.GroupTransparency >= 0.9 then return false end
        current = current.Parent
    end
    
    if current and current:IsA("ScreenGui") and not current.Enabled then
        return false
    end
    return true
end

local function checkAmmoStatus()
    local char = LocalPlayer.Character
    if not char then return nil, nil, "Chưa tải Nhân vật" end

    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        return nil, nil, "Hãy cầm súng trên tay!"
    end

    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return nil, nil, "Không thấy PlayerGui" end

    local screenWidth = Camera and Camera.ViewportSize.X or 1000
    local screenHeight = Camera and Camera.ViewportSize.Y or 1000
    local rightSideX = screenWidth * 0.5
    local bottomSideY = screenHeight * 0.5

    local currentAmmo = nil
    local reserveAmmo = nil

    for _, gui in pairs(playerGui:GetDescendants()) do
        if (gui:IsA("TextLabel") or gui:IsA("TextBox") or gui:IsA("TextButton")) and isFullyVisible(gui) then
            if gui.AbsolutePosition.X >= rightSideX and gui.AbsolutePosition.Y >= bottomSideY then
                local rawText = gui.Text
                if rawText and rawText ~= "" and gui.TextTransparency < 0.8 then
                    local cleanText = string.gsub(rawText, "<[^>]->", "")
                    cleanText = string.match(cleanText, "^%s*(.-)%s*$") or cleanText

                    local cur, res = string.match(cleanText, "^(%d+)%s*[/⁄∕|]%s*(%d+)$")
                    if cur and res then
                        return tonumber(cur), tonumber(res), "Đạn: " .. cleanText
                    end

                    local resOnly = string.match(cleanText, "^[/⁄∕|]%s*(%d+)$")
                    if resOnly then
                        reserveAmmo = tonumber(resOnly)
                    end

                    local curOnly = string.match(cleanText, "^(%d+)$")
                    if curOnly and tonumber(curOnly) <= 200 then
                        currentAmmo = tonumber(curOnly)
                    end
                end
            end
        end
    end

    if currentAmmo ~= nil and reserveAmmo ~= nil then
        return currentAmmo, reserveAmmo, string.format("Đạn: %02d/%d", currentAmmo, reserveAmmo)
    elseif reserveAmmo ~= nil then
        return currentAmmo or 0, reserveAmmo, "Đạn dự trữ: /" .. reserveAmmo
    end

    return nil, nil, "Đang quét UI đạn..."
end

local function getTorso(character)
    if not character then return nil end
    return character:FindFirstChild("UpperTorso") 
        or character:FindFirstChild("Torso") 
        or character:FindFirstChild("HumanoidRootPart")
        or character:FindFirstChild("Head")
end

local function getClosestEnemyInFOV()
    if not AimSettings.Enabled then return nil end

    local closestChar = nil
    local shortestWorldDist = AimSettings.MaxDistance
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local torso = getTorso(char)
            local humanoid = char:FindFirstChildOfClass("Humanoid")

            if humanoid and humanoid.Health > 0 and torso then
                local worldDistance = (Camera.CFrame.Position - torso.Position).Magnitude
                
                if worldDistance <= AimSettings.MaxDistance then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(torso.Position)
                    if onScreen and screenPos.Z > 0 then
                        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        
                        if screenDist <= AimSettings.FOVRadius then
                            if worldDistance < shortestWorldDist then
                                shortestWorldDist = worldDistance
                                closestChar = char
                            end
                        end
                    end
                end
            end
        end
    end
    return closestChar
end

RunService:BindToRenderStep("AimbotSystem", Enum.RenderPriority.Camera.Value + 100, function()
    if not AimSettings.Enabled then
        FOVStroke.Color = Color3.fromRGB(255, 255, 255)
        hasTargetInFOV = false
        return
    end

    local target = getClosestEnemyInFOV()
    if target then
        hasTargetInFOV = true
        local targetTorso = getTorso(target)
        FOVStroke.Color = Color3.fromRGB(255, 50, 50)

        if targetTorso then
            local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, targetTorso.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, AimSettings.Smoothness)
        end
    else
        hasTargetInFOV = false
        FOVStroke.Color = Color3.fromRGB(255, 255, 255)
    end
end)

local function CreateESP(player)
    if player == LocalPlayer then return end

    local function SetupCharacter(char)
        if not char then return end

        -- Không chặn thread load bằng WaitForChild.
        -- Character có thể chưa có Head/Humanoid ngay khi CharacterAdded.
        task.spawn(function()
            local deadline = os.clock() + 8
            local head = char:FindFirstChild("Head")
            local humanoid = char:FindFirstChildOfClass("Humanoid")

            while char.Parent and os.clock() < deadline and (not head or not humanoid) do
                head = head or char:FindFirstChild("Head")
                humanoid = humanoid or char:FindFirstChildOfClass("Humanoid")
                if head and humanoid then break end
                task.wait(0.1)
            end

            if not char.Parent or not head or not humanoid then return end

            if head:FindFirstChild("PlayerESP") then
                head.PlayerESP:Destroy()
            end

            local bgui = Instance.new("BillboardGui")
            bgui.Name = "PlayerESP"
            bgui.Adornee = head
            bgui.Size = UDim2.new(0, 200, 0, 50)
            bgui.StudsOffset = Vector3.new(0, 2.5, 0)
            bgui.AlwaysOnTop = true
            bgui.Parent = head

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
            textLabel.TextStrokeTransparency = 0
            textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextSize = 13
            textLabel.Parent = bgui

            -- Một connection riêng cho ESP này; việc tạo nó không cản quá trình load chính.
            RunService.RenderStepped:Connect(function()
                if not char.Parent or not humanoid.Parent or humanoid.Health <= 0 or not EspSettings.Enabled then
                    if bgui.Parent then bgui.Enabled = false end
                    return
                end

                bgui.Enabled = true
                local textParts = {}

                if EspSettings.ShowName then
                    table.insert(textParts, player.DisplayName)
                end

                if EspSettings.ShowHealth then
                    local hp = math.floor(humanoid.Health)
                    local maxHp = math.floor(humanoid.MaxHealth)
                    table.insert(textParts, string.format("[%d/%d HP]", hp, maxHp))
                end

                local myChar = LocalPlayer.Character
                local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if EspSettings.ShowDistance and myHRP then
                    local dist = math.floor((myHRP.Position - head.Position).Magnitude)
                    table.insert(textParts, string.format("[%dm]", dist))
                end

                textLabel.Text = table.concat(textParts, " | ")
            end)
        end)
    end

    if player.Character then
        SetupCharacter(player.Character)
    end
    player.CharacterAdded:Connect(SetupCharacter)
end

for _, p in ipairs(Players:GetPlayers()) do
    CreateESP(p)
end
Players.PlayerAdded:Connect(CreateESP)

-- Stage 4 chỉ xác nhận hệ thống ESP đã được đăng ký.
-- Không đợi từng Character spawn xong mới cho script chạy tiếp.
LoaderStage(4)

local flyEnabled = false
local flySpeed = 50
local flyAtt, flyLV, flyAG
local flyRenderConnection = nil

local function cleanupFly()
    if flyRenderConnection then
        flyRenderConnection:Disconnect()
        flyRenderConnection = nil
    end
    if flyLV then flyLV:Destroy() flyLV = nil end
    if flyAG then flyAG:Destroy() flyAG = nil end
    if flyAtt then flyAtt:Destroy() flyAtt = nil end
end

local function stopFly()
    flyEnabled = false
    cleanupFly()
end

local function startFly()
    cleanupFly()
    flyEnabled = true

    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not hrp or not flyEnabled then return end

    flyAtt = Instance.new("Attachment", hrp)

    flyLV = Instance.new("LinearVelocity")
    flyLV.Attachment0 = flyAtt
    flyLV.MaxForce = math.huge
    flyLV.VectorVelocity = Vector3.new(0, 0, 0)
    flyLV.Parent = hrp

    flyAG = Instance.new("AlignOrientation")
    flyAG.Attachment0 = flyAtt
    flyAG.MaxTorque = math.huge
    flyAG.Responsiveness = 200
    flyAG.Parent = hrp

    flyRenderConnection = RunService.RenderStepped:Connect(function()
        local currentChar = LocalPlayer.Character
        local currentHRP = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        local humanoid = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

        if not flyEnabled or not currentChar or not currentChar.Parent or not currentHRP or not humanoid or humanoid.Health <= 0 then
            cleanupFly()
            return
        end

        if not flyLV or not flyAG or flyLV.Parent ~= currentHRP or flyAG.Parent ~= currentHRP then
            cleanupFly()
            return
        end

        local moveDir = humanoid.MoveDirection
        local targetVel = Vector3.new()
        if moveDir.Magnitude > 0 then
            local camCF = Camera.CFrame
            local camLook = camCF.LookVector
            local camRight = camCF.RightVector
            local flatLook = Vector3.new(camLook.X, 0, camLook.Z).Unit
            local flatRight = Vector3.new(camRight.X, 0, camRight.Z).Unit
            local lookDot = moveDir:Dot(camLook)
            local rightDot = moveDir:Dot(camRight)
            targetVel = (flatLook * lookDot + flatRight * rightDot + Vector3.new(0, camLook.Y * math.abs(lookDot), 0)).Unit * flySpeed
        else
            targetVel = Vector3.new(0, 0, 0)
        end

        flyLV.VectorVelocity = targetVel
        flyAG.CFrame = Camera.CFrame
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    if flyEnabled then
        task.wait(0.5)
        if flyEnabled then
            startFly()
        end
    end
end)

LoaderStage(5)

----------------------------------------------------
-- 4. KHỞI TẠO TABS VÀ CHỨC NĂNG
----------------------------------------------------
local targetWalkSpeed = 16
RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and targetWalkSpeed > 16 then
            if hum.WalkSpeed ~= targetWalkSpeed then
                hum.WalkSpeed = targetWalkSpeed
            end
        end
    end)
end)



----------------------------------------------------
-- 4. MEIZU UI — dựng hoàn chỉnh phía sau Loader HUD
----------------------------------------------------
local Window = MeizuLibrary:CreateWindow({
    Title = "Meizu Hub",
    SubTitle = "Primeval Earth • NTTP1721",
    Theme = "Dark",
    Accent = Color3.fromRGB(99, 102, 241),
    ToggleKeybind = Enum.KeyCode.RightControl,
    ToggleUIButton = true,
    ToggleImage = "https://i.ibb.co/S7rpHJJN/meizuxp.png",
    Size = UDim2.fromOffset(650, 470),
})

local function FixParagraphElement(element, defaultHeight)
    if not element or not element.Frame then return element end
    local frame = element.Frame
    local fallbackHeight = defaultHeight or 58

    local titleLabel = element.TitleLabel
    local contentLabel = element.ContentLabel
    if not titleLabel or not contentLabel then
        local labels = {}
        for _, obj in ipairs(frame:GetDescendants()) do
            if obj:IsA("TextLabel") then
                table.insert(labels, obj)
                obj.Visible = true
            end
        end
        titleLabel = titleLabel or labels[1]
        contentLabel = contentLabel or labels[2]
    end

    local function Reflow()
        if not frame or not frame.Parent then return end
        pcall(function()
            frame.Visible = true
            frame.ClipsDescendants = false
            frame.AutomaticSize = Enum.AutomaticSize.None
        end)

        if not titleLabel or not titleLabel.Parent then return end

        local width = math.max(120, frame.AbsoluteSize.X - 24)
        if width <= 120 then
            width = 430
        end

        local titleHeight = 18
        local contentHeight = 0

        pcall(function()
            titleLabel.Visible = true
            titleLabel.TextWrapped = true
            titleLabel.AutomaticSize = Enum.AutomaticSize.None
            titleHeight = math.max(18, math.ceil(
                TextService:GetTextSize(tostring(titleLabel.Text or ""), Enum.Font.GothamBold, 13, Vector2.new(width, 1000)).Y
            ))
            titleLabel.Size = UDim2.new(1, 0, 0, titleHeight)
        end)

        if contentLabel and contentLabel.Parent then
            pcall(function()
                contentLabel.Visible = true
                contentLabel.TextWrapped = true
                contentLabel.AutomaticSize = Enum.AutomaticSize.None
                if tostring(contentLabel.Text or "") ~= "" then
                    contentHeight = math.max(16, math.ceil(
                        TextService:GetTextSize(tostring(contentLabel.Text or ""), Enum.Font.Gotham, 12, Vector2.new(width, 1000)).Y
                    ))
                end
                contentLabel.Size = UDim2.new(1, 0, 0, contentHeight)
            end)
        end

        local total = 10 + titleHeight + (contentLabel and 4 or 0) + contentHeight + 10
        total = math.max(fallbackHeight, total, 40)
        frame.Size = UDim2.new(1, 0, 0, total)
    end

    Reflow()
    task.defer(Reflow)
    pcall(function()
        frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            task.defer(Reflow)
        end)
    end)

    if type(element.SetContent) ~= "function" then
        element.SetContent = function(self, text, textColor)
            if contentLabel and contentLabel.Parent then
                contentLabel.Text = tostring(text or "")
                if textColor then contentLabel.TextColor3 = textColor end
            end
            self._Content = tostring(text or "")
            task.defer(Reflow)
        end
    end
    if type(element.SetTitle) ~= "function" then
        element.SetTitle = function(self, text)
            if titleLabel and titleLabel.Parent then
                titleLabel.Text = tostring(text or "")
            end
            task.defer(Reflow)
        end
    end

    return element
end

local function CreateParagraph(tab, cfg, height)
    local element = tab:CreateParagraph(cfg)
    return FixParagraphElement(element, height or 58)
end

local function SetParagraphContent(element, text, textColor)
    if not element then return end
    pcall(function()
        if type(element.SetContent) == "function" then
            element:SetContent(text, textColor)
            return
        end
        local frame = element.Frame
        if frame then
            for _, obj in ipairs(frame:GetDescendants()) do
                if obj:IsA("TextLabel") and obj ~= frame:FindFirstChild("TitleLabel", true) then
                    obj.Text = tostring(text or "")
                    if textColor then obj.TextColor3 = textColor end
                end
            end
        end
    end)
end

local function SetAmmoStatus(text)
    SetParagraphContent(AmmoStatusLabel, text)
end

local function SetQuestStatus(text, color)
    SetParagraphContent(QuestStatusLabel, text, color)
end

local MovementTab = Window:CreateTab("Misc", "rbxassetid://10747382750", 5)
local TeleportTab = Window:CreateTab("Teleport ", "rbxassetid://10734886004", 2)
local EspTab = Window:CreateTab("ESP", "rbxassetid://10747375132", 3)
local PvpTab = Window:CreateTab("PVP", "rbxassetid://10734975692", 4)
local FossilsTab = Window:CreateTab("Main", "rbxassetid://10709781605", 1)
local VisualsTab = Window:CreateTab("Setting", "rbxassetid://10734950309", 6)
LoaderStage(6)

----------------------------------------------------
-- TAB DI CHUYEN
----------------------------------------------------
MovementTab:CreateSection("Movement")
MovementTab:CreateSlider({
    Title = "Tốc Độ Chạy",
    Description = "WalkSpeed",
    Min = 16, Max = 200, Default = 16,
    Callback = function(value)
        targetWalkSpeed = value
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = value end
    end,
})
MovementTab:CreateSlider({
    Title = "Nhảy",
    Description = "JumpPower",
    Min = 50, Max = 300, Default = 50,
    Callback = function(value)
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = value
        end
    end,
})
MovementTab:CreateToggle({
    Title = "Bật/Tắt Bay",
    Description = "Fly",
    Default = false,
    Callback = function(state)
        if state then startFly() else stopFly() end
    end,
})
MovementTab:CreateSlider({
    Title = "Tốc Độ Bay",
    Description = "Fly Speed",
    Min = 10, Max = 150, Default = 50,
    Callback = function(value) flySpeed = value end,
})
MovementTab:CreateToggle({
    Title = "Xuyên Tường",
    Description = "NoClip",
    Default = false,
    Callback = function(state)
        if state then
            if noclipConn then pcall(function() noclipConn:Disconnect() end) end
            noclipConn = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        elseif noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
    end,
})


----------------------------------------------------
-- TAB TELEPORT
----------------------------------------------------
TeleportTab:CreateSection("Teleport Player")
CreateParagraph(TeleportTab, {
    Title = "Danh Sách Người Chơi",
    Content = "Chọn người chơi để dịch chuyển đến người chơi đó",
}, 72)

local PlayerButtonElements = {}

local function ClearPlayerButtons()
    for i = #PlayerButtonElements, 1, -1 do
        local element = PlayerButtonElements[i]
        if element and element.Frame then
            pcall(function() element.Frame:Destroy() end)
        end
        PlayerButtonElements[i] = nil
    end
end

local function AddPlayerButton(plr)
    if plr == LocalPlayer then return end
    local element = TeleportTab:CreateButton({
        Title = "📍 " .. plr.DisplayName .. " (@" .. plr.Name .. ")",
        Callback = function()
            if plr and plr.Parent == Players and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local myChar = LocalPlayer.Character
                local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    myHRP.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 2)
                end
            end
        end,
    })
    table.insert(PlayerButtonElements, element)
end

local function RefreshPlayerList()
    ClearPlayerButtons()
    for _, plr in ipairs(Players:GetPlayers()) do
        AddPlayerButton(plr)
    end
end

Players.PlayerAdded:Connect(function()
    task.wait(0.15)
    RefreshPlayerList()
end)
Players.PlayerRemoving:Connect(function()
    task.wait()
    RefreshPlayerList()
end)
task.defer(RefreshPlayerList)

----------------------------------------------------
-- TAB ESP
----------------------------------------------------
EspTab:CreateSection("ESP")
EspTab:CreateToggle({Title="Bật/Tắt ESP", Default=EspSettings.Enabled, Callback=function(v) EspSettings.Enabled=v end})
EspTab:CreateToggle({Title="Hiện Tên", Default=EspSettings.ShowName, Callback=function(v) EspSettings.ShowName=v end})
EspTab:CreateToggle({Title="Hiện Máu (HP)", Default=EspSettings.ShowHealth, Callback=function(v) EspSettings.ShowHealth=v end})
EspTab:CreateToggle({Title="Hiện Khoảng Cách (m)", Default=EspSettings.ShowDistance, Callback=function(v) EspSettings.ShowDistance=v end})

----------------------------------------------------
-- TAB PVP
----------------------------------------------------
PvpTab:CreateSection("Aim / FOV")
PvpTab:CreateToggle({
    Title="Auto Attack (Chi Bắn Khi FOV Đỏ)", Default=false,
    Callback=function(state) _G.AutoAttackRunning=state end,
})
PvpTab:CreateToggle({
    Title="Aimbot (Auto Lock)", Default=false,
    Callback=function(state)
        AimSettings.Enabled=state
        FOVCircle.Visible=AimSettings.Enabled and AimSettings.ShowFOV
    end,
})
PvpTab:CreateToggle({
    Title="Hiện Vòng FOV", Default=false,
    Callback=function(state)
        AimSettings.ShowFOV=state
        FOVCircle.Visible=AimSettings.Enabled and AimSettings.ShowFOV
    end,
})
PvpTab:CreateSlider({
    Title="Kích Thước FOV", Min=30, Max=200, Default=150,
    Callback=function(value)
        AimSettings.FOVRadius=value
        FOVCircle.Size=UDim2.fromOffset(value*2, value*2)
    end,
})
PvpTab:CreateSlider({
    Title="Độ Mượt Aim (Smooth)", Min=1, Max=10, Default=2,
    Callback=function(value) AimSettings.Smoothness=value/10 end,
})
AmmoStatusLabel = CreateParagraph(PvpTab, {
    Title="Trạng thái đạn",
    Content="Đang chờ...",
}, 60)
PvpTab:CreateToggle({
    Title="Auto Nhặt Đạn (Nhặt 2 Lần)", Default=false,
    Callback=function(state)
        _G.AutoFarmAmmo=state
        if not state then
            SetAmmoStatus("Trạng Thái Đạn: Đã TẮT")
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Anchored=false
            end
        end
    end,
})

----------------------------------------------------
-- TAB FOSSILS
----------------------------------------------------
FossilsTab:CreateSection("Main / Quest")
QuestStatusLabel = CreateParagraph(FossilsTab, {
    Title="Quest Hiện Tại",
    Content="Đang chờ...",
}, 60)
FossilsTab:CreateToggle({Title="Auto Ăn Thịt (Toggle Meat)", Default=false, Callback=function(v) _G.AutoEatActive=v end})
FossilsTab:CreateToggle({Title="Auto Ăn Cỏ (Toggle Herb)", Default=false, Callback=function(v) _G.AutoHerbActive=v end})
FossilsTab:CreateToggle({Title="Auto Drink (Uống Liên Tục)", Default=false, Callback=function(v) _G.AutoDrinkRunning=v end})
FossilsTab:CreateToggle({Title="Auto Rest (Nghỉ Ngơi)", Default=false, Callback=function(v) _G.AutoRestRunning=v end})
FossilsTab:CreateToggle({Title="Auto Zone (Chiếm Zone)", Default=false, Callback=function(v) _G.AutoZoneRunning=v end})

-- ═══════════════════════════════════════════════════════════
-- [KAITUN #1][#4] UI — DROPDOWN CHẾ ĐỘ ĂN + TOGGLE AUTO NUÔI
-- ═══════════════════════════════════════════════════════════
_G.KaitunEnabled  = _G.KaitunEnabled or false
_G.KaitunFeedMode = _G.KaitunFeedMode or "None"  -- #4: mặc định None

if not _G.KaitunNotify then
    _G.KaitunNotify = function(text, duration)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "🐾 Kaitun", Text = tostring(text), Duration = duration or 4
            })
        end)
    end
end

FossilsTab:CreateSection("Auto Nuôi (Kaitun)")

local KaitunStatusLabel = CreateParagraph(FossilsTab, {
    Title = "Trạng Thái Kaitun",
    Content = "TẮT — bật toggle Auto Nuôi để bắt đầu",
}, 60)

_G.KaitunUpdateStatus = function()
    pcall(function()
        if _G.KaitunEnabled then
            local modeText = _G.KaitunFeedMode == "None" and "⚠ CHƯA CHỌN (None)" or tostring(_G.KaitunFeedMode)
            SetParagraphContent(KaitunStatusLabel, "ĐANG BẬT • Chế độ ăn: " .. modeText, Color3.fromRGB(0, 255, 130))
        else
            SetParagraphContent(KaitunStatusLabel, "TẮT — bật toggle Auto Nuôi để bắt đầu", Color3.fromRGB(200, 200, 200))
        end
    end)
end

-- [#1][#4] Dropdown Chế Độ Ăn (None / Meat / Herb) — mặc định None
do
    local okDropdown, dropdownErr = pcall(function()
        FossilsTab:CreateDropdown({
            Title = "Chế Độ Ăn",
            Description = "None / Meat / Herb — mặc định None",
            Options = { "None", "Meat", "Herb" },
            Default = "None",
            Callback = function(selected)
                local val = selected
                if type(val) == "table" then val = val[1] end
                if val ~= "Meat" and val ~= "Herb" then val = "None" end
                _G.KaitunFeedMode = val
                if _G.KaitunEnabled and val == "None" then
                    _G.KaitunNotify("⚠ Kaitun đang BẬT nhưng Chế Độ Ăn = None! Hãy chọn Meat hoặc Herb.", 6, "warn")
                end
                if _G.KaitunUpdateStatus then _G.KaitunUpdateStatus() end
            end,
        })
    end)
    if not okDropdown then
        -- Dự phòng nếu MeizuLibrary không hỗ trợ CreateDropdown
        _G.KaitunNotify("CreateDropdown lỗi (" .. tostring(dropdownErr) .. ") → dùng toggle dự phòng", 6, "warn")
        FossilsTab:CreateToggle({ Title = "Chế độ ăn: MEAT", Default = false, Callback = function(v)
            if v then _G.KaitunFeedMode = "Meat" elseif _G.KaitunFeedMode == "Meat" then _G.KaitunFeedMode = "None" end
        end })
        FossilsTab:CreateToggle({ Title = "Chế độ ăn: HERB", Default = false, Callback = function(v)
            if v then _G.KaitunFeedMode = "Herb" end
        end })
    end
end

-- [#1] Toggle Auto Nuôi (Kaitun) — #10: bật là tele Hide Spot 1 ngay
FossilsTab:CreateToggle({
    Title = "Auto Nuôi (Kaitun)",
    Description = "Bật = tele về Hide Spot 1 ngay lập tức",
    Default = false,
    Callback = function(state)
        if _G.KaitunSetEnabled then
            _G.KaitunSetEnabled(state)
        else
            _G.KaitunEnabled = state
        end
        if _G.KaitunUpdateStatus then _G.KaitunUpdateStatus() end
    end,
})



----------------------------------------------------
-- TAB CAI DAT / UTILITY
----------------------------------------------------
VisualsTab:CreateSection("Utility")
VisualsTab:CreateToggle({
    Title="Trời Sáng (Fullbright)", Default=false,
    Callback=function(state)
        local Lighting=game:GetService("Lighting")
        if state then
            Lighting.Brightness=2
            Lighting.ClockTime=14
            Lighting.GlobalShadows=false
        else
            Lighting.Brightness=1
            Lighting.GlobalShadows=true
        end
    end,
})

lowServerBtn = VisualsTab:CreateButton({
    Title="HOP Server (Low Player)",
    Callback=function()
        local teleportService=game:GetService("TeleportService")
        local placeId=game.PlaceId
        local jobId=game.JobId

        local function SetLowServerText(text)
            if not lowServerBtn or not lowServerBtn.Frame then return end
            local label = lowServerBtn.Frame:FindFirstChild("Title", true) or lowServerBtn.Frame:FindFirstChildWhichIsA("TextLabel", true)
            if label then label.Text=tostring(text) end
        end

        SetLowServerText("Đang Tìm Server...")
        local success,result=pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/0?sortOrder=Asc&limit=100")
        end)
        if success and result then
            local ok,decoded=pcall(function() return HttpService:JSONDecode(result) end)
            if ok and decoded and decoded.data then
                for _,server in ipairs(decoded.data) do
                    if server.id~=jobId and server.playing<server.maxPlayers and server.playing>0 then
                        SetLowServerText("Dang Chuyen Server ("..server.playing.." nguoi)...")
                        teleportService:TeleportToPlaceInstance(placeId,server.id,LocalPlayer)
                        return
                    end
                end
            end
        end
        SetLowServerText("Không Tìm Thất Server!")
        task.delay(2,function()
            if lowServerBtn and lowServerBtn.Frame and lowServerBtn.Frame.Parent then
                SetLowServerText("Vào Server Ít Người (Low Player)")
            end
        end)
    end,
})

VisualsTab:CreateButton({
    Title="Hồi Sinh Nhân vật (Reset)",
    Callback=function()
        local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health=0 end
    end,
})


LoaderStage(7)

----------------------------------------------------
-- 5. LOGIC CHẠY NGẦM (AUTO ATTACK, NHẶT ĐẠN, FOSSILS, AUTO ĂN THỊT/CỎ & ANTI-AFK)
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local Mouse = LocalPlayer:GetMouse()
Mouse.Button1Down:Connect(function()
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and Mouse.Target then
            hrp.CFrame = CFrame.new(Mouse.Hit.X, Mouse.Hit.Y + 3, Mouse.Hit.Z)
        end
    end
end)

-- Vòng lặp Auto Attack (PVP)
task.spawn(function()
    while true do
        if _G.AutoAttackRunning and hasTargetInFOV then
            triggerAttack()
        end
        task.wait(0.1)
    end
end)

-- Vòng lặp Auto Nhặt Đạn (PVP)
task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.AutoFarmAmmo and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local char = LocalPlayer.Character
            local hrp = char.HumanoidRootPart
            local currentAmmo, reserveAmmo, infoMsg = checkAmmoStatus()
            
            SetAmmoStatus(infoMsg)
            
            if currentAmmo == 0 and reserveAmmo == 0 then
                SetAmmoStatus("Hết đạn (00/0)! Đang tới chỗ nhặt...")
                local originalCFrame = hrp.CFrame
                
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.Anchored = false
                
                for i = 1, 5 do
                    hrp.CFrame = targetAmmoCFrame
                    task.wait(0.03)
                end
                
                hrp.Anchored = true
                
                local function tryInteract()
                    local found = false
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("ProximityPrompt") and v.Enabled then
                            local promptPos = getPromptPosition(v)
                            if promptPos then
                                local distance = (promptPos - hrp.Position).Magnitude
                                if distance <= ammoMaxDistance then
                                    found = true
                                    fireproximityprompt(v)
                                end
                            end
                        end
                    end
                    return found
                end

                SetAmmoStatus("Đang nhặt đạn (Lần 1)...")
                tryInteract()
                task.wait(0.6)

                SetAmmoStatus("Đang nhặt đạn (Lần 2)...")
                tryInteract()
                task.wait(0.6)
                
                hrp.Anchored = false
                hrp.AssemblyLinearVelocity = Vector3.zero
                for i = 1, 5 do
                    hrp.CFrame = originalCFrame
                    task.wait(0.03)
                end
                
                SetAmmoStatus("Đã bơm đầy đạn! Đang quay lại...")
                task.wait(2)
            end
        end
    end
end)

-- LOGIC AUTO ĂN THỊT / ĂN CỎ - OPTIMIZED
-- Dùng spatial query thay cho Workspace:GetDescendants() mỗi chu kỳ.
-- RemoteEvent được cache một lần, không quét ReplicatedStorage liên tục.
local EAT_CONFIG = {
    SEARCH_RADIUS = 350,
    CYCLE_INTERVAL = 1.0,
    STAY_DURATION = 0.32,
    INTERACTION_INTERVAL = 0.11,
    MAX_TARGETS_CHECKED = 222,
    STRICT_MEAT_KEYWORDS = {"carcass", "meat", "corpse", "deadbody", "ribs", "flesh"},
    STRICT_HERB_KEYWORDS = {"bush", "plant", "grass", "foliage", "herb", "fern", "leaves", "berry", "shrub"}
}

local IsExecutingEatOrHerb = false
local EatRemoteCandidates = {}
local EatOverlapParams = OverlapParams.new()
EatOverlapParams.FilterType = Enum.RaycastFilterType.Exclude

local function RefreshEatFilter()
    local char = LocalPlayer.Character
    EatOverlapParams.FilterDescendantsInstances = char and {char} or {}
end

RefreshEatFilter()
LocalPlayer.CharacterAdded:Connect(function()
    task.defer(RefreshEatFilter)
end)

-- Cache các RemoteEvent liên quan một lần.
do
    local ok = pcall(function()
        for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local name = string.lower(remote.Name)
                if name:find("eat") or name:find("bite") or name:find("interact")
                    or name:find("feed") or name:find("consume") or name:find("herb") or name:find("graze") then
                    EatRemoteCandidates[#EatRemoteCandidates + 1] = remote
                end
            end
        end
    end)
    if not ok then
        table.clear(EatRemoteCandidates)
    end
end

local function IsTargetNameMatch(part, keywords)
    local name = string.lower(part.Name)
    local parent = part.Parent
    local parentName = parent and string.lower(parent.Name) or ""

    for i = 1, #keywords do
        local key = keywords[i]
        if name:find(key, 1, true) or parentName:find(key, 1, true) then
            return true
        end
    end
    return false
end

local function IsLivingEntityOrMapDecor(instance)
    local model = instance:FindFirstAncestorOfClass("Model")
    if not model then
        return false
    end

    if Players:GetPlayerFromCharacter(model) then
        return true
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health > 0 then
        return true
    end

    local modelName = string.lower(model.Name)
    return modelName:find("map", 1, true) ~= nil
        or modelName:find("border", 1, true) ~= nil
        or modelName:find("ocean", 1, true) ~= nil
        or modelName:find("decor", 1, true) ~= nil
end

local function ScanNearbyTarget(keywords)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        return nil
    end

    local best = nil
    local bestDistanceSq = EAT_CONFIG.SEARCH_RADIUS * EAT_CONFIG.SEARCH_RADIUS
    local parts = Workspace:GetPartBoundsInRadius(root.Position, EAT_CONFIG.SEARCH_RADIUS, EatOverlapParams)
    local checked = 0

    for i = 1, #parts do
        if checked >= EAT_CONFIG.MAX_TARGETS_CHECKED then
            break
        end

        local part = parts[i]
        if part:IsA("BasePart") and IsTargetNameMatch(part, keywords) and not IsLivingEntityOrMapDecor(part) then
            checked = checked + 1
            local delta = part.Position - root.Position
            local distanceSq = delta.X * delta.X + delta.Y * delta.Y + delta.Z * delta.Z
            if distanceSq < bestDistanceSq then
                bestDistanceSq = distanceSq
                best = part
            end
        end
    end

    return best
end

local function TriggerInteraction(targetPart)
    local prompt = targetPart:FindFirstChildOfClass("ProximityPrompt")
        or (targetPart.Parent and targetPart.Parent:FindFirstChildOfClass("ProximityPrompt"))

    if prompt and typeof(fireproximityprompt) == "function" then
        pcall(fireproximityprompt, prompt)
        return true
    end

    -- Fallback: dùng danh sách RemoteEvent đã cache.
    -- Giữ đủ các payload cũ nhưng chỉ chạy một lần / target thay vì lặp mỗi 0.07s.
    for i = 1, #EatRemoteCandidates do
        local remote = EatRemoteCandidates[i]
        if remote and remote.Parent then
            pcall(function()
                remote:FireServer(targetPart)
                remote:FireServer(targetPart.Parent)
                remote:FireServer("Eat", targetPart)
                remote:FireServer("Herb", targetPart)
            end)
        end
    end

    return #EatRemoteCandidates > 0
end

local function PerformBlink(targetPart)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if IsExecutingEatOrHerb or not root or not char or not targetPart or not targetPart.Parent then
        return
    end

    IsExecutingEatOrHerb = true
    local __kaitunBlinkGen = _G.KaitunGetGen and _G.KaitunGetGen() or 0

    pcall(function()
        local storedCFrame = root.CFrame
        local storedVelocity = root.AssemblyLinearVelocity
        local oldCollision = {}

        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide then
                oldCollision[#oldCollision + 1] = part
                part.CanCollide = false
            end
        end

        root.AssemblyLinearVelocity = Vector3.zero
        root.CFrame = targetPart.CFrame * CFrame.new(0, 1, 0)

        local finishAt = os.clock() + EAT_CONFIG.STAY_DURATION
        local nextInteract = 0
        while os.clock() < finishAt do
            if not targetPart.Parent then
                break
            end
            local now = os.clock()
            if now >= nextInteract then
                TriggerInteraction(targetPart)
                nextInteract = now + EAT_CONFIG.INTERACTION_INTERVAL
            end
            task.wait(0.03)
        end

        -- [#17] Kaitun generation guard: không trả về vị trí cũ nếu engine vừa chuyển chỗ trú
        local __kaitunGenOk = (not _G.KaitunGetGen) or (_G.KaitunGetGen() == __kaitunBlinkGen)
        if root.Parent and __kaitunGenOk then
            root.CFrame = storedCFrame
            root.AssemblyLinearVelocity = storedVelocity
        end

        for i = 1, #oldCollision do
            local part = oldCollision[i]
            if part and part.Parent then
                part.CanCollide = true
            end
        end
    end)

    IsExecutingEatOrHerb = false
end

-- Một worker duy nhất cho cả Meat + Herb.
task.spawn(function()
    while true do
        task.wait(EAT_CONFIG.CYCLE_INTERVAL)

        local active = _G.AutoEatActive or _G.AutoHerbActive
        if active and not IsExecutingEatOrHerb then
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not char or not root or not hum or hum.Health <= 0 then
                    return
                end

                -- Giữ behavior cũ: Herb được ưu tiên nếu cả hai toggle cùng bật.
                local keywords = _G.AutoHerbActive
                    and EAT_CONFIG.STRICT_HERB_KEYWORDS
                    or EAT_CONFIG.STRICT_MEAT_KEYWORDS

                local target = ScanNearbyTarget(keywords)
                if target then
                    PerformBlink(target)
                end
            end)
        end
    end
end)

-- Vòng lặp Quét Quest (Fossils)
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local playerGui = LocalPlayer:WaitForChild("PlayerGui")
            local questsFrame = playerGui:FindFirstChild("GameUI") and playerGui.GameUI:FindFirstChild("QuestsFrame")
            local detectedQuest = "None"
            
            if questsFrame then
                for _, child in pairs(questsFrame:GetChildren()) do
                    local textContent = ""
                    for _, desc in pairs(child:GetDescendants()) do
                        if desc:IsA("TextLabel") then
                            textContent = textContent .. " " .. string.lower(desc.Text)
                        end
                    end
                    
                    if string.find(textContent, "drink water") then
                        detectedQuest = "Drink"
                        break
                    elseif string.find(textContent, "rest") then
                        detectedQuest = "Rest"
                        break
                    end
                end
            end
            
            _G.CurrentQuest = detectedQuest
            
            -- [#5] Kaitun ON + Chế độ ăn None → NHÃN QUEST CHUYỂN ĐỎ + cảnh báo
            if _G.KaitunEnabled and _G.KaitunFeedMode == "None" then
                SetQuestStatus("⚠ KAITUN: CHƯA CHỌN CHẾ ĐỘ ĂN (MEAT/HERB)!", Color3.fromRGB(255, 0, 0))
            elseif detectedQuest == "Drink" then
                SetQuestStatus("Quest Hiện Tại: Uống Nước (Drink)", Color3.fromRGB(50, 150, 255))
            elseif detectedQuest == "Rest" then
                SetQuestStatus("Quest Hiện Tại: Nghỉ Nơi (Rest)", Color3.fromRGB(255, 165, 0))
            else
                SetQuestStatus("Quest Hiện Tại: Đang chờ...", Color3.fromRGB(255, 255, 0))
            end
        end)
    end
end)

task.spawn(function()
    while true do
        if _G.AutoDrinkRunning then
            pcall(function() 
                game:GetService("ReplicatedStorage").Remotes.Character.CharacterFunctions:InvokeServer("Drink") 
            end)
            task.wait(0.8)
        else
            task.wait(0.2)
        end
    end
end)

task.spawn(function()
    local restRemote = game:GetService("ReplicatedStorage").Remotes.Character.Rest
    local isRestingActive = false
    while true do
        task.wait(0.3)
        -- [#7] Rest thông minh khi Kaitun bật: <50% nghỉ — ≥95% dừng (engine điều khiển)
        local shouldRest
        if _G.KaitunEnabled and type(_G.KaitunRestShould) == "function" then
            shouldRest = _G.KaitunRestShould()
        else
            shouldRest = _G.AutoRestRunning and (_G.CurrentQuest == "Rest")
        end
        if shouldRest and not isRestingActive then
            pcall(function() restRemote:InvokeServer(true) end)
            isRestingActive = true
        elseif not shouldRest and isRestingActive then
            pcall(function() restRemote:InvokeServer(false) end)
            isRestingActive = false
        end
    end
end)

local function IsThisZoneGreen(targetPos)
    local isGreen = false
    pcall(function()
        local folder = game:GetService("Workspace").MapResources.Zones
        for _, zoneObj in pairs(folder:GetChildren()) do
            local core = zoneObj:FindFirstChild("LightCore")
            if core and (core.Position - targetPos).Magnitude < 15 then
                local color = core.Color
                if color.R == 0 and color.G > 0.9 and color.B == 0 then isGreen = true end
                break
            end
        end
    end)
    return isGreen
end

local ZonesList = {
    Vector3.new(-144.54, -102.15, 1032.19),
    Vector3.new(-617.92, 143.39, -1130.44),
    Vector3.new(1449.99, 77.16, -677.59),
    Vector3.new(276.03, 75.50, -1029.02),
    Vector3.new(-513.23, 75.73, -430.79),
    Vector3.new(1090.65, 66.03, 467.14),
    Vector3.new(209.25, -32.79, -359.19),
    Vector3.new(-170.20, 109.98, 388.42),
    Vector3.new(-69.11, -61.16, -1493.54)
}

task.spawn(function()
    while true do
        if _G.AutoZoneRunning then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local safetyZone3CFrame = CFrame.new(1449.99, 77.16 + 5, -677.59)
                for i = 1, #ZonesList do
                    if not _G.AutoZoneRunning then break end
                    local zonePos = ZonesList[i]
                    local targetCFrame = CFrame.new(zonePos.X, zonePos.Y + 5, zonePos.Z)
                    
                    if not IsThisZoneGreen(zonePos) then
                        hrp.CFrame = targetCFrame
                        task.wait(0.1)
                        local startTime = tick()
                        local lastCheckTime = 0
                        
                        while _G.AutoZoneRunning do
                            local now = tick()
                            
                            -- Chỉ quét kiểm tra xem Zone đã XANH chưa mỗi 0.5 giây (Tiết kiệm 90% CPU)
                            if now - lastCheckTime >= 0.5 then
                                lastCheckTime = now
                                if IsThisZoneGreen(zonePos) or (now - startTime >= 15) then 
                                    break 
                                end
                            end
                            
                            -- Giữ hiệu ứng rung lắc nhưng tăng thời gian chờ lên 0.08s (khoảng 12 lần/giây)
                            local shakeX = math.sin(now * 8) * 0.35
                            local shakeZ = math.cos(now * 8) * 0.35
                            hrp.CFrame = targetCFrame * CFrame.new(shakeX, 0, shakeZ)
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            task.wait(0.08)
                        end
                        task.wait(0.3)
                    end
                end
                if hrp and _G.AutoZoneRunning then hrp.CFrame = safetyZone3CFrame end
                task.wait(3)
            else
                task.wait(0.5)
            end
        else
            task.wait(0.2)
        end
    end
end)

----------------------------------------------------



-- ╔══════════════════════════════════════════════════════════════════╗
-- ║          🐾 KAITUN ENGINE — AUTO NUÔI + SMART HIDE                ║
-- ╠══════════════════════════════════════════════════════════════════╣
-- ║ #2  Scan food 100m→200m→300m→500m (cooldown 0.3/0.5/0.5/1.0s)    ║
-- ║ #3  Ngưỡng ăn: <50% bắt đầu — ≥95% dừng (có hysteresis)          ║
-- ║ #6  Drink giữ nguyên: spam remote 0.8s                           ║
-- ║ #7  Rest thông minh: <50% nghỉ — ≥95% dừng                       ║
-- ║ #9  KHÔNG dùng safe zone dòng 1790 (pet không vào được)          ║
-- ║ #10 Bật Kaitun → tele Hide Spot 1 NGAY LẬP TỨC                   ║
-- ║ #11 Ẩn khi: Quest None/xong + Đói≥80% + Khát≥80% + Kaitun ON     ║
-- ║ #12 Anti-stuck: 30s không thấy food → Hide 1, chờ 10s            ║
-- ║ #13 Đói <10% → LocalPlayer:Kick (auto shutdown)                  ║
-- ║ #14 L1: quét địch 150m trước khi tele                            ║
-- ║ #15 L2: attack thật (địch + mất máu) vs bleed (mất máu không địch)║
-- ║ #16 Cooldown switch 15s                                          ║
-- ║ #17 L3: cycle Hide1 → Hide2 → Sky → Hide1 ...                    ║
-- ║ #18 Sky: tele lên + anchor 60s → tự về Hide 1                    ║
-- ║ #19 Bleed: KHÔNG switch, chỉ notify                              ║
-- ╚══════════════════════════════════════════════════════════════════╝

local KAITUN_SKY_PROVIDED = false
local KAITUN_SHOW_MARKERS = true -- v2.2: BillboardGui đánh dấu 3 điểm trú
local KAITUN_FOOD_ESP   = true -- v2.4: Highlight đồ ăn quanh bạn
local KAITUN_PLAYER_HUD = true -- v2.4: HUD chỉ số nhỏ góc màn hình
local KAITUN_ESP_RANGE  = 600 -- v2.6: bán kính quét ESP food (m)
local KAITUN_ANTI_AFK   = true -- v2.6: chặn kick AFK 20 phút
local KAITUN_AUTO_REJOIN = true -- v2.6: lỗi teleport → tự vào lại
local KAITUN_AUTO_HOP   = false -- v2.7: server đông → tự nhảy server vắng

local KAITUN_CONFIG = {
    FEED_MODE          = "None",  -- đồng bộ dropdown (#4: mặc định None)
    SCAN_STEPS         = { {100, 0.3}, {200, 0.5}, {300, 0.5}, {500, 1} }, -- #2

    EAT_START_PERCENT  = 50,  -- #3 (web-tunable)
    EAT_STOP_PERCENT   = 95,   -- #3
    REST_START_PERCENT = 50, -- #7
    REST_STOP_PERCENT  = 95,  -- #7

    HIDE_HUNGER_MIN    = 80, -- #11
    HIDE_THIRST_MIN    = 80, -- #11
    KICK_HUNGER        = 10,    -- #13

    ENEMY_SCAN_RANGE   = 150, -- #14
    SWITCH_COOLDOWN    = 15, -- #16
    SKY_ANCHOR_TIME    = 60,  -- #18

    ANTISTUCK_NOFOOD   = 30, -- #12
    ANTISTUCK_WAIT     = 10,   -- #12

    HIDE_SPOT_1        = Vector3.new(-965.171, 114.720, -418.536), -- #20
    HIDE_SPOT_2        = Vector3.new(-589.342, 93.005, -1322.879), -- #21
    SKY_SPOT           = Vector3.new(-777.800, 450.000, -777.800), -- ⚠ ITEM #22: CHỜ CUNG CẤP TỌA ĐỘ! Sửa ở Kaitun Control Panel (web),

    HOP_PLAYER_MAX     = 12,      -- v2.7: đông hơn mức này → hop
    HOP_CHECK_INTERVAL = 120,  -- v2.7: chu kỳ kiểm tra (s)
    HOP_SERVER_LIMIT   = 100,    -- v2.8: số server mỗi trang API (tối đa 100)
    HOP_MAX_PAGES      = 2,       -- v2.8: quét tối đa bao nhiêu trang (cursor)
}

if not _G.KaitunNotify then
    _G.KaitunNotify = function(text, duration)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "🐾 Kaitun", Text = tostring(text), Duration = duration or 4
            })
        end)
    end
end

-- ═══════════ [KAITUN v2.2] WEBHOOK DISCORD — đẩy notify lên server ngoài ═══════════
local KAITUN_WEBHOOK_URL = ""
local KAITUN_WEBHOOK_ON  = false

if KAITUN_WEBHOOK_ON and KAITUN_WEBHOOK_URL ~= "" and not _G.KaitunWebhookWrapped then
    _G.KaitunWebhookWrapped = true
    local __baseNotify = _G.KaitunNotify
    -- v2.10: lọc LOẠI sự kiện đẩy lên Discord (in-game vẫn hiện đủ, chỉ lọc khi push)
    local WEBHOOK_FILTER = {
        switch    = true,
        bleed     = true,
        antistuck = true,
        kick      = true,
        status    = true, -- v2.11: BẬT/TẮT, engine sẵn sàng
        warn      = true,   -- v2.11: cảnh báo mode None, dropdown lỗi
    }
    local function sendWebhook(text)
        pcall(function()
            local req = (typeof(syn) == "table" and syn.request)
                or (typeof(http) == "table" and http.request)
                or http_request or request
            if not req then return end
            local body = game:GetService("HttpService"):JSONEncode({
                username = "🐾 Kaitun",
                content = tostring(text):sub(1, 1800),
            })
            req({
                Url = KAITUN_WEBHOOK_URL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = body,
            })
        end)
    end
    _G.KaitunNotify = function(text, duration, tag)
        if __baseNotify then pcall(__baseNotify, text, duration) end
        -- v2.11: tag là loại sự kiện (switch/bleed/antistuck/kick/status/warn) — bị tắt lọc thì KHÔNG push Discord
        if tag ~= nil and WEBHOOK_FILTER[tostring(tag)] == false then return end
        task.spawn(sendWebhook, "🐾 Kaitun • " .. tostring(text))
    end
    _G.KaitunWebhookTest = sendWebhook
    task.delay(3, function()
        local parts = {}
        if WEBHOOK_FILTER.switch then table.insert(parts, "switch chỗ trú") end
        if WEBHOOK_FILTER.bleed then table.insert(parts, "bleed") end
        if WEBHOOK_FILTER.antistuck then table.insert(parts, "anti-stuck") end
        if WEBHOOK_FILTER.kick then table.insert(parts, "kick") end
        if WEBHOOK_FILTER.status then table.insert(parts, "trạng thái") end
        if WEBHOOK_FILTER.warn then table.insert(parts, "cảnh báo") end
        local list = #parts > 0 and table.concat(parts, ", ") or "(mọi loại đã tắt — chỉ notify trong game)"
        sendWebhook("✅ Kaitun v2.11 đã kết nối webhook — sẽ báo: " .. list .. ".")
    end)
end

-- ═══════════ [KAITUN] TRẠNG THÁI NỘI BỘ ═══════════
local KState = {
    currentSpot       = 1,   -- 1=Hide1, 2=Hide2, 3=Sky (theo SPOT_CYCLE)
    lastSwitchAt      = 0,
    lastFoodSeenAt    = os.clock(),
    antistuckUntil    = 0,
    eating            = false,
    eatActive         = false, -- hysteresis #3: <50% bật — ≥95% tắt
    gen               = 0,     -- tăng mỗi lần engine tự di chuyển (chống xung đột blink #17)
    lastHealth        = nil,
    lastBleedNotifyAt = 0,
    drinkDriven       = false,
}

_G.KaitunEnabled    = _G.KaitunEnabled or false
_G.KaitunFeedMode   = _G.KaitunFeedMode or "None"
_G.KaitunRestActive = false
_G.KaitunSkyAnchored = false
_G.KaitunGetGen     = function() return KState.gen end

local function bumpGen()
    KState.gen = KState.gen + 1
    return KState.gen
end

-- ═══════════ [KAITUN] HELPERS NHÂN VẬT ═══════════
local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function teleportTo(spot, extraY)
    local hrp = getRoot()
    if not hrp then return false end
    hrp.Anchored = false
    hrp.AssemblyLinearVelocity = Vector3.zero
    bumpGen()
    for _ = 1, 5 do
        hrp.CFrame = CFrame.new(spot.X, spot.Y + (extraY or 3), spot.Z)
        task.wait(0.03)
    end
    return true
end

-- ═══════════ [KAITUN] ĐỌC CHỈ SỐ ĐÓI / KHÁT / THỂ LỰC ═══════════
local STAT_ALIASES = {
    Hunger = { "hunger", "food", "doi" },
    Thirst = { "thirst", "water", "khat" },
    Rest   = { "energy", "stamina", "rest", "sleep" },
}

local function readNumber(v)
    if typeof(v) == "number" then return v end
    if typeof(v) == "string" then
        local pct = string.match(v, "(%d+)%s*%%")
        if pct then return tonumber(pct) end
        local num = string.match(v, "(%d+)")
        if num then return tonumber(num) end
    end
    return nil
end

local function normalizePercent(v)
    if not v then return nil end
    if v <= 1 then return v * 100 end
    return v
end

local function matchKey(name, keys)
    local n = string.lower(tostring(name))
    for _, k in ipairs(keys) do
        if string.find(n, k, 1, true) then return true end
    end
    return false
end

local function scanGuiForStat(keys)
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    -- (a) TextLabel/TextBox có tên khớp → đọc số trong Text
    for _, obj in ipairs(pg:GetDescendants()) do
        if (obj:IsA("TextLabel") or obj:IsA("TextBox")) and matchKey(obj.Name, keys) then
            local v = readNumber(obj.Text)
            if v then return normalizePercent(v) end
        end
    end
    -- (b) Frame/bar có tên khớp → lấy scale X (thanh %)
    for _, obj in ipairs(pg:GetDescendants()) do
        if obj:IsA("Frame") and matchKey(obj.Name, keys) and obj.Size.X.Scale > 0 then
            return obj.Size.X.Scale * 100
        end
    end
    return nil
end

local function getStatPercent(kind)
    local keys = STAT_ALIASES[kind]
    if not keys then return nil end
    -- (1) Attribute trên nhân vật / player
    local char = LocalPlayer.Character
    if char then
        for _, attrName in ipairs(char:GetAttributes()) do
            if matchKey(attrName, keys) then
                local v = readNumber(char:GetAttribute(attrName))
                if v then return normalizePercent(v) end
            end
        end
    end
    for _, attrName in ipairs(LocalPlayer:GetAttributes()) do
        if matchKey(attrName, keys) then
            local v = readNumber(LocalPlayer:GetAttribute(attrName))
            if v then return normalizePercent(v) end
        end
    end
    -- (2) leaderstats
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    if ls then
        for _, child in ipairs(ls:GetChildren()) do
            if child:IsA("ValueBase") and matchKey(child.Name, keys) then
                local v = readNumber(child.Value)
                if v then return normalizePercent(v) end
            end
        end
    end
    -- (3) PlayerGui
    return scanGuiForStat(keys)
end

-- ═══════════ [KAITUN #14] LỚP 1 — QUÉT ĐỊCH 150m ═══════════
local HOSTILE_KEYWORDS = { "raptor", "trex", "t-rex", "tyrann", "carno", "spino", "allosaur", "giga", "baryonyx", "wolf", "bear", "saber", "carnivore", "predator" }

local EnemyOverlapParams = OverlapParams.new()
EnemyOverlapParams.FilterType = Enum.RaycastFilterType.Exclude

local function refreshEnemyFilter()
    local char = LocalPlayer.Character
    EnemyOverlapParams.FilterDescendantsInstances = char and { char } or {}
end
refreshEnemyFilter()
LocalPlayer.CharacterAdded:Connect(function()
    task.defer(refreshEnemyFilter)
end)

-- Khoảng cách tới địch gần nhất quanh 1 vị trí (nil = an toàn)
local function nearestEnemyDistance(fromPos, range)
    local nearest = nil
    -- (a) Người chơi khác (mối đe dọa PVP)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
                or plr.Character:FindFirstChild("UpperTorso")
                or plr.Character:FindFirstChild("Torso")
            if hum and hum.Health > 0 and root then
                local d = (root.Position - fromPos).Magnitude
                if d <= range and (not nearest or d < nearest) then
                    nearest = d
                end
            end
        end
    end
    -- (b) NPC dữ theo tên model (spatial query cho nhẹ máy)
    local ok, parts = pcall(function()
        return Workspace:GetPartBoundsInRadius(fromPos, range, EnemyOverlapParams)
    end)
    if ok and parts then
        local checked = 0
        for i = 1, #parts do
            if checked >= 100 then break end
            local model = parts[i]:FindFirstAncestorOfClass("Model")
            if model and not Players:GetPlayerFromCharacter(model) and matchKey(model.Name, HOSTILE_KEYWORDS) then
                checked = checked + 1
                local hum = model:FindFirstChildOfClass("Humanoid")
                local root = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or parts[i]
                if hum and hum.Health > 0 then
                    local d = (root.Position - fromPos).Magnitude
                    if d <= range and (not nearest or d < nearest) then
                        nearest = d
                    end
                end
            end
        end
    end
    return nearest
end

local function isSpotSafe(spotPos, range)
    return nearestEnemyDistance(spotPos, range or KAITUN_CONFIG.ENEMY_SCAN_RANGE) == nil
end

-- ═══════════ [KAITUN #17] LỚP 3 — CYCLE HIDE1 → HIDE2 → SKY ═══════════
local SPOT_CYCLE = { "HIDE1", "HIDE2" }
if KAITUN_SKY_PROVIDED then
    SPOT_CYCLE[#SPOT_CYCLE + 1] = "SKY" -- #22: có tọa độ mới thêm Sky vào cycle
end

local function spotPosition(key)
    if key == "HIDE1" then return KAITUN_CONFIG.HIDE_SPOT_1 end
    if key == "HIDE2" then return KAITUN_CONFIG.HIDE_SPOT_2 end
    return KAITUN_CONFIG.SKY_SPOT
end

local function spotName(key)
    if key == "HIDE1" then return "Hide Spot 1" end
    if key == "HIDE2" then return "Hide Spot 2" end
    return "Sky Spot"
end

local function performSwitch(reason)
    -- #16: cooldown switch 15s
    if os.clock() - KState.lastSwitchAt < KAITUN_CONFIG.SWITCH_COOLDOWN then
        return false
    end
    local hrp = getRoot()
    if not hrp then return false end

    local startIdx = KState.currentSpot
    for step = 1, #SPOT_CYCLE do
        local idx = ((startIdx - 1 + step) % #SPOT_CYCLE) + 1
        local key = SPOT_CYCLE[idx]
        local pos = spotPosition(key)

        if key == "SKY" then
            -- #18: tele lên trời + anchor 60s + tự về Hide 1
            KState.lastSwitchAt = os.clock()
            KState.currentSpot = idx
            local myGen = bumpGen()
            _G.KaitunSkyAnchored = true
            hrp.Anchored = false
            hrp.AssemblyLinearVelocity = Vector3.zero
            for _ = 1, 5 do
                hrp.CFrame = CFrame.new(pos.X, pos.Y + 3, pos.Z)
                task.wait(0.03)
            end
            hrp.Anchored = true
            _G.KaitunNotify("🌪 ATTACK → BAY LÊN SKY SPOT! Neo " .. KAITUN_CONFIG.SKY_ANCHOR_TIME .. "s rồi tự về Hide 1", 5, "switch")
            task.delay(KAITUN_CONFIG.SKY_ANCHOR_TIME, function()
                local h = getRoot()
                if not h then return end
                if KState.gen ~= myGen or not _G.KaitunEnabled then
                    h.Anchored = false -- có lệnh mới hơn hoặc đã tắt → chỉ gỡ neo
                    _G.KaitunSkyAnchored = false
                    return
                end
                h.Anchored = false
                _G.KaitunSkyAnchored = false
                teleportTo(KAITUN_CONFIG.HIDE_SPOT_1)
                KState.currentSpot = 1
                KState.lastSwitchAt = os.clock()
                _G.KaitunNotify("⬇ Hết " .. KAITUN_CONFIG.SKY_ANCHOR_TIME .. "s trên trời → về Hide Spot 1", 4, "switch")
            end)
            return true
        end

        -- #14 LỚP 1: kiểm tra spot an toàn (quét địch 150m) trước khi tele
        local enemyDist = nearestEnemyDistance(pos, KAITUN_CONFIG.ENEMY_SCAN_RANGE)
        if enemyDist == nil then
            KState.lastSwitchAt = os.clock()
            KState.currentSpot = idx
            teleportTo(pos)
            _G.KaitunNotify("🛡 " .. tostring(reason or "Địch attack") .. " → chuyển tới " .. spotName(key) .. " (check an toàn 150m ✓)", 4, "switch")
            return true
        else
            _G.KaitunNotify("⚠ " .. spotName(key) .. " KHÔNG an toàn (địch ~" .. tostring(math.floor(enemyDist)) .. "m) — thử điểm kế tiếp...", 3, "switch")
        end
    end
    _G.KaitunNotify("❌ Cả cycle đều không an toàn! Ở nguyên vị trí, thử lại sau cooldown 15s.", 4, "switch")
    return false
end

-- ═══════════ [KAITUN #15] LỚP 2 — ATTACK THẬT vs BLEED ═══════════
task.spawn(function()
    while true do
        task.wait(0.2)
        if not _G.KaitunEnabled then
            local hum = getHumanoid()
            KState.lastHealth = hum and hum.Health or nil
        else
            local hum = getHumanoid()
            if hum and hum.Health > 0 then
                local now = os.clock()
                if KState.lastHealth == nil then
                    KState.lastHealth = hum.Health
                elseif hum.Health < KState.lastHealth - 0.5 then
                    KState.lastHealth = hum.Health
                    local root = getRoot()
                    if root and not _G.KaitunSkyAnchored then
                        local enemyDist = nearestEnemyDistance(root.Position, KAITUN_CONFIG.ENEMY_SCAN_RANGE)
                        if enemyDist then
                            -- ATTACK THẬT: có địch + mất máu → L3 cycle (#17)
                            performSwitch("Attack thật (địch " .. math.floor(enemyDist) .. "m + mất máu)")
                        elseif now - KState.lastBleedNotifyAt >= 10 then
                            -- #19 BLEED: mất máu, không địch → KHÔNG switch, chỉ notify
                            KState.lastBleedNotifyAt = now
                            _G.KaitunNotify("🩸 Đang mất máu nhưng KHÔNG có địch trong 150m → BLEED. Không đổi chỗ, chỉ theo dõi.", 4, "bleed")
                        end
                    end
                elseif hum.Health > KState.lastHealth then
                    KState.lastHealth = hum.Health
                end
            else
                KState.lastHealth = nil
            end
        end
    end
end)

-- ═══════════ [KAITUN #2][#3][#12] SCAN FOOD + VÒNG LẶP ĂN ═══════════
local EAT_KEYWORDS = {
    Meat = EAT_CONFIG.STRICT_MEAT_KEYWORDS, -- giữ nguyên keyword thịt của bản gốc
    Herb = EAT_CONFIG.STRICT_HERB_KEYWORDS, -- giữ nguyên keyword cỏ của bản gốc
}

local function scanFoodAtRange(radius, keywords)
    local root = getRoot()
    if not root then return nil end
    local ok, parts = pcall(function()
        return Workspace:GetPartBoundsInRadius(root.Position, radius, EatOverlapParams)
    end)
    if not ok or not parts then return nil end
    local best, bestDist = nil, math.huge
    local checked = 0
    for i = 1, #parts do
        if checked >= EAT_CONFIG.MAX_TARGETS_CHECKED then break end
        local part = parts[i]
        if part:IsA("BasePart") and IsTargetNameMatch(part, keywords) and not IsLivingEntityOrMapDecor(part) then
            checked = checked + 1
            local d = (part.Position - root.Position).Magnitude
            if d < bestDist then
                best, bestDist = part, d
            end
        end
    end
    return best
end

task.spawn(function()
    while true do
        task.wait(0.3)
        local mode = _G.KaitunFeedMode
        if (not _G.KaitunEnabled) or mode == "None" or _G.KaitunSkyAnchored or os.clock() < KState.antistuckUntil then
            KState.eating = false
            KState.eatActive = false
            KState.lastFoodSeenAt = os.clock()
        else
            local hunger = getStatPercent("Hunger")
            local shouldEat
            if hunger then
                -- #3 hysteresis: <50% bắt đầu — chỉ dừng khi ≥95%
                if hunger < KAITUN_CONFIG.EAT_START_PERCENT then
                    KState.eatActive = true
                elseif hunger >= KAITUN_CONFIG.EAT_STOP_PERCENT then
                    KState.eatActive = false
                end
                shouldEat = KState.eatActive
            else
                shouldEat = true -- không đọc được chỉ số → ăn theo chu kỳ an toàn
            end

            if shouldEat and not IsExecutingEatOrHerb then
                KState.eating = true
                local keywords = EAT_KEYWORDS[mode] or EAT_CONFIG.STRICT_MEAT_KEYWORDS
                local found = nil
                -- #2: scan tăng cấp 100m → 200m → 300m → 500m (cooldown 0.3/0.5/0.5/1.0s)
                for _, stepCfg in ipairs(KAITUN_CONFIG.SCAN_STEPS) do
                    found = scanFoodAtRange(stepCfg[1], keywords)
                    if found then
                        KState.lastFoodSeenAt = os.clock()
                        break
                    end
                    task.wait(stepCfg[2])
                end
                if found then
                    PerformBlink(found) -- tái dùng cơ chế blink-ăn của bản gốc
                elseif os.clock() - KState.lastFoodSeenAt >= KAITUN_CONFIG.ANTISTUCK_NOFOOD then
                    -- #12 anti-stuck
                    _G.KaitunNotify("⛔ " .. KAITUN_CONFIG.ANTISTUCK_NOFOOD .. "s KHÔNG thấy food (500m) → về Hide Spot 1, chờ " .. KAITUN_CONFIG.ANTISTUCK_WAIT .. "s rồi thử lại", 5, "antistuck")
                    teleportTo(KAITUN_CONFIG.HIDE_SPOT_1)
                    KState.currentSpot = 1
                    KState.antistuckUntil = os.clock() + KAITUN_CONFIG.ANTISTUCK_WAIT
                    KState.lastFoodSeenAt = os.clock()
                end
            else
                KState.eating = false
                KState.lastFoodSeenAt = os.clock()
            end
        end
    end
end)

-- ═══════════ [KAITUN #11] VÒNG LẶP ẨN THÔNG MINH ═══════════
task.spawn(function()
    while true do
        task.wait(1)
        if _G.KaitunEnabled and not _G.KaitunSkyAnchored and os.clock() >= KState.antistuckUntil then
            local quest = _G.CurrentQuest -- #8: "None" | "Drink" | "Rest" (quest detection giữ nguyên)
            local hunger = getStatPercent("Hunger")
            local thirst = getStatPercent("Thirst")
            local hungerOk = (hunger == nil) or (hunger >= KAITUN_CONFIG.HIDE_HUNGER_MIN)
            local thirstOk = (thirst == nil) or (thirst >= KAITUN_CONFIG.HIDE_THIRST_MIN)
            local hideOk = quest == "None" and hungerOk and thirstOk and not KState.eating
            if hideOk then
                local hrp = getRoot()
                if hrp then
                    local key = SPOT_CYCLE[KState.currentSpot] or "HIDE1"
                    if key ~= "SKY" then
                        local pos = spotPosition(key)
                        if (hrp.Position - pos).Magnitude > 12 then
                            if isSpotSafe(pos, KAITUN_CONFIG.ENEMY_SCAN_RANGE) then
                                teleportTo(pos)
                            else
                                performSwitch("Chỗ ẩn hiện tại có địch")
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ═══════════ [KAITUN #6] DRINK — giữ nguyên spam remote 0.8s ═══════════
task.spawn(function()
    while true do
        task.wait(1)
        if _G.KaitunEnabled then
            KState.drinkDriven = true
            local thirst = getStatPercent("Thirst")
            if thirst == nil then
                _G.AutoDrinkRunning = true -- không đọc được → spam 0.8s liên tục như bản gốc
            else
                _G.AutoDrinkRunning = thirst < KAITUN_CONFIG.EAT_STOP_PERCENT
            end
        elseif KState.drinkDriven then
            KState.drinkDriven = false
            _G.AutoDrinkRunning = false
        end
    end
end)

-- ═══════════ [KAITUN #7] REST — <50% nghỉ, ≥95% dừng ═══════════
task.spawn(function()
    while true do
        task.wait(1)
        if _G.KaitunEnabled then
            local rest = getStatPercent("Rest")
            if rest then
                if rest < KAITUN_CONFIG.REST_START_PERCENT then
                    _G.KaitunRestActive = true
                elseif rest >= KAITUN_CONFIG.REST_STOP_PERCENT then
                    _G.KaitunRestActive = false
                end
            else
                _G.KaitunRestActive = false
            end
        else
            _G.KaitunRestActive = false
        end
    end
end)

-- ═══════════ [KAITUN #13] ĐÓI <10% → SHUTDOWN (LocalPlayer:Kick) ═══════════
task.spawn(function()
    while true do
        task.wait(2)
        if _G.KaitunEnabled then
            local hunger = getStatPercent("Hunger")
            if hunger and hunger < KAITUN_CONFIG.KICK_HUNGER then
                _G.KaitunNotify("☠ ĐÓI < " .. KAITUN_CONFIG.KICK_HUNGER .. "%! Tự động thoát game để bảo vệ...", 3, "kick")
                task.wait(1.5)
                pcall(function()
                    LocalPlayer:Kick("[Kaitun] Hunger < 10% → Auto shutdown để bảo vệ pet!")
                end)
            end
        end
    end
end)

-- ═══════════ [KAITUN #10] BẬT / TẮT ═══════════
function _G.KaitunSetEnabled(state)
    _G.KaitunEnabled = state == true
    local hrp = getRoot()
    if _G.KaitunEnabled then
        bumpGen()
        KState.currentSpot = 1
        KState.lastSwitchAt = os.clock()
        KState.lastFoodSeenAt = os.clock()
        KState.antistuckUntil = 0
        KState.eatActive = false
        -- #10: tele Hide Spot 1 NGAY LẬP TỨC
        if hrp then
            hrp.Anchored = false
            teleportTo(KAITUN_CONFIG.HIDE_SPOT_1)
        end
        if _G.KaitunFeedMode == "None" then
            _G.KaitunNotify("⚠ KAITUN BẬT nhưng Chế Độ Ăn = None! Quest label chuyển ĐỎ — hãy chọn Meat hoặc Herb!", 7, "warn")
        else
            _G.KaitunNotify("✅ Kaitun BẬT • Chế độ ăn: " .. tostring(_G.KaitunFeedMode) .. " • Đã tele về Hide Spot 1", 5, "status")
        end
    else
        bumpGen()
        _G.KaitunSkyAnchored = false
        _G.KaitunRestActive = false
        if hrp then hrp.Anchored = false end
        _G.KaitunNotify("⛔ Kaitun TẮT — đã gỡ neo & trả lại điều khiển", 4, "status")
    end
    if _G.KaitunUpdateStatus then _G.KaitunUpdateStatus() end
end

-- Respawn: quay lại chỗ trú hiện tại
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1.2)
    if _G.KaitunEnabled then
        KState.lastHealth = nil
        local key = SPOT_CYCLE[KState.currentSpot] or "HIDE1"
        if key ~= "SKY" and getRoot() then
            teleportTo(spotPosition(key))
        end
    end
end)

-- ═══════════ [KAITUN] KHỞI ĐỘNG ═══════════
_G.KaitunRestShould = function()
    return _G.KaitunRestActive == true
end

if false then
    _G.KaitunEnabled = true
    task.delay(2, function()
        if _G.KaitunSetEnabled and _G.KaitunEnabled then
            _G.KaitunSetEnabled(true) -- #10: bật từ đầu → tele Hide 1 ngay sau khi load
        end
    end)
end

if KAITUN_SKY_PROVIDED then
    _G.KaitunNotify("🐾 Kaitun Engine sẵn sàng • Cycle ẩn: Hide 1 → Hide 2 → Sky (#17)", 6, "status")
else
    _G.KaitunNotify("🐾 Kaitun Engine sẵn sàng • Sky Spot CHƯA có tọa độ (#22) → cycle 2 điểm Hide 1 ↔ Hide 2", 7, "status")
end

-- ═══════════ [KAITUN v2.2] BILLBOARD MARKER TẠI 3 ĐIỂM TRÚ ═══════════
-- Giúp bạn dễ xác minh tọa độ trong game (bay ngang là thấy cột mốc)
if KAITUN_SHOW_MARKERS then
    task.spawn(function()
        local markers = {
            { name = "KaitunMarker1", pos = KAITUN_CONFIG.HIDE_SPOT_1, label = "🐾 HIDE SPOT 1", color = Color3.fromRGB(0, 255, 130) },
            { name = "KaitunMarker2", pos = KAITUN_CONFIG.HIDE_SPOT_2, label = "🐾 HIDE SPOT 2", color = Color3.fromRGB(255, 190, 60) },
        }
        if KAITUN_SKY_PROVIDED then
            markers[#markers + 1] = { name = "KaitunMarkerSky", pos = KAITUN_CONFIG.SKY_SPOT, label = "🌤 SKY SPOT", color = Color3.fromRGB(120, 255, 230) }
        end
        for _, m in ipairs(markers) do
            pcall(function()
                local old = Workspace:FindFirstChild(m.name)
                if old then old:Destroy() end
                local part = Instance.new("Part")
                part.Name = m.name
                part.Anchored = true
                part.CanCollide = false
                part.Transparency = 1
                part.Size = Vector3.new(1, 1, 1)
                part.Position = m.pos
                part.Parent = Workspace
                local bb = Instance.new("BillboardGui")
                bb.Size = UDim2.new(0, 170, 0, 40)
                bb.StudsOffset = Vector3.new(0, 4, 0)
                bb.AlwaysOnTop = true
                bb.Parent = part
                local tl = Instance.new("TextLabel")
                tl.Size = UDim2.new(1, 0, 1, 0)
                tl.BackgroundTransparency = 1
                tl.Text = m.label
                tl.TextColor3 = m.color
                tl.TextStrokeTransparency = 0.2
                tl.Font = Enum.Font.GothamBold
                tl.TextSize = 14
                tl.Parent = bb
            end)
        end
    end)
end

-- ═══════════ [KAITUN v2.4] ESP FOOD — khoanh sáng đồ ăn gần bạn ═══════════
-- Tái dùng keyword STRICT_MEAT/HERB của bản gốc + bộ lọc entity/map decor của engine.
-- Quét 5s/lần trong bán kính KAITUN_ESP_RANGE (web-tunable v2.6), tối đa 25 mục — Highlight + Billboard khoảng cách.
if KAITUN_FOOD_ESP then
    task.spawn(function()
        local ESP_RADIUS, ESP_MAX, ESP_TICK = KAITUN_ESP_RANGE, 25, 5
        local tracked = {} -- [part] = { hl = Highlight, holder = Part, label = TextLabel }

        local function espKeywords()
            local mode = _G.KaitunFeedMode
            if mode == "Meat" then return EAT_CONFIG.STRICT_MEAT_KEYWORDS end
            if mode == "Herb" then return EAT_CONFIG.STRICT_HERB_KEYWORDS end
            local both = {}
            for _, k in ipairs(EAT_CONFIG.STRICT_MEAT_KEYWORDS) do both[#both + 1] = k end
            for _, k in ipairs(EAT_CONFIG.STRICT_HERB_KEYWORDS) do both[#both + 1] = k end
            return both
        end

        local function release(part)
            local t = tracked[part]
            if t then
                if t.hl then pcall(function() t.hl:Destroy() end) end
                if t.holder then pcall(function() t.holder:Destroy() end) end
                tracked[part] = nil
            end
        end

        while true do
            task.wait(ESP_TICK)
            local ok, err = pcall(function()
                local root = getRoot()
                local kws = espKeywords()
                -- 1) dọn các mục không còn hợp lệ (biến mất / quá xa / đổi mode)
                for part in pairs(tracked) do
                    local dead = part.Parent == nil
                    if not dead and root then
                        dead = (part.Position - root.Position).Magnitude > ESP_RADIUS + 100
                    end
                    if not dead then dead = not IsTargetNameMatch(part, kws) end
                    if dead then release(part) end
                end
                if not root then return end
                -- 2) quét thêm mục mới (gần nhất trước) nếu còn chỗ trống
                local count = 0
                for _ in pairs(tracked) do count = count + 1 end
                if count >= ESP_MAX then return end
                local okP, parts = pcall(function()
                    return Workspace:GetPartBoundsInRadius(root.Position, ESP_RADIUS, EatOverlapParams)
                end)
                if not okP or not parts then return end
                local candidates = {}
                for i = 1, #parts do
                    local part = parts[i]
                    if part:IsA("BasePart")
                        and not tracked[part]
                        and IsTargetNameMatch(part, kws)
                        and not IsLivingEntityOrMapDecor(part) then
                        local d = (part.Position - root.Position).Magnitude
                        candidates[#candidates + 1] = { part = part, dist = d }
                        if #candidates >= ESP_MAX then break end
                    end
                end
                table.sort(candidates, function(a, b) return a.dist < b.dist end)
                for _, c in ipairs(candidates) do
                    local n = 0
                    for _ in pairs(tracked) do n = n + 1 end
                    if n >= ESP_MAX then break end
                    if c.part.Parent and not tracked[c.part] then
                        local hl = Instance.new("Highlight")
                        hl.Name = "KaitunFoodHighlight"
                        hl.FillColor = Color3.fromRGB(255, 170, 40)
                        hl.OutlineColor = Color3.fromRGB(255, 220, 120)
                        hl.FillTransparency = 0.72
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Adornee = c.part
                        hl.Parent = c.part
                        local holder = Instance.new("Part")
                        holder.Name = "KaitunFoodESPLabel"
                        holder.Anchored = true
                        holder.CanCollide = false
                        holder.CanQuery = false
                        holder.Transparency = 1
                        holder.Size = Vector3.new(1, 1, 1)
                        holder.Position = c.part.Position + Vector3.new(0, 4, 0)
                        holder.Parent = Workspace
                        local bb = Instance.new("BillboardGui")
                        bb.Size = UDim2.new(0, 110, 0, 26)
                        bb.AlwaysOnTop = true
                        bb.Parent = holder
                        local tl = Instance.new("TextLabel")
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.Text = string.format("🍖 %dm", math.floor(c.dist + 0.5))
                        tl.TextColor3 = Color3.fromRGB(255, 200, 90)
                        tl.TextStrokeTransparency = 0.3
                        tl.Font = Enum.Font.GothamBold
                        tl.TextSize = 12
                        tl.Parent = bb
                        tracked[c.part] = { hl = hl, holder = holder, label = tl }
                    end
                end
            end)
            if not ok and err then
                _G.KaitunNotify("ESP food lỗi: " .. tostring(err):sub(1, 80), 3)
            end
        end
    end)
end

-- ═══════════ [KAITUN v2.4] PLAYER HUD — bảng chỉ số nhỏ góc màn hình ═══════════
-- Đói / Khát / Thể lực / địch gần nhất / số người chơi / đang trú đâu — kéo được, cập nhật 0.5s.
if KAITUN_PLAYER_HUD then
    task.spawn(function()
        pcall(function()
            local pg = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
            if not pg then return end
            local old = pg:FindFirstChild("KaitunHUD")
            if old then old:Destroy() end
            local gui = Instance.new("ScreenGui")
            gui.Name = "KaitunHUD"
            gui.ResetOnSpawn = false
            gui.DisplayOrder = 999
            gui.Parent = pg

            local frame = Instance.new("Frame")
            frame.Name = "Root"
            frame.AnchorPoint = Vector2.new(0, 1)
            frame.Position = UDim2.new(0, 14, 1, -14)
            frame.Size = UDim2.new(0, 196, 0, 172)
            frame.BackgroundColor3 = Color3.fromRGB(12, 14, 16)
            frame.BackgroundTransparency = 0.28
            frame.BorderSizePixel = 0
            frame.Active = true
            pcall(function() frame.Draggable = true end) -- kéo được (legacy nhưng mọi executor đều hỗ trợ)
            frame.Parent = gui

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = frame
            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(52, 211, 153)
            stroke.Transparency = 0.45
            stroke.Parent = frame

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -16, 0, 26)
            title.Position = UDim2.new(0, 8, 0, 4)
            title.BackgroundTransparency = 1
            title.Text = "🐾 KAITUN HUD"
            title.TextColor3 = Color3.fromRGB(52, 211, 153)
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Font = Enum.Font.GothamBold
            title.TextSize = 13
            title.Parent = frame

            local function mkRow(idx, defColor)
                local r = Instance.new("TextLabel")
                r.Size = UDim2.new(1, -16, 0, 22)
                r.Position = UDim2.new(0, 8, 0, 30 + (idx - 1) * 23)
                r.BackgroundTransparency = 1
                r.Text = "…"
                r.TextColor3 = defColor
                r.TextXAlignment = Enum.TextXAlignment.Left
                r.Font = Enum.Font.Gotham
                r.TextSize = 12
                r.Parent = frame
                return r
            end
            local rHunger = mkRow(1, Color3.fromRGB(110, 231, 183))
            local rThirst = mkRow(2, Color3.fromRGB(103, 232, 249))
            local rEnergy = mkRow(3, Color3.fromRGB(196, 181, 253))
            local rEnemy  = mkRow(4, Color3.fromRGB(253, 164, 175))
            local rPlayers = mkRow(5, Color3.fromRGB(253, 224, 71))
            local rSpot   = mkRow(6, Color3.fromRGB(161, 161, 170))

            local fmtPct = function(v)
                if v == nil then return "?" end
                return string.format("%d%%", math.floor(v + 0.5))
            end

            while gui.Parent do
                local hunger = getStatPercent("Hunger")
                local thirst = getStatPercent("Thirst")
                local energy = getStatPercent("Rest")
                local hrp = getRoot()
                local enemy = hrp and nearestEnemyDistance(hrp.Position, KAITUN_CONFIG.ENEMY_SCAN_RANGE) or nil
                rHunger.Text = string.format("🍖 Đói: %s", fmtPct(hunger))
                rThirst.Text = string.format("💧 Khát: %s", fmtPct(thirst))
                rEnergy.Text = string.format("😴 Thể lực: %s", fmtPct(energy))
                if enemy then
                    rEnemy.Text = string.format("⚔️ Địch gần nhất: %dm", math.floor(enemy + 0.5))
                    rEnemy.TextColor3 = Color3.fromRGB(253, 164, 175)
                else
                    rEnemy.Text = "⚔️ Địch gần nhất: an toàn"
                    rEnemy.TextColor3 = Color3.fromRGB(110, 231, 183)
                end
                rPlayers.Text = string.format("👥 Người chơi: %d", #Players:GetPlayers())
                local spotLabel = "đang đi ăn"
                if _G.KaitunSkyAnchored then
                    spotLabel = "🌤 Sky (đang neo)"
                elseif _G.KaitunEnabled then
                    spotLabel = spotName((SPOT_CYCLE[KState.currentSpot] or "HIDE1"))
                end
                rSpot.Text = string.format("🏠 %s • Kaitun %s", spotLabel, _G.KaitunEnabled and "ON" or "OFF")
                task.wait(0.5)
            end
        end)
    end)
end

-- ═══════════ [KAITUN v2.6] ANTI-AFK — chặn kick 20 phút không hoạt động ═══════════
-- Roblox kick AFK sau ~20 phút idle. Kaitun chạy session dài → phải giả lập input.
-- Idled fired khi client sắp idle → VirtualUser CaptureController + ClickButton2 = "người chơi vẫn ngồi đó".
if KAITUN_ANTI_AFK then
    task.spawn(function()
        pcall(function()
            if _G.KaitunAntiAfkHooked then return end
            _G.KaitunAntiAfkHooked = true
            local VirtualUser = game:GetService("VirtualUser")
            LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                _G.KaitunNotify("☕ Anti-AFK: đã giả lập hoạt động — không bị kick 20 phút", 3)
            end)
            _G.KaitunNotify("🛡️ Anti-AFK đã bật (v2.6)", 3)
        end)
    end)
end

-- ═══════════ [KAITUN v2.7] AUTO-HOP SERVER — server đông → nhảy server vắng ═══════════
-- Kaitun ON + số người chơi > HOP_PLAYER_MAX → hỏi Roblox servers API (tái dùng pattern
-- "Tìm Server Thấp" của Meizu Hub) → TeleportToPlaceInstance sang server ÍT NGƯỜI NHẤT.
-- v2.8: quét NHIỀU TRANG server qua cursor (HOP_MAX_PAGES) — nếu 100 server đầu đều đông
-- vẫn tìm thấy server vắng ở trang sau; thấy ứng viên ngay thì dừng quét sớm.
-- Sau hop, Self-cache (v2.6) tự chạy lại Kaitun trên server mới → session không đứt.
if KAITUN_AUTO_HOP then
    task.spawn(function()
        pcall(function()
            if _G.KaitunAutoHopHooked then return end
            _G.KaitunAutoHopHooked = true
            local HttpService = game:GetService("HttpService")
            local TeleportService = game:GetService("TeleportService")
            local lastHopCheck = 0

            local function fetchServerPage(cursor)
                local base = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/0?sortOrder=Asc&limit=" .. tostring(KAITUN_CONFIG.HOP_SERVER_LIMIT)
                if cursor and cursor ~= "" then
                    base = base .. "&cursor=" .. cursor
                end
                local ok, res = pcall(function()
                    return game:HttpGet(base)
                end)
                if not ok or type(res) ~= "string" then return nil, nil end
                local ok2, data = pcall(function() return HttpService:JSONDecode(res) end)
                if not ok2 or type(data) ~= "table" or type(data.data) ~= "table" then return nil, nil end
                return data.data, data.nextPageCursor
            end

            -- v2.8: gom ứng viên qua nhiều trang — dừng sớm khi đã thấy
            local function collectCandidates()
                local candidates = {}
                local cursor = nil
                local scanned = 0
                for _ = 1, KAITUN_CONFIG.HOP_MAX_PAGES do
                    local page, nextCursor = fetchServerPage(cursor)
                    if not page then break end
                    scanned = scanned + #page
                    for _, s in ipairs(page) do
                        if type(s.id) == "string" and type(s.playing) == "number" and type(s.maxPlayers) == "number" then
                            if s.id ~= game.JobId and s.playing > 0 and s.playing < KAITUN_CONFIG.HOP_PLAYER_MAX and s.playing < s.maxPlayers then
                                table.insert(candidates, s)
                            end
                        end
                    end
                    if #candidates > 0 then break end -- thấy rồi → không cần quét trang sau
                    if not nextCursor or nextCursor == "" then break end -- hết dữ liệu
                    cursor = nextCursor
                end
                return candidates, scanned
            end

            while true do
                task.wait(10)
                if _G.KaitunEnabled and os.clock() - lastHopCheck >= KAITUN_CONFIG.HOP_CHECK_INTERVAL then
                    lastHopCheck = os.clock()
                    local playerCount = #Players:GetPlayers()
                    if playerCount > KAITUN_CONFIG.HOP_PLAYER_MAX then
                        local candidates, scanned = collectCandidates()
                        if #candidates > 0 then
                            table.sort(candidates, function(a, b) return a.playing < b.playing end)
                            local pick = candidates[1]
                            _G.KaitunNotify(string.format("🛰️ Server đông (%d người) — Auto-Hop sang server %d người (quét %d server)…", playerCount, pick.playing, scanned), 6)
                            task.delay(2, function()
                                pcall(function()
                                    TeleportService:TeleportToPlaceInstance(game.PlaceId, pick.id, LocalPlayer)
                                end)
                            end)
                            break -- teleport xong → self-cache tự chạy lại script
                        else
                            _G.KaitunNotify(string.format("🛰️ Server đông nhưng %d server đã quét đều vắng/không hợp lệ — chờ lần sau", scanned), 4)
                        end
                    end
                end
            end
        end)
    end)
end

-- ═══════════ [KAITUN v2.6] AUTO REJOIN — rớta/teleport lỗi → tự vào lại server ═══════════
-- TeleportInitFailed → chờ 5s rồi Teleport(game.PlaceId) thử lại (tối đa 5 lần).
-- Phần TỰ CHẠY LẠI script sau teleport nằm ở khối SELF-CACHE cuối file (generator chèn).
if KAITUN_AUTO_REJOIN then
    task.spawn(function()
        pcall(function()
            if _G.KaitunAutoRejoinHooked then return end
            _G.KaitunAutoRejoinHooked = true
            local TeleportService = game:GetService("TeleportService")
            local retries = 0
            TeleportService.TeleportInitFailed:Connect(function(_player, result, _message)
                retries = retries + 1
                if retries > 5 then return end
                _G.KaitunNotify(string.format("🔄 Teleport lỗi (%s) — thử lại lần %d/5 sau 5s…", tostring(result), retries), 5)
                task.delay(5, function()
                    pcall(function()
                        TeleportService:Teleport(game.PlaceId, LocalPlayer)
                    end)
                end)
            end)
        end)
    end)
end

----------------------------------------------------
-- LOADER FINAL — chỉ đóng HUD khi mọi thứ đã sẵn sàng
----------------------------------------------------
LoaderStage(8)
LoaderStage(9)

LoaderComplete = true

-- Loader vẫn là lớp trên cùng cho tới khi animation kết thúc.
-- Meizu Window đã được dựng hoàn chỉnh và vẫn đang đóng trong giai đoạn này.
LoaderTween(LoaderTitle, 0.22, {TextTransparency = 1})
LoaderTween(ProgressBG, 0.22, {BackgroundTransparency = 1})
LoaderTween(ProgressBar, 0.22, {BackgroundTransparency = 1})
LoaderTween(StepLabel, 0.22, {TextTransparency = 1})
LoaderTween(PercentLabel, 0.22, {TextTransparency = 1})

local closeTween = LoaderTween(LoaderFrame, 0.25, {Size = UDim2.new(0, 0, 0, 0)})
closeTween.Completed:Wait()
if LoaderGui and LoaderGui.Parent then
    LoaderGui:Destroy()
end

-- Chỉ bây giờ mới cho Meizu UI xuất hiện.
-- Main/controls đã được dựng đầy đủ từ trước nên không có hiện tượng menu load từng phần.
Window:Toggle(true)

pcall(function()
    MeizuLibrary:Notify({
        Title = "Meizu Hub",
        Content = "Loading Succesfully!",
        Duration = 4,
    })
end)

-- ═══════════ [KAITUN v2.6] SELF-CACHE AUTO REJOIN ═══════════
-- Lưu toàn bộ script này vào file executor → sau teleport/kick-lobby tự chạy lại
-- (cần executor hỗ trợ writefile/readfile/queue_on_teleport: Synapse, ScriptWare, Delta…).
do
        local __hasFile = typeof(writefile) == "function" and typeof(readfile) == "function"
        if __hasFile then
                pcall(function()
                        writefile("KAITUN_V212_AUTOEXEC.lua", [=[game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Meizu Hub";
    Text = "Loading..."; -- what the text says (ofc)
    Icon = "rbxassetid://94377325741905",
    Duration = 9;
})
shared.LoaderTitle = "Thanks For Using Meizu";
shared.LoaderKeyFrames = {
    [1] = {
        1,
        10
    },
    [2] = {
        2,
        30
    },
    [3] = {
        3,
        60
    },
    [4] = {
        2,
        100
    }
};
local v2 = {
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
        [1] = {
            1,
            10
        },
        [2] = {
            2,
            30
        },
        [3] = {
            3,
            60
        },
        [4] = {
            2,
            100
        }
    }
};
local v3 = {
    [1] = "",
    [2] = "",
    [3] = "",
    [4] = ""
};
function TweenObject(v178, v179, v180)
    game.TweenService:Create(v178, TweenInfo.new(v179, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), v180):Play();
end
function CreateObject(v181, v182)
    local v183 = Instance.new(v181);
    local v184;
    for v416, v417 in pairs(v182) do
        if (v416 ~= "Parent") then
            v183[v416] = v417;
        else
            v184 = v417;
        end
    end
    v183.Parent = v184;
    return v183;
end
local function v4(v186, v187)
    local v188 = Instance.new("UICorner");
    v188.CornerRadius = UDim.new(0, v186);
    v188.Parent = v187;
end
local v5 = CreateObject("ScreenGui", {
    Name = "Core",
    Parent = game.CoreGui
});
local v6 = CreateObject("Frame", {
    Name = "Main",
    Parent = v5,
    BackgroundColor3 = v2.LoaderData.Colors.Main,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 0, 0, 0)
});
v4(12, v6);
local v7 = CreateObject("ImageLabel", {
    Name = "UserImage",
    Parent = v6,
    BackgroundTransparency = 1,
    Image = "rbxassetid://132336058081263",
    Position = UDim2.new(0, 15, 0, 10),
    Size = UDim2.new(0, 50, 0, 50)
});
v4(25, v7);
local v8 = CreateObject("TextLabel", {
    Name = "UserName",
    Parent = v6,
    BackgroundTransparency = 1,
    Text = "Meizu Hub",
    Position = UDim2.new(0, 75, 0, 10),
    Size = UDim2.new(0, 200, 0, 50),
    Font = Enum.Font.GothamBold,
    TextColor3 = v2.LoaderData.Colors.Title,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
});
local v9 = CreateObject("TextLabel", {
    Name = "Top",
    TextTransparency = 1,
    Parent = v6,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 30, 0, 70),
    Size = UDim2.new(0, 301, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "Loader",
    TextColor3 = v2.LoaderData.Colors.Topic,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left
});
local v10 = CreateObject("TextLabel", {
    Name = "Title",
    Parent = v6,
    TextTransparency = 1,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 30, 0, 90),
    Size = UDim2.new(0, 301, 0, 46),
    Font = Enum.Font.Gotham,
    RichText = true,
    Text = "<b>" .. v2.LoaderData.Name .. "</b>",
    TextColor3 = v2.LoaderData.Colors.Title,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
});
local v11 = CreateObject("Frame", {
    Name = "BG",
    Parent = v6,
    AnchorPoint = Vector2.new(0.5, 0),
    BackgroundTransparency = 1,
    BackgroundColor3 = v2.LoaderData.Colors.LoaderBackground,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, 0, 0, 70),
    Size = UDim2.new(0.8500000238418579, 0, 0, 24)
});
v4(8, v11);
local v12 = CreateObject("Frame", {
    Name = "Progress",
    Parent = v11,
    BackgroundColor3 = v2.LoaderData.Colors.LoaderSplash,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 0, 0, 24)
});
v4(8, v12);
local v13 = CreateObject("TextLabel", {
    Name = "StepLabel",
    Parent = v6,
    BackgroundTransparency = 1,
    Position = UDim2.new(0.5, 0, 1, - 25),
    Size = UDim2.new(1, - 20, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "",
    TextColor3 = v2.LoaderData.Colors.Topic,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Center,
    AnchorPoint = Vector2.new(0.5, 0.5)
});
function UpdateStepText(v191)
    v13.Text = v3[v191] or "" ;
end
function UpdatePercentage(v193, v194)
    TweenObject(v12, 0.5, {
        Size = UDim2.new(v193 / 100, 0, 0, 24)
    });
    UpdateStepText(v194);
end
TweenObject(v6, 0.25, {
    Size = UDim2.new(0, 346, 0, 121)
});
wait();
TweenObject(v9, 0.5, {
    TextTransparency = 0
});
TweenObject(v10, 0.5, {
    TextTransparency = 0
});
TweenObject(v11, 0.5, {
    BackgroundTransparency = 0
});
TweenObject(v12, 0.5, {
    BackgroundTransparency = 0
});
for v195, v196 in pairs(v2.Keyframes) do
    wait(v196[1]);
    UpdatePercentage(v196[2], v195);
end
UpdatePercentage(100, 4);
TweenObject(v9, 0.5, {
    TextTransparency = 1
});
TweenObject(v10, 0.5, {
    TextTransparency = 1
});
TweenObject(v11, 0.5, {
    BackgroundTransparency = 1
});
TweenObject(v12, 0.5, {
    BackgroundTransparency = 1
});
wait(0.5);
TweenObject(v6, 0.25, {
    Size = UDim2.new(0, 0, 0, 0)
});
wait(0.25);
v5:Destroy();
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

local MEIZU_LIBRARY_URL = "https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/meizulibrary1.lua"

----------------------------------------------------
-- LOAD HUD LOADER — đồng bộ theo tiến trình thật
----------------------------------------------------
local LoaderColors = {
    Main             = Color3.fromRGB(0, 0, 0),
    Topic            = Color3.fromRGB(200, 200, 200),
    Title            = Color3.fromRGB(255, 255, 255),
    LoaderBackground = Color3.fromRGB(40, 40, 40),
    LoaderSplash     = Color3.fromRGB(3, 252, 3),
    Error            = Color3.fromRGB(255, 90, 90),
}

local function GetGuiParent()
    if type(gethui) == "function" then
        local ok, gui = pcall(gethui)
        if ok and gui then return gui end
    end
    return game:GetService("CoreGui")
end

local GuiParent = GetGuiParent()

-- Cleanup những instance của bản Primeval/Meizu trước đó để re-run không chồng UI.
pcall(function()
    for _, child in ipairs(GuiParent:GetChildren()) do
        if child:IsA("ScreenGui") then
            if child.Name == "MeizuLoader"
            or child.Name == "PrimevalFOVOverlay"
            or child.Name:match("^MeizuLibrary") then
                child:Destroy()
            end
        end
    end
end)

pcall(function()
    RunService:UnbindFromRenderStep("AimbotSystem")
end)

local function Create(className, properties)
    local obj = Instance.new(className)
    local parent
    for prop, value in pairs(properties or {}) do
        if prop == "Parent" then
            parent = value
        else
            obj[prop] = value
        end
    end
    if parent then obj.Parent = parent end
    return obj
end

local function AddCorner(radius, parent)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius),
        Parent = parent,
    })
end

local function LoaderTween(object, duration, properties)
    local tw = TweenService:Create(
        object,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    )
    tw:Play()
    return tw
end

local LoaderGui = Create("ScreenGui", {
    Name = "MeizuLoader",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100000,
    Parent = GuiParent,
})

-- Chặn input vào UI phía sau trong lúc loader chạy.
Create("Frame", {
    Name = "InputBlocker",
    BackgroundTransparency = 1,
    Active = true,
    Size = UDim2.fromScale(1, 1),
    ZIndex = 1,
    Parent = LoaderGui,
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
    ZIndex = 10,
})
AddCorner(12, LoaderFrame)

local LoaderStroke = Create("UIStroke", {
    Color = LoaderColors.LoaderSplash,
    Thickness = 1.25,
    Transparency = 0.25,
    Parent = LoaderFrame,
})

local LoaderLogo = Create("ImageLabel", {
    Name = "Logo",
    Parent = LoaderFrame,
    BackgroundTransparency = 1,
    Image = "",
    Position = UDim2.new(0, 15, 0, 10),
    Size = UDim2.new(0, 50, 0, 50),
    ZIndex = 11,
})
AddCorner(25, LoaderLogo)

Create("TextLabel", {
    Name = "HubName",
    Parent = LoaderFrame,
    BackgroundTransparency = 1,
    Text = "Primeval Earth Hub",
    Position = UDim2.new(0, 75, 0, 10),
    Size = UDim2.new(0, 240, 0, 50),
    Font = Enum.Font.GothamBold,
    TextColor3 = LoaderColors.Title,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 11,
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
    Text = "<b>Đang khởi tạo Primeval...</b>",
    TextColor3 = LoaderColors.Title,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 11,
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
    ZIndex = 11,
})
AddCorner(7, ProgressBG)

local ProgressBar = Create("Frame", {
    Name = "Progress",
    Parent = ProgressBG,
    BackgroundColor3 = LoaderColors.LoaderSplash,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 0, 1, 0),
    ZIndex = 12,
})
AddCorner(7, ProgressBar)

local PercentLabel = Create("TextLabel", {
    Name = "Percent",
    Parent = LoaderFrame,
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -20, 0, 108),
    Size = UDim2.new(0, 52, 0, 18),
    Font = Enum.Font.GothamBold,
    Text = "0%",
    TextColor3 = LoaderColors.LoaderSplash,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Right,
    ZIndex = 11,
})

local StepLabel = Create("TextLabel", {
    Name = "StepLabel",
    Parent = LoaderFrame,
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0, 0),
    Position = UDim2.new(0, 15, 0, 108),
    Size = UDim2.new(1, -85, 0, 18),
    Font = Enum.Font.Gotham,
    Text = "Đang chuẩn bị...",
    TextColor3 = LoaderColors.Topic,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 11,
})

local LoaderSteps = {
    {5,  "Đã load xong: Core Services"},
    {15, "Đã load xong: MeizuLibrary"},
    {25, "Đã load xong: State + FOV"},
    {40, "Đã load xong: Aimbot + ESP"},
    {52, "Đã load xong: Movement + Fly"},
    {66, "Đã dựng xong: Tab Di Chuyển + Teleport"},
    {80, "Đã dựng xong: ESP + PVP + Fossils + Utility"},
    {94, "Đã load xong: Runtime + Background Systems"},
    {100, "Đã load xong toàn bộ Primeval Earth Hub"},
}

local LoaderStageIndex = 0
local LoaderComplete = false

local function UpdateLoader(percent, message)
    percent = math.clamp(tonumber(percent) or 0, 0, 100)
    PercentLabel.Text = string.format("%d%%", math.floor(percent))
    StepLabel.Text = "✓ " .. tostring(message or "")
    LoaderTween(ProgressBar, 0.18, {Size = UDim2.new(percent / 100, 0, 1, 0)})
end

local function LoaderStage(index)
    local data = LoaderSteps[index]
    if not data then return end
    if index <= LoaderStageIndex then return end
    LoaderStageIndex = index
    UpdateLoader(data[1], data[2])
end

LoaderTween(LoaderFrame, 0.25, {Size = UDim2.new(0, 346, 0, 132)})
task.defer(function()
    LoaderTween(LoaderTitle, 0.25, {TextTransparency = 0})
    LoaderTween(ProgressBG, 0.25, {BackgroundTransparency = 0})
    LoaderTween(ProgressBar, 0.25, {BackgroundTransparency = 0})
end)

LoaderStage(1)

----------------------------------------------------
-- LOAD MEIZU LIBRARY — chỉ load source, chưa tạo Window
----------------------------------------------------
local function LoadMeizuLibrary()
    local okHttp, source = pcall(function()
        return game:HttpGet(MEIZU_LIBRARY_URL, true)
    end)
    if not okHttp or type(source) ~= "string" or source == "" then
        error("[Primeval] Khong the tai MeizuLibrary: " .. tostring(source))
    end

    local chunk, compileErr = loadstring(source)
    if type(chunk) ~= "function" then
        error("[Primeval] MeizuLibrary compile error: " .. tostring(compileErr))
    end

    local okLoad, library = pcall(chunk)
    if not okLoad or type(library) ~= "table" then
        error("[Primeval] MeizuLibrary load error: " .. tostring(library))
    end

    return library
end

local okLibrary, MeizuLibraryOrError = pcall(LoadMeizuLibrary)
if not okLibrary then
    UpdateLoader(100, "Lỗi: Không thể load MeizuLibrary")
    task.wait(0.4)
    if LoaderGui then LoaderGui:Destroy() end
    error(MeizuLibraryOrError)
end

local MeizuLibrary = MeizuLibraryOrError
LoaderStage(2)

----------------------------------------------------
-- PRIMEVAL STATE
----------------------------------------------------
_G.AutoDrinkRunning = false
_G.AutoRestRunning = false
_G.AutoZoneRunning = false
_G.AutoFarmAmmo = false
_G.AutoAttackRunning = false
_G.AutoEatActive = false
_G.AutoHerbActive = false
_G.CurrentQuest = "None"

local AimSettings = {
    Enabled = false,
    ShowFOV = false,
    FOVRadius = 150,
    Smoothness = 0.2,
    MaxDistance = 150,
}

local EspSettings = {
    Enabled = false,
    ShowName = true,
    ShowHealth = true,
    ShowDistance = true,
}

local hasTargetInFOV = false
local AmmoStatusLabel
local QuestStatusLabel
local lowServerBtn
local noclipConn = nil

----------------------------------------------------
-- FOV OVERLAY — không phải menu
----------------------------------------------------
local oldFovGui = GuiParent:FindFirstChild("PrimevalFOVOverlay")
if oldFovGui then pcall(function() oldFovGui:Destroy() end) end

local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "PrimevalFOVOverlay"
FOVGui.ResetOnSpawn = false
FOVGui.IgnoreGuiInset = true
FOVGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
FOVGui.DisplayOrder = 9998
FOVGui.Parent = GuiParent

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.fromScale(0.5, 0.5)
FOVCircle.Size = UDim2.fromOffset(AimSettings.FOVRadius * 2, AimSettings.FOVRadius * 2)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
FOVCircle.ZIndex = 2
FOVCircle.Parent = FOVGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircle

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(255, 255, 255)
FOVStroke.Thickness = 1
FOVStroke.Transparency = 0.2
FOVStroke.Parent = FOVCircle

LoaderStage(3)


-- 3. LOGIC ESP, AIMBOT, AUTO ATTACK & AUTO NHẶT ĐẠN
----------------------------------------------------
local targetAmmoCFrame = CFrame.new(637.3, 94.3, -56.5)
local ammoMaxDistance = 15

local function triggerAttack()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    for _, gui in pairs(playerGui:GetDescendants()) do
        if (gui:IsA("ImageButton") or gui:IsA("TextButton")) and gui.Name == "Attack" then
            if getconnections then
                for _, conn in pairs(getconnections(gui.Activated)) do 
                    conn:Fire() 
                end
                for _, conn in pairs(getconnections(gui.MouseButton1Click)) do 
                    conn:Fire() 
                end
            end
        end
    end
end

local function getPromptPosition(prompt)
    local parent = prompt.Parent
    if parent:IsA("BasePart") then
        return parent.Position
    elseif parent:IsA("Attachment") then
        return parent.WorldPosition
    end
    return nil
end

local function isFullyVisible(gui)
    if not gui or not gui:IsDescendantOf(game) then return false end
    if gui.AbsoluteSize.X <= 0 or gui.AbsoluteSize.Y <= 0 then return false end
    
    local current = gui
    while current and current:IsA("GuiObject") do
        if not current.Visible then return false end
        if current:IsA("CanvasGroup") and current.GroupTransparency >= 0.9 then return false end
        current = current.Parent
    end
    
    if current and current:IsA("ScreenGui") and not current.Enabled then
        return false
    end
    return true
end

local function checkAmmoStatus()
    local char = LocalPlayer.Character
    if not char then return nil, nil, "Chưa tải Nhân vật" end

    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        return nil, nil, "Hãy cầm súng trên tay!"
    end

    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return nil, nil, "Không thấy PlayerGui" end

    local screenWidth = Camera and Camera.ViewportSize.X or 1000
    local screenHeight = Camera and Camera.ViewportSize.Y or 1000
    local rightSideX = screenWidth * 0.5
    local bottomSideY = screenHeight * 0.5

    local currentAmmo = nil
    local reserveAmmo = nil

    for _, gui in pairs(playerGui:GetDescendants()) do
        if (gui:IsA("TextLabel") or gui:IsA("TextBox") or gui:IsA("TextButton")) and isFullyVisible(gui) then
            if gui.AbsolutePosition.X >= rightSideX and gui.AbsolutePosition.Y >= bottomSideY then
                local rawText = gui.Text
                if rawText and rawText ~= "" and gui.TextTransparency < 0.8 then
                    local cleanText = string.gsub(rawText, "<[^>]->", "")
                    cleanText = string.match(cleanText, "^%s*(.-)%s*$") or cleanText

                    local cur, res = string.match(cleanText, "^(%d+)%s*[/⁄∕|]%s*(%d+)$")
                    if cur and res then
                        return tonumber(cur), tonumber(res), "Đạn: " .. cleanText
                    end

                    local resOnly = string.match(cleanText, "^[/⁄∕|]%s*(%d+)$")
                    if resOnly then
                        reserveAmmo = tonumber(resOnly)
                    end

                    local curOnly = string.match(cleanText, "^(%d+)$")
                    if curOnly and tonumber(curOnly) <= 200 then
                        currentAmmo = tonumber(curOnly)
                    end
                end
            end
        end
    end

    if currentAmmo ~= nil and reserveAmmo ~= nil then
        return currentAmmo, reserveAmmo, string.format("Đạn: %02d/%d", currentAmmo, reserveAmmo)
    elseif reserveAmmo ~= nil then
        return currentAmmo or 0, reserveAmmo, "Đạn dự trữ: /" .. reserveAmmo
    end

    return nil, nil, "Đang quét UI đạn..."
end

local function getTorso(character)
    if not character then return nil end
    return character:FindFirstChild("UpperTorso") 
        or character:FindFirstChild("Torso") 
        or character:FindFirstChild("HumanoidRootPart")
        or character:FindFirstChild("Head")
end

local function getClosestEnemyInFOV()
    if not AimSettings.Enabled then return nil end

    local closestChar = nil
    local shortestWorldDist = AimSettings.MaxDistance
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local torso = getTorso(char)
            local humanoid = char:FindFirstChildOfClass("Humanoid")

            if humanoid and humanoid.Health > 0 and torso then
                local worldDistance = (Camera.CFrame.Position - torso.Position).Magnitude
                
                if worldDistance <= AimSettings.MaxDistance then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(torso.Position)
                    if onScreen and screenPos.Z > 0 then
                        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        
                        if screenDist <= AimSettings.FOVRadius then
                            if worldDistance < shortestWorldDist then
                                shortestWorldDist = worldDistance
                                closestChar = char
                            end
                        end
                    end
                end
            end
        end
    end
    return closestChar
end

RunService:BindToRenderStep("AimbotSystem", Enum.RenderPriority.Camera.Value + 100, function()
    if not AimSettings.Enabled then
        FOVStroke.Color = Color3.fromRGB(255, 255, 255)
        hasTargetInFOV = false
        return
    end

    local target = getClosestEnemyInFOV()
    if target then
        hasTargetInFOV = true
        local targetTorso = getTorso(target)
        FOVStroke.Color = Color3.fromRGB(255, 50, 50)

        if targetTorso then
            local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, targetTorso.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, AimSettings.Smoothness)
        end
    else
        hasTargetInFOV = false
        FOVStroke.Color = Color3.fromRGB(255, 255, 255)
    end
end)

local function CreateESP(player)
    if player == LocalPlayer then return end

    local function SetupCharacter(char)
        if not char then return end

        -- Không chặn thread load bằng WaitForChild.
        -- Character có thể chưa có Head/Humanoid ngay khi CharacterAdded.
        task.spawn(function()
            local deadline = os.clock() + 8
            local head = char:FindFirstChild("Head")
            local humanoid = char:FindFirstChildOfClass("Humanoid")

            while char.Parent and os.clock() < deadline and (not head or not humanoid) do
                head = head or char:FindFirstChild("Head")
                humanoid = humanoid or char:FindFirstChildOfClass("Humanoid")
                if head and humanoid then break end
                task.wait(0.1)
            end

            if not char.Parent or not head or not humanoid then return end

            if head:FindFirstChild("PlayerESP") then
                head.PlayerESP:Destroy()
            end

            local bgui = Instance.new("BillboardGui")
            bgui.Name = "PlayerESP"
            bgui.Adornee = head
            bgui.Size = UDim2.new(0, 200, 0, 50)
            bgui.StudsOffset = Vector3.new(0, 2.5, 0)
            bgui.AlwaysOnTop = true
            bgui.Parent = head

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
            textLabel.TextStrokeTransparency = 0
            textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextSize = 13
            textLabel.Parent = bgui

            -- Một connection riêng cho ESP này; việc tạo nó không cản quá trình load chính.
            RunService.RenderStepped:Connect(function()
                if not char.Parent or not humanoid.Parent or humanoid.Health <= 0 or not EspSettings.Enabled then
                    if bgui.Parent then bgui.Enabled = false end
                    return
                end

                bgui.Enabled = true
                local textParts = {}

                if EspSettings.ShowName then
                    table.insert(textParts, player.DisplayName)
                end

                if EspSettings.ShowHealth then
                    local hp = math.floor(humanoid.Health)
                    local maxHp = math.floor(humanoid.MaxHealth)
                    table.insert(textParts, string.format("[%d/%d HP]", hp, maxHp))
                end

                local myChar = LocalPlayer.Character
                local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if EspSettings.ShowDistance and myHRP then
                    local dist = math.floor((myHRP.Position - head.Position).Magnitude)
                    table.insert(textParts, string.format("[%dm]", dist))
                end

                textLabel.Text = table.concat(textParts, " | ")
            end)
        end)
    end

    if player.Character then
        SetupCharacter(player.Character)
    end
    player.CharacterAdded:Connect(SetupCharacter)
end

for _, p in ipairs(Players:GetPlayers()) do
    CreateESP(p)
end
Players.PlayerAdded:Connect(CreateESP)

-- Stage 4 chỉ xác nhận hệ thống ESP đã được đăng ký.
-- Không đợi từng Character spawn xong mới cho script chạy tiếp.
LoaderStage(4)

local flyEnabled = false
local flySpeed = 50
local flyAtt, flyLV, flyAG
local flyRenderConnection = nil

local function cleanupFly()
    if flyRenderConnection then
        flyRenderConnection:Disconnect()
        flyRenderConnection = nil
    end
    if flyLV then flyLV:Destroy() flyLV = nil end
    if flyAG then flyAG:Destroy() flyAG = nil end
    if flyAtt then flyAtt:Destroy() flyAtt = nil end
end

local function stopFly()
    flyEnabled = false
    cleanupFly()
end

local function startFly()
    cleanupFly()
    flyEnabled = true

    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not hrp or not flyEnabled then return end

    flyAtt = Instance.new("Attachment", hrp)

    flyLV = Instance.new("LinearVelocity")
    flyLV.Attachment0 = flyAtt
    flyLV.MaxForce = math.huge
    flyLV.VectorVelocity = Vector3.new(0, 0, 0)
    flyLV.Parent = hrp

    flyAG = Instance.new("AlignOrientation")
    flyAG.Attachment0 = flyAtt
    flyAG.MaxTorque = math.huge
    flyAG.Responsiveness = 200
    flyAG.Parent = hrp

    flyRenderConnection = RunService.RenderStepped:Connect(function()
        local currentChar = LocalPlayer.Character
        local currentHRP = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        local humanoid = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

        if not flyEnabled or not currentChar or not currentChar.Parent or not currentHRP or not humanoid or humanoid.Health <= 0 then
            cleanupFly()
            return
        end

        if not flyLV or not flyAG or flyLV.Parent ~= currentHRP or flyAG.Parent ~= currentHRP then
            cleanupFly()
            return
        end

        local moveDir = humanoid.MoveDirection
        local targetVel = Vector3.new()
        if moveDir.Magnitude > 0 then
            local camCF = Camera.CFrame
            local camLook = camCF.LookVector
            local camRight = camCF.RightVector
            local flatLook = Vector3.new(camLook.X, 0, camLook.Z).Unit
            local flatRight = Vector3.new(camRight.X, 0, camRight.Z).Unit
            local lookDot = moveDir:Dot(camLook)
            local rightDot = moveDir:Dot(camRight)
            targetVel = (flatLook * lookDot + flatRight * rightDot + Vector3.new(0, camLook.Y * math.abs(lookDot), 0)).Unit * flySpeed
        else
            targetVel = Vector3.new(0, 0, 0)
        end

        flyLV.VectorVelocity = targetVel
        flyAG.CFrame = Camera.CFrame
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    if flyEnabled then
        task.wait(0.5)
        if flyEnabled then
            startFly()
        end
    end
end)

LoaderStage(5)

----------------------------------------------------
-- 4. KHỞI TẠO TABS VÀ CHỨC NĂNG
----------------------------------------------------
local targetWalkSpeed = 16
RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and targetWalkSpeed > 16 then
            if hum.WalkSpeed ~= targetWalkSpeed then
                hum.WalkSpeed = targetWalkSpeed
            end
        end
    end)
end)



----------------------------------------------------
-- 4. MEIZU UI — dựng hoàn chỉnh phía sau Loader HUD
----------------------------------------------------
local Window = MeizuLibrary:CreateWindow({
    Title = "Meizu Hub",
    SubTitle = "Primeval Earth • NTTP1721",
    Theme = "Dark",
    Accent = Color3.fromRGB(99, 102, 241),
    ToggleKeybind = Enum.KeyCode.RightControl,
    ToggleUIButton = true,
    ToggleImage = "https://i.ibb.co/S7rpHJJN/meizuxp.png",
    Size = UDim2.fromOffset(650, 470),
})

local function FixParagraphElement(element, defaultHeight)
    if not element or not element.Frame then return element end
    local frame = element.Frame
    local fallbackHeight = defaultHeight or 58

    local titleLabel = element.TitleLabel
    local contentLabel = element.ContentLabel
    if not titleLabel or not contentLabel then
        local labels = {}
        for _, obj in ipairs(frame:GetDescendants()) do
            if obj:IsA("TextLabel") then
                table.insert(labels, obj)
                obj.Visible = true
            end
        end
        titleLabel = titleLabel or labels[1]
        contentLabel = contentLabel or labels[2]
    end

    local function Reflow()
        if not frame or not frame.Parent then return end
        pcall(function()
            frame.Visible = true
            frame.ClipsDescendants = false
            frame.AutomaticSize = Enum.AutomaticSize.None
        end)

        if not titleLabel or not titleLabel.Parent then return end

        local width = math.max(120, frame.AbsoluteSize.X - 24)
        if width <= 120 then
            width = 430
        end

        local titleHeight = 18
        local contentHeight = 0

        pcall(function()
            titleLabel.Visible = true
            titleLabel.TextWrapped = true
            titleLabel.AutomaticSize = Enum.AutomaticSize.None
            titleHeight = math.max(18, math.ceil(
                TextService:GetTextSize(tostring(titleLabel.Text or ""), Enum.Font.GothamBold, 13, Vector2.new(width, 1000)).Y
            ))
            titleLabel.Size = UDim2.new(1, 0, 0, titleHeight)
        end)

        if contentLabel and contentLabel.Parent then
            pcall(function()
                contentLabel.Visible = true
                contentLabel.TextWrapped = true
                contentLabel.AutomaticSize = Enum.AutomaticSize.None
                if tostring(contentLabel.Text or "") ~= "" then
                    contentHeight = math.max(16, math.ceil(
                        TextService:GetTextSize(tostring(contentLabel.Text or ""), Enum.Font.Gotham, 12, Vector2.new(width, 1000)).Y
                    ))
                end
                contentLabel.Size = UDim2.new(1, 0, 0, contentHeight)
            end)
        end

        local total = 10 + titleHeight + (contentLabel and 4 or 0) + contentHeight + 10
        total = math.max(fallbackHeight, total, 40)
        frame.Size = UDim2.new(1, 0, 0, total)
    end

    Reflow()
    task.defer(Reflow)
    pcall(function()
        frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            task.defer(Reflow)
        end)
    end)

    if type(element.SetContent) ~= "function" then
        element.SetContent = function(self, text, textColor)
            if contentLabel and contentLabel.Parent then
                contentLabel.Text = tostring(text or "")
                if textColor then contentLabel.TextColor3 = textColor end
            end
            self._Content = tostring(text or "")
            task.defer(Reflow)
        end
    end
    if type(element.SetTitle) ~= "function" then
        element.SetTitle = function(self, text)
            if titleLabel and titleLabel.Parent then
                titleLabel.Text = tostring(text or "")
            end
            task.defer(Reflow)
        end
    end

    return element
end

local function CreateParagraph(tab, cfg, height)
    local element = tab:CreateParagraph(cfg)
    return FixParagraphElement(element, height or 58)
end

local function SetParagraphContent(element, text, textColor)
    if not element then return end
    pcall(function()
        if type(element.SetContent) == "function" then
            element:SetContent(text, textColor)
            return
        end
        local frame = element.Frame
        if frame then
            for _, obj in ipairs(frame:GetDescendants()) do
                if obj:IsA("TextLabel") and obj ~= frame:FindFirstChild("TitleLabel", true) then
                    obj.Text = tostring(text or "")
                    if textColor then obj.TextColor3 = textColor end
                end
            end
        end
    end)
end

local function SetAmmoStatus(text)
    SetParagraphContent(AmmoStatusLabel, text)
end

local function SetQuestStatus(text, color)
    SetParagraphContent(QuestStatusLabel, text, color)
end

local MovementTab = Window:CreateTab("Misc", "rbxassetid://10747382750", 5)
local TeleportTab = Window:CreateTab("Teleport ", "rbxassetid://10734886004", 2)
local EspTab = Window:CreateTab("ESP", "rbxassetid://10747375132", 3)
local PvpTab = Window:CreateTab("PVP", "rbxassetid://10734975692", 4)
local FossilsTab = Window:CreateTab("Main", "rbxassetid://10709781605", 1)
local VisualsTab = Window:CreateTab("Setting", "rbxassetid://10734950309", 6)
LoaderStage(6)

----------------------------------------------------
-- TAB DI CHUYEN
----------------------------------------------------
MovementTab:CreateSection("Movement")
MovementTab:CreateSlider({
    Title = "Tốc Độ Chạy",
    Description = "WalkSpeed",
    Min = 16, Max = 200, Default = 16,
    Callback = function(value)
        targetWalkSpeed = value
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = value end
    end,
})
MovementTab:CreateSlider({
    Title = "Nhảy",
    Description = "JumpPower",
    Min = 50, Max = 300, Default = 50,
    Callback = function(value)
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = value
        end
    end,
})
MovementTab:CreateToggle({
    Title = "Bật/Tắt Bay",
    Description = "Fly",
    Default = false,
    Callback = function(state)
        if state then startFly() else stopFly() end
    end,
})
MovementTab:CreateSlider({
    Title = "Tốc Độ Bay",
    Description = "Fly Speed",
    Min = 10, Max = 150, Default = 50,
    Callback = function(value) flySpeed = value end,
})
MovementTab:CreateToggle({
    Title = "Xuyên Tường",
    Description = "NoClip",
    Default = false,
    Callback = function(state)
        if state then
            if noclipConn then pcall(function() noclipConn:Disconnect() end) end
            noclipConn = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        elseif noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
    end,
})


----------------------------------------------------
-- TAB TELEPORT
----------------------------------------------------
TeleportTab:CreateSection("Teleport Player")
CreateParagraph(TeleportTab, {
    Title = "Danh Sách Người Chơi",
    Content = "Chọn người chơi để dịch chuyển đến người chơi đó",
}, 72)

local PlayerButtonElements = {}

local function ClearPlayerButtons()
    for i = #PlayerButtonElements, 1, -1 do
        local element = PlayerButtonElements[i]
        if element and element.Frame then
            pcall(function() element.Frame:Destroy() end)
        end
        PlayerButtonElements[i] = nil
    end
end

local function AddPlayerButton(plr)
    if plr == LocalPlayer then return end
    local element = TeleportTab:CreateButton({
        Title = "📍 " .. plr.DisplayName .. " (@" .. plr.Name .. ")",
        Callback = function()
            if plr and plr.Parent == Players and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local myChar = LocalPlayer.Character
                local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    myHRP.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 2)
                end
            end
        end,
    })
    table.insert(PlayerButtonElements, element)
end

local function RefreshPlayerList()
    ClearPlayerButtons()
    for _, plr in ipairs(Players:GetPlayers()) do
        AddPlayerButton(plr)
    end
end

Players.PlayerAdded:Connect(function()
    task.wait(0.15)
    RefreshPlayerList()
end)
Players.PlayerRemoving:Connect(function()
    task.wait()
    RefreshPlayerList()
end)
task.defer(RefreshPlayerList)

----------------------------------------------------
-- TAB ESP
----------------------------------------------------
EspTab:CreateSection("ESP")
EspTab:CreateToggle({Title="Bật/Tắt ESP", Default=EspSettings.Enabled, Callback=function(v) EspSettings.Enabled=v end})
EspTab:CreateToggle({Title="Hiện Tên", Default=EspSettings.ShowName, Callback=function(v) EspSettings.ShowName=v end})
EspTab:CreateToggle({Title="Hiện Máu (HP)", Default=EspSettings.ShowHealth, Callback=function(v) EspSettings.ShowHealth=v end})
EspTab:CreateToggle({Title="Hiện Khoảng Cách (m)", Default=EspSettings.ShowDistance, Callback=function(v) EspSettings.ShowDistance=v end})

----------------------------------------------------
-- TAB PVP
----------------------------------------------------
PvpTab:CreateSection("Aim / FOV")
PvpTab:CreateToggle({
    Title="Auto Attack (Chi Bắn Khi FOV Đỏ)", Default=false,
    Callback=function(state) _G.AutoAttackRunning=state end,
})
PvpTab:CreateToggle({
    Title="Aimbot (Auto Lock)", Default=false,
    Callback=function(state)
        AimSettings.Enabled=state
        FOVCircle.Visible=AimSettings.Enabled and AimSettings.ShowFOV
    end,
})
PvpTab:CreateToggle({
    Title="Hiện Vòng FOV", Default=false,
    Callback=function(state)
        AimSettings.ShowFOV=state
        FOVCircle.Visible=AimSettings.Enabled and AimSettings.ShowFOV
    end,
})
PvpTab:CreateSlider({
    Title="Kích Thước FOV", Min=30, Max=200, Default=150,
    Callback=function(value)
        AimSettings.FOVRadius=value
        FOVCircle.Size=UDim2.fromOffset(value*2, value*2)
    end,
})
PvpTab:CreateSlider({
    Title="Độ Mượt Aim (Smooth)", Min=1, Max=10, Default=2,
    Callback=function(value) AimSettings.Smoothness=value/10 end,
})
AmmoStatusLabel = CreateParagraph(PvpTab, {
    Title="Trạng thái đạn",
    Content="Đang chờ...",
}, 60)
PvpTab:CreateToggle({
    Title="Auto Nhặt Đạn (Nhặt 2 Lần)", Default=false,
    Callback=function(state)
        _G.AutoFarmAmmo=state
        if not state then
            SetAmmoStatus("Trạng Thái Đạn: Đã TẮT")
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Anchored=false
            end
        end
    end,
})

----------------------------------------------------
-- TAB FOSSILS
----------------------------------------------------
FossilsTab:CreateSection("Main / Quest")
QuestStatusLabel = CreateParagraph(FossilsTab, {
    Title="Quest Hiện Tại",
    Content="Đang chờ...",
}, 60)
FossilsTab:CreateToggle({Title="Auto Ăn Thịt (Toggle Meat)", Default=false, Callback=function(v) _G.AutoEatActive=v end})
FossilsTab:CreateToggle({Title="Auto Ăn Cỏ (Toggle Herb)", Default=false, Callback=function(v) _G.AutoHerbActive=v end})
FossilsTab:CreateToggle({Title="Auto Drink (Uống Liên Tục)", Default=false, Callback=function(v) _G.AutoDrinkRunning=v end})
FossilsTab:CreateToggle({Title="Auto Rest (Nghỉ Ngơi)", Default=false, Callback=function(v) _G.AutoRestRunning=v end})
FossilsTab:CreateToggle({Title="Auto Zone (Chiếm Zone)", Default=false, Callback=function(v) _G.AutoZoneRunning=v end})

-- ═══════════════════════════════════════════════════════════
-- [KAITUN #1][#4] UI — DROPDOWN CHẾ ĐỘ ĂN + TOGGLE AUTO NUÔI
-- ═══════════════════════════════════════════════════════════
_G.KaitunEnabled  = _G.KaitunEnabled or false
_G.KaitunFeedMode = _G.KaitunFeedMode or "None"  -- #4: mặc định None

if not _G.KaitunNotify then
    _G.KaitunNotify = function(text, duration)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "🐾 Kaitun", Text = tostring(text), Duration = duration or 4
            })
        end)
    end
end

FossilsTab:CreateSection("Auto Nuôi (Kaitun)")

local KaitunStatusLabel = CreateParagraph(FossilsTab, {
    Title = "Trạng Thái Kaitun",
    Content = "TẮT — bật toggle Auto Nuôi để bắt đầu",
}, 60)

_G.KaitunUpdateStatus = function()
    pcall(function()
        if _G.KaitunEnabled then
            local modeText = _G.KaitunFeedMode == "None" and "⚠ CHƯA CHỌN (None)" or tostring(_G.KaitunFeedMode)
            SetParagraphContent(KaitunStatusLabel, "ĐANG BẬT • Chế độ ăn: " .. modeText, Color3.fromRGB(0, 255, 130))
        else
            SetParagraphContent(KaitunStatusLabel, "TẮT — bật toggle Auto Nuôi để bắt đầu", Color3.fromRGB(200, 200, 200))
        end
    end)
end

-- [#1][#4] Dropdown Chế Độ Ăn (None / Meat / Herb) — mặc định None
do
    local okDropdown, dropdownErr = pcall(function()
        FossilsTab:CreateDropdown({
            Title = "Chế Độ Ăn",
            Description = "None / Meat / Herb — mặc định None",
            Options = { "None", "Meat", "Herb" },
            Default = "None",
            Callback = function(selected)
                local val = selected
                if type(val) == "table" then val = val[1] end
                if val ~= "Meat" and val ~= "Herb" then val = "None" end
                _G.KaitunFeedMode = val
                if _G.KaitunEnabled and val == "None" then
                    _G.KaitunNotify("⚠ Kaitun đang BẬT nhưng Chế Độ Ăn = None! Hãy chọn Meat hoặc Herb.", 6, "warn")
                end
                if _G.KaitunUpdateStatus then _G.KaitunUpdateStatus() end
            end,
        })
    end)
    if not okDropdown then
        -- Dự phòng nếu MeizuLibrary không hỗ trợ CreateDropdown
        _G.KaitunNotify("CreateDropdown lỗi (" .. tostring(dropdownErr) .. ") → dùng toggle dự phòng", 6, "warn")
        FossilsTab:CreateToggle({ Title = "Chế độ ăn: MEAT", Default = false, Callback = function(v)
            if v then _G.KaitunFeedMode = "Meat" elseif _G.KaitunFeedMode == "Meat" then _G.KaitunFeedMode = "None" end
        end })
        FossilsTab:CreateToggle({ Title = "Chế độ ăn: HERB", Default = false, Callback = function(v)
            if v then _G.KaitunFeedMode = "Herb" end
        end })
    end
end

-- [#1] Toggle Auto Nuôi (Kaitun) — #10: bật là tele Hide Spot 1 ngay
FossilsTab:CreateToggle({
    Title = "Auto Nuôi (Kaitun)",
    Description = "Bật = tele về Hide Spot 1 ngay lập tức",
    Default = false,
    Callback = function(state)
        if _G.KaitunSetEnabled then
            _G.KaitunSetEnabled(state)
        else
            _G.KaitunEnabled = state
        end
        if _G.KaitunUpdateStatus then _G.KaitunUpdateStatus() end
    end,
})



----------------------------------------------------
-- TAB CAI DAT / UTILITY
----------------------------------------------------
VisualsTab:CreateSection("Utility")
VisualsTab:CreateToggle({
    Title="Trời Sáng (Fullbright)", Default=false,
    Callback=function(state)
        local Lighting=game:GetService("Lighting")
        if state then
            Lighting.Brightness=2
            Lighting.ClockTime=14
            Lighting.GlobalShadows=false
        else
            Lighting.Brightness=1
            Lighting.GlobalShadows=true
        end
    end,
})

lowServerBtn = VisualsTab:CreateButton({
    Title="HOP Server (Low Player)",
    Callback=function()
        local teleportService=game:GetService("TeleportService")
        local placeId=game.PlaceId
        local jobId=game.JobId

        local function SetLowServerText(text)
            if not lowServerBtn or not lowServerBtn.Frame then return end
            local label = lowServerBtn.Frame:FindFirstChild("Title", true) or lowServerBtn.Frame:FindFirstChildWhichIsA("TextLabel", true)
            if label then label.Text=tostring(text) end
        end

        SetLowServerText("Đang Tìm Server...")
        local success,result=pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/0?sortOrder=Asc&limit=100")
        end)
        if success and result then
            local ok,decoded=pcall(function() return HttpService:JSONDecode(result) end)
            if ok and decoded and decoded.data then
                for _,server in ipairs(decoded.data) do
                    if server.id~=jobId and server.playing<server.maxPlayers and server.playing>0 then
                        SetLowServerText("Dang Chuyen Server ("..server.playing.." nguoi)...")
                        teleportService:TeleportToPlaceInstance(placeId,server.id,LocalPlayer)
                        return
                    end
                end
            end
        end
        SetLowServerText("Không Tìm Thất Server!")
        task.delay(2,function()
            if lowServerBtn and lowServerBtn.Frame and lowServerBtn.Frame.Parent then
                SetLowServerText("Vào Server Ít Người (Low Player)")
            end
        end)
    end,
})

VisualsTab:CreateButton({
    Title="Hồi Sinh Nhân vật (Reset)",
    Callback=function()
        local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health=0 end
    end,
})


LoaderStage(7)

----------------------------------------------------
-- 5. LOGIC CHẠY NGẦM (AUTO ATTACK, NHẶT ĐẠN, FOSSILS, AUTO ĂN THỊT/CỎ & ANTI-AFK)
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local Mouse = LocalPlayer:GetMouse()
Mouse.Button1Down:Connect(function()
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and Mouse.Target then
            hrp.CFrame = CFrame.new(Mouse.Hit.X, Mouse.Hit.Y + 3, Mouse.Hit.Z)
        end
    end
end)

-- Vòng lặp Auto Attack (PVP)
task.spawn(function()
    while true do
        if _G.AutoAttackRunning and hasTargetInFOV then
            triggerAttack()
        end
        task.wait(0.1)
    end
end)

-- Vòng lặp Auto Nhặt Đạn (PVP)
task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.AutoFarmAmmo and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local char = LocalPlayer.Character
            local hrp = char.HumanoidRootPart
            local currentAmmo, reserveAmmo, infoMsg = checkAmmoStatus()
            
            SetAmmoStatus(infoMsg)
            
            if currentAmmo == 0 and reserveAmmo == 0 then
                SetAmmoStatus("Hết đạn (00/0)! Đang tới chỗ nhặt...")
                local originalCFrame = hrp.CFrame
                
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.Anchored = false
                
                for i = 1, 5 do
                    hrp.CFrame = targetAmmoCFrame
                    task.wait(0.03)
                end
                
                hrp.Anchored = true
                
                local function tryInteract()
                    local found = false
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("ProximityPrompt") and v.Enabled then
                            local promptPos = getPromptPosition(v)
                            if promptPos then
                                local distance = (promptPos - hrp.Position).Magnitude
                                if distance <= ammoMaxDistance then
                                    found = true
                                    fireproximityprompt(v)
                                end
                            end
                        end
                    end
                    return found
                end

                SetAmmoStatus("Đang nhặt đạn (Lần 1)...")
                tryInteract()
                task.wait(0.6)

                SetAmmoStatus("Đang nhặt đạn (Lần 2)...")
                tryInteract()
                task.wait(0.6)
                
                hrp.Anchored = false
                hrp.AssemblyLinearVelocity = Vector3.zero
                for i = 1, 5 do
                    hrp.CFrame = originalCFrame
                    task.wait(0.03)
                end
                
                SetAmmoStatus("Đã bơm đầy đạn! Đang quay lại...")
                task.wait(2)
            end
        end
    end
end)

-- LOGIC AUTO ĂN THỊT / ĂN CỎ - OPTIMIZED
-- Dùng spatial query thay cho Workspace:GetDescendants() mỗi chu kỳ.
-- RemoteEvent được cache một lần, không quét ReplicatedStorage liên tục.
local EAT_CONFIG = {
    SEARCH_RADIUS = 350,
    CYCLE_INTERVAL = 1.0,
    STAY_DURATION = 0.32,
    INTERACTION_INTERVAL = 0.11,
    MAX_TARGETS_CHECKED = 222,
    STRICT_MEAT_KEYWORDS = {"carcass", "meat", "corpse", "deadbody", "ribs", "flesh"},
    STRICT_HERB_KEYWORDS = {"bush", "plant", "grass", "foliage", "herb", "fern", "leaves", "berry", "shrub"}
}

local IsExecutingEatOrHerb = false
local EatRemoteCandidates = {}
local EatOverlapParams = OverlapParams.new()
EatOverlapParams.FilterType = Enum.RaycastFilterType.Exclude

local function RefreshEatFilter()
    local char = LocalPlayer.Character
    EatOverlapParams.FilterDescendantsInstances = char and {char} or {}
end

RefreshEatFilter()
LocalPlayer.CharacterAdded:Connect(function()
    task.defer(RefreshEatFilter)
end)

-- Cache các RemoteEvent liên quan một lần.
do
    local ok = pcall(function()
        for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local name = string.lower(remote.Name)
                if name:find("eat") or name:find("bite") or name:find("interact")
                    or name:find("feed") or name:find("consume") or name:find("herb") or name:find("graze") then
                    EatRemoteCandidates[#EatRemoteCandidates + 1] = remote
                end
            end
        end
    end)
    if not ok then
        table.clear(EatRemoteCandidates)
    end
end

local function IsTargetNameMatch(part, keywords)
    local name = string.lower(part.Name)
    local parent = part.Parent
    local parentName = parent and string.lower(parent.Name) or ""

    for i = 1, #keywords do
        local key = keywords[i]
        if name:find(key, 1, true) or parentName:find(key, 1, true) then
            return true
        end
    end
    return false
end

local function IsLivingEntityOrMapDecor(instance)
    local model = instance:FindFirstAncestorOfClass("Model")
    if not model then
        return false
    end

    if Players:GetPlayerFromCharacter(model) then
        return true
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health > 0 then
        return true
    end

    local modelName = string.lower(model.Name)
    return modelName:find("map", 1, true) ~= nil
        or modelName:find("border", 1, true) ~= nil
        or modelName:find("ocean", 1, true) ~= nil
        or modelName:find("decor", 1, true) ~= nil
end

local function ScanNearbyTarget(keywords)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        return nil
    end

    local best = nil
    local bestDistanceSq = EAT_CONFIG.SEARCH_RADIUS * EAT_CONFIG.SEARCH_RADIUS
    local parts = Workspace:GetPartBoundsInRadius(root.Position, EAT_CONFIG.SEARCH_RADIUS, EatOverlapParams)
    local checked = 0

    for i = 1, #parts do
        if checked >= EAT_CONFIG.MAX_TARGETS_CHECKED then
            break
        end

        local part = parts[i]
        if part:IsA("BasePart") and IsTargetNameMatch(part, keywords) and not IsLivingEntityOrMapDecor(part) then
            checked = checked + 1
            local delta = part.Position - root.Position
            local distanceSq = delta.X * delta.X + delta.Y * delta.Y + delta.Z * delta.Z
            if distanceSq < bestDistanceSq then
                bestDistanceSq = distanceSq
                best = part
            end
        end
    end

    return best
end

local function TriggerInteraction(targetPart)
    local prompt = targetPart:FindFirstChildOfClass("ProximityPrompt")
        or (targetPart.Parent and targetPart.Parent:FindFirstChildOfClass("ProximityPrompt"))

    if prompt and typeof(fireproximityprompt) == "function" then
        pcall(fireproximityprompt, prompt)
        return true
    end

    -- Fallback: dùng danh sách RemoteEvent đã cache.
    -- Giữ đủ các payload cũ nhưng chỉ chạy một lần / target thay vì lặp mỗi 0.07s.
    for i = 1, #EatRemoteCandidates do
        local remote = EatRemoteCandidates[i]
        if remote and remote.Parent then
            pcall(function()
                remote:FireServer(targetPart)
                remote:FireServer(targetPart.Parent)
                remote:FireServer("Eat", targetPart)
                remote:FireServer("Herb", targetPart)
            end)
        end
    end

    return #EatRemoteCandidates > 0
end

local function PerformBlink(targetPart)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if IsExecutingEatOrHerb or not root or not char or not targetPart or not targetPart.Parent then
        return
    end

    IsExecutingEatOrHerb = true
    local __kaitunBlinkGen = _G.KaitunGetGen and _G.KaitunGetGen() or 0

    pcall(function()
        local storedCFrame = root.CFrame
        local storedVelocity = root.AssemblyLinearVelocity
        local oldCollision = {}

        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide then
                oldCollision[#oldCollision + 1] = part
                part.CanCollide = false
            end
        end

        root.AssemblyLinearVelocity = Vector3.zero
        root.CFrame = targetPart.CFrame * CFrame.new(0, 1, 0)

        local finishAt = os.clock() + EAT_CONFIG.STAY_DURATION
        local nextInteract = 0
        while os.clock() < finishAt do
            if not targetPart.Parent then
                break
            end
            local now = os.clock()
            if now >= nextInteract then
                TriggerInteraction(targetPart)
                nextInteract = now + EAT_CONFIG.INTERACTION_INTERVAL
            end
            task.wait(0.03)
        end

        -- [#17] Kaitun generation guard: không trả về vị trí cũ nếu engine vừa chuyển chỗ trú
        local __kaitunGenOk = (not _G.KaitunGetGen) or (_G.KaitunGetGen() == __kaitunBlinkGen)
        if root.Parent and __kaitunGenOk then
            root.CFrame = storedCFrame
            root.AssemblyLinearVelocity = storedVelocity
        end

        for i = 1, #oldCollision do
            local part = oldCollision[i]
            if part and part.Parent then
                part.CanCollide = true
            end
        end
    end)

    IsExecutingEatOrHerb = false
end

-- Một worker duy nhất cho cả Meat + Herb.
task.spawn(function()
    while true do
        task.wait(EAT_CONFIG.CYCLE_INTERVAL)

        local active = _G.AutoEatActive or _G.AutoHerbActive
        if active and not IsExecutingEatOrHerb then
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not char or not root or not hum or hum.Health <= 0 then
                    return
                end

                -- Giữ behavior cũ: Herb được ưu tiên nếu cả hai toggle cùng bật.
                local keywords = _G.AutoHerbActive
                    and EAT_CONFIG.STRICT_HERB_KEYWORDS
                    or EAT_CONFIG.STRICT_MEAT_KEYWORDS

                local target = ScanNearbyTarget(keywords)
                if target then
                    PerformBlink(target)
                end
            end)
        end
    end
end)

-- Vòng lặp Quét Quest (Fossils)
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local playerGui = LocalPlayer:WaitForChild("PlayerGui")
            local questsFrame = playerGui:FindFirstChild("GameUI") and playerGui.GameUI:FindFirstChild("QuestsFrame")
            local detectedQuest = "None"
            
            if questsFrame then
                for _, child in pairs(questsFrame:GetChildren()) do
                    local textContent = ""
                    for _, desc in pairs(child:GetDescendants()) do
                        if desc:IsA("TextLabel") then
                            textContent = textContent .. " " .. string.lower(desc.Text)
                        end
                    end
                    
                    if string.find(textContent, "drink water") then
                        detectedQuest = "Drink"
                        break
                    elseif string.find(textContent, "rest") then
                        detectedQuest = "Rest"
                        break
                    end
                end
            end
            
            _G.CurrentQuest = detectedQuest
            
            -- [#5] Kaitun ON + Chế độ ăn None → NHÃN QUEST CHUYỂN ĐỎ + cảnh báo
            if _G.KaitunEnabled and _G.KaitunFeedMode == "None" then
                SetQuestStatus("⚠ KAITUN: CHƯA CHỌN CHẾ ĐỘ ĂN (MEAT/HERB)!", Color3.fromRGB(255, 0, 0))
            elseif detectedQuest == "Drink" then
                SetQuestStatus("Quest Hiện Tại: Uống Nước (Drink)", Color3.fromRGB(50, 150, 255))
            elseif detectedQuest == "Rest" then
                SetQuestStatus("Quest Hiện Tại: Nghỉ Nơi (Rest)", Color3.fromRGB(255, 165, 0))
            else
                SetQuestStatus("Quest Hiện Tại: Đang chờ...", Color3.fromRGB(255, 255, 0))
            end
        end)
    end
end)

task.spawn(function()
    while true do
        if _G.AutoDrinkRunning then
            pcall(function() 
                game:GetService("ReplicatedStorage").Remotes.Character.CharacterFunctions:InvokeServer("Drink") 
            end)
            task.wait(0.8)
        else
            task.wait(0.2)
        end
    end
end)

task.spawn(function()
    local restRemote = game:GetService("ReplicatedStorage").Remotes.Character.Rest
    local isRestingActive = false
    while true do
        task.wait(0.3)
        -- [#7] Rest thông minh khi Kaitun bật: <50% nghỉ — ≥95% dừng (engine điều khiển)
        local shouldRest
        if _G.KaitunEnabled and type(_G.KaitunRestShould) == "function" then
            shouldRest = _G.KaitunRestShould()
        else
            shouldRest = _G.AutoRestRunning and (_G.CurrentQuest == "Rest")
        end
        if shouldRest and not isRestingActive then
            pcall(function() restRemote:InvokeServer(true) end)
            isRestingActive = true
        elseif not shouldRest and isRestingActive then
            pcall(function() restRemote:InvokeServer(false) end)
            isRestingActive = false
        end
    end
end)

local function IsThisZoneGreen(targetPos)
    local isGreen = false
    pcall(function()
        local folder = game:GetService("Workspace").MapResources.Zones
        for _, zoneObj in pairs(folder:GetChildren()) do
            local core = zoneObj:FindFirstChild("LightCore")
            if core and (core.Position - targetPos).Magnitude < 15 then
                local color = core.Color
                if color.R == 0 and color.G > 0.9 and color.B == 0 then isGreen = true end
                break
            end
        end
    end)
    return isGreen
end

local ZonesList = {
    Vector3.new(-144.54, -102.15, 1032.19),
    Vector3.new(-617.92, 143.39, -1130.44),
    Vector3.new(1449.99, 77.16, -677.59),
    Vector3.new(276.03, 75.50, -1029.02),
    Vector3.new(-513.23, 75.73, -430.79),
    Vector3.new(1090.65, 66.03, 467.14),
    Vector3.new(209.25, -32.79, -359.19),
    Vector3.new(-170.20, 109.98, 388.42),
    Vector3.new(-69.11, -61.16, -1493.54)
}

task.spawn(function()
    while true do
        if _G.AutoZoneRunning then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local safetyZone3CFrame = CFrame.new(1449.99, 77.16 + 5, -677.59)
                for i = 1, #ZonesList do
                    if not _G.AutoZoneRunning then break end
                    local zonePos = ZonesList[i]
                    local targetCFrame = CFrame.new(zonePos.X, zonePos.Y + 5, zonePos.Z)
                    
                    if not IsThisZoneGreen(zonePos) then
                        hrp.CFrame = targetCFrame
                        task.wait(0.1)
                        local startTime = tick()
                        local lastCheckTime = 0
                        
                        while _G.AutoZoneRunning do
                            local now = tick()
                            
                            -- Chỉ quét kiểm tra xem Zone đã XANH chưa mỗi 0.5 giây (Tiết kiệm 90% CPU)
                            if now - lastCheckTime >= 0.5 then
                                lastCheckTime = now
                                if IsThisZoneGreen(zonePos) or (now - startTime >= 15) then 
                                    break 
                                end
                            end
                            
                            -- Giữ hiệu ứng rung lắc nhưng tăng thời gian chờ lên 0.08s (khoảng 12 lần/giây)
                            local shakeX = math.sin(now * 8) * 0.35
                            local shakeZ = math.cos(now * 8) * 0.35
                            hrp.CFrame = targetCFrame * CFrame.new(shakeX, 0, shakeZ)
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            task.wait(0.08)
                        end
                        task.wait(0.3)
                    end
                end
                if hrp and _G.AutoZoneRunning then hrp.CFrame = safetyZone3CFrame end
                task.wait(3)
            else
                task.wait(0.5)
            end
        else
            task.wait(0.2)
        end
    end
end)

----------------------------------------------------



-- ╔══════════════════════════════════════════════════════════════════╗
-- ║          🐾 KAITUN ENGINE — AUTO NUÔI + SMART HIDE                ║
-- ╠══════════════════════════════════════════════════════════════════╣
-- ║ #2  Scan food 100m→200m→300m→500m (cooldown 0.3/0.5/0.5/1.0s)    ║
-- ║ #3  Ngưỡng ăn: <50% bắt đầu — ≥95% dừng (có hysteresis)          ║
-- ║ #6  Drink giữ nguyên: spam remote 0.8s                           ║
-- ║ #7  Rest thông minh: <50% nghỉ — ≥95% dừng                       ║
-- ║ #9  KHÔNG dùng safe zone dòng 1790 (pet không vào được)          ║
-- ║ #10 Bật Kaitun → tele Hide Spot 1 NGAY LẬP TỨC                   ║
-- ║ #11 Ẩn khi: Quest None/xong + Đói≥80% + Khát≥80% + Kaitun ON     ║
-- ║ #12 Anti-stuck: 30s không thấy food → Hide 1, chờ 10s            ║
-- ║ #13 Đói <10% → LocalPlayer:Kick (auto shutdown)                  ║
-- ║ #14 L1: quét địch 150m trước khi tele                            ║
-- ║ #15 L2: attack thật (địch + mất máu) vs bleed (mất máu không địch)║
-- ║ #16 Cooldown switch 15s                                          ║
-- ║ #17 L3: cycle Hide1 → Hide2 → Sky → Hide1 ...                    ║
-- ║ #18 Sky: tele lên + anchor 60s → tự về Hide 1                    ║
-- ║ #19 Bleed: KHÔNG switch, chỉ notify                              ║
-- ╚══════════════════════════════════════════════════════════════════╝

local KAITUN_SKY_PROVIDED = false
local KAITUN_SHOW_MARKERS = true -- v2.2: BillboardGui đánh dấu 3 điểm trú
local KAITUN_FOOD_ESP   = true -- v2.4: Highlight đồ ăn quanh bạn
local KAITUN_PLAYER_HUD = true -- v2.4: HUD chỉ số nhỏ góc màn hình
local KAITUN_ESP_RANGE  = 600 -- v2.6: bán kính quét ESP food (m)
local KAITUN_ANTI_AFK   = true -- v2.6: chặn kick AFK 20 phút
local KAITUN_AUTO_REJOIN = true -- v2.6: lỗi teleport → tự vào lại
local KAITUN_AUTO_HOP   = false -- v2.7: server đông → tự nhảy server vắng

local KAITUN_CONFIG = {
    FEED_MODE          = "None",  -- đồng bộ dropdown (#4: mặc định None)
    SCAN_STEPS         = { {100, 0.3}, {200, 0.5}, {300, 0.5}, {500, 1} }, -- #2

    EAT_START_PERCENT  = 50,  -- #3 (web-tunable)
    EAT_STOP_PERCENT   = 95,   -- #3
    REST_START_PERCENT = 50, -- #7
    REST_STOP_PERCENT  = 95,  -- #7

    HIDE_HUNGER_MIN    = 80, -- #11
    HIDE_THIRST_MIN    = 80, -- #11
    KICK_HUNGER        = 10,    -- #13

    ENEMY_SCAN_RANGE   = 150, -- #14
    SWITCH_COOLDOWN    = 15, -- #16
    SKY_ANCHOR_TIME    = 60,  -- #18

    ANTISTUCK_NOFOOD   = 30, -- #12
    ANTISTUCK_WAIT     = 10,   -- #12

    HIDE_SPOT_1        = Vector3.new(-965.171, 114.720, -418.536), -- #20
    HIDE_SPOT_2        = Vector3.new(-589.342, 93.005, -1322.879), -- #21
    SKY_SPOT           = Vector3.new(-777.800, 450.000, -777.800), -- ⚠ ITEM #22: CHỜ CUNG CẤP TỌA ĐỘ! Sửa ở Kaitun Control Panel (web),

    HOP_PLAYER_MAX     = 12,      -- v2.7: đông hơn mức này → hop
    HOP_CHECK_INTERVAL = 120,  -- v2.7: chu kỳ kiểm tra (s)
    HOP_SERVER_LIMIT   = 100,    -- v2.8: số server mỗi trang API (tối đa 100)
    HOP_MAX_PAGES      = 2,       -- v2.8: quét tối đa bao nhiêu trang (cursor)
}

if not _G.KaitunNotify then
    _G.KaitunNotify = function(text, duration)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "🐾 Kaitun", Text = tostring(text), Duration = duration or 4
            })
        end)
    end
end

-- ═══════════ [KAITUN v2.2] WEBHOOK DISCORD — đẩy notify lên server ngoài ═══════════
local KAITUN_WEBHOOK_URL = ""
local KAITUN_WEBHOOK_ON  = false

if KAITUN_WEBHOOK_ON and KAITUN_WEBHOOK_URL ~= "" and not _G.KaitunWebhookWrapped then
    _G.KaitunWebhookWrapped = true
    local __baseNotify = _G.KaitunNotify
    -- v2.10: lọc LOẠI sự kiện đẩy lên Discord (in-game vẫn hiện đủ, chỉ lọc khi push)
    local WEBHOOK_FILTER = {
        switch    = true,
        bleed     = true,
        antistuck = true,
        kick      = true,
        status    = true, -- v2.11: BẬT/TẮT, engine sẵn sàng
        warn      = true,   -- v2.11: cảnh báo mode None, dropdown lỗi
    }
    local function sendWebhook(text)
        pcall(function()
            local req = (typeof(syn) == "table" and syn.request)
                or (typeof(http) == "table" and http.request)
                or http_request or request
            if not req then return end
            local body = game:GetService("HttpService"):JSONEncode({
                username = "🐾 Kaitun",
                content = tostring(text):sub(1, 1800),
            })
            req({
                Url = KAITUN_WEBHOOK_URL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = body,
            })
        end)
    end
    _G.KaitunNotify = function(text, duration, tag)
        if __baseNotify then pcall(__baseNotify, text, duration) end
        -- v2.11: tag là loại sự kiện (switch/bleed/antistuck/kick/status/warn) — bị tắt lọc thì KHÔNG push Discord
        if tag ~= nil and WEBHOOK_FILTER[tostring(tag)] == false then return end
        task.spawn(sendWebhook, "🐾 Kaitun • " .. tostring(text))
    end
    _G.KaitunWebhookTest = sendWebhook
    task.delay(3, function()
        local parts = {}
        if WEBHOOK_FILTER.switch then table.insert(parts, "switch chỗ trú") end
        if WEBHOOK_FILTER.bleed then table.insert(parts, "bleed") end
        if WEBHOOK_FILTER.antistuck then table.insert(parts, "anti-stuck") end
        if WEBHOOK_FILTER.kick then table.insert(parts, "kick") end
        if WEBHOOK_FILTER.status then table.insert(parts, "trạng thái") end
        if WEBHOOK_FILTER.warn then table.insert(parts, "cảnh báo") end
        local list = #parts > 0 and table.concat(parts, ", ") or "(mọi loại đã tắt — chỉ notify trong game)"
        sendWebhook("✅ Kaitun v2.11 đã kết nối webhook — sẽ báo: " .. list .. ".")
    end)
end

-- ═══════════ [KAITUN] TRẠNG THÁI NỘI BỘ ═══════════
local KState = {
    currentSpot       = 1,   -- 1=Hide1, 2=Hide2, 3=Sky (theo SPOT_CYCLE)
    lastSwitchAt      = 0,
    lastFoodSeenAt    = os.clock(),
    antistuckUntil    = 0,
    eating            = false,
    eatActive         = false, -- hysteresis #3: <50% bật — ≥95% tắt
    gen               = 0,     -- tăng mỗi lần engine tự di chuyển (chống xung đột blink #17)
    lastHealth        = nil,
    lastBleedNotifyAt = 0,
    drinkDriven       = false,
}

_G.KaitunEnabled    = _G.KaitunEnabled or false
_G.KaitunFeedMode   = _G.KaitunFeedMode or "None"
_G.KaitunRestActive = false
_G.KaitunSkyAnchored = false
_G.KaitunGetGen     = function() return KState.gen end

local function bumpGen()
    KState.gen = KState.gen + 1
    return KState.gen
end

-- ═══════════ [KAITUN] HELPERS NHÂN VẬT ═══════════
local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function teleportTo(spot, extraY)
    local hrp = getRoot()
    if not hrp then return false end
    hrp.Anchored = false
    hrp.AssemblyLinearVelocity = Vector3.zero
    bumpGen()
    for _ = 1, 5 do
        hrp.CFrame = CFrame.new(spot.X, spot.Y + (extraY or 3), spot.Z)
        task.wait(0.03)
    end
    return true
end

-- ═══════════ [KAITUN] ĐỌC CHỈ SỐ ĐÓI / KHÁT / THỂ LỰC ═══════════
local STAT_ALIASES = {
    Hunger = { "hunger", "food", "doi" },
    Thirst = { "thirst", "water", "khat" },
    Rest   = { "energy", "stamina", "rest", "sleep" },
}

local function readNumber(v)
    if typeof(v) == "number" then return v end
    if typeof(v) == "string" then
        local pct = string.match(v, "(%d+)%s*%%")
        if pct then return tonumber(pct) end
        local num = string.match(v, "(%d+)")
        if num then return tonumber(num) end
    end
    return nil
end

local function normalizePercent(v)
    if not v then return nil end
    if v <= 1 then return v * 100 end
    return v
end

local function matchKey(name, keys)
    local n = string.lower(tostring(name))
    for _, k in ipairs(keys) do
        if string.find(n, k, 1, true) then return true end
    end
    return false
end

local function scanGuiForStat(keys)
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    -- (a) TextLabel/TextBox có tên khớp → đọc số trong Text
    for _, obj in ipairs(pg:GetDescendants()) do
        if (obj:IsA("TextLabel") or obj:IsA("TextBox")) and matchKey(obj.Name, keys) then
            local v = readNumber(obj.Text)
            if v then return normalizePercent(v) end
        end
    end
    -- (b) Frame/bar có tên khớp → lấy scale X (thanh %)
    for _, obj in ipairs(pg:GetDescendants()) do
        if obj:IsA("Frame") and matchKey(obj.Name, keys) and obj.Size.X.Scale > 0 then
            return obj.Size.X.Scale * 100
        end
    end
    return nil
end

local function getStatPercent(kind)
    local keys = STAT_ALIASES[kind]
    if not keys then return nil end
    -- (1) Attribute trên nhân vật / player
    local char = LocalPlayer.Character
    if char then
        for _, attrName in ipairs(char:GetAttributes()) do
            if matchKey(attrName, keys) then
                local v = readNumber(char:GetAttribute(attrName))
                if v then return normalizePercent(v) end
            end
        end
    end
    for _, attrName in ipairs(LocalPlayer:GetAttributes()) do
        if matchKey(attrName, keys) then
            local v = readNumber(LocalPlayer:GetAttribute(attrName))
            if v then return normalizePercent(v) end
        end
    end
    -- (2) leaderstats
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    if ls then
        for _, child in ipairs(ls:GetChildren()) do
            if child:IsA("ValueBase") and matchKey(child.Name, keys) then
                local v = readNumber(child.Value)
                if v then return normalizePercent(v) end
            end
        end
    end
    -- (3) PlayerGui
    return scanGuiForStat(keys)
end

-- ═══════════ [KAITUN #14] LỚP 1 — QUÉT ĐỊCH 150m ═══════════
local HOSTILE_KEYWORDS = { "raptor", "trex", "t-rex", "tyrann", "carno", "spino", "allosaur", "giga", "baryonyx", "wolf", "bear", "saber", "carnivore", "predator" }

local EnemyOverlapParams = OverlapParams.new()
EnemyOverlapParams.FilterType = Enum.RaycastFilterType.Exclude

local function refreshEnemyFilter()
    local char = LocalPlayer.Character
    EnemyOverlapParams.FilterDescendantsInstances = char and { char } or {}
end
refreshEnemyFilter()
LocalPlayer.CharacterAdded:Connect(function()
    task.defer(refreshEnemyFilter)
end)

-- Khoảng cách tới địch gần nhất quanh 1 vị trí (nil = an toàn)
local function nearestEnemyDistance(fromPos, range)
    local nearest = nil
    -- (a) Người chơi khác (mối đe dọa PVP)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
                or plr.Character:FindFirstChild("UpperTorso")
                or plr.Character:FindFirstChild("Torso")
            if hum and hum.Health > 0 and root then
                local d = (root.Position - fromPos).Magnitude
                if d <= range and (not nearest or d < nearest) then
                    nearest = d
                end
            end
        end
    end
    -- (b) NPC dữ theo tên model (spatial query cho nhẹ máy)
    local ok, parts = pcall(function()
        return Workspace:GetPartBoundsInRadius(fromPos, range, EnemyOverlapParams)
    end)
    if ok and parts then
        local checked = 0
        for i = 1, #parts do
            if checked >= 100 then break end
            local model = parts[i]:FindFirstAncestorOfClass("Model")
            if model and not Players:GetPlayerFromCharacter(model) and matchKey(model.Name, HOSTILE_KEYWORDS) then
                checked = checked + 1
                local hum = model:FindFirstChildOfClass("Humanoid")
                local root = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or parts[i]
                if hum and hum.Health > 0 then
                    local d = (root.Position - fromPos).Magnitude
                    if d <= range and (not nearest or d < nearest) then
                        nearest = d
                    end
                end
            end
        end
    end
    return nearest
end

local function isSpotSafe(spotPos, range)
    return nearestEnemyDistance(spotPos, range or KAITUN_CONFIG.ENEMY_SCAN_RANGE) == nil
end

-- ═══════════ [KAITUN #17] LỚP 3 — CYCLE HIDE1 → HIDE2 → SKY ═══════════
local SPOT_CYCLE = { "HIDE1", "HIDE2" }
if KAITUN_SKY_PROVIDED then
    SPOT_CYCLE[#SPOT_CYCLE + 1] = "SKY" -- #22: có tọa độ mới thêm Sky vào cycle
end

local function spotPosition(key)
    if key == "HIDE1" then return KAITUN_CONFIG.HIDE_SPOT_1 end
    if key == "HIDE2" then return KAITUN_CONFIG.HIDE_SPOT_2 end
    return KAITUN_CONFIG.SKY_SPOT
end

local function spotName(key)
    if key == "HIDE1" then return "Hide Spot 1" end
    if key == "HIDE2" then return "Hide Spot 2" end
    return "Sky Spot"
end

local function performSwitch(reason)
    -- #16: cooldown switch 15s
    if os.clock() - KState.lastSwitchAt < KAITUN_CONFIG.SWITCH_COOLDOWN then
        return false
    end
    local hrp = getRoot()
    if not hrp then return false end

    local startIdx = KState.currentSpot
    for step = 1, #SPOT_CYCLE do
        local idx = ((startIdx - 1 + step) % #SPOT_CYCLE) + 1
        local key = SPOT_CYCLE[idx]
        local pos = spotPosition(key)

        if key == "SKY" then
            -- #18: tele lên trời + anchor 60s + tự về Hide 1
            KState.lastSwitchAt = os.clock()
            KState.currentSpot = idx
            local myGen = bumpGen()
            _G.KaitunSkyAnchored = true
            hrp.Anchored = false
            hrp.AssemblyLinearVelocity = Vector3.zero
            for _ = 1, 5 do
                hrp.CFrame = CFrame.new(pos.X, pos.Y + 3, pos.Z)
                task.wait(0.03)
            end
            hrp.Anchored = true
            _G.KaitunNotify("🌪 ATTACK → BAY LÊN SKY SPOT! Neo " .. KAITUN_CONFIG.SKY_ANCHOR_TIME .. "s rồi tự về Hide 1", 5, "switch")
            task.delay(KAITUN_CONFIG.SKY_ANCHOR_TIME, function()
                local h = getRoot()
                if not h then return end
                if KState.gen ~= myGen or not _G.KaitunEnabled then
                    h.Anchored = false -- có lệnh mới hơn hoặc đã tắt → chỉ gỡ neo
                    _G.KaitunSkyAnchored = false
                    return
                end
                h.Anchored = false
                _G.KaitunSkyAnchored = false
                teleportTo(KAITUN_CONFIG.HIDE_SPOT_1)
                KState.currentSpot = 1
                KState.lastSwitchAt = os.clock()
                _G.KaitunNotify("⬇ Hết " .. KAITUN_CONFIG.SKY_ANCHOR_TIME .. "s trên trời → về Hide Spot 1", 4, "switch")
            end)
            return true
        end

        -- #14 LỚP 1: kiểm tra spot an toàn (quét địch 150m) trước khi tele
        local enemyDist = nearestEnemyDistance(pos, KAITUN_CONFIG.ENEMY_SCAN_RANGE)
        if enemyDist == nil then
            KState.lastSwitchAt = os.clock()
            KState.currentSpot = idx
            teleportTo(pos)
            _G.KaitunNotify("🛡 " .. tostring(reason or "Địch attack") .. " → chuyển tới " .. spotName(key) .. " (check an toàn 150m ✓)", 4, "switch")
            return true
        else
            _G.KaitunNotify("⚠ " .. spotName(key) .. " KHÔNG an toàn (địch ~" .. tostring(math.floor(enemyDist)) .. "m) — thử điểm kế tiếp...", 3, "switch")
        end
    end
    _G.KaitunNotify("❌ Cả cycle đều không an toàn! Ở nguyên vị trí, thử lại sau cooldown 15s.", 4, "switch")
    return false
end

-- ═══════════ [KAITUN #15] LỚP 2 — ATTACK THẬT vs BLEED ═══════════
task.spawn(function()
    while true do
        task.wait(0.2)
        if not _G.KaitunEnabled then
            local hum = getHumanoid()
            KState.lastHealth = hum and hum.Health or nil
        else
            local hum = getHumanoid()
            if hum and hum.Health > 0 then
                local now = os.clock()
                if KState.lastHealth == nil then
                    KState.lastHealth = hum.Health
                elseif hum.Health < KState.lastHealth - 0.5 then
                    KState.lastHealth = hum.Health
                    local root = getRoot()
                    if root and not _G.KaitunSkyAnchored then
                        local enemyDist = nearestEnemyDistance(root.Position, KAITUN_CONFIG.ENEMY_SCAN_RANGE)
                        if enemyDist then
                            -- ATTACK THẬT: có địch + mất máu → L3 cycle (#17)
                            performSwitch("Attack thật (địch " .. math.floor(enemyDist) .. "m + mất máu)")
                        elseif now - KState.lastBleedNotifyAt >= 10 then
                            -- #19 BLEED: mất máu, không địch → KHÔNG switch, chỉ notify
                            KState.lastBleedNotifyAt = now
                            _G.KaitunNotify("🩸 Đang mất máu nhưng KHÔNG có địch trong 150m → BLEED. Không đổi chỗ, chỉ theo dõi.", 4, "bleed")
                        end
                    end
                elseif hum.Health > KState.lastHealth then
                    KState.lastHealth = hum.Health
                end
            else
                KState.lastHealth = nil
            end
        end
    end
end)

-- ═══════════ [KAITUN #2][#3][#12] SCAN FOOD + VÒNG LẶP ĂN ═══════════
local EAT_KEYWORDS = {
    Meat = EAT_CONFIG.STRICT_MEAT_KEYWORDS, -- giữ nguyên keyword thịt của bản gốc
    Herb = EAT_CONFIG.STRICT_HERB_KEYWORDS, -- giữ nguyên keyword cỏ của bản gốc
}

local function scanFoodAtRange(radius, keywords)
    local root = getRoot()
    if not root then return nil end
    local ok, parts = pcall(function()
        return Workspace:GetPartBoundsInRadius(root.Position, radius, EatOverlapParams)
    end)
    if not ok or not parts then return nil end
    local best, bestDist = nil, math.huge
    local checked = 0
    for i = 1, #parts do
        if checked >= EAT_CONFIG.MAX_TARGETS_CHECKED then break end
        local part = parts[i]
        if part:IsA("BasePart") and IsTargetNameMatch(part, keywords) and not IsLivingEntityOrMapDecor(part) then
            checked = checked + 1
            local d = (part.Position - root.Position).Magnitude
            if d < bestDist then
                best, bestDist = part, d
            end
        end
    end
    return best
end

task.spawn(function()
    while true do
        task.wait(0.3)
        local mode = _G.KaitunFeedMode
        if (not _G.KaitunEnabled) or mode == "None" or _G.KaitunSkyAnchored or os.clock() < KState.antistuckUntil then
            KState.eating = false
            KState.eatActive = false
            KState.lastFoodSeenAt = os.clock()
        else
            local hunger = getStatPercent("Hunger")
            local shouldEat
            if hunger then
                -- #3 hysteresis: <50% bắt đầu — chỉ dừng khi ≥95%
                if hunger < KAITUN_CONFIG.EAT_START_PERCENT then
                    KState.eatActive = true
                elseif hunger >= KAITUN_CONFIG.EAT_STOP_PERCENT then
                    KState.eatActive = false
                end
                shouldEat = KState.eatActive
            else
                shouldEat = true -- không đọc được chỉ số → ăn theo chu kỳ an toàn
            end

            if shouldEat and not IsExecutingEatOrHerb then
                KState.eating = true
                local keywords = EAT_KEYWORDS[mode] or EAT_CONFIG.STRICT_MEAT_KEYWORDS
                local found = nil
                -- #2: scan tăng cấp 100m → 200m → 300m → 500m (cooldown 0.3/0.5/0.5/1.0s)
                for _, stepCfg in ipairs(KAITUN_CONFIG.SCAN_STEPS) do
                    found = scanFoodAtRange(stepCfg[1], keywords)
                    if found then
                        KState.lastFoodSeenAt = os.clock()
                        break
                    end
                    task.wait(stepCfg[2])
                end
                if found then
                    PerformBlink(found) -- tái dùng cơ chế blink-ăn của bản gốc
                elseif os.clock() - KState.lastFoodSeenAt >= KAITUN_CONFIG.ANTISTUCK_NOFOOD then
                    -- #12 anti-stuck
                    _G.KaitunNotify("⛔ " .. KAITUN_CONFIG.ANTISTUCK_NOFOOD .. "s KHÔNG thấy food (500m) → về Hide Spot 1, chờ " .. KAITUN_CONFIG.ANTISTUCK_WAIT .. "s rồi thử lại", 5, "antistuck")
                    teleportTo(KAITUN_CONFIG.HIDE_SPOT_1)
                    KState.currentSpot = 1
                    KState.antistuckUntil = os.clock() + KAITUN_CONFIG.ANTISTUCK_WAIT
                    KState.lastFoodSeenAt = os.clock()
                end
            else
                KState.eating = false
                KState.lastFoodSeenAt = os.clock()
            end
        end
    end
end)

-- ═══════════ [KAITUN #11] VÒNG LẶP ẨN THÔNG MINH ═══════════
task.spawn(function()
    while true do
        task.wait(1)
        if _G.KaitunEnabled and not _G.KaitunSkyAnchored and os.clock() >= KState.antistuckUntil then
            local quest = _G.CurrentQuest -- #8: "None" | "Drink" | "Rest" (quest detection giữ nguyên)
            local hunger = getStatPercent("Hunger")
            local thirst = getStatPercent("Thirst")
            local hungerOk = (hunger == nil) or (hunger >= KAITUN_CONFIG.HIDE_HUNGER_MIN)
            local thirstOk = (thirst == nil) or (thirst >= KAITUN_CONFIG.HIDE_THIRST_MIN)
            local hideOk = quest == "None" and hungerOk and thirstOk and not KState.eating
            if hideOk then
                local hrp = getRoot()
                if hrp then
                    local key = SPOT_CYCLE[KState.currentSpot] or "HIDE1"
                    if key ~= "SKY" then
                        local pos = spotPosition(key)
                        if (hrp.Position - pos).Magnitude > 12 then
                            if isSpotSafe(pos, KAITUN_CONFIG.ENEMY_SCAN_RANGE) then
                                teleportTo(pos)
                            else
                                performSwitch("Chỗ ẩn hiện tại có địch")
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ═══════════ [KAITUN #6] DRINK — giữ nguyên spam remote 0.8s ═══════════
task.spawn(function()
    while true do
        task.wait(1)
        if _G.KaitunEnabled then
            KState.drinkDriven = true
            local thirst = getStatPercent("Thirst")
            if thirst == nil then
                _G.AutoDrinkRunning = true -- không đọc được → spam 0.8s liên tục như bản gốc
            else
                _G.AutoDrinkRunning = thirst < KAITUN_CONFIG.EAT_STOP_PERCENT
            end
        elseif KState.drinkDriven then
            KState.drinkDriven = false
            _G.AutoDrinkRunning = false
        end
    end
end)

-- ═══════════ [KAITUN #7] REST — <50% nghỉ, ≥95% dừng ═══════════
task.spawn(function()
    while true do
        task.wait(1)
        if _G.KaitunEnabled then
            local rest = getStatPercent("Rest")
            if rest then
                if rest < KAITUN_CONFIG.REST_START_PERCENT then
                    _G.KaitunRestActive = true
                elseif rest >= KAITUN_CONFIG.REST_STOP_PERCENT then
                    _G.KaitunRestActive = false
                end
            else
                _G.KaitunRestActive = false
            end
        else
            _G.KaitunRestActive = false
        end
    end
end)

-- ═══════════ [KAITUN #13] ĐÓI <10% → SHUTDOWN (LocalPlayer:Kick) ═══════════
task.spawn(function()
    while true do
        task.wait(2)
        if _G.KaitunEnabled then
            local hunger = getStatPercent("Hunger")
            if hunger and hunger < KAITUN_CONFIG.KICK_HUNGER then
                _G.KaitunNotify("☠ ĐÓI < " .. KAITUN_CONFIG.KICK_HUNGER .. "%! Tự động thoát game để bảo vệ...", 3, "kick")
                task.wait(1.5)
                pcall(function()
                    LocalPlayer:Kick("[Kaitun] Hunger < 10% → Auto shutdown để bảo vệ pet!")
                end)
            end
        end
    end
end)

-- ═══════════ [KAITUN #10] BẬT / TẮT ═══════════
function _G.KaitunSetEnabled(state)
    _G.KaitunEnabled = state == true
    local hrp = getRoot()
    if _G.KaitunEnabled then
        bumpGen()
        KState.currentSpot = 1
        KState.lastSwitchAt = os.clock()
        KState.lastFoodSeenAt = os.clock()
        KState.antistuckUntil = 0
        KState.eatActive = false
        -- #10: tele Hide Spot 1 NGAY LẬP TỨC
        if hrp then
            hrp.Anchored = false
            teleportTo(KAITUN_CONFIG.HIDE_SPOT_1)
        end
        if _G.KaitunFeedMode == "None" then
            _G.KaitunNotify("⚠ KAITUN BẬT nhưng Chế Độ Ăn = None! Quest label chuyển ĐỎ — hãy chọn Meat hoặc Herb!", 7, "warn")
        else
            _G.KaitunNotify("✅ Kaitun BẬT • Chế độ ăn: " .. tostring(_G.KaitunFeedMode) .. " • Đã tele về Hide Spot 1", 5, "status")
        end
    else
        bumpGen()
        _G.KaitunSkyAnchored = false
        _G.KaitunRestActive = false
        if hrp then hrp.Anchored = false end
        _G.KaitunNotify("⛔ Kaitun TẮT — đã gỡ neo & trả lại điều khiển", 4, "status")
    end
    if _G.KaitunUpdateStatus then _G.KaitunUpdateStatus() end
end

-- Respawn: quay lại chỗ trú hiện tại
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1.2)
    if _G.KaitunEnabled then
        KState.lastHealth = nil
        local key = SPOT_CYCLE[KState.currentSpot] or "HIDE1"
        if key ~= "SKY" and getRoot() then
            teleportTo(spotPosition(key))
        end
    end
end)

-- ═══════════ [KAITUN] KHỞI ĐỘNG ═══════════
_G.KaitunRestShould = function()
    return _G.KaitunRestActive == true
end

if false then
    _G.KaitunEnabled = true
    task.delay(2, function()
        if _G.KaitunSetEnabled and _G.KaitunEnabled then
            _G.KaitunSetEnabled(true) -- #10: bật từ đầu → tele Hide 1 ngay sau khi load
        end
    end)
end

if KAITUN_SKY_PROVIDED then
    _G.KaitunNotify("🐾 Kaitun Engine sẵn sàng • Cycle ẩn: Hide 1 → Hide 2 → Sky (#17)", 6, "status")
else
    _G.KaitunNotify("🐾 Kaitun Engine sẵn sàng • Sky Spot CHƯA có tọa độ (#22) → cycle 2 điểm Hide 1 ↔ Hide 2", 7, "status")
end

-- ═══════════ [KAITUN v2.2] BILLBOARD MARKER TẠI 3 ĐIỂM TRÚ ═══════════
-- Giúp bạn dễ xác minh tọa độ trong game (bay ngang là thấy cột mốc)
if KAITUN_SHOW_MARKERS then
    task.spawn(function()
        local markers = {
            { name = "KaitunMarker1", pos = KAITUN_CONFIG.HIDE_SPOT_1, label = "🐾 HIDE SPOT 1", color = Color3.fromRGB(0, 255, 130) },
            { name = "KaitunMarker2", pos = KAITUN_CONFIG.HIDE_SPOT_2, label = "🐾 HIDE SPOT 2", color = Color3.fromRGB(255, 190, 60) },
        }
        if KAITUN_SKY_PROVIDED then
            markers[#markers + 1] = { name = "KaitunMarkerSky", pos = KAITUN_CONFIG.SKY_SPOT, label = "🌤 SKY SPOT", color = Color3.fromRGB(120, 255, 230) }
        end
        for _, m in ipairs(markers) do
            pcall(function()
                local old = Workspace:FindFirstChild(m.name)
                if old then old:Destroy() end
                local part = Instance.new("Part")
                part.Name = m.name
                part.Anchored = true
                part.CanCollide = false
                part.Transparency = 1
                part.Size = Vector3.new(1, 1, 1)
                part.Position = m.pos
                part.Parent = Workspace
                local bb = Instance.new("BillboardGui")
                bb.Size = UDim2.new(0, 170, 0, 40)
                bb.StudsOffset = Vector3.new(0, 4, 0)
                bb.AlwaysOnTop = true
                bb.Parent = part
                local tl = Instance.new("TextLabel")
                tl.Size = UDim2.new(1, 0, 1, 0)
                tl.BackgroundTransparency = 1
                tl.Text = m.label
                tl.TextColor3 = m.color
                tl.TextStrokeTransparency = 0.2
                tl.Font = Enum.Font.GothamBold
                tl.TextSize = 14
                tl.Parent = bb
            end)
        end
    end)
end

-- ═══════════ [KAITUN v2.4] ESP FOOD — khoanh sáng đồ ăn gần bạn ═══════════
-- Tái dùng keyword STRICT_MEAT/HERB của bản gốc + bộ lọc entity/map decor của engine.
-- Quét 5s/lần trong bán kính KAITUN_ESP_RANGE (web-tunable v2.6), tối đa 25 mục — Highlight + Billboard khoảng cách.
if KAITUN_FOOD_ESP then
    task.spawn(function()
        local ESP_RADIUS, ESP_MAX, ESP_TICK = KAITUN_ESP_RANGE, 25, 5
        local tracked = {} -- [part] = { hl = Highlight, holder = Part, label = TextLabel }

        local function espKeywords()
            local mode = _G.KaitunFeedMode
            if mode == "Meat" then return EAT_CONFIG.STRICT_MEAT_KEYWORDS end
            if mode == "Herb" then return EAT_CONFIG.STRICT_HERB_KEYWORDS end
            local both = {}
            for _, k in ipairs(EAT_CONFIG.STRICT_MEAT_KEYWORDS) do both[#both + 1] = k end
            for _, k in ipairs(EAT_CONFIG.STRICT_HERB_KEYWORDS) do both[#both + 1] = k end
            return both
        end

        local function release(part)
            local t = tracked[part]
            if t then
                if t.hl then pcall(function() t.hl:Destroy() end) end
                if t.holder then pcall(function() t.holder:Destroy() end) end
                tracked[part] = nil
            end
        end

        while true do
            task.wait(ESP_TICK)
            local ok, err = pcall(function()
                local root = getRoot()
                local kws = espKeywords()
                -- 1) dọn các mục không còn hợp lệ (biến mất / quá xa / đổi mode)
                for part in pairs(tracked) do
                    local dead = part.Parent == nil
                    if not dead and root then
                        dead = (part.Position - root.Position).Magnitude > ESP_RADIUS + 100
                    end
                    if not dead then dead = not IsTargetNameMatch(part, kws) end
                    if dead then release(part) end
                end
                if not root then return end
                -- 2) quét thêm mục mới (gần nhất trước) nếu còn chỗ trống
                local count = 0
                for _ in pairs(tracked) do count = count + 1 end
                if count >= ESP_MAX then return end
                local okP, parts = pcall(function()
                    return Workspace:GetPartBoundsInRadius(root.Position, ESP_RADIUS, EatOverlapParams)
                end)
                if not okP or not parts then return end
                local candidates = {}
                for i = 1, #parts do
                    local part = parts[i]
                    if part:IsA("BasePart")
                        and not tracked[part]
                        and IsTargetNameMatch(part, kws)
                        and not IsLivingEntityOrMapDecor(part) then
                        local d = (part.Position - root.Position).Magnitude
                        candidates[#candidates + 1] = { part = part, dist = d }
                        if #candidates >= ESP_MAX then break end
                    end
                end
                table.sort(candidates, function(a, b) return a.dist < b.dist end)
                for _, c in ipairs(candidates) do
                    local n = 0
                    for _ in pairs(tracked) do n = n + 1 end
                    if n >= ESP_MAX then break end
                    if c.part.Parent and not tracked[c.part] then
                        local hl = Instance.new("Highlight")
                        hl.Name = "KaitunFoodHighlight"
                        hl.FillColor = Color3.fromRGB(255, 170, 40)
                        hl.OutlineColor = Color3.fromRGB(255, 220, 120)
                        hl.FillTransparency = 0.72
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Adornee = c.part
                        hl.Parent = c.part
                        local holder = Instance.new("Part")
                        holder.Name = "KaitunFoodESPLabel"
                        holder.Anchored = true
                        holder.CanCollide = false
                        holder.CanQuery = false
                        holder.Transparency = 1
                        holder.Size = Vector3.new(1, 1, 1)
                        holder.Position = c.part.Position + Vector3.new(0, 4, 0)
                        holder.Parent = Workspace
                        local bb = Instance.new("BillboardGui")
                        bb.Size = UDim2.new(0, 110, 0, 26)
                        bb.AlwaysOnTop = true
                        bb.Parent = holder
                        local tl = Instance.new("TextLabel")
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.Text = string.format("🍖 %dm", math.floor(c.dist + 0.5))
                        tl.TextColor3 = Color3.fromRGB(255, 200, 90)
                        tl.TextStrokeTransparency = 0.3
                        tl.Font = Enum.Font.GothamBold
                        tl.TextSize = 12
                        tl.Parent = bb
                        tracked[c.part] = { hl = hl, holder = holder, label = tl }
                    end
                end
            end)
            if not ok and err then
                _G.KaitunNotify("ESP food lỗi: " .. tostring(err):sub(1, 80), 3)
            end
        end
    end)
end

-- ═══════════ [KAITUN v2.4] PLAYER HUD — bảng chỉ số nhỏ góc màn hình ═══════════
-- Đói / Khát / Thể lực / địch gần nhất / số người chơi / đang trú đâu — kéo được, cập nhật 0.5s.
if KAITUN_PLAYER_HUD then
    task.spawn(function()
        pcall(function()
            local pg = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
            if not pg then return end
            local old = pg:FindFirstChild("KaitunHUD")
            if old then old:Destroy() end
            local gui = Instance.new("ScreenGui")
            gui.Name = "KaitunHUD"
            gui.ResetOnSpawn = false
            gui.DisplayOrder = 999
            gui.Parent = pg

            local frame = Instance.new("Frame")
            frame.Name = "Root"
            frame.AnchorPoint = Vector2.new(0, 1)
            frame.Position = UDim2.new(0, 14, 1, -14)
            frame.Size = UDim2.new(0, 196, 0, 172)
            frame.BackgroundColor3 = Color3.fromRGB(12, 14, 16)
            frame.BackgroundTransparency = 0.28
            frame.BorderSizePixel = 0
            frame.Active = true
            pcall(function() frame.Draggable = true end) -- kéo được (legacy nhưng mọi executor đều hỗ trợ)
            frame.Parent = gui

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = frame
            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(52, 211, 153)
            stroke.Transparency = 0.45
            stroke.Parent = frame

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -16, 0, 26)
            title.Position = UDim2.new(0, 8, 0, 4)
            title.BackgroundTransparency = 1
            title.Text = "🐾 KAITUN HUD"
            title.TextColor3 = Color3.fromRGB(52, 211, 153)
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Font = Enum.Font.GothamBold
            title.TextSize = 13
            title.Parent = frame

            local function mkRow(idx, defColor)
                local r = Instance.new("TextLabel")
                r.Size = UDim2.new(1, -16, 0, 22)
                r.Position = UDim2.new(0, 8, 0, 30 + (idx - 1) * 23)
                r.BackgroundTransparency = 1
                r.Text = "…"
                r.TextColor3 = defColor
                r.TextXAlignment = Enum.TextXAlignment.Left
                r.Font = Enum.Font.Gotham
                r.TextSize = 12
                r.Parent = frame
                return r
            end
            local rHunger = mkRow(1, Color3.fromRGB(110, 231, 183))
            local rThirst = mkRow(2, Color3.fromRGB(103, 232, 249))
            local rEnergy = mkRow(3, Color3.fromRGB(196, 181, 253))
            local rEnemy  = mkRow(4, Color3.fromRGB(253, 164, 175))
            local rPlayers = mkRow(5, Color3.fromRGB(253, 224, 71))
            local rSpot   = mkRow(6, Color3.fromRGB(161, 161, 170))

            local fmtPct = function(v)
                if v == nil then return "?" end
                return string.format("%d%%", math.floor(v + 0.5))
            end

            while gui.Parent do
                local hunger = getStatPercent("Hunger")
                local thirst = getStatPercent("Thirst")
                local energy = getStatPercent("Rest")
                local hrp = getRoot()
                local enemy = hrp and nearestEnemyDistance(hrp.Position, KAITUN_CONFIG.ENEMY_SCAN_RANGE) or nil
                rHunger.Text = string.format("🍖 Đói: %s", fmtPct(hunger))
                rThirst.Text = string.format("💧 Khát: %s", fmtPct(thirst))
                rEnergy.Text = string.format("😴 Thể lực: %s", fmtPct(energy))
                if enemy then
                    rEnemy.Text = string.format("⚔️ Địch gần nhất: %dm", math.floor(enemy + 0.5))
                    rEnemy.TextColor3 = Color3.fromRGB(253, 164, 175)
                else
                    rEnemy.Text = "⚔️ Địch gần nhất: an toàn"
                    rEnemy.TextColor3 = Color3.fromRGB(110, 231, 183)
                end
                rPlayers.Text = string.format("👥 Người chơi: %d", #Players:GetPlayers())
                local spotLabel = "đang đi ăn"
                if _G.KaitunSkyAnchored then
                    spotLabel = "🌤 Sky (đang neo)"
                elseif _G.KaitunEnabled then
                    spotLabel = spotName((SPOT_CYCLE[KState.currentSpot] or "HIDE1"))
                end
                rSpot.Text = string.format("🏠 %s • Kaitun %s", spotLabel, _G.KaitunEnabled and "ON" or "OFF")
                task.wait(0.5)
            end
        end)
    end)
end

-- ═══════════ [KAITUN v2.6] ANTI-AFK — chặn kick 20 phút không hoạt động ═══════════
-- Roblox kick AFK sau ~20 phút idle. Kaitun chạy session dài → phải giả lập input.
-- Idled fired khi client sắp idle → VirtualUser CaptureController + ClickButton2 = "người chơi vẫn ngồi đó".
if KAITUN_ANTI_AFK then
    task.spawn(function()
        pcall(function()
            if _G.KaitunAntiAfkHooked then return end
            _G.KaitunAntiAfkHooked = true
            local VirtualUser = game:GetService("VirtualUser")
            LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                _G.KaitunNotify("☕ Anti-AFK: đã giả lập hoạt động — không bị kick 20 phút", 3)
            end)
            _G.KaitunNotify("🛡️ Anti-AFK đã bật (v2.6)", 3)
        end)
    end)
end

-- ═══════════ [KAITUN v2.7] AUTO-HOP SERVER — server đông → nhảy server vắng ═══════════
-- Kaitun ON + số người chơi > HOP_PLAYER_MAX → hỏi Roblox servers API (tái dùng pattern
-- "Tìm Server Thấp" của Meizu Hub) → TeleportToPlaceInstance sang server ÍT NGƯỜI NHẤT.
-- v2.8: quét NHIỀU TRANG server qua cursor (HOP_MAX_PAGES) — nếu 100 server đầu đều đông
-- vẫn tìm thấy server vắng ở trang sau; thấy ứng viên ngay thì dừng quét sớm.
-- Sau hop, Self-cache (v2.6) tự chạy lại Kaitun trên server mới → session không đứt.
if KAITUN_AUTO_HOP then
    task.spawn(function()
        pcall(function()
            if _G.KaitunAutoHopHooked then return end
            _G.KaitunAutoHopHooked = true
            local HttpService = game:GetService("HttpService")
            local TeleportService = game:GetService("TeleportService")
            local lastHopCheck = 0

            local function fetchServerPage(cursor)
                local base = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/0?sortOrder=Asc&limit=" .. tostring(KAITUN_CONFIG.HOP_SERVER_LIMIT)
                if cursor and cursor ~= "" then
                    base = base .. "&cursor=" .. cursor
                end
                local ok, res = pcall(function()
                    return game:HttpGet(base)
                end)
                if not ok or type(res) ~= "string" then return nil, nil end
                local ok2, data = pcall(function() return HttpService:JSONDecode(res) end)
                if not ok2 or type(data) ~= "table" or type(data.data) ~= "table" then return nil, nil end
                return data.data, data.nextPageCursor
            end

            -- v2.8: gom ứng viên qua nhiều trang — dừng sớm khi đã thấy
            local function collectCandidates()
                local candidates = {}
                local cursor = nil
                local scanned = 0
                for _ = 1, KAITUN_CONFIG.HOP_MAX_PAGES do
                    local page, nextCursor = fetchServerPage(cursor)
                    if not page then break end
                    scanned = scanned + #page
                    for _, s in ipairs(page) do
                        if type(s.id) == "string" and type(s.playing) == "number" and type(s.maxPlayers) == "number" then
                            if s.id ~= game.JobId and s.playing > 0 and s.playing < KAITUN_CONFIG.HOP_PLAYER_MAX and s.playing < s.maxPlayers then
                                table.insert(candidates, s)
                            end
                        end
                    end
                    if #candidates > 0 then break end -- thấy rồi → không cần quét trang sau
                    if not nextCursor or nextCursor == "" then break end -- hết dữ liệu
                    cursor = nextCursor
                end
                return candidates, scanned
            end

            while true do
                task.wait(10)
                if _G.KaitunEnabled and os.clock() - lastHopCheck >= KAITUN_CONFIG.HOP_CHECK_INTERVAL then
                    lastHopCheck = os.clock()
                    local playerCount = #Players:GetPlayers()
                    if playerCount > KAITUN_CONFIG.HOP_PLAYER_MAX then
                        local candidates, scanned = collectCandidates()
                        if #candidates > 0 then
                            table.sort(candidates, function(a, b) return a.playing < b.playing end)
                            local pick = candidates[1]
                            _G.KaitunNotify(string.format("🛰️ Server đông (%d người) — Auto-Hop sang server %d người (quét %d server)…", playerCount, pick.playing, scanned), 6)
                            task.delay(2, function()
                                pcall(function()
                                    TeleportService:TeleportToPlaceInstance(game.PlaceId, pick.id, LocalPlayer)
                                end)
                            end)
                            break -- teleport xong → self-cache tự chạy lại script
                        else
                            _G.KaitunNotify(string.format("🛰️ Server đông nhưng %d server đã quét đều vắng/không hợp lệ — chờ lần sau", scanned), 4)
                        end
                    end
                end
            end
        end)
    end)
end

-- ═══════════ [KAITUN v2.6] AUTO REJOIN — rớta/teleport lỗi → tự vào lại server ═══════════
-- TeleportInitFailed → chờ 5s rồi Teleport(game.PlaceId) thử lại (tối đa 5 lần).
-- Phần TỰ CHẠY LẠI script sau teleport nằm ở khối SELF-CACHE cuối file (generator chèn).
if KAITUN_AUTO_REJOIN then
    task.spawn(function()
        pcall(function()
            if _G.KaitunAutoRejoinHooked then return end
            _G.KaitunAutoRejoinHooked = true
            local TeleportService = game:GetService("TeleportService")
            local retries = 0
            TeleportService.TeleportInitFailed:Connect(function(_player, result, _message)
                retries = retries + 1
                if retries > 5 then return end
                _G.KaitunNotify(string.format("🔄 Teleport lỗi (%s) — thử lại lần %d/5 sau 5s…", tostring(result), retries), 5)
                task.delay(5, function()
                    pcall(function()
                        TeleportService:Teleport(game.PlaceId, LocalPlayer)
                    end)
                end)
            end)
        end)
    end)
end

----------------------------------------------------
-- LOADER FINAL — chỉ đóng HUD khi mọi thứ đã sẵn sàng
----------------------------------------------------
LoaderStage(8)
LoaderStage(9)

LoaderComplete = true

-- Loader vẫn là lớp trên cùng cho tới khi animation kết thúc.
-- Meizu Window đã được dựng hoàn chỉnh và vẫn đang đóng trong giai đoạn này.
LoaderTween(LoaderTitle, 0.22, {TextTransparency = 1})
LoaderTween(ProgressBG, 0.22, {BackgroundTransparency = 1})
LoaderTween(ProgressBar, 0.22, {BackgroundTransparency = 1})
LoaderTween(StepLabel, 0.22, {TextTransparency = 1})
LoaderTween(PercentLabel, 0.22, {TextTransparency = 1})

local closeTween = LoaderTween(LoaderFrame, 0.25, {Size = UDim2.new(0, 0, 0, 0)})
closeTween.Completed:Wait()
if LoaderGui and LoaderGui.Parent then
    LoaderGui:Destroy()
end

-- Chỉ bây giờ mới cho Meizu UI xuất hiện.
-- Main/controls đã được dựng đầy đủ từ trước nên không có hiện tượng menu load từng phần.
Window:Toggle(true)

pcall(function()
    MeizuLibrary:Notify({
        Title = "Meizu Hub",
        Content = "Loading Succesfully!",
        Duration = 4,
    })
end)
]=])
                end)
        end
        if typeof(queue_on_teleport) == "function" then
                pcall(function()
                        queue_on_teleport([[
                                task.delay(6, function()
                                        pcall(function()
                                                if (isfile and isfile("KAITUN_V212_AUTOEXEC.lua")) or typeof(readfile) == "function" then
                                                        loadstring(readfile("KAITUN_V212_AUTOEXEC.lua"))()
                                                end
                                        end)
                                end)
                        ]])
                        if _G.KaitunNotify then _G.KaitunNotify("♻️ Auto-rejoin ON: sau teleport script tự chạy lại (v2.6)", 4) end
                end)
        end
end
