-- Primeval Earth Hub x MeizuLibrary
--
-- UI migration:
--   * Giữ nguyên logic/feature gốc của UpdatePrimeval.
--   * Loại bỏ toàn bộ UI tự dựng cũ của Primeval.
--   * Dùng trực tiếp API của meizulibrary1.lua.
--   * FOV/ESP vẫn là overlay chức năng, không phải menu UI.

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

----------------------------------------------------
-- 1. LOAD MEIZU LIBRARY
----------------------------------------------------
local MEIZU_LIBRARY_URL = "https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/meizulibrary1.lua"

local function LoadMeizuLibrary()
    local okHttp, source = pcall(function()
        return game:HttpGet(MEIZU_LIBRARY_URL, true)
    end)
    if not okHttp or type(source) ~= "string" or source == "" then
        error("[Primeval] Không thể tải MeizuLibrary: " .. tostring(source))
    end

    local loader, compileErr = loadstring(source)
    if type(loader) ~= "function" then
        error("[Primeval] MeizuLibrary compile error: " .. tostring(compileErr))
    end

    local okLoad, library = pcall(loader)
    if not okLoad or type(library) ~= "table" then
        error("[Primeval] MeizuLibrary load error: " .. tostring(library))
    end

    return library
end

local MeizuLibrary = LoadMeizuLibrary()

----------------------------------------------------
-- 2. PRIMEVAL GLOBAL STATE / CORE SETTINGS
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

----------------------------------------------------
-- 3. MEIZU WINDOW
----------------------------------------------------
local Window = MeizuLibrary:CreateWindow({
    Title = "Primeval Earth Hub",
    SubTitle = "UpdatePrimeval • Meizu UI",
    Theme = "Dark",
    Accent = Color3.fromRGB(99, 102, 241),
    ToggleKeybind = Enum.KeyCode.RightControl,
    ToggleUIButton = true,
    Size = UDim2.fromOffset(650, 470),
    Language = "vi",
})

if not Window then
    error("[Primeval] MeizuLibrary không trả về Window.")
end

----------------------------------------------------
-- 4. FOV OVERLAY (CHỨC NĂNG AIM, KHÔNG PHẢI MENU UI)
----------------------------------------------------
local function GetGuiParent()
    if type(gethui) == "function" then
        local ok, ui = pcall(gethui)
        if ok and ui then return ui end
    end
    return game:GetService("CoreGui")
end

local oldFovGui = GetGuiParent():FindFirstChild("PrimevalFOVOverlay")
if oldFovGui then
    pcall(function() oldFovGui:Destroy() end)
end

local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "PrimevalFOVOverlay"
FOVGui.ResetOnSpawn = false
FOVGui.IgnoreGuiInset = true
FOVGui.DisplayOrder = 9998
FOVGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
FOVGui.Parent = GetGuiParent()

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

----------------------------------------------------
-- UI ADAPTERS
-- Meizu trả element object thay vì trả TextButton trực tiếp.
-- Các adapter dưới đây chỉ dùng API/frame mà library đã expose.
----------------------------------------------------
local function SetButtonTitle(element, text)
    if not element or not element.Frame or not element.Frame.Parent then return end
    local title
    for _, obj in ipairs(element.Frame:GetDescendants()) do
        if obj:IsA("TextLabel") then
            title = obj
            break
        end
    end
    if title then title.Text = tostring(text) end
end

local function SetParagraphContent(element, text, textColor)
    if not element or not element.Frame or not element.Frame.Parent then return end
    local labels = {}
    for _, obj in ipairs(element.Frame:GetDescendants()) do
        if obj:IsA("TextLabel") then
            table.insert(labels, obj)
        end
    end
    local content = labels[2] or labels[1]
    if content then
        content.Text = tostring(text)
        if textColor then
            content.TextColor3 = textColor
        end
    end
end

