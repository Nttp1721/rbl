--[[═══════════════════════════════════════════════════════════════════════
    MEIZU HUB — BLOX FRUITS · HALLOWEEN EVENT 2026 (HELLFIRE) · v2.5
    ────────────────────────────────────────────────────────────────────────
    • Library   : Meizu Library (Nttp1721) — raw.githubusercontent.com/Nttp1721/rbl
    • Update v2.5:
      [FIX] Tele khùng khi farm — khóa mục tiêu trong PumpkinPatch + giới hạn
            vùng farm, blacklist ổn định, chỉ di chuyển sang patch gần nhất
            khi vùng hiện tại CẠN KIỆT (không nhảy loạn xạ nữa).
      [FIX] Farm + Trick-or-Treat chạy cùng lúc: đầu giờ (phút 0–9) farm tự
            nhường quyền, script đi gõ cửa trong bán kính lớn rồi quay lại.
      [FIX] Mất thông báo — hệ thống Toast riêng (không phụ thuộc Library).
      [MỚI] Anti-ban (mượn ý tưởng Banana Cat Hub): Teleport-Y khi máu yếu,
            tự né skill quái, jitter tốc độ bay ngẫu nhiên.
      [MỚI] Locked Door: gõ trúng nhà bị khóa → tự đổi sang nhà khác.
      [ĐỔI] Tốc độ bay MAX 250 studs/s (an toàn với anti-cheat).
════════════════════════════════════════════════════════════════════════]]

-- ════════════════════════════ 0. CẤU HÌNH URL ════════════════════════════
local MEIZU_LIBRARY_URL =
        "https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/MeizuLibrary.lua"

-- ════════════════════════════ 1. ANTI-CHỒNG BẢN ═══════════════════════════
if getgenv().MZ_Halloween_Unload then
        pcall(getgenv().MZ_Halloween_Unload)
        task.wait(0.2)
end

-- ════════════════════════════ 2. SERVICES ═════════════════════════════════
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local VirtualUser      = game:GetService("VirtualUser")
local VIM              = game:GetService("VirtualInputManager")
local TeleportService  = game:GetService("TeleportService")
local HttpService      = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Lighting         = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- ════════════════════════════ 3. TRẠNG THÁI CHUNG ═════════════════════════
local State = {
        -- Farm bí ngô
        FarmPumpkin     = false,
        FarmMode        = "Tới gần từng bí ngô",
        TweenSpeed      = 250,   -- MAX 250 (an toàn anti-cheat)
        MaxFarmDistance = 350,   -- bán kính vùng farm quanh điểm neo
        StandDist       = 4,
        HitRange        = 30,
        HitDelay        = 0.12,
        AutoBuso        = true,
        FastAttack      = false, -- mặc định M1 ngườn thật
        Noclip          = true,
        PickupDrops     = true,
        PickupRadius    = 60,
        PickupKeywords  = "candy,corn,pumpkin,bit,spooky,treat",
        StatusText      = "Tắt",

        -- Anti-ban
        AntiBanY        = true,
        LowHPPercent    = 40,    -- dưới 40% máu → bay lên tránh
        HighHPPercent   = 80,    -- trên 80% → quay lại farm
        DodgeSkill      = true,  -- tự né skill quái

        -- ESP
        ESP             = false,
        ESPPatch        = false,
        ESPDistance     = true,
        ESPMaxRange     = 0,
        ESPFill         = Color3.fromRGB(255, 100, 0),
        ESPOutline      = Color3.fromRGB(255, 200, 0),

        -- Sự kiện
        TrickOrTreat    = false,
        SkipLockedDoor  = true,  -- gõ trúng nhà khóa → đổi nhà khác
        KnockKeywords   = "knock,door,trick,treat,halloween,candy",
        KnockRadius     = 2500,
        DoorAnytime     = false, -- true = gõ cửa mọi lúc (bỏ khung giờ)
        Gacha           = false,
        GachaKeywords   = "roll,gacha,witch,brew,potion,haunt,spooky",

        -- Khác
        AntiAFK         = true,
        NoFX            = false,
        HideUIFarm      = true,
        AlwaysToast     = true,  -- luôn hiện toast thông báo (độc lập Library)
}

local Connections = {}
local Library -- gán ở mục nạp thư viện

-- ════════════════════════════ 4. TOAST (thông báo luôn hiện) ══════════════
-- Một số executor / phiên bản Library không render Notify → mình tự toast.
local ToastParent, ToastContainer

local function getToastParent()
        if ToastParent and ToastParent.Parent then return ToastParent end
        local parent
        pcall(function()
                if gethui then
                        local ok, ui = pcall(gethui)
                        if ok and ui then parent = ui end
                end
                if not parent then parent = game:GetService("CoreGui") end
        end)
        if not parent then parent = LocalPlayer:WaitForChild("PlayerGui") end
        ToastParent = parent

        local old = parent:FindFirstChild("MZ_Toast_GUI")
        if old then old:Destroy() end
        local gui = Instance.new("ScreenGui")
        gui.Name = "MZ_Toast_GUI"
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 999
        gui.Parent = parent

        local list = Instance.new("Frame")
        list.Name = "List"
        list.AnchorPoint = Vector2.new(1, 1)
        list.Position = UDim2.new(1, -12, 1, -12)
        list.Size = UDim2.new(0, 300, 0, 0)
        list.AutomaticSize = Enum.AutomaticSize.Y
        list.BackgroundTransparency = 1
        list.Parent = gui

        local lay = Instance.new("UIListLayout")
        lay.VerticalAlignment = Enum.VerticalAlignment.Bottom
        lay.Padding = UDim.new(0, 6)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        lay.Parent = list

        ToastContainer = list
        return parent
end

local TOAST_COLORS = {
        info    = Color3.fromRGB(80, 170, 255),
        success = Color3.fromRGB(90, 220, 130),
        warning = Color3.fromRGB(255, 180, 60),
        error   = Color3.fromRGB(255, 90, 90),
}

local function toast(title, content, typ)
        if not State.AlwaysToast then return end
        pcall(function()
                getToastParent()
                if not ToastContainer then return end
                while #ToastContainer:GetChildren() > 5 do
                        local first = ToastContainer:FindFirstChildWhichIsA("Frame")
                        if first then first:Destroy() else break end
                end
                local color = TOAST_COLORS[typ] or TOAST_COLORS.info

                local f = Instance.new("Frame")
                f.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
                f.BackgroundTransparency = 0.08
                f.BorderSizePixel = 0
                f.Size = UDim2.new(1, 0, 0, 0)
                f.AutomaticSize = Enum.AutomaticSize.Y
                f.Parent = ToastContainer

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 8)
                corner.Parent = f
                local stroke = Instance.new("UIStroke")
                stroke.Color = color
                stroke.Thickness = 1.5
                stroke.Transparency = 0.25
                stroke.Parent = f
                local pad = Instance.new("UIPadding")
                pad.PaddingTop = UDim.new(0, 8)
                pad.PaddingBottom = UDim.new(0, 8)
                pad.PaddingLeft = UDim.new(0, 10)
                pad.PaddingRight = UDim.new(0, 10)
                pad.Parent = f

                local t = Instance.new("TextLabel")
                t.BackgroundTransparency = 1
                t.Size = UDim2.new(1, 0, 0, 14)
                t.Font = Enum.Font.GothamBold
                t.TextSize = 13
                t.TextXAlignment = Enum.TextXAlignment.Left
                t.TextColor3 = color
                t.Text = tostring(title)
                t.Parent = f

                local c = Instance.new("TextLabel")
                c.BackgroundTransparency = 1
                c.Position = UDim2.new(0, 0, 0, 16)
                c.Size = UDim2.new(1, 0, 0, 0)
                c.AutomaticSize = Enum.AutomaticSize.Y
                c.Font = Enum.Font.Gotham
                c.TextSize = 12
                c.TextWrapped = true
                c.TextXAlignment = Enum.TextXAlignment.Left
                c.TextColor3 = Color3.fromRGB(230, 230, 235)
                c.Text = tostring(content or "")
                c.Parent = f

                f.BackgroundTransparency = 1
                f.Position = UDim2.new(0, 40, 0, 0)
                TweenService:Create(f, TweenInfo.new(0.25), {
                        BackgroundTransparency = 0.08,
                        Position = UDim2.new(0, 0, 0, 0),
                }):Play()
                task.delay(5, function()
                        if f.Parent then
                                local tw = TweenService:Create(f, TweenInfo.new(0.3), { BackgroundTransparency = 1 })
                                tw:Play()
                                tw.Completed:Connect(function() pcall(function() f:Destroy() end) end)
                        end
                end)
        end)
end

local function notify(title, content, typ)
        -- gọi Library (nếu được) + toast riêng để chắc chắn user thấy
        pcall(function()
                if Library and Library.Notify then
                        Library:Notify({ Title = title, Content = content, Duration = 5, Type = typ or "info" })
                end
        end)
        toast(title, content, typ)
end

-- ════════════════════════════ 5. TIỆN ÍCH NHÂN VẬT ════════════════════════
local function getChar() return LocalPlayer.Character end

local function getRoot()
        local c = LocalPlayer.Character
        return c and (c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart)
end

local function getHum()
        local c = LocalPlayer.Character
        return c and c:FindFirstChildOfClass("Humanoid")
end

