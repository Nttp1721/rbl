--[[
    PRIMEVAL EARTH HUB + MEIZU LIBRARY
    Rewritten for runtime stability and lower background overhead.

    Main goals:
      - Keep the original tabs/features.
      - Avoid repeated Workspace:GetDescendants() / ReplicatedStorage:GetDescendants().
      - Use one RenderStepped worker for ESP instead of one connection per player.
      - Bind Aimbot/Fly/Noclip workers only while enabled.
      - Keep loader progress tied to actual initialization stages.
      - Keep rerun cleanup through shared.PrimevalRuntime.
]]

local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local LIBRARY_URL = "https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/meizulibrary1.lua"

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Meizu Hub",
        Text = "Loading...",
        Icon = "rbxassetid://94377325741905",
        Duration = 6,
    })
end)

--==================================================
-- SHARED CLEANUP / RERUN SAFETY
--==================================================

local oldRuntime = rawget(shared, "PrimevalRuntime")
if type(oldRuntime) == "table" and type(oldRuntime.Cleanup) == "function" then
    pcall(oldRuntime.Cleanup)
end

local Runtime = {
    stopped = false,
    connections = {},
    instances = {},
}

function Runtime:TrackConnection(connection)
    if connection then
        table.insert(self.connections, connection)
    end
    return connection
end

function Runtime:Connect(signal, callback)
    local ok, connection = pcall(function()
        return signal:Connect(callback)
    end)
    if ok and connection then
        self:TrackConnection(connection)
        return connection
    end
end

function Runtime:AddInstance(instance)
    if instance then
        table.insert(self.instances, instance)
    end
    return instance
end

function Runtime:Cleanup()
    self.stopped = true
    pcall(function() RunService:UnbindFromRenderStep("PrimevalAimbot") end)
    pcall(function() RunService:UnbindFromRenderStep("PrimevalESP") end)

    for i = #self.connections, 1, -1 do
        local connection = self.connections[i]
        if connection then
            pcall(function() connection:Disconnect() end)
        end
        self.connections[i] = nil
    end

    for i = #self.instances, 1, -1 do
        local instance = self.instances[i]
        if instance and instance.Parent then
            pcall(function() instance:Destroy() end)
        end
        self.instances[i] = nil
    end
end

shared.PrimevalRuntime = Runtime

pcall(function() RunService:UnbindFromRenderStep("AimbotSystem") end)
pcall(function() RunService:UnbindFromRenderStep("PrimevalAimbot") end)
pcall(function() RunService:UnbindFromRenderStep("PrimevalESP") end)

--==================================================
-- GUI PARENT / CLEANUP
--==================================================

local function GetGuiParent()
    if type(gethui) == "function" then
        local ok, gui = pcall(gethui)
        if ok and gui then
            return gui
        end
    end

    local ok, coreGui = pcall(function()
        return game:GetService("CoreGui")
    end)
    if ok and coreGui then
        return coreGui
    end

    return LocalPlayer:WaitForChild("PlayerGui")
end

local GuiParent = GetGuiParent()

pcall(function()
    for _, child in ipairs(GuiParent:GetChildren()) do
        if child:IsA("ScreenGui") then
            if child.Name == "MeizuLoader"
                or child.Name == "PrimevalFOVOverlay"
                or child.Name == "PrimevalFOV"
                or child.Name == "MeizuLoaderOld"
                or child.Name:match("^MeizuLibrary") then
                child:Destroy()
            end
        end
    end
end)

--==================================================
-- LOADER
--==================================================

local LoaderColors = {
    Main = Color3.fromRGB(0, 0, 0),
    Topic = Color3.fromRGB(200, 200, 200),
    Title = Color3.fromRGB(255, 255, 255),
    LoaderBackground = Color3.fromRGB(40, 40, 40),
    LoaderSplash = Color3.fromRGB(3, 252, 3),
    Error = Color3.fromRGB(255, 90, 90),
}

local function Create(className, properties)
    local object = Instance.new(className)
    local parent

    for property, value in pairs(properties or {}) do
        if property == "Parent" then
            parent = value
        else
            pcall(function()
                object[property] = value
            end)
        end
    end

    if parent then
        object.Parent = parent
    end

    return object
end

local function AddCorner(radius, parent)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius),
        Parent = parent,
    })
end

local function Tween(object, duration, properties)
    if not object or not object.Parent then
        return nil
    end

    local ok, tween = pcall(function()
        return TweenService:Create(
            object,
            TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            properties
        )
    end)

    if ok and tween then
        tween:Play()
        return tween
    end
end

local LoaderGui = Runtime:AddInstance(Create("ScreenGui", {
    Name = "MeizuLoader",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100000,
    Parent = GuiParent,
}))

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
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(0, 0),
    ZIndex = 10,
})
AddCorner(12, LoaderFrame)

Create("UIStroke", {
    Color = LoaderColors.LoaderSplash,
    Thickness = 1.25,
    Transparency = 0.25,
    Parent = LoaderFrame,
})

Create("ImageLabel", {
    Name = "Logo",
    Parent = LoaderFrame,
    BackgroundTransparency = 1,
    Image = "rbxassetid://132336058081263",
    Position = UDim2.fromOffset(15, 10),
    Size = UDim2.fromOffset(50, 50),
    ZIndex = 11,
})

local logo = LoaderFrame:FindFirstChild("Logo")
if logo then
    AddCorner(25, logo)
end

Create("TextLabel", {
    Name = "HubName",
    Parent = LoaderFrame,
    BackgroundTransparency = 1,
    Text = "Primeval Earth Hub",
    Position = UDim2.fromOffset(75, 10),
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
    BackgroundTransparency = 1,
    Text = "<b>Đang khởi tạo Primeval...</b>",
    RichText = true,
    Position = UDim2.fromOffset(15, 66),
    Size = UDim2.new(1, -30, 0, 18),
    Font = Enum.Font.Gotham,
    TextColor3 = LoaderColors.Title,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTransparency = 1,
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
    BackgroundTransparency = 1,
    BackgroundColor3 = LoaderColors.LoaderSplash,
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
    Size = UDim2.fromOffset(52, 18),
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
    Position = UDim2.fromOffset(15, 108),
    Size = UDim2.new(1, -85, 0, 18),
    Font = Enum.Font.Gotham,
    Text = "Đang chuẩn bị...",
    TextColor3 = LoaderColors.Topic,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 11,
})

local function UpdateLoader(percent, message)
    percent = math.clamp(tonumber(percent) or 0, 0, 100)
    PercentLabel.Text = string.format("%d%%", math.floor(percent))
    StepLabel.Text = "✓ " .. tostring(message or "")
    Tween(ProgressBar, 0.18, {
        Size = UDim2.new(percent / 100, 0, 1, 0),
    })
end

Tween(LoaderFrame, 0.22, {
    Size = UDim2.fromOffset(346, 132),
})
Tween(LoaderTitle, 0.22, {TextTransparency = 0})
Tween(ProgressBG, 0.22, {BackgroundTransparency = 0})
Tween(ProgressBar, 0.22, {BackgroundTransparency = 0})
UpdateLoader(3, "Đang chuẩn bị...")

--==================================================
-- LOAD MEIZU LIBRARY
--==================================================

