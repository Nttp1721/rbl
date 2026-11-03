--[[═══════════════════════════════════════════════════════════════════════
    ███╗   ███╗███████╗██╗███████╗██╗   ██╗    ██╗██╗   ██╗██████╗
    ████╗ ████║██╔════╝██║██╔════╝██║   ██║    ██║██║   ██║██╔══██╗
    ██╔████╔██║█████╗  ██║███████╗██║   ██║    ██║██║   ██║██████╔╝
    ██║╚██╔╝██║██╔══╝  ██║╚════██║██║   ██║    ██║██║   ██║██╔══██╗
    ██║ ╚═╝ ██║███████╗██║███████║╚██████╔╝    ██║╚██████╔╝██████╔╝
    ╚═╝     ╚═╝╚══════╝╚═╝╚══════╝ ╚═════╝     ╚═╝ ╚═════╝ ╚═════╝
    ═══════════════════════════════════════════════════════════════════════
    MEIZU HUB — BLOX FRUITS · HALLOWEEN EVENT 2026 (HELLFIRE)
    ────────────────────────────────────────────────────────────────────────
    • Nền tảng UI : Meizu Library (Nttp1721) — bản v3.1 "Luxe"
    • Tham khảo   : Banana Cat Hub (meizublf.lua) — tween / fast attack /
                    noclip / anti-AFK được viết lại gọn cho event
    • Tính năng   :
        [1] Auto Farm Bí Ngô (Jack O' Lantern Hunt) — 2 chế độ:
              + Tới gần từng bí ngô (tween + fast attack remote)
              + Đập trong tầm (hết tầm → tự bay đuổi, không đứng im)
        [2] ESP Bí Ngô + PumpkinPatch (Highlight + BillTag khoảng cách)
        [3] Auto Gõ Cửa (Trick-or-Treat mỗi giờ XX:00)
        [4] Auto Roll Gacha / Tương tác Phù Thủy (ProximityPrompt)
        [5] Nhặt đồ rơi (Candy Corn / Pumpkin Bits)
        [6] Anti-AFK · Hop Server · Rejoin · Watermark FPS/Ping
    ────────────────────────────────────────────────────────────────────────
    CÁCH DÙNG — upload file này lên repo Nttp1721/rbl (nhánh main) với tên:
        MeizuHub-Halloween2026.lua
    rồi chạy bằng:
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/MeizuHub-Halloween2026.lua"))()

    ═══ UPDATE v2.1 — FIX THEO FEEDBACK ═══
    • FIX "bật farm xong tự tắt khi tele tới bí ngô": bản cũ click chuột ảo
      NGAY GIỮA MÀN HÌNH → cú click rơi trúng cửa sổ Hub đang mở → tự bấm
      trúng toggle Farm → farm tắt. Giờ script tự tìm điểm màn hình KHÔNG
      có UI để click + tự thu nhỏ Hub khi farm (Ctrl trái mở lại).
    • Đánh M1 GIẢ LẬP NGƯỜI THẬT: nhấn-giữ chuột 40-90ms, nhịp 0.30-0.42s
      ngẫu nhiên, quay người + camera vào bí ngô → server mới cộng damage.
    • FIX "bay chui xuống nước": tween dò mặt đất/mặt nước bằng raycast,
      luôn giữ 3-3.5 studs phía trên → không chìm dưới biển nữa.
    • GIẢM LAG: 1 cache quét map duy nhất (tối đa 1 lần/1.2s) thay vì
      5-10 lần GetDescendants mỗi giây; noclip dùng list cache;
      ESP giới hạn 100 vật thể.

    ═══ UPDATE v2.2 — FARM LIÊN TỤC + ĐÁNH SÁT + AUTO BUSO ═══
    • Đánh bí ngô GẦN trước → hết gần thì TỰ BAY ra vùng XA đập tiếp,
      không bao giờ đứng im chờ (farm liên tục).
    • Bay đứng SÁT CẠNH bí ngô (3.5–5 studs, chỉnh bằng slider) — bản cũ
      đứng 10+ studs nên M1 trượt ("đánh không dính"). Bị văng ra xa thì
      TỰ BAY LẠI sát bí ngô, không bỏ quả giữa chừng.
    • AUTO BẬT BUSO HAKI (Aura): CommF_:InvokeServer("Buso") — kỹ thuật
      lấy từ Banana Cat Hub → đập bí ngô đau hơn hẳn.

    ═══ UPDATE v2.4 — KHÓA MỤC TIÊU + GIỚI HẠN VÙNG FARM ═══
    • Chỉ farm bí ngô có marker sự kiện hoặc nằm trong PumpkinPatch;
      không fallback sang bí ngô trang trí khi không tìm được patch.
    • Giới hạn vùng tìm quanh vị trí bật farm, tránh bay dây chuyền qua map.
    • Quả đập hoài không mất máu → cấm 120s (trước 15s) → không bay
      đi bếp lại quả giả nữa.
    • Nhặt đồ KHÔNG dịch chuyển nhân vật khi farm đang bật (hết bị kéo
      sang nhặt "Candy Corn" trang trí ở khu Gacha).
    • Auto Gõ Cửa / Gacha: khi farm bật chỉ bấm prompt TRONG TẦM đánh,
      KHÔNG tween đi nơi khác + cooldown 6s/prompt → hết spam lỗi
      "[DIALOGUE] there's already an active dialogue".
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
local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local VirtualUser     = game:GetService("VirtualUser")
local VIM             = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local HttpService     = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- ════════════════════════════ 3. TRẠNG THÁI CHUNG ═════════════════════════
local State = {
        -- Farm bí ngô
        FarmPumpkin   = false,
        FarmMode      = "Tới gần từng bí ngô",
        FilterMode    = "Tất cả bí ngô",
        TweenSpeed    = 350,
        HitRange      = 30,
        MaxFarmDistance = 350, -- bán kính tính từ vị trí bật farm; không cho đuổi mục tiêu xuyên map
        StandDist     = 4,    -- đứng SÁT CẠNH bí ngô khi đập (bản cũ đứng 10+ studs → M1 trượt)
        AutoBuso      = true, -- tự bật Buso Haki (Aura) khi đánh
        HitDelay      = 0.12,
        FastAttack    = false, -- remote thường bị server chặn → mặc định M1 người thật
        Noclip        = true,
        PickupDrops   = true,
        PickupRadius  = 60,
        PickupKeywords = "candy,corn,pumpkin,bit,spooky,treat",
        StatusText    = "Tắt",

        -- ESP
        ESP          = false,
        ESPPatch     = false,
        ESPDistance  = true,
        ESPMaxRange  = 0, -- 0 = vô hạn
        ESPFill      = Color3.fromRGB(255, 100, 0),
        ESPOutline   = Color3.fromRGB(255, 200, 0),

        -- Sự kiện
        TrickOrTreat  = false,
        KnockKeywords = "knock,door,trick,treat,halloween,candy",
        KnockRadius   = 15000,
        Gacha         = false,
        GachaKeywords = "roll,gacha,witch,brew,potion,haunt,spooky",

        -- Khác
        AntiAFK     = true,
        NoFX        = false,
        HideUIFarm  = true, -- thu nhỏ Hub khi farm (chống click ảo bấm nhầm nút)
}

local Connections = {}

-- KHAI BÁO SỚM để mọi hàm bên dưới (notify...) dùng chung 1 biến local
local Library -- sẽ gán ở mục 16 (Nạp thư viện Meizu)

-- (các loop chống chạy trùng bằng "generation counter" — xem farmLoop / busoLoop)

-- ════════════════════════════ 4. TIỆN ÍCH NHÂN VẬT ════════════════════════
local function getChar()
        return LocalPlayer.Character
end

local function getRoot()
        local c = LocalPlayer.Character
        return c and (c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart)
end

local function getHum()
        local c = LocalPlayer.Character
        return c and c:FindFirstChildOfClass("Humanoid")
end

local function notify(title, content, typ)
        pcall(function()
                Library:Notify({ Title = title, Content = content, Duration = 5, Type = typ or "info" })
        end)
end

-- ════════════════════════════ 5. TWEEN (mượn ý tưởng Banana Cat Hub) ══════
-- Tween theo Heartbeat: set CFrame từng bước theo tốc độ, có noclip,
-- chống kẹt (watchdog) và hủy được từ thread khác qua token.
local MZ_Tween = {
        token   = 0,
        running = false,
        _fv     = nil,
}

local function setFloatForce(root, on)
        -- luôn dọn Force cũ (kể cả khi đổi nhân vật giữa chừng)
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

-- Raycast tìm mặt đất / MẶT NƯỚC dưới 1 điểm (fix lỗi bay chui xuống nước)
local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Exclude
RayParams.IgnoreWater = false -- bắt buộc false để dò được mặt nước
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
                Vector3.new(pos.X, pos.Y + 60, pos.Z),
                Vector3.new(0, -500, 0), RayParams)
        if hit then
                return hit.Position.Y, (hit.Material == Enum.Material.Water)
        end
        return nil, false
end

-- Trả về true nếu tới nơi (trong stopDist), false nếu hủy / kẹt / chết
-- groundSafe (mặc định BẬT): dọc đường bay tự giữ tối thiểu 3 studs trên
-- mặt đất / 3.5 studs trên mặt nước → KHÔNG bao giờ chui xuống biển nữa.
function MZ_Tween.to(targetCFrame, speed, stopDist, groundSafe)
        local root = getRoot()
        local char = getChar()
        local hum = getHum()
        if not (root and char and hum) or typeof(targetCFrame) ~= "CFrame" then
                return false
        end

        MZ_Tween.cancel()
        MZ_Tween.running = true
        local myToken = MZ_Tween.token
        setFloatForce(root, true)

        speed = math.max(tonumber(speed) or 350, 20)
        stopDist = tonumber(stopDist) or 4
        local goalPos = targetCFrame.Position
        local startTime = os.clock()
        local maxTime = (root.Position - goalPos).Magnitude / speed + 15 -- timeout an toàn
        local lastDist = math.huge
        local lastProgress = os.clock()

        local ok = false
        while MZ_Tween.running and myToken == MZ_Tween.token do
                local dt = RunService.Heartbeat:Wait()
                local c = LocalPlayer.Character
                local r = c and (c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart)
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if not (c and r and h) or h.Health <= 0 or r.Parent ~= c then
                        break
                end
                if os.clock() - startTime > maxTime then
                        break
                end

                local cur = r.Position
                local delta = goalPos - cur
                local dist = delta.Magnitude

                -- watchdog chống kẹt: 5s không tiến bộ thì thoát
                if dist < lastDist - 1 then
                        lastDist = dist
                        lastProgress = os.clock()
                elseif os.clock() - lastProgress > 5 then
                        break
                end

                if dist <= stopDist then
                        r.CFrame = targetCFrame
                        ok = true
                        break
                end

                local step = math.min(speed * dt, dist)
                local newPos = cur + delta.Unit * step

                -- FIX "bay dưới nước": giữ độ cao an toàn so với đất/nước dọc đường
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
        if myToken == MZ_Tween.token then
                MZ_Tween.running = false
        end
        return ok
end

-- ════════════════════════════ 6. NOCLIP (bản nhẹ — giảm lag) ══════════════
-- Dùng lại danh sách part đã cache (làm mới 1s/lần) thay vì GetDescendants
-- 60 lần/giây như bản cũ.
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
                        if p:IsA("BasePart") then
                                table.insert(noclipParts, p)
                        end
                end
        end
        for _, p in ipairs(noclipParts) do
                if p.Parent and p.CanCollide then
                        p.CanCollide = false
                end
        end
end))

