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
    Text = "Meizu Hub",
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

----------------------------------------------------
-- AUTO NUÔI (KAITUN) — STATE & CONFIG
----------------------------------------------------
_G.AutoNuoiKaitun = false
_G.KaitunDiet = "None"

local KaitunState = {
    Diet = "None",
    Enabled = false,
    CurrentSpot = nil,        -- "1" | "2" | "sky" | nil
    SkyStartTime = 0,
    LastSwitchTime = 0,
    LastHP = 100,
    LastActualAttack = 0,
    NoFoodSince = 0,
    UnsafeSince = 0,
    IsEating = false,
}

local KAITUN_CONFIG = {
    HUNGER_START = 0.50,      -- < 50% bắt đầu ăn
    HUNGER_STOP  = 0.95,      -- >= 95% dừng ăn
    STAMINA_START = 0.50,
    STAMINA_STOP  = 0.95,
    SCAN_RADII     = {100, 200, 300, 500},
    SCAN_COOLDOWNS = {0.3, 0.5, 1.0, 1.0},
    HIDE_SPOTS = {
        ["1"]   = Vector3.new(-965.171, 114.720, -418.536),
        ["2"]   = Vector3.new(-589.342, 93.005, -1322.879),
        ["sky"] = Vector3.new(127.360, 2683.926, -1478.516),
    },
    SKY_DURATION       = 60,   -- giây ở sky spot
    SWITCH_COOLDOWN    = 15,   -- giây giữa các lần switch
    BLEED_TOLERANCE    = 8,    -- giây sau cắn → bleed, không switch
    UNSAFE_FAILSAFE    = 30,   -- giây không switch được → force sky
    ENEMY_SCAN_RADIUS  = 150,  -- check spot safe
    ENEMY_ATTACK_RADIUS = 50,  -- check attack thật
    HP_DROP_THRESHOLD  = 2,    -- mất > 2 HP / 0.5s = bị damage
    CRITICAL_HUNGER    = 0.10, -- < 10% → shutdown game
    NO_FOOD_TIMEOUT    = 30,   -- giây không thấy food → anti-stuck
    NO_FOOD_RETRY_DELAY = 10,  -- giây chờ sau anti-stuck
    HIDE_HUNGER_MIN    = 0.80, -- >= 80% mới được hide
    HIDE_THIRST_MIN    = 0.80,
}

-- Forward declarations (gán sau, dùng trong UI callbacks)
local KaitunStatusLabel
local SetKaitunStatus
local TeleportToHideSpot, StartSkyMode, StopSkyMode, IsSpotSafe, TrySwitchSpot
local GetStatValue, ScanEnemyNear, ScanNearbyTargetAtRadius, KaitunCleanup

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

SetKaitunStatus = function(text, color)
    SetParagraphContent(KaitunStatusLabel, text, color)
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
-- AUTO NUÔI (KAITUN) — HELPER FUNCTIONS
----------------------------------------------------

-- Cache thanh stat để không scan PlayerGui mỗi cycle
local StatBarCache = {}

local function FindBarByName(root, keyword)
    for _, obj in pairs(root:GetDescendants()) do
        if obj:IsA("Frame") then
            local name = string.lower(obj.Name)
            if name:find(keyword, 1, true) then
                return obj
            end
        end
    end
    return nil
end

local function ReadBarRatio(barFrame)
    if not barFrame then return nil end
    local fill = barFrame:FindFirstChild("Fill")
        or barFrame:FindFirstChild("Bar")
        or barFrame:FindFirstChild("FillBar")
        or barFrame:FindFirstChild("Content")

    if not fill then
        for _, child in pairs(barFrame:GetChildren()) do
            if child:IsA("Frame") then
                fill = child
                break
            end
        end
    end
    if not fill then return nil end

    local sx = fill.Size.X.Scale
    local sy = fill.Size.Y.Scale
    -- Thanh ngang: dùng X.Scale. Thanh dọc: dùng 1 - Y.Scale (fill từ dưới lên)
    if sx > 0 and sx <= 1 then return sx end
    if sy > 0 and sy <= 1 then return 1 - sy end
    return nil