local function LoadMeizuLibrary()
    local okHttp, source = pcall(function()
        return game:HttpGet(LIBRARY_URL, true)
    end)
    if not okHttp or type(source) ~= "string" or source == "" then
        error("[Primeval] Không thể tải MeizuLibrary: " .. tostring(source))
    end

    local loader = loadstring or load
    if type(loader) ~= "function" then
        error("[Primeval] Executor không hỗ trợ loadstring/load")
    end

    local chunk, compileError = loader(source)
    if type(chunk) ~= "function" then
        error("[Primeval] MeizuLibrary compile error: " .. tostring(compileError))
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
    task.wait(0.35)
    error(MeizuLibraryOrError)
end

local MeizuLibrary = MeizuLibraryOrError
UpdateLoader(12, "Đã load xong: MeizuLibrary")

--==================================================
-- STATE
--==================================================

local State = {
    autoAttack = false,
    autoAmmo = false,
    autoEat = false,
    autoHerb = false,
    autoDrink = false,
    autoRest = false,
    autoZone = false,
    aimEnabled = false,
    showFOV = false,
    espEnabled = false,
    showName = true,
    showHealth = true,
    showDistance = true,
    flyEnabled = false,
    noclipEnabled = false,
    targetWalkSpeed = 16,
    targetJumpPower = 50,
    flySpeed = 50,
    aimFOV = 150,
    aimSmooth = 0.2,
    aimMaxDistance = 150,
    currentQuest = "None",
}

_G.AutoAttackRunning = false
_G.AutoFarmAmmo = false
_G.AutoEatActive = false
_G.AutoHerbActive = false
_G.AutoDrinkRunning = false
_G.AutoRestRunning = false
_G.AutoZoneRunning = false
_G.CurrentQuest = "None"

local hasTargetInFOV = false
local AmmoStatusLabel
local QuestStatusLabel
local lowServerBtn

UpdateLoader(18, "Đã load xong: State + Runtime")

--==================================================
-- FOV GUI
--==================================================

local FOVGui = Runtime:AddInstance(Create("ScreenGui", {
    Name = "PrimevalFOVOverlay",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 9998,
    Parent = GuiParent,
}))

local FOVCircle = Create("Frame", {
    Name = "FOVCircle",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(State.aimFOV * 2, State.aimFOV * 2),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 2,
    Parent = FOVGui,
})
AddCorner(State.aimFOV, FOVCircle)

local FOVStroke = Create("UIStroke", {
    Color = Color3.fromRGB(255, 255, 255),
    Thickness = 1,
    Transparency = 0.2,
    Parent = FOVCircle,
})

UpdateLoader(22, "Đã load xong: FOV Overlay")

--==================================================
-- GENERIC HELPERS
--==================================================

local function GetCharacter()
    return LocalPlayer.Character
end

local function GetHumanoid(character)
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function GetRoot(character)
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function GetAimPart(character)
    if not character then return nil end
    return character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("Torso")
        or character:FindFirstChild("HumanoidRootPart")
        or character:FindFirstChild("Head")
end

local function SafeCharacterReady()
    local character = GetCharacter()
    local root = GetRoot(character)
    local humanoid = GetHumanoid(character)
    return character, root, humanoid
end

local function SetSafeCFrame(root, cf)
    if root and root.Parent then
        pcall(function()
            root.CFrame = cf
            root.AssemblyLinearVelocity = Vector3.zero
        end)
    end
end

--==================================================
-- AIMBOT
--==================================================

local function GetClosestEnemyInFOV()
    Camera = Workspace.CurrentCamera or Camera
    if not Camera or not State.aimEnabled then
        return nil
    end

    local center = Vector2.new(Camera.ViewportSize.X * 0.5, Camera.ViewportSize.Y * 0.5)
    local closestCharacter = nil
    local closestWorldDistance = State.aimMaxDistance

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local humanoid = GetHumanoid(character)
            local aimPart = GetAimPart(character)

            if humanoid and humanoid.Health > 0 and aimPart then
                local worldDistance = (Camera.CFrame.Position - aimPart.Position).Magnitude
                if worldDistance <= State.aimMaxDistance then
                    local screenPosition, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                    if onScreen and screenPosition.Z > 0 then
                        local screenDistance = (
                            Vector2.new(screenPosition.X, screenPosition.Y) - center
                        ).Magnitude

                        if screenDistance <= State.aimFOV and worldDistance < closestWorldDistance then
                            closestWorldDistance = worldDistance
                            closestCharacter = character
                        end
                    end
                end
            end
        end
    end

    return closestCharacter
end

local function StopAimbot()
    State.aimEnabled = false
    hasTargetInFOV = false
    FOVStroke.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Visible = false
    pcall(function() RunService:UnbindFromRenderStep("PrimevalAimbot") end)
end

local function StartAimbot()
    pcall(function() RunService:UnbindFromRenderStep("PrimevalAimbot") end)
    State.aimEnabled = true

    RunService:BindToRenderStep(
        "PrimevalAimbot",
        Enum.RenderPriority.Camera.Value + 100,
        function()
            if Runtime.stopped or not State.aimEnabled then
                return
            end

            local target = GetClosestEnemyInFOV()
            if target then
                hasTargetInFOV = true
                FOVStroke.Color = Color3.fromRGB(255, 50, 50)

                local aimPart = GetAimPart(target)
                Camera = Workspace.CurrentCamera or Camera
                if Camera and aimPart then
                    local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, aimPart.Position)
                    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, State.aimSmooth)
                end
            else
                hasTargetInFOV = false
                FOVStroke.Color = Color3.fromRGB(255, 255, 255)
            end

            FOVCircle.Visible = State.showFOV
        end
    )
end

local function SetAimEnabled(enabled)
    if enabled then
        StartAimbot()
    else
        StopAimbot()
    end
end

--==================================================
-- ESP: ONE RENDER LOOP FOR ALL PLAYERS
--==================================================

local ESPEntries = {}

local function DestroyESPEntry(player)
    local entry = ESPEntries[player]
    if not entry then return end

    if entry.billboard then
        pcall(function() entry.billboard:Destroy() end)
    end

    ESPEntries[player] = nil
end

local function BuildESPEntry(player, character)
    if player == LocalPlayer or not character then return end

    local head = character:FindFirstChild("Head")
    local humanoid = GetHumanoid(character)
    if not head or not humanoid then
        task.spawn(function()
            local deadline = os.clock() + 6
            while not Runtime.stopped and character.Parent and os.clock() < deadline do
                head = head or character:FindFirstChild("Head")
                humanoid = humanoid or GetHumanoid(character)
                if head and humanoid then break end
                task.wait(0.1)
            end

            if Runtime.stopped or not character.Parent or not head or not humanoid then
                return
            end
            BuildESPEntry(player, character)
        end)
        return
    end

    DestroyESPEntry(player)

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerESP"
    billboard.Adornee = head
    billboard.Size = UDim2.fromOffset(220, 52)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = false
    billboard.Parent = head

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0, 255, 150)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextWrapped = true
    label.Parent = billboard

    ESPEntries[player] = {
        character = character,
        head = head,
        humanoid = humanoid,
        billboard = billboard,
        label = label,
    }
end