-- ════════════════════════════ 7. ANTI-AFK ═════════════════════════════════
table.insert(Connections, LocalPlayer.Idled:Connect(function()
        if State.AntiAFK then
                pcall(function()
                        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                        task.wait(1)
                        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                end)
        end
end))

-- ════════════════════════════ 8. REMOTE FAST ATTACK ═══════════════════════
-- Flow người chơi thật (theo Banana Cat Hub):
--   1) Mouse module:FireServer(0.35) → đăng ký cú vung, mở "cửa sổ đánh" server
--   2) RegisterHit:FireServer(partĐầu, list cặp {rig, part})
-- Bí ngô KHÔNG nằm trong Workspace.Enemies nên AttackAOE gốc không trúng
-- → mình tự gom part của bí ngô và gửi đúng format trên.
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
                if type(mm) == "table" and type(mm.FireServer) == "function" then
                        MouseSwing = mm -- thiếu gói này server có thể từ chối damage!
                end
        end)
        if not RegisterHit then
                warn("[MZ Halloween] Không tìm thấy remote RegisterHit → dùng fallback M1 thường")
        end
end

-- ════════════════════════════ 9. QUÉT MAP (CACHE DUY NHẤT — GIẢM LAG) ═════
-- Bí ngô = Model tên "Pumpkin" (theo ESP gốc của bạn). PumpkinPatch = mốc vùng.
-- ⚠ GIẢM LAG: trước đây farm / ESP / nhặt đồ / prompt MỖI CÁI tự chạy
-- workspace:GetDescendants() → quét cả map 5-10 lần/giây → lag nặng.
-- Giờ chỉ có 1 bảng cache duy nhất: cả game tối đa quét 1 lần / 1.2s,
-- mọi tính năng (farm, ESP, nhặt đồ, gõ cửa, gacha, đếm) đọc từ đây.
local MZ_World = {
        built    = 0,
        sig      = "",
        pumpkins = {},
        patches  = {},
        drops    = {},
        prompts  = {},
}
local blacklist = {} -- [model] = THỜI ĐIỂM HẾT HẠN ban (quả giả 120s / khó tới 30s)

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
                if kw ~= "" and text:find(kw, 1, true) then
                        return true
                end
        end
        return false
end

-- KHÔNG nhặt part của chính quả bí ngô (tránh dịch chuyển nhân vật loạn xạ)
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
                .. "|" .. (State.GachaKeywords or "") .. "|" .. (State.FilterMode or "")
end

local pickupKw = splitCsv(State.PickupKeywords)

-- Có thể đánh dấu mục tiêu trong experience của bạn bằng tag/attribute này.
-- Pumpkin không được đánh dấu chỉ hợp lệ nếu nằm trong vùng PumpkinPatch.
local EVENT_PUMPKIN_TAG = "MZ_HalloweenPumpkin"
local EVENT_PATCH_TAG = "MZ_HalloweenPumpkinPatch"

local function hasEventMarker(instance, tagName)
        if not instance then return false end
        local marked = false
        pcall(function()
                marked = instance:GetAttribute(tagName) == true
                        or CollectionService:HasTag(instance, tagName)
        end)
        return marked
end

