-- Primeval Earth Hub
-- UI layer: MeizuLibrary
-- Core logic: giữ nguyên từ UpdatePrimeval gốc, chỉ thay lớp giao diện.

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

----------------------------------------------------
-- 3. LOGIC ESP, AIMBOT, AUTO ATTACK & AUTO NHẶT ĐẠN
----------------------------------------------------

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
    Title = "Primeval Earth Hub",
    SubTitle = "UpdatePrimeval • MeizuLibrary",
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

local MovementTab = Window:CreateTab("Di Chuyen", nil, 1)
local TeleportTab = Window:CreateTab("Dich Chuyen", nil, 2)
local EspTab = Window:CreateTab("Nhin Xuyen", nil, 3)
local PvpTab = Window:CreateTab("PVP", nil, 4)
local FossilsTab = Window:CreateTab("Fossils", nil, 5)
local VisualsTab = Window:CreateTab("Cai Dat", nil, 6)
LoaderStage(6)

----------------------------------------------------
-- TAB DI CHUYEN
----------------------------------------------------
MovementTab:CreateSection("Movement")
MovementTab:CreateSlider({
    Title = "Toc Do Di Chuyen",
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
    Title = "Suc Nhay (Jump Power)",
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
    Title = "Bat/Tat Fly (Bay)",
    Default = false,
    Callback = function(state)
        if state then startFly() else stopFly() end
    end,
})
MovementTab:CreateSlider({
    Title = "Toc Do Fly (Speed)",
    Description = "Fly speed",
    Min = 10, Max = 150, Default = 50,
    Callback = function(value) flySpeed = value end,
})
MovementTab:CreateToggle({
    Title = "Xuyen Tuong (Noclip)",
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
CreateParagraph(MovementTab, {
    Title = "Thong tin",
    Content = "Toc do di chuyen, Jump Power, Fly va Noclip.",
}, 58)

----------------------------------------------------
-- TAB TELEPORT
----------------------------------------------------
TeleportTab:CreateSection("Teleport nguoi choi")
CreateParagraph(TeleportTab, {
    Title = "Danh sach nguoi choi",
    Content = "Chon nguoi choi ben duoi de dich chuyen. Danh sach tu refresh khi nguoi choi vao/rời server.",
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
EspTab:CreateToggle({Title="Bat ESP Tong", Default=EspSettings.Enabled, Callback=function(v) EspSettings.Enabled=v end})
EspTab:CreateToggle({Title="Hien Ten Nguoi Choi", Default=EspSettings.ShowName, Callback=function(v) EspSettings.ShowName=v end})
EspTab:CreateToggle({Title="Hien Thanh Mau (HP)", Default=EspSettings.ShowHealth, Callback=function(v) EspSettings.ShowHealth=v end})
EspTab:CreateToggle({Title="Hien Khoang Cach (m)", Default=EspSettings.ShowDistance, Callback=function(v) EspSettings.ShowDistance=v end})

----------------------------------------------------
-- TAB PVP
----------------------------------------------------
PvpTab:CreateSection("Aim / FOV")
PvpTab:CreateToggle({
    Title="Bat Auto Attack (Chi Bắn Khi FOV Đỏ)", Default=false,
    Callback=function(state) _G.AutoAttackRunning=state end,
})
PvpTab:CreateToggle({
    Title="Bat Aimbot (Auto Lock)", Default=false,
    Callback=function(state)
        AimSettings.Enabled=state
        FOVCircle.Visible=AimSettings.Enabled and AimSettings.ShowFOV
    end,
})
PvpTab:CreateToggle({
    Title="Hien Vong FOV", Default=false,
    Callback=function(state)
        AimSettings.ShowFOV=state
        FOVCircle.Visible=AimSettings.Enabled and AimSettings.ShowFOV
    end,
})
PvpTab:CreateSlider({
    Title="Kich Thuoc FOV", Min=30, Max=200, Default=150,
    Callback=function(value)
        AimSettings.FOVRadius=value
        FOVCircle.Size=UDim2.fromOffset(value*2, value*2)
    end,
})
PvpTab:CreateSlider({
    Title="Do Muot Aim (Smooth)", Min=1, Max=10, Default=2,
    Callback=function(value) AimSettings.Smoothness=value/10 end,
})
AmmoStatusLabel = CreateParagraph(PvpTab, {
    Title="Trạng thái đạn",
    Content="Đang chờ...",
}, 60)
PvpTab:CreateToggle({
    Title="Auto Nhat Dan (Nhat 2 Lan)", Default=false,
    Callback=function(state)
        _G.AutoFarmAmmo=state
        if not state then
            SetAmmoStatus("Trạng thái đạn: Đã TẮT")
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Anchored=false
            end
        end
    end,
})

----------------------------------------------------
-- TAB FOSSILS
----------------------------------------------------
FossilsTab:CreateSection("Fossils / Quest")
QuestStatusLabel = CreateParagraph(FossilsTab, {
    Title="Quest Hiện Tại",
    Content="Đang chờ...",
}, 60)
FossilsTab:CreateToggle({Title="Auto Ăn Thịt (Toggle Meat)", Default=false, Callback=function(v) _G.AutoEatActive=v end})
FossilsTab:CreateToggle({Title="Auto Ăn Cỏ (Toggle Herb)", Default=false, Callback=function(v) _G.AutoHerbActive=v end})
FossilsTab:CreateToggle({Title="Auto Drink (Uong Lien Tuc)", Default=false, Callback=function(v) _G.AutoDrinkRunning=v end})
FossilsTab:CreateToggle({Title="Auto Rest (Nghi Noi)", Default=false, Callback=function(v) _G.AutoRestRunning=v end})
FossilsTab:CreateToggle({Title="Auto Zone (Chiem Zone)", Default=false, Callback=function(v) _G.AutoZoneRunning=v end})
CreateParagraph(FossilsTab, {
    Title = "Primeval Core",
    Content = "Auto Ăn Thịt/Cỏ, Drink, Rest, Zone và Quest được giữ nguyên từ UpdatePrimeval.",
}, 64)

----------------------------------------------------
-- TAB CAI DAT / UTILITY
----------------------------------------------------
VisualsTab:CreateSection("Utility")
VisualsTab:CreateToggle({
    Title="Bat Sang Ban Dem (Fullbright)", Default=false,
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
    Title="Vao Server It Nguoi (Low Server)",
    Callback=function()
        local teleportService=game:GetService("TeleportService")
        local placeId=game.PlaceId
        local jobId=game.JobId

        local function SetLowServerText(text)
            if not lowServerBtn or not lowServerBtn.Frame then return end
            local label = lowServerBtn.Frame:FindFirstChild("Title", true) or lowServerBtn.Frame:FindFirstChildWhichIsA("TextLabel", true)
            if label then label.Text=tostring(text) end
        end

        SetLowServerText("Dang Tim Server...")
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
        SetLowServerText("Khong Tim Thay Server!")
        task.delay(2,function()
            if lowServerBtn and lowServerBtn.Frame and lowServerBtn.Frame.Parent then
                SetLowServerText("Vao Server It Nguoi (Low Server)")
            end
        end)
    end,
})

VisualsTab:CreateButton({
    Title="Hoi Sinh Nhan Vat (Reset)",
    Callback=function()
        local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health=0 end
    end,
})
CreateParagraph(VisualsTab, {
    Title="Primeval Earth Hub",
    Content="Giao dien dung MeizuLibrary. Logic UpdatePrimeval duoc giu lai; chi thay lop giao dien.",
}, 64)

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

-- LOGIC AUTO ĂN THỊT & ĂN CỎ CHUNG MỘT HỆ THỐNG BLINK
local EAT_CONFIG = {
    SEARCH_RADIUS = 350.0,
    STAY_DURATION = 0.35,
    CYCLE_INTERVAL = 0.4,
    STRICT_MEAT_KEYWORDS = {"carcass", "meat", "corpse", "deadbody", "ribs", "flesh"},
    STRICT_HERB_KEYWORDS = {"bush", "plant", "grass", "foliage", "herb", "fern", "leaves", "berry", "shrub"}
}

local IsExecutingEatOrHerb = false

local function IsLivingEntityOrMapDecor(instance: Instance): boolean
    local ancestorModel = instance:FindFirstAncestorOfClass("Model")
    if ancestorModel then
        if Players:GetPlayerFromCharacter(ancestorModel) then return true end

        local targetHumanoid = ancestorModel:FindFirstChildOfClass("Humanoid")
        if targetHumanoid and targetHumanoid.Health > 0 then return true end

        local pName = string.lower(ancestorModel.Name)
        if pName:find("map") or pName:find("border") or pName:find("ocean") or pName:find("decor") then
            return true
        end
    end
    return false
end

local function ScanNearbyTarget(keywordsList): BasePart?
    local targetNode: BasePart? = nil
    local minDistance = EAT_CONFIG.SEARCH_RADIUS

    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not IsLivingEntityOrMapDecor(obj) then
                local nameLower = string.lower(obj.Name)
                local parentNameLower = obj.Parent and string.lower(obj.Parent.Name) or ""
                local isMatch = false

                for _, kw in ipairs(keywordsList) do
                    if nameLower:find(kw) or parentNameLower:find(kw) then
                        isMatch = true
                        break
                    end
                end

                if isMatch then
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local dist = (obj.Position - root.Position).Magnitude
                        if dist < minDistance then
                            minDistance = dist
                            targetNode = obj
                        end
                    end
                end
            end
        end
    end)

    return targetNode
end

local function TriggerInteraction(targetPart: BasePart)
    pcall(function()
        local prompt = targetPart:FindFirstChildOfClass("ProximityPrompt") 
            or (targetPart.Parent and targetPart.Parent:FindFirstChildOfClass("ProximityPrompt"))
        
        if prompt and typeof(fireproximityprompt) == "function" then
            fireproximityprompt(prompt)
        end

        for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local rName = string.lower(remote.Name)
                if rName:find("eat") or rName:find("bite") or rName:find("interact") 
                   or rName:find("feed") or rName:find("consume") or rName:find("herb") or rName:find("graze") then
                    
                    remote:FireServer(targetPart)
                    remote:FireServer(targetPart.Parent)
                    remote:FireServer("Eat", targetPart)
                    remote:FireServer("Herb", targetPart)
                end
            end
        end
    end)
end

local function PerformBlink(targetPart: BasePart)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if IsExecutingEatOrHerb or not root or not char then return end
    IsExecutingEatOrHerb = true

    pcall(function()
        local storedCFrame = root.CFrame
        local storedVelocity = root.AssemblyLinearVelocity

        local tempNoclip = {}
        for _, p in ipairs(char:GetChildren()) do
            if p:IsA("BasePart") and p.CanCollide then
                p.CanCollide = false
                table.insert(tempNoclip, p)
            end
        end

        root.AssemblyLinearVelocity = Vector3.zero
        root.CFrame = targetPart.CFrame * CFrame.new(0, 1.0, 0)

        local startTime = tick()
        while tick() - startTime < EAT_CONFIG.STAY_DURATION do
            TriggerInteraction(targetPart)
            task.wait(0.07)
        end

        root.CFrame = storedCFrame
        root.AssemblyLinearVelocity = storedVelocity

        for _, p in ipairs(tempNoclip) do
            if p and p.Parent then p.CanCollide = true end
        end
    end)

    IsExecutingEatOrHerb = false
end

-- Vòng lặp Auto Ăn Thịt
task.spawn(function()
    while true do
        task.wait(EAT_CONFIG.CYCLE_INTERVAL)
        pcall(function()
            if _G.AutoEatActive and not _G.AutoHerbActive then
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if char and root and hum and hum.Health > 0 then
                    local meatNode = ScanNearbyTarget(EAT_CONFIG.STRICT_MEAT_KEYWORDS)
                    if meatNode then
                        PerformBlink(meatNode)
                    end
                end
            end
        end)
    end
end)

-- Vòng lặp Auto Ăn Cỏ
task.spawn(function()
    while true do
        task.wait(EAT_CONFIG.CYCLE_INTERVAL)
        pcall(function()
            if _G.AutoHerbActive then
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if char and root and hum and hum.Health > 0 then
                    local herbNode = ScanNearbyTarget(EAT_CONFIG.STRICT_HERB_KEYWORDS)
                    if herbNode then
                        PerformBlink(herbNode)
                    end
                end
            end
        end)
    end
end)

-- Vòng lặp Quét Quest (Fossils)
task.spawn(function()
    while task.wait(0.2) do
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
            
            if detectedQuest == "Drink" then
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
                        task.wait(0.05)
                        local startTime = tick()
                        while _G.AutoZoneRunning do
                            if IsThisZoneGreen(zonePos) or (tick() - startTime >= 15) then break end
                            local shakeX = math.sin(tick() * 8) * 0.35
                            local shakeZ = math.cos(tick() * 8) * 0.35
                            hrp.CFrame = targetCFrame * CFrame.new(shakeX, 0, shakeZ)
                            hrp.Velocity = Vector3.new(0, 0, 0)
                            task.wait(0.02)
                        end
                        task.wait(0.5)
                    end
                end
                if hrp and _G.AutoZoneRunning then hrp.CFrame = safetyZone3CFrame end
                task.wait(5)
            else
                task.wait(0.5)
            end
        else
            task.wait(0.1)
        end
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
        Title = "Primeval Earth Hub",
        Content = "Đã load hoàn tất. Meizu UI sẵn sàng.",
        Duration = 4,
    })
end)