local function hpPercent()
        local h = getHum()
        if not h or h.MaxHealth <= 0 then return 100 end
        return (h.Health / h.MaxHealth) * 100
end

-- ════════════════════════════ 6. TWEEN (max 250 + jitter chống ban) ═══════
local MZ_Tween = { token = 0, running = false, _fv = nil }

local function setFloatForce(root, on)
        if MZ_Tween._fv then
                pcall(function() MZ_Tween._fv:Destroy() end)
                MZ_Tween._fv = nil
        end
        if not root then return end
        local old = root:FindFirstChild("MZ_FloatForce")
        if on then
                if not old then
                        local fv = Instance.new("BodyVelocity")
                        fv.Name = "MZ_FloatForce"
                        fv.Velocity = Vector3.new(0, 0, 0)
                        fv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                        fv.P = 1e4
                        fv.Parent = root
                        MZ_Tween._fv = fv
                end
        elseif old then
                old:Destroy()
        end
end

function MZ_Tween.cancel()
        MZ_Tween.token = MZ_Tween.token + 1
        MZ_Tween.running = false
end

local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Exclude
RayParams.IgnoreWater = false
local rayBuildClock = 0

local function groundYAt(pos)
        local now = os.clock()
        if now - rayBuildClock > 2 then
                rayBuildClock = now
                local list = {}
                local c = getChar()
                if c then table.insert(list, c) end
                local folder = workspace:FindFirstChild("Characters")
                if folder then table.insert(list, folder) end
                RayParams.FilterDescendantsInstances = list
        end
        local hit = workspace:Raycast(
                Vector3.new(pos.X, pos.Y + 60, pos.Z), Vector3.new(0, -500, 0), RayParams)
        if hit then return hit.Position.Y, (hit.Material == Enum.Material.Water) end
        return nil, false
end

function MZ_Tween.to(targetCFrame, speed, stopDist, groundSafe)
        local root, char, hum = getRoot(), getChar(), getHum()
        if not (root and char and hum) or typeof(targetCFrame) ~= "CFrame" then return false end

        MZ_Tween.cancel()
        MZ_Tween.running = true
        local myToken = MZ_Tween.token
        setFloatForce(root, true)

        -- GIỚI HẠN CỨNG 250 studs/s + jitter nhỏ như ngườn thật
        speed = math.clamp((tonumber(speed) or 250) * (0.92 + math.random() * 0.16), 20, 250)
        stopDist = tonumber(stopDist) or 4
        local goalPos = targetCFrame.Position
        local startTime = os.clock()
        local maxTime = (root.Position - goalPos).Magnitude / speed + 12
        local lastDist, lastProgress = math.huge, os.clock()
        local ok = false

        while MZ_Tween.running and myToken == MZ_Tween.token do
                local dt = RunService.Heartbeat:Wait()
                local c = LocalPlayer.Character
                local r = c and (c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart)
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if not (c and r and h) or h.Health <= 0 or r.Parent ~= c then break end
                if os.clock() - startTime > maxTime then break end

                local cur = r.Position
                local delta = goalPos - cur
                local dist = delta.Magnitude

                if dist < lastDist - 1 then
                        lastDist, lastProgress = dist, os.clock()
                elseif os.clock() - lastProgress > 5 then
                        break -- kẹt quá 5s → thoát, caller tự blacklist
                end

                if dist <= stopDist then
                        r.CFrame = targetCFrame
                        ok = true
                        break
                end

                local step = math.min(speed * dt, dist)
                local newPos = cur + delta.Unit * step

                if groundSafe ~= false then
                        local gY, isWater = groundYAt(newPos)
                        if gY then
                                local minY = gY + (isWater and 3.5 or 3)
                                if newPos.Y < minY then
                                        newPos = Vector3.new(newPos.X, minY, newPos.Z)
                                end
                        end
                end

                r.CFrame = CFrame.new(newPos)
                r.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                r.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end

        setFloatForce(getRoot(), false)
        if myToken == MZ_Tween.token then MZ_Tween.running = false end
        return ok
end

-- ════════════════════════════ 7. NOCLIP (cache — giảm lag) ════════════════
local noclipParts, noclipChar, noclipClock = {}, nil, 0
table.insert(Connections, RunService.Stepped:Connect(function()
        if not State.Noclip then return end
        local c = LocalPlayer.Character
        if not c then return end
        if c ~= noclipChar or os.clock() - noclipClock > 1 then
                noclipChar = c
                noclipClock = os.clock()
                noclipParts = {}
                for _, p in ipairs(c:GetDescendants()) do
                        if p:IsA("BasePart") then table.insert(noclipParts, p) end
                end
        end
        for _, p in ipairs(noclipParts) do
                if p.Parent and p.CanCollide then p.CanCollide = false end
        end
end))

-- ════════════════════════════ 8. ANTI-AFK ═════════════════════════════════
table.insert(Connections, LocalPlayer.Idled:Connect(function()
        if State.AntiAFK then
                pcall(function()
                        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                        task.wait(1)
                        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                end)
        end
end))

-- ════════════════════════════ 9. ANTI-BAN (theo phong cách Banana Cat) ════
local DangerY = false   -- đang bay lên tránh (máu yếu)
local Dodging = false   -- đang né skill

-- Teleport-Y khi máu yếu + né skill: cập nhật liên tục, farm loop phải nhường
table.insert(Connections, RunService.Heartbeat:Connect(function()
        local root, hum = getRoot(), getHum()
        if not (root and hum) or hum.Health <= 0 then return end

        -- 1) Teleport Y khi máu yếu
        if State.AntiBanY then
                local hp = hpPercent()
                if hp < State.LowHPPercent then
                        DangerY = true
                elseif hp > State.HighHPPercent then
                        DangerY = false
                end
                if DangerY and not MZ_Tween.running then
                        local p = root.Position
                        root.CFrame = CFrame.new(p.X, p.Y + 800, p.Z)
                        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
        else
                DangerY = false
        end
end))

-- 2) Tự né skill quái: thấy quái cast (BodyGyro/BodyPosition/KiBlast) → bật nhảy
pcall(function()
        workspace:WaitForChild("Enemies", 10).DescendantAdded:Connect(function(d)
                if not State.DodgeSkill then return end
                if Dodging then return end
                local n = d.Name
                if n == "BodyGyro" or n == "BodyPosition" or n == "KiBlastFireShort" or n == "KiBlast" then
                        local mob = d:FindFirstAncestorOfClass("Model")
                        if mob and mob:FindFirstChild("HumanoidRootPart") and getRoot() then
                                local d2 = (mob.HumanoidRootPart.Position - getRoot().Position).Magnitude
                                if d2 < 60 then
                                        Dodging = true
                                        task.delay(3, function() Dodging = false end)
                                end
                        end
                end
        end)
end)

-- ════════════════════════════ 10. REMOTE FAST ATTACK (giữ nguyên) ══════════
local RegisterAttack, RegisterHit, CombatUtil, MouseSwing
do
        pcall(function()
                local Net = game:GetService("ReplicatedStorage")
                        :WaitForChild("Modules", 9):WaitForChild("Net", 9)
                RegisterAttack = Net:WaitForChild("RE/RegisterAttack", 9)
                local okNet = pcall(function()
                        RegisterHit = Net:RemoteEvent("RegisterHit", true)
                end)
                if not okNet or not RegisterHit then
                        RegisterHit = Net:WaitForChild("RE/RegisterHit", 9)
                end
        end)
        pcall(function()
                CombatUtil = require(game:GetService("ReplicatedStorage")
                        :WaitForChild("Modules"):WaitForChild("CombatUtil"))
        end)
        pcall(function()
                local mm = require(game:GetService("ReplicatedStorage"):WaitForChild("Mouse", 9))
                if type(mm) == "table" and type(mm.FireServer) == "function" then MouseSwing = mm end
        end)
end

-- ════════════════════════════ 11. QUÉT MAP (cache duy nhất) ═══════════════
local MZ_World = { built = 0, sig = "", pumpkins = {}, patches = {}, drops = {}, prompts = {} }
local blacklist = {}     -- [model] = hết hạn cấm (quả giả 120s / khó tới 45s)
local pumpkinPatch = {}  -- [pumpkinModel] = patchModel cha (để hỏi "thuộc patch nào")

local function splitCsv(csv)
        local list = {}
        for kw in (csv or ""):lower():gmatch("[^,]+") do
                kw = kw:match("^%s*(.-)%s*$")
                if kw ~= "" then table.insert(list, kw) end
        end
        return list
end

local function matchKeyword(text, csv)
        text = (text or ""):lower()
        for kw in (csv or ""):lower():gmatch("[^,]+") do
                kw = kw:match("^%s*(.-)%s*$")
                if kw ~= "" and text:find(kw, 1, true) then return true end
        end
        return false
end

local function isPumpkinModelPart(p)
        local anc = p:FindFirstAncestorOfClass("Model")
        while anc do
                if anc.Name:lower():find("pumpkin") then return true end
                anc = anc:FindFirstAncestorOfClass("Model")
        end
        return false
end

local function worldSignature()
        return (State.PickupKeywords or "") .. "|" .. (State.KnockKeywords or "")
                .. "|" .. (State.GachaKeywords or "")
end

local pickupKw = splitCsv(State.PickupKeywords)

