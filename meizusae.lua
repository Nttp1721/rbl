-- Primeval Earth Hub UI (Cập nhật: Tích hợp Auto Ăn Thịt & Auto Ăn Cỏ vào Tab Fossils)
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")


-- ============================================================
-- MEIZU LIBRARY UI
-- Chỉ thay giao diện; logic Primeval bên dưới được giữ nguyên.
-- ============================================================
local MEIZU_LIBRARY_URL = "https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/meizulibrary1.lua"

local MeizuLibrary = loadstring(game:HttpGet(MEIZU_LIBRARY_URL, true))()

local Window = MeizuLibrary:CreateWindow({
    Title = "PRIMEVAL EARTH",
    SubTitle = "Primeval Earth Hub",
    Theme = "Dark",
    Accent = Color3.fromRGB(88, 101, 242),
    ToggleKeybind = Enum.KeyCode.RightControl,
    ToggleUIButton = true,
    Language = "vi",
    Size = UDim2.fromOffset(650, 460),
})

-- FOV giữ nguyên cơ chế cũ, chỉ dùng ScreenGui của Meizu.
local ScreenGui = MeizuLibrary._ScreenGui

----------------------------------------------------
-- VÒNG TRÒN FOV AIMBOT
----------------------------------------------------
local AimSettings = {
    Enabled = false,
    ShowFOV = false,
    FOVRadius = 150,
    Smoothness = 0.2,
    MaxDistance = 150
}

local hasTargetInFOV = false

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "PrimevalFOVCircle"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVCircle.Size = UDim2.new(0, AimSettings.FOVRadius * 2, 0, AimSettings.FOVRadius * 2)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
FOVCircle.ZIndex = 0
FOVCircle.Parent = ScreenGui

local UICornerCircle = Instance.new("UICorner")
UICornerCircle.CornerRadius = UDim.new(1, 0)
UICornerCircle.Parent = FOVCircle

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 1
UIStroke.Transparency = 0.2
UIStroke.Parent = FOVCircle

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

local EspSettings = {
    Enabled = false,
    ShowName = true,
    ShowHealth = true,
    ShowDistance = true
}

-- Meizu CreateButton/CreateParagraph trả object có Frame.
-- Helper này chỉ lấy TextLabel bên trong để giữ các label trạng thái
-- mà logic Primeval bên dưới đang cập nhật bằng .Text/.TextColor3.
local function FindTextLabel(root, textValue, fallbackIndex)
    local found = {}
    if root then
        for _, obj in ipairs(root:GetDescendants()) do
            if obj:IsA("TextLabel") then
                table.insert(found, obj)
                if textValue ~= nil and obj.Text == textValue then
                    return obj
                end
            end
        end
    end
    return found[fallbackIndex or 1]
end

----------------------------------------------------
-- 4. KHỞI TẠO TABS VÀ CHỨC NĂNG
----------------------------------------------------
local MovementTab = Window:CreateTab("⚡ Di Chuyen", nil, 1)
local TeleportTab = Window:CreateTab("📍 Dich Chuyen", nil, 2)
local EspTab = Window:CreateTab("👁️ Nhin Xuyen", nil, 3)
local PvpTab = Window:CreateTab("⚔ PVP", nil, 4)
local FossilsTab = Window:CreateTab("🦴 Fossils", nil, 5)
local VisualsTab = Window:CreateTab("⚙️ Cai Dat", nil, 6)

-- Adapter nhỏ để phần logic bên dưới không phải thay toàn bộ callback.
local function AddButton(tab, text, callback)
    return tab:CreateButton({
        Title = text,
        Callback = callback,
    })
end

local function AddToggle(tab, text, default, callback)
    return tab:CreateToggle({
        Title = text,
        Default = default,
        Callback = callback,
    })
end

local function AddSlider(tab, text, min, max, default, callback)
    return tab:CreateSlider({
        Title = text,
        Min = min,
        Max = max,
        Default = default,
        Callback = callback,
    })
end

local function AddStatus(tab, title, content)
    local el = tab:CreateParagraph({
        Title = title,
        Content = content,
    })

    local label = FindTextLabel(el.Frame, content, 2)
    if not label then
        label = el.Frame:FindFirstChildWhichIsA("TextLabel", true)
    end

    return label
end

local targetWalkSpeed = 16

AddSlider(MovementTab, "Toc Do Di Chuyen", 16, 200, 16, function(value)
    targetWalkSpeed = value
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = value end
end)

AddSlider(MovementTab, "Suc Nhay (Jump Power)", 50, 300, 50, function(value)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = value
    end
end)

AddToggle(MovementTab, "Bat/Tat Fly (Bay)", false, function(state)
    if state then startFly() else stopFly() end
end)