end

-- Đọc giá trị thanh stat (hunger/thirst/stamina) từ PlayerGui
-- Trả về 0.0 - 1.0, hoặc nil nếu không đọc được
GetStatValue = function(statName)
    -- Cache hit
    if StatBarCache[statName] then
        local bar = StatBarCache[statName]
        if bar and bar.Parent then
            return ReadBarRatio(bar)
        end
    end

    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return nil end

    local keywords = {
        hunger  = {"hunger", "food", "meat"},
        thirst  = {"thirst", "water", "drink"},
        stamina = {"stamina", "energy", "rest"},
    }
    local kwList = keywords[statName]
    if not kwList then return nil end

    for _, kw in ipairs(kwList) do
        local bar = FindBarByName(playerGui, kw)
        if bar then
            StatBarCache[statName] = bar
            return ReadBarRatio(bar)
        end
    end
    return nil
end

-- Quét địch (player + NPC creature) trong bán kính quanh vị trí
-- Trả về: hasEnemy (bool), enemyType (string)
ScanEnemyNear = function(position, radius)
    local radiusSq = radius * radius

    -- Check players
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local delta = hrp.Position - position
                if delta.X * delta.X + delta.Y * delta.Y + delta.Z * delta.Z <= radiusSq then
                    return true, "player:" .. player.Name
                end
            end
        end
    end

    -- Check NPC creatures via spatial query
    local params = OverlapParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local char = LocalPlayer.Character
    if char then params.FilterDescendantsInstances = {char} end

    local parts = Workspace:GetPartBoundsInRadius(position, radius, params)
    for _, part in ipairs(parts) do
        local model = part:FindFirstAncestorOfClass("Model")
        if model and not Players:GetPlayerFromCharacter(model) then
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local delta = part.Position - position
                if delta.X * delta.X + delta.Y * delta.Y + delta.Z * delta.Z <= radiusSq then
                    return true, "creature:" .. model.Name
                end
            end
        end
    end
    return false, nil
end

-- Check hide spot có safe không (không có địch trong 150m)
IsSpotSafe = function(spotName)
    local pos = KAITUN_CONFIG.HIDE_SPOTS[spotName]
    if not pos then return false end
    if spotName == "sky" then return true end
    local hasEnemy = ScanEnemyNear(pos, KAITUN_CONFIG.ENEMY_SCAN_RADIUS)
    return not hasEnemy
end

-- Teleport an toàn tới vị trí (reset velocity, multi-set)
local function TeleportToPosition(position)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        local targetCF = CFrame.new(position)
        for _ = 1, 3 do
            hrp.CFrame = targetCF
            task.wait(0.03)
        end
    end)
    return true
end

-- Sky mode state (riêng biệt với fly system của Misc tab)
local skyAtt, skyLV, skyAG, skyRenderConn

StopSkyMode = function()
    if skyRenderConn then pcall(function() skyRenderConn:Disconnect() end) skyRenderConn = nil end
    if skyLV then pcall(function() skyLV:Destroy() end) skyLV = nil end
    if skyAG then pcall(function() skyAG:Destroy() end) skyAG = nil end
    if skyAtt then pcall(function() skyAtt:Destroy() end) skyAtt = nil end
end