local function refreshWorld(force)
        local now = os.clock()
        local sig = worldSignature()
        if not force and (now - MZ_World.built) < 1.2 and MZ_World.sig == sig then
                return MZ_World
        end
        MZ_World.built = now
        MZ_World.sig = sig
        pickupKw = splitCsv(State.PickupKeywords)

        local pumpkins, patches, drops, prompts = {}, {}, {}, {}
        local myChar = LocalPlayer.Character
        pumpkinPatch = {}

        for _, d in ipairs(workspace:GetDescendants()) do
                local cls = d.ClassName
                if cls == "Model" then
                        local ln = d.Name:lower()
                        local compact = ln:gsub("[^%w]", "")
                        if compact == "pumpkinpatch" then
                                table.insert(patches, d)
                        elseif compact == "pumpkin" then
                                -- chỉ nhận bí ngô NẰM TRONG patch (scan sau khi có đủ patches)
                                table.insert(pumpkins, d)
                        end
                elseif cls == "ProximityPrompt" then
                        table.insert(prompts, d)
                elseif cls == "BasePart" then
                        if #pickupKw > 0 then
                                local name = d.Name:lower()
                                for _, kw in ipairs(pickupKw) do
                                        if name:find(kw, 1, true) then
                                                if not (myChar and d:IsDescendantOf(myChar))
                                                        and not isPumpkinModelPart(d) then
                                                        table.insert(drops, d)
                                                end
                                                break
                                        end
                                end
                        end
                end
        end

        -- gắn bí ngô vào patch chứa nó (dùng BoundingBox)
        local patchBoxes = {}
        for _, p in ipairs(patches) do
                local ok, cf, size = pcall(function() return p:GetBoundingBox() end)
                if ok and cf and size and size.Magnitude > 0 then
                        table.insert(patchBoxes, { patch = p, cf = cf, size = size })
                else
                        local r = p.PrimaryPart or p:FindFirstChildWhichIsA("BasePart", true)
                        if r then
                                table.insert(patchBoxes, {
                                        patch = p, cf = r.CFrame, size = Vector3.new(200, 120, 200),
                                })
                        end
                end
        end
        local inPumpkins = {}
        for _, m in ipairs(pumpkins) do
                local r = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart", true)
                if r then
                        for _, box in ipairs(patchBoxes) do
                                local lp = box.cf:PointToObjectSpace(r.Position)
                                if math.abs(lp.X) <= box.size.X * 0.5 + 40
                                        and math.abs(lp.Z) <= box.size.Z * 0.5 + 40
                                        and math.abs(lp.Y) <= box.size.Y * 0.5 + 80 then
                                        pumpkinPatch[m] = box.patch
                                        table.insert(inPumpkins, m)
                                        break
                                end
                        end
                end
        end

        MZ_World.pumpkins = inPumpkins
        MZ_World.patches  = patches
        MZ_World.drops    = drops
        MZ_World.prompts  = prompts

        for m, t in pairs(blacklist) do
                if now > t or m.Parent == nil then blacklist[m] = nil end
        end
        return MZ_World
end

local function modelRoot(model)
        if not model then return nil end
        return model.PrimaryPart
                or model:FindFirstChild("HumanoidRootPart", true)
                or model:FindFirstChild("RootPart", true)
                or model:FindFirstChildWhichIsA("BasePart", true)
end

local function pumpkinUsable(model)
        if not model or model.Parent == nil then return false end
        local bl = blacklist[model]
        if bl and os.clock() < bl then return false end
        local r = modelRoot(model)
        if not r then return false end
        local hum = model:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then return false end
        return pumpkinPatch[model] ~= nil -- BẮT BUỘC thuộc patch
end

-- ════════════════════════════ 12. ĐÁNH (M1 ngườn thật + remote fallback) ═══
local STYLE_NAMES = {
        "Combat", "Black Leg", "Electro", "Fishman Karate", "Dragon Talon",
        "Superhuman", "Electric Claw", "Death Step", "Sharkman Karate",
        "Godhuman", "Sanguine Art",
}

local function isStyleTool(t)
        if not t then return false end
        local n = ((t.Name or "") .. " " .. (t.ToolTip or "")):lower()
        for _, name in ipairs(STYLE_NAMES) do
                if n:find(name:lower(), 1, true) then return true end
        end
        return false
end

local function equippedStyle()
        local char = getChar()
        local held = char and char:FindFirstChildOfClass("Tool")
        if held and isStyleTool(held) then return held end
        return nil
end

local StyleNotFoundNotified = false

local function equipFightingStyle()
        local char, hum = getChar(), getHum()
        if not (char and hum) or hum.Health <= 0 then return end
        if equippedStyle() then return end
        local tool
        for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") and isStyleTool(t) then tool = t break end
        end
        if not tool then
                local bp = LocalPlayer:FindFirstChild("Backpack")
                if bp then
                        for _, t in ipairs(bp:GetChildren()) do
                                if t:IsA("Tool") and isStyleTool(t) then tool = t break end
                        end
                end
        end
        if tool and not hum.Sit then
                pcall(function() hum:EquipTool(tool) end)
        elseif not tool and not StyleNotFoundNotified then
                StyleNotFoundNotified = true
                notify("Fighting Style", "Không thấy Fighting Style → M1 có thể không ăn. Hãy trang bị Combat trở lên!", "warning")
        end
end

local function faceTarget(pos)
        local root = getRoot()
        if not root then return end
        local flat = Vector3.new(pos.X, root.Position.Y, pos.Z)
        if (flat - root.Position).Magnitude > 0.5 then
                pcall(function() root.CFrame = CFrame.lookAt(root.Position, flat) end)
        end
end

local function aimCamera(pos)
        pcall(function()
                local cam = workspace.CurrentCamera
                if cam then cam.CFrame = CFrame.lookAt(cam.CFrame.Position, pos) end
        end)
end

local function pumpkinSnapshot(model)
        local s = { parts = 0, health = nil }
        pcall(function()
                local hum = model:FindFirstChildOfClass("Humanoid")
                if hum then s.health = hum.Health end
                for _, p in ipairs(model:GetDescendants()) do
                        if p:IsA("BasePart") then s.parts = s.parts + 1 end
                end
        end)
        return s
end

local function snapshotChanged(a, b)
        if not a or not b then return true end
        if a.health and b.health and math.abs(a.health - b.health) > 0.01 then return true end
        if a.parts ~= b.parts then return true end
        return false
end

local AtkMethod = State.FastAttack and "remote" or "m1"

local function hitPumpkinRemote(model, myPos)
        if not (RegisterHit and CombatUtil) then return false end
        local hitList = {}
        for _, p in ipairs(model:GetDescendants()) do
                if p:IsA("BasePart") and (p.Position - myPos).Magnitude <= State.HitRange + 15 then
                        local rig = nil
                        pcall(function() rig = CombatUtil:GetRigOfHitPart(p) end)
                        if rig then table.insert(hitList, { rig, p }) end
                end
        end
        if #hitList == 0 then return false end
        local first = table.remove(hitList, 1)
        return pcall(function()
                if MouseSwing then MouseSwing:FireServer(0.35) end
                if RegisterAttack then RegisterAttack:FireServer(0) end
                RegisterHit:FireServer(first[2], hitList)
        end)
end

local function pointInHub(x, y)
        local ok, res = pcall(function()
                local sg = Library and Library._ScreenGui
                if not sg or not sg.Enabled then return false end
                for _, f in ipairs(sg:GetChildren()) do
                        if f:IsA("Frame") and f.Visible
                                and f.AbsoluteSize.X > 50 and f.AbsoluteSize.Y > 30 then
                                local px, py = f.AbsolutePosition.X, f.AbsolutePosition.Y
                                if x >= px and x <= px + f.AbsoluteSize.X
                                        and y >= py and y <= py + f.AbsoluteSize.Y then
                                        return true
                                end
                        end
                end
                return false
        end)
        return ok and res or false
end

local function safeClickPoint()
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        local vp = cam.ViewportSize
        local candidates = {
                Vector2.new(vp.X * 0.50, vp.Y * 0.50),
                Vector2.new(vp.X * 0.50, vp.Y * 0.40),
                Vector2.new(vp.X * 0.50, vp.Y * 0.60),
                Vector2.new(vp.X * 0.38, vp.Y * 0.50),
                Vector2.new(vp.X * 0.62, vp.Y * 0.50),
                Vector2.new(vp.X * 0.30, vp.Y * 0.38),
                Vector2.new(vp.X * 0.70, vp.Y * 0.38),
                Vector2.new(vp.X * 0.30, vp.Y * 0.62),
                Vector2.new(vp.X * 0.70, vp.Y * 0.62),
                Vector2.new(vp.X * 0.20, vp.Y * 0.50),
                Vector2.new(vp.X * 0.80, vp.Y * 0.50),
                Vector2.new(vp.X * 0.08, vp.Y * 0.50),
                Vector2.new(vp.X * 0.92, vp.Y * 0.50),
        }
        for _, c in ipairs(candidates) do
                local blocked = pointInHub(c.X, c.Y)
                if not blocked then
                        local okG, guis = pcall(function()
                                return UserInputService:GetGuiObjectsAtPosition(c.X, c.Y)
                        end)
                        if okG and type(guis) == "table" and #guis > 0 then blocked = true end
                end
                if not blocked then return c end
        end
        return nil
end

