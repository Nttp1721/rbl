-- Language: Luau, file: BFHalloween2026.lua
-- Target: Blox Fruits (Roblox) — Halloween 2026 Event
-- Library: MeizuLibrary v2.2 (Nttp1721/rbl)
-- Features: Pumpkin ESP · PumpkinPatch ESP · Hellfire Gas ESP
--           Door ESP · Auto Farm Pumpkin · Auto Trick-or-Treat
--           Auto Haunted Gacha · FastWalk · Noclip · Anti-AFK
-- Remote names (HalloweenGacha, ToT door prompts) — re-derive in-game
--   if they differ; use the Debug → Print Models button to check.
-- Pumpkin attack uses VirtualInputManager M1 + firetouchinterest fallback.
-- ToT door interaction: fireproximityprompt scan in radius after teleport.
-- TweenTo: coroutine-stepped CFrame move (mirrors meizublf BackupTween).

-- ================================================================
-- 1. GUARD: one instance only
-- ================================================================
if getgenv().__BF_HALLOWEEN_LOADED then return end
getgenv().__BF_HALLOWEEN_LOADED = true

-- ================================================================
-- 2. SERVICES
-- ================================================================
local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local RunService      = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser     = game:GetService("VirtualUser")
local VirtualInput    = game:GetService("VirtualInputManager")

local lp   = Players.LocalPlayer
local RS   = game:GetService("ReplicatedStorage")
local CommF

-- CommF_ wait with timeout (in case of server delay)
task.spawn(function()
    local ok, cf = pcall(function()
        return RS:WaitForChild("Remotes", 10):WaitForChild("CommF_", 10)
    end)
    if ok then CommF = cf end
end)

-- ================================================================
-- 3. LIBRARY LOAD
-- ================================================================
local LIBRARY_URL = "https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/MeizuLibrary.lua"
local Library = getgenv().MeizuLibrary
if not Library then
    Library = loadstring(game:HttpGet(LIBRARY_URL))()
    getgenv().MeizuLibrary = Library
end

-- ================================================================
-- 4. ACTIVE STATE (non-persistent runtime toggles)
-- ================================================================
local Active = {
    PumpkinESP     = false,
    PatchESP       = false,
    BossESP        = false,
    DoorESP        = false,
    AutoFarmPumpkin = false,
    AutoToT        = false,
    AutoGacha      = false,
    FastWalk       = false,
    FastJump       = false,
    Noclip         = false,
    FarmSpeed      = 200,
    WalkSpeed      = 50,
    JumpPower      = 100,
    ToTSea         = "Sea 1 (Center Town)",
}

-- ================================================================
-- 5. WINDOW
-- ================================================================
local Window = Library:CreateWindow({
    Title         = "Halloween 2026",
    SubTitle      = "Blox Fruits Event Hub",
    Theme         = "Midnight",
    Accent        = Color3.fromRGB(255, 90, 0),
    ToggleKeybind = Enum.KeyCode.RightControl,
    Size          = UDim2.fromOffset(640, 470),
})

-- ================================================================
-- 6. UTILITY
-- ================================================================
local function getChar()  return lp.Character end
local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function isAlive()
    local h = getHum()
    return h and h.Health > 0
end

-- Coroutine tween to CFrame (BackupTween pattern from meizublf)
-- Moves HRP in small steps per Heartbeat so Noclip keeps working
local function TweenTo(targetCF, speed)
    speed = speed or 200
    local hrp = getHRP()
    if not hrp or not targetCF then return end
    local dist = (targetCF.Position - hrp.Position).Magnitude
    if dist < 4 then return end
    local dur  = dist / speed
    local tween = TweenService:Create(hrp, TweenInfo.new(dur, Enum.EasingStyle.Linear), {CFrame = targetCF})
    tween:Play()
    tween.Completed:Wait()
    tween:Destroy()
end