local function SetupESPPlayer(player)
    if player == LocalPlayer then return end

    if player.Character then
        BuildESPEntry(player, player.Character)
    end

    Runtime:Connect(player.CharacterAdded, function(character)
        BuildESPEntry(player, character)
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    SetupESPPlayer(player)
end

Runtime:Connect(Players.PlayerAdded, SetupESPPlayer)
Runtime:Connect(Players.PlayerRemoving, function(player)
    DestroyESPEntry(player)
end)

local function StopESP()
    State.espEnabled = false
    pcall(function() RunService:UnbindFromRenderStep("PrimevalESP") end)
    for _, entry in pairs(ESPEntries) do
        if entry.billboard then
            entry.billboard.Enabled = false
        end
    end
end

local function StartESP()
    pcall(function() RunService:UnbindFromRenderStep("PrimevalESP") end)
    State.espEnabled = true

    RunService:BindToRenderStep("PrimevalESP", Enum.RenderPriority.Last.Value, function()
        if Runtime.stopped or not State.espEnabled then
            return
        end

        local localCharacter = GetCharacter()
        local localRoot = GetRoot(localCharacter)

        for player, entry in pairs(ESPEntries) do
            local character = entry.character
            local head = entry.head
            local humanoid = entry.humanoid
            local billboard = entry.billboard

            if player.Parent ~= Players or not character or not character.Parent
                or not head or not head.Parent or not humanoid or not humanoid.Parent
                or humanoid.Health <= 0 then
                if billboard then billboard.Enabled = false end
            else
                billboard.Enabled = true

                local parts = {}
                if State.showName then
                    table.insert(parts, player.DisplayName)
                end
                if State.showHealth then
                    table.insert(parts, string.format(
                        "[%d/%d HP]",
                        math.floor(humanoid.Health),
                        math.floor(humanoid.MaxHealth)
                    ))
                end
                if State.showDistance and localRoot then
                    local distance = (localRoot.Position - head.Position).Magnitude
                    table.insert(parts, string.format("[%dm]", math.floor(distance)))
                end

                entry.label.Text = table.concat(parts, " | ")
            end
        end
    end)
end

--==================================================
-- FLY
--==================================================

local flyAttachment
local flyVelocity
local flyOrientation
local flyConnection

local function CleanupFlyObjects()
    if flyConnection then
        pcall(function() flyConnection:Disconnect() end)
        flyConnection = nil
    end

    if flyVelocity then
        pcall(function() flyVelocity:Destroy() end)
        flyVelocity = nil
    end

    if flyOrientation then
        pcall(function() flyOrientation:Destroy() end)
        flyOrientation = nil
    end

    if flyAttachment then
        pcall(function() flyAttachment:Destroy() end)
        flyAttachment = nil
    end
end

local function StopFly()
    State.flyEnabled = false
    CleanupFlyObjects()
end

local function StartFly()
    CleanupFlyObjects()
    State.flyEnabled = true

    local character, root, humanoid = SafeCharacterReady()
    if not character or not root or not humanoid or humanoid.Health <= 0 then
        State.flyEnabled = false
        return
    end

    flyAttachment = Instance.new("Attachment")
    flyAttachment.Name = "PrimevalFlyAttachment"
    flyAttachment.Parent = root

    flyVelocity = Instance.new("LinearVelocity")
    flyVelocity.Name = "PrimevalFlyVelocity"
    flyVelocity.Attachment0 = flyAttachment
    flyVelocity.MaxForce = math.huge
    flyVelocity.VectorVelocity = Vector3.zero
    flyVelocity.Parent = root

    flyOrientation = Instance.new("AlignOrientation")
    flyOrientation.Name = "PrimevalFlyOrientation"
    flyOrientation.Attachment0 = flyAttachment
    flyOrientation.MaxTorque = math.huge
    flyOrientation.Responsiveness = 200
    flyOrientation.Parent = root

    flyConnection = Runtime:Connect(RunService.RenderStepped, function()
        if Runtime.stopped or not State.flyEnabled then
            return
        end

        Camera = Workspace.CurrentCamera or Camera
        local currentCharacter = GetCharacter()
        local currentRoot = GetRoot(currentCharacter)
        local currentHumanoid = GetHumanoid(currentCharacter)

        if not currentCharacter or not currentRoot or not currentHumanoid
            or currentHumanoid.Health <= 0
            or not flyVelocity or not flyOrientation
            or flyVelocity.Parent ~= currentRoot
            or flyOrientation.Parent ~= currentRoot then
            CleanupFlyObjects()
            return
        end

        if not Camera then return end

        local moveDirection = currentHumanoid.MoveDirection
        if moveDirection.Magnitude <= 0.001 then
            flyVelocity.VectorVelocity = Vector3.zero
            flyOrientation.CFrame = Camera.CFrame
            return
        end

        local look = Camera.CFrame.LookVector
        local right = Camera.CFrame.RightVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        local flatRight = Vector3.new(right.X, 0, right.Z)

        if flatLook.Magnitude <= 0.001 then
            flatLook = Vector3.new(0, 0, -1)
        else
            flatLook = flatLook.Unit
        end

        if flatRight.Magnitude <= 0.001 then
            flatRight = Vector3.new(1, 0, 0)
        else
            flatRight = flatRight.Unit
        end

        local forwardAmount = moveDirection:Dot(look)
        local rightAmount = moveDirection:Dot(right)
        local desired = flatLook * forwardAmount
            + flatRight * rightAmount
            + Vector3.new(0, look.Y * math.abs(forwardAmount), 0)

        if desired.Magnitude > 0.001 then
            desired = desired.Unit * State.flySpeed
        else
            desired = Vector3.zero
        end

        flyVelocity.VectorVelocity = desired
        flyOrientation.CFrame = Camera.CFrame
    end)
end

Runtime:Connect(LocalPlayer.CharacterAdded, function()
    if State.flyEnabled then
        task.delay(0.45, function()
            if not Runtime.stopped and State.flyEnabled then
                StartFly()
            end
        end)
    end
end)

UpdateLoader(28, "Đã load xong: Aimbot + ESP + Fly")

--==================================================
-- MOVEMENT / NOCLIP
--==================================================

local noclipConnection
local noclipOriginals = {}

local function StopNoclip()
    State.noclipEnabled = false

    if noclipConnection then
        pcall(function() noclipConnection:Disconnect() end)
        noclipConnection = nil
    end

    for part, originalValue in pairs(noclipOriginals) do
        if part and part.Parent then
            pcall(function() part.CanCollide = originalValue end)
        end
        noclipOriginals[part] = nil
    end
end

local function StartNoclip()
    StopNoclip()
    State.noclipEnabled = true

    noclipConnection = Runtime:Connect(RunService.Stepped, function()
        if Runtime.stopped or not State.noclipEnabled then
            return
        end

        local character = GetCharacter()
        if not character then return end

        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                if noclipOriginals[part] == nil then
                    noclipOriginals[part] = part.CanCollide
                end
                part.CanCollide = false
            end
        end
    end)
end

Runtime:Connect(LocalPlayer.CharacterAdded, function(character)
    task.delay(0.2, function()
        if Runtime.stopped then return end
        local humanoid = GetHumanoid(character)
        if humanoid then
            pcall(function()
                humanoid.WalkSpeed = State.targetWalkSpeed
                humanoid.UseJumpPower = true
                humanoid.JumpPower = State.targetJumpPower
            end)
        end

        if State.noclipEnabled then
            StartNoclip()
        end
    end)
end)

--==================================================
-- AMMO HELPERS
--==================================================

local targetAmmoCFrame = CFrame.new(637.3, 94.3, -56.5)
local ammoMaxDistance = 15

local function IsFullyVisible(gui)
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

local function CheckAmmoStatus()
    local character = GetCharacter()
    if not character then return nil, nil, "Chưa tải Nhân vật" end

    if not character:FindFirstChildOfClass("Tool") then
        return nil, nil, "Hãy cầm súng trên tay!"
    end

    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then
        return nil, nil, "Không thấy PlayerGui"
    end

    Camera = Workspace.CurrentCamera or Camera
    local viewport = Camera and Camera.ViewportSize or Vector2.new(1000, 1000)
    local rightSideX = viewport.X * 0.5
    local bottomSideY = viewport.Y * 0.5

    local currentAmmo
    local reserveAmmo

    for _, gui in ipairs(playerGui:GetDescendants()) do
        if (gui:IsA("TextLabel") or gui:IsA("TextBox") or gui:IsA("TextButton"))
            and IsFullyVisible(gui)
            and gui.AbsolutePosition.X >= rightSideX
            and gui.AbsolutePosition.Y >= bottomSideY then

            local rawText = gui.Text
            if rawText and rawText ~= "" and gui.TextTransparency < 0.8 then
                local cleanText = rawText:gsub("<[^>]->", "")
                cleanText = cleanText:match("^%s*(.-)%s*$") or cleanText

                local cur, res = cleanText:match("^(%d+)%s*[/⁄∕|]%s*(%d+)$")
                if cur and res then
                    return tonumber(cur), tonumber(res), "Đạn: " .. cleanText
                end

                local resOnly = cleanText:match("^[/⁄∕|]%s*(%d+)$")
                if resOnly then
                    reserveAmmo = tonumber(resOnly)
                end

                local curOnly = cleanText:match("^(%d+)$")
                if curOnly and tonumber(curOnly) <= 200 then
                    currentAmmo = tonumber(curOnly)
                end
            end
        end
    end

    if currentAmmo ~= nil and reserveAmmo ~= nil then
        return currentAmmo, reserveAmmo,
            string.format("Đạn: %02d/%d", currentAmmo, reserveAmmo)
    elseif reserveAmmo ~= nil then
        return currentAmmo or 0, reserveAmmo,
            "Đạn dự trữ: /" .. reserveAmmo
    end

    return nil, nil, "Đang quét UI đạn..."
end

local function FindNearbyPrompts(radius)
    local character = GetCharacter()
    local root = GetRoot(character)
    if not root then return {} end

    local params = OverlapParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {character}
    params.MaxParts = 120

    local found = {}
    local seen = {}

    local ok, parts = pcall(function()
        return Workspace:GetPartBoundsInRadius(root.Position, radius, params)
    end)
    if not ok or not parts then
        return found
    end

    for _, part in ipairs(parts) do
        local prompt = part:FindFirstChildOfClass("ProximityPrompt")
            or (part.Parent and part.Parent:FindFirstChildOfClass("ProximityPrompt"))
        if prompt and prompt.Enabled and not seen[prompt] then
            seen[prompt] = true
            table.insert(found, prompt)
        end
    end

    return found
end

UpdateLoader(34, "Đã load xong: Ammo System")

--==================================================
-- AUTO EAT / HERB - LOW OVERHEAD SYSTEM
--==================================================

local EatConfig = {
    SEARCH_RADIUS = 350,
    STAY_DURATION = 0.35,
    INTERACTION_INTERVAL = 0.14,
    CYCLE_INTERVAL = 0.9,
    STRICT_MEAT_KEYWORDS = {"carcass", "meat", "corpse", "deadbody", "ribs", "flesh"},
    STRICT_HERB_KEYWORDS = {"bush", "plant", "grass", "foliage", "herb", "fern", "leaves", "berry", "shrub"},
}

local EatRemotes = nil
local EatRemoteByType = {
    meat = nil,
    herb = nil,
    generic = nil,
}
local IsExecutingEatOrHerb = false
local EatBusyUntil = 0

local function HasKeyword(text, keywords)
    text = string.lower(tostring(text or ""))
    for _, keyword in ipairs(keywords) do
        if text:find(keyword, 1, true) then
            return true
        end
    end
    return false
end

local function IsLivingOrMapDecor(instance)
    local model = instance:FindFirstAncestorOfClass("Model")
    if not model then return false end

    if Players:GetPlayerFromCharacter(model) then
        return true
    end

    local humanoid = GetHumanoid(model)
    if humanoid and humanoid.Health > 0 then
        return true
    end

    local modelName = string.lower(model.Name)
    return modelName:find("map", 1, true) ~= nil
        or modelName:find("border", 1, true) ~= nil
        or modelName:find("ocean", 1, true) ~= nil
        or modelName:find("decor", 1, true) ~= nil
end

local function FindNearbyEatTarget(keywords)
    local character, root = SafeCharacterReady()
    if not character or not root then return nil end

    local params = OverlapParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {character}
    params.MaxParts = 220

    local ok, parts = pcall(function()
        return Workspace:GetPartBoundsInRadius(root.Position, EatConfig.SEARCH_RADIUS, params)
    end)
    if not ok or not parts then
        return nil
    end

    local nearest
    local nearestDistance = EatConfig.SEARCH_RADIUS

    for _, part in ipairs(parts) do
        if part:IsA("BasePart") and not IsLivingOrMapDecor(part) then
            local parent = part.Parent
            local ancestor = parent and parent.Parent
            local matches = HasKeyword(part.Name, keywords)
                or (parent and HasKeyword(parent.Name, keywords))
                or (ancestor and HasKeyword(ancestor.Name, keywords))

            if matches then
                local distance = (part.Position - root.Position).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearest = part
                end
            end
        end
    end

    return nearest
end

local function RefreshEatRemotes()
    EatRemotes = {}
    EatRemoteByType = {
        meat = nil,
        herb = nil,
        generic = nil,
    }

    pcall(function()
        for _, object in ipairs(ReplicatedStorage:GetDescendants()) do
            if object:IsA("RemoteEvent") then
                local name = string.lower(object.Name)
                local isMeat = name:find("eat", 1, true)
                    or name:find("bite", 1, true)
                    or name:find("feed", 1, true)
                    or name:find("consume", 1, true)
                local isHerb = name:find("herb", 1, true)
                    or name:find("graze", 1, true)
                local isGeneric = name:find("interact", 1, true)

                if isMeat or isHerb or isGeneric then
                    table.insert(EatRemotes, object)
                    if isHerb and not EatRemoteByType.herb then
                        EatRemoteByType.herb = object
                    end
                    if isMeat and not EatRemoteByType.meat then
                        EatRemoteByType.meat = object
                    end
                    if isGeneric and not EatRemoteByType.generic then
                        EatRemoteByType.generic = object
                    end
                end
            end
        end
    end)
end

local function GetEatPrompt(targetPart)
    if not targetPart then return nil end

    local prompt = targetPart:FindFirstChildOfClass("ProximityPrompt")
    if prompt and prompt.Enabled then
        return prompt
    end

    local parent = targetPart.Parent
    if parent then
        prompt = parent:FindFirstChildOfClass("ProximityPrompt")
        if prompt and prompt.Enabled then
            return prompt
        end
    end

    return nil
end

local function TriggerEatInteraction(targetPart, mode)
    if not targetPart or not targetPart.Parent then
        return false
    end

    local prompt = GetEatPrompt(targetPart)
    if prompt and type(fireproximityprompt) == "function" then
        local ok = pcall(function()
            fireproximityprompt(prompt)
        end)
        if ok then
            return true
        end
    end

    if EatRemotes == nil then
        RefreshEatRemotes()
    end

    local remote
    if mode == "herb" then
        remote = EatRemoteByType.herb or EatRemoteByType.generic or EatRemoteByType.meat
    else
        remote = EatRemoteByType.meat or EatRemoteByType.generic or EatRemoteByType.herb
    end

    if remote and remote.Parent then
        local remoteName = string.lower(remote.Name)
        local ok = pcall(function()
            if remoteName:find("herb", 1, true) or remoteName:find("graze", 1, true) or mode == "herb" then
                remote:FireServer("Herb", targetPart)
            else
                remote:FireServer(targetPart)
            end
        end)
        return ok
    end

    return false
end

local function PerformEatBlink(targetPart, mode)
    local now = os.clock()
    if now < EatBusyUntil or IsExecutingEatOrHerb then
        return false
    end

    local character, root, humanoid = SafeCharacterReady()
    if not character or not root or not humanoid or humanoid.Health <= 0 then
        return false
    end

    if not targetPart or not targetPart.Parent then
        return false
    end

    IsExecutingEatOrHerb = true
    EatBusyUntil = now + EatConfig.CYCLE_INTERVAL * 0.5

    local originalCFrame = root.CFrame
    local originalVelocity = root.AssemblyLinearVelocity
    local originalCollisions = {}

    local ok = pcall(function()
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                originalCollisions[part] = part.CanCollide
                if part.CanCollide then
                    part.CanCollide = false
                end
            end
        end

        root.AssemblyLinearVelocity = Vector3.zero
        root.CFrame = targetPart.CFrame * CFrame.new(0, 1, 0)

        local start = os.clock()
        while os.clock() - start < EatConfig.STAY_DURATION do
            if not targetPart.Parent then
                break
            end
            TriggerEatInteraction(targetPart, mode)
            task.wait(EatConfig.INTERACTION_INTERVAL)
        end
    end)

    if root and root.Parent then
        root.CFrame = originalCFrame
        root.AssemblyLinearVelocity = originalVelocity
    end

    for part, originalValue in pairs(originalCollisions) do
        if part and part.Parent then
            pcall(function() part.CanCollide = originalValue end)
        end
    end

    IsExecutingEatOrHerb = false
    return ok
end

-- One worker for both Meat + Herb, never two scanners fighting each other.
task.spawn(function()
    while not Runtime.stopped do
        local started = os.clock()

        if State.autoEat and not State.autoHerb then
            local target = FindNearbyEatTarget(EatConfig.STRICT_MEAT_KEYWORDS)
            if target then
                PerformEatBlink(target, "meat")
            end
        elseif State.autoHerb and not State.autoEat then
            local target = FindNearbyEatTarget(EatConfig.STRICT_HERB_KEYWORDS)
            if target then
                PerformEatBlink(target, "herb")
            end
        elseif State.autoEat and State.autoHerb then
            -- Alternates between the two lists so both toggles can remain enabled.
            local target = FindNearbyEatTarget(EatConfig.STRICT_MEAT_KEYWORDS)
            if not target then
                target = FindNearbyEatTarget(EatConfig.STRICT_HERB_KEYWORDS)
            end
            if target then
                local name = string.lower(target.Name)
                local mode = HasKeyword(name, EatConfig.STRICT_HERB_KEYWORDS) and "herb" or "meat"
                PerformEatBlink(target, mode)
            end
        end

        local elapsed = os.clock() - started
        local remaining = math.max(0.05, EatConfig.CYCLE_INTERVAL - elapsed)
        task.wait(remaining)
    end
end)

RefreshEatRemotes()
UpdateLoader(42, "Đã load xong: Auto Eat + Auto Herb")

--==================================================
-- UI WINDOW
--==================================================

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

pcall(function()
    Window:Toggle(false)
end)

--==================================================
-- PARAGRAPH HELPERS
--==================================================

local function FixParagraphElement(element, defaultHeight)
    if not element or not element.Frame then
        return element
    end

    local frame = element.Frame
    local fallbackHeight = defaultHeight or 58
    local titleLabel = element.TitleLabel
    local contentLabel = element.ContentLabel

    if not titleLabel or not contentLabel then
        local labels = {}
        for _, object in ipairs(frame:GetDescendants()) do
            if object:IsA("TextLabel") then
                table.insert(labels, object)
                object.Visible = true
            end
        end
        titleLabel = titleLabel or labels[1]
        contentLabel = contentLabel or labels[2]
    end

    local busy = false
    local function Reflow()
        if busy or not frame.Parent then return end
        busy = true

        pcall(function()
            frame.Visible = true
            frame.ClipsDescendants = false
            frame.AutomaticSize = Enum.AutomaticSize.None
        end)

        if titleLabel and titleLabel.Parent then
            local width = math.max(120, frame.AbsoluteSize.X - 24)
            if width <= 120 then width = 430 end

            local titleHeight = 18
            pcall(function()
                titleLabel.Visible = true
                titleLabel.TextWrapped = true
                titleLabel.AutomaticSize = Enum.AutomaticSize.None
                titleHeight = math.max(
                    18,
                    math.ceil(TextService:GetTextSize(
                        tostring(titleLabel.Text or ""),
                        Enum.Font.GothamBold,
                        13,
                        Vector2.new(width, 1000)
                    ).Y)
                )
                titleLabel.Size = UDim2.new(1, 0, 0, titleHeight)
            end)

            local contentHeight = 0
            if contentLabel and contentLabel.Parent then
                pcall(function()
                    contentLabel.Visible = true
                    contentLabel.TextWrapped = true
                    contentLabel.AutomaticSize = Enum.AutomaticSize.None
                    local text = tostring(contentLabel.Text or "")
                    if text ~= "" then
                        contentHeight = math.max(
                            16,
                            math.ceil(TextService:GetTextSize(
                                text,
                                Enum.Font.Gotham,
                                12,
                                Vector2.new(width, 1000)
                            ).Y)
                        )
                    end
                    contentLabel.Size = UDim2.new(1, 0, 0, contentHeight)
                end)
            end

            local total = 10 + titleHeight + (contentLabel and 4 or 0) + contentHeight + 10
            frame.Size = UDim2.new(1, 0, 0, math.max(fallbackHeight, total, 40))
        end)

        busy = false
    end

    Reflow()
    task.defer(Reflow)

    Runtime:Connect(frame:GetPropertyChangedSignal("AbsoluteSize"), function()
        task.defer(Reflow)
    end)

    if type(element.SetContent) ~= "function" then
        element.SetContent = function(self, text, textColor)
            if contentLabel and contentLabel.Parent then
                contentLabel.Text = tostring(text or "")
                if textColor then
                    contentLabel.TextColor3 = textColor
                end
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