local function hitPumpkinM1(aimPos)
        aimCamera(aimPos)
        if VIM then
                local pt = safeClickPoint()
                if pt then
                        local x = pt.X + math.random(-8, 8)
                        local y = pt.Y + math.random(-6, 6)
                        pcall(function() VIM:SendMouseMoveEvent(x, y, game) end)
                        task.wait(0.02)
                        pcall(function() VIM:SendMouseButtonEvent(x, y, 0, true, game, 1) end)
                        task.wait(0.04 + math.random() * 0.05)
                        pcall(function() VIM:SendMouseButtonEvent(x, y, 0, false, game, 1) end)
                        return
                end
        end
        local char = getChar()
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool then pcall(function() tool:Activate() end) end
end

local function doHit(model, aimPos, myPos)
        if AtkMethod == "remote" and hitPumpkinRemote(model, myPos or aimPos) then return "remote" end
        hitPumpkinM1(aimPos)
        return "m1"
end

-- ════════════════════════════ 13. AUTO BUSO ═══════════════════════════════
local CommF = nil
pcall(function()
        CommF = game:GetService("ReplicatedStorage")
                :WaitForChild("Remotes", 9):WaitForChild("CommF_", 9)
end)

local function ffcMatch(container, pattern)
        if not container then return nil end
        for _, c in ipairs(container:GetChildren()) do
                if string.match(c.Name, pattern) then return c end
        end
        return nil
end

local function busoActive()
        local c = getChar()
        if not c then return true end
        return ffcMatch(c, "_BusoLayer1") ~= nil or c:FindFirstChild("HasBuso") ~= nil
end

local function enableBuso()
        if not CommF then return false end
        if not busoActive() then
                return pcall(function() CommF:InvokeServer("Buso") end)
        end
        return true
end

local BusoGen = 0
local busoFails, busoWarned = 0, false

local function busoLoop()
        BusoGen = BusoGen + 1
        local myGen = BusoGen
        while State.AutoBuso and myGen == BusoGen do
                local ok, err = pcall(function()
                        local c = getChar()
                        if c and not busoActive() then
                                enableBuso()
                                task.wait(1.5)
                                if busoActive() then
                                        busoFails = 0
                                else
                                        busoFails = busoFails + 1
                                        if busoFails >= 3 and not busoWarned then
                                                busoWarned = true
                                                notify("Auto Buso",
                                                        "Không bật được Buso — chưa mua Haki Buso ($25k) hoặc hết năng lượng Haki.",
                                                        "warning")
                                        end
                                end
                        end
                end)
                if not ok then warn("[MZ] busoLoop:", tostring(err)) end
                task.wait(1)
        end
end

-- ════════════════════════════ 14. AUTO FARM (FIX TELE KHÙNG) ══════════════
local function safeStandPos(pos)
        local gY, isWater = groundYAt(pos)
        local baseY = pos.Y
        if gY then baseY = math.max(baseY, gY + (isWater and 1.5 or 0.5)) end
        return Vector3.new(pos.X, baseY + 3.5, pos.Z)
end

-- Chọn quả gần nhất TRONG VÙNG FARM. Trả về: model, dist, patch
local function pickNearest(rootPos, origin)
        local best, bestD, bestPatch = nil, math.huge, nil
        for _, m in ipairs(MZ_World.pumpkins) do
                if pumpkinUsable(m) then
                        local r = modelRoot(m)
                        if r then
                                local d = (r.Position - rootPos).Magnitude
                                local dOrigin = (r.Position - origin).Magnitude
                                if dOrigin <= State.MaxFarmDistance and d < bestD then
                                        best, bestD, bestPatch = m, d, pumpkinPatch[m]
                                end
                        end
                end
        end
        return best, bestD, bestPatch
end

-- Patch còn bí ngô hợp lệ gần nhất (để di chuyển vùng farm hợp lý)
local function nearestPatchWithPumpkins(fromPos)
        local best, bestD = nil, math.huge
        for _, m in ipairs(MZ_World.pumpkins) do
                if pumpkinUsable(m) then
                        local r = modelRoot(m)
                        if r then
                                local d = (r.Position - fromPos).Magnitude
                                if d < bestD then best, bestD = r.Position, d end
                        end
                end
        end
        return best, bestD
end

local FarmGen = 0

local function smashUntilDead(target, myGen)
        local startClock = os.clock()
        local hits, noProgress = 0, 0
        local lastSnap = pumpkinSnapshot(target)
        local hasHum = (target:FindFirstChildOfClass("Humanoid") ~= nil)

        while State.FarmPumpkin and (not myGen or myGen == FarmGen) do
                if DangerY or Dodging then
                        State.StatusText = "Đang né/chạy máu..."
                        task.wait(0.5)
                        return false
                end
                local char, root = getChar(), getRoot()
                if not (char and root) then return false end
                if not target or target.Parent == nil then return true end
                local hum = target:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health <= 0 then return true end
                local rp = modelRoot(target)
                if not rp then return true end

                -- quả lăn ra khỏi patch / bị nhặt nhầm → bỏ (KHÔNG đuổi khùng)
                if pumpkinPatch[target] == nil then return false end

                local distNow = (rp.Position - root.Position).Magnitude
                if distNow > math.max(State.StandDist or 4, 3) + 9 then
                        local flat = Vector3.new(root.Position.X - rp.Position.X, 0, root.Position.Z - rp.Position.Z)
                        if flat.Magnitude < 0.1 then flat = Vector3.new(1, 0, 0) end
                        State.StatusText = "Bị văng ra → bay lại sát bí ngô..."
                        MZ_Tween.to(CFrame.new(safeStandPos(rp.Position + flat.Unit
                                * math.clamp(State.StandDist or 4, 3, 12))), State.TweenSpeed, 3, true)
                        if not State.FarmPumpkin or (myGen and myGen ~= FarmGen) then return false end
                elseif distNow > State.HitRange + 10 then
                        return false
                end

                if os.clock() - startClock > 35 then
                        blacklist[target] = os.clock() + 120 -- quá lâu → quả giả
                        return false
                end

                equipFightingStyle()
                faceTarget(rp.Position)
                doHit(target, rp.Position, root.Position)
                hits = hits + 1

                task.wait(AtkMethod == "m1"
                        and (math.max(State.HitDelay, 0.30) + math.random() * 0.12)
                        or math.max(State.HitDelay, 0.06))

                if hits % 4 == 0 then
                        if not target.Parent then return true end
                        State.StatusText = string.format("Đang đập bí ngô (hit %d, %s)...",
                                hits, AtkMethod == "m1" and "M1 ảo" or "remote")
                        local snap = pumpkinSnapshot(target)
                        if snapshotChanged(snap, lastSnap) then
                                noProgress = 0
                        else
                                noProgress = noProgress + 4
                        end
                        lastSnap = snap

                        local budget = hasHum and 12 or (AtkMethod == "remote" and 48 or 24)
                        if noProgress >= budget then
                                if AtkMethod == "remote" then
                                        AtkMethod = "m1"
                                        noProgress = 0
                                        notify("Fast Attack", "Remote không ăn damage → chuyển sang M1 ảo.", "warning")
                                else
                                        blacklist[target] = os.clock() + 120
                                        return false
                                end
                        end
                end
        end
        return false
end

local function farmLoop()
        FarmGen = FarmGen + 1
        local myGen = FarmGen
        local originChar, farmOrigin = nil, nil
        local idleCycles = 0

        while State.FarmPumpkin and myGen == FarmGen do
                local ok, err = pcall(function()
                        local char, root, hum = getChar(), getRoot(), getHum()
                        if not (char and root and hum) or hum.Health <= 0 then
                                State.StatusText = "Chờ hồi sinh..."
                                MZ_Tween.cancel()
                                task.wait(1)
                                return
                        end

                        if DangerY then
                                State.StatusText = "Máu yếu — đang bay lên tránh (anti-ban)..."
                                task.wait(0.5)
                                return
                        end
                        if Dodging then
                                State.StatusText = "Đang né skill quái..."
                                local p = root.Position
                                MZ_Tween.to(CFrame.new(p.X, p.Y + 200, p.Z), 250, 5, false)
                                task.wait(0.5)
                                return
                        end

                        -- Đang giờ vàng Trick-or-Treat → nhường quyền cho doorLoop
                        if State.TrickOrTreat and isDoorWindow() and not State.DoorAnytime then
                                State.StatusText = "Giờ vàng Trick-or-Treat → đang gõ cửa..."
                                task.wait(1)
                                return
                        end

                        if char ~= originChar then
                                originChar = char
                                farmOrigin = root.Position
                        end

                        refreshWorld()

                        local target, dist = pickNearest(root.Position, farmOrigin)
                        if not target then
                                -- vùng hiện tại cạn kiệt → TÍNH TOÁN di chuyển sang cụm bí ngô gần nhất
                                idleCycles = idleCycles + 1
                                refreshWorld(true)
                                local clusterPos, clusterDist = nearestPatchWithPumpkins(root.Position)
                                if clusterPos and clusterDist > State.MaxFarmDistance then
                                        State.StatusText = string.format("Vùng cạn bí ngô → di chuyển tới cụm mới (%.0fm)", clusterDist)
                                        equipFightingStyle()
                                        MZ_Tween.to(CFrame.new(safeStandPos(clusterPos)), State.TweenSpeed, 8, true)
                                        farmOrigin = getRoot() and getRoot().Position or farmOrigin
                                        idleCycles = 0
                                elseif clusterPos then
                                        farmOrigin = clusterPos -- cụm trong tầm nhưng bị blacklist hết → đổi neo
                                        idleCycles = 0
                                        State.StatusText = "Bí ngô trong vùng đang bị cấm tạm — chờ..."
                                        task.wait(1)
                                else
                                        State.StatusText = "Không còn bí ngô trong map — chờ respawn..."
                                        task.wait(2)
                                end
                                return
                        end
                        idleCycles = 0

                        local rp = modelRoot(target)
                        if not rp then return end

                        local offsetDir = (root.Position - rp.Position)
                        local standDist = math.clamp(State.StandDist or 4, 3, 12) + math.random() * 0.8
                        local reached = true

                        if offsetDir.Magnitude < 0.1 then
                                pcall(function()
                                        getRoot().CFrame = CFrame.new(safeStandPos(
                                                rp.Position + Vector3.new(standDist, 0, 0)))
                                end)
                        else
                                local flat = Vector3.new(offsetDir.X, 0, offsetDir.Z)
                                if flat.Magnitude < 0.1 then flat = Vector3.new(1, 0, 0) end
                                local goal = CFrame.new(safeStandPos(rp.Position + flat.Unit * standDist))
                                State.StatusText = string.format("Đang bay tới bí ngô (%.0fm)", dist)
                                equipFightingStyle()
                                reached = MZ_Tween.to(goal, State.TweenSpeed, 3.5, true)
                        end

                        if not State.FarmPumpkin then return end

                        if reached then
                                State.StatusText = "Đang đập bí ngô..."
                                smashUntilDead(target, myGen)
                        else
                                -- không tới được → cấm quả 45s, KHÔNG tele loạn
                                blacklist[target] = os.clock() + 45
                                State.StatusText = "Không tới được quả này → bỏ qua..."
                                task.wait(0.3)
                        end
                        task.wait(0.1)
                end)
                if not ok then
                        warn("[MZ] farmLoop:", tostring(err))
                        State.StatusText = "Lỗi nhỏ — tự tiếp tục..."
                        task.wait(0.5)
                end
        end
        if myGen == FarmGen then State.StatusText = "Tắt" end