local function refreshPumpkins(force)
        local now = os.clock()
        local sig = worldSignature()
        if not force and (now - MZ_World.built) < 1.2 and MZ_World.sig == sig then
                return MZ_World.pumpkins
        end
        MZ_World.built = now
        MZ_World.sig = sig
        pickupKw = splitCsv(State.PickupKeywords)

        local pumpkins, patches, drops, prompts = {}, {}, {}, {}
        local myChar = LocalPlayer.Character
        for _, d in ipairs(workspace:GetDescendants()) do
                local cls = d.ClassName
                if cls == "Model" then
                        local ln = d.Name:lower()
                        local compactName = ln:gsub("[^%w]", "")
                        if compactName == "pumpkinpatch"
                                or hasEventMarker(d, EVENT_PATCH_TAG) then
                                table.insert(patches, d)
                        elseif compactName == "pumpkin"
                                or hasEventMarker(d, EVENT_PUMPKIN_TAG) then
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

        MZ_World.pumpkins = pumpkins
        MZ_World.patches  = patches
        MZ_World.drops    = drops
        MZ_World.prompts  = prompts

        -- dọn blacklist ĐÃ HẾT HẠN (t = thời điểm hết hạn)
        for m, t in pairs(blacklist) do
                if now > t or m.Parent == nil then
                        blacklist[m] = nil
                end
        end
        return pumpkins
end

local function modelRoot(model)
        if not model then return nil end
        return model.PrimaryPart
                or model:FindFirstChild("HumanoidRootPart", true)
                or model:FindFirstChild("RootPart", true)
                or model:FindFirstChildWhichIsA("BasePart", true)
end

local PATCH_PADDING = 35
local PATCH_FALLBACK_RADIUS = 140

local function pumpkinInsidePatch(pumpkinRoot, patch)
        if not (pumpkinRoot and patch and patch.Parent) then return false end
        local ok, boxCFrame, boxSize = pcall(function()
                return patch:GetBoundingBox()
        end)
        if ok and boxCFrame and boxSize and boxSize.Magnitude > 0 then
                local localPos = boxCFrame:PointToObjectSpace(pumpkinRoot.Position)
                local verticalPadding = math.max(boxSize.Y * 0.5 + PATCH_PADDING, 80)
                return math.abs(localPos.X) <= boxSize.X * 0.5 + PATCH_PADDING
                        and math.abs(localPos.Z) <= boxSize.Z * 0.5 + PATCH_PADDING
                        and math.abs(localPos.Y) <= verticalPadding
        end
        local patchRoot = modelRoot(patch)
        return patchRoot ~= nil
                and (pumpkinRoot.Position - patchRoot.Position).Magnitude <= PATCH_FALLBACK_RADIUS
end

local function isEventPumpkinTarget(model, rootPart, patches)
        if hasEventMarker(model, EVENT_PUMPKIN_TAG) then return true end
        for _, patch in ipairs(patches or {}) do
                if pumpkinInsidePatch(rootPart, patch) then return true end
        end
        return false
end

local function withinFarmRadius(position, origin)
        if not origin then return true end
        return (position - origin).Magnitude <= (tonumber(State.MaxFarmDistance) or 350)
end

local function pumpkinValid(model, fromPos)
        if not model or model.Parent == nil then return false end
        local bl = blacklist[model]
        if bl and os.clock() < bl then return false end
        local r = modelRoot(model)
        if not r then return false end
        local hum = model:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then return false end
        if State.FilterMode == "Bỏ qua bí ngô sống/boss" and hum and hum.MaxHealth >= 1000 then
                return false
        end
        return true
end

-- ════════════════════════════ 10. VŨ KHÍ & ĐÁNH ═══════════════════════════
local STYLE_NAMES = {
        "Combat", "Black Leg", "Electro", "Fishman Karate", "Dragon Talon",
        "Superhuman", "Electric Claw", "Death Step", "Sharkman Karate",
        "Godhuman", "Sanguine Art",
}

-- khớp theo TÊN hoặc TOOLTIP (nhiều executor để ToolTip rỗng)
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
        local char = getChar()
        local hum = getHum()
        if not (char and hum) or hum.Health <= 0 then return end
        if equippedStyle() then return end -- đang cầm đúng style → khỏi equip lại

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
                notify("Fighting Style", "Không thấy Fighting Style trong nhân vật/túi → M1 có thể không ăn. Hãy trang bị Combat trở lên!", "warning")
        end
end

local function faceTarget(pos)
        local root = getRoot()
        if not root then return end
        local flat = Vector3.new(pos.X, root.Position.Y, pos.Z)
        if (flat - root.Position).Magnitude > 0.5 then
                pcall(function()
                        root.CFrame = CFrame.lookAt(root.Position, flat)
                end)
        end
end

-- quay camera nhìn về bí ngô để cú M1 ảo ăn đúng mục tiêu
local function aimCamera(pos)
        pcall(function()
                local cam = workspace.CurrentCamera
                if cam then
                        cam.CFrame = CFrame.lookAt(cam.CFrame.Position, pos)
                end
        end)
end

-- "ảnh chụp" bí ngô để biết cú đánh có ăn máu không (máu giảm / part biến mất)
local function pumpkinSnapshot(model)
        local s = { parts = 0, health = nil }
        pcall(function()
                local hum = model:FindFirstChildOfClass("Humanoid")
                if hum then s.health = hum.Health end
                for _, p in ipairs(model:GetDescendants()) do
                        if p:IsA("BasePart") then
                                s.parts = s.parts + 1
                        end
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

-- Cách đánh: MẶC ĐỊNH "m1" = giả lập NGƯỜI THẬT (server chỉ cộng damage khi
-- đánh như người chơi thật). "remote" chỉ dùng khi bật toggle riêng.
local AtkMethod = State.FastAttack and "remote" or "m1"

-- Đánh bằng remote — GIỐNG HỆT gói người chơi thật:
--   1) Mouse:FireServer(0.35) → đăng ký cú vung, mở "cửa sổ đánh" phía server
--   2) RegisterHit:FireServer(partĐầu, list cặp {rig, part})
-- Part không resolve được rig sẽ KHÔNG được gửi (game thật cũng không bao giờ
-- gửi part không rig → tránh lỗi "unknown index from name=PartType").
local function hitPumpkinRemote(model, myPos)
        if not (RegisterHit and CombatUtil) then return false end
        local hitList = {}
        for _, p in ipairs(model:GetDescendants()) do
                if p:IsA("BasePart") and (p.Position - myPos).Magnitude <= State.HitRange + 15 then
                        local rig = nil
                        pcall(function()
                                rig = CombatUtil:GetRigOfHitPart(p)
                        end)
                        if rig then
                                table.insert(hitList, { rig, p })
                        end
                end
        end
        if #hitList == 0 then return false end
        local first = table.remove(hitList, 1)
        return pcall(function()
                if MouseSwing then
                        MouseSwing:FireServer(0.35) -- đăng ký cú vung TRƯỚC như người chơi thật
                end
                if RegisterAttack then
                        RegisterAttack:FireServer(0)
                end
                RegisterHit:FireServer(first[2], hitList)
        end)
end

-- Kiểm tra 1 điểm màn hình có nằm TRONG cửa sổ Hub không (Hub nằm trong
-- CoreGui nên GetGuiObjectsAtPosition không thấy → phải tự soi bounds)
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

-- Tìm điểm click TRỐNG trên màn hình (không có UI nào nằm dưới đó).
-- ⚠ FIX LỖI "FARM TỰ TẮT": bản cũ click NGAY GIỮA MÀN HÌNH — cú click ảo
-- rơi trúng cửa sổ Hub đang mở → tự bấm trúng toggle Farm → farm tắt!
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
                        if okG and type(guis) == "table" and #guis > 0 then
                                blocked = true
                        end
                end
                if not blocked then
                        return c
                end
        end
        return nil -- màn hình bị UI che kín → dùng fallback Activate