local function CreateParagraph(tab, config, height)
    return FixParagraphElement(tab:CreateParagraph(config), height or 58)
end

local function SetParagraphContent(element, text, textColor)
    if not element then return end

    pcall(function()
        if type(element.SetContent) == "function" then
            element:SetContent(text, textColor)
            return
        end

        local frame = element.Frame
        if not frame then return end

        for _, object in ipairs(frame:GetDescendants()) do
            if object:IsA("TextLabel") then
                if textColor then
                    object.TextColor3 = textColor
                end
                if object ~= frame:FindFirstChild("TitleLabel", true) then
                    object.Text = tostring(text or "")
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

--==================================================
-- TABS
--==================================================

local MovementTab = Window:CreateTab("Misc", "rbxassetid://10747382750", 5)
local TeleportTab = Window:CreateTab("Teleport", "rbxassetid://10734886004", 2)
local EspTab = Window:CreateTab("ESP", "rbxassetid://10747375132", 3)
local PvpTab = Window:CreateTab("PVP", "rbxassetid://10734975692", 4)
local FossilsTab = Window:CreateTab("Main", "rbxassetid://10709781605", 1)
local VisualsTab = Window:CreateTab("Setting", "rbxassetid://10734950309", 6)

UpdateLoader(50, "Đã dựng xong: Tabs + Menu")

--==================================================
-- MOVEMENT TAB
--==================================================

MovementTab:CreateSection("Movement")
MovementTab:CreateSlider({
    Title = "Tốc Độ Chạy",
    Description = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        State.targetWalkSpeed = tonumber(value) or 16
        local humanoid = GetHumanoid(GetCharacter())
        if humanoid then
            pcall(function() humanoid.WalkSpeed = State.targetWalkSpeed end)
        end
    end,
})

MovementTab:CreateSlider({
    Title = "Nhảy",
    Description = "JumpPower",
    Min = 50,
    Max = 300,
    Default = 50,
    Callback = function(value)
        State.targetJumpPower = tonumber(value) or 50
        local humanoid = GetHumanoid(GetCharacter())
        if humanoid then
            pcall(function()
                humanoid.UseJumpPower = true
                humanoid.JumpPower = State.targetJumpPower
            end)
        end
    end,
})

MovementTab:CreateToggle({
    Title = "Bật/Tắt Bay",
    Description = "Fly",
    Default = false,
    Callback = function(enabled)
        if enabled then
            StartFly()
        else
            StopFly()
        end
    end,
})

MovementTab:CreateSlider({
    Title = "Tốc Độ Bay",
    Description = "Fly Speed",
    Min = 10,
    Max = 150,
    Default = 50,
    Callback = function(value)
        State.flySpeed = tonumber(value) or 50
    end,
})

MovementTab:CreateToggle({
    Title = "Xuyên Tường",
    Description = "NoClip",
    Default = false,
    Callback = function(enabled)
        if enabled then
            StartNoclip()
        else
            StopNoclip()
        end
    end,
})

--==================================================
-- TELEPORT TAB
--==================================================

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

local function AddPlayerButton(player)
    if player == LocalPlayer then return end

    local element = TeleportTab:CreateButton({
        Title = "📍 " .. player.DisplayName .. " (@" .. player.Name .. ")",
        Callback = function()
            if player.Parent ~= Players then return end
            local targetRoot = GetRoot(player.Character)
            local myRoot = GetRoot(GetCharacter())
            if targetRoot and myRoot then
                pcall(function()
                    myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 2)
                end)
            end
        end,
    })

    table.insert(PlayerButtonElements, element)