-- Sky mode: teleport lên sky spot + giữ yên bằng LinearVelocity (giống startFly)
StartSkyMode = function()
    StopSkyMode()

    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end

    -- Teleport lên sky spot
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.CFrame = CFrame.new(KAITUN_CONFIG.HIDE_SPOTS.sky)
    end)

    -- Tạo fly hold (giữ yên, velocity = 0)
    skyAtt = Instance.new("Attachment", hrp)

    skyLV = Instance.new("LinearVelocity")
    skyLV.Attachment0 = skyAtt
    skyLV.MaxForce = math.huge
    skyLV.VectorVelocity = Vector3.new(0, 0, 0)
    skyLV.Parent = hrp

    skyAG = Instance.new("AlignOrientation")
    skyAG.Attachment0 = skyAtt
    skyAG.MaxTorque = math.huge
    skyAG.Responsiveness = 200
    skyAG.Parent = hrp

    skyRenderConn = RunService.RenderStepped:Connect(function()
        local currentChar = LocalPlayer.Character
        local currentHRP = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        local humanoid = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

        if not currentChar or not currentChar.Parent or not currentHRP
           or not humanoid or humanoid.Health <= 0 then
            StopSkyMode()
            return
        end

        -- Giữ velocity = 0 (chống rơi)
        if skyLV then skyLV.VectorVelocity = Vector3.new(0, 0, 0) end

        -- Re-center nếu drift quá 3 studs
        local delta = KAITUN_CONFIG.HIDE_SPOTS.sky - currentHRP.Position
        if delta.Magnitude > 3 then
            currentHRP.CFrame = CFrame.new(KAITUN_CONFIG.HIDE_SPOTS.sky)
        end
    end)
end

-- Teleport tới hide spot (1, 2, hoặc sky)
TeleportToHideSpot = function(spotName)
    local pos = KAITUN_CONFIG.HIDE_SPOTS[spotName]
    if not pos then return false end

    if spotName == "sky" then
        StartSkyMode()
        KaitunState.SkyStartTime = os.clock()
    else
        StopSkyMode()
        TeleportToPosition(pos)
    end

    KaitunState.CurrentSpot = spotName
    KaitunState.LastSwitchTime = os.clock()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    KaitunState.LastHP = (hum and hum.Health) or 100
    return true
end

-- Switch spot theo cycle: 1 → 2 → sky → 1 → 2 → sky → ...
TrySwitchSpot = function(reason)
    local now = os.clock()
    if (now - KaitunState.LastSwitchTime) < KAITUN_CONFIG.SWITCH_COOLDOWN then
        return false
    end

    local current = KaitunState.CurrentSpot
    local nextSpot

    if current == "1" then
        if IsSpotSafe("2") then
            nextSpot = "2"
        else
            nextSpot = "sky"
        end
    elseif current == "2" then
        nextSpot = "sky"
    else  -- sky or nil
        if IsSpotSafe("1") then
            nextSpot = "1"
        elseif IsSpotSafe("2") then
            nextSpot = "2"
        else
            return false  -- Cả 2 unsafe, ở lại sky
        end
    end

    if nextSpot then
        if SetKaitunStatus then
            SetKaitunStatus(string.format("⚡ Switch %s → %s (%s)",
                tostring(current), nextSpot, reason or "attack"),
                Color3.fromRGB(255, 200, 50))
        end
        TeleportToHideSpot(nextSpot)
        return true
    end
    return false
end

-- Cleanup khi tắt Kaitun
KaitunCleanup = function()
    StopSkyMode()
    KaitunState.CurrentSpot = nil
    KaitunState.NoFoodSince = 0
    KaitunState.UnsafeSince = 0
    KaitunState.IsEating = false
    local restRemote = ReplicatedStorage:FindFirstChild("Remotes")
    if restRemote and restRemote:FindFirstChild("Character") and restRemote.Character:FindFirstChild("Rest") then
        pcall(function() restRemote.Character.Rest:InvokeServer(false) end)
    end
end

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

----------------------------------------------------
-- TAB FOSSILS — AUTO NUÔI (KAITUN)
----------------------------------------------------
FossilsTab:CreateSection("Auto Nuôi (Kaitun)")

KaitunStatusLabel = CreateParagraph(FossilsTab, {
    Title = "Trạng thái Auto Nuôi",
    Content = "Đang chờ...",
}, 70)

