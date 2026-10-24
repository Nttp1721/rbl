
-- ============================================================

-- Đợi game load
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("DataLoaded")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- ========== CONFIG (chỉnh trong UI cũng được) ==========
local Config = {
    UseTeleport       = false,   -- true = teleport (risky, dễ ban); false = tween (an toàn)
    StopOnFistOfDarkness = true, -- dừng khi có Fist of Darkness (key râu đen)
    StopOnGodsChalice  = false,  -- cũng dừng khi có God's Chalice nếu bật
    CheckInterval      = 0.1,   -- tốc độ vòng lặp
    StuckTimeout       = 5,      -- giây: nếu đứng cạnh chest quá lâu thì skip
}

-- Nâng identity để tránh lỗi capability
pcall(function()
    local f = setthreadidentity or setidentity or set_thread_identity
    if f then f(8) end
end)

-- Mở rộng streaming để client thấy chest ở xa
pcall(function() workspace.StreamingEnabled = false end)
pcall(function() workspace.StreamingMinRadius = 1e8 end)
pcall(function() workspace.StreamingTargetRadius = 1e8 end)

-- ========== TWEEN MANAGER (đơn giản hóa) ==========
local TweenManager = {}
TweenManager.currentTween = nil

local noclip = false
local function setNoclip(state)
    noclip = state
    local char = LocalPlayer.Character
    if not char then return end
    if not state then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

function TweenManager.CancelCurrent()
    if TweenManager.currentTween then
        pcall(function()
            TweenManager.currentTween:Cancel()
            TweenManager.currentTween:Destroy()
        end)
        TweenManager.currentTween = nil
    end
    setNoclip(false)
end

-- Tag "Teleporting" để game không flag anti-cheat khi tween xa
local teleportingTag = false
local teleportingUntil = 0
local function markTeleporting()
    teleportingUntil = tick() + 1.5
    if not teleportingTag then
        teleportingTag = true
        pcall(function() CollectionService:AddTag(LocalPlayer, "Teleporting") end)
    end
end
task.spawn(function()
    while task.wait(0.1) do
        if teleportingTag and tick() >= teleportingUntil then
            pcall(function() CollectionService:RemoveTag(LocalPlayer, "Teleporting") end)
            teleportingTag = false
        end
    end
end)

-- Tạo BodyVelocity giữ nhân vật đứng yên (tránh rơi khi tween xa)
local function ensureFloatForce(hrp)
    if not hrp:FindFirstChild("FloatForce") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FloatForce"
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(100000, 100000, 100000)
        bv.P = 10000
        bv.Parent = hrp
    end
end

-- ========== toTarget: hàm di chuyển chính ==========
local function toTarget(targetCFrame, isClose)
    if typeof(targetCFrame) ~= "CFrame" then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    -- Nếu đang ngồi -> đứng dậy rồi mới đi tiếp
    if hum.Sit then
        TweenManager.CancelCurrent()
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(true, "Space", false, game)
        task.wait()
        VirtualInputManager:SendKeyEvent(false, "Space", false, game)
        task.wait(0.1)
        if hrp:FindFirstChild("EffectsSY") then hrp.EffectsSY:Destroy() end
        hum.Jump = true
        task.wait(0.1)
        hrp.CFrame = hrp.CFrame * CFrame.new(0, 10, 0)
        return
    end

    ensureFloatForce(hrp)

    local distance = (targetCFrame.Position - hrp.Position).Magnitude
    -- Nếu đã gần target -> teleport thẳng luôn
    if distance < (isClose and 8 or 150) then
        TweenManager.CancelCurrent()
        markTeleporting()
        hrp.CFrame = targetCFrame
        return
    end

    setNoclip(true)
    markTeleporting()

    -- Hủy tween cũ
    if TweenManager.currentTween then
        pcall(function() TweenManager.currentTween:Cancel() end)
    end

    local speed = 350
    local t = distance / speed
    if t < 0.05 then t = 0.05 end

    local tweenInfo = TweenInfo.new(t, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, { CFrame = targetCFrame })
    TweenManager.currentTween = tween
    tween:Play()
end

-- ========== HÀM HỖ TRỢ CHEST ==========
local function DetectItemPlr(itemName)
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not char or not backpack then return false end
    return (char:FindFirstChild(itemName) ~= nil) or (backpack:FindFirstChild(itemName) ~= nil)
end

local function ShouldStop()
    if Config.StopOnFistOfDarkness and DetectItemPlr("Fist of Darkness") then
        return "Fist of Darkness"
    end
    if Config.StopOnGodsChalice and DetectItemPlr("God's Chalice") then
        return "God's Chalice"
    end
    return nil
end

-- Tìm chest gần nhất (đã loại chest bị disable / Ignored)
local function GetNearestChest()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local nearest, nearestDist = nil, math.huge
    for _, chest in ipairs(CollectionService:GetTagged("_ChestTagged")) do
        if chest:IsA("BasePart") and not chest:GetAttribute("IsDisabled")
            and not chest:FindFirstChild("Ignored")
            and chest:FindFirstChild("TouchInterest") then
            local d = (chest.Position - hrp.Position).Magnitude
            if d < nearestDist then
                nearestDist = d
                nearest = chest
            end
        end
    end
    return nearest
