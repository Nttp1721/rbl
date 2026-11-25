--[[
    MEIZU LIBRARY  v4.0  "Graphite"
    Thu vien UI cho Roblox (Luau). Viet lai tu v3.1, giu ten API cu.

    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/lib.lua"))()
    local Window  = Library:CreateWindow({ Title = "My Hub", Subtitle = "v1.0", ToggleKey = Enum.KeyCode.RightShift })
    local Tab     = Window:CreateTab("Main")
    local Sec     = Tab:CreateSection("Farm")           -- Section co the gap lai
    Sec:CreateToggle({ Title = "Auto Farm", Flag = "farm", Default = false, Callback = function(v) end })

    Phan tu (Tab hoac Section deu dung duoc):
      CreateButton CreateToggle CreateSlider CreateStepper CreateSegmented CreateDropdown CreateMultiDropdown
      CreateKeybind CreateInput CreateColorPicker CreateParagraph CreateLabel CreateDivider CreateProgress
      CreateStat (moi)  CreateSparkline (moi)
    Moi phan tu nhan them:  Tooltip = "...",  Flag = "ten",  Description = "...".
    Phan tu tra ve:  el:Set(v) el:Get() el:SetTitle() el:SetDesc() el:SetVisible(b) el:Destroy()   (goi el.Set(v) cung duoc)

    Window: CreateTab(name, icon) CreateTabGroup(name) SelectTab Open Close Toggle Dialog Notify OpenPalette Destroy
    Library: Notify SetTheme SetAccent SetRainbow SetLanguage AddTranslation SetPerformanceMode SaveConfig LoadConfig
             ListConfigs ExportConfig ImportConfig Watermark SetKeybindHUD Destroy
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local LocalizationService = game:GetService("LocalizationService")
local GuiService = game:GetService("GuiService")

local genv = (type(getgenv) == "function" and getgenv()) or _G
if type(genv.MeizuLibrary) == "table" and type(genv.MeizuLibrary.Destroy) == "function" then
    pcall(genv.MeizuLibrary.Destroy, genv.MeizuLibrary)
end

local Library = {
    Version = "4.0", Flags = {}, Unread = 0, History = {}, UIScale = 1,
    PerfMode = false, PerfSetting = "auto", Lang = "en", Folder = "Meizu",
    UI = {}, _Elems = {}, _conns = {}, _binds = {},
}
genv.MeizuLibrary = Library

-- ============================ HE THONG THIET KE ============================
-- Mot thang bo goc, mot thang chu, mot bo chuyen dong. Khong gradient, khong bong do.
local R = { sm = 6, md = 10, lg = 14 }
local FONT = { reg = Enum.Font.SourceSans, semi = Enum.Font.SourceSansSemibold, bold = Enum.Font.SourceSansBold }
local TS = { cap = 13, body = 15, title = 16, head = 19 }
local TOUCH = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local CARDH = TOUCH and 50 or 44
local function H(n) return TOUCH and n + 6 or n end
local EZ, ED = Enum.EasingStyle, Enum.EasingDirection
local M = {
    fast = TweenInfo.new(0.12, EZ.Quad, ED.Out),
    base = TweenInfo.new(0.2, EZ.Quint, ED.Out),
    slow = TweenInfo.new(0.34, EZ.Quint, ED.Out),
    pop = TweenInfo.new(0.3, EZ.Back, ED.Out),
}

local function C(r, g, b) return Color3.fromRGB(r, g, b) end
local SEM = { Danger = C(236, 98, 98), Success = C(92, 202, 142), Warning = C(242, 184, 72), Backdrop = C(0, 0, 0) }
local function theme(t)
    for k, v in pairs(SEM) do if t[k] == nil then t[k] = v end end
    return t
end
local THEMES = {
    Dark = theme{ Window = C(21, 21, 24), Surface = C(30, 30, 34), SurfaceHover = C(38, 38, 43), Stroke = C(48, 48, 54), StrokeHover = C(76, 76, 85), Text = C(240, 240, 244), TextDim = C(163, 163, 173), TextMuted = C(124, 124, 135), Track = C(54, 54, 61), Knob = C(250, 250, 252) },
    Light = theme{ Window = C(245, 243, 239), Surface = C(255, 255, 255), SurfaceHover = C(247, 245, 241), Stroke = C(226, 222, 214), StrokeHover = C(190, 184, 174), Text = C(32, 30, 28), TextDim = C(104, 100, 94), TextMuted = C(122, 117, 110), Track = C(214, 210, 202), Knob = C(255, 255, 255), Danger = C(206, 70, 70), Success = C(46, 160, 100), Warning = C(198, 138, 24), Backdrop = C(30, 28, 24) },
    Midnight = theme{ Window = C(14, 17, 27), Surface = C(22, 27, 41), SurfaceHover = C(29, 35, 53), Stroke = C(38, 46, 68), StrokeHover = C(64, 76, 108), Text = C(232, 236, 248), TextDim = C(146, 156, 182), TextMuted = C(112, 122, 150), Track = C(42, 50, 74), Knob = C(250, 252, 255) },
    Void = theme{ Window = C(0, 0, 0), Surface = C(14, 14, 15), SurfaceHover = C(22, 22, 24), Stroke = C(34, 34, 37), StrokeHover = C(62, 62, 68), Text = C(244, 244, 246), TextDim = C(150, 150, 158), TextMuted = C(112, 112, 120), Track = C(40, 40, 44), Knob = C(250, 250, 252) },
    Obsidian = theme{ Window = C(11, 11, 10), Surface = C(22, 21, 19), SurfaceHover = C(31, 29, 26), Stroke = C(46, 43, 37), StrokeHover = C(84, 77, 62), Text = C(238, 233, 222), TextDim = C(166, 158, 142), TextMuted = C(128, 121, 108), Track = C(52, 49, 43), Knob = C(250, 246, 236) },
    Forest = theme{ Window = C(15, 21, 19), Surface = C(22, 31, 28), SurfaceHover = C(29, 40, 36), Stroke = C(40, 55, 50), StrokeHover = C(68, 92, 84), Text = C(232, 242, 238), TextDim = C(146, 166, 158), TextMuted = C(112, 132, 124), Track = C(44, 60, 55), Knob = C(250, 252, 250) },
    Wine = theme{ Window = C(24, 16, 19), Surface = C(35, 24, 28), SurfaceHover = C(45, 31, 36), Stroke = C(62, 44, 50), StrokeHover = C(96, 70, 78), Text = C(246, 236, 238), TextDim = C(178, 156, 162), TextMuted = C(140, 120, 126), Track = C(68, 50, 56), Knob = C(252, 248, 249) },
}
local THEME_ORDER = { "Dark", "Light", "Midnight", "Void", "Obsidian", "Forest", "Wine" }
Library.Themes = THEMES

local ACCENTS = {
    { "Ember", C(255, 143, 64) }, { "Gold", C(242, 190, 72) }, { "Lime", C(160, 214, 72) }, { "Mint", C(72, 199, 163) },
    { "Ice", C(132, 214, 255) }, { "Sky", C(84, 156, 255) }, { "Violet", C(150, 122, 255) }, { "Rose", C(255, 99, 132) },
}
local WHITE, INK = C(255, 255, 255), C(22, 22, 26)
local function lum(c) return 0.2126 * c.R ^ 2.2 + 0.7152 * c.G ^ 2.2 + 0.0722 * c.B ^ 2.2 end
local function onAccentFor(c)
    local l = lum(c) + 0.05
    return (1.05 / l >= l / 0.07) and WHITE or INK
end

local Theme = { name = "Dark", c = THEMES.Dark }
local Accent = ACCENTS[1][2]
local OnAccent = onAccentFor(Accent)

-- ================================ TIEN ICH ================================
local GUIOBJ = { Frame = true, TextLabel = true, TextButton = true, TextBox = true, ImageLabel = true, ImageButton = true, ScrollingFrame = true }

local function New(class, props, kids)
    local o = Instance.new(class)
    if GUIOBJ[class] then
        o.BorderSizePixel = 0
        if class == "TextButton" or class == "ImageButton" then o.AutoButtonColor = false end
        if class == "TextLabel" or class == "TextButton" then o.Text = "" end
        if class == "TextLabel" or class == "TextButton" or class == "TextBox" then
            o.Font = Enum.Font.SourceSans
            o.TextSize = 15
        end
    end
    local parent
    if props then
        for k, v in pairs(props) do
            if k == "Parent" then parent = v else o[k] = v end
        end
    end
    if kids then for i = 1, #kids do kids[i].Parent = o end end
    if parent then o.Parent = parent end
    return o
end

local function Corner(p, r) return New("UICorner", { CornerRadius = UDim.new(0, r), Parent = p }) end
local function Stroke(p, col, th, tr)
    return New("UIStroke", { Color = col, Thickness = th or 1, Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p })
end
local function Pad(p, l, t, r, b)
    return New("UIPadding", { PaddingLeft = UDim.new(0, l or 0), PaddingTop = UDim.new(0, t or l or 0), PaddingRight = UDim.new(0, r or l or 0), PaddingBottom = UDim.new(0, b or t or l or 0), Parent = p })
end
local function List(p, gap, dir, ha, va)
    return New("UIListLayout", {
        Padding = UDim.new(0, gap or 0), SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = dir or Enum.FillDirection.Vertical,
        HorizontalAlignment = ha or Enum.HorizontalAlignment.Left,
        VerticalAlignment = va or Enum.VerticalAlignment.Top, Parent = p })
end

local function Tween(obj, ti, props)
    if not obj then return nil end
    if Library.PerfMode then
        for k, v in pairs(props) do obj[k] = v end
        return nil
    end
    local tw = TweenService:Create(obj, ti, props)
    tw:Play()
    return tw
end

-- song lan toa tu diem cham (chi dung cho Button; host phai ClipsDescendants)
local function Ripple(host, x, y)
    if Library.PerfMode or not host.Parent then return end
    local s = (Library.Window and Library.Window.Scale.Scale) or 1
    local ap, as = host.AbsolutePosition, host.AbsoluteSize
    local d = math.max(as.X, as.Y) / s * 1.4
    local r = New("Frame", { BackgroundColor3 = Accent, BackgroundTransparency = 0.75, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset((x - ap.X) / s, (y - ap.Y) / s), Size = UDim2.fromOffset(8, 8), ZIndex = 0, Parent = host })
    Corner(r, 999)
    TweenService:Create(r, TweenInfo.new(0.5, EZ.Quint, ED.Out), { Size = UDim2.fromOffset(d, d), BackgroundTransparency = 1 }):Play()
    task.delay(0.55, function() r:Destroy() end)
end

local function clamp(v, a, b) return math.max(a, math.min(b, v)) end
local function roundTo(v, step)
    if step <= 0 then return v end
    return math.floor(v / step + 0.5) * step
end
local function safe(fn, ...)
    if type(fn) ~= "function" then return false end
    local ok, err = pcall(fn, ...)
    if not ok then warn("[Meizu] " .. tostring(err)) end
    return ok
end
-- cho phep goi el:Set(v) lan el.Set(v)
local function method(el, fn)
    return function(self, ...)
        if self == el then return fn(...) end
        return fn(self, ...)
    end
end
local function debounce(delay, fn)
    local token = 0
    return function(...)
        token = token + 1
        local my, args = token, table.pack(...)
        task.delay(delay, function()
            if my == token then fn(table.unpack(args, 1, args.n)) end
        end)
    end
end

local measureCache = {}
local function Measure(text, size, font, width)
    local key = text .. "|" .. size .. "|" .. font.Name .. "|" .. tostring(width)
    local v = measureCache[key]
    if v then return v end
    local ok, res = pcall(TextService.GetTextSize, TextService, text, size, font, Vector2.new(width or 1000, 10000))
    v = ok and res or Vector2.new(#text * size * 0.5, size + 4)
    measureCache[key] = v
    return v
end

-- ---- chu Viet: bo dau de tim kiem, in hoa ----
local VN_LOW = { a = "àáạảãâầấậẩẫăằắặẳẵ", e = "èéẹẻẽêềếệểễ", i = "ìíịỉĩ", o = "òóọỏõôồốộổỗơờớợởỡ", u = "ùúụủũưừứựửữ", y = "ỳýỵỷỹ", d = "đ" }
local VN_UP = { a = "ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ", e = "ÈÉẸẺẼÊỀẾỆỂỄ", i = "ÌÍỊỈĨ", o = "ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ", u = "ÙÚỤỦŨƯỪỨỰỬỮ", y = "ỲÝỴỶỸ", d = "Đ" }
local FOLD, UPPER = {}, {}
for base, low in pairs(VN_LOW) do
    local lc, uc = {}, {}
    for _, cp in utf8.codes(low) do lc[#lc + 1] = cp end
    for _, cp in utf8.codes(VN_UP[base]) do uc[#uc + 1] = cp end
    for i = 1, #lc do
        FOLD[lc[i]] = string.byte(base)
        if uc[i] then FOLD[uc[i]] = string.byte(base); UPPER[lc[i]] = uc[i] end
    end
end
local function Norm(s)
    s = tostring(s or "")
    if not s:find("[\128-\255]") then return s:lower() end
    local ok, res = pcall(function()
        local out = {}
        for _, cp in utf8.codes(s) do
            local f = FOLD[cp]
            if f then out[#out + 1] = string.char(f)
            elseif cp < 128 then out[#out + 1] = string.char(cp):lower()
            else out[#out + 1] = utf8.char(cp) end
        end
        return table.concat(out)
    end)
    return ok and res or s:lower()
end
local function UpperVN(s)
    s = tostring(s or "")
    if not s:find("[\128-\255]") then return s:upper() end
    local ok, res = pcall(function()
        local out = {}
        for _, cp in utf8.codes(s) do
            if UPPER[cp] then out[#out + 1] = utf8.char(UPPER[cp])
            elseif cp < 128 then out[#out + 1] = string.char(cp):upper()
            else out[#out + 1] = utf8.char(cp) end
        end
        return table.concat(out)
    end)
    return ok and res or s:upper()
end

-- ---- base64 de chia se cau hinh ----
local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local B64R = {}
for i = 1, 64 do B64R[B64:byte(i)] = i - 1 end
local function b64enc(data)
    local out = {}
    for i = 1, #data, 3 do
        local a, b, c = data:byte(i, i + 2)
        local n = a * 65536 + (b or 0) * 256 + (c or 0)
        local c1, c2, c3, c4 = math.floor(n / 262144) % 64, math.floor(n / 4096) % 64, math.floor(n / 64) % 64, n % 64
        out[#out + 1] = B64:sub(c1 + 1, c1 + 1) .. B64:sub(c2 + 1, c2 + 1) .. (b and B64:sub(c3 + 1, c3 + 1) or "=") .. (c and B64:sub(c4 + 1, c4 + 1) or "=")
    end
    return table.concat(out)
end
local function b64dec(s)
    s = s:gsub("[^%w%+/=]", "")
    local out = {}
    for i = 1, #s, 4 do
        local a, b, c, d = s:byte(i, i + 3)
        local va, vb = B64R[a], B64R[b]
        if not va or not vb then return nil end
        local vc, vd = c and B64R[c], d and B64R[d]
        local n = va * 262144 + vb * 4096 + (vc or 0) * 64 + (vd or 0)
        out[#out + 1] = string.char(math.floor(n / 65536) % 256)
        if vc then out[#out + 1] = string.char(math.floor(n / 256) % 256) end
        if vd then out[#out + 1] = string.char(n % 256) end
    end
    return table.concat(out)
end

-- ============================ NGON NGU (vi / en) ============================
local Strings = {
    en = {},
    vi = {
        ["Search"] = "Tìm kiếm", ["Search features..."] = "Tìm tính năng...", ["Run"] = "Chạy", ["Select"] = "Chọn", ["None"] = "Không",
        ["Settings"] = "Cài đặt", ["Appearance"] = "Giao diện", ["Theme"] = "Chủ đề", ["Accent color"] = "Màu nhấn",
        ["Rainbow accent"] = "Màu nhấn cầu vồng", ["Language"] = "Ngôn ngữ", ["Blur background"] = "Làm mờ nền",
        ["Interface scale"] = "Kích thước giao diện", ["Performance"] = "Hiệu năng", ["Lite mode"] = "Chế độ tiết kiệm",
        ["Auto"] = "Tự động", ["On"] = "Bật", ["Off"] = "Tắt", ["Show FPS watermark"] = "Hiện FPS / Ping",
        ["Keybind HUD"] = "Bảng phím tắt", ["Toggle key"] = "Phím ẩn / hiện", ["Configuration"] = "Cấu hình", ["Slot"] = "Ô lưu",
        ["Save"] = "Lưu", ["Load"] = "Tải", ["Auto load on start"] = "Tự tải khi khởi động",
        ["Copy share code"] = "Sao chép mã chia sẻ", ["Import share code"] = "Nhập mã chia sẻ", ["Paste code here"] = "Dán mã vào đây",
        ["Notifications"] = "Thông báo", ["Clear"] = "Xóa", ["No notifications yet"] = "Chưa có thông báo",
        ["Unload UI"] = "Gỡ giao diện", ["Unload"] = "Gỡ", ["Cancel"] = "Hủy", ["OK"] = "OK", ["About"] = "Giới thiệu",
        ["Config saved"] = "Đã lưu cấu hình", ["Config loaded"] = "Đã tải cấu hình", ["Nothing saved in this slot"] = "Ô này chưa có dữ liệu",
        ["Code copied"] = "Đã sao chép mã", ["Invalid code"] = "Mã không hợp lệ", ["Press a key..."] = "Nhấn một phím...",
        ["Keybinds"] = "Phím tắt", ["more, keep typing"] = "mục nữa, gõ để lọc", ["Commands"] = "Lệnh", ["Recent"] = "Gần đây",
        ["Tabs"] = "Tab", ["Lite mode on"] = "Đã bật chế độ tiết kiệm", ["Lite mode off"] = "Đã tắt chế độ tiết kiệm",
        ["Files are not available in this executor"] = "Executor này không hỗ trợ lưu file", ["Interface"] = "Giao diện",
        ["Switch theme"] = "Đổi chủ đề", ["Toggle lite mode"] = "Bật / tắt chế độ tiết kiệm", ["Save config"] = "Lưu cấu hình",
        ["Remove this UI?"] = "Gỡ giao diện này?", ["Everything in this window will be closed."] = "Toàn bộ cửa sổ sẽ bị đóng.",
    },
}
local function tr(s)
    local d = Strings[Library.Lang]
    return (d and d[s]) or s
end
function Library:AddTranslation(a, b)
    local t = type(a) == "table" and a or { [a] = b }
    for lang, dict in pairs(t) do
        if type(dict) == "table" then
            Strings[lang] = Strings[lang] or {}
            for k, v in pairs(dict) do Strings[lang][k] = v end
        end
    end
end
do
    local ok, id = pcall(function() return LocalizationService.RobloxLocaleId end)
    if ok and type(id) == "string" and id:sub(1, 2) == "vi" then Library.Lang = "vi" end
end

-- =================== BINDING: theme / accent / ngon ngu theo scope ===================
-- Moi tab co 1 scope. Tab dang an chi danh dau "dirty", khi mo ra moi ap dung -> doi theme chi ton chi phi cua phan dang thay.
local Scopes = {}
local function newScope(active)
    local s = { t = {}, a = {}, f = {}, l = {}, active = active == true, dT = false, dA = false, dL = false }
    Scopes[#Scopes + 1] = s
    return s
end
local Chrome = newScope(true)

local function runF(s) local f = s.f; for i = 1, #f do f[i]() end end
local function applyT(s)
    local c, t = Theme.c, s.t
    for i = 1, #t do local b = t[i]; b[1][b[2]] = c[b[3]] end
    runF(s); s.dT = false
end
local function applyA(s)
    local a, o, t = Accent, OnAccent, s.a
    for i = 1, #t do local b = t[i]; b[1][b[2]] = (b[3] == 1) and a or o end
    runF(s); s.dA = false
end
local function applyL(s)
    local l = s.l
    for i = 1, #l do
        local b = l[i]
        local txt = tr(b[2])
        b[1].Text = b[3] and UpperVN(txt) or txt
    end
    s.dL = false
end
local function activate(s)
    s.active = true
    if s.dT then applyT(s) end
    if s.dA then applyA(s) end
    if s.dL then applyL(s) end
end
local function removeScope(s)
    for i = #Scopes, 1, -1 do if Scopes[i] == s then table.remove(Scopes, i) end end
end

local function bindT(scope, inst, prop, key)
    scope.t[#scope.t + 1] = { inst, prop, key }
    inst[prop] = Theme.c[key]
end
local function bindA(scope, inst, prop, onAccent)
    scope.a[#scope.a + 1] = { inst, prop, onAccent and 2 or 1 }
    inst[prop] = onAccent and OnAccent or Accent
end
local function bindF(scope, fn)
    scope.f[#scope.f + 1] = fn
    fn()
end
local function loc(scope, label, text, upper)
    scope.l[#scope.l + 1] = { label, text, upper }
    local txt = tr(text)
    label.Text = upper and UpperVN(txt) or txt
end

local function Label(parent, scope, text, size, font, key, extra)
    local l = New("TextLabel", {
        BackgroundTransparency = 1, Text = text or "", TextSize = size or TS.body, Font = font or FONT.reg,
        TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = parent })
    if extra then for k, v in pairs(extra) do l[k] = v end end
    bindT(scope, l, "TextColor3", key or "Text")
    return l
end

local function eachScope(fnActive, flag)
    for i = 1, #Scopes do
        local s = Scopes[i]
        if s.active then fnActive(s) else s[flag] = true end
    end
end

-- ============================= LUU TRU (file) =============================
local FS = { ok = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function" }
local function ensureFolder(path)
    if type(isfolder) ~= "function" or type(makefolder) ~= "function" then return end
    local acc = ""
    for part in path:gmatch("[^/]+") do
        acc = acc == "" and part or (acc .. "/" .. part)
        if not isfolder(acc) then pcall(makefolder, acc) end
    end
end
local Store = {}
function Store.read(path)
    if not FS.ok then return nil end
    local ok, exists = pcall(isfile, path)
    if not ok or not exists then return nil end
    local ok2, raw = pcall(readfile, path)
    if not ok2 then return nil end
    local ok3, data = pcall(HttpService.JSONDecode, HttpService, raw)
    return ok3 and data or nil
end
function Store.write(path, tbl)
    if not FS.ok then return false end
    local dir = path:match("^(.*)/[^/]+$")
    if dir then ensureFolder(dir) end
    local ok, raw = pcall(HttpService.JSONEncode, HttpService, tbl)
    if not ok then return false end
    return pcall(writefile, path, raw)
end
local function ser(v)
    local t = typeof(v)
    if t == "Color3" then return { __c = { math.floor(v.R * 255 + 0.5), math.floor(v.G * 255 + 0.5), math.floor(v.B * 255 + 0.5) } } end
    if t == "table" then
        local o = {}
        for i, x in ipairs(v) do o[i] = ser(x) end
        return o
    end
    if t == "boolean" or t == "number" or t == "string" then return v end
    return nil
end
local function des(v)
    if type(v) == "table" then
        if v.__c then return Color3.fromRGB(v.__c[1] or 0, v.__c[2] or 0, v.__c[3] or 0) end
        local o = {}
        for i, x in ipairs(v) do o[i] = des(x) end
        return o
    end
    return v
end
local function path(...) return Library.Folder .. "/" .. table.concat({ ... }, "/") end

function Library:_LoadUI()
    local d = Store.read(path("ui.json"))
    if type(d) ~= "table" then return end
    self.UI = d
    if d.lang == "vi" or d.lang == "en" then self.Lang = d.lang end
    if type(d.theme) == "string" and THEMES[d.theme] then Theme.name = d.theme; Theme.c = THEMES[d.theme] end
    if type(d.accent) == "table" and #d.accent == 3 then Accent = C(d.accent[1], d.accent[2], d.accent[3]); OnAccent = onAccentFor(Accent) end
    if type(d.scale) == "number" then self.UIScale = clamp(d.scale, 0.7, 1.3) end
    if d.perf == "on" or d.perf == "off" or d.perf == "auto" then self.PerfSetting = d.perf; self.PerfMode = d.perf == "on" end
    self.BlurEnabled = d.blur == true
    self.Rainbow = d.rainbow == true
end
Library._SaveUIDeb = debounce(1.2, function()
    Store.write(path("ui.json"), Library.UI)
end)
function Library:_SaveUI() self._SaveUIDeb() end

-- ================================ NHIP (Heartbeat) ================================
-- Mot ket noi Heartbeat duy nhat, chi ton tai khi co viec can lam (cua so mo / watermark / rainbow).
local Pulse = { list = {}, conn = nil, frames = 0, fps = 60, low = 0, high = 0, autoOn = false }
local function pulseStep(dt)
    Pulse.frames = Pulse.frames + 1
    local list = Pulse.list
    for i = 1, #list do
        local t = list[i]
        if t then
            t.acc = t.acc + dt
            if t.acc >= t.every then
                local d = t.acc
                t.acc = 0
                t.fn(d)
            end
        end
    end
end
function Pulse.remove(name)
    for i = #Pulse.list, 1, -1 do
        if Pulse.list[i].name == name then table.remove(Pulse.list, i) end
    end
    if #Pulse.list == 0 and Pulse.conn then Pulse.conn:Disconnect(); Pulse.conn = nil end
end
function Pulse.add(name, every, fn)
    for i = 1, #Pulse.list do
        if Pulse.list[i].name == name then Pulse.list[i].every = every; Pulse.list[i].fn = fn; return end
    end
    Pulse.list[#Pulse.list + 1] = { name = name, every = every, acc = 0, fn = fn }
    if not Pulse.conn then Pulse.conn = RunService.Heartbeat:Connect(pulseStep) end
end

local function onFps(d)
    local fps = Pulse.frames / d
    Pulse.frames = 0
    Pulse.fps = fps
    if Library.PerfSetting ~= "auto" then return end
    if fps < 22 then Pulse.low = Pulse.low + 1; Pulse.high = 0
    elseif fps > 52 then Pulse.high = Pulse.high + 1; Pulse.low = 0
    else Pulse.low = 0; Pulse.high = 0 end
    if not Library.PerfMode and Pulse.low >= 4 then Library:_SetPerf(true, true)
    elseif Library.PerfMode and Pulse.autoOn and Pulse.high >= 12 then Library:_SetPerf(false, true) end
end

local rainbowHue = 0
local function setAccentRaw(col)
    Accent = col
    OnAccent = onAccentFor(col)
    eachScope(applyA, "dA")
end
local function onRainbow(d)
    rainbowHue = (rainbowHue + d * 0.1) % 1
    setAccentRaw(Color3.fromHSV(rainbowHue, 0.6, 1))
end

function Library:_Sync()
    local open = self.Window ~= nil and self.Window.IsOpen == true
    if open or self.WatermarkOn then Pulse.add("fps", 0.5, onFps) else Pulse.remove("fps") end
    if self.Rainbow and open and not self.PerfMode then Pulse.add("rainbow", 1 / 15, onRainbow) else Pulse.remove("rainbow") end
end
function Library:_SetPerf(on, auto)
    if self.PerfMode == on then return end
    self.PerfMode = on
    if self.Window and self.Window.Glow then self.Window.Glow.Visible = not on end
    Pulse.autoOn = (auto and on) or false
    self:_Sync()
    if auto then self:Notify({ Title = tr(on and "Lite mode on" or "Lite mode off"), Duration = 3 }) end
end
function Library:SetPerformanceMode(mode)
    if mode == true then mode = "on" elseif mode == false then mode = "off" end
    self.PerfSetting = mode
    Pulse.low, Pulse.high = 0, 0
    if mode == "on" then self:_SetPerf(true, false) elseif mode == "off" then self:_SetPerf(false, false) end
    self.UI.perf = mode
    self:_SaveUI()
end

-- ============================== THEME / ACCENT / LANG ==============================
function Library:SetTheme(name)
    local t = THEMES[name]
    if not t then return false end
    Theme.name = name; Theme.c = t
    eachScope(applyT, "dT")
    self.UI.theme = name
    self:_SaveUI()
    return true
end
function Library:GetThemes() return THEME_ORDER end
function Library:SetAccent(col)
    if typeof(col) ~= "Color3" then return end
    setAccentRaw(col)
    self.UI.accent = { math.floor(col.R * 255 + 0.5), math.floor(col.G * 255 + 0.5), math.floor(col.B * 255 + 0.5) }
    self:_SaveUI()
end
function Library:SetRainbow(on)
    self.Rainbow = on == true
    self.UI.rainbow = self.Rainbow
    self:_Sync()
    if not self.Rainbow and self.UI.accent then
        local a = self.UI.accent
        setAccentRaw(C(a[1], a[2], a[3]))
    end
    self:_SaveUI()
end
function Library:SetLanguage(lang)
    if lang ~= "vi" and lang ~= "en" then return end
    self.Lang = lang
    eachScope(applyL, "dL")
    self.UI.lang = lang
    self:_SaveUI()
    if self.Window and self.Window._onLang then self.Window:_onLang() end
end
local BlurFx
function Library:_Blur(on)
    if not self.BlurEnabled then on = false end
    pcall(function()
        if not BlurFx or not BlurFx.Parent then BlurFx = New("BlurEffect", { Name = "MeizuBlur", Size = 0, Parent = Lighting }) end
        Tween(BlurFx, M.slow, { Size = on and 12 or 0 })
    end)
end

-- ================================ INPUT TRUNG TAM ================================
local Pointer = { move = nil, done = nil }
function Pointer.begin(move, done) Pointer.move = move; Pointer.done = done end
function Pointer.cancel()
    local d = Pointer.done
    Pointer.move = nil; Pointer.done = nil
    if d then d() end
end
local Hub = { fns = {}, capture = nil }
function Hub.add(fn) Hub.fns[#Hub.fns + 1] = fn; return fn end
function Hub.remove(fn)
    for i = #Hub.fns, 1, -1 do if Hub.fns[i] == fn then table.remove(Hub.fns, i) end end
end
local function isPress(i)
    return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end

-- InputObject.Position nam trong he toa do "GUI" (da tru inset); AbsolutePosition cua ScreenGui IgnoreGuiInset thi khong -> cong inset vao.
local function spos(i)
    return Vector2.new(i.Position.X, i.Position.Y) + GuiService:GetGuiInset()
end
local function track(conn) Library._conns[#Library._conns + 1] = conn; return conn end
track(UserInputService.InputChanged:Connect(function(i)
    if Pointer.move and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        Pointer.move(spos(i))
    end
end))
track(UserInputService.InputEnded:Connect(function(i)
    if Pointer.move and isPress(i) then Pointer.cancel() end
end))
track(UserInputService.InputBegan:Connect(function(i, gp)
    if Hub.capture and Hub.capture(i) then return end
    for k = 1, #Hub.fns do
        local fn = Hub.fns[k]
        if fn and fn(i, gp) then return end
    end
end))

-- ============================ GUI GOC + THONG BAO ============================
local Gui, NotifyHolder, notifyOrder = nil, nil, 0
local liveNotifs = {}

local function mountGui(g)
    local ok = false
    if type(gethui) == "function" then ok = pcall(function() g.Parent = gethui() end) end
    if not ok or not g.Parent then
        if syn and syn.protect_gui then pcall(syn.protect_gui, g) end
        ok = pcall(function() g.Parent = CoreGui end)
    end
    if not ok or not g.Parent then g.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end
end
local function ensureGui()
    if Gui and Gui.Parent then return Gui end
    Gui = New("ScreenGui", { Name = HttpService:GenerateGUID(false), ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true, DisplayOrder = 999999 })
    mountGui(Gui)
    Library.Gui = Gui
    return Gui
end

function Library:Notify(a, b, c, d)
    local cfg = type(a) == "table" and a or { Title = a, Content = b, Duration = c, Type = d }
    local title = tostring(cfg.Title or cfg.Name or "")
    local body = cfg.Content or cfg.Text or cfg.Description
    body = body ~= nil and tostring(body) or ""
    local kind = string.lower(tostring(cfg.Type or "info"))
    if kind == "err" then kind = "error" elseif kind == "warn" then kind = "warning" end
    local dur = tonumber(cfg.Duration) or 4
    local hist = self.History
    hist[#hist + 1] = { title = title, body = body, kind = kind, time = os.time() }
    if #hist > 40 then table.remove(hist, 1) end
    if self.Window and not self.Window.IsOpen then
        self.Unread = self.Unread + 1
        if self._onUnread then self._onUnread() end
    end
    if self.NotifyOff then return nil end

    local g = ensureGui()
    local c3 = Theme.c
    local col = (kind == "success" and c3.Success) or (kind == "warning" and c3.Warning) or (kind == "error" and c3.Danger) or Accent
    if not NotifyHolder or not NotifyHolder.Parent then
        NotifyHolder = New("Frame", { Name = "Notifications", BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, -16), Size = UDim2.new(0, 300, 1, -32), Parent = g })
        List(NotifyHolder, 8, nil, nil, Enum.VerticalAlignment.Bottom)
    end
    notifyOrder = notifyOrder + 1
    local wrap = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = notifyOrder, Parent = NotifyHolder })
    local card = New("Frame", { BackgroundColor3 = c3.Surface, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.new(1, 330, 0, 0), Parent = wrap })
    Corner(card, R.md)
    Stroke(card, c3.Stroke)
    Corner(New("Frame", { BackgroundColor3 = col, Size = UDim2.new(0, 3, 1, -22), Position = UDim2.new(0, 9, 0, 11), Parent = card }), 2)
    local box = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = card })
    Pad(box, 22, 11, 14, 13)
    List(box, 3)
    if title ~= "" then
        New("TextLabel", { BackgroundTransparency = 1, Text = title, Font = FONT.semi, TextSize = TS.title, TextColor3 = c3.Text, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1, Parent = box })
    end
    if body ~= "" then
        New("TextLabel", { BackgroundTransparency = 1, Text = body, Font = FONT.reg, TextSize = TS.body - 1, TextColor3 = c3.TextDim, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2, Parent = box })
    end
    local prog = New("Frame", { BackgroundColor3 = col, BackgroundTransparency = 0.4, Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2), Parent = card })
    local dead = false
    local function dismiss()
        if dead then return end
        dead = true
        Tween(card, M.base, { Position = UDim2.new(1, 330, 0, 0) })
        task.delay(0.24, function() wrap:Destroy() end)
    end
    local hit = New("TextButton", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 3, Parent = card })
    hit.Activated:Connect(dismiss)
    Tween(card, M.slow, { Position = UDim2.new(0, 0, 0, 0) })
    if dur > 0 and dur < 1e6 then
        if Library.PerfMode then prog.Visible = false else Tween(prog, TweenInfo.new(dur, EZ.Linear), { Size = UDim2.new(0, 0, 0, 2) }) end
        task.delay(dur, dismiss)
    else
        prog.Visible = false
    end
    liveNotifs[#liveNotifs + 1] = dismiss
    if #liveNotifs > 5 then table.remove(liveNotifs, 1)() end
    return { Dismiss = dismiss }
end

-- ================================== TOOLTIP ==================================
local Tip = { frame = nil, label = nil }
local function tipHide() if Tip.frame then Tip.frame.Visible = false end end
local function tipShow(text)
    local g = ensureGui()
    local c3 = Theme.c
    if not Tip.frame or not Tip.frame.Parent then
        Tip.frame = New("Frame", { Name = "Tip", Visible = false, ZIndex = 200, Parent = g })
        Corner(Tip.frame, R.sm)
        Tip.stroke = Stroke(Tip.frame, c3.StrokeHover)
        Tip.label = New("TextLabel", { BackgroundTransparency = 1, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, Font = FONT.reg, TextSize = TS.body - 1, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), ZIndex = 201, Parent = Tip.frame })
    end
    text = tr(text)
    local b = Measure(text, TS.body - 1, FONT.reg, 240)
    local w, h = math.min(b.X, 240) + 22, b.Y + 14
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
    local m = UserInputService:GetMouseLocation()
    Tip.frame.BackgroundColor3 = c3.Surface
    Tip.stroke.Color = c3.StrokeHover
    Tip.label.TextColor3 = c3.Text
    Tip.label.Text = text
    Tip.frame.Size = UDim2.fromOffset(w, h)
    Tip.frame.Position = UDim2.fromOffset(clamp(m.X + 14, 8, vp.X - w - 8), clamp(m.Y + 20, 8, vp.Y - h - 8))
    Tip.frame.Visible = true
end
function Library._Tip(gui, text)
    local token = 0
    gui.MouseEnter:Connect(function()
        token = token + 1
        local my = token
        task.delay(0.45, function() if my == token then tipShow(text) end end)
    end)
    gui.MouseLeave:Connect(function() token = token + 1; tipHide() end)
    gui.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            token = token + 1
            local my = token
            task.delay(0.55, function()
                if my == token then
                    tipShow(text)
                    task.delay(2.4, function() if my == token then tipHide() end end)
                end
            end)
        end
    end)
    gui.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then token = token + 1 end end)
end

-- ================================ KHUNG GIAO DIEN ================================
local Container = {}
Container.__index = Container
local TabMT = setmetatable({}, { __index = Container })
TabMT.__index = TabMT
local SectionMT = setmetatable({}, { __index = Container })
SectionMT.__index = SectionMT
local WindowMT = {}
WindowMT.__index = WindowMT
local Features = {}
local U = {}

function Container:_Next() self._order = self._order + 1; return self._order end
function Container:_Index(item)
    local tab = self.Tab
    if tab then tab.Items[#tab.Items + 1] = item end
end

function U.first(s)
    s = tostring(s or "?")
    local off = utf8.offset(s, 2)
    return off and s:sub(1, off - 1) or s
end
function U.hairline(parent, scope, size, pos)
    local f = New("Frame", { Size = size, Position = pos, Parent = parent })
    bindT(scope, f, "BackgroundColor3", "Stroke")
    return f
end
-- mui ten nho (v). Xoay 180 khi mo, -90 khi gap.
function U.chevron(parent, scope, pos, anchor)
    local c = New("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(12, 8), AnchorPoint = anchor or Vector2.new(1, 0.5), Position = pos or UDim2.new(1, -4, 0.5, 0), Parent = parent })
    for i = 1, 2 do
        local b = New("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(7, 2), Position = UDim2.fromOffset(i == 1 and 4 or 8, 4), Rotation = i == 1 and 45 or -45, Parent = c })
        Corner(b, 1)
        bindT(scope, b, "BackgroundColor3", "TextMuted")
    end
    return c
end

-- ================================ SECTION (gap lai duoc) ================================
function Container:CreateSection(a, b)
    local cfg = type(a) == "table" and a or (type(b) == "table" and b or {})
    local title = type(a) == "string" and a or cfg.Title or cfg.Name or ""
    local scope = self.Scope
    local wrap = New("Frame", { Name = "Section", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = self:_Next(), Parent = self.Frame })
    List(wrap, 8)
    local head = New("TextButton", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22), LayoutOrder = 0, Parent = wrap })
    local lbl = Label(head, scope, "", 12, FONT.bold, "TextMuted", { Size = UDim2.new(1, -24, 1, 0), AutomaticSize = Enum.AutomaticSize.None, Position = UDim2.new(0, 2, 0, 0) })
    loc(scope, lbl, title, true)
    local chev = U.chevron(head, scope, UDim2.new(1, -6, 0.5, 0))
    local body = New("Frame", { Name = "Body", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1, Parent = wrap })
    List(body, 8)
    local sec = setmetatable({ Frame = body, Scope = scope, Tab = self.Tab, Window = self.Window, Wrap = wrap, Title = title, Collapsed = false, _order = 0 }, SectionMT)
    function sec:SetCollapsed(v)
        self.Collapsed = v == true
        body.Visible = not self.Collapsed
        Tween(chev, M.base, { Rotation = self.Collapsed and -90 or 0 })
    end
    function sec:SetTitle(t) title = t; loc(scope, lbl, t, true) end
    function sec:SetVisible(v) wrap.Visible = v ~= false end
    function sec:Destroy() wrap:Destroy() end
    head.Activated:Connect(function() sec:SetCollapsed(not sec.Collapsed) end)
    if cfg.Collapsed then sec:SetCollapsed(true) end
    return sec
end

-- ================================ CUA SO ================================
function Library:CreateWindow(cfg)
    cfg = cfg or {}
    if self.Window then self.Window:Destroy() end
    self.Folder = (tostring(cfg.Folder or cfg.ConfigFolder or cfg.ConfigName or cfg.Name or cfg.Title or "Meizu"):gsub("[^%w _%-]", ""))
    self:_LoadUI()
    local g = ensureGui()
    local title = tostring(cfg.Title or cfg.Name or "Meizu")
    local w, h = 640, 420
    if typeof(cfg.Size) == "Vector2" then w, h = cfg.Size.X, cfg.Size.Y
    elseif typeof(cfg.Size) == "UDim2" then w, h = cfg.Size.X.Offset, cfg.Size.Y.Offset end
    w, h = clamp(w, 460, 980), clamp(h, 320, 700)
    local key = cfg.ToggleKey or cfg.Keybind or cfg.MinimizeKey or Enum.KeyCode.RightShift
    if type(self.UI.key) == "string" then
        local ok, kc = pcall(function() return Enum.KeyCode[self.UI.key] end)
        if ok and kc then key = kc end
    end
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
    local win = setmetatable({
        Library = self, Title = title, Subtitle = tostring(cfg.Subtitle or cfg.SubTitle or cfg.Version or ""),
        Size = Vector2.new(w, h), Pos = Vector2.new(vp.X / 2, vp.Y / 2), Tabs = {}, Groups = {}, IsOpen = false,
        ToggleKey = key, Rail = false, _fitScale = 1, _tabOrder = 0, _groupCount = 0, _conns = {}, _destroyers = {}, Config = cfg,
    }, WindowMT)
    self.Window = win

    local root = New("Frame", { Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(win.Pos.X, win.Pos.Y), Size = UDim2.fromOffset(w, h), ClipsDescendants = true, Visible = false, Parent = g })
    Corner(root, R.lg)
    bindT(Chrome, root, "BackgroundColor3", "Window")
    bindT(Chrome, Stroke(root, Theme.c.Stroke), "Color", "Stroke")
    win.Root = root
    win.Scale = New("UIScale", { Scale = 1, Parent = root })

    -- ---- sidebar ----
    local sb = New("Frame", { Name = "Sidebar", BackgroundTransparency = 1, Size = UDim2.new(0, 176, 1, 0), Parent = root })
    U.hairline(sb, Chrome, UDim2.new(0, 1, 1, 0), UDim2.new(1, -1, 0, 0))
    local brand = New("TextButton", { Name = "Brand", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 62), Parent = sb })
    local logo = New("Frame", { Size = UDim2.fromOffset(32, 32), Position = UDim2.new(0, 14, 0.5, -16), Parent = brand })
    Corner(logo, R.md)
    bindA(Chrome, logo, "BackgroundColor3")
    local logoTxt = New("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = UpperVN(U.first(title)), Font = FONT.bold, TextSize = 18, Parent = logo })
    bindA(Chrome, logoTxt, "TextColor3", true)
    local brandText = New("Frame", { BackgroundTransparency = 1, Position = UDim2.new(0, 54, 0, 0), Size = UDim2.new(1, -62, 1, 0), Parent = brand })
    local tTitle = Label(brandText, Chrome, title, TS.title, FONT.semi, "Text", { Position = UDim2.new(0, 0, 0.5, win.Subtitle ~= "" and -19 or -9), Size = UDim2.new(1, 0, 0, 18), AutomaticSize = Enum.AutomaticSize.None, TextTruncate = Enum.TextTruncate.AtEnd })
    local tSub = Label(brandText, Chrome, win.Subtitle, 12, FONT.reg, "TextMuted", { Position = UDim2.new(0, 0, 0.5, 1), Size = UDim2.new(1, 0, 0, 14), AutomaticSize = Enum.AutomaticSize.None, TextTruncate = Enum.TextTruncate.AtEnd })
    win.BrandText, win.TitleLabel, win.SubLabel = brandText, tTitle, tSub
    local list = New("ScrollingFrame", { Name = "Tabs", BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 62), Size = UDim2.new(1, 0, 1, -114), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.Y, Parent = sb })
    Pad(list, 8, 4, 8, 4)
    List(list, 2)
    local foot = New("Frame", { Name = "Foot", BackgroundTransparency = 1, Position = UDim2.new(0, 0, 1, -52), Size = UDim2.new(1, 0, 0, 52), Parent = sb })
    U.hairline(foot, Chrome, UDim2.new(1, -16, 0, 1), UDim2.new(0, 8, 0, 0))
    Pad(foot, 8, 8, 8, 6)
    win.Sidebar, win.TabList, win.Foot = sb, list, foot

    -- ---- header ----
    local head = New("Frame", { Name = "Header", BackgroundTransparency = 1, Position = UDim2.new(0, 176, 0, 0), Size = UDim2.new(1, -176, 0, 54), Parent = root })
    U.hairline(head, Chrome, UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 1, -1))
    win.TabTitleLabel = Label(head, Chrome, "", TS.head, FONT.semi, "Text", { Position = UDim2.new(0, 18, 0, 0), Size = UDim2.new(1, -190, 1, 0), AutomaticSize = Enum.AutomaticSize.None, TextTruncate = Enum.TextTruncate.AtEnd })
    local close = New("TextButton", { Text = "×", Font = FONT.reg, TextSize = 26, BackgroundTransparency = 1, Size = UDim2.fromOffset(32, 32), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Parent = head })
    bindT(Chrome, close, "TextColor3", "TextDim")
    close.MouseEnter:Connect(function() close.TextColor3 = Theme.c.Danger end)
    close.MouseLeave:Connect(function() close.TextColor3 = Theme.c.TextDim end)
    close.Activated:Connect(function() win:Close() end)
    local search = New("TextButton", { Name = "Search", Size = UDim2.fromOffset(112, 30), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -50, 0.5, 0), Parent = head })
    Corner(search, R.sm)
    bindT(Chrome, search, "BackgroundColor3", "Surface")
    bindT(Chrome, Stroke(search, Theme.c.Stroke), "Color", "Stroke")
    local sLbl = Label(search, Chrome, "", TS.body - 1, FONT.reg, "TextDim", { Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -52, 1, 0), AutomaticSize = Enum.AutomaticSize.None })
    loc(Chrome, sLbl, "Search")
    local sKey = Label(search, Chrome, "Ctrl K", 11, FONT.semi, "TextMuted", { Position = UDim2.new(1, -44, 0, 0), Size = UDim2.new(0, 36, 1, 0), AutomaticSize = Enum.AutomaticSize.None, TextXAlignment = Enum.TextXAlignment.Right })
    win.SearchBtn, win.SearchKey = search, sKey
    search.Activated:Connect(function() win:OpenPalette() end)

    -- ---- noi dung + overlay ----
    local pages = New("Frame", { Name = "Pages", BackgroundTransparency = 1, ClipsDescendants = true, Position = UDim2.new(0, 176, 0, 54), Size = UDim2.new(1, -176, 1, -54), Parent = root })
    -- hieu ung: mo mau accent duoi header (tinh, khong ton chi phi) + mep mo dan o tren/duoi trang
    local glow = New("Frame", { Name = "Glow", Size = UDim2.new(1, 0, 0, 170), ZIndex = 0, Visible = not self.PerfMode, Parent = root })
    bindA(Chrome, glow, "BackgroundColor3")
    New("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(1, 1) }), Parent = glow })
    win.Glow = glow
    local sweep = New("Frame", { Name = "Sweep", Size = UDim2.new(0.5, 0, 0, 2), Position = UDim2.new(-0.5, 0, 0, 0), ZIndex = 16, Visible = false, Parent = root })
    bindA(Chrome, sweep, "BackgroundColor3")
    New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1) }), Parent = sweep })
    win.Sweep = sweep
    for i = 1, 2 do
        local top = i == 1
        local fade = New("Frame", { Name = top and "FadeTop" or "FadeBottom", AnchorPoint = Vector2.new(0, top and 0 or 1), Position = UDim2.new(0, 0, top and 0 or 1, 0), Size = UDim2.new(1, 0, 0, 12), ZIndex = 5, Parent = pages })
        bindT(Chrome, fade, "BackgroundColor3", "Window")
        local seq = top and NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }) or NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) })
        New("UIGradient", { Rotation = 90, Transparency = seq, Parent = fade })
    end
    local overlay = New("Frame", { Name = "Overlay", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 20, Parent = root })
    local blocker = New("TextButton", { Name = "Blocker", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Visible = false, ZIndex = 21, Parent = overlay })
    blocker.Activated:Connect(function() win:ClosePopup() end)
    win.Header, win.Pages, win.Overlay, win.Blocker = head, pages, overlay, blocker

    -- ---- keo tha, doi kich thuoc ----
    local function grabDrag(input)
        if not isPress(input) then return end
        local start = spos(input)
        local p0 = win.Pos
        Pointer.begin(function(p) win.Pos = p0 + (p - start); win:_Move() end)
    end
    head.InputBegan:Connect(grabDrag)
    local grip = New("TextButton", { Name = "Grip", BackgroundTransparency = 1, Size = UDim2.fromOffset(22, 22), AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 0, 1, 0), ZIndex = 15, Parent = root })
    for i = 1, 2 do
        bindT(Chrome, New("Frame", { Size = UDim2.fromOffset(i * 5, 1), AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -5, 1, -5 - (i - 1) * 4), Rotation = 0, ZIndex = 15, Parent = grip }), "BackgroundColor3", "StrokeHover")
    end
    grip.InputBegan:Connect(function(input)
        if not isPress(input) then return end
        local start = spos(input)
        local s0, p0, sc = win.Size, win.Pos, win._fitScale
        Pointer.begin(function(p)
            local d = (p - start) / sc
            local ns = Vector2.new(clamp(s0.X + d.X, 460, 980), clamp(s0.Y + d.Y, 320, 700))
            win.Size = ns
            win.Pos = p0 + (ns - s0) * sc / 2
            root.Size = UDim2.fromOffset(ns.X, ns.Y)
            win:_Fit()
        end)
    end)
    local cam = workspace.CurrentCamera
    if cam then win._conns[#win._conns + 1] = cam:GetPropertyChangedSignal("ViewportSize"):Connect(function() win:_Fit() end) end
    brand.Activated:Connect(function() win._railForced = not win.Rail; win:_Fit() end)

    win._hub = Hub.add(function(i, gp)
        if gp or win.ToggleKey == Enum.KeyCode.Unknown then return false end
        if i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode == win.ToggleKey then win:Toggle(); return true end
        return false
    end)
    win:_Fit()
    for _, f in ipairs({ "Palette", "Float", "Watermark", "HUD", "Settings" }) do
        if Features[f] then safe(Features[f], win) end
    end
    if cfg.AutoOpen ~= false then task.defer(function() if self.Window == win then win:Open() end end) end
    return win
end

function WindowMT:_Move()
    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
    self.Pos = Vector2.new(clamp(self.Pos.X, 40, vp.X - 40), clamp(self.Pos.Y, 40, vp.Y - 40))
    self.Root.Position = UDim2.fromOffset(self.Pos.X, self.Pos.Y)
end
function WindowMT:_Fit()
    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
    local fit = math.min((vp.X - 20) / self.Size.X, (vp.Y - 20) / self.Size.Y)
    self._fitScale = clamp(math.min(self.Library.UIScale, fit), 0.5, 1.3)
    if self.IsOpen then self.Scale.Scale = self._fitScale end
    local rail = self._railForced
    if rail == nil then rail = vp.X < 700 end
    if rail ~= self.Rail then self.Rail = rail; self:_Layout(true) end
    self:_Move()
end
function WindowMT:_Layout(anim)
    local sbw = self.Rail and 60 or 176
    local function go(obj, props)
        if anim then Tween(obj, M.base, props) else for k, v in pairs(props) do obj[k] = v end end
    end
    go(self.Sidebar, { Size = UDim2.new(0, sbw, 1, 0) })
    go(self.Header, { Position = UDim2.new(0, sbw, 0, 0), Size = UDim2.new(1, -sbw, 0, 54) })
    go(self.Pages, { Position = UDim2.new(0, sbw, 0, 54), Size = UDim2.new(1, -sbw, 1, -54) })
    self.BrandText.Visible = not self.Rail
    self.SearchKey.Visible = not self.Rail
    for _, t in ipairs(self.Tabs) do t._layout() end
    for _, gh in ipairs(self.Groups) do gh.label.Visible = not self.Rail; gh.line.Visible = self.Rail end
end
function WindowMT:SetRail(v) self._railForced = v == true; self:_Fit() end

function WindowMT:Open()
    if self.IsOpen then return end
    self.IsOpen = true
    self.Root.Visible = true
    self:_Fit()
    local s = self._fitScale
    self.Scale.Scale = s * 0.94
    Tween(self.Scale, M.pop, { Scale = s })
    local lib = self.Library
    if not lib.PerfMode and self.Sweep then
        local sw = self.Sweep
        sw.Position = UDim2.new(-0.5, 0, 0, 0)
        sw.Visible = true
        Tween(sw, TweenInfo.new(0.7, EZ.Quint, ED.Out), { Position = UDim2.new(1, 0, 0, 0) })
        task.delay(0.75, function() sw.Visible = false end)
    end
    if not lib.UI.hint then
        lib.UI.hint = true
        lib:_SaveUI()
        task.delay(1.4, function()
            lib:Notify({ Title = tr("Tip"), Content = tr(TOUCH and "Hold the floating button to search every feature." or "Press Ctrl+K to search every feature."), Duration = 6 })
        end)
    end
    lib.Unread = 0
    if lib._onUnread then lib._onUnread() end
    lib:_Blur(true)
    lib:_Sync()
    if self.Float then self.Float.sync() end
end
function WindowMT:Close()
    if not self.IsOpen then return end
    self.IsOpen = false
    self:ClosePopup()
    if self.ClosePalette then self:ClosePalette() end
    Pointer.cancel()
    local lib = self.Library
    Tween(self.Scale, M.fast, { Scale = self._fitScale * 0.95 })
    task.delay(lib.PerfMode and 0 or 0.12, function() if not self.IsOpen and self.Root.Parent then self.Root.Visible = false end end)
    lib:_Blur(false)
    lib:_Sync()
    if self.Float then self.Float.sync() end
end
function WindowMT:Toggle() if self.IsOpen then self:Close() else self:Open() end end
function WindowMT:SetTitle(t) self.Title = tostring(t); self.TitleLabel.Text = self.Title end
function WindowMT:SetSubtitle(t) self.Subtitle = tostring(t); self.SubLabel.Text = self.Subtitle end
function WindowMT:Notify(...) return self.Library:Notify(...) end
function WindowMT:_onLang()
    if self.Current then self.TabTitleLabel.Text = tr(self.Current.Name) end
end
function Library:SetUIScale(v)
    self.UIScale = clamp(tonumber(v) or 1, 0.7, 1.3)
    self.UI.scale = self.UIScale
    self:_SaveUI()
    if self.Window then self.Window:_Fit() end
end

-- ---- popup: moi lan chi mo 1 cai, nam trong overlay cua cua so ----
function WindowMT:OpenPopup(anchor, w, h)
    self:ClosePopup()
    local s = self.Scale.Scale
    local ov = self.Overlay
    local ap, asz, op = anchor.AbsolutePosition, anchor.AbsoluteSize, ov.AbsolutePosition
    local W = w or math.min(asz.X / s, 320)
    local ow, oh = ov.AbsoluteSize.X / s, ov.AbsoluteSize.Y / s
    local x = (ap.X - op.X + asz.X) / s - W
    local y = (ap.Y - op.Y + asz.Y) / s + 4
    if y + h > oh - 8 then y = (ap.Y - op.Y) / s - h - 4 end
    x, y = clamp(x, 8, math.max(8, ow - W - 8)), clamp(y, 8, math.max(8, oh - h - 8))
    local c3 = Theme.c
    local pop = New("Frame", { BackgroundColor3 = c3.Surface, Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(W, h), ZIndex = 22, Parent = ov })
    Corner(pop, R.md)
    Stroke(pop, c3.StrokeHover)
    if not self.Library.PerfMode then
        pop.Position = UDim2.fromOffset(x, y - 6)
        Tween(pop, M.base, { Position = UDim2.fromOffset(x, y) })
    end
    self.Blocker.Visible = true
    self.Popup = pop
    return pop
end
function WindowMT:ClosePopup()
    local pop = self.Popup
    if pop then
        self.Popup = nil
        pop:Destroy()
        local f = self.PopupClose
        self.PopupClose = nil
        if f then f() end
    end
    self.Blocker.Visible = false
end

-- ================================ TAB / NHOM TAB ================================
function WindowMT:_NewTab(def)
    local scope = newScope(false)
    local page = New("ScrollingFrame", { Name = "Page", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollingDirection = Enum.ScrollingDirection.Y, ElasticBehavior = Enum.ElasticBehavior.Never, Visible = false, Parent = self.Pages })
    bindT(scope, page, "ScrollBarImageColor3", "StrokeHover")
    Pad(page, 14, 16, 14, 18)
    List(page, 8)
    local tab = setmetatable({ Window = self, Name = def.Name, Scope = scope, Frame = page, Page = page, Items = {}, _order = 0, Build = def.Build }, TabMT)
    tab.Tab = tab

    local btn = New("TextButton", { Name = "TabBtn", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 38), LayoutOrder = def.Order or 0, Parent = def.Pinned and self.Foot or self.TabList })
    Corner(btn, 8)
    local bar = New("Frame", { AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.new(0, 3, 0, 0), Position = UDim2.new(0, 0, 0.5, 0), Parent = btn })
    local barWant = 0
    Corner(bar, 2)
    local ico = New("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(24, 24), Position = UDim2.new(0, 12, 0.5, -12), Parent = btn })
    local img, mono, monoTxt
    if def.Icon and tostring(def.Icon) ~= "" then
        local id = tostring(def.Icon)
        if tonumber(id) then id = "rbxassetid://" .. id end
        img = New("ImageLabel", { BackgroundTransparency = 1, Image = id, Size = UDim2.fromOffset(18, 18), Position = UDim2.new(0.5, -9, 0.5, -9), Parent = ico })
    else
        mono = New("Frame", { Size = UDim2.fromOffset(24, 24), Parent = ico })
        Corner(mono, 7)
        monoTxt = New("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = UpperVN(U.first(def.Name)), Font = FONT.bold, TextSize = 13, Parent = mono })
    end
    local lbl = New("TextLabel", { BackgroundTransparency = 1, Font = FONT.semi, TextSize = TS.body, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Position = UDim2.new(0, 48, 0, 0), Size = UDim2.new(1, -86, 1, 0), Parent = btn })
    loc(Chrome, lbl, def.Name)
    local badge = New("TextLabel", { Visible = false, Font = FONT.bold, TextSize = 11, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(20, 18), Parent = btn })
    Corner(badge, 9)
    local hover = false
    local function paint()
        local c3 = Theme.c
        local on = self.Current == tab
        btn.BackgroundColor3 = c3.Surface
        btn.BackgroundTransparency = on and 0 or (hover and 0.5 or 1)
        lbl.TextColor3 = (on or hover) and c3.Text or c3.TextDim
        bar.BackgroundColor3 = Accent
        local want = on and 16 or 0
        if want ~= barWant then
            barWant = want
            Tween(bar, M.base, { Size = UDim2.new(0, 3, 0, want) })
        end
        if img then img.ImageColor3 = on and Accent or c3.TextDim end
        if mono then
            mono.BackgroundColor3 = on and Accent or c3.Track
            monoTxt.TextColor3 = on and OnAccent or c3.TextDim
        end
        badge.BackgroundColor3 = Accent
        badge.TextColor3 = OnAccent
    end
    bindF(Chrome, paint)
    tab._paint = paint
    tab._layout = function()
        local rail = self.Rail
        lbl.Visible = not rail
        ico.Position = rail and UDim2.new(0.5, -12, 0.5, -12) or UDim2.new(0, 12, 0.5, -12)
        badge.Position = rail and UDim2.new(1, -2, 0, 8) or UDim2.new(1, -10, 0.5, 0)
    end
    tab._layout()
    btn.MouseEnter:Connect(function() hover = true; paint() end)
    btn.MouseLeave:Connect(function() hover = false; paint() end)
    btn.Activated:Connect(function() self:SelectTab(tab) end)
    tab.Button = btn
    function tab:SetBadge(v)
        if v == nil or v == false or v == "" or v == 0 then badge.Visible = false; return end
        local t = tostring(v)
        badge.Text = t
        badge.Size = UDim2.fromOffset(math.max(20, #t * 8 + 10), 18)
        badge.Visible = true
    end
    self.Tabs[#self.Tabs + 1] = tab
    return tab
end

function WindowMT:CreateTab(a, b, group)
    local def
    if type(a) == "table" then def = { Name = tostring(a.Name or a.Title or "Tab"), Icon = a.Icon }
    else def = { Name = tostring(a or "Tab"), Icon = b } end
    self._tabOrder = self._tabOrder + 1
    if group then group.n = group.n + 1; def.Order = group.base + group.n else def.Order = self._tabOrder end
    local tab = self:_NewTab(def)
    if not self.Current then self:SelectTab(tab) end
    return tab
end
function WindowMT:CreateTabGroup(name)
    self._groupCount = self._groupCount + 1
    local base = self._groupCount * 1000
    local holder = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 28), LayoutOrder = base, Parent = self.TabList })
    local lbl = Label(holder, Chrome, "", 11, FONT.bold, "TextMuted", { Position = UDim2.new(0, 12, 0, 8), Size = UDim2.new(1, -12, 0, 16), AutomaticSize = Enum.AutomaticSize.None })
    loc(Chrome, lbl, tostring(name), true)
    local line = U.hairline(holder, Chrome, UDim2.new(1, -24, 0, 1), UDim2.new(0, 12, 0.5, 0))
    line.Visible = self.Rail
    lbl.Visible = not self.Rail
    local group = { base = base, n = 0, label = lbl, line = line }
    group.CreateTab = function(grp, a, b) return self:CreateTab(a, b, grp) end
    self.Groups[#self.Groups + 1] = group
    return group
end
function WindowMT:SelectTab(t)
    if type(t) == "string" then
        for _, x in ipairs(self.Tabs) do
            if x.Name == t then t = x; break end
        end
    end
    if type(t) ~= "table" or t == self.Current then return end
    self:ClosePopup()
    local prev = self.Current
    if prev then prev.Page.Visible = false; prev.Scope.active = false end
    self.Current = t
    if t.Build then
        local b = t.Build
        t.Build = nil
        safe(b, t)
    end
    t.Page.Visible = true
    if prev and not self.Library.PerfMode then
        t.Page.Position = UDim2.new(0, 0, 0, 10)
        Tween(t.Page, M.base, { Position = UDim2.new(0, 0, 0, 0) })
    end
    activate(t.Scope)
    self.TabTitleLabel.Text = tr(t.Name)
    if prev then prev._paint() end
    t._paint()
    if t.OnShow then safe(t.OnShow, t) end
end
function TabMT:Select() self.Window:SelectTab(self) end
function TabMT:SetVisible(v) self.Button.Visible = v ~= false end

function WindowMT:Destroy()
    local lib = self.Library
    if self._dead then return end
    self._dead = true
    for _, c in ipairs(self._conns) do c:Disconnect() end
    for _, f in ipairs(self._destroyers) do pcall(f) end
    if self._hub then Hub.remove(self._hub) end
    Pointer.cancel()
    for _, t in ipairs(self.Tabs) do removeScope(t.Scope) end
    if self.Root then self.Root:Destroy() end
    if lib.Window == self then lib.Window = nil end
    lib:_Blur(false)
    lib:_Sync()
end
function Library:Destroy()
    if self.Window then self.Window:Destroy() end
    for _, c in ipairs(self._conns) do c:Disconnect() end
    self._conns = {}
    for i = #Pulse.list, 1, -1 do Pulse.remove(Pulse.list[i].name) end
    if Gui then Gui:Destroy(); Gui = nil end
    if BlurFx then BlurFx:Destroy(); BlurFx = nil end
    if genv.MeizuLibrary == self then genv.MeizuLibrary = nil end
end

-- ================================ PHAN TU: nen the dung chung ================================
-- the 1 dong cao 44; co mo ta thi tu gian; "stack" = control nam duoi tieu de.
function U.card(ct, cfg, o)
    o = o or {}
    local scope = ct.Scope
    local title = tostring(cfg.Title or cfg.Name or cfg.Text or "")
    local desc = cfg.Description or cfg.Desc or cfg.Content
    desc = (desc ~= nil and tostring(desc) ~= "") and tostring(desc) or nil
    local card = New(o.click and "TextButton" or "Frame", { Name = "Card", LayoutOrder = ct:_Next(), Size = UDim2.new(1, 0, 0, o.h or CARDH), Parent = ct.Frame })
    Corner(card, R.md)
    local st = Stroke(card, Theme.c.Stroke)
    bindT(scope, card, "BackgroundColor3", "Surface")
    bindT(scope, st, "Color", "Stroke")
    local col = New("Frame", { Name = "Text", BackgroundTransparency = 1, Size = UDim2.new(1, -(o.ctrlW or 0) - 28, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = card })
    List(col, 2)
    if desc or o.stack then
        col.Position = UDim2.new(0, 14, 0, 0)
        Pad(col, 0, 11, 0, 11 + (desc and (o.below or 0) or 0))
        if desc then card.AutomaticSize = Enum.AutomaticSize.Y end
    else
        col.AnchorPoint = Vector2.new(0, 0.5)
        col.Position = UDim2.new(0, 14, 0.5, 0)
    end
    local c = { card = card, stroke = st, col = col, scope = scope, title = title, desc = desc }
    if title ~= "" then
        c.tl = Label(col, scope, "", TS.title, FONT.semi, "Text", { Size = UDim2.new(1, 0, 0, 18), AutomaticSize = Enum.AutomaticSize.None, TextTruncate = Enum.TextTruncate.AtEnd, LayoutOrder = 1 })
        loc(scope, c.tl, title)
    end
    if desc then
        c.dl = Label(col, scope, "", TS.body - 1, FONT.reg, "TextDim", { TextWrapped = true, LayoutOrder = 2 })
        loc(scope, c.dl, desc)
    end
    if o.click then
        card.MouseEnter:Connect(function()
            Tween(card, M.fast, { BackgroundColor3 = Theme.c.SurfaceHover })
            Tween(st, M.fast, { Color = Theme.c.StrokeHover })
        end)
        card.MouseLeave:Connect(function()
            Tween(card, M.fast, { BackgroundColor3 = Theme.c.Surface })
            Tween(st, M.fast, { Color = Theme.c.Stroke })
        end)
        card.MouseButton1Down:Connect(function() Tween(st, M.fast, { Color = Accent }) end)
        card.MouseButton1Up:Connect(function() Tween(st, M.fast, { Color = Theme.c.StrokeHover }) end)
    end
    return c
end

local function relabel(scope, label, text)
    for _, b in ipairs(scope.l) do
        if b[1] == label then
            b[2] = text
            label.Text = b[3] and UpperVN(tr(text)) or tr(text)
            return
        end
    end
    loc(scope, label, text)
end

function U.finish(ct, kind, cfg, c, el)
    el.Frame, el.Kind, el.Title = c.card, kind, c.title
    el.SetVisible = method(el, function(v) c.card.Visible = v ~= false end)
    el.SetTitle = method(el, function(t) el.Title = tostring(t); if c.tl then relabel(c.scope, c.tl, tostring(t)) end end)
    el.SetDesc = method(el, function(t) if c.dl then relabel(c.scope, c.dl, tostring(t)) end end)
    local item = { title = c.title, desc = c.desc, kind = kind, el = el, card = c.card, section = ct.Title, tab = ct.Tab, ct = ct }
    el.Destroy = method(el, function() item.dead = true; c.card:Destroy(); if el._onDestroy then el._onDestroy() end end)
    el.SetEnabled = method(el, function(on)
        on = on ~= false
        el.Enabled = on
        c.card.Interactable = on
        local tt = on and 0 or 0.55
        if c.tl then c.tl.TextTransparency = tt end
        if c.dl then c.dl.TextTransparency = tt end
    end)
    if cfg.Disabled then el.SetEnabled(false) end
    if cfg.Tooltip then Library._Tip(c.card, cfg.Tooltip) end
    if cfg.Flag and cfg.Flag ~= "" then Library:_RegFlag(cfg.Flag, el, cfg.Internal) end
    if not cfg.NoIndex then ct:_Index(item) end
    return el
end

function U.commit(el, cfg, v, fire)
    el.Value = v
    if el.Flag then
        Library.Flags[el.Flag] = v
        Library:_Dirty(el.Internal)
    end
    if fire ~= false then safe(cfg.Callback, v) end
end

-- bong gia tri noi tren nut keo cua Slider (dung chung 1 cai / cua so), de nhin thay so khi ngon tay che mat
function U.bubbleAt(win, track, a, text)
    if not win or Library.PerfMode then return end
    local b = win._bubble
    if not b then
        local f = New("Frame", { Name = "Bubble", Size = UDim2.fromOffset(60, 26), ZIndex = 25, Visible = false, Parent = win.Overlay })
        Corner(f, R.sm)
        bindA(Chrome, f, "BackgroundColor3")
        local l = New("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = FONT.semi, TextSize = 14, ZIndex = 26, Parent = f })
        bindA(Chrome, l, "TextColor3", true)
        b = { f = f, l = l }
        win._bubble = b
    end
    local s = win.Scale.Scale
    local ov = win.Overlay.AbsolutePosition
    local w = math.max(44, Measure(text, 14, FONT.semi, 400).X + 20)
    b.l.Text = text
    b.f.Size = UDim2.fromOffset(w, 26)
    b.f.Position = UDim2.fromOffset((track.AbsolutePosition.X + track.AbsoluteSize.X * a - ov.X) / s - w / 2, (track.AbsolutePosition.Y - ov.Y) / s - 38)
    b.f.Visible = true
end
function U.bubbleHide(win)
    if win and win._bubble then win._bubble.f.Visible = false end
end

do
    local makeCard, finish, commit = U.card, U.finish, U.commit

    -- ---------------------------------- Button ----------------------------------
    function Container:CreateButton(cfg)
        if type(cfg) == "string" then cfg = { Title = cfg } end
        cfg = cfg or {}
        local label = tostring(cfg.ButtonText or cfg.Label or "Run")
        local w = Measure(tr(label), 14, FONT.semi, 400).X + 28
        local c = makeCard(self, cfg, { click = true, ctrlW = w })
        local pill = New("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(w, 26), Parent = c.card })
        Corner(pill, R.sm)
        local danger = cfg.Style == "Danger"
        if danger then bindT(c.scope, pill, "BackgroundColor3", "Danger") else bindA(c.scope, pill, "BackgroundColor3") end
        local txt = New("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = FONT.semi, TextSize = 14, Parent = pill })
        loc(c.scope, txt, label)
        if danger then txt.TextColor3 = WHITE else bindA(c.scope, txt, "TextColor3", true) end
        local el = {}
        local function fire()
            if el.Locked then return end
            pill.BackgroundTransparency = 0.45
            Tween(pill, M.base, { BackgroundTransparency = 0 })
            safe(cfg.Callback)
        end
        c.card.ClipsDescendants = true
        c.card.Activated:Connect(function(i)
            if i and i.Position then
                local p = spos(i)
                Ripple(c.card, p.X, p.Y)
            end
            fire()
        end)
        el.Fire = method(el, fire)
        el.Click = el.Fire
        el.SetText = method(el, function(t) relabel(c.scope, txt, tostring(t)) end)
        return finish(self, "Button", cfg, c, el)
    end

    -- ---------------------------------- Toggle ----------------------------------
    function Container:CreateToggle(cfg)
        cfg = cfg or {}
        local c = makeCard(self, cfg, { click = true, ctrlW = 54 })
        local track = New("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(40, 22), Parent = c.card })
        Corner(track, 11)
        local knob = New("Frame", { AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.fromOffset(16, 16), Position = UDim2.new(0, 3, 0.5, 0), Parent = track })
        Corner(knob, 8)
        local state = (cfg.Default == true) or (cfg.Value == true)
        local el = {}
        local function paint(anim)
            local pos = UDim2.new(0, state and 21 or 3, 0.5, 0)
            local col = state and Accent or Theme.c.Track
            if anim then
                Tween(track, M.base, { BackgroundColor3 = col })
                Tween(knob, M.base, { Position = pos })
                knob.Size = UDim2.fromOffset(19, 16)
                Tween(knob, M.pop, { Size = UDim2.fromOffset(16, 16) })
            else
                track.BackgroundColor3 = col
                knob.Position = pos
            end
            knob.BackgroundColor3 = Theme.c.Knob
        end
        bindF(c.scope, function() paint(false) end)
        local function set(v, fire)
            v = v and true or false
            if v == state and fire ~= "force" then return end
            state = v
            paint(true)
            commit(el, cfg, v, fire)
        end
        c.card.Activated:Connect(function() set(not state) end)
        el.Set = method(el, set)
        el.Get = method(el, function() return state end)
        el.Toggle = method(el, function() set(not state) end)
        finish(self, "Toggle", cfg, c, el)
        commit(el, cfg, state, false)
        if state then task.defer(function() safe(cfg.Callback, true) end) end
        return el
    end

    -- ---------------------------------- Slider ----------------------------------
    function Container:CreateSlider(cfg)
        cfg = cfg or {}
        local mn, mx = tonumber(cfg.Min) or 0, tonumber(cfg.Max) or 100
        if mx <= mn then mx = mn + 1 end
        local step = tonumber(cfg.Increment or cfg.Step) or (cfg.Rounding and 10 ^ -cfg.Rounding) or 1
        local dec = tonumber(cfg.Rounding) or #(tostring(step):match("%.(%d+)") or "")
        local suffix = tostring(cfg.Suffix or "")
        local c = makeCard(self, cfg, { stack = true, h = H(60), ctrlW = 90, below = 24 })
        local scope = c.scope
        local val = New("TextBox", { BackgroundTransparency = 1, ClearTextOnFocus = true, Font = FONT.semi, TextSize = TS.body, TextXAlignment = Enum.TextXAlignment.Right, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 9), Size = UDim2.fromOffset(86, 22), Parent = c.card })
        bindA(scope, val, "TextColor3")
        local track = New("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 14, 1, -17), Size = UDim2.new(1, -28, 0, 6), Parent = c.card })
        Corner(track, 3)
        bindT(scope, track, "BackgroundColor3", "Track")
        local fill = New("Frame", { Size = UDim2.new(0, 0, 1, 0), Parent = track })
        Corner(fill, 3)
        bindA(scope, fill, "BackgroundColor3")
        local knob = New("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(14, 14), Position = UDim2.new(0, 0, 0.5, 0), ZIndex = 2, Parent = track })
        Corner(knob, 7)
        bindT(scope, knob, "BackgroundColor3", "Knob")
        local hit = New("TextButton", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 6, 1, -6), Size = UDim2.new(1, -12, 0, 24), ZIndex = 3, Parent = c.card })
        local el = {}
        local function clean(v) return tonumber(string.format("%." .. dec .. "f", v)) or v end
        local value = clean(clamp(roundTo((tonumber(cfg.Default) or mn) - mn, step) + mn, mn, mx))
        local function fmt(v) return string.format("%." .. dec .. "f", v) .. suffix end
        local dragging = false
        local function render(v, anim)
            local a = (v - mn) / (mx - mn)
            local sz, pos = UDim2.new(a, 0, 1, 0), UDim2.new(a, 0, 0.5, 0)
            if anim then Tween(fill, M.base, { Size = sz }); Tween(knob, M.base, { Position = pos })
            else fill.Size = sz; knob.Position = pos end
            val.Text = fmt(v)
            if dragging then U.bubbleAt(self.Window, track, a, val.Text) end
        end
        local function set(v, fire, anim)
            v = clean(clamp(roundTo((tonumber(v) or value) - mn, step) + mn, mn, mx))
            render(v, anim ~= false)
            if v ~= value or fire == "force" then
                value = v
                commit(el, cfg, v, fire)
            end
        end
        local function fromX(x)
            local a = clamp((x - track.AbsolutePosition.X) / math.max(1, track.AbsoluteSize.X), 0, 1)
            set(mn + a * (mx - mn), true, false)
        end
        hit.InputBegan:Connect(function(i)
            if not isPress(i) then return end
            local page = self.Tab and self.Tab.Page
            if page then page.ScrollingEnabled = false end
            dragging = true
            Tween(knob, M.fast, { Size = UDim2.fromOffset(18, 18) })
            fromX(i.Position.X)
            Pointer.begin(function(p) fromX(p.X) end, function()
                dragging = false
                if page then page.ScrollingEnabled = true end
                Tween(knob, M.base, { Size = UDim2.fromOffset(14, 14) })
                U.bubbleHide(self.Window)
            end)
        end)
        val.FocusLost:Connect(function()
            local n = tonumber((val.Text:gsub("[^%d%.%-]", "")))
            if n then set(n, true) else render(value, false) end
            val.Text = fmt(value)
        end)
        render(value, false)
        el.Set = method(el, set)
        el.Get = method(el, function() return value end)
        finish(self, "Slider", cfg, c, el)
        commit(el, cfg, value, false)
        return el
    end

    -- ---------------------------------- Stepper ----------------------------------
    function Container:CreateStepper(cfg)
        cfg = cfg or {}
        local mn, mx = tonumber(cfg.Min) or 0, tonumber(cfg.Max) or 100
        local step = tonumber(cfg.Step or cfg.Increment) or 1
        local suffix = tostring(cfg.Suffix or "")
        local c = makeCard(self, cfg, { ctrlW = 130 })
        local scope = c.scope
        local box = New("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(124, 28), Parent = c.card })
        local function mini(txt, x)
            local b = New("TextButton", { Text = txt, Font = FONT.bold, TextSize = 18, Size = UDim2.fromOffset(28, 28), Position = UDim2.new(0, x, 0, 0), Parent = box })
            Corner(b, R.sm)
            bindT(scope, b, "BackgroundColor3", "SurfaceHover")
            bindT(scope, b, "TextColor3", "Text")
            return b
        end
        local minus, plus = mini("-", 0), mini("+", 96)
        local val = New("TextLabel", { BackgroundTransparency = 1, Font = FONT.semi, TextSize = TS.body, Position = UDim2.new(0, 28, 0, 0), Size = UDim2.new(1, -56, 1, 0), Parent = box })
        bindT(scope, val, "TextColor3", "Text")
        local el = {}
        local value = clamp(tonumber(cfg.Default) or mn, mn, mx)
        local function show() val.Text = tostring(value) .. suffix end
        local function set(v, fire)
            v = clamp(tonumber(v) or value, mn, mx)
            if v == value and fire ~= "force" then return end
            value = v
            show()
            commit(el, cfg, v, fire)
        end
        local holding
        local function bump(dir) set(value + dir * step, true) end
        local function hold(btn, dir)
            btn.InputBegan:Connect(function(i)
                if not isPress(i) then return end
                local my = {}
                holding = my
                bump(dir)
                task.delay(0.4, function()
                    while holding == my do
                        bump(dir)
                        task.wait(0.06)
                    end
                end)
            end)
            btn.InputEnded:Connect(function(i) if isPress(i) then holding = nil end end)
            btn.MouseLeave:Connect(function() holding = nil end)
        end
        hold(minus, -1)
        hold(plus, 1)
        show()
        el.Set = method(el, set)
        el.Get = method(el, function() return value end)
        finish(self, "Stepper", cfg, c, el)
        commit(el, cfg, value, false)
        return el
    end

    -- ---------------------------------- Segmented ----------------------------------
    function Container:CreateSegmented(cfg)
        cfg = cfg or {}
        local opts = {}
        for _, o in ipairs(cfg.Options or cfg.Values or cfg.Items or {}) do opts[#opts + 1] = tostring(o) end
        local n = math.max(1, #opts)
        local hasTitle = tostring(cfg.Title or cfg.Name or "") ~= ""
        local c = makeCard(self, cfg, { stack = true, h = H(hasTitle and 78 or 54), below = 42 })
        local scope = c.scope
        local seg = New("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 14, 1, hasTitle and -12 or -11), Size = UDim2.new(1, -28, 0, 32), Parent = c.card })
        if not hasTitle and not c.desc then seg.AnchorPoint = Vector2.new(0, 0.5); seg.Position = UDim2.new(0, 14, 0.5, 0) end
        Corner(seg, R.sm)
        bindT(scope, seg, "BackgroundColor3", "SurfaceHover")
        local hl = New("Frame", { Size = UDim2.new(1 / n, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2), Parent = seg })
        Corner(hl, R.sm - 1)
        local btns = {}
        local sel = 1
        local el = {}
        local function paint()
            hl.BackgroundColor3 = Accent
            for i, b in ipairs(btns) do b.TextColor3 = (i == sel) and OnAccent or Theme.c.TextDim end
        end
        local function set(v, fire)
            local idx = tonumber(v)
            if not idx or not opts[idx] then
                idx = nil
                for i, o in ipairs(opts) do if o == tostring(v) then idx = i; break end end
            end
            if not idx then return end
            if idx == sel and fire ~= "force" then return end
            sel = idx
            Tween(hl, M.base, { Position = UDim2.new((idx - 1) / n, 2, 0, 2) })
            paint()
            commit(el, cfg, opts[idx], fire)
        end
        for i, o in ipairs(opts) do
            local b = New("TextButton", { BackgroundTransparency = 1, Font = FONT.semi, TextSize = TS.body - 1, Position = UDim2.new((i - 1) / n, 0, 0, 0), Size = UDim2.new(1 / n, 0, 1, 0), ZIndex = 2, Parent = seg })
            loc(scope, b, o)
            btns[i] = b
            b.Activated:Connect(function() set(i, true) end)
        end
        local d = cfg.Default
        sel = 1
        if d ~= nil then
            local idx = tonumber(d)
            if not (idx and opts[idx]) then
                idx = 1
                for i, o in ipairs(opts) do if o == tostring(d) then idx = i; break end end
            end
            sel = idx
        end
        hl.Position = UDim2.new((sel - 1) / n, 2, 0, 2)
        bindF(scope, paint)
        el.Set = method(el, set)
        el.Get = method(el, function() return opts[sel] end)
        finish(self, "Segmented", cfg, c, el)
        commit(el, cfg, opts[sel], false)
        return el
    end
end

do
    local makeCard, finish, commit = U.card, U.finish, U.commit

    -- ---------------------------------- Dropdown / MultiDropdown ----------------------------------
    -- Danh sach chi tao toi da 80 hang va TAI SU DUNG hang khi loc -> list 1000 muc van nhe.
    local function buildDropdown(ct, cfg, multi)
        cfg = cfg or {}
        local options = {}
        local function setOptions(list)
            options = {}
            for _, o in ipairs(list or {}) do options[#options + 1] = tostring(o) end
        end
        setOptions(cfg.Options or cfg.Values or cfg.List or cfg.Items)
        local c = makeCard(ct, cfg, { click = true, ctrlW = 168 })
        local scope = c.scope
        local pill = New("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(160, 28), Parent = c.card })
        Corner(pill, R.sm)
        bindT(scope, pill, "BackgroundColor3", "SurfaceHover")
        local txt = Label(pill, scope, "", TS.body - 1, FONT.reg, "TextDim", { Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -34, 1, 0), AutomaticSize = Enum.AutomaticSize.None, TextTruncate = Enum.TextTruncate.AtEnd })
        local chev = U.chevron(pill, scope, UDim2.new(1, -9, 0.5, 0))
        local sel, single = {}, nil
        local el = {}
        local function value()
            if not multi then return single end
            local out = {}
            for _, o in ipairs(options) do if sel[o] then out[#out + 1] = o end end
            return out
        end
        local function refresh()
            if not multi then txt.Text = single or tr("Select"); return end
            local v = value()
            if #v == 0 then txt.Text = tr("None")
            elseif #v <= 2 then txt.Text = table.concat(v, ", ")
            else txt.Text = v[1] .. ", " .. v[2] .. " +" .. (#v - 2) end
        end
        local function apply(v, fire)
            if multi then
                sel = {}
                for _, o in ipairs(type(v) == "table" and v or {}) do sel[tostring(o)] = true end
            else
                if type(v) == "number" and options[v] then v = options[v] end
                single = v ~= nil and tostring(v) or nil
            end
            refresh()
            commit(el, cfg, value(), fire)
        end
        local d = cfg.Default
        if multi then
            for _, o in ipairs(type(d) == "table" and d or {}) do sel[tostring(o)] = true end
        elseif d ~= nil then
            single = (type(d) == "number" and options[d]) or tostring(d)
        end
        refresh()

        local function open()
            local win = ct.Window
            local n = #options
            if n == 0 then return end
            local withSearch = n > 7
            local pop = win:OpenPopup(c.card, nil, math.min(n, 6) * 32 + 8 + (withSearch and 42 or 0))
            local c3 = Theme.c
            Tween(chev, M.fast, { Rotation = 180 })
            win.PopupClose = function() Tween(chev, M.fast, { Rotation = 0 }) end
            local top, filter = 0, ""
            local fill
            if withSearch then
                top = 42
                local box = New("TextBox", { BackgroundColor3 = c3.SurfaceHover, PlaceholderText = tr("Search") .. "...", PlaceholderColor3 = c3.TextMuted, Text = "", TextColor3 = c3.Text, ClearTextOnFocus = false, Font = FONT.reg, TextSize = TS.body - 1, TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.new(0, 6, 0, 6), Size = UDim2.new(1, -12, 0, 30), Parent = pop })
                Corner(box, R.sm)
                Pad(box, 10, 0, 10, 0)
                box:GetPropertyChangedSignal("Text"):Connect(function() filter = Norm(box.Text); fill() end)
            end
            local scroll = New("ScrollingFrame", { BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, top), Size = UDim2.new(1, 0, 1, -top), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollBarImageColor3 = c3.StrokeHover, ScrollingDirection = Enum.ScrollingDirection.Y, Parent = pop })
            Pad(scroll, 4, 4, 4, 4)
            List(scroll, 2)
            local rows, MAXR = {}, 80
            local more = New("TextLabel", { BackgroundTransparency = 1, Font = FONT.reg, TextSize = 13, TextColor3 = c3.TextMuted, Size = UDim2.new(1, 0, 0, 24), LayoutOrder = MAXR + 1, Visible = false, Parent = scroll })
            local function pick(o)
                if multi then
                    local list, found = value(), false
                    for i, x in ipairs(list) do
                        if x == o then table.remove(list, i); found = true; break end
                    end
                    if not found then list[#list + 1] = o end
                    apply(list, true)
                    fill()
                else
                    apply(o, true)
                    win:ClosePopup()
                end
            end
            local function makeRow(i)
                local btn = New("TextButton", { BackgroundColor3 = c3.SurfaceHover, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), LayoutOrder = i, Parent = scroll })
                Corner(btn, R.sm)
                local lb = New("TextLabel", { BackgroundTransparency = 1, Font = FONT.reg, TextSize = TS.body, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -30, 1, 0), Parent = btn })
                local dot = New("Frame", { BackgroundColor3 = Accent, Size = UDim2.fromOffset(6, 6), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Parent = btn })
                Corner(dot, 3)
                local row = { btn = btn }
                btn.MouseEnter:Connect(function() btn.BackgroundTransparency = 0 end)
                btn.MouseLeave:Connect(function() btn.BackgroundTransparency = 1 end)
                btn.Activated:Connect(function() pick(row.opt) end)
                function row.set(o)
                    row.opt = o
                    lb.Text = o
                    btn.Visible = true
                    local on = (multi and sel[o]) or (not multi and single == o)
                    lb.TextColor3 = on and Accent or c3.Text
                    dot.Visible = on == true
                end
                return row
            end
            fill = function()
                local total = 0
                for _, o in ipairs(options) do
                    if filter == "" or Norm(o):find(filter, 1, true) then
                        total = total + 1
                        if total <= MAXR then
                            local row = rows[total]
                            if not row then row = makeRow(total); rows[total] = row end
                            row.set(o)
                        end
                    end
                end
                for i = total + 1, #rows do rows[i].btn.Visible = false end
                more.Visible = total > MAXR
                if total > MAXR then more.Text = (total - MAXR) .. " " .. tr("more, keep typing") end
            end
            fill()
        end
        c.card.Activated:Connect(function()
            if ct.Window.Popup then ct.Window:ClosePopup() else open() end
        end)
        el.Set = method(el, apply)
        el.Get = method(el, value)
        el.SetOptions = method(el, function(list, keep)
            setOptions(list)
            if not keep then single = nil; sel = {} end
            refresh()
        end)
        el.Refresh = el.SetOptions
        finish(ct, multi and "MultiDropdown" or "Dropdown", cfg, c, el)
        commit(el, cfg, value(), false)
        return el
    end
    function Container:CreateDropdown(cfg) return buildDropdown(self, cfg, cfg and cfg.Multi == true) end
    function Container:CreateMultiDropdown(cfg) return buildDropdown(self, cfg, true) end

    -- ---------------------------------- Keybind ----------------------------------
    local SHORT = { LeftControl = "LCtrl", RightControl = "RCtrl", LeftShift = "LShift", RightShift = "RShift", LeftAlt = "LAlt", RightAlt = "RAlt", Return = "Enter", Backspace = "Bksp", MouseButton1 = "Mouse 1", MouseButton2 = "Mouse 2", MouseButton3 = "Mouse 3" }
    local function parseKey(v)
        if typeof(v) == "EnumItem" then
            if v.EnumType == Enum.KeyCode then return "kc", v end
            if v.EnumType == Enum.UserInputType then return "ut", v end
            return nil
        end
        if type(v) == "string" and v ~= "" and v ~= "None" then
            local ok, kc = pcall(function() return Enum.KeyCode[v] end)
            if ok and kc then return "kc", kc end
            local ok2, ut = pcall(function() return Enum.UserInputType[v] end)
            if ok2 and ut then return "ut", ut end
        end
        return nil
    end
    local function hits(b, i)
        if b.kind == "kc" then return i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode == b.key end
        return i.UserInputType == b.key
    end
    local hubReady = false
    local function ensureHub()
        if hubReady then return end
        hubReady = true
        Hub.add(function(i, gp)
            if gp then return false end
            for _, b in ipairs(Library._binds) do
                if b.key and b.on and hits(b, i) then b.press() end
            end
            return false
        end)
        track(UserInputService.InputEnded:Connect(function(i)
            for _, b in ipairs(Library._binds) do
                if b.key and b.mode == "Hold" and b.state and hits(b, i) then b.release() end
            end
        end))
    end
    U.parseKey, U.keyShort = parseKey, SHORT

    function Container:CreateKeybind(cfg)
        cfg = cfg or {}
        ensureHub()
        local c = makeCard(self, cfg, { click = true, ctrlW = 110 })
        local scope = c.scope
        local pill = New("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(96, 26), Parent = c.card })
        Corner(pill, R.sm)
        bindT(scope, pill, "BackgroundColor3", "SurfaceHover")
        local txt = Label(pill, scope, "", TS.body - 1, FONT.semi, "Text", { Size = UDim2.new(1, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.None, TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.AtEnd })
        local b = { mode = cfg.Mode or "Press", state = false, on = true, title = c.title }
        local el = {}
        local ccfg = { Callback = cfg.Changed }
        local function nameOf() return b.key and b.key.Name or "None" end
        local function paint(capturing)
            if capturing then txt.Text = tr("Press a key..."); txt.TextColor3 = Accent
            else txt.Text = SHORT[nameOf()] or nameOf(); txt.TextColor3 = Theme.c.Text end
        end
        local function hud() if Library._hudRefresh then Library._hudRefresh() end end
        local function assign(v, fire)
            b.kind, b.key = parseKey(v)
            paint(false)
            commit(el, ccfg, nameOf(), fire)
            hud()
        end
        b.press = function()
            if b.mode == "Toggle" then b.state = not b.state; safe(cfg.Callback, b.state)
            elseif b.mode == "Hold" then b.state = true; safe(cfg.Callback, true)
            else safe(cfg.Callback) end
            hud()
        end
        b.release = function() b.state = false; safe(cfg.Callback, false); hud() end
        c.card.Activated:Connect(function()
            if Hub.capture then return end
            b.on = false
            paint(true)
            Hub.capture = function(i)
                local ut = i.UserInputType
                if ut == Enum.UserInputType.Keyboard then
                    Hub.capture = nil
                    b.on = true
                    local kc = i.KeyCode
                    if kc == Enum.KeyCode.Escape then paint(false)
                    elseif kc == Enum.KeyCode.Backspace or kc == Enum.KeyCode.Delete then assign(nil, true)
                    else assign(kc, true) end
                    return true
                elseif ut == Enum.UserInputType.MouseButton2 or ut == Enum.UserInputType.MouseButton3 then
                    Hub.capture = nil
                    b.on = true
                    assign(ut, true)
                    return true
                elseif ut == Enum.UserInputType.MouseButton1 or ut == Enum.UserInputType.Touch then
                    Hub.capture = nil
                    b.on = true
                    paint(false)
                end
                return false
            end
        end)
        bindF(scope, function() paint(false) end)
        el.Set = method(el, assign)
        el.Get = method(el, nameOf)
        el.GetKey = method(el, function() return b.key end)
        el.GetState = method(el, function() return b.state end)
        el.SetMode = method(el, function(m) b.mode = m; hud() end)
        el.Fire = method(el, function() b.press() end)
        el._onDestroy = function()
            for i = #Library._binds, 1, -1 do if Library._binds[i] == b then table.remove(Library._binds, i) end end
            hud()
        end
        b.el = el
        Library._binds[#Library._binds + 1] = b
        b.kind, b.key = parseKey(cfg.Default)
        paint(false)
        finish(self, "Keybind", cfg, c, el)
        commit(el, ccfg, nameOf(), false)
        hud()
        return el
    end

    -- ---------------------------------- Input ----------------------------------
    function Container:CreateInput(cfg)
        cfg = cfg or {}
        local c = makeCard(self, cfg, { ctrlW = 182 })
        local scope = c.scope
        local box = New("TextBox", { Text = tostring(cfg.Default or ""), PlaceholderText = tostring(cfg.Placeholder or ""), ClearTextOnFocus = cfg.ClearOnFocus == true, Font = FONT.reg, TextSize = TS.body, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(170, 28), Parent = c.card })
        Corner(box, R.sm)
        Pad(box, 10, 0, 10, 0)
        bindT(scope, box, "BackgroundColor3", "SurfaceHover")
        bindT(scope, box, "TextColor3", "Text")
        bindT(scope, box, "PlaceholderColor3", "TextMuted")
        local st = Stroke(box, Theme.c.SurfaceHover)
        bindT(scope, st, "Color", "SurfaceHover")
        local el = {}
        local numeric = cfg.Numeric == true
        local maxLen = tonumber(cfg.MaxLength)
        box.Focused:Connect(function() st.Color = Accent end)
        box:GetPropertyChangedSignal("Text"):Connect(function()
            local t = box.Text
            if numeric then t = t:gsub("[^%d%.%-]", "") end
            if maxLen and #t > maxLen then t = t:sub(1, maxLen) end
            if t ~= box.Text then box.Text = t; return end
            if cfg.Live then commit(el, cfg, t, true) end
        end)
        box.FocusLost:Connect(function(enter)
            st.Color = Theme.c.SurfaceHover
            if not cfg.Live then
                commit(el, cfg, box.Text, true)
                if enter then safe(cfg.Finished, box.Text) end
            end
        end)
        el.Set = method(el, function(v, fire) box.Text = tostring(v or ""); commit(el, cfg, box.Text, fire) end)
        el.Get = method(el, function() return box.Text end)
        el.Focus = method(el, function() box:CaptureFocus() end)
        finish(self, "Input", cfg, c, el)
        commit(el, cfg, box.Text, false)
        return el
    end

    -- ---------------------------------- ColorPicker ----------------------------------
    local HUES = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(1 / 6, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(2 / 6, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(3 / 6, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(4 / 6, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(5 / 6, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
    })
    local function hexOf(col) return string.format("%02X%02X%02X", math.floor(col.R * 255 + 0.5), math.floor(col.G * 255 + 0.5), math.floor(col.B * 255 + 0.5)) end
    U.hexOf = hexOf

    function Container:CreateColorPicker(cfg)
        cfg = cfg or {}
        local c = makeCard(self, cfg, { click = true, ctrlW = 54 })
        local scope = c.scope
        local sw = New("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(38, 22), Parent = c.card })
        Corner(sw, R.sm)
        bindT(scope, Stroke(sw, Theme.c.StrokeHover), "Color", "StrokeHover")
        local color = typeof(cfg.Default) == "Color3" and cfg.Default or Color3.fromRGB(255, 255, 255)
        local h, s, v = color:ToHSV()
        sw.BackgroundColor3 = color
        local el, ui = {}, nil
        local function push(fire)
            color = Color3.fromHSV(h, s, v)
            sw.BackgroundColor3 = color
            if ui then ui() end
            commit(el, cfg, color, fire)
        end
        local function open()
            local win = self.Window
            local pop = win:OpenPopup(c.card, 224, 198)
            local c3 = Theme.c
            local sv = New("Frame", { Position = UDim2.fromOffset(8, 8), Size = UDim2.fromOffset(208, 120), ClipsDescendants = true, Parent = pop })
            Corner(sv, R.sm)
            local wh = New("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = WHITE, Parent = sv })
            Corner(wh, R.sm)
            New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }), Parent = wh })
            local bk = New("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0, 0, 0), Parent = sv })
            Corner(bk, R.sm)
            New("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }), Parent = bk })
            local cur = New("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(12, 12), BackgroundTransparency = 1, ZIndex = 3, Parent = sv })
            Corner(cur, 6)
            Stroke(cur, WHITE, 2)
            local hue = New("Frame", { Position = UDim2.fromOffset(8, 136), Size = UDim2.fromOffset(208, 14), BackgroundColor3 = WHITE, Parent = pop })
            Corner(hue, 7)
            New("UIGradient", { Color = HUES, Parent = hue })
            local hcur = New("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(6, 20), BackgroundColor3 = WHITE, ZIndex = 3, Parent = hue })
            Corner(hcur, 3)
            Stroke(hcur, Color3.new(0, 0, 0), 1, 0.5)
            local hex = New("TextBox", { BackgroundColor3 = c3.SurfaceHover, TextColor3 = c3.Text, ClearTextOnFocus = false, Font = FONT.semi, TextSize = TS.body - 1, Position = UDim2.fromOffset(8, 160), Size = UDim2.fromOffset(136, 28), Parent = pop })
            Corner(hex, R.sm)
            local prev = New("Frame", { Position = UDim2.fromOffset(152, 160), Size = UDim2.fromOffset(64, 28), Parent = pop })
            Corner(prev, R.sm)
            ui = function()
                sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                cur.Position = UDim2.new(s, 0, 1 - v, 0)
                hcur.Position = UDim2.new(h, 0, 0.5, 0)
                hex.Text = "#" .. hexOf(color)
                prev.BackgroundColor3 = color
            end
            ui()
            win.PopupClose = function() ui = nil end
            local function svFrom(p)
                s = clamp((p.X - sv.AbsolutePosition.X) / math.max(1, sv.AbsoluteSize.X), 0, 1)
                v = 1 - clamp((p.Y - sv.AbsolutePosition.Y) / math.max(1, sv.AbsoluteSize.Y), 0, 1)
                push(true)
            end
            local function hueFrom(p)
                h = clamp((p.X - hue.AbsolutePosition.X) / math.max(1, hue.AbsoluteSize.X), 0, 1)
                push(true)
            end
            sv.InputBegan:Connect(function(i)
                if isPress(i) then svFrom(spos(i)); Pointer.begin(svFrom) end
            end)
            hue.InputBegan:Connect(function(i)
                if isPress(i) then hueFrom(spos(i)); Pointer.begin(hueFrom) end
            end)
            hex.FocusLost:Connect(function()
                local t = (hex.Text:gsub("[^%x]", ""))
                if #t == 6 then
                    h, s, v = Color3.fromRGB(tonumber(t:sub(1, 2), 16), tonumber(t:sub(3, 4), 16), tonumber(t:sub(5, 6), 16)):ToHSV()
                    push(true)
                end
                if ui then ui() end
            end)
        end
        c.card.Activated:Connect(function()
            if self.Window.Popup then self.Window:ClosePopup() else open() end
        end)
        el.Set = method(el, function(col, fire)
            if type(col) == "table" and col.__c then col = Color3.fromRGB(col.__c[1], col.__c[2], col.__c[3]) end
            if typeof(col) ~= "Color3" then return end
            h, s, v = col:ToHSV()
            push(fire)
        end)
        el.Get = method(el, function() return color end)
        finish(self, "ColorPicker", cfg, c, el)
        commit(el, cfg, color, false)
        return el
    end

    -- ---------------------------------- Paragraph / Label / Divider ----------------------------------
    function Container:CreateParagraph(cfg)
        if type(cfg) == "string" then cfg = { Content = cfg } end
        cfg = cfg or {}
        local c = makeCard(self, { Title = cfg.Title or cfg.Name, Description = cfg.Content or cfg.Text or cfg.Description or " ", Tooltip = cfg.Tooltip }, { h = 44 })
        local el = {}
        el.SetContent = method(el, function(t) if c.dl then relabel(c.scope, c.dl, tostring(t)) end end)
        el.Set = el.SetContent
        return finish(self, "Paragraph", cfg, c, el)
    end
    function Container:CreateLabel(a)
        local cfg = type(a) == "table" and a or { Text = a }
        local lbl = Label(self.Frame, self.Scope, "", TS.body - 1, FONT.reg, "TextDim", { TextWrapped = true, LayoutOrder = self:_Next() })
        Pad(lbl, 2, 0, 2, 0)
        loc(self.Scope, lbl, tostring(cfg.Text or cfg.Title or ""))
        local el = { Frame = lbl, Kind = "Label" }
        el.Set = method(el, function(t) relabel(self.Scope, lbl, tostring(t)) end)
        el.SetText = el.Set
        el.SetVisible = method(el, function(b) lbl.Visible = b ~= false end)
        el.Destroy = method(el, function() lbl:Destroy() end)
        return el
    end
    function Container:CreateDivider(a)
        local cfg = type(a) == "table" and a or { Text = a }
        local holder = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 14), LayoutOrder = self:_Next(), Parent = self.Frame })
        U.hairline(holder, self.Scope, UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 0.5, 0))
        local el = { Frame = holder, Kind = "Divider" }
        el.SetVisible = method(el, function(b) holder.Visible = b ~= false end)
        el.Destroy = method(el, function() holder:Destroy() end)
        return el
    end

    -- ---------------------------------- Progress ----------------------------------
    function Container:CreateProgress(cfg)
        cfg = cfg or {}
        local mn, mx = tonumber(cfg.Min) or 0, tonumber(cfg.Max) or 100
        if mx <= mn then mx = mn + 1 end
        local c = makeCard(self, cfg, { stack = true, h = H(54), ctrlW = 70, below = 20 })
        local scope = c.scope
        local fmt = cfg.Format or "%d%%"
        local pct = Label(c.card, scope, "", TS.body, FONT.semi, "TextDim", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 9), Size = UDim2.fromOffset(80, 22), AutomaticSize = Enum.AutomaticSize.None, TextXAlignment = Enum.TextXAlignment.Right })
        local track = New("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 14, 1, -14), Size = UDim2.new(1, -28, 0, 6), Parent = c.card })
        Corner(track, 3)
        bindT(scope, track, "BackgroundColor3", "Track")
        local fill = New("Frame", { Size = UDim2.new(0, 0, 1, 0), Parent = track })
        Corner(fill, 3)
        bindA(scope, fill, "BackgroundColor3")
        local el = {}
        local value = mn
        local function set(v)
            value = clamp(tonumber(v) or mn, mn, mx)
            local a = (value - mn) / (mx - mn)
            Tween(fill, M.base, { Size = UDim2.new(a, 0, 1, 0) })
            local ok, text = pcall(string.format, fmt, math.floor(a * 100 + 0.5), value)
            pct.Text = ok and text or tostring(value)
        end
        set(cfg.Default or mn)
        el.Set = method(el, set)
        el.Get = method(el, function() return value end)
        return finish(self, "Progress", cfg, c, el)
    end

    -- ---------------------------------- Stat (so lieu song) ----------------------------------
    function Container:CreateStat(cfg)
        cfg = cfg or {}
        local c = makeCard(self, cfg, { ctrlW = 150 })
        local val = Label(c.card, c.scope, "", TS.title, FONT.semi, "Text", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(150, 20), AutomaticSize = Enum.AutomaticSize.None, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd })
        bindA(c.scope, val, "TextColor3")
        local el = {}
        local value = cfg.Value ~= nil and cfg.Value or (cfg.Default ~= nil and cfg.Default or "-")
        val.Text = tostring(value)
        el.Set = method(el, function(v) value = v; val.Text = tostring(v) end)
        el.Get = method(el, function() return value end)
        return finish(self, "Stat", cfg, c, el)
    end

    -- ---------------------------------- Sparkline (do thi nho) ----------------------------------
    -- So cot co dinh, chi doi Size khi Push va gop cac lan Push trong 0.15s -> gan nhu khong ton FPS.
    function Container:CreateSparkline(cfg)
        cfg = cfg or {}
        local n = clamp(math.floor(tonumber(cfg.Points) or 40), 8, 120)
        local c = makeCard(self, cfg, { stack = true, h = 88, ctrlW = 100, below = 46 })
        local scope = c.scope
        local dec = tonumber(cfg.Decimals) or 1
        local suffix = tostring(cfg.Suffix or "")
        local val = Label(c.card, scope, "", TS.title, FONT.semi, "Text", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 9), Size = UDim2.fromOffset(110, 20), AutomaticSize = Enum.AutomaticSize.None, TextXAlignment = Enum.TextXAlignment.Right })
        bindA(scope, val, "TextColor3")
        local area = New("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 14, 1, -12), Size = UDim2.new(1, -28, 0, 36), Parent = c.card })
        local bars = {}
        for i = 1, n do
            local b = New("Frame", { BackgroundTransparency = 0.35, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new((i - 1) / n, 1, 1, 0), Size = UDim2.new(1 / n, -2, 0, 2), Parent = area })
            bindA(scope, b, "BackgroundColor3")
            bars[i] = b
        end
        local data, pending = {}, false
        local el = {}
        local function redraw()
            local lo, hi = math.huge, -math.huge
            for i = 1, #data do lo = math.min(lo, data[i]); hi = math.max(hi, data[i]) end
            if cfg.Min then lo = tonumber(cfg.Min) end
            if cfg.Max then hi = tonumber(cfg.Max) end
            local span = math.max(hi - lo, 1e-9)
            local off = n - #data
            for i = 1, n do
                local d = data[i - off]
                bars[i].Size = UDim2.new(1 / n, -2, 0, d and (2 + clamp((d - lo) / span, 0, 1) * 34) or 2)
                bars[i].BackgroundTransparency = (i == n and d) and 0 or 0.4
            end
            if #data > 0 then val.Text = string.format("%." .. dec .. "f", data[#data]) .. suffix end
        end
        el.Push = method(el, function(v)
            v = tonumber(v)
            if not v then return end
            data[#data + 1] = v
            if #data > n then table.remove(data, 1) end
            el.Value = v
            if not pending then
                pending = true
                task.delay(0.15, function() pending = false; redraw() end)
            end
        end)
        el.Clear = method(el, function() data = {}; redraw() end)
        el.Set = el.Push
        el.Get = method(el, function() return data[#data] end)
        return finish(self, "Sparkline", cfg, c, el)
    end
end

-- ================================ CAU HINH / FLAGS ================================
Library:AddTranslation({ vi = { ["No results"] = "Không có kết quả", ["English"] = "English", ["Copy failed, code placed in the box"] = "Không sao chép được, mã đã đặt vào ô nhập" } })

Library:AddTranslation({ vi = {
    ["Tip"] = "Mẹo", ["Press Ctrl+K to search every feature."] = "Nhấn Ctrl+K để tìm nhanh mọi tính năng.",
    ["Hold the floating button to search every feature."] = "Giữ nút nổi để tìm nhanh mọi tính năng.",
    ["Up/Down to move   Enter to run   Esc to close"] = "Lên/Xuống để chọn   Enter để chạy   Esc để đóng",
    ["Tools"] = "Công cụ", ["Reset window position"] = "Đặt lại vị trí cửa sổ", ["Reset"] = "Đặt lại", ["Rejoin server"] = "Vào lại server",
    ["Rejoin"] = "Vào lại", ["Copy server ID"] = "Sao chép ID server", ["Reset interface settings"] = "Đặt lại cài đặt giao diện",
    ["Reset interface settings?"] = "Đặt lại cài đặt giao diện?", ["Interface settings reset"] = "Đã đặt lại cài đặt giao diện",
    ["Everything will go back to default."] = "Mọi thứ sẽ về mặc định.",
} })

function Library:_RegFlag(flag, el, internal)
    el.Flag = flag
    el.Internal = internal == true
    self._Elems[flag] = el
    if not el.Internal and self.AutoLoad then self._autoLoadDeb() end
end
function Library:_Dirty(internal)
    if internal then self:_SaveUI() elseif self.AutoSave then self._autoSaveDeb() end
end
function Library:_Snapshot()
    local flags = {}
    for flag, v in pairs(self.Flags) do
        local el = self._Elems[flag]
        if el and not el.Internal then
            local sv = ser(v)
            if sv ~= nil then flags[flag] = sv end
        end
    end
    return { v = 4, flags = flags }
end
function Library:_Apply(data)
    if type(data) ~= "table" or type(data.flags) ~= "table" then return 0 end
    local n = 0
    for flag, raw in pairs(data.flags) do
        local el = self._Elems[flag]
        if el and el.Set then
            n = n + 1
            pcall(el.Set, el, des(raw), "force")
        end
    end
    return n
end
Library._autoLoadDeb = debounce(0.7, function()
    if not Library.AutoLoad then return end
    local d = Store.read(path("auto.json"))
    if d then Library:_Apply(d) end
    Library._autoLoaded = true
end)
Library._autoSaveDeb = debounce(1.5, function()
    if not Library.AutoSave or (Library.AutoLoad and not Library._autoLoaded) then return end
    Store.write(path("auto.json"), Library:_Snapshot())
end)

function Library:SaveConfig(slot)
    if not FS.ok then
        self:Notify({ Title = tr("Files are not available in this executor"), Type = "warning" })
        return false
    end
    return Store.write(path("configs", tostring(slot or "default") .. ".json"), self:_Snapshot()) == true
end
function Library:LoadConfig(slot)
    local d = Store.read(path("configs", tostring(slot or "default") .. ".json"))
    if not d then return false end
    self:_Apply(d)
    return true
end
function Library:ListConfigs()
    local out = {}
    if FS.ok and type(listfiles) == "function" then
        pcall(function()
            for _, f in ipairs(listfiles(path("configs"))) do
                local n = f:match("([^/\\]+)%.json$")
                if n then out[#out + 1] = n end
            end
        end)
    end
    return out
end
function Library:DeleteConfig(slot)
    if type(delfile) == "function" then pcall(delfile, path("configs", tostring(slot) .. ".json")) end
end
function Library:ExportConfig() return "MZ4:" .. b64enc(HttpService:JSONEncode(self:_Snapshot())) end
function Library:ImportConfig(code)
    code = (tostring(code or ""):gsub("%s", ""))
    if code:sub(1, 4) ~= "MZ4:" then return false end
    local raw = b64dec(code:sub(5))
    if not raw then return false end
    local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)
    if not ok then return false end
    return self:_Apply(data) > 0
end
function Library:SetAutoLoad(on)
    self.AutoLoad = on == true
    self.AutoSave = self.AutoLoad
    self.UI.autoload = self.AutoLoad
    self:_SaveUI()
    if self.AutoLoad then self._autoLoaded = true; Store.write(path("auto.json"), self:_Snapshot()) end
end
function Library:GetFlag(f) return self.Flags[f] end
function Library:SetFlag(f, v)
    local el = self._Elems[f]
    if el and el.Set then el:Set(v) else self.Flags[f] = v end
end

-- ================================ COMMAND PALETTE (Ctrl+K) ================================
Features.Palette = function(win)
    local P = { built = false, open = false, sel = 1, res = {}, recent = {}, byKey = {} }
    local shade, panel, box, listf, empty, pStroke, pScale, hint
    local rows = {}

    local function flash(card)
        local st = card:FindFirstChildOfClass("UIStroke")
        if not st then return end
        st.Color = Accent
        st.Thickness = 2
        task.delay(0.9, function()
            if st.Parent then st.Color = Theme.c.Stroke; st.Thickness = 1 end
        end)
    end
    local function reveal(e)
        win:SelectTab(e.tab)
        if e.ct and e.ct.Collapsed then e.ct:SetCollapsed(false) end
        task.delay(0.06, function()
            local card, page = e.card, e.tab.Page
            if not card.Parent then return end
            local y = (card.AbsolutePosition.Y - page.AbsolutePosition.Y) / win.Scale.Scale + page.CanvasPosition.Y - 14
            page.CanvasPosition = Vector2.new(0, math.max(0, y))
            flash(card)
        end)
    end
    local function score(q, hay)
        local s = hay:find(q, 1, true)
        if s then return 1000 - s * 4 - #hay * 0.05 end
        local all = true
        for w in q:gmatch("%S+") do
            if not hay:find(w, 1, true) then all = false; break end
        end
        if all then return 400 - #hay * 0.05 end
        local pos = 1
        for ch in q:gmatch("%S") do
            local f = hay:find(ch, pos, true)
            if not f then return 0 end
            pos = f + 1
        end
        return 100 - #hay * 0.05
    end
    local function collect()
        local items, byKey = {}, {}
        local function add(it)
            it.label = tr(it.title)
            it.norm = Norm(it.label .. " " .. it.title .. " " .. (it.sub or ""))
            it.key = it.kind .. "|" .. it.title .. "|" .. (it.tabName or "")
            items[#items + 1] = it
            byKey[it.key] = it
        end
        for _, tab in ipairs(win.Tabs) do
            add({ title = tab.Name, kind = "tab", sub = tr("Tabs"), tabName = tab.Name, run = function() win:SelectTab(tab) end })
            for _, e in ipairs(tab.Items) do
                if e.title ~= "" and not e.dead then
                    add({ title = e.title, kind = e.kind, sub = tr(tab.Name), tabName = tab.Name, e = e, run = function()
                        local el = e.el
                        if e.kind == "Button" then safe(el.Fire, el)
                        elseif e.kind == "Toggle" then
                            el:Set(not el:Get(), true)
                            Library:Notify({ Title = e.title, Content = el:Get() and tr("On") or tr("Off"), Duration = 1.6 })
                        else reveal(e) end
                    end })
                end
            end
        end
        for _, name in ipairs(THEME_ORDER) do
            add({ title = tr("Switch theme") .. ": " .. name, kind = "cmd", sub = tr("Commands"), run = function() Library:SetTheme(name) end })
        end
        add({ title = tr("Toggle lite mode"), kind = "cmd", sub = tr("Commands"), run = function() Library:SetPerformanceMode(Library.PerfMode and "off" or "on") end })
        add({ title = tr("Save config"), kind = "cmd", sub = tr("Commands"), run = function()
            if Library:SaveConfig("default") then Library:Notify({ Title = tr("Config saved"), Type = "success", Duration = 2 }) end
        end })
        return items, byKey
    end

    local function paintSel()
        local c3 = Theme.c
        for i, row in ipairs(rows) do
            row.b.BackgroundColor3 = c3.SurfaceHover
            row.b.BackgroundTransparency = (i == P.sel and row.b.Visible) and 0 or 1
        end
    end
    local function run(it)
        if not it then return end
        win:ClosePalette()
        for i = #P.recent, 1, -1 do if P.recent[i] == it.key then table.remove(P.recent, i) end end
        table.insert(P.recent, 1, it.key)
        if #P.recent > 6 then table.remove(P.recent) end
        it.run()
    end
    local function makeRow(i)
        local b = New("TextButton", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 36), LayoutOrder = i, Parent = listf })
        Corner(b, R.sm)
        local t = New("TextLabel", { BackgroundTransparency = 1, Font = FONT.semi, TextSize = TS.body, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0.62, -12, 1, 0), Parent = b })
        local s = New("TextLabel", { BackgroundTransparency = 1, Font = FONT.reg, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 0), Size = UDim2.new(0.38, -12, 1, 0), Parent = b })
        local row = { b = b, t = t, s = s, idx = i }
        b.MouseEnter:Connect(function() P.sel = row.idx; paintSel() end)
        b.Activated:Connect(function() run(P.res[row.idx]) end)
        return row
    end
    local function refresh()
        local q = Norm(box.Text)
        local res = {}
        if q == "" then
            for _, k in ipairs(P.recent) do
                if P.byKey[k] then res[#res + 1] = P.byKey[k] end
            end
            for _, it in ipairs(P.items) do
                if it.kind == "tab" and #res < 12 then res[#res + 1] = it end
            end
        else
            local scored = {}
            for _, it in ipairs(P.items) do
                local sc = score(q, it.norm)
                if sc > 0 then scored[#scored + 1] = { it, sc } end
            end
            table.sort(scored, function(a, b) return a[2] > b[2] end)
            for i = 1, math.min(#scored, 40) do res[i] = scored[i][1] end
        end
        P.res = res
        P.sel = 1
        local c3 = Theme.c
        for i, it in ipairs(res) do
            local row = rows[i]
            if not row then row = makeRow(i); rows[i] = row end
            row.b.Visible = true
            row.t.Text = it.label
            row.t.TextColor3 = c3.Text
            row.s.TextColor3 = c3.TextMuted
            local right = it.sub or ""
            if it.e and it.e.kind == "Toggle" then right = (it.e.el:Get() and tr("On") or tr("Off")) .. "  ·  " .. right end
            row.s.Text = right
        end
        for i = #res + 1, #rows do rows[i].b.Visible = false end
        empty.Visible = #res == 0
        empty.TextColor3 = c3.TextMuted
        listf.Size = UDim2.new(1, 0, 0, math.max(36, math.min(#res, 7) * 38 + 8))
        panel.Size = UDim2.new(0, math.min(400, win.Size.X - 32), 0, 52 + math.max(36, math.min(#res, 7) * 38 + 8) + 28)
        paintSel()
    end
    local function move(d)
        if #P.res == 0 then return end
        P.sel = ((P.sel - 1 + d) % #P.res) + 1
        paintSel()
        local row = rows[P.sel]
        if row then
            local top, bot = row.b.AbsolutePosition.Y, row.b.AbsolutePosition.Y + row.b.AbsoluteSize.Y
            local lt, lb = listf.AbsolutePosition.Y, listf.AbsolutePosition.Y + listf.AbsoluteSize.Y
            local s = win.Scale.Scale
            if top < lt then listf.CanvasPosition = Vector2.new(0, math.max(0, listf.CanvasPosition.Y - (lt - top) / s - 4))
            elseif bot > lb then listf.CanvasPosition = Vector2.new(0, listf.CanvasPosition.Y + (bot - lb) / s + 4) end
        end
    end
    local function build()
        P.built = true
        local ov = win.Overlay
        shade = New("TextButton", { Name = "PaletteShade", Size = UDim2.new(1, 0, 1, 0), Visible = false, ZIndex = 30, Parent = ov })
        shade.Activated:Connect(function() win:ClosePalette() end)
        panel = New("Frame", { Name = "Palette", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 58), Size = UDim2.fromOffset(380, 100), Visible = false, ZIndex = 31, Active = true, Parent = ov })
        Corner(panel, R.lg)
        pStroke = Stroke(panel, Theme.c.StrokeHover)
        pScale = New("UIScale", { Parent = panel })
        hint = New("TextLabel", { BackgroundTransparency = 1, Font = FONT.reg, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.new(0, 16, 1, -22), Size = UDim2.new(1, -32, 0, 18), Parent = panel })
        box = New("TextBox", { BackgroundTransparency = 1, ClearTextOnFocus = false, Font = FONT.reg, TextSize = TS.title, TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.new(0, 16, 0, 0), Size = UDim2.new(1, -32, 0, 50), Parent = panel })
        New("Frame", { Name = "Line", Position = UDim2.new(0, 0, 0, 50), Size = UDim2.new(1, 0, 0, 1), Parent = panel })
        listf = New("ScrollingFrame", { BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 52), Size = UDim2.new(1, 0, 0, 80), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollingDirection = Enum.ScrollingDirection.Y, Parent = panel })
        Pad(listf, 6, 4, 6, 4)
        List(listf, 2)
        empty = New("TextLabel", { BackgroundTransparency = 1, Font = FONT.reg, TextSize = TS.body, Size = UDim2.new(1, 0, 0, 36), Visible = false, Parent = listf })
        box:GetPropertyChangedSignal("Text"):Connect(refresh)
        box.FocusLost:Connect(function(enter)
            if enter and P.open then run(P.res[P.sel]) end
        end)
    end
    function win:OpenPalette()
        if not self.IsOpen then self:Open() end
        if not P.built then build() end
        self:ClosePopup()
        P.items, P.byKey = collect()
        local c3 = Theme.c
        shade.BackgroundColor3 = c3.Backdrop
        shade.BackgroundTransparency = Library.PerfMode and 0.45 or 1
        if not Library.PerfMode then Tween(shade, M.base, { BackgroundTransparency = 0.45 }) end
        pScale.Scale = 0.96
        Tween(pScale, M.pop, { Scale = 1 })
        hint.Text = tr("Up/Down to move   Enter to run   Esc to close")
        hint.TextColor3 = c3.TextMuted
        panel.BackgroundColor3 = c3.Surface
        pStroke.Color = c3.StrokeHover
        panel.Line.BackgroundColor3 = c3.Stroke
        box.TextColor3 = c3.Text
        box.PlaceholderColor3 = c3.TextMuted
        box.PlaceholderText = tr("Search features...")
        empty.Text = tr("No results")
        listf.ScrollBarImageColor3 = c3.StrokeHover
        shade.Visible = true
        panel.Visible = true
        P.open = true
        box.Text = ""
        refresh()
        box:CaptureFocus()
    end
    function win:ClosePalette()
        if not P.open then return end
        P.open = false
        shade.Visible = false
        panel.Visible = false
        box:ReleaseFocus()
    end
    win._palHub = Hub.add(function(i, gp)
        if i.UserInputType ~= Enum.UserInputType.Keyboard then return false end
        local kc = i.KeyCode
        if kc == Enum.KeyCode.K and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) and (P.open or not gp) then
            if P.open then win:ClosePalette() else win:OpenPalette() end
            return true
        end
        if P.open then
            if kc == Enum.KeyCode.Down then move(1); return true
            elseif kc == Enum.KeyCode.Up then move(-1); return true
            elseif kc == Enum.KeyCode.Escape then win:ClosePalette(); return true end
        end
        return false
    end)
    win._destroyers[#win._destroyers + 1] = function() Hub.remove(win._palHub) end
end

-- ================================ HOP THOAI ================================
function WindowMT:Dialog(cfg)
    cfg = cfg or {}
    if not self.IsOpen then self:Open() end
    self:ClosePopup()
    if self.ClosePalette then self:ClosePalette() end
    local c3 = Theme.c
    local shade = New("TextButton", { BackgroundColor3 = c3.Backdrop, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 40, Parent = self.Overlay })
    Tween(shade, M.base, { BackgroundTransparency = 0.4 })
    local card = New("Frame", { BackgroundColor3 = c3.Surface, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.fromOffset(math.min(340, self.Size.X - 40), 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 41, Active = true, Parent = shade })
    Corner(card, R.lg)
    Stroke(card, c3.StrokeHover)
    local sc = New("UIScale", { Scale = 0.94, Parent = card })
    Tween(sc, M.pop, { Scale = 1 })
    local inner = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = card })
    Pad(inner, 20, 18, 20, 16)
    List(inner, 6)
    local title = cfg.Title or cfg.Name
    local body = cfg.Content or cfg.Text or cfg.Description
    if title then New("TextLabel", { BackgroundTransparency = 1, Text = tr(tostring(title)), Font = FONT.semi, TextSize = 19, TextColor3 = c3.Text, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1, Parent = inner }) end
    if body then New("TextLabel", { BackgroundTransparency = 1, Text = tr(tostring(body)), Font = FONT.reg, TextSize = TS.body, TextColor3 = c3.TextDim, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2, Parent = inner }) end
    local bar = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 44), LayoutOrder = 3, Parent = inner })
    List(bar, 8, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Bottom)
    local function close() shade:Destroy() end
    local buttons = cfg.Buttons or { { Title = "OK" } }
    for i, bc in ipairs(buttons) do
        local label = tr(tostring(bc.Title or bc.Text or bc.Name or "OK"))
        local w = Measure(label, 15, FONT.semi, 400).X + 32
        local b = New("TextButton", { Text = label, Font = FONT.semi, TextSize = TS.body, Size = UDim2.fromOffset(w, 34), LayoutOrder = i, Parent = bar })
        Corner(b, R.sm)
        local st = bc.Style
        if st == "Danger" then b.BackgroundColor3 = c3.Danger; b.TextColor3 = WHITE
        elseif st == "Primary" or (st == nil and i == #buttons and #buttons > 1) then b.BackgroundColor3 = Accent; b.TextColor3 = OnAccent
        else b.BackgroundColor3 = c3.SurfaceHover; b.TextColor3 = c3.Text end
        b.Activated:Connect(function()
            close()
            safe(bc.Callback)
        end)
    end
    return { Close = close }
end

-- ================================ NUT NOI ================================
Features.Float = function(win)
    local cfg = win.Config
    if cfg.FloatingButton == false or cfg.ShowButton == false then return end
    local lib = win.Library
    local g = ensureGui()
    local function vp() return workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720) end
    local sp = lib.UI.btn
    local v0 = vp()
    local px = type(sp) == "table" and tonumber(sp[1]) or 36
    local py = type(sp) == "table" and tonumber(sp[2]) or v0.Y * 0.4
    local btn = New("TextButton", { Name = "Float", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(clamp(px, 24, v0.X - 24), clamp(py, 24, v0.Y - 24)), Size = UDim2.fromOffset(46, 46), Parent = g })
    Corner(btn, 23)
    local st = Stroke(btn, Theme.c.StrokeHover, 1.5)
    local sc = New("UIScale", { Parent = btn })
    local lbl = New("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = UpperVN(U.first(win.Title)), Font = FONT.bold, TextSize = 20, Parent = btn })
    local badge = New("TextLabel", { Visible = false, Font = FONT.bold, TextSize = 11, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 2, 0, -2), Size = UDim2.fromOffset(18, 18), ZIndex = 2, Parent = btn })
    Corner(badge, 9)
    local function paint()
        local c3 = Theme.c
        btn.BackgroundColor3 = c3.Surface
        btn.BackgroundTransparency = 0.06
        st.Color = win.IsOpen and Accent or c3.StrokeHover
        lbl.TextColor3 = win.IsOpen and Accent or c3.Text
        badge.BackgroundColor3 = Accent
        badge.TextColor3 = OnAccent
    end
    bindF(Chrome, paint)
    local pulse
    lib._onUnread = function()
        local n = lib.Unread
        badge.Visible = n > 0
        badge.Text = n > 9 and "9+" or tostring(n)
        if pulse then pulse:Cancel(); pulse = nil; st.Thickness = 1.5 end
        if n > 0 and not lib.PerfMode then
            pulse = TweenService:Create(st, TweenInfo.new(0.9, EZ.Sine, ED.InOut, -1, true), { Thickness = 3.5 })
            pulse:Play()
        end
    end
    btn.InputBegan:Connect(function(i)
        if not isPress(i) then return end
        local start = spos(i)
        local p0 = Vector2.new(btn.Position.X.Offset, btn.Position.Y.Offset)
        local moved = false
        local armed = {}
        local token = armed
        task.delay(0.5, function()
            if token == armed and not moved then
                token = nil
                Pointer.cancel()
                win:OpenPalette()
            end
        end)
        Tween(sc, M.fast, { Scale = 0.92 })
        Pointer.begin(function(p)
            local d = p - start
            if not moved and d.Magnitude > 6 then moved = true end
            if moved then
                local v = vp()
                btn.Position = UDim2.fromOffset(clamp(p0.X + d.X, 24, v.X - 24), clamp(p0.Y + d.Y, 24, v.Y - 24))
            end
        end, function()
            Tween(sc, M.fast, { Scale = 1 })
            if token == armed then
                token = nil
                if moved then
                    lib.UI.btn = { btn.Position.X.Offset, btn.Position.Y.Offset }
                    lib:_SaveUI()
                else
                    win:Toggle()
                end
            end
        end)
    end)
    win.Float = { sync = paint, destroy = function() btn:Destroy() end }
    win._destroyers[#win._destroyers + 1] = function() btn:Destroy(); lib._onUnread = nil end
end

function U.copy(s)
    local fn = (type(setclipboard) == "function" and setclipboard) or (type(toclipboard) == "function" and toclipboard)
    if not fn then return false end
    return (pcall(fn, s)) == true
end
function Library:ResetUI()
    self:SetRainbow(false)
    Theme.name = "Dark"
    Theme.c = THEMES.Dark
    eachScope(applyT, "dT")
    setAccentRaw(ACCENTS[1][2])
    self.BlurEnabled = false
    self:_Blur(false)
    self:SetUIScale(1)
    self:SetPerformanceMode("auto")
    self:Watermark(false)
    if self.SetKeybindHUD then self:SetKeybindHUD(false) end
    local defaults = { ui_theme = "Dark", ui_rainbow = false, ui_blur = false, ui_scale = 1, ui_perf = "Auto", ui_fps = false, ui_hud = false, ui_accent = ACCENTS[1][2] }
    for flag, v in pairs(defaults) do
        local el = self._Elems[flag]
        if el and el.Set then pcall(el.Set, el, v, false) end
    end
    self.UI = {}
    Store.write(path("ui.json"), {})
    self:Notify({ Title = tr("Interface settings reset"), Type = "success", Duration = 2 })
end

-- ================================ WATERMARK (FPS / Ping) ================================
local wm, wmStroke
function Library:Watermark(on)
    if on == nil then on = true end
    self.WatermarkOn = on == true
    self.UI.fps = self.WatermarkOn
    self:_SaveUI()
    if self.WatermarkOn then
        local g = ensureGui()
        if not wm or not wm.Parent then
            wm = New("TextLabel", { Name = "Watermark", AutomaticSize = Enum.AutomaticSize.XY, Position = UDim2.fromOffset(12, 12), Font = FONT.semi, TextSize = 14, Parent = g })
            Corner(wm, R.sm)
            Pad(wm, 12, 7, 12, 7)
            wmStroke = Stroke(wm, Theme.c.Stroke)
        end
        local function upd()
            local c3 = Theme.c
            wm.BackgroundColor3 = c3.Surface
            wm.TextColor3 = c3.Text
            wmStroke.Color = c3.Stroke
            local ping = 0
            pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5) end)
            wm.Text = (self.Window and self.Window.Title or "Meizu") .. "  |  " .. math.floor(Pulse.fps + 0.5) .. " fps  |  " .. ping .. " ms"
        end
        upd()
        wm.Visible = true
        Pulse.add("wm", 1, upd)
    else
        Pulse.remove("wm")
        if wm then wm.Visible = false end
    end
    self:_Sync()
end
Features.Watermark = function(win)
    if win.Library.UI.fps == true then win.Library:Watermark(true) end
end

-- ================================ BANG PHIM TAT (HUD) ================================
Features.HUD = function(win)
    local lib = win.Library
    local g = ensureGui()
    local hud = New("Frame", { Name = "KeybindHUD", Visible = false, AutomaticSize = Enum.AutomaticSize.XY, Position = UDim2.fromOffset(12, 56), Parent = g })
    Corner(hud, R.md)
    local st = Stroke(hud, Theme.c.Stroke)
    Pad(hud, 12, 10, 12, 10)
    List(hud, 4)
    local head = New("TextLabel", { BackgroundTransparency = 1, Font = FONT.bold, TextSize = 12, AutomaticSize = Enum.AutomaticSize.XY, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 0, Parent = hud })
    local rows = {}
    local function refresh()
        local c3 = Theme.c
        hud.BackgroundColor3 = c3.Surface
        hud.BackgroundTransparency = 0.06
        st.Color = c3.Stroke
        head.TextColor3 = c3.TextMuted
        head.Text = UpperVN(tr("Keybinds"))
        local list = {}
        for _, b in ipairs(lib._binds) do
            if b.key then list[#list + 1] = b end
        end
        hud.Visible = lib.HudOn == true and #list > 0
        for i = 1, #list do
            local r = rows[i]
            if not r then
                r = New("TextLabel", { BackgroundTransparency = 1, Font = FONT.reg, TextSize = TS.body - 1, AutomaticSize = Enum.AutomaticSize.XY, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = i, Parent = hud })
                rows[i] = r
            end
            local b = list[i]
            local k = U.keyShort[b.key.Name] or b.key.Name
            local on = b.state and b.mode ~= "Press"
            r.Text = (b.title ~= "" and b.title or "?") .. "   [" .. k .. "]" .. (on and "  ON" or "")
            r.TextColor3 = on and Accent or c3.Text
            r.Visible = true
        end
        for i = #list + 1, #rows do rows[i].Visible = false end
    end
    lib.HudOn = lib.UI.hud == true
    lib._hudRefresh = refresh
    function lib:SetKeybindHUD(on)
        self.HudOn = on == true
        self.UI.hud = self.HudOn
        self:_SaveUI()
        refresh()
    end
    hud.InputBegan:Connect(function(i)
        if not isPress(i) then return end
        local start = spos(i)
        local p0 = Vector2.new(hud.Position.X.Offset, hud.Position.Y.Offset)
        Pointer.begin(function(p)
            local d = p - start
            hud.Position = UDim2.fromOffset(p0.X + d.X, p0.Y + d.Y)
        end)
    end)
    bindF(Chrome, refresh)
    win._destroyers[#win._destroyers + 1] = function() hud:Destroy(); lib._hudRefresh = nil end
end

-- ================================ TAB CAI DAT ================================
Features.Settings = function(win)
    local lib = win.Library
    local cfg = win.Config
    local auto = lib.UI.autoload
    if auto == nil then auto = cfg.AutoLoad == true or cfg.AutoSave == true end
    lib.AutoLoad = auto == true
    lib.AutoSave = lib.AutoLoad
    if cfg.Blur ~= nil and lib.UI.blur == nil then lib.BlurEnabled = cfg.Blur == true end
    if cfg.SettingsTab == false then return end
    lib:AddTranslation({ vi = {
        ["Copy"] = "Sao chép", ["Auto turns lite mode on when FPS stays low."] = "Tự bật chế độ tiết kiệm khi FPS thấp kéo dài.",
        ["Lite mode"] = "Chế độ tiết kiệm", ["Custom accent"] = "Màu nhấn tùy chỉnh",
    } })

    local function build(t)
        local sA = t:CreateSection("Appearance")
        sA:CreateDropdown({ Title = "Theme", Options = THEME_ORDER, Default = Theme.name, Internal = true, Flag = "ui_theme", Callback = function(v) lib:SetTheme(v) end })
        local sw = U.card(sA, { Title = "Accent color" }, { stack = true, h = 82 })
        local row = New("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 14, 1, -12), Size = UDim2.new(1, -28, 0, 30), Parent = sw.card })
        List(row, 8, Enum.FillDirection.Horizontal)
        local chips = {}
        for i, a in ipairs(ACCENTS) do
            local b = New("TextButton", { BackgroundColor3 = a[2], Size = UDim2.fromOffset(28, 28), LayoutOrder = i, Parent = row })
            Corner(b, 14)
            chips[i] = { ring = Stroke(b, Theme.c.Text, 2, 1), col = a[2] }
            b.Activated:Connect(function()
                if lib.Rainbow then lib:SetRainbow(false) end
                lib:SetAccent(a[2])
            end)
        end
        bindF(sw.scope, function()
            for _, s in ipairs(chips) do
                local near = math.abs(s.col.R - Accent.R) + math.abs(s.col.G - Accent.G) + math.abs(s.col.B - Accent.B) < 0.02
                s.ring.Transparency = near and 0 or 1
                s.ring.Color = Theme.c.Text
            end
        end)
        sA:CreateColorPicker({ Title = "Custom accent", Default = Accent, Internal = true, Flag = "ui_accent", Callback = function(col)
            if lib.Rainbow then lib:SetRainbow(false) end
            lib:SetAccent(col)
        end })
        sA:CreateToggle({ Title = "Rainbow accent", Default = lib.Rainbow == true, Internal = true, Flag = "ui_rainbow", Callback = function(v) lib:SetRainbow(v) end })
        sA:CreateSegmented({ Title = "Language", Options = { "English", "Tiếng Việt" }, Default = lib.Lang == "vi" and 2 or 1, Internal = true, Flag = "ui_lang", Callback = function(v)
            lib:SetLanguage(v == "English" and "en" or "vi")
        end })
        sA:CreateToggle({ Title = "Blur background", Default = lib.BlurEnabled == true, Internal = true, Flag = "ui_blur", Callback = function(v)
            lib.BlurEnabled = v
            lib.UI.blur = v
            lib:_SaveUI()
            lib:_Blur(win.IsOpen)
        end })
        sA:CreateSlider({ Title = "Interface scale", Min = 0.7, Max = 1.3, Increment = 0.05, Default = lib.UIScale, Suffix = "x", Internal = true, Flag = "ui_scale", Callback = function(v) lib:SetUIScale(v) end })

        local sP = t:CreateSection("Performance")
        sP:CreateSegmented({ Title = "Lite mode", Description = "Auto turns lite mode on when FPS stays low.", Options = { "Auto", "On", "Off" }, Default = lib.PerfSetting == "on" and 2 or (lib.PerfSetting == "off" and 3 or 1), Internal = true, Flag = "ui_perf", Callback = function(v)
            lib:SetPerformanceMode(string.lower(v))
        end })
        sP:CreateToggle({ Title = "Show FPS watermark", Default = lib.WatermarkOn == true, Internal = true, Flag = "ui_fps", Callback = function(v) lib:Watermark(v) end })
        sP:CreateToggle({ Title = "Keybind HUD", Default = lib.HudOn == true, Internal = true, Flag = "ui_hud", Callback = function(v) lib:SetKeybindHUD(v) end })

        local sK = t:CreateSection("Keybinds")
        sK:CreateKeybind({ Title = "Toggle key", Default = win.ToggleKey, Internal = true, Flag = "ui_key", Changed = function(name)
            local _, k = U.parseKey(name)
            win.ToggleKey = (k and k.EnumType == Enum.KeyCode) and k or Enum.KeyCode.Unknown
            lib.UI.key = name
            lib:_SaveUI()
        end })

        local sC = t:CreateSection("Configuration")
        local slot = tonumber(lib.UI.slot) or 1
        sC:CreateSegmented({ Title = "Slot", Options = { "1", "2", "3" }, Default = slot, Internal = true, Flag = "ui_slot", Callback = function(v)
            slot = tonumber(v) or 1
            lib.UI.slot = slot
            lib:_SaveUI()
        end })
        sC:CreateButton({ Title = "Save", ButtonText = "Save", Callback = function()
            if lib:SaveConfig("slot" .. slot) then lib:Notify({ Title = tr("Config saved"), Content = tr("Slot") .. " " .. slot, Type = "success", Duration = 2 }) end
        end })
        sC:CreateButton({ Title = "Load", ButtonText = "Load", Callback = function()
            if lib:LoadConfig("slot" .. slot) then lib:Notify({ Title = tr("Config loaded"), Content = tr("Slot") .. " " .. slot, Type = "success", Duration = 2 })
            else lib:Notify({ Title = tr("Nothing saved in this slot"), Type = "warning", Duration = 2 }) end
        end })
        sC:CreateToggle({ Title = "Auto load on start", Default = lib.AutoLoad == true, Internal = true, Flag = "ui_auto", Callback = function(v)
            if v ~= lib.AutoLoad then lib:SetAutoLoad(v) end
        end })
        local importBox
        sC:CreateButton({ Title = "Copy share code", ButtonText = "Copy", Callback = function()
            local code = lib:ExportConfig()
            local fn = (type(setclipboard) == "function" and setclipboard) or (type(toclipboard) == "function" and toclipboard)
            if fn and pcall(fn, code) then
                lib:Notify({ Title = tr("Code copied"), Type = "success", Duration = 2 })
            else
                importBox:Set(code, false)
                lib:Notify({ Title = tr("Copy failed, code placed in the box"), Type = "warning", Duration = 3 })
            end
        end })
        importBox = sC:CreateInput({ Title = "Import share code", Placeholder = "Paste code here", Internal = true, Flag = "ui_import", Callback = function(text)
            if text == "" then return end
            if lib:ImportConfig(text) then lib:Notify({ Title = tr("Config loaded"), Type = "success", Duration = 2 })
            else lib:Notify({ Title = tr("Invalid code"), Type = "error", Duration = 2 }) end
        end })

        local sN = t:CreateSection("Notifications")
        local histEls = {}
        local function fillHistory()
            for _, e in ipairs(histEls) do e:Destroy() end
            histEls = {}
            local h = lib.History
            if #h == 0 then
                histEls[1] = sN:CreateLabel("No notifications yet")
                return
            end
            for i = #h, math.max(1, #h - 7), -1 do
                local n = h[i]
                histEls[#histEls + 1] = sN:CreateParagraph({ Title = n.title ~= "" and n.title or "-", Content = n.body ~= "" and n.body or os.date("%H:%M:%S", n.time), NoIndex = true })
            end
        end
        sN:CreateButton({ Title = "Notifications", ButtonText = "Clear", Callback = function()
            lib.History = {}
            lib.Unread = 0
            fillHistory()
        end })
        fillHistory()
        t.OnShow = fillHistory

        local sT = t:CreateSection("Tools")
        sT:CreateButton({ Title = "Reset window position", ButtonText = "Reset", Callback = function()
            local v = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
            win.Pos = Vector2.new(v.X / 2, v.Y / 2)
            win:_Move()
        end })
        sT:CreateButton({ Title = "Copy server ID", ButtonText = "Copy", Callback = function()
            if U.copy(game.JobId ~= "" and game.JobId or tostring(game.PlaceId)) then lib:Notify({ Title = tr("Code copied"), Type = "success", Duration = 2 }) end
        end })
        sT:CreateButton({ Title = "Rejoin server", ButtonText = "Rejoin", Callback = function()
            local TeleportService = game:GetService("TeleportService")
            pcall(function()
                if #Players:GetPlayers() <= 1 then TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
                else TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer) end
            end)
        end })
        sT:CreateButton({ Title = "Reset interface settings", ButtonText = "Reset", Style = "Danger", Callback = function()
            win:Dialog({ Title = "Reset interface settings?", Content = "Everything will go back to default.", Buttons = {
                { Title = "Cancel" },
                { Title = "Reset", Style = "Danger", Callback = function() lib:ResetUI() end },
            } })
        end })

        local sB = t:CreateSection("About")
        sB:CreateParagraph({ Title = "Meizu Library " .. lib.Version, Content = "Graphite", NoIndex = true })
        sB:CreateButton({ Title = "Unload UI", ButtonText = "Unload", Style = "Danger", Callback = function()
            win:Dialog({ Title = "Remove this UI?", Content = "Everything in this window will be closed.", Buttons = {
                { Title = "Cancel" },
                { Title = "Unload", Style = "Danger", Callback = function() lib:Destroy() end },
            } })
        end })
    end
    win.SettingsTab = win:_NewTab({ Name = "Settings", Pinned = true, Order = 1, Build = build })
end

return Library