-- VirtualInputManager M1 click at viewport center (meizublf doClick pattern)
local function doM1Click()
    local vp = workspace.CurrentCamera.ViewportSize
    local x  = vp.X * 0.5
    local y  = vp.Y * 0.5
    pcall(function()
        VirtualInput:SendMouseButtonEvent(x, y, 0, true,  game, 1)
        VirtualInput:SendMouseButtonEvent(x, y, 0, false, game, 1)
    end)
end

-- Camera face toward position (so M1 hits the right target)
local function lookAt(pos)
    pcall(function()
        local hrp = getHRP()
        if not hrp then return end
        workspace.CurrentCamera.CFrame = CFrame.new(hrp.Position, pos)
    end)
end

-- firetouchinterest fallback (prop pumpkins that use touch damage)
local function touchAttack(model)
    local hrp = getHRP()
    if not hrp then return end
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(firetouchinterest, hrp, part, 0)
            task.wait(0.03)
            pcall(firetouchinterest, hrp, part, 1)
        end
    end
end

-- Fire all ProximityPrompts on a model (ToT doors)
local function firePrompts(model)
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            pcall(fireproximityprompt, v)
        end
    end
end

-- Find nearest Model by name list — returns (model, distance)
local FIND_RANGE = 2000
local function findNearest(nameSet)
    local hrp = getHRP()
    if not hrp then return nil, math.huge end
    local best, bestDist = nil, FIND_RANGE
    for _, item in ipairs(workspace:GetDescendants()) do
        if item:IsA("Model") and nameSet[item.Name] then
            local root = item:FindFirstChild("HumanoidRootPart")
                      or item:FindFirstChildWhichIsA("BasePart", true)
            if root then
                local d = (root.Position - hrp.Position).Magnitude
                if d < bestDist then
                    bestDist, best = d, item
                end
            end
        end
    end
    return best, bestDist
end

-- ================================================================
-- 7. ESP SYSTEM
-- ================================================================
local ESP_TAGS = {
    PumpkinHL   = "PumpkinHL_ESP",
    PatchHL     = "PatchHL_ESP",
    PatchLabel  = "PumpkinPatchText_ESP",
    BossHL      = "BossHL_ESP",
    BossLabel   = "BossText_ESP",
    DoorHL      = "DoorHL_ESP",
    DoorLabel   = "DoorText_ESP",
}

local function addHighlight(model, tag, fill, outline, fillAlpha)
    if model:FindFirstChild(tag) then return end
    local hl = Instance.new("Highlight")
    hl.Name             = tag
    hl.FillColor        = fill    or Color3.fromRGB(255, 100, 0)
    hl.OutlineColor     = outline or Color3.fromRGB(255, 200, 0)
    hl.FillTransparency = fillAlpha or 0.2
    hl.OutlineTransparency = 0
    hl.Adornee          = model
    hl.Parent           = model
end

local function addBillboard(model, tag, text, color)
    if model:FindFirstChild(tag) then return end
    local part = model:FindFirstChild("RootPart")
              or model:FindFirstChildWhichIsA("BasePart", true)
    if not part then return end
    local bb  = Instance.new("BillboardGui")
    bb.Name         = tag
    bb.Adornee      = part
    bb.Size         = UDim2.fromOffset(200, 50)
    bb.StudsOffset  = Vector3.new(0, 4, 0)
    bb.AlwaysOnTop  = true
    local lbl       = Instance.new("TextLabel")
    lbl.Parent              = bb
    lbl.Size                = UDim2.fromScale(1, 1)
    lbl.BackgroundTransparency = 1
    lbl.Text                = text
    lbl.TextColor3          = color or Color3.fromRGB(255, 215, 0)
    lbl.TextStrokeColor3    = Color3.fromRGB(0, 0, 0)
    lbl.TextStrokeTransparency = 0
    lbl.Font                = Enum.Font.GothamBold
    lbl.TextScaled          = true
    bb.Parent = model
end

local function clearTag(tag)
    for _, item in ipairs(workspace:GetDescendants()) do
        if item.Name == tag then
            pcall(function() item:Destroy() end)
        end
    end