end

-- Tìm path (PlayerSpawns) khi không thấy chest nào -> bay tới điểm spawn
local function PathFindChest()
    local spawns = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("PlayerSpawns")
    if not spawns then return nil end
    local pirates = spawns:FindFirstChild("Pirates")
    if not pirates then return nil end

    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local nearest, nearestDist = nil, math.huge
    for _, model in ipairs(pirates:GetChildren()) do
        if model:IsA("Model") and model:FindFirstChild("Part") and not model:FindFirstChild("Ignored") then
            local d = (model.Part.Position - hrp.Position).Magnitude
            if d < nearestDist then
                nearestDist = d
                nearest = model
            end
        end
    end
    return nearest
end

local function ClearIgnoredSpawns()
    local spawns = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("PlayerSpawns")
    if spawns and spawns:FindFirstChild("Pirates") then
        for _, m in ipairs(spawns.Pirates:GetChildren()) do
            if m:FindFirstChild("Ignored") then
                m.Ignored:Destroy()
            end
        end
    end
end

-- ========== NOTIFICATION ==========
local function notify(title, text)
    pcall(function()
        local notifModule = ReplicatedStorage:FindFirstChild("Notification")
        if notifModule then
            local Notification = require(notifModule)
            Notification.new("<Color=Yellow>[" .. title .. "]<Color=/> " .. text):Display()
        end
    end)
end

-- ========== UI ==========
local function getParent()
    local ok, ui = pcall(function()
        if gethui then return gethui() end
        return game:GetService("CoreGui")
    end)
    if ok and ui then return ui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local parent = getParent()
local old = parent:FindFirstChild("AutoChestStandaloneUI")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "AutoChestStandaloneUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parent

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.AnchorPoint = Vector2.new(0, 0.5)
frame.Size = UDim2.new(0, 280, 0, 250)
frame.Position = UDim2.new(0, 20, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 24, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(70, 140, 255)
stroke.Thickness = 2
stroke.Parent = frame

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 14)
padding.PaddingRight = UDim.new(0, 14)
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)
padding.Parent = frame

local list = Instance.new("UIListLayout")
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Padding = UDim.new(0, 8)
list.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 22)
title.BackgroundTransparency = 1
title.Text = "Auto Chest (Standalone)"
title.TextColor3 = Color3.fromRGB(70, 140, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.LayoutOrder = 1
title.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 18)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.LayoutOrder = 2
statusLabel.Parent = frame

local statLabel = Instance.new("TextLabel")
statLabel.Size = UDim2.new(1, 0, 0, 18)
statLabel.BackgroundTransparency = 1
statLabel.Text = "Chests collected: 0"
statLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
statLabel.Font = Enum.Font.Gotham
statLabel.TextSize = 12
statLabel.TextXAlignment = Enum.TextXAlignment.Left
statLabel.LayoutOrder = 3
statLabel.Parent = frame

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(1, 0, 0, 32)
startBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 60)
startBtn.Text = "START"
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14
startBtn.LayoutOrder = 4
startBtn.Parent = frame
local c1 = Instance.new("UICorner"); c1.CornerRadius = UDim.new(0, 6); c1.Parent = startBtn

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(1, 0, 0, 32)
stopBtn.BackgroundColor3 = Color3.fromRGB(100, 35, 35)
stopBtn.Text = "STOP"
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
stopBtn.LayoutOrder = 5
stopBtn.Parent = frame
local c2 = Instance.new("UICorner"); c2.CornerRadius = UDim.new(0, 6); c2.Parent = stopBtn

local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(1, 0, 0, 26)
modeBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
modeBtn.Text = "Mode: Tween (Safe)"
modeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
modeBtn.Font = Enum.Font.Gotham
modeBtn.TextSize = 12
modeBtn.LayoutOrder = 6
modeBtn.Parent = frame
local c3 = Instance.new("UICorner"); c3.CornerRadius = UDim.new(0, 6); c3.Parent = modeBtn

local stopItemBtn = Instance.new("TextButton")
stopItemBtn.Size = UDim2.new(1, 0, 0, 26)
stopItemBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
stopItemBtn.Text = "Stop on: Fist of Darkness"
stopItemBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
stopItemBtn.Font = Enum.Font.Gotham
stopItemBtn.TextSize = 12
stopItemBtn.LayoutOrder = 7
stopItemBtn.Parent = frame
local c4 = Instance.new("UICorner"); c4.CornerRadius = UDim.new(0, 6); c4.Parent = stopItemBtn

local function setStatus(text, color)
    statusLabel.Text = "Status: " .. text
    statusLabel.TextColor3 = color or Color3.fromRGB(200, 200, 200)
end

-- ========== STATE & CALLBACKS ==========
local running = false
local chestCount = 0
local stopFlag = nil  -- nil | "Fist of Darkness" | "God's Chalice"