end

-- M1 GIẢ LẬP NGƯỜI THẬT (bản cũ bấm 0ms tại giữa màn hình → không ăn damage
-- và tự bấm nhầm UI). Bản mới:
--   • di chuyển chuột tới điểm trống → NHẤN GIỮ 40-90ms → nhả (như tay thật)
--   • jitter ±8px mỗi phát như người thật
--   • không có VIM / màn hình kín UI → fallback tool:Activate()
local function hitPumpkinM1(aimPos)
        aimCamera(aimPos)
        if VIM then
                local pt = safeClickPoint()
                if pt then
                        local x = pt.X + math.random(-8, 8)
                        local y = pt.Y + math.random(-6, 6)
                        pcall(function()
                                VIM:SendMouseMoveEvent(x, y, game)
                        end)
                        task.wait(0.02)
                        pcall(function()
                                VIM:SendMouseButtonEvent(x, y, 0, true, game, 1)
                        end)
                        task.wait(0.04 + math.random() * 0.05) -- giữ chuột như người thật
                        pcall(function()
                                VIM:SendMouseButtonEvent(x, y, 0, false, game, 1)
                        end)
                        return
                end
        end
        local char = getChar()
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool then
                pcall(function() tool:Activate() end)
        end
end

-- Điểm vào duy nhất: chọn cách đánh theo AtkMethod
local function doHit(model, aimPos, myPos)
        if AtkMethod == "remote" and hitPumpkinRemote(model, myPos or aimPos) then
                return "remote"
        end
        hitPumpkinM1(aimPos)
        return "m1"
end

-- ════════════════════════════ 10b. AUTO BUSO HAKI ═════════════════════════
-- Mượn kỹ thuật Banana Cat Hub: khi Buso BẬT, nhân vật có con _BusoLayer1
-- (layer aura) hoặc HasBuso → chưa có thì CommF_:InvokeServer("Buso").
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

-- true = Buso đang BẬT (char chưa load → coi như bật để khỏi spam remote)
local function busoActive()
        local c = getChar()
        if not c then return true end
        return ffcMatch(c, "_BusoLayer1") ~= nil
                or c:FindFirstChild("HasBuso") ~= nil
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
                                                        "Không bật được Buso — có thể bạn CHƯA MUA Haki Buso ($25.000 Beli) hoặc đang hết năng lượng Haki.",
                                                        "warning")
                                        end
                                end
                        end
                end)
                if not ok then
                        warn("[MZ Halloween] busoLoop lỗi (tự tiếp tục): " .. tostring(err))
                end
                task.wait(1)
        end
end

-- ════════════════════════════ 11. AUTO FARM BÍ NGÔ ════════════════════════
-- Điểm đứng an toàn: nâng 3.5 studs trên mặt đất/MẶT NƯỚC dưới điểm đó
-- (fix lỗi đứng chìm dưới nước khi bí ngô gần bờ biển)
local function safeStandPos(pos)
        local gY, isWater = groundYAt(pos)
        local baseY = pos.Y
        if gY then
                baseY = math.max(baseY, gY + (isWater and 1.5 or 0.5))
        end
        return Vector3.new(pos.X, baseY + 3.5, pos.Z)
end

-- Chọn mục tiêu sau khi cache được cập nhật. Không dùng fallback toàn map:
-- mục tiêu phải có marker rõ ràng hoặc nằm trong bounds của PumpkinPatch.
local function pickNearest(rootPos, farmOrigin)
        local pumpkins = refreshPumpkins()
        local patches = MZ_World.patches -- lấy sau refresh để tránh dùng danh sách patch cũ
        local best, bestD = nil, math.huge
        for _, m in ipairs(pumpkins) do
                if pumpkinValid(m, rootPos) then
                        local r = modelRoot(m)
                        if r and withinFarmRadius(r.Position, farmOrigin)
                                and isEventPumpkinTarget(m, r, patches) then
                                local d = (r.Position - rootPos).Magnitude
                                if d <= State.MaxFarmDistance and d < bestD then
                                        best, bestD = m, d
                                end
                        end
                end
        end
        return best, bestD
end

local FarmGen = 0 -- mỗi lần bật tăng gen → vòng cũ tự thoát, KHÔNG bao giờ "chết im"

-- Đập 1 bí ngô tới khi chết. true = xong (chết/biến mất), false = bỏ quả này.
-- CÓ đo tiến triển: 12 hit không thấy máu giảm/part mất → tự đổi cách đánh → bỏ.
local function smashUntilDead(target, myGen, farmOrigin)
        local startClock = os.clock()
        local hits = 0
        local noProgress = 0
        local lastSnap = pumpkinSnapshot(target)
        -- bí ngô CÓ Humanoid → đo được máu (ngưỡng ngắn).
        -- KHÔNG có → chỉ đợi part mất dần (nhiều loại nổ 1 phát sau N hit,
        -- không có tín hiệu gì cho tới lúc nổ) → phải cho ngân sách hit rộng hơn.
        local hasHum = (target:FindFirstChildOfClass("Humanoid") ~= nil)

        while State.FarmPumpkin and (not myGen or myGen == FarmGen) do
                local char = getChar()
                local root = getRoot()
                if not (char and root) then return false end
                if not target or target.Parent == nil then return true end
                local hum = target:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health <= 0 then return true end
                local rp = modelRoot(target)
                if not rp then return true end
                if not withinFarmRadius(rp.Position, farmOrigin)
                        or not isEventPumpkinTarget(target, rp, MZ_World.patches) then
                        blacklist[target] = os.clock() + 30
                        return false
                end
                local distNow = (rp.Position - root.Position).Magnitude
                if distNow > math.max(State.StandDist or 4, 3) + 9 then
                        -- bị đẩy văng / bí ngô lăn xa → BAY LẠI đứng kế bên (không bỏ quả)
                        local flat = Vector3.new(root.Position.X - rp.Position.X,
                                0, root.Position.Z - rp.Position.Z)
                        if flat.Magnitude < 0.1 then flat = Vector3.new(1, 0, 0) end
                        State.StatusText = "Bị văng ra → bay lại sát bí ngô..."
                        MZ_Tween.to(CFrame.new(safeStandPos(
                                rp.Position + flat.Unit
                                        * math.clamp(State.StandDist or 4, 3, 12))),
                                State.TweenSpeed, 3, true)
                        if not State.FarmPumpkin or (myGen and myGen ~= FarmGen) then
                                return false
                        end
                elseif distNow > State.HitRange + 10 then
                        return false -- quá xa hẳn so với tầm đập → chọn quả khác
                end
                if os.clock() - startClock > 35 then
                        -- quá lâu không chết → khả năng là pumpkin giả → ban 120s
                        blacklist[target] = os.clock() + 120
                        return false
                end

                equipFightingStyle()
                faceTarget(rp.Position)
                doHit(target, rp.Position, root.Position)
                hits = hits + 1

                task.wait(AtkMethod == "m1"
                        and (math.max(State.HitDelay, 0.30) + math.random() * 0.12) -- nhịp người thật 0.30–0.42s
                        or math.max(State.HitDelay, 0.06))

                -- mỗi 4 hit kiểm tra 1 lần xem có ăn máu không
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

                        local budget = hasHum and 12
                                or (AtkMethod == "remote" and 48 or 24)
                        if noProgress >= budget then
                                if AtkMethod == "remote" then
                                        AtkMethod = "m1" -- remote không ăn → đổi sang M1 ảo
                                        noProgress = 0
                                        State.StatusText = "Remote không ăn damage → chuyển sang M1 ảo..."
                                        notify("Fast Attack", "Remote không gây damage → tự chuyển sang M1 ảo.", "warning")
                                else
                                        -- đập hoài không mất máu → PUMPKIN GIẢ / trang trí → ban 120s
                                        blacklist[target] = os.clock() + 120
                                        return false
                                end
                        end
                end
        end
        return false