end

local function RefreshPlayerList()
    ClearPlayerButtons()
    for _, player in ipairs(Players:GetPlayers()) do
        AddPlayerButton(player)
    end
end

Runtime:Connect(Players.PlayerAdded, function()
    task.delay(0.15, RefreshPlayerList)
end)
Runtime:Connect(Players.PlayerRemoving, function()
    task.delay(0.05, RefreshPlayerList)
end)
task.defer(RefreshPlayerList)

--==================================================
-- ESP TAB
--==================================================

EspTab:CreateSection("ESP")
EspTab:CreateToggle({
    Title = "Bật/Tắt ESP",
    Default = false,
    Callback = function(enabled)
        if enabled then
            StartESP()
        else
            StopESP()
        end
    end,
})
EspTab:CreateToggle({
    Title = "Hiện Tên",
    Default = true,
    Callback = function(value) State.showName = value end,
})
EspTab:CreateToggle({
    Title = "Hiện Máu (HP)",
    Default = true,
    Callback = function(value) State.showHealth = value end,
})
EspTab:CreateToggle({
    Title = "Hiện Khoảng Cách (m)",
    Default = true,
    Callback = function(value) State.showDistance = value end,
})

--==================================================
-- PVP TAB
--==================================================

PvpTab:CreateSection("Aim / FOV")
PvpTab:CreateToggle({
    Title = "Auto Attack (Chỉ bắn khi FOV đỏ)",
    Default = false,
    Callback = function(enabled)
        State.autoAttack = enabled
        _G.AutoAttackRunning = enabled
    end,
})