end

-- ════════════════════════════ 15. NHẶT ĐỒ ═════════════════════════════════
local PickupGen = 0
local function pickupLoop()
        PickupGen = PickupGen + 1
        local myGen = PickupGen
        while State.PickupDrops and myGen == PickupGen do
                local ok = pcall(function()
                        local root, myChar = getRoot(), LocalPlayer.Character
                        if root and myChar then
                                refreshWorld()
                                for _, p in ipairs(MZ_World.drops) do
                                        if not State.PickupDrops then break end
                                        if p.Parent then
                                                local d = (p.Position - root.Position).Magnitude
                                                if d <= State.PickupRadius then
                                                        local fired = pcall(function()
                                                                firetouchinterest(root, p, 0)
                                                                firetouchinterest(root, p, 1)
                                                        end)
                                                        if not fired and d <= State.PickupRadius
                                                                and not MZ_Tween.running and not State.FarmPumpkin then
                                                                pcall(function()
                                                                        root.CFrame = CFrame.new(p.Position + Vector3.new(0, 2, 0))
                                                                end)
                                                        end
                                                        task.wait(0.12)
                                                end
                                        end
                                end
                        end
                end)
                if not ok then task.wait(1) end
                task.wait(0.35)
        end
end

-- ════════════════════════════ 16. TRICK-OR-TREAT (cửa, locked, giờ vàng) ═══
local lockedDoors  = {}  -- [doorKey] = hết hạn cấm
local doorFiredAt  = {}  -- [doorKey] = giờ đã gõ
local lastDoorKey  = nil

-- khung giờ vàng: phút 0–9 mỗi giờ (Harvest Moon ~10 phút)
local function isDoorWindow()
        if State.DoorAnytime then return true end
        local t = os.date("*t")
        return t.min < 10
end

-- tìm chữ "Locked" trong UI dialogue sau khi gõ
local function scanLockedDialogue()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return false end
        for _, d in ipairs(pg:GetDescendants()) do
                if d:IsA("TextLabel") and d.Visible and d.Text ~= "" then
                        if d.Text:lower():find("locked", 1, true) then return true end
                end
        end
        return false
end

local function doorKeyOf(prompt)
        local holder = prompt.Parent
        local anc = holder and holder:FindFirstAncestorOfClass("Model")
        return anc or holder or prompt
end

local function firePrompt(prompt)
        local fired = false
        if type(fireproximityprompt) == "function" then
                fired = pcall(fireproximityprompt, prompt)
        end
        if not fired then
                pcall(function()
                        prompt:InputHoldBegin()
                        task.wait((prompt.HoldDuration or 0) + 0.15)
                        prompt:InputHoldEnd()
                end)
        end
end

local function promptPart(prompt)
        local holder = prompt.Parent
        if not holder then return nil end
        if holder:IsA("BasePart") then return holder end
        return holder:FindFirstChildWhichIsA("BasePart", true)
end

local function findBestDoor(rootPos, maxDist)
        local best, bestD, bestPart, bestKey = nil, math.huge, nil, nil
        for _, pr in ipairs(MZ_World.prompts) do
                if pr.Enabled and pr.Parent then
                        local key = doorKeyOf(pr)
                        local lk = lockedDoors[key]
                        if not (lk and os.clock() < lk) then
                                local label = table.concat({
                                        pr.Name, pr.ActionText or "", pr.ObjectText or "",
                                        pr.Parent and pr.Parent.Name or "",
                                }, " ")
                                if matchKeyword(label, State.KnockKeywords) then
                                        local part = promptPart(pr)
                                        if part then
                                                local d = (part.Position - rootPos).Magnitude
                                                if d <= maxDist and d < bestD then
                                                        best, bestD, bestPart, bestKey = pr, d, part, key
                                                end
                                        end
                                end
                        end
                end
        end
        return best, bestD, bestPart, bestKey
end

local DoorGen = 0
local function doorLoop()
        DoorGen = DoorGen + 1
        local myGen = DoorGen
        local notifyNoDoor = false

        while State.TrickOrTreat and myGen == DoorGen do
                local ok, err = pcall(function()
                        local root = getRoot()
                        if not root then task.wait(1) return end
                        if DangerY or Dodging then task.wait(0.5) return end

                        refreshWorld()
                        local window = isDoorWindow()

                        -- Khi farm bật và KHÔNG trong giờ vàng: chỉ gõ cửa trong tầm
                        local maxDist = State.KnockRadius
                        if State.FarmPumpkin and not window then
                                maxDist = State.HitRange + 30
                        end

                        local door, dist, part, key = findBestDoor(root.Position, maxDist)
                        if not door then
                                if window and not notifyNoDoor then
                                        notifyNoDoor = true
                                        notify("Trick-or-Treat", "Đang trong giờ vàng nhưng không thấy cửa trong bán kính " .. maxDist .. " studs.", "warning")
                                end
                                if not window then notifyNoDoor = false end
                                State.DoorStatusText = "Không có cửa trong tầm..."
                                task.wait(1.5)
                                return
                        end
                        notifyNoDoor = false

                        -- mỗi nhà chỉ gõ 1 lần / giờ
                        local hourKey = os.date("*t").hour
                        if doorFiredAt[key] == hourKey and not State.DoorAnytime then
                                lockedDoors[key] = os.clock() + 300 -- cho qua giờ mới
                                task.wait(0.5)
                                return
                        end

                        -- bay tới cửa (khi được phép đi xa)
                        if dist > 10 then
                                State.DoorStatusText = string.format("Đang bay tới cửa (%.0fm)...", dist)
                                if State.FarmPumpkin and not window then
                                        -- farm đang bật, ngoài giờ vàng: không đi xa
                                        task.wait(1)
                                        return
                                end
                                local away = (root.Position - part.Position)
                                if away.Magnitude > 0.1 then
                                        local goal = part.CFrame + away.Unit * 5
                                        MZ_Tween.to(CFrame.new(safeStandPos(goal.Position)), State.TweenSpeed, 4, true)
                                end
                        end

                        if not (door.Enabled and door.Parent) then task.wait(0.5) return end

                        -- GÕ
                        doorFiredAt[key] = hourKey
                        lastDoorKey = key
                        faceTarget(part.Position)
                        State.DoorStatusText = "Đang gõ cửa..."
                        firePrompt(door)

                        -- CHECK LOCKED sau 3 giây
                        local firedKey = key
                        task.delay(3, function()
                                if not State.TrickOrTreat then return end
                                if State.SkipLockedDoor and scanLockedDialogue() then
                                        lockedDoors[firedKey] = os.clock() + 120
                                        notify("Trick-or-Treat", "🚪 Cửa bị KHÓA (Locked) → tự đổi sang nhà khác!", "warning")
                                end
                        end)
                        task.wait(2)
                end)
                if not ok then
                        warn("[MZ] doorLoop:", tostring(err))
                        task.wait(1)
                end
        end
end

