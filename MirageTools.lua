-- ============================================================
--  MIRAGE ISLAND TOOLS (BananaCat logic + MeizuLibrary1)
--  Game: Blox Fruits
--  Functions:
--    1. Lụm bánh răng (Blue Gear) trên Mirage Island để gạt cần V4
--    2. Teleport đến NPC Advanced Fruit Dealer (bán trái ác quỷ)
--    3. Teleport đến Mirage Island (nếu đã spawn)
--    4. Tự động đi thuyền ra biển tìm Mirage Island
-- ============================================================

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("DataLoaded")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- ========== LOAD MEIZU LIBRARY ==========
local Library
local okLoad, errLoad = pcall(function()
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/meizulibrary1.lua"))()
end)
if not okLoad or not Library then
    warn("[MirageTools] Failed to load meizulibrary1:", errLoad)
    return
end

-- ========== NOTIFY ==========
local function notify(title, text)
    pcall(function()
        Library:Notify{Title = title, Content = text, Duration = 5}
    end)
end

-- ========== TWEEN MANAGER (BananaCat style) ==========
local TweenManager = {}
TweenManager.currentTween = nil
TweenManager.currentBoatTween = nil

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
    if TweenManager.currentBoatTween then
        pcall(function()
            TweenManager.currentBoatTween:Cancel()
            TweenManager.currentBoatTween:Destroy()
        end)
        TweenManager.currentBoatTween = nil
    end
    setNoclip(false)
end

-- Tag "Teleporting" để tránh anti-cheat flag
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

local function getHRP()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
end

local function isAlive()
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

-- ========== toTarget (BananaCat style) ==========
local function toTarget(targetCFrame, isClose)
    if typeof(targetCFrame) ~= "CFrame" then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    -- Sit fix
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
    -- Close enough -> direct teleport
    if distance < (isClose and 8 or 150) then
        TweenManager.CancelCurrent()
        markTeleporting()
        hrp.CFrame = targetCFrame
        return
    end

    setNoclip(true)
    markTeleporting()

    if TweenManager.currentTween then
        pcall(function() TweenManager.currentTween:Cancel() end)
    end

    local speed = 325
    local t = distance / speed
    if t < 0.05 then t = 0.05 end

    local tweenInfo = TweenInfo.new(t, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, { CFrame = targetCFrame })
    TweenManager.currentTween = tween
    tween:Play()
end