PvpTab:CreateToggle({
    Title = "Aimbot (Auto Lock)",
    Default = false,
    Callback = function(enabled)
        SetAimEnabled(enabled)
        FOVCircle.Visible = enabled and State.showFOV
    end,
})

PvpTab:CreateToggle({
    Title = "Hiện Vòng FOV",
    Default = false,
    Callback = function(enabled)
        State.showFOV = enabled
        FOVCircle.Visible = State.aimEnabled and enabled
    end,
})

PvpTab:CreateSlider({
    Title = "Kích Thước FOV",
    Min = 30,
    Max = 200,
    Default = 150,
    Callback = function(value)
        State.aimFOV = tonumber(value) or 150
        FOVCircle.Size = UDim2.fromOffset(State.aimFOV * 2, State.aimFOV * 2)
        local corner = FOVCircle:FindFirstChildOfClass("UICorner")
        if corner then
            corner.CornerRadius = UDim.new(1, 0)
        end
    end,
})

PvpTab:CreateSlider({
    Title = "Độ Mượt Aim (Smooth)",
    Min = 1,
    Max = 10,
    Default = 2,
    Callback = function(value)
        State.aimSmooth = math.clamp((tonumber(value) or 2) / 10, 0.05, 1)
    end,
})

AmmoStatusLabel = CreateParagraph(PvpTab, {
    Title = "Trạng thái đạn",
    Content = "Đang chờ...",
}, 60)

PvpTab:CreateToggle({
    Title = "Auto Nhặt Đạn (Nhặt 2 Lần)",
    Default = false,
    Callback = function(enabled)
        State.autoAmmo = enabled
        _G.AutoFarmAmmo = enabled
        if not enabled then
            SetAmmoStatus("Trạng Thái Đạn: Đã TẮT")
            local root = GetRoot(GetCharacter())
            if root then
                root.Anchored = false
            end
        end
    end,
})

--==================================================
-- MAIN / FOSSILS TAB
--==================================================

FossilsTab:CreateSection("Main / Quest")
QuestStatusLabel = CreateParagraph(FossilsTab, {
    Title = "Quest Hiện Tại",
    Content = "Đang chờ...",
}, 60)

FossilsTab:CreateToggle({
    Title = "Auto Ăn Thịt (Toggle Meat)",
    Default = false,
    Callback = function(enabled)
        State.autoEat = enabled
        _G.AutoEatActive = enabled
    end,
})

FossilsTab:CreateToggle({
    Title = "Auto Ăn Cỏ (Toggle Herb)",
    Default = false,
    Callback = function(enabled)
        State.autoHerb = enabled
        _G.AutoHerbActive = enabled
    end,
})

FossilsTab:CreateToggle({
    Title = "Auto Drink (Uống Liên Tục)",
    Default = false,
    Callback = function(enabled)
        State.autoDrink = enabled
        _G.AutoDrinkRunning = enabled
    end,
})