FossilsTab:CreateDropdown({
    Title = "Chế độ ăn",
    Description = "Chọn Meat hoặc Herb. None = Kaitun đứng chờ.",
    Values = {"None", "Meat", "Herb"},
    Default = "None",
    Callback = function(value)
        KaitunState.Diet = value
        _G.KaitunDiet = value
        if KaitunState.Enabled and SetKaitunStatus then
            if value == "None" then
                SetKaitunStatus("⚠ Chưa chọn chế độ ăn — Kaitun đang chờ", Color3.fromRGB(255, 80, 80))
            else
                SetKaitunStatus(string.format("✓ Diet: %s", value), Color3.fromRGB(80, 255, 80))
            end
        end
    end,
})

FossilsTab:CreateToggle({
    Title = "Auto Nuôi (Kaitun)",
    Description = "Master switch — tự ẩn + ăn + uống + nghỉ thông minh",
    Default = false,
    Callback = function(state)
        _G.AutoNuoiKaitun = state
        KaitunState.Enabled = state

        if state then
            -- Bật Kaitun: kích hoạt Auto Drink + Auto Rest hiện có
            _G.AutoDrinkRunning = true
            _G.AutoRestRunning = true

            task.spawn(function()
                task.wait(0.5)
                if not KaitunState.Enabled then return end
                if KaitunState.Diet == "None" then
                    if SetKaitunStatus then
                        SetKaitunStatus("⚠ Chưa chọn chế độ ăn — Kaitun đang chờ", Color3.fromRGB(255, 80, 80))
                    end
                else
                    -- Tele ngay về hide spot 1
                    TeleportToHideSpot("1")
                    if SetKaitunStatus then
                        SetKaitunStatus(string.format("✓ Kaitun ON — Diet: %s — Đã tele hide spot 1", KaitunState.Diet), Color3.fromRGB(80, 255, 80))
                    end
                end
            end)
        else
            -- Tắt Kaitun: dừng mọi thứ
            _G.AutoDrinkRunning = false
            _G.AutoRestRunning = false
            KaitunCleanup()
            if SetKaitunStatus then
                SetKaitunStatus("✗ Kaitun OFF", Color3.fromRGB(150, 150, 150))
            end
        end
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

        if root.Parent then
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

----------------------------------------------------
-- AUTO NUÔI — SCAN NEARBY TARGET AT RADIUS
-- Dùng cho Kaitun smart eat (100/200/300/500m escalation)
----------------------------------------------------
ScanNearbyTargetAtRadius = function(keywords, radius)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local best = nil
    local bestDistanceSq = radius * radius
    local parts = Workspace:GetPartBoundsInRadius(root.Position, radius, EatOverlapParams)
    local checked = 0
    local maxCheck = EAT_CONFIG.MAX_TARGETS_CHECKED or 222

    for i = 1, #parts do
        if checked >= maxCheck then break end
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
            
            if KaitunState.Enabled and KaitunState.Diet == "None" then
                SetQuestStatus("⚠ Chưa chọn chế độ ăn (Meat/Herb)", Color3.fromRGB(255, 80, 80))
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
        local shouldRest = _G.AutoRestRunning and (_G.CurrentQuest == "Rest")
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
-- AUTO NUÔI (KAITUN) — RUNTIME WORKERS
----------------------------------------------------

-- Character respawn handler: re-teleport về hide spot 1
LocalPlayer.CharacterAdded:Connect(function()
    if KaitunState.Enabled and KaitunState.Diet ~= "None" then
        task.wait(1.5)
        if KaitunState.Enabled then
            StopSkyMode()
            KaitunState.CurrentSpot = nil
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            KaitunState.LastHP = (hum and hum.Health) or 100
            TeleportToHideSpot("1")
            if SetKaitunStatus then
                SetKaitunStatus("🔄 Respawn → tele hide spot 1", Color3.fromRGB(80, 200, 255))
            end
        end
    end
end)

-- WORKER 1: Smart Eat (Meat/Herb) — escalation 100/200/300/500m
task.spawn(function()
    while true do
        task.wait(0.5)
        if not KaitunState.Enabled then goto continue end
        if KaitunState.Diet == "None" then goto continue end
        if KaitunState.CurrentSpot == "sky" then goto continue end
        if KaitunState.IsEating then goto continue end
        if _G.AutoEatActive or _G.AutoHerbActive then goto continue end
        if IsExecutingEatOrHerb then goto continue end

        local hunger = GetStatValue("hunger")
        -- Nếu không đọc được hunger → fallback: giả định đói
        if hunger == nil then hunger = 0.4 end

        -- Critical hunger → shutdown game
        if hunger < KAITUN_CONFIG.CRITICAL_HUNGER then
            if SetKaitunStatus then
                SetKaitunStatus("⚠ HUNGER CRITICAL (<10%) — SHUTDOWN GAME!", Color3.fromRGB(255, 50, 50))
            end
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Auto Nuôi — CRITICAL";
                    Text = "Hunger < 10%, shutting down game để bảo toàn progress.";
                    Duration = 5;
                })
            end)
            task.wait(2)
            pcall(function()
                LocalPlayer:Kick("Auto Nuôi: Hunger critical (<10%). Shutdown để bảo toàn progress.")
            end)
            return
        end

        -- Nếu hunger >= stop threshold → không ăn
        if hunger >= KAITUN_CONFIG.HUNGER_STOP then
            if KaitunState.NoFoodSince ~= 0 then
                KaitunState.NoFoodSince = 0
            end
            goto continue
        end

        -- Nếu hunger < start threshold → cần ăn
        if hunger < KAITUN_CONFIG.HUNGER_START or KaitunState.NoFoodSince ~= 0 then
            local keywords = (KaitunState.Diet == "Meat")
                and EAT_CONFIG.STRICT_MEAT_KEYWORDS
                or EAT_CONFIG.STRICT_HERB_KEYWORDS

            local target = nil
            local radiusUsed = 0

            -- Escalation: 100m → 200m → 300m → 500m
            for i, radius in ipairs(KAITUN_CONFIG.SCAN_RADII) do
                if not KaitunState.Enabled then break end
                target = ScanNearbyTargetAtRadius(keywords, radius)
                if target then
                    radiusUsed = radius
                    break
                end
                task.wait(KAITUN_CONFIG.SCAN_COOLDOWNS[i] or 0.5)
            end

            if target then
                KaitunState.NoFoodSince = 0
                KaitunState.IsEating = true
                if SetKaitunStatus then
                    SetKaitunStatus(string.format("🍽 Đang ăn %s (tìm thấy %dm)...",
                        KaitunState.Diet, radiusUsed), Color3.fromRGB(100, 255, 100))
                end
                -- Dùng PerformBlink có sẵn (save CFrame → blink → eat → return)
                PerformBlink(target)
                KaitunState.IsEating = false
                task.wait(0.3)
            else
                -- Không tìm thấy food trong 500m
                if KaitunState.NoFoodSince == 0 then
                    KaitunState.NoFoodSince = os.clock()
                end

                local elapsed = os.clock() - KaitunState.NoFoodSince
                if elapsed > KAITUN_CONFIG.NO_FOOD_TIMEOUT then
                    -- Anti-stuck: tele hide spot 1, chờ 10s
                    if SetKaitunStatus then
                        SetKaitunStatus(string.format("⚠ Không thấy food %ds → tele hide spot 1 chờ %ds",
                            math.floor(elapsed), KAITUN_CONFIG.NO_FOOD_RETRY_DELAY),
                            Color3.fromRGB(255, 200, 50))
                    end
                    TeleportToHideSpot("1")
                    task.wait(KAITUN_CONFIG.NO_FOOD_RETRY_DELAY)
                    KaitunState.NoFoodSince = 0
                else
                    if SetKaitunStatus then
                        SetKaitunStatus(string.format("🔍 Không thấy food 500m (chờ %ds)...",
                            math.ceil(KAITUN_CONFIG.NO_FOOD_TIMEOUT - elapsed)),
                            Color3.fromRGB(255, 200, 50))
                    end
                end
            end
        end

        ::continue::
    end