-- ════════════════════════════ 17. GACHA / PHÙ THỦY ════════════════════════
local GachaGen = 0
local gachaLastFired = 0
local function gachaLoop()
        GachaGen = GachaGen + 1
        local myGen = GachaGen
        while State.Gacha and myGen == GachaGen do
                local ok, err = pcall(function()
                        local root = getRoot()
                        if not root then task.wait(1) return end
                        if DangerY or Dodging then task.wait(0.5) return end
                        refreshWorld()

                        local maxDist = State.KnockRadius
                        if State.FarmPumpkin then
                                if MZ_Tween.running then task.wait(1) return end
                                maxDist = State.HitRange + 30 -- farm bật: chỉ bấm trong tầm
                        end

                        local best, bestD, bestPart = nil, math.huge, nil
                        for _, pr in ipairs(MZ_World.prompts) do
                                if pr.Enabled and pr.Parent then
                                        local label = table.concat({
                                                pr.Name, pr.ActionText or "", pr.ObjectText or "",
                                                pr.Parent and pr.Parent.Name or "",
                                        }, " ")
                                        if matchKeyword(label, State.GachaKeywords) then
                                                local part = promptPart(pr)
                                                if part then
                                                        local d = (part.Position - root.Position).Magnitude
                                                        if d <= maxDist and d < bestD then
                                                                best, bestD, bestPart = pr, d, part
                                                        end
                                                end
                                        end
                                end
                        end

                        if not best then
                                State.GachaStatusText = "Không thấy Gacha/Phù Thủy trong tầm..."
                                task.wait(1.5)
                                return
                        end

                        if bestD > 10 and not State.FarmPumpkin then
                                local away = (root.Position - bestPart.Position)
                                if away.Magnitude > 0.1 then
                                        local goal = bestPart.CFrame + away.Unit * 5
                                        MZ_Tween.to(CFrame.new(safeStandPos(goal.Position)), State.TweenSpeed, 4, true)
                                end
                        end

                        if os.clock() - gachaLastFired < 6 then task.wait(1) return end
                        if best.Enabled and best.Parent then
                                gachaLastFired = os.clock()
                                faceTarget(bestPart.Position)
                                firePrompt(best)
                                State.GachaStatusText = "Đã bấm Gacha/Phù Thủy!"
                                task.wait(2)
                        end
                end)
                if not ok then
                        warn("[MZ] gachaLoop:", tostring(err))
                        task.wait(1)
                end
        end
end

-- ════════════════════════════ 18. ESP ═════════════════════════════════════
local ESPObjects = {}

local function espRemove(model)
        local o = ESPObjects[model]
        if o then
                pcall(function() if o.hl then o.hl:Destroy() end end)
                pcall(function() if o.bb then o.bb:Destroy() end end)
                ESPObjects[model] = nil
        end
end

local function espClearAll()
        for m in pairs(ESPObjects) do espRemove(m) end
        ESPObjects = {}
end

local ESP_CAP = 100

local function espApply(model, kind)
        if ESPObjects[model] then return end
        local n = 0
        for _ in pairs(ESPObjects) do
                n = n + 1
                if n >= ESP_CAP then return end
        end
        local r = modelRoot(model)
        if not r then return end
        local hl = Instance.new("Highlight")
        hl.Name = "MZ_Halloween_ESP"
        hl.FillColor = State.ESPFill
        hl.OutlineColor = State.ESPOutline
        hl.FillTransparency = 0.25
        hl.OutlineTransparency = 0
        hl.Adornee = model
        hl.Parent = model

        local bb = Instance.new("BillboardGui")
        bb.Name = "MZ_Halloween_ESP_Tag"
        bb.Adornee = r
        bb.Size = UDim2.new(0, 170, 0, 30)
        bb.StudsOffset = Vector3.new(0, 3.5, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 2500

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = kind == "patch" and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 170, 60)
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextScaled = true
        label.Text = kind == "patch" and "🎃 PumpkinPatch" or "🎃 Pumpkin"
        label.Parent = bb
        bb.Parent = r
        ESPObjects[model] = { hl = hl, bb = bb, label = label, kind = kind }
end

local function espScan()
        local cam = workspace.CurrentCamera
        local camPos = cam and cam.CFrame.Position
        local maxR = State.ESPMaxRange
        refreshWorld()

        if State.ESP then
                for _, m in ipairs(MZ_World.pumpkins) do
                        local r = modelRoot(m)
                        if r and camPos and (maxR <= 0 or (r.Position - camPos).Magnitude <= maxR) then
                                espApply(m, "pumpkin")
                        end
                end
        end
        if State.ESPPatch then
                for _, m in ipairs(MZ_World.patches) do
                        local r = modelRoot(m)
                        if r and camPos and (maxR <= 0 or (r.Position - camPos).Magnitude <= maxR) then
                                espApply(m, "patch")
                        end
                end
        end

        for m, o in pairs(ESPObjects) do
                local dead = m.Parent == nil
                if not dead and camPos then
                        local r = modelRoot(m)
                        if not r or (o.kind == "pumpkin" and not State.ESP)
                                or (o.kind == "patch" and not State.ESPPatch)
                                or (maxR > 0 and (r.Position - camPos).Magnitude > maxR + 50) then
                                dead = true
                        end
                end
                if dead then espRemove(m) end
        end
end

local EspGen = 0
local function espLoop()
        EspGen = EspGen + 1
        local myGen = EspGen
        while (State.ESP or State.ESPPatch) and myGen == EspGen do
                pcall(espScan)
                task.wait(2)
        end
        if myGen == EspGen then espClearAll() end
end

local EspLabelGen = 0
local function espLabelLoop()
        EspLabelGen = EspLabelGen + 1
        local myGen = EspLabelGen
        while (State.ESP or State.ESPPatch) and myGen == EspLabelGen do
                local cam = workspace.CurrentCamera
                local camPos = cam and cam.CFrame.Position
                if camPos then
                        for m, o in pairs(ESPObjects) do
                                local r = modelRoot(m)
                                pcall(function()
                                        if r and o.label then
                                                if State.ESPDistance then
                                                        o.label.Text = (o.kind == "patch" and "🎃 Patch • " or "🎃 Pumpkin • ")
                                                                .. tostring(math.floor((r.Position - camPos).Magnitude + 0.5)) .. "m"
                                                else
                                                        o.label.Text = o.kind == "patch" and "🎃 PumpkinPatch" or "🎃 Pumpkin"
                                                end
                                        end
                                end)
                        end
                end
                task.wait(0.4)
        end
end

-- ════════════════════════════ 19. GIẢM LAG / NO FX ════════════════════════
local NOFX_CLASSES = {
        ParticleEmitter = true, Fire = true, Smoke = true, Sparkles = true,
        PointLight = true, SurfaceLight = true, SpotLight = true,
}
local nofxConn = nil

local function nofxSweep(container)
        for _, d in ipairs(container:GetDescendants()) do
                if NOFX_CLASSES[d.ClassName] then
                        pcall(function() d.Enabled = false end)
                end
        end
end

local function setNoFX(on)
        if on then
                if not nofxConn then
                        nofxConn = workspace.DescendantAdded:Connect(function(d)
                                if NOFX_CLASSES[d.ClassName] then
                                        task.defer(function()
                                                if d.Parent then pcall(function() d.Enabled = false end) end
                                        end)
                                end
                        end)
                        table.insert(Connections, nofxConn)
                end
                nofxSweep(workspace)
        end
end

-- ════════════════════════════ 20. HOP SERVER ══════════════════════════════
getgenv().MZ_VisitedServers = getgenv().MZ_VisitedServers or {}

local function serverList()
        local servers = {}
        local cursor = ""
        for _ = 1, 3 do
                local url = "https://games.roblox.com/v1/games/" .. game.PlaceId
                        .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true"
                        .. (cursor ~= "" and ("&cursor=" .. cursor) or "")
                local ok, res = pcall(function()
                        return HttpService:JSONDecode(game:HttpGet(url))
                end)
                if not ok or type(res) ~= "table" or type(res.data) ~= "table" then break end
                for _, s in ipairs(res.data) do
                        if s.id ~= game.JobId and (s.playing or 0) < (s.maxPlayers or 0) then
                                table.insert(servers, s.id)
                        end
                end
                cursor = res.nextPageCursor or ""
                if cursor == "" then break end
        end
        return servers
end