-- ========== DETECT NPC (BananaCat style) ==========
local function DetectNpc(npcName)
    local hrp = getHRP()
    if not hrp then return nil end

    local searchFolders = { Workspace:FindFirstChild("NPCs"), ReplicatedStorage:FindFirstChild("NPCs") }
    local nearest, nearestDist = nil, math.huge

    for _, folder in ipairs(searchFolders) do
        if folder then
            for _, npc in ipairs(folder:GetChildren()) do
                if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
                    local d = (npc.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if d < nearestDist then
                        nearestDist = d
                        nearest = npc
                    end
                end
            end
        end
    end

    -- Fallback: dùng NPCManager nếu có
    if not nearest then
        pcall(function()
            local NPCManager = require(ReplicatedStorage:WaitForChild("NPCManager"))
            local npcs = NPCManager.getNPCsByName(npcName)
            if npcs and npcs[1] then
                nearest = npcs[1]._modelState._instance
            end
        end)
    end

    return nearest
end

-- ========== MIRAGE ISLAND DETECTION ==========
local function getMysticIsland()
    return Workspace.Map:FindFirstChild("MysticIsland")
end

local function getMirageLocation()
    return Workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island")
end

-- Tìm bánh răng blue (Mirage gear)
local function getBlueGear()
    local mystic = getMysticIsland()
    if not mystic then return nil end
    for _, v in ipairs(mystic:GetChildren()) do
        if v:IsA("MeshPart") and v.MeshId == "rbxassetid://10153114969" then
            return v
        end
    end
    return nil
end

-- Tìm điểm cao nhất trên Mirage Island (để ngắm trăng trigger gear spawn)
local function getHighestPoint()
    local mystic = getMysticIsland()
    if not mystic then return nil end
    for _, v in ipairs(mystic:GetDescendants()) do
        if v:IsA("MeshPart") and v.MeshId == "rbxassetid://6745037796" then
            return v
        end
    end
    return nil
end

-- ========== BOAT (for Auto Find Mirage) ==========
local function checkBoat()
    local playerName = LocalPlayer.Name
    local boats = Workspace:FindFirstChild("Boats")
    if not boats then return nil end
    for _, b in ipairs(boats:GetChildren()) do
        if b:IsA("Model") and b:FindFirstChild("Owner") and tostring(b.Owner.Value) == playerName then
            if b:FindFirstChild("Humanoid") and b.Humanoid.Value > 0 then
                return b
            end
        end
    end
    return nil
end

local function noclipBoat(boat)
    for _, v in ipairs(boat:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide then
            v.CanCollide = false
        end
    end
end

-- Tween boat function (simplified)
local function tweenBoat(boat, targetCFrame, speed)
    speed = speed or 350
    if not boat or not boat:FindFirstChild("VehicleSeat") then return end
    local seat = boat.VehicleSeat
    local distance = (targetCFrame.Position - seat.Position).Magnitude
    if TweenManager.currentBoatTween then
        pcall(function() TweenManager.currentBoatTween:Cancel() end)
    end
    local t = distance / speed
    if t < 0.05 then t = 0.05 end
    local info = TweenInfo.new(t, Enum.EasingStyle.Linear)
    local tw = TweenService:Create(seat, info, { CFrame = targetCFrame })
    TweenManager.currentBoatTween = tw
    tw:Play()
    return tw
end

-- ========== UI ==========
local Window = Library:CreateWindow {
    Title = "Mirage Island Tools",
    SubTitle = "BananaCat logic + MeizuLibrary1",
    Theme = "Dark",
    Size = UDim2.fromOffset(530, 420),
    ToggleKeybind = Enum.KeyCode.RightControl,
}

local Tab = Window:CreateTab("Mirage", "", 1)

-- ========== LIVE STATUS PARAGRAPH (update 0.5s) ==========
-- 1 paragraph duy nhất: hiển thị cả status action + info Mirage/BlueGear/FruitDealer
local currentAction = "Idle - Press any button to start"

local function setStatus(text)
    currentAction = text
end

local liveStatus = Tab:CreateParagraph {
    Title = "Live Status",
    Content = currentAction,
}

-- ========== SECTION: TOOLS ==========
Tab:CreateSection("Mirage Island Tools")

-- 1. Collect Blue Gear (lụm bánh răng)
Tab:CreateButton {
    Title = "Lụm Bánh Răng (Blue Gear)",
    Description = "Tìm và lụm bánh răng trên Mirage Island để gạt cần V4",
    Callback = function()
        if not isAlive() then
            notify("Mirage Tools", "Player is dead, wait respawn")
            return
        end

        local mystic = getMysticIsland()
        if not mystic then
            notify("Mirage Tools", "Mirage Island chưa spawn! Bật Auto Find Mirage để tìm.")
            setStatus("Mirage Island chưa spawn")
            return
        end

        local blueGear = getBlueGear()
        if not blueGear then
            notify("Mirage Tools", "Không thấy bánh răng - cần ngắm trăng trước")
            setStatus("Cần ngắm trăng để bánh răng spawn")

            -- Đi lên điểm cao nhất
            local high = getHighestPoint()
            if high then
                local targetCF = high.CFrame * CFrame.new(0, 211.88, 0)
                local hrp = getHRP()
                if hrp and (targetCF.Position - hrp.Position).Magnitude > 10 then
                    setStatus("Đang bay lên điểm cao nhất để ngắm trăng")
                    toTarget(targetCF)
                    return
                end

                -- Nhìn hướng trăng và kích hoạt race skill (T)
                setStatus("Đang nhìn trăng + nhấn T")
                local camera = Workspace.CurrentCamera
                LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
                LocalPlayer.CameraMode = Enum.CameraMode.Classic
                local startT = tick()
                task.spawn(function()
                    while tick() - startT < 3 do
                        pcall(function()
                            camera.CFrame = CFrame.new(
                                camera.CFrame.Position,
                                Lighting:GetMoonDirection() + camera.CFrame.Position
                            )
                        end)
                        task.wait()
                    end
                    VirtualInputManager:SendKeyEvent(true, "T", false, game)
                    task.wait(0.5)
                    VirtualInputManager:SendKeyEvent(false, "T", false, game)
                    task.wait(1)

                    -- Sau khi nhấn T, chạy lại lụm bánh răng
                    local gear = getBlueGear()
                    if gear then
                        setStatus("Đã thấy bánh răng, đang bay tới lụm")
                        toTarget(gear.CFrame)
                    else
                        setStatus("Vẫn không thấy bánh răng - thử lại")
                        notify("Mirage Tools", "Vẫn không thấy bánh răng")
                    end
                end)
            end
            return
        end

        -- Có bánh răng -> bay tới lụm
        setStatus("Đang bay tới lụm bánh răng")
        notify("Mirage Tools", "Đang lụm bánh răng")
        toTarget(blueGear.CFrame)
    end,
}

-- 2. Teleport to Advanced Fruit Dealer
Tab:CreateButton {
    Title = "Tele Đến NPC Bán Trái Ác Quỷ",
    Description = "Bay đến Advanced Fruit Dealer (npc bán trái ác quỷ)",
    Callback = function()
        if not isAlive() then
            notify("Mirage Tools", "Player is dead")
            return
        end

        setStatus("Đang tìm Advanced Fruit Dealer...")
        local npc = DetectNpc("Advanced Fruit Dealer")
        if not npc or not npc:FindFirstChild("HumanoidRootPart") then
            notify("Mirage Tools", "Không tìm thấy Advanced Fruit Dealer")
            setStatus("Không tìm thấy NPC")
            return
        end

        setStatus("Đang bay đến Advanced Fruit Dealer")
        notify("Mirage Tools", "Đang tele đến Advanced Fruit Dealer")
        toTarget(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
    end,
}

-- 3. Teleport to Mirage Island
Tab:CreateButton {
    Title = "Tele Đến Mirage Island",
    Description = "Bay đến Mirage Island (nếu đã spawn)",
    Callback = function()
        if not isAlive() then
            notify("Mirage Tools", "Player is dead")
            return
        end

        local mirageLoc = getMirageLocation()
        if not mirageLoc then
            notify("Mirage Tools", "Mirage Island chưa spawn")
            setStatus("Mirage Island chưa spawn")
            return
        end

        setStatus("Đang bay đến Mirage Island")
        notify("Mirage Tools", "Đang tele đến Mirage Island")
        toTarget(mirageLoc.CFrame)
    end,
}

-- 4. Auto Find Mirage Island (toggle)
local autoFindRunning = false
Tab:CreateToggle {
    Title = "Tự Động Tìm Mirage Island",
    Description = "Mua thuyền + đi ra biển xa để Mirage Island spawn",
    Default = false,
    Callback = function(state)
        autoFindRunning = state
        if state then
            notify("Mirage Tools", "Bắt đầu tìm Mirage Island")
            task.spawn(function()
                while autoFindRunning do
                    pcall(function()
                        if not isAlive() then
                            task.wait(1)
                            return
                        end

                        -- Đã tìm thấy -> dừng
                        if getMysticIsland() then
                            setStatus("Đã tìm thấy Mirage Island! Dừng.")
                            notify("Mirage Tools", "Đã tìm thấy Mirage Island!")
                            autoFindRunning = false
                            if TweenManager.currentBoatTween then
                                pcall(function() TweenManager.currentBoatTween:Cancel() end)
                            end
                            task.wait(5)
                            return
                        end

                        -- Chưa có thuyền -> mua
                        local boat = checkBoat()
                        local hrp = getHRP()
                        if not hrp then task.wait(0.5) return end

                        if not boat or (boat and (boat.VehicleSeat.Position - hrp.Position).Magnitude >= 4000) then
                            -- Bay đến npc bán thuyền
                            local buyBoatCF = CFrame.new(-16204.0810546875, 9.0863618850708, 479.2259521484375)
                            if (buyBoatCF.Position - hrp.Position).Magnitude > 8 then
                                setStatus("Đang bay đến NPC bán thuyền")
                                toTarget(buyBoatCF)
                                return
                            else
                                setStatus("Đang mua PirateBrigade")
                                ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyBoat", "PirateBrigade")
                                task.wait(3)
                                return
                            end
                        end

                        -- Có thuyền rồi -> ngồi lên + tween ra biển xa
                        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if not hum.Sit then
                            setStatus("Đang ngồi lên thuyền")
                            toTarget(boat.VehicleSeat.CFrame)
                            task.wait(1)
                            return
                        end

                        -- Đang ngồi -> tween boat ra xa
                        noclipBoat(boat)
                        setStatus("Đang đi thuyền ra biển tìm Mirage")
                        local farCF = CFrame.new(-118834.515625, boat.WorldPivot.Y, -78.9505844116211)
                            * CFrame.new(0, 0, 99999999)
                        tweenBoat(boat, farCF, 350)
                    end)
                    task.wait(0.5)
                end
            end)
        else
            setStatus("Đã dừng tìm Mirage Island")
            if TweenManager.currentBoatTween then
                pcall(function() TweenManager.currentBoatTween:Cancel() end)
            end
        end
    end,
}

-- ========== SECTION: SETTINGS ==========
Tab:CreateSection("Settings")

-- Biến điều khiển Anti-AFK (declare trước khi dùng)
local antiAfkEnabled = true

-- Anti-AFK toggle (default ON)
Tab:CreateToggle {
    Title = "Anti-AFK",
    Description = "Tự nhấp chuột phải định kỳ để không bị kick vì AFK",
    Default = true,
    Callback = function(state)
        antiAfkEnabled = state
        setStatus(state and "Anti-AFK đã BẬT" or "Anti-AFK đã TẮT")
        notify("Mirage Tools", state and "Anti-AFK đã bật" or "Anti-AFK đã tắt")
    end,
}

-- No Fog toggle - xóa sương mù
local noFogEnabled = false
Tab:CreateToggle {
    Title = "No Fog (Xóa Sương Mù)",
    Description = "Xóa sương mù + Atmosphere để nhìn xa hơn",
    Default = false,
    Callback = function(state)
        noFogEnabled = state
        if state then
            pcall(function()
                Lighting.FogEnd = 100000
                Lighting.FogStart = 100000
                -- Xóa Atmosphere và BlurEffect
                for _, v in ipairs(Lighting:GetDescendants()) do
                    if v:IsA("Atmosphere") or v:IsA("BlurEffect") then
                        v:Destroy()
                    end
                end
                -- Cũng xóa trong Workspace nếu có
                for _, v in ipairs(Workspace:GetDescendants()) do
                    if v:IsA("Atmosphere") or v:IsA("FogEffect") then
                        pcall(function() v:Destroy() end)
                    end
                end
            end)
            notify("Mirage Tools", "Đã xóa sương mù")
            setStatus("No Fog: đã BẬT")
        else
            pcall(function()
                -- Khôi phục giá trị mặc định
                Lighting.FogEnd = 600
                Lighting.FogStart = 0
            end)
            notify("Mirage Tools", "Đã khôi phục sương mù")
            setStatus("No Fog: đã TẮT")
        end
    end,
}

-- Auto re-apply No Fog mỗi 5s (game có thể tự thêm lại)
task.spawn(function()
    while task.wait(5) do
        if noFogEnabled then
            pcall(function()
                if Lighting.FogEnd < 100000 then Lighting.FogEnd = 100000 end
                if Lighting.FogStart < 100000 then Lighting.FogStart = 100000 end
                for _, v in ipairs(Lighting:GetDescendants()) do
                    if (v:IsA("Atmosphere") or v:IsA("BlurEffect")) and v.Parent then
                        v:Destroy()
                    end
                end
            end)
        end
    end
end)

-- ========== SECTION: INFO / HELP ==========
Tab:CreateSection("Help")
Tab:CreateParagraph {
    Title = "Hướng dẫn",
    Content = "UI: RightCtrl để ẩn/hiện\n- Nếu không thấy Mirage Island, dùng Auto Find.\n- Lụm bánh răng: cần Race V4 Awakening (nhìn trăng + T).",
}

-- ========== ANTI-AFK (Idled event) ==========
LocalPlayer.Idled:Connect(function()
    if not antiAfkEnabled then return end
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    end)
end)

-- ========== MAIN LOOP - cập nhật live status mỗi 0.5s ==========
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local mystic = getMysticIsland()
            local mirage = getMirageLocation()
            local blueGear = getBlueGear()
            local npc = DetectNpc("Advanced Fruit Dealer")

            local lines = {}

            -- Action status (từ button/toggle set)
            table.insert(lines, currentAction)
            table.insert(lines, "")

            -- Mirage Island status
            if mystic then
                table.insert(lines, "Mirage Island: ĐÃ SPAWN ✓")
            elseif mirage then
                table.insert(lines, "Mirage Island: ĐÃ SPAWN ✓")
            else
                table.insert(lines, "Mirage Island: chưa spawn ✗")
            end

            -- Blue Gear status
            if blueGear then
                table.insert(lines, "Blue Gear: có thể lụm ✓")
            else
                table.insert(lines, "Blue Gear: chưa spawn ✗")
            end

            -- Fruit Dealer status
            if npc then
                table.insert(lines, "Fruit Dealer: có thể tele ✓")
            else
                table.insert(lines, "Fruit Dealer: không tìm thấy ✗")
            end

            if liveStatus and liveStatus.SetContent then
                liveStatus:SetContent(table.concat(lines, "\n"))
            end
        end)
    end
end)

notify("Mirage Tools", "Loaded. RightCtrl to toggle UI.")