end

-- Vòng farm chính — MỌI lỗi nhỏ đều pcall nên KHÔNG BAO GIỜ chết âm thầm
local function farmLoop()
        FarmGen = FarmGen + 1
        local myGen = FarmGen
        local noneCount = 0
        local originChar, farmOrigin = nil, nil
        while State.FarmPumpkin and myGen == FarmGen do
                local ok, err = pcall(function()
                        local char, root, hum = getChar(), getRoot(), getHum()
                        if not (char and root and hum) or hum.Health <= 0 then
                                State.StatusText = "Chờ hồi sinh..."
                                MZ_Tween.cancel()
                                task.wait(1)
                                return
                        end

                        if char ~= originChar then
                                originChar = char
                                farmOrigin = root.Position
                        end

                        if State.FarmMode == "Tới gần từng bí ngô" then
                                -- Đánh GẦN trước (pickNearest luôn chọn quả gần nhất);
                                -- hết quả gần → tự bay ra vùng XA, KHÔNG đứng im đợi
                                local target, dist = pickNearest(root.Position, farmOrigin)
                                if not target then
                                        noneCount = noneCount + 1
                                        State.StatusText = "Không thấy mục tiêu event trong bán kính farm..."
                                        -- dò lại map NGAY; chỉ thả ban SẮP HẾT HẠN (<8s),
                                        -- GIỮ ban dài (quả giả/trang trí) để không bay lại
                                        refreshPumpkins(true)
                                        local now = os.clock()
                                        for m, t in pairs(blacklist) do
                                                if (t - now) < 8 or m.Parent == nil then
                                                        blacklist[m] = nil
                                                end
                                        end
                                        if noneCount >= 5 then
                                                State.StatusText = "Không thấy bí ngô event — đứng gần PumpkinPatch hoặc gắn marker..."
                                        end
                                        task.wait(0.6)
                                        return
                                end
                                noneCount = 0
                                local rp = modelRoot(target)
                                if not rp then return end
                                -- ĐỨNG SÁT CẠNH bí ngô (mặc định 3.5–5 studs) để M1
                                -- không trượt; nâng trên mặt đất/nước khỏi chìm xuống biển
                                local offsetDir = (root.Position - rp.Position)
                                local standDist = math.clamp(State.StandDist or 4, 3, 12)
                                        + math.random() * 0.8
                                local reached = true
                                if offsetDir.Magnitude < 0.1 then
                                        -- đang đứng đè lên bí ngô → lùi nhẹ ra rồi đập luôn
                                        pcall(function()
                                                getRoot().CFrame = CFrame.new(safeStandPos(
                                                        rp.Position + Vector3.new(standDist, 0, 0)))
                                        end)
                                else
                                        local flat = Vector3.new(offsetDir.X, 0, offsetDir.Z)
                                        if flat.Magnitude < 0.1 then
                                                flat = Vector3.new(1, 0, 0)
                                        end
                                        local goal = CFrame.new(safeStandPos(rp.Position + flat.Unit * standDist))
                                        State.StatusText = string.format("Đang bay tới bí ngô (%.0fm)", dist)
                                        equipFightingStyle()
                                        reached = MZ_Tween.to(goal, State.TweenSpeed, 3.5, true)
                                end
                                if not State.FarmPumpkin then return end
                                if reached then
                                        State.StatusText = "Đang đập bí ngô..."
                                        smashUntilDead(target, myGen, farmOrigin)
                                else
                                        -- không tới được (kẹt / game kéo về) → tạm bỏ quả này
                                        local rp2 = modelRoot(target)
                                        local r2 = getRoot()
                                        if rp2 and r2
                                                and (rp2.Position - r2.Position).Magnitude > State.HitRange + 10 then
                                                blacklist[target] = os.clock() + 30
                                                State.StatusText = "Bỏ qua bí ngô khó tới..."
                                        end
                                end
                                task.wait(0.1)
                        else -- "Đập trong tầm (tự đuổi khi trống)"
                                refreshPumpkins()
                                local rootPos = root.Position
                                local patches = MZ_World.patches
                                local found = 0
                                for _, m in ipairs(MZ_World.pumpkins) do
                                        if not State.FarmPumpkin then break end
                                        if pumpkinValid(m, rootPos) then
                                                local rp = modelRoot(m)
                                                if rp and withinFarmRadius(rp.Position, farmOrigin)
                                                        and isEventPumpkinTarget(m, rp, patches)
                                                        and (rp.Position - rootPos).Magnitude <= State.HitRange then
                                                        found = found + 1
                                                        equipFightingStyle()
                                                        faceTarget(rp.Position)
                                                        doHit(m, rp.Position, rootPos)
                                                        task.wait(AtkMethod == "m1"
                                                                and (math.max(State.HitDelay, 0.30) + math.random() * 0.12)
                                                                or math.max(State.HitDelay, 0.06))
                                                end
                                        end
                                end
                                State.StatusText = found > 0
                                        and string.format("Đang đập trong tầm (%d bí ngô, %s)",
                                                found, AtkMethod == "m1" and "M1 ảo" or "remote")
                                        or "Không có bí ngô trong tầm..."
                                -- KHÔNG đứng im đợi: hết bí ngô trong tầm → tự bay tới
                                -- quả GẦN NHẤT trong vùng giới hạn rồi đập tiếp
                                if found == 0 and State.FarmPumpkin then
                                        local target, dist = pickNearest(rootPos, farmOrigin)
                                        local rp = target and modelRoot(target)
                                        if rp then
                                                local away = (rootPos - rp.Position)
                                                local flat = Vector3.new(away.X, 0, away.Z)
                                                if flat.Magnitude < 0.1 then flat = Vector3.new(1, 0, 0) end
                                                State.StatusText = string.format(
                                                        "Trong tầm không có → bay tới (%.0fm)", dist or 0)
                                                equipFightingStyle()
                                                MZ_Tween.to(CFrame.new(safeStandPos(
                                                        rp.Position + flat.Unit * math.clamp(
                                                                State.StandDist or 4, 3, 12))),
                                                        State.TweenSpeed, 3, true)
                                        else
                                                -- map trống thật sự → dò lại + thả ban sắp hết hạn
                                                refreshPumpkins(true)
                                                local now = os.clock()
                                                for m2, t2 in pairs(blacklist) do
                                                        if (t2 - now) < 8 or m2.Parent == nil then
                                                                blacklist[m2] = nil
                                                        end
                                                end
                                                task.wait(0.6)
                                        end
                                end
                        end
                end)
                if not ok then
                        warn("[MZ Halloween] farmLoop lỗi (tự tiếp tục): " .. tostring(err))
                        State.StatusText = "Lỗi nhỏ — tự tiếp tục..."
                        task.wait(0.5)
                end
        end
        if myGen == FarmGen then
                State.StatusText = "Tắt"
        end
end