local function RemoveDestroyedElements(tab)
    if not tab or type(tab._Elements) ~= "table" then return end
    for i = #tab._Elements, 1, -1 do
        local element = tab._Elements[i]
        if not element or not element.Frame or not element.Frame.Parent then
            table.remove(tab._Elements, i)
        end
    end
end

local function SafeFeatureNotify(title, content)
    pcall(function()
        MeizuLibrary:Notify({
            Title = title,
            Content = content,
            Duration = 3,
        })
    end)
end

-- Đồng bộ trạng thái FOV khi UI/library bị đóng hoàn toàn.
task.spawn(function()
    while FOVGui and FOVGui.Parent and not MeizuLibrary.Destroyed do
        task.wait(0.5)
    end
    if FOVGui and FOVGui.Parent then
        FOVGui:Destroy()
    end
end)

----------------------------------------------------
-- 5. LOGIC ESP, AIMBOT, AUTO ATTACK & AUTO NHẶT ĐẠN
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
        textLabel.Font = Enum.Font.GothamBold
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

----------------------------------------------------
----------------------------------------------------
-- 6. KHỞI TẠO TABS VÀ CHỨC NĂNG QUA MEIZULIBRARY
----------------------------------------------------
local MovementTab = Window:CreateTab("Di Chuyen", nil, 1)
local TeleportTab = Window:CreateTab("Dich Chuyen", nil, 2)
local EspTab = Window:CreateTab("Nhin Xuyen", nil, 3)
local PvpTab = Window:CreateTab("PVP", nil, 4)
local FossilsTab = Window:CreateTab("Fossils", nil, 5)
local VisualsTab = Window:CreateTab("Cai Dat", nil, 6)

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

MovementTab:CreateSection("Movement")
MovementTab:CreateSlider({
    Title = "Toc Do Di Chuyen",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        targetWalkSpeed = value
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = value end
    end,
})

MovementTab:CreateSlider({
    Title = "Suc Nhay (Jump Power)",
    Min = 50,
    Max = 300,
    Default = 50,
    Callback = function(value)
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")
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
    Min = 10,
    Max = 150,
    Default = 50,
    Callback = function(value)
        flySpeed = value
    end,
})

local noclipConn = nil
MovementTab:CreateToggle({
    Title = "Xuyen Tuong (Noclip)",
    Default = false,
    Callback = function(state)
        if state then
            if noclipConn then
                pcall(function() noclipConn:Disconnect() end)
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
    end,
})

MovementTab:CreateParagraph({
    Title = "Meizu UI",
    Content = "Menu đã được chuyển hoàn toàn sang MeizuLibrary. Logic Primeval phía sau vẫn giữ nguyên.",
})

----------------------------------------------------
-- TAB TELEPORT
----------------------------------------------------
TeleportTab:CreateSection("Teleport nguoi choi")
TeleportTab:CreateParagraph({
    Title = "Danh sach nguoi choi",
    Content = "Chọn người chơi bên dưới để dịch chuyển. Danh sách tự refresh khi người chơi vào/rời server.",
})

local PlayerButtonElements = {}

local function ClearPlayerButtons()
    for i = #PlayerButtonElements, 1, -1 do
        local element = PlayerButtonElements[i]
        if element and element.Frame then
            pcall(function() element.Frame:Destroy() end)
        end
        PlayerButtonElements[i] = nil
    end
    RemoveDestroyedElements(TeleportTab)
end