local function hopServer()
        local visited = getgenv().MZ_VisitedServers
        local list = serverList()
        local fresh = {}
        for _, id in ipairs(list) do
                if not visited[id] then table.insert(fresh, id) end
        end
        local pool = (#fresh > 0) and fresh or list
        if #pool == 0 then
                notify("Hop Server", "Không tìm thấy server nào khác!", "error")
                return
        end
        local job = pool[math.random(1, #pool)]
        visited[job] = true
        local n = 0
        for id in pairs(visited) do
                n = n + 1
                if n > 20 then visited[id] = nil end
        end
        notify("Hop Server", "Đang chuyển server...", "info")
        task.wait(0.5)
        pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, job, LocalPlayer)
        end)
end

-- ════════════════════════════ 21. NẠP THƯ VIỆN MEIZU + UI ════════════════
Library = getgenv().MeizuLibrary
if not Library then
        Library = loadstring(game:HttpGet(MEIZU_LIBRARY_URL))()
        getgenv().MeizuLibrary = Library
end

local Window = Library:CreateWindow({
        Title = "Meizu Hub",
        SubTitle = "Halloween Event 2026 🎃 v2.5",
        Theme = "Midnight",
        Accent = Color3.fromRGB(255, 120, 0),
        ToggleKeybind = Enum.KeyCode.LeftControl,
        Size = UDim2.fromOffset(640, 470),
})

-- ─── TAB: FARM BÍ NGÔ ───
local TabFarm = Window:CreateTab("Farm Bí Ngô")
local SecStatus = TabFarm:CreateSection("Trạng Thái")

local statusPara = SecStatus:CreateParagraph({
        Title = "🎃 Jack O' Lantern Hunt",
        Content = "Bí ngô: ... | Trạng thái: Tắt",
})

local SecFarm = TabFarm:CreateSection("Auto Farm Bí Ngô")

SecFarm:CreateToggle({
        Title = "Bật Auto Farm Bí Ngô",
        Description = "Chỉ farm bí ngô trong PumpkinPatch, giới hạn vùng, không tele loạn. Khi cạn vùng sẽ tự di chuyển sang cụm gần nhất.",
        Default = false,
        Callback = function(v)
                State.FarmPumpkin = v
                if v then
                        task.spawn(farmLoop)
                        if State.PickupDrops then task.spawn(pickupLoop) end
                        notify("Farm Bí Ngô", "✅ Đã BẬT auto farm bí ngô!", "success")
                        if State.HideUIFarm and Window.IsOpen and Window:IsOpen() then
                                task.delay(1.5, function()
                                        if State.FarmPumpkin and Window.IsOpen and Window:IsOpen() then
                                                pcall(function() Window:Toggle(false) end)
                                                notify("Farm Bí Ngô", "Đã thu nhỏ Hub — nhấn CTRL TRÁI để mở lại.", "info")
                                        end
                                end)
                        end
                else
                        MZ_Tween.cancel()
                        State.StatusText = "Tắt"
                        notify("Farm Bí Ngô", "Đã TẮT auto farm.", "warning")
                end
        end,
})

SecFarm:CreateToggle({
        Title = "Tự Bật Buso Haki (Aura)",
        Default = true,
        Callback = function(v)
                State.AutoBuso = v
                if v then
                        enableBuso()
                        task.spawn(busoLoop)
                        notify("Auto Buso", "Đã bật tự động Buso Haki.", "info")
                end
        end,
})

SecFarm:CreateSlider({
        Title = "Khoảng cách đứng khi đập",
        Description = "Đứng SÁT CẠNH bí ngô để M1 không trượt (3–5 là sát nhất)",
        Min = 3, Max = 12, Default = State.StandDist, Rounding = 1, Suffix = " studs",
        Callback = function(v) State.StandDist = v end,
})

SecFarm:CreateDropdown({
        Title = "Chế độ farm",
        Options = { "Tới gần từng bí ngô", "Đập trong tầm (tự đuổi khi trống)" },
        Default = State.FarmMode,
        Callback = function(opt) State.FarmMode = opt end,
})

SecFarm:CreateSlider({
        Title = "Tốc độ di chuyển (tối đa 250)",
        Min = 100, Max = 250, Default = State.TweenSpeed, Rounding = 0, Suffix = " studs/s",
        Callback = function(v) State.TweenSpeed = math.min(v, 250) end,
})

SecFarm:CreateSlider({
        Title = "Bán kính farm quanh điểm neo",
        Description = "Giới hạn vùng săn bí ngô — tránh đuổi xuyên map",
        Min = 100, Max = 2000, Default = State.MaxFarmDistance, Rounding = 0, Suffix = " studs",
        Callback = function(v) State.MaxFarmDistance = v end,
})

SecFarm:CreateSlider({
        Title = "Tầm đập",
        Min = 10, Max = 80, Default = State.HitRange, Rounding = 0, Suffix = " studs",
        Callback = function(v) State.HitRange = v end,
})

SecFarm:CreateSlider({
        Title = "Delay mỗi hit",
        Min = 0.05, Max = 1, Default = State.HitDelay, Rounding = 2, Suffix = "s",
        Callback = function(v) State.HitDelay = v end,
})

SecFarm:CreateToggle({
        Title = "Chế độ Remote (RegisterHit)",
        Description = "MẶC ĐỊNH TẮT — server đa số CHẶN remote với bí ngô. Để TẮT = M1 giả lập ngườn thật.",
        Default = false,
        Callback = function(v)
                State.FastAttack = v
                AtkMethod = v and "remote" or "m1"
                notify("Fast Attack", v and "Đang dùng remote — nếu không mất máu thì TẮT lại." or "Đã chuyển về M1 ảo.", v and "warning" or "info")
        end,
})

SecFarm:CreateToggle({
        Title = "Noclip khi farm",
        Default = true,
        Callback = function(v) State.Noclip = v end,
})

SecFarm:CreateToggle({
        Title = "Tự nhặt đồ rơi",
        Default = true,
        Callback = function(v)
                State.PickupDrops = v
                if v and (State.FarmPumpkin or State.TrickOrTreat) then task.spawn(pickupLoop) end
        end,
})

SecFarm:CreateToggle({
        Title = "Tự thu nhỏ Hub khi farm",
        Description = "Ẩn UI chống click ảo bấm nhầm nút. Ctrl trái mở lại.",
        Default = true,
        Callback = function(v)
                State.HideUIFarm = v
                if not v and Window.IsOpen and not Window:IsOpen() then
                        pcall(function() Window:Toggle(true) end)
                end
        end,
})

SecFarm:CreateSlider({
        Title = "Bán kính nhặt đồ",
        Min = 20, Max = 300, Default = State.PickupRadius, Rounding = 0, Suffix = " studs",
        Callback = function(v) State.PickupRadius = v end,
})

SecFarm:CreateInput({
        Title = "Từ khóa đồ rơi (phân cách ,)",
        Placeholder = "candy,corn,pumpkin,bit,spooky",
        Default = State.PickupKeywords,
        Callback = function(text) State.PickupKeywords = text or "" end,
})

-- ─── TAB: ANTI-BAN ───
local TabBan = Window:CreateTab("Anti-Ban")
local SecBan = TabBan:CreateSection("Chống Ban (mượn ý tưởng Banana Cat Hub)")

SecBan:CreateParagraph({
        Title = "🛡️ Cơ chế",
        Content = "• Teleport-Y: máu yếu → tự bay lên cao tránh bị combo chết\n"
                .. "• Tự né skill: thấy quái cast (BodyGyro/BodyPosition/KiBlast) → nhảy lên né\n"
                .. "• Jitter tốc độ bay ±8% như ngườn thật, giới hạn cứng 250 studs/s\n"
                .. "• Nhịp M1 ngẫu nhiên 0.30–0.42s, chuột jitter ±8px",
})

SecBan:CreateToggle({
        Title = "Teleport-Y khi máu yếu",
        Description = "Máu dưới ngưỡng → bay lên 800 studs, hồi trên 80% mới quay lại farm",
        Default = true,
        Callback = function(v)
                State.AntiBanY = v
                notify("Anti-Ban", v and "Đã BẬT Teleport-Y." or "Đã TẮT Teleport-Y.", v and "success" or "warning")
        end,
})

SecBan:CreateSlider({
        Title = "Ngưỡng máu yếu",
        Min = 10, Max = 90, Default = State.LowHPPercent, Rounding = 0, Suffix = " %",
        Callback = function(v) State.LowHPPercent = v end,
})

SecBan:CreateSlider({
        Title = "Ngưỡng hồi lại farm",
        Min = 50, Max = 100, Default = State.HighHPPercent, Rounding = 0, Suffix = " %",
        Callback = function(v) State.HighHPPercent = v end,
})

SecBan:CreateToggle({
        Title = "Tự né skill quái",
        Description = "Thấy quái cast skill gần → tự nhảy lên né 3 giây",
        Default = true,
        Callback = function(v)
                State.DodgeSkill = v
                notify("Anti-Ban", v and "Đã BẬT tự né skill." or "Đã TẮT tự né skill.", v and "success" or "warning")
        end,
})

-- ─── TAB: ESP ───
local TabESP = Window:CreateTab("ESP Bí Ngô")
local SecESPMain = TabESP:CreateSection("ESP Pumpkin")

SecESPMain:CreateToggle({
        Title = "ESP Bí Ngô",
        Default = false,
        Callback = function(v)
                State.ESP = v
                task.spawn(espLoop)
                task.spawn(espLabelLoop)
                notify("ESP", v and "Đã BẬT ESP bí ngô." or "Đã TẮT ESP bí ngô.", "info")
        end,
})

SecESPMain:CreateToggle({
        Title = "ESP PumpkinPatch (vùng)",
        Default = false,
        Callback = function(v)
                State.ESPPatch = v
                task.spawn(espLoop)
                task.spawn(espLabelLoop)
        end,
})

SecESPMain:CreateToggle({
        Title = "Hiện khoảng cách",
        Default = true,
        Callback = function(v) State.ESPDistance = v end,
})

SecESPMain:CreateSlider({
        Title = "Bán kính hiện ESP",
        Min = 0, Max = 5000, Default = 0, Rounding = 0, Suffix = " studs (0 = vô hạn)",
        Callback = function(v) State.ESPMaxRange = v end,
})

local SecESPColor = TabESP:CreateSection("Màu ESP")

SecESPColor:CreateColorPicker({
        Title = "Màu fill",
        Default = State.ESPFill,
        Callback = function(c)
                State.ESPFill = c
                for _, o in pairs(ESPObjects) do pcall(function() o.hl.FillColor = c end) end
        end,
})

SecESPColor:CreateColorPicker({
        Title = "Màu viền",
        Default = State.ESPOutline,
        Callback = function(c)
                State.ESPOutline = c
                for _, o in pairs(ESPObjects) do pcall(function() o.hl.OutlineColor = c end) end
        end,
})

SecESPColor:CreateButton({
        Title = "Làm mới ESP",
        Callback = function()
                espClearAll()
                task.spawn(espScan)
                notify("ESP", "Đã làm mới ESP!", "success")
        end,
})

-- ─── TAB: SỰ KIỆN ───
local TabEvent = Window:CreateTab("Sự Kiện")
local SecEventInfo = TabEvent:CreateSection("Thông Tin Event Hellfire")

SecEventInfo:CreateParagraph({
        Title = "👻 Halloween 2026",
        Content = "• Mỗi đầu giờ (XX:00) map tối → gõ CỬA nhận Candy Corn (khung ~10 phút)\n"
                .. "• Đập bí ngô bằng Fighting Style bất kỳ lúc nào\n"
                .. "• Gacha 500 Candy Corn/lượt (2 lượt/giờ)\n"
                .. "• Giải lớn: Mutation Hellfire Gas 🔥",
})

local SecDoor = TabEvent:CreateSection("Auto Gõ Cửa (Trick-or-Treat)")
local doorStatusPara = SecDoor:CreateParagraph({
        Title = "🚪 Trạng thái cửa",
        Content = "Tắt",
})

SecDoor:CreateToggle({
        Title = "Bật Auto Gõ Cửa",
        Description = "Đầu giờ (phút 0–9): tự bay đi gõ cửa trong bán kính — FARM TỰ NHƯỜNG QUYỀN. Ngoài giờ: chỉ gõ cửa trong tầm khi farm bật.",
        Default = false,
        Callback = function(v)
                State.TrickOrTreat = v
                if v then
                        task.spawn(doorLoop)
                        if State.PickupDrops then task.spawn(pickupLoop) end
                        notify("Trick-or-Treat", "✅ Đã BẬT auto gõ cửa! Đến đầu giờ sẽ tự đi gõ (farm sẽ tạm nghỉ).", "success")
                else
                        notify("Trick-or-Treat", "Đã TẮT auto gõ cửa.", "warning")
                end
        end,
})

SecDoor:CreateToggle({
        Title = "Đổi nhà khi bị KHÓA (Locked)",
        Description = "Gõ trúng nhà Locked Door → tự cấm nhà đó 120s và chuyển sang nhà khác",
        Default = true,
        Callback = function(v)
                State.SkipLockedDoor = v
                notify("Trick-or-Treat", v and "Đã BẬT tự đổi nhà khi bị khóa." or "Đã TẮT đổi nhà khi bị khóa.", "info")
        end,
})

SecDoor:CreateToggle({
        Title = "Gõ cửa MỌI LÚC (bỏ khung giờ)",
        Description = "Mặc định OFF: chỉ ưu tiên gõ cửa vào phút 0–9 mỗi giờ. Bật nếu server bạn chạy khung giờ khác.",
        Default = false,
        Callback = function(v)
                State.DoorAnytime = v
                notify("Trick-or-Treat", v and "Sẽ gõ cửa mọi lúc (có thể phí công ngoài giờ)." or "Chỉ ưu tiên cửa vào đầu giờ.", "info")
        end,
})

SecDoor:CreateInput({
        Title = "Từ khóa cửa (phân cách ,)",
        Placeholder = "knock,door,trick,treat",
        Default = State.KnockKeywords,
        Callback = function(text) State.KnockKeywords = text or "" end,
})

SecDoor:CreateSlider({
        Title = "Bán kính quét cửa",
        Min = 100, Max = 15000, Default = State.KnockRadius, Rounding = 0, Suffix = " studs",
        Callback = function(v) State.KnockRadius = v end,
})

local SecGacha = TabEvent:CreateSection("Auto Gacha / Phù Thủy")
local gachaStatusPara = SecGacha:CreateParagraph({
        Title = "🔮 Trạng thái gacha",
        Content = "Tắt",
})

SecGacha:CreateToggle({
        Title = "Bật Auto Gacha (Witch)",
        Description = "Tự tìm Phù Thủy/nút Gacha gần nhất và bấm (cần đủ Candy Corn)",
        Default = false,
        Callback = function(v)
                State.Gacha = v
                if v then
                        task.spawn(gachaLoop)
                        notify("Gacha", "✅ Đã BẬT auto gacha!", "success")
                else
                        notify("Gacha", "Đã TẮT auto gacha.", "warning")
                end
        end,
})

SecGacha:CreateInput({
        Title = "Từ khóa gacha (phân cách ,)",
        Placeholder = "roll,gacha,witch,brew,potion",
        Default = State.GachaKeywords,
        Callback = function(text) State.GachaKeywords = text or "" end,
})

-- ─── TAB: KHÁC ───
local TabMisc = Window:CreateTab("Khác")
local SecMisc = TabMisc:CreateSection("Tiện Ích")

SecMisc:CreateToggle({
        Title = "Anti-AFK",
        Default = true,
        Callback = function(v) State.AntiAFK = v end,
})

SecMisc:CreateToggle({
        Title = "Giảm Lag (Tắt FX an toàn)",
        Description = "Tắt particle/lửa/khói/đèn — KHÔNG đụng Beam/Trail",
        Default = false,
        Callback = function(v)
                State.NoFX = v
                pcall(function() setNoFX(v) end)
                if v then notify("Giảm Lag", "Đã tắt FX an toàn.", "success") end
        end,
})

SecMisc:CreateToggle({
        Title = "Toast thông báo (luôn hiện)",
        Description = "Hiện thông báo góc màn hình độc lập với Library — bật nếu trước đây không thấy thông báo",
        Default = true,
        Callback = function(v)
                State.AlwaysToast = v
                notify("Toast", v and "Toast ĐANG BẬT — bạn sẽ luôn thấy thông báo." or "Toast đã tắt.", "info")
        end,
})

SecMisc:CreateParagraph({
        Title = "🛠️ Về lỗi console",
        Content = "• 'CChain: out of radius' → do bật Chế độ Remote. Mặc định đã TẮT.\n"
                .. "• 'Disabled is not a valid member of ... Rage' → lỗi game Blox Fruits, không liên quan script.\n"
                .. "• 'StartBeam / PartType' → lỗi hiệu ứng Hellfire của game, bật Giảm Lag để đỡ.",
})

SecMisc:CreateButton({
        Title = "Hop Server (random)",
        Callback = function() task.spawn(hopServer) end,
})

SecMisc:CreateButton({
        Title = "Rejoin Server",
        Callback = function()
                notify("Rejoin", "Đang vào lại server...", "info")
                task.wait(0.4)
                pcall(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                end)
        end,
})

SecMisc:CreateButton({
        Title = "Gỡ Script (Unload)",
        Callback = function()
                if getgenv().MZ_Halloween_Unload then getgenv().MZ_Halloween_Unload() end
        end,
})

SecMisc:CreateParagraph({
        Title = "ℹ️ Credits",
        Content = "Meizu Library & Hub — Nttp1721\nKỹ thuật tham khảo: Banana Cat Hub\nESP gốc: FixedPumpkinESP",
})

-- ════════════════════════════ 22. VÒNG TRẠNG THÁI ═════════════════════════
task.spawn(function()
        while true do
                pcall(function()
                        refreshWorld()
                        if statusPara and statusPara.SetContent then
                                statusPara:SetContent(string.format(
                                        "🎃 Bí ngô (trong patch): %d   |   📍 Patch: %d\n🎯 Trạng thái: %s",
                                        #MZ_World.pumpkins, #MZ_World.patches, State.StatusText or "Tắt"))
                        end
                        if doorStatusPara and doorStatusPara.SetContent then
                                local windowText = isDoorWindow() and "🔥 ĐANG TRONG GIỜ VÀNG (phút 0–9)" or "⏳ Ngoài giờ vàng"
                                doorStatusPara:SetContent(windowText .. "\n" .. (State.DoorStatusText or "Tắt"))
                        end
                        if gachaStatusPara and gachaStatusPara.SetContent then
                                gachaStatusPara:SetContent(State.GachaStatusText or "Tắt")
                        end
                end)
                task.wait(1)
        end
end)

-- ════════════════════════════ 23. UNLOAD ══════════════════════════════════
getgenv().MZ_Halloween_Unload = function()
        State.FarmPumpkin = false
        State.ESP = false
        State.ESPPatch = false
        State.TrickOrTreat = false
        State.Gacha = false
        State.PickupDrops = false
        State.AutoBuso = false
        MZ_Tween.cancel()
        espClearAll()
        for _, c in ipairs(Connections) do
                pcall(function() c:Disconnect() end)
        end
        Connections = {}
        pcall(function() if ToastParent then ToastParent:Destroy() end end)
        pcall(function() Library:Destroy() end)
        getgenv().MZ_Halloween_Unload = nil
        print("[MZ Halloween] Đã gỡ script.")
end

-- ════════════════════════════ 24. KHỞI ĐỘNG ═══════════════════════════════
Window:SelectTab(1)
refreshWorld(true)
getToastParent()
if State.AutoBuso then task.spawn(busoLoop) end
notify("Meizu Hub 🎃", "Đã nạp Halloween Event 2026 v2.5!\nBật [Farm Bí Ngô] để bắt đầu.", "success")
print("[MZ Halloween] Loaded v2.5 — fix tele khùng + anti-ban + locked door | Library: Meizu")