AddSlider(MovementTab, "Toc Do Fly (Speed)", 10, 150, 50, function(value)
    flySpeed = value
end)

local noclipConn = nil
AddToggle(MovementTab, "Xuyen Tuong (Noclip)", false, function(state)
    if state then
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end

        noclipConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
    end
end)

-- Tab Teleport
TeleportTab:CreateSection("Nguoi Choi")

local PlayerButtonElements = {}

local function RefreshPlayerList()
    for _, element in ipairs(PlayerButtonElements) do
        pcall(function()
            if element and element.Frame then
                element.Frame:Destroy()
            end
        end)
    end
    table.clear(PlayerButtonElements)

    local count = 0

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            count += 1

            local displayName = plr.DisplayName
            local userName = plr.Name
            local btnText = "📍 " .. displayName .. " (@" .. userName .. ")"

            local element = AddButton(TeleportTab, btnText, function()
                if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local myChar = LocalPlayer.Character
                    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")

                    if myHRP then
                        myHRP.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 2)
                    end
                end
            end)

            table.insert(PlayerButtonElements, element)
        end
    end

    if count == 0 then
        table.insert(PlayerButtonElements, TeleportTab:CreateParagraph({
            Title = "Danh sach nguoi choi",
            Content = "Chua co nguoi choi khac trong server.",
        }))
    end
end

Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(RefreshPlayerList)
task.spawn(RefreshPlayerList)

-- Tab ESP
EspTab:CreateSection("ESP")

AddToggle(EspTab, "Bat ESP Tong", EspSettings.Enabled, function(state)
    EspSettings.Enabled = state
end)

AddToggle(EspTab, "Hien Ten Nguoi Choi", EspSettings.ShowName, function(state)
    EspSettings.ShowName = state
end)

AddToggle(EspTab, "Hien Thanh Mau (HP)", EspSettings.ShowHealth, function(state)
    EspSettings.ShowHealth = state
end)

AddToggle(EspTab, "Hien Khoang Cach (m)", EspSettings.ShowDistance, function(state)
    EspSettings.ShowDistance = state
end)

-- Tab PVP
PvpTab:CreateSection("Combat")

AddToggle(PvpTab, "Bat Auto Attack (Chi Bắn Khi FOV Đỏ)", false, function(state)
    _G.AutoAttackRunning = state
end)

AddToggle(PvpTab, "Bat Aimbot (Auto Lock)", false, function(state)
    AimSettings.Enabled = state
    FOVCircle.Visible = AimSettings.Enabled and AimSettings.ShowFOV
end)

AddToggle(PvpTab, "Hien Vong FOV", false, function(state)
    AimSettings.ShowFOV = state
    FOVCircle.Visible = AimSettings.Enabled and AimSettings.ShowFOV
end)

AddSlider(PvpTab, "Kich Thuoc FOV", 30, 200, 150, function(value)
    AimSettings.FOVRadius = value
    FOVCircle.Size = UDim2.new(0, value * 2, 0, value * 2)
end)

AddSlider(PvpTab, "Do Muot Aim (Smooth)", 1, 10, 2, function(value)
    AimSettings.Smoothness = value / 10
end)

local AmmoStatusLabel = AddStatus(PvpTab, "Trạng thái đạn", "Trạng thái đạn: Đang chờ...")

AddToggle(PvpTab, "Auto Nhat Dan (Nhat 2 Lan)", false, function(state)
    _G.AutoFarmAmmo = state

    if not state then
        if AmmoStatusLabel then
            AmmoStatusLabel.Text = "Trạng thái đạn: Đã TẮT"
        end

        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end
    end
end)

-- Tab Fossils
FossilsTab:CreateSection("Fossils")

local QuestStatusLabel = AddStatus(FossilsTab, "Quest Hiện Tại", "Quest Hiện Tại: Đang chờ...")

AddToggle(FossilsTab, "Auto Ăn Thịt (Toggle Meat)", false, function(state)
    _G.AutoEatActive = state
end)

AddToggle(FossilsTab, "Auto Ăn Cỏ (Toggle Herb)", false, function(state)
    _G.AutoHerbActive = state
end)

AddToggle(FossilsTab, "Auto Drink (Uong Lien Tuc)", false, function(state)
    _G.AutoDrinkRunning = state
end)

AddToggle(FossilsTab, "Auto Rest (Nghi Noi)", false, function(state)
    _G.AutoRestRunning = state
end)

AddToggle(FossilsTab, "Auto Zone (Chiem Zone)", false, function(state)
    _G.AutoZoneRunning = state
end)