end

-- Boss name candidates (re-derive in-game if needed)
local BOSS_NAMES = {
    HellfireGas = true,
    HellFireGas = true,
    Hellfire_Gas = true,
    ["HellFire Gas"] = true,
    ["Hellfire Gas"] = true,
}

-- ESP loop — runs on Heartbeat when any ESP is on
local espConn
local function rebuildESP()
    if espConn then espConn:Disconnect(); espConn = nil end

    -- Clear all existing tags first
    for _, tag in pairs(ESP_TAGS) do clearTag(tag) end

    local anyOn = Active.PumpkinESP or Active.PatchESP or Active.BossESP or Active.DoorESP
    if not anyOn then return end

    local TICK = 0
    espConn = RunService.Heartbeat:Connect(function()
        TICK = TICK + 1
        if TICK % 30 ~= 0 then return end  -- re-scan every ~0.5s
        pcall(function()
            for _, item in ipairs(workspace:GetDescendants()) do
                if not item:IsA("Model") then continue end

                if Active.PumpkinESP and item.Name == "Pumpkin" then
                    addHighlight(item, ESP_TAGS.PumpkinHL,
                        Color3.fromRGB(255, 100, 0),
                        Color3.fromRGB(255, 210, 0), 0.2)
                end

                if Active.PatchESP and item.Name == "PumpkinPatch" then
                    addHighlight(item, ESP_TAGS.PatchHL,
                        Color3.fromRGB(255, 55, 0),
                        Color3.fromRGB(255, 150, 0), 0.3)
                    addBillboard(item, ESP_TAGS.PatchLabel,
                        "🎃 PumpkinPatch", Color3.fromRGB(255, 215, 0))
                end

                if Active.BossESP and BOSS_NAMES[item.Name] then
                    addHighlight(item, ESP_TAGS.BossHL,
                        Color3.fromRGB(255, 20, 0),
                        Color3.fromRGB(255, 90, 0), 0.1)
                    addBillboard(item, ESP_TAGS.BossLabel,
                        "🔥 Hellfire Gas", Color3.fromRGB(255, 50, 0))
                end

                if Active.DoorESP then
                    local lname = item.Name:lower()
                    if lname:find("trickortreat") or lname:find("halloweendoor")
                    or lname:find("candydoor") or lname:find("flamedoor") then
                        addHighlight(item, ESP_TAGS.DoorHL,
                            Color3.fromRGB(140, 0, 255),
                            Color3.fromRGB(200, 100, 255), 0.3)
                        addBillboard(item, ESP_TAGS.DoorLabel,
                            "🚪 ToT Door", Color3.fromRGB(200, 100, 255))
                    end
                end
            end
        end)
    end)
end

-- ================================================================
-- 8. TRICK-OR-TREAT LOCATIONS
-- Approximate — use "Print Model Positions" button to tune per sea.
-- Sea 1: center town spawn island
-- Sea 2: cafe near Flower Hill / Kingdom of Rose area
-- Sea 3: mansion area Third Sea
-- ================================================================
local ToTLocations = {
    ["Sea 1 (Center Town)"] = CFrame.new(-1420, 126, -2050),
    ["Sea 2 (Cafe)"]        = CFrame.new(-738,   95, -2270),
    ["Sea 3 (Mansion)"]     = CFrame.new(-3027,   15,  -320),
}

-- Door scan radius (studs) after arriving at ToT location
local DOOR_RADIUS = 40

-- ================================================================
-- 9. AUTO FARM PUMPKIN
-- Move to nearest Pumpkin / PumpkinPatch, look at it, M1 click + touch.
-- Pumpkins with Humanoid → normal attack; prop pumpkins → touch fallback.
-- ================================================================
local PUMPKIN_SET = {Pumpkin = true, PumpkinPatch = true}
local ATTACK_DIST = 10  -- engage range (studs)