end)

-- WORKER 2: Smart Rest — dựa trên stamina thực (không phụ thuộc quest)
task.spawn(function()
    local restRemote = ReplicatedStorage:WaitForChild("Remotes").Character.Rest
    local isRestingActive = false
    while true do
        task.wait(0.5)
        if not KaitunState.Enabled then
            if isRestingActive then
                pcall(function() restRemote:InvokeServer(false) end)
                isRestingActive = false
            end
            goto continue
        end

        local stamina = GetStatValue("stamina")
        if stamina == nil then goto continue end

        if stamina < KAITUN_CONFIG.STAMINA_START and not isRestingActive then
            pcall(function() restRemote:InvokeServer(true) end)
            isRestingActive = true
        elseif stamina >= KAITUN_CONFIG.STAMINA_STOP and isRestingActive then
            pcall(function() restRemote:InvokeServer(false) end)
            isRestingActive = false
        end

        ::continue::
    end
end)

-- WORKER 3: Hide Spot Monitor — attack detection + switch + sky timeout
task.spawn(function()
    while true do
        task.wait(0.5)
        if not KaitunState.Enabled then goto continue end
        if KaitunState.Diet == "None" then goto continue end

        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then goto continue end

        local now = os.clock()
        local currentHP = hum.Health

        -- SKY MODE: kiểm tra timeout 60s
        if KaitunState.CurrentSpot == "sky" then
            if (now - KaitunState.SkyStartTime) >= KAITUN_CONFIG.SKY_DURATION then
                if IsSpotSafe("1") then
                    if SetKaitunStatus then
                        SetKaitunStatus("🛬 Hết 60s sky → trở về spot 1", Color3.fromRGB(100, 255, 100))
                    end
                    TeleportToHideSpot("1")
                elseif IsSpotSafe("2") then
                    if SetKaitunStatus then
                        SetKaitunStatus("🛬 Hết 60s sky → spot 1 unsafe → spot 2", Color3.fromRGB(100, 255, 100))
                    end
                    TeleportToHideSpot("2")
                else
                    -- Cả 2 unsafe → ở sky thêm 60s
                    KaitunState.SkyStartTime = now
                    if SetKaitunStatus then
                        SetKaitunStatus("🛬 Cả 2 spot unsafe → ở sky thêm 60s", Color3.fromRGB(255, 200, 50))
                    end
                end
            end
            KaitunState.LastHP = currentHP
            goto continue
        end

        -- DETECT HP DROP
        local hpDrop = KaitunState.LastHP - currentHP
        if hpDrop >= KAITUN_CONFIG.HP_DROP_THRESHOLD then
            local hasEnemy, enemyType = ScanEnemyNear(hrp.Position, KAITUN_CONFIG.ENEMY_ATTACK_RADIUS)

            if hasEnemy then
                -- ATTACK THẬT → switch spot
                KaitunState.LastActualAttack = now
                if SetKaitunStatus then
                    SetKaitunStatus(string.format("⚔ Bị %s attack! Đang switch...",
                        enemyType or "enemy"), Color3.fromRGB(255, 80, 80))
                end
                local switched = TrySwitchSpot("attack by " .. (enemyType or "?"))
                if not switched then
                    if KaitunState.UnsafeSince == 0 then
                        KaitunState.UnsafeSince = now
                    end
                    if (now - KaitunState.UnsafeSince) >= KAITUN_CONFIG.UNSAFE_FAILSAFE then
                        -- Failsafe: 30s không switch được → force sky
                        if SetKaitunStatus then
                            SetKaitunStatus("⚠ 30s không switch được → FORCE SKY", Color3.fromRGB(255, 50, 50))
                        end
                        TeleportToHideSpot("sky")
                        KaitunState.UnsafeSince = 0
                    end
                else
                    KaitunState.UnsafeSince = 0
                end
            else
                -- BLEED EFFECT → không switch, chỉ notify
                if (now - KaitunState.LastActualAttack) > KAITUN_CONFIG.BLEED_TOLERANCE then
                    if SetKaitunStatus then
                        SetKaitunStatus(string.format("🩸 Bleed effect (HP -%d, no enemy) — đang chờ heal...",
                            math.floor(hpDrop)), Color3.fromRGB(255, 180, 80))
                    end
                end
            end
        else
            -- Không mất máu → reset unsafe timer
            if KaitunState.UnsafeSince ~= 0 and (now - KaitunState.LastActualAttack) > 5 then
                KaitunState.UnsafeSince = 0
            end
        end

        KaitunState.LastHP = currentHP

        -- RETURN TO HIDE: nếu pet không ở hide spot nào + đủ điều kiện → tele về
        if KaitunState.CurrentSpot ~= "1" and KaitunState.CurrentSpot ~= "2"
           and KaitunState.CurrentSpot ~= "sky" then
            local hunger = GetStatValue("hunger") or 1
            local thirst = GetStatValue("thirst") or 1
            if hunger >= KAITUN_CONFIG.HIDE_HUNGER_MIN and thirst >= KAITUN_CONFIG.HIDE_THIRST_MIN then
                if IsSpotSafe("1") then
                    TeleportToHideSpot("1")
                    if SetKaitunStatus then
                        SetKaitunStatus("🏠 Đủ điều kiện → trở về hide spot 1", Color3.fromRGB(100, 255, 100))
                    end
                end
            end
        end

        ::continue::
    end
end)