-- Tab Cài Đặt
VisualsTab:CreateSection("Tiện Ích")

AddToggle(VisualsTab, "Bat Sang Ban Dem (Fullbright)", false, function(state)
    if state then
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").ClockTime = 14
        game:GetService("Lighting").GlobalShadows = false
    else
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").GlobalShadows = true
    end
end)

local lowServerElement
local lowServerBtn

lowServerElement = AddButton(VisualsTab, "Vao Server It Nguoi (Low Server)", function()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local placeId = game.PlaceId
    local jobId = game.JobId

    if lowServerBtn then
        lowServerBtn.Text = "Dang Tim Server..."
    end

    local success, result = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/0?sortOrder=Asc&limit=100")
    end)

    if success and result then
        local decoded = HttpService:JSONDecode(result)

        if decoded and decoded.data then
            for _, server in ipairs(decoded.data) do
                if server.id ~= jobId and server.playing < server.maxPlayers and server.playing > 0 then
                    if lowServerBtn then
                        lowServerBtn.Text = "Dang Chuyen Server (" .. server.playing .. " nguoi)..."
                    end

                    TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
                    return
                end
            end
        end
    end

    if lowServerBtn then
        lowServerBtn.Text = "Khong Tim Thay Server!"
    end

    task.wait(2)

    if lowServerBtn and lowServerBtn.Parent then
        lowServerBtn.Text = "Vao Server It Nguoi (Low Server)"
    end
end)

lowServerBtn = lowServerElement and FindTextLabel(lowServerElement.Frame, nil, 1)

AddButton(VisualsTab, "Hoi Sinh Nhan Vat (Reset)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
    end
end)

-- Meizu tự có intro/open animation; không cần loading UI cũ nữa.
task.defer(function()
    Window:SelectTab(1)
end)

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
        UIStroke.Color = Color3.fromRGB(255, 255, 255)
        hasTargetInFOV = false
        return
    end

    local target = getClosestEnemyInFOV()
    if target then
        hasTargetInFOV = true
        local targetTorso = getTorso(target)
        UIStroke.Color = Color3.fromRGB(255, 50, 50)

        if targetTorso then
            local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, targetTorso.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, AimSettings.Smoothness)
        end
    else
        hasTargetInFOV = false
        UIStroke.Color = Color3.fromRGB(255, 255, 255)
    end
end)

local function CreateESP(player)
    if player == LocalPlayer then return end

    local function SetupCharacter(char)
        if not char then return end
        local head = char:WaitForChild("Head", 5)
        local humanoid = char:WaitForChild("Humanoid", 5)
        if not head or not humanoid then return end

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
        textLabel.Font = Theme.FontBold
        textLabel.TextSize = 13
        textLabel.Parent = bgui

        RunService.RenderStepped:Connect(function()
            if not char or not char.Parent or not humanoid or humanoid.Health <= 0 or not EspSettings.Enabled then
                bgui.Enabled = false
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

            if EspSettings.ShowDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - head.Position).Magnitude)
                table.insert(textParts, string.format("[%dm]", dist))
            end

            textLabel.Text = table.concat(textParts, " | ")
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
-- 5. LOGIC CHẠY NGẦM (AUTO ATTACK, NHẶT ĐẠN, FOSSILS, AUTO ĂN THỊT/CỎ & ANTI-AFK)
----------------------------------------------------
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
            
            AmmoStatusLabel.Text = infoMsg
            
            if currentAmmo == 0 and reserveAmmo == 0 then
                AmmoStatusLabel.Text = "Hết đạn (00/0)! Đang tới chỗ nhặt..."
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

                AmmoStatusLabel.Text = "Đang nhặt đạn (Lần 1)..."
                tryInteract()
                task.wait(0.6)

                AmmoStatusLabel.Text = "Đang nhặt đạn (Lần 2)..."
                tryInteract()
                task.wait(0.6)
                
                hrp.Anchored = false
                hrp.AssemblyLinearVelocity = Vector3.zero
                for i = 1, 5 do
                    hrp.CFrame = originalCFrame
                    task.wait(0.03)
                end
                
                AmmoStatusLabel.Text = "Đã bơm đầy đạn! Đang quay lại..."
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
                QuestStatusLabel.Text = "Quest Hiện Tại: Uống Nước (Drink)"
                QuestStatusLabel.TextColor3 = Color3.fromRGB(50, 150, 255)
            elseif detectedQuest == "Rest" then
                QuestStatusLabel.Text = "Quest Hiện Tại: Nghỉ Nơi (Rest)"
                QuestStatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
            else
                QuestStatusLabel.Text = "Quest Hiện Tại: Đang chờ..."
                QuestStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
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