task.spawn(function()
    while true do
        task.wait(0.08)
        if Active.AutoFarmPumpkin and isAlive() then
            pcall(function()
                local target, dist = findNearest(PUMPKIN_SET)
                if not target then return end

                local root = target:FindFirstChild("HumanoidRootPart")
                          or target:FindFirstChildWhichIsA("BasePart", true)
                if not root then return end

                local hrp = getHRP()
                if not hrp then return end

                if dist > ATTACK_DIST then
                    -- Tween to attack range
                    local dir = (hrp.Position - root.Position).Unit
                    TweenTo(CFrame.new(root.Position + dir * (ATTACK_DIST - 2)), Active.FarmSpeed)
                end

                -- Face target, click, touch
                lookAt(root.Position)
                doM1Click()
                touchAttack(target)
                -- Also try proximityprompt in case pumpkin uses E-interact
                firePrompts(target)
            end)
        end
    end
end)

-- ================================================================
-- 10. AUTO TRICK-OR-TREAT
-- Teleports to the sea's ToT location, then scans and fires door prompts.
-- ================================================================
local totCooldown = 0
local TOT_INTERVAL = 2.5  -- seconds between door-fire attempts

task.spawn(function()
    while true do
        task.wait(0.5)
        if Active.AutoToT and isAlive() then
            pcall(function()
                local sea    = Active.ToTSea or "Sea 1 (Center Town)"
                local destCF = ToTLocations[sea]
                if not destCF then return end

                local hrp  = getHRP()
                if not hrp then return end

                -- Move to ToT area if far
                if (destCF.Position - hrp.Position).Magnitude > 20 then
                    TweenTo(destCF, Active.FarmSpeed)
                end

                -- Throttle door fires
                if tick() < totCooldown then return end
                totCooldown = tick() + TOT_INTERVAL

                -- Scan for door models and proximity prompts near current position
                local pos = getHRP() and getHRP().Position or destCF.Position
                for _, item in ipairs(workspace:GetDescendants()) do
                    if item:IsA("Model") then
                        local lname = item.Name:lower()
                        local isToT = lname:find("trickortreat") or lname:find("door")
                                   or lname:find("halloween") or lname:find("candy")
                        if isToT then
                            local r2 = item:FindFirstChildWhichIsA("BasePart", true)
                            if r2 and (r2.Position - pos).Magnitude < DOOR_RADIUS then
                                firePrompts(item)
                            end
                        end
                    end
                    -- Also scan loose ProximityPrompts not inside a named model
                    if item:IsA("ProximityPrompt") then
                        local lname = item.Name:lower()
                        if lname:find("trick") or lname:find("candy") or lname:find("halloween") then
                            local pp = item.Parent and item.Parent:FindFirstChildWhichIsA("BasePart")
                                    or (item.Parent and item.Parent:IsA("BasePart") and item.Parent)
                            if pp and (pp.Position - pos).Magnitude < DOOR_RADIUS then
                                pcall(fireproximityprompt, item)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ================================================================
-- 11. AUTO HAUNTED GACHA
-- 500 Candy Coin per spin. After 1-hour cooldown → 2 spins available.
-- Remote name "HalloweenGacha" — adjust if game uses different name.
-- ================================================================
local gachaState = {
    lastReset   = 0,
    spinsLeft   = 0,
    COOLDOWN    = 3600,  -- 1 hour
    SPINS_PER_CD = 2,
}

local function tryGachaSpin()
    if not CommF then return false end
    local ok, res = pcall(function()
        return CommF:InvokeServer("HalloweenGacha", "Spin")
    end)
    return ok
end

task.spawn(function()
    while true do
        task.wait(5)
        if Active.AutoGacha and isAlive() then
            pcall(function()
                local now = tick()
                -- Refresh spins after cooldown
                if now - gachaState.lastReset >= gachaState.COOLDOWN then
                    gachaState.lastReset = now
                    gachaState.spinsLeft = gachaState.SPINS_PER_CD
                end
                -- Consume spins
                while gachaState.spinsLeft > 0 do
                    if not Active.AutoGacha or not isAlive() then break end
                    local ok = tryGachaSpin()
                    if ok then
                        gachaState.spinsLeft = gachaState.spinsLeft - 1
                        Library:Notify({
                            Title  = "Haunted Gacha",
                            Content = "Đã spin! Còn " .. gachaState.spinsLeft .. " lần. Next reset: 1h",
                            Duration = 4,
                        })
                    else
                        Library:Notify({
                            Title   = "Haunted Gacha",
                            Content = "Spin thất bại — không đủ Candy Coin hoặc sai remote name.",
                            Duration = 5,
                        })
                        break
                    end
                    task.wait(1.5)
                end
            end)
        end
    end
end)

-- ================================================================
-- 12. MOVEMENT CHEATS (WalkSpeed / JumpPower / Noclip)
-- ================================================================
local movConn, noclipConn

local function hookMovement()
    if movConn then movConn:Disconnect(); movConn = nil end
    if not (Active.FastWalk or Active.FastJump) then return end
    movConn = RunService.Heartbeat:Connect(function()
        local hum = getHum()
        if not hum then return end
        if Active.FastWalk  then hum.WalkSpeed  = Active.WalkSpeed  or 50  end
        if Active.FastJump  then hum.JumpPower  = Active.JumpPower  or 100 end
    end)
end

local function hookNoclip(v)
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    if not v then return end
    noclipConn = RunService.Stepped:Connect(function()
        if not Active.Noclip then return end
        local char = getChar()
        if not char then return end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                p.CanCollide = false
            end
        end
    end)
end

-- ================================================================
-- 13. ANTI-AFK
-- ================================================================
lp.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- ================================================================
-- 14. UI — TAB: ESP
-- ================================================================
local TabESP = Window:CreateTab("ESP")

local secPumpkinESP = TabESP:CreateSection("Pumpkin")

secPumpkinESP:CreateToggle({
    Title       = "Pumpkin ESP",
    Description = "Highlight cam bí ngô (Pumpkin) trên map",
    Default     = false,
    Callback    = function(v)
        Active.PumpkinESP = v
        rebuildESP()
    end,
})

secPumpkinESP:CreateToggle({
    Title       = "PumpkinPatch ESP",
    Description = "Highlight + label cụm bí ngô (PumpkinPatch / snowman)",
    Default     = false,
    Callback    = function(v)
        Active.PatchESP = v
        rebuildESP()
    end,
})

local secBossESP = TabESP:CreateSection("Boss & Door")

secBossESP:CreateToggle({
    Title       = "Hellfire Gas ESP",
    Description = "Highlight boss lửa Hellfire Gas xuyên tường",
    Default     = false,
    Callback    = function(v)
        Active.BossESP = v
        rebuildESP()
    end,
})

secBossESP:CreateToggle({
    Title       = "ToT Door ESP",
    Description = "Highlight cửa Trick-or-Treat để dễ tìm",
    Default     = false,
    Callback    = function(v)
        Active.DoorESP = v
        rebuildESP()
    end,
})

-- ================================================================
-- 15. UI — TAB: FARM
-- ================================================================
local TabFarm = Window:CreateTab("Farm")

local secAutoFarm = TabFarm:CreateSection("Auto Farm Pumpkin")

secAutoFarm:CreateToggle({
    Title       = "Auto Farm Pumpkin",
    Description = "Tự tìm bí ngô gần nhất, đến và đánh để farm Candy Coin",
    Default     = false,
    Callback    = function(v)
        Active.AutoFarmPumpkin = v
        Library:Notify({
            Title   = "Auto Farm Pumpkin",
            Content = v and "Đang farm..." or "Đã tắt.",
            Duration = 3,
        })
    end,
})

secAutoFarm:CreateSlider({
    Title       = "Tốc độ di chuyển (studs/s)",
    Description = "Tốc độ tween khi đến mục tiêu",
    Min = 50, Max = 600, Default = 200, Rounding = 0,
    Callback    = function(v) Active.FarmSpeed = v end,
})

-- ================================================================
-- 16. UI — TAB: EVENT
-- ================================================================
local TabEvent = Window:CreateTab("Event")

local secToT = TabEvent:CreateSection("Trick-or-Treat")

secToT:CreateDropdown({
    Title       = "Chọn Sea",
    Description = "Sea 1 → Thị trấn | Sea 2 → Quán Cafe | Sea 3 → Dinh Thự",
    Options     = {"Sea 1 (Center Town)", "Sea 2 (Cafe)", "Sea 3 (Mansion)"},
    Default     = "Sea 1 (Center Town)",
    Callback    = function(v) Active.ToTSea = v end,
})

secToT:CreateToggle({
    Title       = "Auto Trick-or-Treat",
    Description = "Tự đến vị trí cửa theo sea và gõ cửa lấy Candy Coin",
    Default     = false,
    Callback    = function(v)
        Active.AutoToT = v
        Library:Notify({
            Title   = "Auto Trick-or-Treat",
            Content = v and ("Chạy tại: " .. (Active.ToTSea or "?")) or "Đã tắt.",
            Duration = 3,
        })
    end,
})

secToT:CreateButton({
    Title       = "Teleport đến vị trí ToT",
    Description = "Nhảy thẳng đến vị trí sea đã chọn",
    Callback    = function()
        local cf = ToTLocations[Active.ToTSea or "Sea 1 (Center Town)"]
        local hrp = getHRP()
        if cf and hrp then
            hrp.CFrame = cf
            Library:Notify({Title = "Teleport", Content = "Đã đến " .. Active.ToTSea, Duration = 3})
        end
    end,
})

local secGacha = TabEvent:CreateSection("Haunted Gacha")

secGacha:CreateToggle({
    Title       = "Auto Haunted Gacha",
    Description = "Tự spin Gacha: 500 Candy/lần, cooldown 1h → 2 lần",
    Default     = false,
    Callback    = function(v)
        Active.AutoGacha = v
        if v then
            -- Force refresh so it spins immediately if spins available
            gachaState.lastReset = 0
            gachaState.spinsLeft = 0
        end
        Library:Notify({
            Title   = "Auto Gacha",
            Content = v and "Đang theo dõi cooldown..." or "Đã tắt.",
            Duration = 3,
        })
    end,
})

secGacha:CreateButton({
    Title       = "Spin Ngay (Force)",
    Description = "Force spin 1 lần ngay bây giờ",
    Callback    = function()
        local ok = tryGachaSpin()
        Library:Notify({
            Title   = "Haunted Gacha",
            Content = ok and "Spin thành công!" or "Spin thất bại — kiểm tra remote name.",
            Duration = 4,
        })
    end,
})

-- ================================================================
-- 17. UI — TAB: PLAYER
-- ================================================================
local TabPlayer = Window:CreateTab("Player")

local secMove = TabPlayer:CreateSection("Movement")

secMove:CreateToggle({
    Title       = "Fast Walk",
    Description = "Tăng tốc độ di chuyển nhân vật",
    Default     = false,
    Callback    = function(v)
        Active.FastWalk = v
        hookMovement()
    end,
})

secMove:CreateSlider({
    Title = "WalkSpeed",
    Min = 16, Max = 500, Default = 50, Rounding = 0,
    Callback = function(v) Active.WalkSpeed = v end,
})

secMove:CreateToggle({
    Title       = "Fast Jump",
    Description = "Tăng JumpPower nhân vật",
    Default     = false,
    Callback    = function(v)
        Active.FastJump = v
        hookMovement()
    end,
})

secMove:CreateSlider({
    Title = "JumpPower",
    Min = 50, Max = 500, Default = 100, Rounding = 0,
    Callback = function(v) Active.JumpPower = v end,
})

local secUtil = TabPlayer:CreateSection("Utility")

secUtil:CreateToggle({
    Title       = "Noclip",
    Description = "Xuyên tường — hữu ích để vào Flame Door tìm Hellfire Gas",
    Default     = false,
    Callback    = function(v)
        Active.Noclip = v
        hookNoclip(v)
    end,
})

secUtil:CreateToggle({
    Title       = "Anti-AFK (luôn bật)",
    Description = "VirtualUser anti-idle — tự kích hoạt khi game idle",
    Default     = true,
    Callback    = function() end,  -- handled at startup, toggle is visual only
})

-- ================================================================
-- 18. UI — TAB: DEBUG
-- ================================================================
local TabDebug = Window:CreateTab("Debug")

local secDebug = TabDebug:CreateSection("In-game Model Finder")

TabDebug:CreateParagraph({
    Title   = "Re-derive guide",
    Content = "Nếu ESP hoặc ToT door không hoạt động:\n1. Vào đúng Sea → nhấn nút bên dưới.\n2. Check Console (F9) để thấy model names thật.\n3. Báo lại để update tên trong BOSS_NAMES / door filter.",
})

TabDebug:CreateButton({
    Title       = "Print Halloween Model Names",
    Description = "Log tên models liên quan event ra Console",
    Callback    = function()
        local found = 0
        local seen  = {}
        for _, item in ipairs(workspace:GetDescendants()) do
            if item:IsA("Model") and not seen[item.Name] then
                local lower = item.Name:lower()
                if lower:find("pump") or lower:find("hell") or lower:find("halloween")
                or lower:find("candy") or lower:find("trick") or lower:find("flame")
                or lower:find("ghost") or lower:find("spooky") or lower:find("witch")
                or lower:find("door") or lower:find("jack") or lower:find("lantern") then
                    seen[item.Name] = true
                    local pivot = pcall(function() return item:GetPivot().Position end)
                    print("[BFHalloween]", item.Name, "@", item:GetPivot().Position)
                    found = found + 1
                end
            end
        end
        Library:Notify({
            Title   = "Debug",
            Content = ("Đã log " .. found .. " model(s). Mở Console (F9) để xem."),
            Duration = 5,
        })
    end,
})

TabDebug:CreateButton({
    Title       = "Print ProximityPrompts in Range",
    Description = "Log tất cả ProximityPrompt trong 50 studs",
    Callback    = function()
        local hrp = getHRP()
        if not hrp then return end
        local count = 0
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                local pp = v.Parent and v.Parent:FindFirstChildWhichIsA("BasePart")
                        or (v.Parent and v.Parent:IsA("BasePart") and v.Parent)
                if pp and (pp.Position - hrp.Position).Magnitude < 50 then
                    print("[Prompt]", v.Name, "| Parent:", v.Parent and v.Parent.Name, "@", pp.Position)
                    count = count + 1
                end
            end
        end
        Library:Notify({
            Title   = "Debug",
            Content = count .. " ProximityPrompt(s) trong 50 studs. Xem Console.",
            Duration = 5,
        })
    end,
})

TabDebug:CreateButton({
    Title       = "Test Gacha Remote",
    Description = "Thử InvokeServer HalloweenGacha để kiểm tra tên remote",
    Callback    = function()
        if not CommF then
            Library:Notify({Title = "Error", Content = "CommF_ chưa ready.", Duration = 4})
            return
        end
        local ok, res = pcall(function()
            return CommF:InvokeServer("HalloweenGacha", "Info")
        end)
        print("[Gacha test] ok:", ok, "| res:", tostring(res))
        Library:Notify({
            Title   = "Gacha Remote Test",
            Content = ok and ("Response: " .. tostring(res)) or ("Error: " .. tostring(res)),
            Duration = 6,
        })
    end,
})

-- ================================================================
-- 19. BOOT NOTIFY
-- ================================================================
Library:Notify({
    Title   = "Halloween 2026 Hub",
    Content = "Loaded! RCtrl → toggle UI.\nESP → Farm → Event → Player → Debug",
    Duration = 6,
})