-- ════════════════════════════ 12. NHẶT ĐỒ RƠI ═════════════════════════════
-- Đọc từ MZ_World.drops (cache chung) — KHÔNG quét GetDescendants nữa (giảm lag)
local PickupGen = 0
local function pickupLoop()
        PickupGen = PickupGen + 1
        local myGen = PickupGen
        while State.PickupDrops and myGen == PickupGen do
                local ok = pcall(function()
                        local root = getRoot()
                        local myChar = LocalPlayer.Character
                        if root and myChar then
                                refreshPumpkins() -- chỉ làm mới cache nếu đã quá 1.2s
                                for _, p in ipairs(MZ_World.drops) do
                                        if not State.PickupDrops then break end
                                        if p.Parent then
                                                local d = (p.Position - root.Position).Magnitude
                                                if d <= State.PickupRadius then
                                                        local fired = pcall(function()
                                                                firetouchinterest(root, p, 0)
                                                                firetouchinterest(root, p, 1)
                                                        end)
                                                        -- CHỈ dịch chuyển khi FARM ĐANG TẮT — hết bị kéo sang
                                                        -- nhặt "Candy Corn" trang trí giữa lúc farm bí ngô
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

-- ════════════════════════════ 13. PROXIMITY PROMPT (Cửa / Gacha) ══════════
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

-- chống spam lỗi "[DIALOGUE] there's already an active dialogue":
-- mỗi prompt chỉ fire 1 lần / 6 giây
local promptLastFired = {}

local function promptLoop(keywordsGetter, radiusGetter, statusKey)
        while State[statusKey] do
                local root = getRoot()
                if not root then
                        task.wait(1)
                elseif State.FarmPumpkin and MZ_Tween.running then
                        -- FIX "tự tele chỗ không có bí ngô": farm đang BAY → prompt
                        -- (gõ cửa / gacha) KHÔNG được tranh quyền điều khiển nhân vật
                        task.wait(1)
                else
                        local farmOn = State.FarmPumpkin
                        refreshPumpkins() -- cache chung — không quét lại map (giảm lag)
                        local maxD = radiusGetter()
                        if farmOn then
                                -- farm bật: chỉ bấm prompt TRONG TẦM đánh, KHÔNG tween xa
                                maxD = math.min(maxD, State.HitRange + 30)
                        end
                        local best, bestD, bestPart = nil, math.huge, nil
                        for _, pr in ipairs(MZ_World.prompts) do
                                if not State[statusKey] then break end
                                if pr.Enabled and pr.Parent
                                        and matchKeyword(
                                                table.concat({
                                                        pr.Name, pr.ActionText or "", pr.ObjectText or "",
                                                        pr.Parent and pr.Parent.Name or "",
                                                }, " "),
                                                keywordsGetter())
                                then
                                        local part = promptPart(pr)
                                        if part then
                                                local d = (part.Position - root.Position).Magnitude
                                                if d <= maxD and d < bestD then
                                                        best, bestD, bestPart = pr, d, part
                                                end
                                        end
                                end
                        end
                        if best then
                                if bestD > 10 and not farmOn then
                                        local away = (root.Position - bestPart.Position)
                                        if away.Magnitude > 0.1 then
                                                local goal = bestPart.CFrame + away.Unit * 6
                                                pcall(function()
                                                        MZ_Tween.to(CFrame.new(goal.Position), State.TweenSpeed, 5)
                                                end)
                                        end
                                end
                                if State[statusKey] and bestPart then
                                        local last = promptLastFired[best]
                                        if not last or os.clock() - last > 6 then
                                                promptLastFired[best] = os.clock()
                                                faceTarget(bestPart.Position)
                                                pcall(firePrompt, best)
                                        end
                                end
                                task.wait(1)
                        else
                                task.wait(1.2)
                        end
                end
        end
end

-- ════════════════════════════ 14. ESP BÍ NGÔ ══════════════════════════════
-- Viết lại từ ESP Pumpkin gốc của bạn + thêm tag khoảng cách + đổi màu live
local ESPObjects = {} -- [model] = { hl, bb, label, kind }

local function espRemove(model)
        local o = ESPObjects[model]
        if o then
                pcall(function() if o.hl then o.hl:Destroy() end end)
                pcall(function() if o.bb then o.bb:Destroy() end end)
                ESPObjects[model] = nil
        end
end

local function espClearAll()
        for m in pairs(ESPObjects) do
                espRemove(m)
        end
        ESPObjects = {}
end

local ESP_CAP = 100 -- giới hạn số Highlight để không tụt FPS

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
        refreshPumpkins() -- cache chung — không quét đè (giảm lag)
        local patches = MZ_World.patches

        if State.ESP then
                for _, m in ipairs(MZ_World.pumpkins) do
                        local r = modelRoot(m)
                        if r and camPos and isEventPumpkinTarget(m, r, patches) then
                                if maxR <= 0 or (r.Position - camPos).Magnitude <= maxR then
                                        espApply(m, "pumpkin")
                                end
                        end
                end
        end
        if State.ESPPatch then
                for _, m in ipairs(MZ_World.patches) do
                        local r = modelRoot(m)
                        if r and camPos then
                                if maxR <= 0 or (r.Position - camPos).Magnitude <= maxR then
                                        espApply(m, "patch")
                                end
                        end
                end
        end

        -- dọn ESP thừa
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
                if dead then
                        espRemove(m)
                end
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
        if myGen == EspGen then
                espClearAll()
        end
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

-- ════════════════════════════ 14b. GIẢM LAG / NO FX AN TOÀN ═══════════════
-- Tắt hiệu ứng TRỰC QUAN an toàn (particle / lửa / khói / sáng).
-- KHÔNG đụng Beam / Trail — vì script hiệu ứng của game tham chiếu chúng
-- (VD lỗi "Beam is not a valid member of Part 'StartBeam'" của
--  ReplicatedStorage.EffectContainer.Hellfire.Transformed.Z — lỗi game,
--  mình không phá Beam để tránh làm lỗi nặng hơn).
local NOFX_CLASSES = {
        ParticleEmitter = true,
        Fire = true,
        Smoke = true,
        Sparkles = true,
        PointLight = true,
        SurfaceLight = true,
        SpotLight = true,
}

local nofxConn = nil

local function nofxSweep(container)
        for _, d in ipairs(container:GetDescendants()) do
                if NOFX_CLASSES[d.ClassName] then
                        pcall(function()
                                d.Enabled = false
                        end)
                end
        end
end

local function setNoFX(on)
        if on then
                if not nofxConn then
                        nofxConn = workspace.DescendantAdded:Connect(function(d)
                                if NOFX_CLASSES[d.ClassName] then
                                        task.defer(function()
                                                if d.Parent then
                                                        pcall(function() d.Enabled = false end)
                                                end
                                        end)
                                end
                        end)
                        table.insert(Connections, nofxConn)
                end
                nofxSweep(workspace)
        end
        -- khi tắt: không bật lại particle cũ (tránh kích hoạt lại effect lỗi)
end

-- ════════════════════════════ 15. HOP SERVER ══════════════════════════════
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
                if not ok or type(res) ~= "table" or type(res.data) ~= "table" then
                        break
                end
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
                if not visited[id] then
                        table.insert(fresh, id)
                end
        end
        local pool = (#fresh > 0) and fresh or list
        if #pool == 0 then
                notify("Hop Server", "Không tìm thấy server nào khác!", "error")
                return
        end
        local job = pool[math.random(1, #pool)]
        visited[job] = true
        -- chỉ nhớ 20 server gần nhất
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

-- ════════════════════════════ 16. NẠP THƯ VIỆN MEIZU ══════════════════════
Library = getgenv().MeizuLibrary
if not Library then
        Library = loadstring(game:HttpGet(MEIZU_LIBRARY_URL))()
        getgenv().MeizuLibrary = Library
end

local Window = Library:CreateWindow({
        Title = "Meizu Hub",
        SubTitle = "Halloween Event 2026 🎃",
        Theme = "Midnight",
        Accent = Color3.fromRGB(255, 120, 0), -- cam halloween
        ToggleKeybind = Enum.KeyCode.LeftControl,
        Size = UDim2.fromOffset(640, 470),
})

-- ════════════════════════════ 17. TAB: FARM BÍ NGÔ ════════════════════════
local TabFarm = Window:CreateTab("Farm Bí Ngô")
local SecStatus = TabFarm:CreateSection("Trạng Thái")

local statusPara = SecStatus:CreateParagraph({
        Title = "🎃 Jack O' Lantern Hunt",
        Content = "Bí ngô khả dụng: ... | Trạng thái: Tắt",
})

local SecFarm = TabFarm:CreateSection("Auto Farm Bí Ngô")

SecFarm:CreateToggle({
        Title = "Bật Auto Farm Bí Ngô",
        Description = "Chỉ chọn bí ngô trong PumpkinPatch/được đánh dấu; giới hạn quanh vị trí bật farm.",
        Default = false,
        Callback = function(v)
                State.FarmPumpkin = v
                if v then
                        task.spawn(farmLoop)
                        if State.PickupDrops then
                                task.spawn(pickupLoop)
                        end
                        notify("Farm Bí Ngô", "Đã BẬT auto farm bí ngô!", "success")
                        -- chống bấm nhầm UI: tự thu nhỏ Hub sau 1.5s (Ctrl trái mở lại)
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
        Description = "Tự kích hoạt Haki Vũ Sắc khi đánh — đập bí ngô đau hơn hẳn, không cần bật tay.",
        Default = true,
        Callback = function(v)
                State.AutoBuso = v
                if v then
                        enableBuso()
                        task.spawn(busoLoop)
                end
        end,
})

SecFarm:CreateSlider({
        Title = "Khoảng cách đứng khi đập",
        Description = "Đứng SÁT CẠNH bí ngô để M1 không trượt (3–5 là sát nhất)",
        Min = 3, Max = 12, Default = State.StandDist, Rounding = 1, Suffix = " studs",
        Callback = function(v)
                State.StandDist = v
        end,
})

SecFarm:CreateDropdown({
        Title = "Chế độ farm",
        Options = { "Tới gần từng bí ngô", "Đập trong tầm (tự đuổi khi trống)" },
        Default = State.FarmMode,
        Callback = function(opt)
                State.FarmMode = opt
        end,
})

SecFarm:CreateDropdown({
        Title = "Lọc bí ngô",
        Options = { "Tất cả bí ngô", "Bỏ qua bí ngô sống/boss" },
        Default = State.FilterMode,
        Callback = function(opt)
                State.FilterMode = opt
        end,
})

SecFarm:CreateSlider({
        Title = "Tốc độ di chuyển",
        Min = 100, Max = 1000, Default = State.TweenSpeed, Rounding = 0, Suffix = " studs/s",
        Callback = function(v)
                State.TweenSpeed = v
        end,
})

SecFarm:CreateSlider({
        Title = "Bán kính farm quanh vị trí bật",
        Description = "Giới hạn vùng tìm mục tiêu để tránh đuổi bí ngô xa xuyên map",
        Min = 100, Max = 2000, Default = State.MaxFarmDistance, Rounding = 0, Suffix = " studs",
        Callback = function(v)
                State.MaxFarmDistance = v
        end,
})

SecFarm:CreateSlider({
        Title = "Tầm đập",
        Min = 10, Max = 80, Default = State.HitRange, Rounding = 0, Suffix = " studs",
        Callback = function(v)
                State.HitRange = v
        end,
})

SecFarm:CreateSlider({
        Title = "Delay mỗi hit",
        Min = 0.05, Max = 1, Default = State.HitDelay, Rounding = 2, Suffix = "s",
        Callback = function(v)
                State.HitDelay = v
        end,
})

SecFarm:CreateToggle({
        Title = "Chế độ Remote (RegisterHit)",
        Description = "MẶC ĐỊNH TẮT — server đa số CHẶN remote với bí ngô (lỗi CChain: out of radius). Để TẮT = đánh M1 giả lập người thật, ăn damage ổn định.",
        Default = false,
        Callback = function(v)
                State.FastAttack = v
                AtkMethod = v and "remote" or "m1"
                if v then
                        notify("Fast Attack", "Đang dùng remote — nếu bí ngô không mất máu thì hãy TẮT để quay về M1 người thật.", "warning")
                end
        end,
})

SecFarm:CreateToggle({
        Title = "Noclip khi farm",
        Default = true,
        Callback = function(v)
                State.Noclip = v
        end,
})

SecFarm:CreateToggle({
        Title = "Tự nhặt đồ rơi",
        Description = "Candy Corn / Pumpkin Bits trong bán kính bên dưới",
        Default = true,
        Callback = function(v)
                State.PickupDrops = v
                if v and (State.FarmPumpkin or State.TrickOrTreat) then
                        task.spawn(pickupLoop)
                end
        end,
})

SecFarm:CreateToggle({
        Title = "Tự thu nhỏ Hub khi farm",
        Description = "KHUYẾN NGHỊ BẬT — ẩn UI để click ảo KHÔNG bấm nhầm nút Hub (chính là nguyên nhân farm tự tắt trước đây). Nhấn Ctrl trái để mở lại Hub.",
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
        Callback = function(v)
                State.PickupRadius = v
        end,
})

SecFarm:CreateInput({
        Title = "Từ khóa đồ rơi (phân cách bằng ,)",
        Placeholder = "candy,corn,pumpkin,bit,spooky",
        Default = State.PickupKeywords,
        Callback = function(text)
                State.PickupKeywords = text or ""
        end,
})

-- ════════════════════════════ 18. TAB: ESP ════════════════════════════════
local TabESP = Window:CreateTab("ESP Bí Ngô")
local SecESPMain = TabESP:CreateSection("ESP Pumpkin (Jack O' Lantern)")

SecESPMain:CreateToggle({
        Title = "ESP Bí Ngô",
        Description = "Highlight mọi bí ngô trong map",
        Default = false,
        Callback = function(v)
                State.ESP = v
                task.spawn(espLoop)
                task.spawn(espLabelLoop)
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
        Callback = function(v)
                State.ESPDistance = v
        end,
})

SecESPMain:CreateSlider({
        Title = "Bán kính hiện ESP",
        Min = 0, Max = 5000, Default = 0, Rounding = 0, Suffix = " studs (0 = vô hạn)",
        Callback = function(v)
                State.ESPMaxRange = v
        end,
})

local SecESPColor = TabESP:CreateSection("Màu ESP")

SecESPColor:CreateColorPicker({
        Title = "Màu fill",
        Default = State.ESPFill,
        Callback = function(c)
                State.ESPFill = c
                for _, o in pairs(ESPObjects) do
                        pcall(function() o.hl.FillColor = c end)
                end
        end,
})

SecESPColor:CreateColorPicker({
        Title = "Màu viền",
        Default = State.ESPOutline,
        Callback = function(c)
                State.ESPOutline = c
                for _, o in pairs(ESPObjects) do
                        pcall(function() o.hl.OutlineColor = c end)
                end
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

-- ════════════════════════════ 19. TAB: SỰ KIỆN ════════════════════════════
local TabEvent = Window:CreateTab("Sự Kiện")
local SecEventInfo = TabEvent:CreateSection("Thông Tin Event Hellfire")

SecEventInfo:CreateParagraph({
        Title = "👻 Halloween 2026",
        Content = "• Mỗi đầu giờ (XX:00) map biến thành đêm Halloween → gõ CỬA để nhận Candy Corn\n"
                .. "• Đập bí ngô bất kỳ lúc nào bằng Fighting Style\n"
                .. "• Phù Thủy bán thuốc + Gacha 500 Candy Corn/lượt (2 lượt/giờ)\n"
                .. "• Giải lớn Gacha: Mutation Hellfire Gas 🔥",
})

local SecDoor = TabEvent:CreateSection("Auto Gõ Cửa (Trick-or-Treat)")

SecDoor:CreateToggle({
        Title = "Bật Auto Gõ Cửa",
        Description = "Tự tìm + gõ cửa khi event giờ bật (mỗi XX:00)",
        Default = false,
        Callback = function(v)
                State.TrickOrTreat = v
                if v then
                        task.spawn(function()
                                promptLoop(
                                        function() return State.KnockKeywords end,
                                        function() return State.KnockRadius end,
                                        "TrickOrTreat"
                                )
                        end)
                        if State.PickupDrops then
                                task.spawn(pickupLoop)
                        end
                        notify("Trick-or-Treat", "Đã bật auto gõ cửa!", "success")
                else
                        MZ_Tween.cancel()
                end
        end,
})

SecDoor:CreateInput({
        Title = "Từ khóa cửa (phân cách bằng ,)",
        Placeholder = "knock,door,trick,treat",
        Default = State.KnockKeywords,
        Callback = function(text)
                State.KnockKeywords = text or ""
        end,
})

SecDoor:CreateSlider({
        Title = "Bán kính quét cửa",
        Min = 100, Max = 50000, Default = State.KnockRadius, Rounding = 0, Suffix = " studs",
        Callback = function(v)
                State.KnockRadius = v
        end,
})

local SecGacha = TabEvent:CreateSection("Auto Gacha / Phù Thủy")

SecGacha:CreateToggle({
        Title = "Bật Auto Gacha (Witch)",
        Description = "Tự tìm Phù Thủy / nút Gacha gần nhất và bấm (cần đủ Candy Corn)",
        Default = false,
        Callback = function(v)
                State.Gacha = v
                if v then
                        task.spawn(function()
                                promptLoop(
                                        function() return State.GachaKeywords end,
                                        function() return State.KnockRadius end,
                                        "Gacha"
                                )
                        end)
                        notify("Gacha", "Đã bật auto gacha!", "success")
                else
                        MZ_Tween.cancel()
                end
        end,
})

SecGacha:CreateInput({
        Title = "Từ khóa gacha (phân cách bằng ,)",
        Placeholder = "roll,gacha,witch,brew,potion",
        Default = State.GachaKeywords,
        Callback = function(text)
                State.GachaKeywords = text or ""
        end,
})

-- ════════════════════════════ 20. TAB: KHÁC ═══════════════════════════════
local TabMisc = Window:CreateTab("Khác")
local SecMisc = TabMisc:CreateSection("Tiện Ích")

SecMisc:CreateToggle({
        Title = "Anti-AFK",
        Description = "Chống bị kick khi để farm lâu",
        Default = true,
        Callback = function(v)
                State.AntiAFK = v
        end,
})

SecMisc:CreateToggle({
        Title = "Giảm Lag (Tắt FX an toàn)",
        Description = "Tắt particle/lửa/khói/đèn hiệu ứng — KHÔNG đụng Beam/Trail để không lỗi game",
        Default = false,
        Callback = function(v)
                State.NoFX = v
                pcall(function() setNoFX(v) end)
                if v then
                        notify("Giảm Lag", "Đã tắt FX an toàn (particle/lửa/khói/đèn).", "success")
                end
        end,
})

SecMisc:CreateParagraph({
        Title = "🛠️ Về lỗi console trong game",
        Content = "• 'Disabled is not a valid member of NumberValue ... Rage' → lỗi của CHÍNH GAME (script Race/Buff của Blox Fruits), không liên quan script này, không ảnh hưởng farm.\n"
                .. "• 'CChain: out of radius' → xuất hiện khi bật Chế độ Remote (server từ chối hit). Mặc định remote đã TẮT nên lỗi này sẽ biến mất.\n"
                .. "• 'StartBeam / PartType' → lỗi hiệu ứng Hellfire Gas của game. Bật 'Giảm Lag' để bớt hiệu ứng lỗi.",
})

SecMisc:CreateToggle({
        Title = "Watermark FPS/Ping (Meizu Extras)",
        Default = false,
        Callback = function(v)
                pcall(function()
                        local Extras = getgenv().MeizuExtras
                        if Extras then
                                if v then
                                        Extras:EnableWatermark({ ShowFPS = true, ShowPing = true })
                                else
                                        Extras:DisableWatermark()
                                end
                        end
                end)
        end,
})

SecMisc:CreateButton({
        Title = "Hop Server (random)",
        Description = "Tìm server khác để có nhiều bí ngô mới",
        Callback = function()
                task.spawn(hopServer)
        end,
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
        Description = "Tắt mọi tính năng + xóa UI",
        Callback = function()
                if getgenv().MZ_Halloween_Unload then
                        getgenv().MZ_Halloween_Unload()
                end
        end,
})

SecMisc:CreateParagraph({
        Title = "ℹ️ Credits",
        Content = "Meizu Library & Hub — Nttp1721\n"
                .. "Tham khảo kỹ thuật: Banana Cat Hub (meizublf.lua)\n"
                .. "ESP Pumpkin gốc: FixedPumpkinESP của bạn",
})

-- ════════════════════════════ 21. VÒNG LẶP TRẠNG THÁI ════════════════════
task.spawn(function()
        while true do
                pcall(function()
                        if statusPara and statusPara.SetContent then
                                refreshPumpkins() -- đọc từ cache chung (giảm lag)
                                statusPara:SetContent(string.format(
                                        "🎃 Bí ngô trong map: %d   |   📍 PumpkinPatch: %d\n🎯 Trạng thái: %s",
                                        #MZ_World.pumpkins, #MZ_World.patches, State.StatusText or "Tắt"
                                ))
                        end
                end)
                task.wait(2)
        end
end)

-- ════════════════════════════ 22. UNLOAD ══════════════════════════════════
getgenv().MZ_Halloween_Unload = function()
        State.FarmPumpkin = false
        State.ESP = false
        State.ESPPatch = false
        State.TrickOrTreat = false
        State.Gacha = false
        State.PickupDrops = false
        State.AutoBuso = false
        State.NoFX = false
        MZ_Tween.cancel()
        espClearAll()
        for _, c in ipairs(Connections) do
                pcall(function() c:Disconnect() end)
        end
        Connections = {}
        pcall(function() Library:Destroy() end)
        getgenv().MZ_Halloween_Unload = nil
        print("[MZ Halloween] Đã gỡ script.")
end

-- ════════════════════════════ 23. KHỞI ĐỘNG ═══════════════════════════════
Window:SelectTab(1)
refreshPumpkins(true)
if State.AutoBuso then
        task.spawn(busoLoop) -- Buso mặc định BẬT → tự kích hoạt ngay từ khi nạp
end
notify("Meizu Hub 🎃", "Đã nạp Halloween Event 2026!\nBật tab [Farm Bí Ngô] để bắt đầu.", "success")
print("[MZ Halloween] Loaded — Meizu Hub Halloween 2026 v2.4 (target lock + farm radius) | Library: Meizu v3.1")