local function AddPlayerButton(plr)
    if plr == LocalPlayer then return end

    local displayName = plr.DisplayName
    local userName = plr.Name
    local btnText = "📍 " .. displayName .. " (@" .. userName .. ")"

    local element = TeleportTab:CreateButton({
        Title = btnText,
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
EspTab:CreateToggle({
    Title = "Bat ESP Tong",
    Default = EspSettings.Enabled,
    Callback = function(state)
        EspSettings.Enabled = state
    end,
})
EspTab:CreateToggle({
    Title = "Hien Ten Nguoi Choi",
    Default = EspSettings.ShowName,
    Callback = function(state)
        EspSettings.ShowName = state
    end,
})
EspTab:CreateToggle({
    Title = "Hien Thanh Mau (HP)",
    Default = EspSettings.ShowHealth,
    Callback = function(state)
        EspSettings.ShowHealth = state
    end,
})
EspTab:CreateToggle({
    Title = "Hien Khoang Cach (m)",
    Default = EspSettings.ShowDistance,
    Callback = function(state)
        EspSettings.ShowDistance = state
    end,
})

----------------------------------------------------
-- TAB PVP
----------------------------------------------------
PvpTab:CreateSection("Aim / FOV")
PvpTab:CreateToggle({
    Title = "Bat Auto Attack (Chi Ban Khi FOV Do)",
    Default = false,
    Callback = function(state)
        _G.AutoAttackRunning = state
    end,
})

PvpTab:CreateToggle({
    Title = "Bat Aimbot (Auto Lock)",
    Default = false,
    Callback = function(state)
        AimSettings.Enabled = state
        FOVCircle.Visible = AimSettings.Enabled and AimSettings.ShowFOV
    end,
})

PvpTab:CreateToggle({
    Title = "Hien Vong FOV",
    Default = false,
    Callback = function(state)
        AimSettings.ShowFOV = state
        FOVCircle.Visible = AimSettings.Enabled and AimSettings.ShowFOV
    end,
})

PvpTab:CreateSlider({
    Title = "Kich Thuoc FOV",
    Min = 30,
    Max = 200,
    Default = 150,
    Callback = function(value)
        AimSettings.FOVRadius = value
        FOVCircle.Size = UDim2.fromOffset(value * 2, value * 2)
    end,
})

PvpTab:CreateSlider({
    Title = "Do Muot Aim (Smooth)",
    Min = 1,
    Max = 10,
    Default = 2,
    Callback = function(value)
        AimSettings.Smoothness = value / 10
    end,
})

local AmmoStatusLabel = PvpTab:CreateParagraph({
    Title = "Trang thai dan",
    Content = "Đang chờ...",
})

PvpTab:CreateToggle({
    Title = "Auto Nhat Dan (Nhat 2 Lan)",
    Default = false,
    Callback = function(state)
        _G.AutoFarmAmmo = state
        if not state then
            SetParagraphContent(AmmoStatusLabel, "Đã TẮT")
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Anchored = false
            end
        end
    end,
})

----------------------------------------------------
-- TAB FOSSILS
----------------------------------------------------
FossilsTab:CreateSection("Fossils / Quest")
local QuestStatusLabel = FossilsTab:CreateParagraph({
    Title = "Quest Hiện Tại",
    Content = "Đang chờ...",
})

FossilsTab:CreateToggle({
    Title = "Auto Ăn Thịt (Toggle Meat)",
    Default = false,
    Callback = function(state) _G.AutoEatActive = state end,
})
FossilsTab:CreateToggle({
    Title = "Auto Ăn Cỏ (Toggle Herb)",
    Default = false,
    Callback = function(state) _G.AutoHerbActive = state end,
})
FossilsTab:CreateToggle({
    Title = "Auto Drink (Uong Lien Tuc)",
    Default = false,
    Callback = function(state) _G.AutoDrinkRunning = state end,
})
FossilsTab:CreateToggle({
    Title = "Auto Rest (Nghi Noi)",
    Default = false,
    Callback = function(state) _G.AutoRestRunning = state end,
})
FossilsTab:CreateToggle({
    Title = "Auto Zone (Chiem Zone)",
    Default = false,
    Callback = function(state) _G.AutoZoneRunning = state end,
})

----------------------------------------------------
-- TAB CAI DAT / UTILITY
----------------------------------------------------
VisualsTab:CreateSection("Utility")
VisualsTab:CreateToggle({
    Title = "Bat Sang Ban Dem (Fullbright)",
    Default = false,
    Callback = function(state)
        if state then
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").ClockTime = 14
            game:GetService("Lighting").GlobalShadows = false
        else
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").GlobalShadows = true
        end
    end,
})

local lowServerBtn = VisualsTab:CreateButton({
    Title = "Vao Server It Nguoi (Low Server)",
    Callback = function()
        local teleportService = game:GetService("TeleportService")
        local placeId = game.PlaceId
        local jobId = game.JobId

        SetButtonTitle(lowServerBtn, "Dang Tim Server...")

        local success, result = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/0?sortOrder=Asc&limit=100")
        end)

        if success and result then
            local decodedSuccess, decoded = pcall(function()
                return HttpService:JSONDecode(result)
            end)

            if decodedSuccess and decoded and decoded.data then
                for _, server in ipairs(decoded.data) do
                    if server.id ~= jobId and server.playing < server.maxPlayers and server.playing > 0 then
                        SetButtonTitle(lowServerBtn, "Dang Chuyen Server (" .. server.playing .. " nguoi)...")
                        SafeFeatureNotify("Low Server", "Đang chuyển sang server " .. tostring(server.playing) .. " người.")
                        teleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
                        return
                    end
                end
            end
        end

        SetButtonTitle(lowServerBtn, "Khong Tim Thay Server!")
        SafeFeatureNotify("Low Server", "Không tìm thấy server phù hợp.")
        task.delay(2, function()
            SetButtonTitle(lowServerBtn, "Vao Server It Nguoi (Low Server)")
        end)
    end,
})

VisualsTab:CreateButton({
    Title = "Hoi Sinh Nhan Vat (Reset)",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
        end
    end,
})

VisualsTab:CreateParagraph({
    Title = "UI / Library",
    Content = "RightControl: bật/tắt menu. Theme, Accent, Config và các thiết lập Library nằm trong tab Settings của MeizuLibrary.",
})

----------------------------------------------------
-- PRIMEVAL READY
----------------------------------------------------
pcall(function()
    MeizuLibrary:Notify({
        Title = "Primeval Earth Hub",
        Content = "Đã nạp thành công bằng MeizuLibrary.",
        Duration = 4,
    })
end)

----------------------------------------------------
-- 7. LOGIC CHẠY NGẦM (GIỮ NGUYÊN UPDATEPRIMEVAL)
----------------------------------------------------
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
            
            SetParagraphContent(AmmoStatusLabel, infoMsg)
            
            if currentAmmo == 0 and reserveAmmo == 0 then
                SetParagraphContent(AmmoStatusLabel, "Hết đạn (00/0)! Đang tới chỗ nhặt...")
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

                SetParagraphContent(AmmoStatusLabel, "Đang nhặt đạn (Lần 1)...")
                tryInteract()
                task.wait(0.6)

                SetParagraphContent(AmmoStatusLabel, "Đang nhặt đạn (Lần 2)...")
                tryInteract()
                task.wait(0.6)
                
                hrp.Anchored = false
                hrp.AssemblyLinearVelocity = Vector3.zero
                for i = 1, 5 do
                    hrp.CFrame = originalCFrame
                    task.wait(0.03)
                end
                
                SetParagraphContent(AmmoStatusLabel, "Đã bơm đầy đạn! Đang quay lại...")
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
                SetParagraphContent(QuestStatusLabel, "Uống Nước (Drink)", Color3.fromRGB(50, 150, 255))
            elseif detectedQuest == "Rest" then
                SetParagraphContent(QuestStatusLabel, "Nghỉ Nơi (Rest)", Color3.fromRGB(255, 165, 0))
            else
                SetParagraphContent(QuestStatusLabel, "Đang chờ...", Color3.fromRGB(255, 255, 0))
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
-- 8. KẾT THÚC
----------------------------------------------------
-- Không còn loading UI cũ của Primeval.
-- MeizuLibrary tự xử lý intro/open animation, launcher và settings.