FossilsTab:CreateToggle({
    Title = "Auto Rest (Nghỉ Ngơi)",
    Default = false,
    Callback = function(enabled)
        State.autoRest = enabled
        _G.AutoRestRunning = enabled
    end,
})

FossilsTab:CreateToggle({
    Title = "Auto Zone (Chiếm Zone)",
    Default = false,
    Callback = function(enabled)
        State.autoZone = enabled
        _G.AutoZoneRunning = enabled
    end,
})

--==================================================
-- SETTINGS / UTILITY TAB
--==================================================

VisualsTab:CreateSection("Utility")
VisualsTab:CreateToggle({
    Title = "Trời Sáng (Fullbright)",
    Default = false,
    Callback = function(enabled)
        local Lighting = game:GetService("Lighting")
        if enabled then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
        end
    end,
})

lowServerBtn = VisualsTab:CreateButton({
    Title = "HOP Server (Low Player)",
    Callback = function()
        if not lowServerBtn or not lowServerBtn.Frame then return end

        local function SetText(text)
            pcall(function()
                local label = lowServerBtn.Frame:FindFirstChild("Title", true)
                    or lowServerBtn.Frame:FindFirstChildWhichIsA("TextLabel", true)
                if label then
                    label.Text = tostring(text)
                end
            end)
        end

        SetText("Đang Tìm Server...")

        local placeId = game.PlaceId
        local currentJobId = game.JobId
        local success, result = pcall(function()
            return game:HttpGet(
                "https://games.roblox.com/v1/games/" .. tostring(placeId)
                .. "/servers/0?sortOrder=Asc&limit=100"
            )
        end)

        if success and result then
            local ok, data = pcall(function()
                return HttpService:JSONDecode(result)
            end)

            if ok and data and data.data then
                for _, server in ipairs(data.data) do
                    if server.id ~= currentJobId
                        and tonumber(server.playing) ~= nil
                        and tonumber(server.maxPlayers) ~= nil
                        and server.playing < server.maxPlayers
                        and server.playing > 0 then
                        SetText("Đang Chuyển Server (" .. tostring(server.playing) .. " người)...")
                        pcall(function()
                            TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
                        end)
                        return
                    end
                end
            end
        end

        SetText("Không Tìm Thấy Server!")
        task.delay(2, function()
            if lowServerBtn and lowServerBtn.Frame and lowServerBtn.Frame.Parent then
                SetText("Vào Server Ít Người (Low Player)")
            end
        end)
    end,
})

VisualsTab:CreateButton({
    Title = "Hồi Sinh Nhân vật (Reset)",
    Callback = function()
        local humanoid = GetHumanoid(GetCharacter())
        if humanoid then
            pcall(function() humanoid.Health = 0 end)
        end
    end,
})

UpdateLoader(60, "Đã dựng xong: Misc + Teleport + ESP + PVP + Main + Setting")

--==================================================
-- AUTO ATTACK - CACHED ATTACK BUTTONS
--==================================================

local AttackButtons = {}
local AttackScanTime = 0

local function RefreshAttackButtons()
    table.clear(AttackButtons)

    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return end

    pcall(function()
        for _, gui in ipairs(playerGui:GetDescendants()) do
            if (gui:IsA("ImageButton") or gui:IsA("TextButton"))
                and gui.Name == "Attack" then
                table.insert(AttackButtons, gui)
            end
        end
    end)

    AttackScanTime = os.clock()
end

local function TriggerAttack()
    if type(getconnections) ~= "function" then return end

    if os.clock() - AttackScanTime >= 2 or #AttackButtons == 0 then
        RefreshAttackButtons()
    end

    for i = #AttackButtons, 1, -1 do
        local button = AttackButtons[i]
        if not button or not button.Parent then
            table.remove(AttackButtons, i)
        else
            pcall(function()
                for _, connection in ipairs(getconnections(button.Activated)) do
                    connection:Fire()
                end
            end)
        end
    end
end

--==================================================
-- CONTROL CLICK TELEPORT
--==================================================

local Mouse = LocalPlayer:GetMouse()
Runtime:Connect(Mouse.Button1Down, function()
    if not UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        return
    end

    local root = GetRoot(GetCharacter())
    if root and Mouse.Target then
        pcall(function()
            local position = Mouse.Hit.Position
            root.CFrame = CFrame.new(position.X, position.Y + 3, position.Z)
        end)
    end
end)

--==================================================
-- ANTI AFK
--==================================================