-- WORKER 4: Kaitun Status Display — cập nhật định kỳ
task.spawn(function()
    while true do
        task.wait(2)
        if not KaitunState.Enabled then goto continue end

        local hunger  = GetStatValue("hunger")
        local thirst  = GetStatValue("thirst")
        local stamina = GetStatValue("stamina")

        local hungerStr  = hunger  and string.format("%.0f%%", hunger * 100)  or "?"
        local thirstStr  = thirst  and string.format("%.0f%%", thirst * 100)  or "?"
        local staminaStr = stamina and string.format("%.0f%%", stamina * 100) or "?"

        local spotStr = KaitunState.CurrentSpot or "—"
        local dietStr = KaitunState.Diet

        if KaitunState.Diet == "None" then
            if SetKaitunStatus then
                SetKaitunStatus("⚠ Chưa chọn chế độ ăn (Meat/Herb) — Kaitun đang chờ", Color3.fromRGB(255, 80, 80))
            end
        elseif KaitunState.CurrentSpot == "sky" then
            local remaining = KAITUN_CONFIG.SKY_DURATION - (os.clock() - KaitunState.SkyStartTime)
            if SetKaitunStatus then
                SetKaitunStatus(string.format("🚀 Sky mode — còn %ds | H:%s T:%s S:%s | Diet:%s",
                    math.max(0, math.ceil(remaining)), hungerStr, thirstStr, staminaStr, dietStr),
                    Color3.fromRGB(150, 200, 255))
            end
        else
            if SetKaitunStatus then
                SetKaitunStatus(string.format("🏠 Spot %s | H:%s T:%s S:%s | Diet:%s | Quest:%s",
                    spotStr, hungerStr, thirstStr, staminaStr, dietStr, tostring(_G.CurrentQuest)),
                    Color3.fromRGB(200, 200, 200))
            end
        end

        ::continue::
    end
end)

----------------------------------------------------


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