modeBtn.MouseButton1Click:Connect(function()
    Config.UseTeleport = not Config.UseTeleport
    modeBtn.Text = Config.UseTeleport and "Mode: Teleport (Risk)" or "Mode: Tween (Safe)"
end)

stopItemBtn.MouseButton1Click:Connect(function()
    if Config.StopOnFistOfDarkness then
        Config.StopOnFistOfDarkness = false
        Config.StopOnGodsChalice = true
        stopItemBtn.Text = "Stop on: God's Chalice"
    elseif Config.StopOnGodsChalice then
        Config.StopOnGodsChalice = false
        Config.StopOnFistOfDarkness = true
        stopItemBtn.Text = "Stop on: Fist of Darkness"
    end
end)

startBtn.MouseButton1Click:Connect(function()
    if not running then
        running = true
        stopFlag = nil
        setStatus("Running", Color3.fromRGB(100, 255, 120))
        notify("AutoChest", "Started")
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    if running then
        running = false
        setStatus("Stopped", Color3.fromRGB(255, 100, 100))
        TweenManager.CancelCurrent()
        notify("AutoChest", "Stopped manually")
    end
end)

local function updateStat()
    statLabel.Text = string.format("Chests collected: %d", chestCount)
end

-- ========== MAIN LOOP ==========
task.spawn(function()
    while true do
        task.wait(Config.CheckInterval)
        if not running then continue end

        local ok, err = pcall(function()
            -- 1. Kiểm tra key râu đen (Fist of Darkness) / God's Chalice -> dừng
            local stopItem = ShouldStop()
            if stopItem then
                stopFlag = stopItem
                running = false
                setStatus("Got " .. stopItem .. "! Stopped", Color3.fromRGB(255, 215, 0))
                notify("AutoChest", "Got " .. stopItem .. " -> Stopped")
                TweenManager.CancelCurrent()
                return
            end

            -- 2. Tìm chest gần nhất
            local chest = GetNearestChest()
            if chest then
                setStatus("Collecting chest...", Color3.fromRGB(120, 200, 255))
                chestCount = chestCount + 1
                updateStat()

                local stuckTimer = nil
                while running and chest and chest.Parent
                    and not chest:GetAttribute("IsDisabled")
                    and not chest:FindFirstChild("Ignored")
                    and chest:FindFirstChild("TouchInterest") do
                    task.wait()

                    local char = LocalPlayer.Character
                    if not char or not char:FindFirstChild("HumanoidRootPart") then break end
                    local hrp = char.HumanoidRootPart

                    local dist = (hrp.Position - chest.Position).Magnitude

                    if dist <= 5 then
                        -- Đã tới chest. Nếu đứng quá lâu mà không "touch" được -> skip
                        if not stuckTimer then
                            stuckTimer = tick()
                        elseif tick() - stuckTimer >= Config.StuckTimeout then
                            local ignored = Instance.new("IntValue")
                            ignored.Name = "Ignored"
                            ignored.Parent = chest
                            task.wait(0.1)
                            break
                        end

                        if not Config.UseTeleport then
                            -- Tween mode: nhảy để trigger TouchInterest
                            VirtualInputManager:SendKeyEvent(true, "Space", false, game)
                            task.wait()
                            VirtualInputManager:SendKeyEvent(false, "Space", false, game)
                            TweenManager.CancelCurrent()
                        end
                    end

                    if Config.UseTeleport then
                        hrp.CFrame = chest.CFrame
                        TweenManager.CancelCurrent()
                    else
                        toTarget(chest.CFrame, true)
                    end

                    -- Kiểm tra key râu đen trong lúc đang lụm -> dừng ngay
                    local stopItem = ShouldStop()
                    if stopItem then
                        stopFlag = stopItem
                        running = false
                        setStatus("Got " .. stopItem .. "! Stopped", Color3.fromRGB(255, 215, 0))
                        notify("AutoChest", "Got " .. stopItem .. " -> Stopped")
                        TweenManager.CancelCurrent()
                        return
                    end
                end
            else
                -- Không có chest -> đi tới điểm spawn gần nhất để đợi
                local pathChest = PathFindChest()
                if pathChest then
                    setStatus("Moving to spawn area...", Color3.fromRGB(255, 200, 100))
                    toTarget(pathChest.Part.CFrame)
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and (pathChest.Part.Position - hrp.Position).Magnitude <= 100 or GetNearestChest() then
                        local ignored = Instance.new("IntValue")
                        ignored.Name = "Ignored"
                        ignored.Parent = pathChest
                    end
                else
                    -- Không có path -> clear ignore và chờ
                    setStatus("Waiting for chest spawn...", Color3.fromRGB(255, 165, 0))
                    ClearIgnoredSpawns()
                    task.wait(2)
                end
            end
        end)

        if not ok then
            warn("[AutoChest] Error:", err)
            task.wait(1)
        end
    end
end)

-- ========== ANTI-AFK ==========
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end)

notify("AutoChest Standalone", "Loaded. Press START to begin.")