Runtime:Connect(LocalPlayer.Idled, function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

--==================================================
-- AUTO ATTACK WORKER
--==================================================

task.spawn(function()
    while not Runtime.stopped do
        if State.autoAttack and hasTargetInFOV then
            TriggerAttack()
        end
        task.wait(0.12)
    end
end)

--==================================================
-- AUTO AMMO WORKER
--==================================================

local autoAmmoBusy = false

task.spawn(function()
    while not Runtime.stopped do
        if State.autoAmmo and not autoAmmoBusy then
            local character, root, humanoid = SafeCharacterReady()
            if root and humanoid and humanoid.Health > 0 then
                local currentAmmo, reserveAmmo, info = CheckAmmoStatus()
                SetAmmoStatus(info)

                if currentAmmo == 0 and reserveAmmo == 0 then
                    autoAmmoBusy = true

                    local originalCFrame = root.CFrame
                    root.Anchored = false
                    root.AssemblyLinearVelocity = Vector3.zero

                    for _ = 1, 4 do
                        if not State.autoAmmo then break end
                        SetSafeCFrame(root, targetAmmoCFrame)
                        task.wait(0.04)
                    end

                    if State.autoAmmo then
                        root.Anchored = true
                        SetAmmoStatus("Đang nhặt đạn (Lần 1)...")
                        for _, prompt in ipairs(FindNearbyPrompts(ammoMaxDistance)) do
                            pcall(function() fireproximityprompt(prompt) end)
                        end

                        task.wait(0.65)
                        if State.autoAmmo then
                            SetAmmoStatus("Đang nhặt đạn (Lần 2)...")
                            for _, prompt in ipairs(FindNearbyPrompts(ammoMaxDistance)) do
                                pcall(function() fireproximityprompt(prompt) end)
                            end
                        end
                        task.wait(0.5)
                    end

                    root.Anchored = false
                    root.AssemblyLinearVelocity = Vector3.zero

                    for _ = 1, 4 do
                        if not State.autoAmmo then break end
                        SetSafeCFrame(root, originalCFrame)
                        task.wait(0.04)
                    end

                    if State.autoAmmo then
                        SetAmmoStatus("Đã bơm đầy đạn! Đang quay lại...")
                    end

                    autoAmmoBusy = false
                end
            end
        end
        task.wait(State.autoAmmo and 0.75 or 0.2)
    end
end)

--==================================================
-- QUEST SCANNER
--==================================================

local lastQuestScan = 0

local function DetectQuest()
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return "None" end

    local gameUI = playerGui:FindFirstChild("GameUI")
    local questsFrame = gameUI and gameUI:FindFirstChild("QuestsFrame")
    if not questsFrame then return "None" end

    local detectedQuest = "None"

    pcall(function()
        for _, object in ipairs(questsFrame:GetDescendants()) do
            if object:IsA("TextLabel") then
                local text = string.lower(object.Text or "")
                if text:find("drink water", 1, true) then
                    detectedQuest = "Drink"
                    break
                elseif text:find("rest", 1, true) then
                    detectedQuest = "Rest"
                    break
                end
            end
        end
    end)

    return detectedQuest
end

task.spawn(function()
    while not Runtime.stopped do
        local now = os.clock()
        if now - lastQuestScan >= 0.9 then
            lastQuestScan = now
            local quest = DetectQuest()
            State.currentQuest = quest
            _G.CurrentQuest = quest

            if quest == "Drink" then
                SetQuestStatus(
                    "Quest Hiện Tại: Uống Nước (Drink)",
                    Color3.fromRGB(50, 150, 255)
                )
            elseif quest == "Rest" then
                SetQuestStatus(
                    "Quest Hiện Tại: Nghỉ Nơi (Rest)",
                    Color3.fromRGB(255, 165, 0)
                )
            else
                SetQuestStatus(
                    "Quest Hiện Tại: Đang chờ...",
                    Color3.fromRGB(255, 255, 0)
                )
            end
        end

        task.wait(0.2)
    end
end)

--==================================================
-- AUTO DRINK
--==================================================

task.spawn(function()
    while not Runtime.stopped do
        if State.autoDrink then
            local ok, remote = pcall(function()
                return ReplicatedStorage
                    .Remotes
                    .Character
                    .CharacterFunctions
            end)

            if ok and remote then
                pcall(function()
                    remote:InvokeServer("Drink")
                end)
            end
            task.wait(0.8)
        else
            task.wait(0.25)
        end
    end
end)

--==================================================
-- AUTO REST
--==================================================

task.spawn(function()
    local restRemote
    local restingActive = false

    while not Runtime.stopped do
        if not restRemote or not restRemote.Parent then
            pcall(function()
                restRemote = ReplicatedStorage.Remotes.Character.Rest
            end)
        end

        local shouldRest = State.autoRest and State.currentQuest == "Rest"

        if shouldRest and not restingActive and restRemote then
            pcall(function() restRemote:InvokeServer(true) end)
            restingActive = true
        elseif not shouldRest and restingActive and restRemote then
            pcall(function() restRemote:InvokeServer(false) end)
            restingActive = false
        end

        task.wait(0.35)
    end
end)

--==================================================
-- AUTO ZONE
--==================================================

local ZonesList = {
    Vector3.new(-144.54, -102.15, 1032.19),
    Vector3.new(-617.92, 143.39, -1130.44),
    Vector3.new(1449.99, 77.16, -677.59),
    Vector3.new(276.03, 75.50, -1029.02),
    Vector3.new(-513.23, 75.73, -430.79),
    Vector3.new(1090.65, 66.03, 467.14),
    Vector3.new(209.25, -32.79, -359.19),
    Vector3.new(-170.20, 109.98, 388.42),
    Vector3.new(-69.11, -61.16, -1493.54),
}

local ZoneFolder
local ZoneCores = {}
local zoneCacheBuilt = false

local function BuildZoneCache()
    ZoneCores = {}
    zoneCacheBuilt = false

    pcall(function()
        ZoneFolder = Workspace:FindFirstChild("MapResources")
            and Workspace.MapResources:FindFirstChild("Zones")
        if not ZoneFolder then return end

        for _, zoneObject in ipairs(ZoneFolder:GetChildren()) do
            local core = zoneObject:FindFirstChild("LightCore")
            if core and core:IsA("BasePart") then
                table.insert(ZoneCores, core)
            end
        end

        zoneCacheBuilt = true
    end)
end

local function IsThisZoneGreen(targetPosition)
    if not zoneCacheBuilt then
        BuildZoneCache()
    end

    for i = #ZoneCores, 1, -1 do
        local core = ZoneCores[i]
        if not core or not core.Parent then
            table.remove(ZoneCores, i)
        else
            local distance = (core.Position - targetPosition).Magnitude
            if distance < 15 then
                local color = core.Color
                return color.R <= 0.05 and color.G > 0.9 and color.B <= 0.05
            end
        end
    end

    return false
end

BuildZoneCache()

Runtime:Connect(LocalPlayer.CharacterAdded, function()
    if State.autoZone then
        task.delay(0.5, function()
            -- Worker automatically reacquires root; no blocking wait here.
        end)
    end
end)

task.spawn(function()
    local zoneIndex = 1

    while not Runtime.stopped do
        if State.autoZone then
            local character, root, humanoid = SafeCharacterReady()
            if root and humanoid and humanoid.Health > 0 then
                local startIndex = zoneIndex

                repeat
                    if not State.autoZone then break end

                    local zonePosition = ZonesList[zoneIndex]
                    if zonePosition and not IsThisZoneGreen(zonePosition) then
                        local targetCFrame = CFrame.new(
                            zonePosition.X,
                            zonePosition.Y + 5,
                            zonePosition.Z
                        )

                        SetSafeCFrame(root, targetCFrame)
                        task.wait(0.1)

                        local startTime = os.clock()
                        local nextCheck = 0

                        while State.autoZone and root.Parent and humanoid.Health > 0 do
                            local now = os.clock()

                            if now >= nextCheck then
                                nextCheck = now + 0.5
                                if IsThisZoneGreen(zonePosition) or now - startTime >= 15 then
                                    break
                                end
                            end

                            local shakeX = math.sin(now * 8) * 0.35
                            local shakeZ = math.cos(now * 8) * 0.35
                            pcall(function()
                                root.CFrame = targetCFrame * CFrame.new(shakeX, 0, shakeZ)
                                root.AssemblyLinearVelocity = Vector3.zero
                            end)
                            task.wait(0.08)
                        end

                        task.wait(0.25)
                    end

                    zoneIndex = zoneIndex + 1
                    if zoneIndex > #ZonesList then
                        zoneIndex = 1
                    end
                until zoneIndex == startIndex or not State.autoZone

                if State.autoZone and root.Parent then
                    pcall(function()
                        root.CFrame = CFrame.new(1449.99, 82.16, -677.59)
                    end)
                end

                task.wait(2.5)
            else
                task.wait(0.5)
            end
        else
            task.wait(0.25)
        end
    end
end)

UpdateLoader(72, "Đã load xong: Auto Attack + Auto Ammo + Quest + Zone")

--==================================================
-- FINAL READY
--==================================================

UpdateLoader(84, "Đã hoàn tất Runtime Systems")

-- Give the library one tiny scheduling slice so its initial UI/layout can settle.
task.wait()

UpdateLoader(100, "Đã load xong toàn bộ Primeval Earth Hub")

-- Close loader without freezing the script.
Tween(LoaderTitle, 0.18, {TextTransparency = 1})
Tween(ProgressBG, 0.18, {BackgroundTransparency = 1})
Tween(ProgressBar, 0.18, {BackgroundTransparency = 1})
Tween(StepLabel, 0.18, {TextTransparency = 1})
Tween(PercentLabel, 0.18, {TextTransparency = 1})

local closeTween = Tween(LoaderFrame, 0.22, {
    Size = UDim2.fromOffset(0, 0),
})

if closeTween then
    pcall(function() closeTween.Completed:Wait() end)
end

if LoaderGui and LoaderGui.Parent then
    LoaderGui:Destroy()
end

pcall(function()
    Window:Toggle(true)
end)

pcall(function()
    MeizuLibrary:Notify({
        Title = "Meizu Hub",
        Content = "Loading Succesfully!",
        Duration = 4,
    })
end)

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Meizu Hub",
        Text = "Loaded successfully!",
        Icon = "rbxassetid://94377325741905",
        Duration = 4,
    })
end)

