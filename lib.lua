--[[
    ███╗   ███╗███████╗██╗███████╗██╗   ██╗
    ████╗ ████║██╔════╝██║██╔════╝╚██╗ ██╔╝
    ██╔████╔██║█████╗  ██║███████╗ ╚████╔╝
    ██║╚██╔╝██║██╔══╝  ██║╚════██║  ╚██╔╝
    ██║ ╚═╝ ██║███████╗██║███████║   ██║
    ╚═╝     ╚═╝╚══════╝╚═╝╚══════╝   ╚═╝
    MEIZU LIBRARY v3.1 "Luxe" — Modern UI Library cho Roblox (Fluent-inspired)
    ===========================================================================
    API (tương thích hoàn toàn với bản v2.x):
      Library:CreateWindow{Title, SubTitle, Theme, Accent, ToggleKeybind, ToggleUIButton,
                           Size, Language, SettingsTab, SettingsIcon, AutoOpen, PersistUI}
      Window:CreateTab(name, icon, order)  /  Window:SelectTab(số | tên)
      Window:Toggle(state)  /  Window:Dialog{Title, Content, Buttons}
      Window:SetTitle(text) / Window:SetSubTitle(text) / Window:SetScale(0.7 → 1.3)
      Window.SettingsTab    -- tab "Cài đặt" tự tạo, có thể tự thêm element vào
      Tab/Section:CreateSection / CreateButton / CreateToggle / CreateSlider
                  CreateDropdown / CreateMultiDropdown / CreateKeybind / CreateInput
                  CreateColorPicker / CreateParagraph
      Library:Notify{Title, Content, Duration, Type = "info|success|warning|error"}
      Library:ApplyTheme("Dark") / ApplyAccent(Color3) / SetRainbow(bool)
      Library:SetLanguage("vi" | "en") / AddTranslation(key, {vi = "...", en = "..."})
      Library:SetFont("Source Sans" | "Builder Sans" | "Gotham")
      Library:SaveSettings(name) / LoadSettings(name, silent) / ListConfigs()
      Library:Destroy()   |   Library.Flags --> giá trị theo Flag
      Library.Utils = {UpperVN, StripAccents, NormalizeSearch, EscapeRich, FormatNumber, Comma, FormatTime}
      -- Mới ở v3.1:
      Tab/Section:CreateSegmented{Title, Options, Default, Flag, Callback}   -- nút chọn kính trượt (kiểu iOS)
      Tab/Section:CreateProgress{Title, Min, Max, Default, Format}  -> .SetValue(v, text) .SetRange(min, max)
      Tab/Section:CreateStepper{Title, Min, Max, Step, Default, Flag, Callback}   -- nút − / + (giữ để lặp)
      Tab/Section:CreateLabel(text | {Text, Color, Size})  /  CreateDivider()
      Section:CreateSection(name, collapsedByDefault) -> :Collapse(bool) :Toggle() :IsCollapsed()
      Element (mọi loại): .SetVisible(b) .SetEnabled(b) .SetTitle(t) .SetDescription(t) .Destroy()
      Tab:SetBadge(true | số | chữ | nil)        Window:SetSize(w, h) / ResetLayout() / SetWatermark(b)
      Library:SetPerformanceMode(b) / SetGlassWindow(b) / SetBlur(b, size) / SetWatermark(b)
      Library:LoadAutoConfig() / SaveAutoConfig()   -- cấu hình tự lưu "_auto" (bật trong Cài đặt)
      Library:OnDestroy(fn)

    CHANGELOG v3.1 (bản "toàn quyền sáng tạo")
      [Element mới]  Segmented (nút chọn kính trượt kiểu iOS), Progress, Stepper (giữ để lặp), Label, Divider.
                     Mọi element có thêm SetVisible / SetEnabled / SetTitle / SetDescription / Destroy.
      [Tiện ích]     Section thu gọn được (nhớ trạng thái), Tab:SetBadge, tự lưu / tự tải cấu hình, nhớ vị trí + kích
                     thước cửa sổ + tab đang xem, kéo góc phải-dưới để đổi kích thước cửa sổ.
      [Liquid Glass] Nút nổi hít vào mép màn hình (+ tuỳ chọn thu nửa), huy hiệu số thông báo chưa đọc, Watermark
                     FPS / Ping / giờ dạng kính, "Cửa sổ kính mờ" và làm mờ nền game (BlurEffect).
      [Hiệu năng]    Chế độ tiết kiệm: tắt vòng lặp hiệu ứng, giảm tần số rainbow, tắt blur.

    CHANGELOG v3.0
      [Tiếng Việt]
        • Viết lại hệ thống ngôn ngữ: MỌI chữ của library (tab, tiêu đề, nút, dialog, thông báo,
          placeholder...) đều dịch được và đổi ngôn ngữ là cập nhật ngay, không cần mở lại UI.
        • Sửa string.upper làm hỏng chữ hoa tiếng Việt ("CHIếM" -> "CHIẾM") bằng UpperVN theo UTF-8.
        • Tìm kiếm không phân biệt dấu & hoa/thường: gõ "an thit" vẫn ra "Ăn Thịt".
        • Phông chữ hỗ trợ đầy đủ dấu tiếng Việt (Source Sans) + đổi phông ngay trong Cài đặt.
        • Ngôn ngữ / chủ đề / màu nhấn / phông / âm thanh được nhớ lại cho lần chạy sau.
      [Giao diện]
        • Thanh tiêu đề (header) riêng ở phần nội dung: có khoảng trống để KÉO cửa sổ, nội dung
          cuộn luôn nằm dưới header và mờ dần khi trượt lên (không còn đè lên nút thu nhỏ/đóng).
        • NÚT NỔI LIQUID GLASS (kiểu iOS 26): thân kính trong, viền sáng lệch hướng đung đưa, ánh phản
          chiếu quét ngang, "nhún" như chất lỏng khi chạm/kéo/bật-tắt, gợn sóng tại điểm chạm.
          Đổi/tắt bằng TOGGLE_BUTTON_STYLE, GLASS_TINT, GLASS_ALPHA ở phần cấu hình nhanh.
        • Tab "Cài đặt" có icon rbxassetid://10734950309; tab nào không có icon sẽ tự có chấm tròn
          thay vì để trống. Icon đổi màu theo tab đang chọn.
        • Bóng đổ thật sự hiển thị (bản cũ bị CanvasGroup cắt mất), góc bo không còn bị khuyết ở
          đường nối sidebar, tự co cửa sổ vừa màn hình điện thoại, kéo không bị lọt khỏi màn hình.
      [Sửa lỗi]
        • Destroy() không reset drag pipeline -> tạo lại cửa sổ thì slider/color picker không kéo được.
        • Chạy lại script -> tự gỡ UI cũ cùng Title, không bị chồng 2 cửa sổ.
        • Rainbow không còn gọi pcall + closure cho từng object mỗi frame (giới hạn 30 FPS).
        • Đổi Accent giờ cập nhật cả công tắc đang bật, dropdown, tab đang chọn.
        • Keybind: bấm gán phím không còn kích hoạt callback ngay; Backspace để xoá phím.
        • Input: lưu giá trị cả khi bấm ra ngoài (mobile); LoadSettings kích hoạt callback.
        • RichText: tên config/nội dung người dùng được escape, không còn làm hỏng thông báo.
        • Dialog chặn click xuyên xuống UI bên dưới; Notify xếp tối đa 5 thẻ.
]]

--// ================== CẤU HÌNH NHANH ==================
local TOGGLE_BUTTON_SIZE     = UDim2.new(0, 50, 0, 50)                                  -- Nút nổi
local TOGGLE_BUTTON_POSITION = UDim2.new(0.120833337 - 0.1, 0, 0.0952890813 + 0.01, 0)  -- Vị trí nút nổi

-- Hình mặc định của nút nổi (URL PNG hoặc rbxassetid://ID)
local TOGGLE_BUTTON_IMAGE    = "https://i.ibb.co/S7rpHJJN/meizuxp.png"

-- Bo góc nút nổi (KHÔNG tròn hoàn hảo)
local TOGGLE_BUTTON_RADIUS   = 12

-- Kiểu nút nổi: "LiquidGlass" (kính lỏng kiểu iOS 26) | "Classic" (nền đặc như bản cũ)
local TOGGLE_BUTTON_STYLE       = "LiquidGlass"
local TOGGLE_BUTTON_GLASS_TINT  = Color3.fromRGB(12, 16, 30)   -- màu ám của kính
local TOGGLE_BUTTON_GLASS_ALPHA = 0.47                         -- độ trong của thân kính (0 = đặc, 1 = trong suốt hoàn toàn)

-- Icon của tab "Cài đặt" tự tạo (đổi bằng config.SettingsIcon)
local SETTINGS_TAB_ICON      = "rbxassetid://10734950309"

local DEFAULT_WINDOW_SIZE    = UDim2.fromOffset(600, 430)  -- Kích thước cửa sổ mặc định
local SIDEBAR_WIDTH          = 190                         -- Độ rộng thanh bên trái
local HEADER_HEIGHT          = 50                          -- Chiều cao header (vùng kéo cửa sổ)
local DEFAULT_FONT           = "Source Sans"               -- Phông mặc định (hỗ trợ dấu tiếng Việt)

-- Nút nổi: thả gần mép thì tự hít vào mép trái/phải (kiểu AssistiveTouch của iPhone)
local TOGGLE_BUTTON_SNAP        = true
-- Nút nổi tự thu một nửa vào mép khi không dùng ~3 giây (chạm vào là bung ra)
local TOGGLE_BUTTON_DOCK        = false
local GLASS_SURFACE_ALPHA       = 0.16                         -- độ trong thêm của cửa sổ khi bật "Cửa sổ kính mờ"
local DEFAULT_BLUR_SIZE         = 14                           -- độ mờ nền game mặc định
local AUTO_CONFIG_NAME          = "_auto"                      -- file cấu hình tự lưu / tự tải
--// ====================================================

local MeizuLibrary = {
    Version       = "3.1",
    Flags         = {},
    Theme         = "Dark",
    Accent        = Color3.fromRGB(88, 101, 242),
    ToggleKeybind = Enum.KeyCode.RightControl,
    SoundEnabled  = true,
    Folder        = "MeizuLibrary",
    Language      = "vi",
    FontName      = DEFAULT_FONT,
    UIScale       = 1,
    PersistUI     = true,
    PerfMode      = false,          -- chế độ tiết kiệm (giảm hiệu ứng)
    GlassWindow   = false,          -- cửa sổ kính mờ (trong suốt nhẹ)
    BlurEnabled   = false,          -- làm mờ nền game khi UI mở
    BlurSize      = DEFAULT_BLUR_SIZE,
    AutoSave      = false,          -- tự lưu cấu hình khi có thay đổi
    AutoLoad      = false,          -- tự tải cấu hình đã lưu khi mở UI
    WatermarkOn   = false,          -- hiện FPS / Ping / giờ
    CollapsedSections = {},         -- ["Tab/Section"] = true | false
    Icons         = {settings = SETTINGS_TAB_ICON},   -- Library.Icons["tên"] = "rbxassetid://..."
    _FlagElems    = {},
    _ThemeObjs    = {},
    _AccentObjs   = {},
    _ThemeHooks   = {},
    _AccentHooks  = {},
    _LangHooks    = {},
    _FontHooks    = {},
    _LocBindings  = {},
    _LocEntries   = {},          -- giữ lại cho tương thích bản cũ (không còn dùng)
    _SurfaceObjs  = {},
    _PerfHooks    = {},
    _WindowOpen   = false,
    _LastBind     = 0,
    _FontObjs     = {},
    _Connections  = {},
    _ActiveDrags  = {},
    _Notifs       = {},
    _NotifCount   = 0,
    _ToggleImage  = nil,
    Destroyed     = false,
}

local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local HttpService      = game:GetService("HttpService")
local TextService      = game:GetService("TextService")
local SoundService     = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end

--// ---------------------- Executor / file helpers ----------------------
local function HasFileSystem()
    return type(writefile) == "function" and type(readfile) == "function"
end

local function EnsureFolder()
    if type(isfolder) == "function" and type(makefolder) == "function" then
        if not isfolder(MeizuLibrary.Folder) then makefolder(MeizuLibrary.Folder) end
    end
end

local function GetCustomAssetFn()
    if type(getcustomasset) == "function" then return getcustomasset end
    if type(getsynasset) == "function" then return getsynasset end
    return nil
end

--// ============================ TEXT / UTF-8 UTILITIES ============================
-- Lua gốc chỉ xử lý ASCII: string.upper("Chiếm") -> "CHIếM" (hỏng chữ có dấu).
-- Các hàm dưới đây xử lý theo từng codepoint UTF-8 nên tiếng Việt luôn đúng.
local HAS_UTF8 = type(utf8) == "table" and type(utf8.codes) == "function" and type(utf8.char) == "function"

-- Bảng chữ gốc (sinh tự động từ Unicode, "." = không có chữ gốc):
--   ACCENT_LATIN : U+00C0 .. U+01B0  (Latin-1, Latin Extended-A/B, Ơ ơ Ư ư, Đ đ)
--   ACCENT_VN    : U+1EA0 .. U+1EF9  (toàn bộ chữ tiếng Việt có dấu: ạ ả ấ ầ ẩ ẫ ậ ...)
local ACCENT_LATIN_START = 0xC0
local ACCENT_LATIN = "AAAAAA.CEEEEIIII.NOOOOO.OUUUUY..aaaaaa.ceeeeiiii.nooooo.ouuuuy.yAaAaAaCcCcCcCcDdDdEeEeEeEeEeGgGgGgGgHhHhIiIiIiIiIi..JjKk.LlLlLlLlLlNnNnNn...OoOoOo..RrRrRrSsSsSsSsTtTt..UuUuUuUuUuUuWwYyYZzZzZz.................................Oo.............Uu"
local ACCENT_VN_START = 0x1EA0
local ACCENT_VN = "AaAaAaAaAaAaAaAaAaAaAaAaEeEeEeEeEeEeEeEeIiIiOoOoOoOoOoOoOoOoOoOoOoOoUuUuUuUuUuUuUuYyYyYyYy"

local function Trim(s)
    return (tostring(s or ""):match("^%s*(.-)%s*$"))
end

local function HasHighBytes(s)
    return s:find("[\128-\255]") ~= nil
end

local function BaseLetter(cp)
    local idx = cp - ACCENT_LATIN_START + 1
    if idx >= 1 and idx <= #ACCENT_LATIN then
        local c = ACCENT_LATIN:sub(idx, idx)
        if c ~= "." then return c end
        return nil
    end
    idx = cp - ACCENT_VN_START + 1
    if idx >= 1 and idx <= #ACCENT_VN then
        return ACCENT_VN:sub(idx, idx)
    end
    return nil
end

-- Duyệt từng codepoint; fn trả về: số (codepoint mới) | chuỗi | nil (bỏ ký tự)
-- Trả về nil nếu chuỗi không phải UTF-8 hợp lệ.
local function MapCodepoints(s, fn)
    local out, n = {}, 0
    local ok = pcall(function()
        for _, cp in utf8.codes(s) do
            local r = fn(cp)
            if r ~= nil then
                n = n + 1
                if type(r) == "number" then out[n] = utf8.char(r) else out[n] = r end
            end
        end
    end)
    if not ok then return nil end
    return table.concat(out)
end

-- "Ăn Thịt" -> "An Thit"   (xử lý cả dấu rời kiểu NFD: U+0300..U+036F)
local function StripAccents(s)
    s = tostring(s or "")
    if not HAS_UTF8 or not HasHighBytes(s) then return s end
    local r = MapCodepoints(s, function(cp)
        if cp >= 0x300 and cp <= 0x36F then return nil end
        local base = BaseLetter(cp)
        if base then return base end
        return cp
    end)
    return r or s
end

-- Chữ thường -> chữ hoa theo codepoint (có cả toàn bộ chữ tiếng Việt)
local function CpUpper(cp)
    if cp < 0x80 then
        if cp >= 97 and cp <= 122 then return cp - 32 end
        return cp
    end
    if cp >= 0xE0 and cp <= 0xFE then
        if cp == 0xF7 then return cp end          -- ÷
        return cp - 32                            -- à á â ã è é ê ì í ò ó ô õ ù ú ý ...
    end
    if cp == 0xFF then return 0x178 end
    if (cp >= 0x100 and cp <= 0x137) or (cp >= 0x14A and cp <= 0x177) then
        if cp == 0x131 then return 0x49 end       -- ı -> I
        if cp % 2 == 1 then return cp - 1 end     -- ă đ ĩ ũ ...
        return cp
    end
    if (cp >= 0x139 and cp <= 0x148) or (cp >= 0x179 and cp <= 0x17E) then
        if cp % 2 == 0 then return cp - 1 end
        return cp
    end
    if cp == 0x1A1 then return 0x1A0 end          -- ơ -> Ơ
    if cp == 0x1B0 then return 0x1AF end          -- ư -> Ư
    if cp >= 0x1EA0 and cp <= 0x1EF9 then
        if cp % 2 == 1 then return cp - 1 end     -- ạ ả ấ ầ ẩ ẫ ậ ắ ằ ... ỹ
        return cp
    end
    return cp
end

-- "Chiếm Zone" -> "CHIẾM ZONE"
local function UpperVN(s)
    s = tostring(s or "")
    if not HAS_UTF8 or not HasHighBytes(s) then return string.upper(s) end
    local r = MapCodepoints(s, CpUpper)
    return r or string.upper(s)
end

-- Chuẩn hoá để tìm kiếm: bỏ dấu + chữ thường + gộp khoảng trắng
local function NormalizeSearch(s)
    local r = string.lower(StripAccents(Trim(s)))
    r = r:gsub("%s+", " ")
    return r
end

-- Escape ký tự đặc biệt khi chèn chữ của người dùng vào RichText
local function EscapeRich(s)
    s = tostring(s or "")
    s = s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"):gsub("'", "&apos;")
    return s
end

-- Bỏ thẻ RichText (dùng khi đo chiều cao chữ)
local function StripRich(s)
    s = tostring(s or "")
    if not s:find("[<&]") then return s end
    s = s:gsub("<br%s*/?>", "\n")
    s = s:gsub("<[^>]*>", "")
    s = s:gsub("&lt;", "<"):gsub("&gt;", ">"):gsub("&quot;", '"'):gsub("&apos;", "'"):gsub("&amp;", "&")
    return s
end

-- Tên file an toàn cho writefile (executor Android hay lỗi với ký tự lạ / có dấu)
local function SanitizeFileName(name)
    local s = StripAccents(Trim(name))
    s = s:gsub("%s+", "_"):gsub("[^%w_%-%.]", "")
    s = s:gsub("^%.+", "")
    if #s > 48 then s = s:sub(1, 48) end
    if s == "" then s = "config" end
    return s
end

local function HashString(s)
    local h = 5381
    for i = 1, #s do
        h = (h * 33 + s:byte(i)) % 4294967296
    end
    return string.format("%08x", h)
end

-- 116149193 -> "116,149,193"
local function Comma(n)
    n = tonumber(n) or 0
    local neg = n < 0
    local s = string.format("%d", math.floor(math.abs(n) + 0.5))
    local out = s:reverse():gsub("(%d%d%d)", "%1,"):reverse()
    out = out:gsub("^,", "")
    return (neg and "-" or "") .. out
end

-- 116149193 -> "116.1M", 2500 -> "2.5K"  (tiền / điểm kinh nghiệm trong game)
local function FormatNumber(n)
    n = tonumber(n) or 0
    local a = math.abs(n)
    local units = {{1e15, "Qa"}, {1e12, "T"}, {1e9, "B"}, {1e6, "M"}, {1e3, "K"}}
    for _, u in ipairs(units) do
        if a >= u[1] then
            local v = n / u[1]
            local txt = string.format("%.1f", v):gsub("%.0$", "")
            return txt .. u[2]
        end
    end
    if n % 1 == 0 then return string.format("%d", n) end
    return string.format("%.1f", n)
end

-- 3725 -> "01:02:05"
local function FormatTime(sec)
    sec = math.max(math.floor(tonumber(sec) or 0), 0)
    return string.format("%02d:%02d:%02d", math.floor(sec / 3600), math.floor(sec / 60) % 60, sec % 60)
end

MeizuLibrary.Utils = {
    UpperVN         = UpperVN,
    StripAccents    = StripAccents,
    NormalizeSearch = NormalizeSearch,
    EscapeRich      = EscapeRich,
    SanitizeFileName = SanitizeFileName,
    Comma           = Comma,
    FormatNumber    = FormatNumber,
    FormatTime      = FormatTime,
}

--// ============================ CORE PRIMITIVES ============================
local function New(class, props, children)
    local obj = Instance.new(class)
    local parent = nil
    if props then
        for k, v in pairs(props) do
            if k == "Parent" then parent = v else obj[k] = v end
        end
    end
    if children then
        for _, c in ipairs(children) do c.Parent = obj end
    end
    if parent then obj.Parent = parent end
    return obj
end

local function Tween(obj, time, props, style, dir)
    if not obj then return nil end
    local ok, tw = pcall(function()
        local t = TweenService:Create(obj,
            TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
            props)
        t:Play()
        return t
    end)
    if ok then return tw end
    return nil
end

-- Dọn các entry đã bị Destroy khỏi danh sách đăng ký (tránh rò rỉ bộ nhớ)
local function PruneList(list)
    local j = 0
    local n = #list
    for i = 1, n do
        local e = list[i]
        local o = e.Object
        if o and o.Parent ~= nil then
            j = j + 1
            list[j] = e
        end
    end
    for i = n, j + 1, -1 do list[i] = nil end
end

--// ============================ THEMES ============================
MeizuLibrary.Themes = {
    Dark = {
        Window = Color3.fromRGB(18, 20, 28),   Sidebar = Color3.fromRGB(13, 15, 21),
        Tab = Color3.fromRGB(26, 29, 40),      Element = Color3.fromRGB(27, 30, 42),
        Stroke = Color3.fromRGB(45, 50, 66),   Track = Color3.fromRGB(45, 50, 66),
        Text = Color3.fromRGB(240, 242, 248),  SubText = Color3.fromRGB(148, 153, 168),
        Placeholder = Color3.fromRGB(105, 110, 125),
        Input = Color3.fromRGB(21, 24, 33),    Dropdown = Color3.fromRGB(21, 24, 33),
        ToggleOff = Color3.fromRGB(52, 57, 73),
        Overlay = Color3.fromRGB(8, 9, 13),    Notification = Color3.fromRGB(25, 28, 38),
    },
    Light = {
        Window = Color3.fromRGB(246, 247, 251), Sidebar = Color3.fromRGB(238, 240, 246),
        Tab = Color3.fromRGB(255, 255, 255),    Element = Color3.fromRGB(255, 255, 255),
        Stroke = Color3.fromRGB(215, 219, 230), Track = Color3.fromRGB(210, 215, 227),
        Text = Color3.fromRGB(35, 38, 48),      SubText = Color3.fromRGB(120, 126, 142),
        Placeholder = Color3.fromRGB(160, 165, 180),
        Input = Color3.fromRGB(243, 244, 250),  Dropdown = Color3.fromRGB(250, 251, 253),
        ToggleOff = Color3.fromRGB(205, 210, 222),
        Overlay = Color3.fromRGB(120, 125, 140), Notification = Color3.fromRGB(255, 255, 255),
    },
    Midnight = {
        Window = Color3.fromRGB(15, 19, 32),   Sidebar = Color3.fromRGB(11, 14, 25),
        Tab = Color3.fromRGB(22, 27, 45),      Element = Color3.fromRGB(23, 28, 47),
        Stroke = Color3.fromRGB(40, 48, 78),   Track = Color3.fromRGB(42, 50, 80),
        Text = Color3.fromRGB(232, 238, 255),  SubText = Color3.fromRGB(140, 150, 185),
        Placeholder = Color3.fromRGB(100, 110, 140),
        Input = Color3.fromRGB(17, 21, 36),    Dropdown = Color3.fromRGB(17, 21, 36),
        ToggleOff = Color3.fromRGB(48, 56, 88),
        Overlay = Color3.fromRGB(6, 8, 14),    Notification = Color3.fromRGB(21, 26, 44),
    },
    Void = {
        Window = Color3.fromRGB(10, 10, 12),   Sidebar = Color3.fromRGB(7, 7, 9),
        Tab = Color3.fromRGB(16, 16, 19),      Element = Color3.fromRGB(16, 16, 20),
        Stroke = Color3.fromRGB(32, 32, 38),   Track = Color3.fromRGB(34, 34, 42),
        Text = Color3.fromRGB(235, 235, 240),  SubText = Color3.fromRGB(130, 130, 140),
        Placeholder = Color3.fromRGB(90, 90, 100),
        Input = Color3.fromRGB(13, 13, 16),    Dropdown = Color3.fromRGB(13, 13, 16),
        ToggleOff = Color3.fromRGB(40, 40, 48),
        Overlay = Color3.fromRGB(0, 0, 0),     Notification = Color3.fromRGB(14, 14, 18),
    },
    -- Mới: đen ấm kiểu "Obsidian", hợp với màu nhấn vàng (Gold) trong bảng chọn màu
    Obsidian = {
        Window = Color3.fromRGB(17, 16, 18),   Sidebar = Color3.fromRGB(11, 10, 12),
        Tab = Color3.fromRGB(30, 28, 32),      Element = Color3.fromRGB(25, 24, 27),
        Stroke = Color3.fromRGB(52, 49, 46),   Track = Color3.fromRGB(52, 49, 46),
        Text = Color3.fromRGB(242, 238, 230),  SubText = Color3.fromRGB(156, 149, 138),
        Placeholder = Color3.fromRGB(108, 103, 95),
        Input = Color3.fromRGB(19, 18, 20),    Dropdown = Color3.fromRGB(19, 18, 20),
        ToggleOff = Color3.fromRGB(60, 57, 53),
        Overlay = Color3.fromRGB(0, 0, 0),     Notification = Color3.fromRGB(25, 24, 27),
    },
}

local function T(key)
    local theme = MeizuLibrary.Themes[MeizuLibrary.Theme]
    return (theme and theme[key]) or Color3.fromRGB(255, 255, 255)
end

local function Shade(color, mult)
    mult = mult or 1
    if mult >= 1 then
        return color:Lerp(Color3.new(1, 1, 1), math.min(mult - 1, 1))
    end
    return color:Lerp(Color3.new(0, 0, 0), 1 - mult)
end

--// ============================ FONTS ============================
-- Gotham KHÔNG có đủ glyph tiếng Việt (Roblox phải mượn font khác cho chữ có dấu -> chữ lệch,
-- dấu bị chồng/cắt). Mặc định dùng Source Sans (đủ dấu tiếng Việt), đổi được trong Cài đặt.
local function FontEnum(name, fallback)
    local ok, v = pcall(function() return Enum.Font[name] end)
    if ok and v then return v end
    return fallback
end

MeizuLibrary.FontPresets = {
    ["Source Sans"] = {
        Regular = FontEnum("SourceSans", Enum.Font.Gotham),
        Medium  = FontEnum("SourceSansSemibold", Enum.Font.GothamMedium),
        Bold    = FontEnum("SourceSansBold", Enum.Font.GothamBold),
        Black   = FontEnum("SourceSansBold", Enum.Font.GothamBlack),
        SizeOffset = 2,    -- Source Sans nhỏ hơn Gotham nên cộng thêm cỡ chữ
    },
    ["Builder Sans"] = {
        Regular = FontEnum("BuilderSans", Enum.Font.Gotham),
        Medium  = FontEnum("BuilderSansMedium", Enum.Font.GothamMedium),
        Bold    = FontEnum("BuilderSansBold", Enum.Font.GothamBold),
        Black   = FontEnum("BuilderSansExtraBold", Enum.Font.GothamBlack),
        SizeOffset = 0,
    },
    ["Gotham"] = {
        Regular = Enum.Font.Gotham,
        Medium  = Enum.Font.GothamMedium,
        Bold    = Enum.Font.GothamBold,
        Black   = Enum.Font.GothamBlack,
        SizeOffset = 0,
    },
}
MeizuLibrary.FontOrder = {"Source Sans", "Builder Sans", "Gotham"}

local function CurrentPreset()
    return MeizuLibrary.FontPresets[MeizuLibrary.FontName] or MeizuLibrary.FontPresets[DEFAULT_FONT]
end

local function SetFontEntry(e)
    local preset = CurrentPreset()
    e.Object.Font = preset[e.Weight] or preset.Regular
    e.Object.TextSize = e.Size + preset.SizeOffset
end

-- Đăng ký 1 object chữ để đổi phông trực tiếp (weight: Regular | Medium | Bold | Black)
local fontRegCount = 0
local function Fonted(obj, weight, size)
    local e = {Object = obj, Weight = weight or "Regular", Size = size or 13}
    SetFontEntry(e)
    table.insert(MeizuLibrary._FontObjs, e)
    fontRegCount = fontRegCount + 1
    if fontRegCount % 200 == 0 then PruneList(MeizuLibrary._FontObjs) end
    return obj
end

local function TextObj(class, props, weight, size)
    return Fonted(New(class, props), weight, size)
end

-- Đo chiều cao (và rộng) chữ khi wrap — thay cho AutomaticSize (lỗi trên Android).
-- Thứ tự thử: GetTextSize -> GetTextBoundsAsync (API mới) -> ước lượng (để chữ nhiều dòng không bị cắt).
local function MeasureText(text, weight, size, width)
    local preset = CurrentPreset()
    local font = preset[weight] or preset.Regular
    local realSize = size + preset.SizeOffset
    local plain = StripRich(text)
    width = math.max(width or 100, 10)

    local ok, res = pcall(function()
        return TextService:GetTextSize(plain, realSize, font, Vector2.new(width, 10000))
    end)
    if not (ok and res) then
        ok, res = pcall(function()
            local params = Instance.new("GetTextBoundsParams")
            params.Text = plain
            params.Font = Font.fromEnum(font)
            params.Size = realSize
            params.Width = width
            return TextService:GetTextBoundsAsync(params)
        end)
    end
    if ok and res then
        return math.max(math.ceil(res.Y), realSize), math.ceil(res.X)
    end

    local perLine = math.max(math.floor(width / (realSize * 0.52)), 1)
    local lines, chars = 0, 0
    for seg in (plain .. "\n"):gmatch("(.-)\n") do
        local n = (HAS_UTF8 and utf8.len(seg)) or #seg
        chars = chars + n
        lines = lines + math.max(1, math.ceil(n / perLine))
    end
    return math.ceil(lines * realSize * 1.2), math.ceil(math.min(chars * realSize * 0.52, width))
end

--// ====================== LANGUAGE SYSTEM ======================
MeizuLibrary.Languages     = {vi = "Tiếng Việt", en = "English"}
MeizuLibrary.LanguageOrder = {"vi", "en"}

-- Đoạn giới thiệu trong tab Cài đặt (dùng chung 1 hằng để key không bao giờ bị lệch)
local ABOUT_KEY = "Modern UI Library — Design by NTTP1721.\nThank you for using it!"

-- Key = chữ tiếng Anh. Hub có thể thêm riêng bằng Library:AddTranslation(key, {vi=..., en=...})
MeizuLibrary.LanguageMap = {
    ["Settings"]            = {vi = "Cài đặt",                  en = "Settings"},
    ["Appearance"]          = {vi = "Giao diện",                en = "Appearance"},
    ["General"]             = {vi = "Chung",                    en = "General"},
    ["Configuration"]       = {vi = "Cấu hình",                 en = "Configuration"},
    ["Theme"]               = {vi = "Chủ đề",                   en = "Theme"},
    ["Accent Color"]        = {vi = "Màu nhấn",                 en = "Accent Color"},
    ["Rainbow Accent"]      = {vi = "Màu nhấn cầu vồng",        en = "Rainbow Accent"},
    ["Font"]                = {vi = "Phông chữ",                en = "Font"},
    ["UI Scale"]            = {vi = "Kích thước giao diện",     en = "UI Scale"},
    ["Sound Effects"]       = {vi = "Âm thanh",                 en = "Sound Effects"},
    ["Toggle UI Keybind"]   = {vi = "Phím bật/tắt UI",          en = "Toggle UI Keybind"},
    ["Language"]            = {vi = "Ngôn ngữ",                 en = "Language"},
    ["Reset Appearance"]    = {vi = "Đặt lại giao diện",        en = "Reset Appearance"},
    ["Restore theme, accent, font and scale to default"] = {
        vi = "Khôi phục chủ đề, màu nhấn, phông chữ và kích thước mặc định",
        en = "Restore theme, accent, font and scale to default"},
    ["Appearance has been reset."] = {vi = "Đã đặt lại giao diện.", en = "Appearance has been reset."},
    ["Config Name"]         = {vi = "Tên cấu hình",             en = "Config Name"},
    ["Saved Configs"]       = {vi = "Cấu hình đã lưu",          en = "Saved Configs"},
    ["Save Config"]         = {vi = "Lưu cấu hình",             en = "Save Config"},
    ["Load Config"]         = {vi = "Tải cấu hình",             en = "Load Config"},
    ["Unload Library"]      = {vi = "Gỡ giao diện",             en = "Unload Library"},
    ["Remove the whole UI from the game"] = {vi = "Xóa toàn bộ giao diện khỏi game", en = "Remove the whole UI from the game"},
    ["Search..."]           = {vi = "Tìm kiếm...",              en = "Search..."},
    ["No results"]          = {vi = "Không có kết quả",         en = "No results"},
    ["Select..."]           = {vi = "Chọn...",                  en = "Select..."},
    ["%d selected"]         = {vi = "Đã chọn %d",               en = "%d selected"},
    ["None"]                = {vi = "Chưa gán",                 en = "None"},
    ["Type here..."]        = {vi = "Nhập tại đây...",          en = "Type here..."},
    ["Notification"]        = {vi = "Thông báo",                en = "Notification"},
    ["Config"]              = {vi = "Cấu hình",                 en = "Config"},
    ["Close UI"]            = {vi = "Đóng giao diện",           en = "Close UI"},
    ["Do you want to close the UI completely?"] = {
        vi = "Bạn có muốn tắt hoàn toàn giao diện không?",
        en = "Do you want to close the UI completely?"},
    ["Cancel"]              = {vi = "Hủy",                      en = "Cancel"},
    ["Close"]               = {vi = "Đóng",                     en = "Close"},
    ["Unload"]              = {vi = "Gỡ",                       en = "Unload"},
    ["Are you sure you want to unload the UI?"] = {
        vi = "Bạn có chắc muốn gỡ giao diện không?",
        en = "Are you sure you want to unload the UI?"},
    ["OK"]                  = {vi = "Đồng ý",                   en = "OK"},
    ["Dialog"]              = {vi = "Hộp thoại",                en = "Dialog"},
    ["Config saved: %s"]    = {vi = "Đã lưu cấu hình '%s'!",    en = "Config saved: '%s'!"},
    ["Config loaded: %s"]   = {vi = "Đã tải cấu hình '%s'!",    en = "Config loaded: '%s'!"},
    ["Config not found!"]   = {vi = "Không tìm thấy cấu hình!", en = "Config not found!"},
    ["Could not save the config."] = {vi = "Không thể lưu cấu hình!", en = "Could not save the config."},
    -- v3.1
    ["Glass Window"]        = {vi = "Cửa sổ kính mờ",           en = "Glass Window"},
    ["Slightly transparent window surfaces"] = {vi = "Nền cửa sổ trong suốt nhẹ, nhìn xuyên được game", en = "Slightly transparent window surfaces"},
    ["Background Blur"]     = {vi = "Làm mờ nền game",          en = "Background Blur"},
    ["Blur the game behind the UI while it is open"] = {vi = "Làm mờ cảnh game phía sau khi UI đang mở", en = "Blur the game behind the UI while it is open"},
    ["Blur Strength"]       = {vi = "Độ mờ nền",                en = "Blur Strength"},
    ["Performance Mode"]    = {vi = "Chế độ tiết kiệm",         en = "Performance Mode"},
    ["Reduce effects to boost FPS"] = {vi = "Giảm hiệu ứng để tăng FPS", en = "Reduce effects to boost FPS"},
    ["Watermark (FPS / Ping)"] = {vi = "Hiện FPS / Ping",       en = "Watermark (FPS / Ping)"},
    ["Floating glass bar with FPS, ping and clock"] = {vi = "Thanh kính nổi hiện FPS, ping và giờ", en = "Floating glass bar with FPS, ping and clock"},
    ["Auto Save"]           = {vi = "Tự động lưu",              en = "Auto Save"},
    ["Save every change automatically"] = {vi = "Tự động lưu mọi thay đổi của tính năng", en = "Save every change automatically"},
    ["Auto Load"]           = {vi = "Tự động tải",              en = "Auto Load"},
    ["Restore the last saved settings when the UI opens"] = {vi = "Khôi phục cài đặt đã lưu mỗi khi mở UI", en = "Restore the last saved settings when the UI opens"},
    ["Reset Window"]        = {vi = "Đặt lại cửa sổ",           en = "Reset Window"},
    ["Restore the default size and position"] = {vi = "Trả kích thước và vị trí về mặc định", en = "Restore the default size and position"},
    ["Window"]              = {vi = "Cửa sổ",                   en = "Window"},
    ["Auto-loaded the last saved settings."] = {vi = "Đã tự động tải cài đặt lần trước.", en = "Auto-loaded the last saved settings."},
    ["Your executor does not support file saving (writefile)."] = {
        vi = "Executor không hỗ trợ lưu file (writefile)!",
        en = "Your executor does not support file saving (writefile)."},
    [ABOUT_KEY] = {
        vi = "Modern UI Library — Thiết kế bởi NTTP1721.\nCảm ơn bạn đã sử dụng!",
        en = "Modern UI Library — Design by NTTP1721.\nThank you for using it!"},
}

function MeizuLibrary:_Translate(key)
    if type(key) ~= "string" then return key end
    local row = self.LanguageMap[key]
    if type(row) == "table" then
        return row[self.Language] or row.en or key
    end
    return key
end

local function L(key)
    return MeizuLibrary:_Translate(key)
end

local function SetBindingText(b)
    local text = L(b.Key)
    if b.Format then text = b.Format(text) end
    b.Object[b.Prop] = text
end

-- Gắn 1 thuộc tính chữ vào hệ thống ngôn ngữ: đổi ngôn ngữ là tự cập nhật.
-- Trả về binding; đổi binding.Key rồi gọi RefreshBinding để đổi nội dung.
local function BindLoc(obj, prop, key, format)
    local b = {Object = obj, Prop = prop, Key = key, Format = format}
    SetBindingText(b)
    table.insert(MeizuLibrary._LocBindings, b)
    return b
end

local function RefreshBinding(b)
    if b and b.Object and b.Object.Parent ~= nil then
        pcall(SetBindingText, b)
    end
end

function MeizuLibrary:_ApplyLocalization()
    local list = self._LocBindings
    PruneList(list)
    for i = 1, #list do
        pcall(SetBindingText, list[i])
    end
    -- tương thích bản cũ: object gắn Attribute "MeizuLocKey" / "MeizuLocDesc"
    if self._ScreenGui then
        for _, obj in ipairs(self._ScreenGui:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                local key = obj:GetAttribute("MeizuLocKey") or obj:GetAttribute("MeizuLocDesc")
                if key then
                    pcall(function() obj.Text = self:_Translate(key) end)
                end
            end
        end
    end
    for _, fn in ipairs(self._LangHooks) do
        pcall(fn)
    end
end

function MeizuLibrary:SetLanguage(lang)
    lang = tostring(lang or "vi")
    for code, name in pairs(self.Languages) do      -- chấp nhận cả tên hiển thị
        if lang == name then lang = code end
    end
    lang = lang:lower()
    if not self.Languages[lang] then lang = "vi" end
    self.Language = lang
    self.Flags["__language"] = lang
    self:_ApplyLocalization()
    self:_SaveUiPrefs()
    if self._SyncSettings then self._SyncSettings() end
end

-- Library:AddTranslation("Auto Farm", {vi = "Tự động farm", en = "Auto Farm"})
function MeizuLibrary:AddTranslation(key, row)
    if type(key) ~= "string" or type(row) ~= "table" then return end
    self.LanguageMap[key] = row
    if not self._LocDirty then
        self._LocDirty = true
        task.defer(function()
            self._LocDirty = false
            if not self.Destroyed then self:_ApplyLocalization() end
        end)
    end
end

function MeizuLibrary:AddTranslations(map)
    if type(map) ~= "table" then return end
    for key, row in pairs(map) do self:AddTranslation(key, row) end
end

-- Chuỗi tìm kiếm của 1 element: chữ gốc + bản dịch vi/en (để gõ ngôn ngữ nào cũng ra)
local function SearchText(...)
    local parts = {}
    for _, s in ipairs({...}) do
        if s ~= nil then
            s = tostring(s)
            table.insert(parts, s)
            local row = MeizuLibrary.LanguageMap[s]
            if type(row) == "table" then
                if row.vi then table.insert(parts, row.vi) end
                if row.en then table.insert(parts, row.en) end
            end
        end
    end
    return NormalizeSearch(table.concat(parts, " "))
end

--// ============================ THEME / ACCENT REGISTRY ============================
local registerCount = 0

-- Gắn thuộc tính màu của object vào theme. Trả về entry (đặt entry.Map = {} để ngừng đồng bộ)
local function Register(obj, map)
    local theme = MeizuLibrary.Themes[MeizuLibrary.Theme]
    if theme then
        for prop, key in pairs(map) do
            if theme[key] then obj[prop] = theme[key] end
        end
    end
    local entry = {Object = obj, Map = map}
    table.insert(MeizuLibrary._ThemeObjs, entry)
    registerCount = registerCount + 1
    if registerCount % 150 == 0 then
        PruneList(MeizuLibrary._ThemeObjs)
        PruneList(MeizuLibrary._AccentObjs)
        PruneList(MeizuLibrary._SurfaceObjs)
    end
    return entry
end

local function RegisterAccent(obj, prop, mult)
    mult = mult or 1
    obj[prop] = Shade(MeizuLibrary.Accent, mult)
    local entry = {Object = obj, Prop = prop, Mult = mult}
    table.insert(MeizuLibrary._AccentObjs, entry)
    return entry
end

local function OnThemeChange(fn)  table.insert(MeizuLibrary._ThemeHooks, fn)  end
local function OnAccentChange(fn) table.insert(MeizuLibrary._AccentHooks, fn) end
local function OnLangChange(fn)   table.insert(MeizuLibrary._LangHooks, fn)   end
local function OnFontChange(fn)   table.insert(MeizuLibrary._FontHooks, fn)   end
local function OnPerfChange(fn)   table.insert(MeizuLibrary._PerfHooks, fn)   end

-- "Bề mặt" (nền Main / Sidebar / Header / thẻ...) có thể trong suốt thêm khi bật "Cửa sổ kính mờ".
-- Chỉ đăng ký những object KHÔNG tự chạy hoạt ảnh BackgroundTransparency.
local function ApplySurface(e)
    local base = e.Base
    e.Object.BackgroundTransparency = MeizuLibrary.GlassWindow and math.min(1, base + GLASS_SURFACE_ALPHA) or base
end

local function RegisterSurface(obj)
    local e = {Object = obj, Base = obj.BackgroundTransparency}
    table.insert(MeizuLibrary._SurfaceObjs, e)
    if MeizuLibrary.GlassWindow then ApplySurface(e) end
    return e
end

--// ============================ MISC HELPERS ============================
local function SafeCall(fn, ...)
    if type(fn) ~= "function" then return end
    local args = table.pack(...)
    task.spawn(function()
        local ok, err = pcall(fn, table.unpack(args, 1, args.n))
        if not ok then warn("[MeizuLibrary] Callback error: " .. tostring(err)) end
    end)
end

local function PlaySound(id, volume, speed)
    if not MeizuLibrary.SoundEnabled then return end
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = id or "rbxasset://sounds/electronicpingshort.wav"
        s.Volume = volume or 0.3
        s.PlaybackSpeed = speed or 1
        s.Parent = SoundService
        s:Play()
        task.delay(3, function() if s then s:Destroy() end end)
    end)
end

-- Tổng tỉ lệ UIScale của cửa sổ (để đổi toạ độ màn hình -> toạ độ cục bộ)
local function GuiScale()
    local s = 1
    if MeizuLibrary._RootScale and MeizuLibrary._RootScale.Parent then s = s * MeizuLibrary._RootScale.Scale end
    if MeizuLibrary._PopScale and MeizuLibrary._PopScale.Parent then s = s * MeizuLibrary._PopScale.Scale end
    if s <= 0 then s = 1 end
    return s
end

local function IsPointer(input)
    local t = input.UserInputType
    return t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch
end

-- Toạ độ con trỏ cùng hệ với AbsolutePosition (ScreenGui IgnoreGuiInset = true).
-- Chuột dùng GetMouseLocation để không bị lệch ~36px do thanh topbar của Roblox.
local function PointerPos(input)
    if input.UserInputType ~= Enum.UserInputType.Touch then
        local ok, loc = pcall(function() return UserInputService:GetMouseLocation() end)
        if ok and loc then return loc end
    end
    return Vector2.new(input.Position.X, input.Position.Y)
end

local function Ripple(parent, x, y)
    if not parent or not parent.Parent then return end
    local size = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.4 / GuiScale()
    local circle = New("Frame", {
        Name = "Ripple",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, x, 0, y),
        Size = UDim2.fromOffset(0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.82,
        BorderSizePixel = 0,
        ZIndex = 50,
        Parent = parent,
    })
    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = circle})
    Tween(circle, 0.55, {Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1}, Enum.EasingStyle.Quad)
    task.delay(0.6, function() if circle then circle:Destroy() end end)
end

-- Vẽ dấu X bằng 2 thanh xoay (không phụ thuộc phông chữ)
local function DrawCross(parent, len, thick, themeKey, z)
    local bars = {}
    for _, rot in ipairs({45, -45}) do
        local bar = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(len, thick),
            Rotation = rot,
            BackgroundColor3 = T(themeKey or "SubText"),
            BorderSizePixel = 0,
            ZIndex = z or 2,
            Parent = parent,
        })
        Register(bar, {BackgroundColor3 = themeKey or "SubText"})
        table.insert(bars, bar)
    end
    return bars
end

--// ==================== DRAG PIPELINE (chuột + đa điểm chạm) ====================
local function FindScrollAncestor(obj)
    local p = obj and obj.Parent
    while p and p ~= game do
        if p:IsA("ScrollingFrame") then return p end
        p = p.Parent
    end
    return nil
end

-- Khoá cuộn của ScrollingFrame cha khi đang kéo slider / bảng màu (mobile)
local function BeginGuard(card)
    local sf = FindScrollAncestor(card)
    if not sf then return function() end end
    sf.ScrollingEnabled = false
    return function()
        if sf and sf.Parent then sf.ScrollingEnabled = true end
    end
end

local function SessionEnds(d, input)
    local own = d.Input
    if own == nil then return true end
    if own.UserInputType == Enum.UserInputType.Touch then
        return input == own or input.UserInputType == Enum.UserInputType.Touch and MeizuLibrary._SingleTouch
    end
    return input.UserInputType == Enum.UserInputType.MouseButton1
end

local function EnsureDragPipeline()
    if MeizuLibrary._DragPipelineInit then return end
    MeizuLibrary._DragPipelineInit = true

    table.insert(MeizuLibrary._Connections, UserInputService.InputChanged:Connect(function(input)
        local t = input.UserInputType
        if t ~= Enum.UserInputType.MouseMovement and t ~= Enum.UserInputType.Touch then return end
        local drags = MeizuLibrary._ActiveDrags
        for i = 1, #drags do
            local d = drags[i]
            local own = d.Input
            if d.OnChanged then
                if own and own.UserInputType == Enum.UserInputType.Touch then
                    if t == Enum.UserInputType.Touch and (input == own or #drags == 1) then
                        pcall(d.OnChanged, input)
                    end
                elseif t == Enum.UserInputType.MouseMovement then
                    pcall(d.OnChanged, input)
                end
            end
        end
    end))

    table.insert(MeizuLibrary._Connections, UserInputService.InputEnded:Connect(function(input)
        local t = input.UserInputType
        if t ~= Enum.UserInputType.MouseButton1 and t ~= Enum.UserInputType.Touch then return end
        local drags = MeizuLibrary._ActiveDrags
        MeizuLibrary._SingleTouch = (#drags == 1)
        local keep, ended = {}, {}
        for _, d in ipairs(drags) do
            if SessionEnds(d, input) then table.insert(ended, d) else table.insert(keep, d) end
        end
        MeizuLibrary._SingleTouch = false
        MeizuLibrary._ActiveDrags = keep
        for _, d in ipairs(ended) do
            if d.OnEnd then pcall(d.OnEnd, input) end
        end
    end))
end

-- Bắt đầu 1 phiên kéo: handlers = {OnChanged = fn(input), OnEnd = fn(input)}
local function AddDrag(input, handlers)
    EnsureDragPipeline()
    handlers.Input = input
    table.insert(MeizuLibrary._ActiveDrags, handlers)
    return handlers
end

-- Kéo cả cửa sổ bằng 1 vùng handle. clampFn(UDim2) -> UDim2 để giữ cửa sổ trong màn hình.
local function MakeDraggable(handle, target, clampFn, onEnd)
    handle.InputBegan:Connect(function(input)
        if not IsPointer(input) then return end
        local startPointer = PointerPos(input)
        local startPos = target.Position
        AddDrag(input, {
            OnChanged = function(inp)
                local d = PointerPos(inp) - startPointer
                local pos = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y)
                if clampFn then pos = clampFn(pos) end
                target.Position = pos
            end,
            OnEnd = function()
                if onEnd then onEnd() end
            end,
        })
    end)
end

--// ==================== RESOLVE IMAGE (ID hoặc URL .png/.jpg) ====================
local function ResolveImageAsset(id)
    if type(id) == "number" then return "rbxassetid://" .. tostring(id) end
    if type(id) ~= "string" then return nil end
    id = Trim(id)
    if id == "" then return nil end
    if tonumber(id) then return "rbxassetid://" .. id end
    if id:sub(1, 8) == "rbxasset" or id:find("roblox.com/asset", 1, true) then return id end
    if id:sub(1, 4) == "http" then
        local getAsset = GetCustomAssetFn()
        if not (HasFileSystem() and getAsset) then return nil end
        local ext = (id:lower():match("%.jpe?g$") and ".jpg") or ".png"
        local path = MeizuLibrary.Folder .. "/img_" .. HashString(id) .. ext
        local okExists, exists = pcall(function() return type(isfile) == "function" and isfile(path) end)
        if not (okExists and exists) then
            local okGet, content = pcall(function() return game:HttpGet(id, true) end)
            if not okGet or type(content) ~= "string" or #content < 16 then return nil end
            local okW = pcall(function()
                EnsureFolder()
                writefile(path, content)
            end)
            if not okW then return nil end
        end
        local okA, asset = pcall(getAsset, path)
        if okA and asset then return asset end
        return nil
    end
    return nil
end

-- Icon của tab: số | "10734950309" | "rbxassetid://..." | tên trong Library.Icons
local function ResolveIcon(icon)
    if icon == nil or icon == false then return nil end
    if type(icon) == "string" then
        local key = Trim(icon)
        local mapped = MeizuLibrary.Icons[key] or MeizuLibrary.Icons[key:lower()]
        if mapped then icon = mapped end
    end
    if type(icon) == "number" then return "rbxassetid://" .. tostring(icon) end
    if type(icon) == "string" then
        icon = Trim(icon)
        if icon == "" then return nil end
        if tonumber(icon) then return "rbxassetid://" .. icon end
        if icon:sub(1, 8) == "rbxasset" or icon:find("roblox.com/asset", 1, true) then return icon end
    end
    return nil
end

--// ============================ SCREEN GUI ============================
local function CreateScreenGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "MeizuLibrary_" .. tostring(math.random(100000, 999999))
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    pcall(function() gui.ScreenInsets = Enum.ScreenInsets.None end)
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 9999

    local parented = false
    pcall(function()
        if type(syn) == "table" and type(syn.protect_gui) == "function" then syn.protect_gui(gui) end
        local parent = (type(gethui) == "function" and gethui()) or game:GetService("CoreGui")
        gui.Parent = parent
        parented = (gui.Parent ~= nil)
    end)
    if not parented then
        gui.Name = "MeizuLibrary"
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    return gui
end

--// ============================ NOTIFICATIONS ============================
local NOTIF_WIDTH = 300
local NOTIF_MAX   = 5
local NOTIF_KIND_COLORS = {
    success = Color3.fromRGB(80, 200, 120),
    warning = Color3.fromRGB(255, 184, 77),
    error   = Color3.fromRGB(255, 95, 95),
}

-- Gọi được cả Library:Notify{...}, Library.Notify{...}, Library:Notify("nội dung", 4)
MeizuLibrary.Notify = function(a, b, c)
    local cfg, dur
    if a == MeizuLibrary then cfg, dur = b, c else cfg, dur = a, b end
    if type(cfg) == "string" then cfg = {Content = cfg, Duration = tonumber(dur)} end
    if type(cfg) ~= "table" then cfg = {} end

    local ScreenGui = MeizuLibrary._ScreenGui
    if not ScreenGui or MeizuLibrary.Destroyed then return end

    local holder = MeizuLibrary._NotifHolder
    if not holder or not holder.Parent then
        holder = New("Frame", {
            Name = "Notifications",
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -16, 0, 16),
            Size = UDim2.new(0, NOTIF_WIDTH + 20, 1, -32),
            ZIndex = 200,
            Parent = ScreenGui,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            Parent = holder,
        })
        MeizuLibrary._NotifHolder = holder
    end

    MeizuLibrary._NotifCount = MeizuLibrary._NotifCount + 1

    -- Kích thước tính thủ công (không dùng AutomaticSize — lỗi trên Android)
    local PAD_T, PAD_B, PAD_L, PAD_R = 12, 14, 20, 12
    local preset = CurrentPreset()
    local titleH = 13 + preset.SizeOffset + 6
    local textW = NOTIF_WIDTH - PAD_L - PAD_R
    local contentText = (cfg.Content ~= nil) and L(tostring(cfg.Content)) or nil
    local contentH = 0
    if contentText and contentText ~= "" then
        contentH = math.min(MeasureText(contentText, "Regular", 12, textW) + 2, 110)
    end
    local cardH = PAD_T + titleH + ((contentH > 0) and (4 + contentH) or 0) + PAD_B + 3

    local kind = tostring(cfg.Type or cfg.Kind or "info"):lower()
    local kindColor = NOTIF_KIND_COLORS[kind]

    local Card = New("CanvasGroup", {
        Name = "Notification",
        BackgroundColor3 = T("Notification"),
        Size = UDim2.fromOffset(NOTIF_WIDTH, cardH),
        GroupTransparency = 1,
        ClipsDescendants = true,
        LayoutOrder = -MeizuLibrary._NotifCount,
        BorderSizePixel = 0,
        ZIndex = 200,
        Parent = holder,
    })
    Register(Card, {BackgroundColor3 = "Notification"})
    New("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Card})
    local CardStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.35, Parent = Card})
    Register(CardStroke, {Color = "Stroke"})

    local Bar = New("Frame", {
        BackgroundColor3 = kindColor or MeizuLibrary.Accent,
        Position = UDim2.new(0, 10, 0, PAD_T),
        Size = UDim2.new(0, 3, 0, cardH - PAD_T - PAD_B),
        BorderSizePixel = 0, ZIndex = 201, Parent = Card,
    })
    if not kindColor then RegisterAccent(Bar, "BackgroundColor3") end
    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Bar})

    local NTitle = TextObj("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, PAD_L, 0, PAD_T),
        Size = UDim2.new(1, -(PAD_L + PAD_R + 24), 0, titleH),
        TextColor3 = T("Text"),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Text = L(tostring(cfg.Title or "Notification")),
        ZIndex = 201, Parent = Card,
    }, "Bold", 13)
    Register(NTitle, {TextColor3 = "Text"})

    local NClose = New("TextButton", {
        Text = "", AutoButtonColor = false, BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -8, 0, PAD_T - 2),
        Size = UDim2.fromOffset(22, 22),
        ZIndex = 202, Parent = Card,
    })
    local CloseBars = DrawCross(NClose, 9, 1.5, "SubText", 203)
    NClose.MouseEnter:Connect(function()
        for _, bar in ipairs(CloseBars) do Tween(bar, 0.15, {BackgroundColor3 = T("Text")}) end
    end)
    NClose.MouseLeave:Connect(function()
        for _, bar in ipairs(CloseBars) do Tween(bar, 0.2, {BackgroundColor3 = T("SubText")}) end
    end)

    if contentH > 0 then
        local NContent = TextObj("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, PAD_L, 0, PAD_T + titleH + 4),
            Size = UDim2.new(1, -(PAD_L + PAD_R), 0, contentH),
            TextColor3 = T("SubText"),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true, RichText = true,
            Text = contentText, ZIndex = 201, Parent = Card,
        }, "Regular", 12)
        Register(NContent, {TextColor3 = "SubText"})
    end

    local ProgTrack = New("Frame", {
        BackgroundColor3 = T("Track"), BackgroundTransparency = 0.5,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 3),
        BorderSizePixel = 0, ZIndex = 200, Parent = Card,
    })
    Register(ProgTrack, {BackgroundColor3 = "Track"})
    local ProgFill = New("Frame", {
        BackgroundColor3 = kindColor or MeizuLibrary.Accent,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 3),
        BorderSizePixel = 0, ZIndex = 201, Parent = Card,
    })
    if not kindColor then RegisterAccent(ProgFill, "BackgroundColor3") end

    local scale = New("UIScale", {Scale = 0.85, Parent = Card})
    local closed = false
    local entry = {}
    local function Close()
        if closed then return end
        closed = true
        for i, e in ipairs(MeizuLibrary._Notifs) do
            if e == entry then table.remove(MeizuLibrary._Notifs, i) break end
        end
        Tween(Card, 0.2, {GroupTransparency = 1})
        Tween(scale, 0.2, {Scale = 0.88})
        task.delay(0.24, function() if Card then Card:Destroy() end end)
    end
    entry.Close = Close
    NClose.Activated:Connect(Close)

    table.insert(MeizuLibrary._Notifs, entry)
    while #MeizuLibrary._Notifs > NOTIF_MAX do
        MeizuLibrary._Notifs[1].Close()
    end

    Tween(Card, 0.25, {GroupTransparency = 0})
    Tween(scale, 0.35, {Scale = 1}, Enum.EasingStyle.Back)
    PlaySound("rbxasset://sounds/electronicpingshort.wav", 0.25, 1.15)
    if MeizuLibrary._OnNotify then pcall(MeizuLibrary._OnNotify) end      -- huy hiệu "chưa đọc" trên nút nổi

    local duration = tonumber(cfg.Duration) or 5
    if duration > 0 then
        Tween(ProgFill, duration, {Size = UDim2.new(0, 0, 0, 3)}, Enum.EasingStyle.Linear)
        task.delay(duration, Close)
    end
    return {Close = Close}
end

--// ============================ SERIALIZE ============================
local function Serialize(v)
    if typeof(v) == "Color3" then
        return {__color = true, R = v.R, G = v.G, B = v.B}
    end
    return v
end

local function Deserialize(v)
    if type(v) == "table" and v.__color then
        return Color3.new(v.R, v.G, v.B)
    end
    return v
end

--// ============================ FLAGS + CẤU HÌNH TỰ ĐỘNG ============================
-- Mọi element ghi giá trị vào Flags qua SetFlag để "Auto Save" biết khi nào có thay đổi.
--
-- Thiết kế chống mất dữ liệu:
--   * Dữ liệu đã lưu (_AutoData) được đọc 1 lần lúc tạo cửa sổ và áp NGAY khi từng element được tạo
--     (giao diện hiện đúng giá trị cũ, không nhấp nháy về mặc định).
--   * Callback chỉ được kích hoạt sau khi hub dựng xong UI (không có element mới trong ~1.2s) -> tính năng
--     mới chạy; Auto Save chỉ "lên đạn" (_AutoArmed) sau bước này, nên giá trị mặc định lúc dựng UI không
--     bao giờ ghi đè dữ liệu đã lưu.
--   * Khi lưu, dữ liệu mới được GỘP vào dữ liệu cũ nên cờ của element chưa kịp tạo không bị rơi mất.
local function SetFlag(flag, value)
    MeizuLibrary.Flags[flag] = value
    if MeizuLibrary.AutoSave and not MeizuLibrary._Loading then
        if MeizuLibrary._AutoArmed then
            MeizuLibrary:_QueueAutoSave()
        else
            MeizuLibrary._AutoDirty = true
        end
    end
end

function MeizuLibrary:_QueueAutoSave()
    if self._AutoSavePending or self.Destroyed then return end
    self._AutoSavePending = true
    task.delay(1.5, function()
        self._AutoSavePending = false
        if not self.Destroyed and self.AutoSave then self:SaveAutoConfig() end
    end)
end

function MeizuLibrary:SaveAutoConfig()
    if not HasFileSystem() then return false end
    local data = {}
    if self._AutoData then
        for k, v in pairs(self._AutoData) do data[k] = v end
    end
    for flag, el in pairs(self._FlagElems) do
        local ok, v = pcall(el.Get)
        if ok and type(v) ~= "function" then data[flag] = Serialize(v) end
    end
    self._AutoData = data
    local okW = pcall(function()
        EnsureFolder()
        writefile(self.Folder .. "/" .. AUTO_CONFIG_NAME .. ".json", HttpService:JSONEncode(data))
    end)
    return okW
end

function MeizuLibrary:LoadAutoConfig(silent) return self:LoadSettings(AUTO_CONFIG_NAME, silent) end

-- Đọc dữ liệu đã lưu vào bộ nhớ (gọi lúc tạo cửa sổ khi Auto Load / Auto Save đang bật)
function MeizuLibrary:_LoadAutoData()
    self._AutoData, self._AutoPending, self._AutoArmed, self._AutoDirty = nil, {}, false, false
    if not (self.AutoLoad or self.AutoSave) or not HasFileSystem() then return end
    local okR, content = pcall(readfile, self.Folder .. "/" .. AUTO_CONFIG_NAME .. ".json")
    if not okR or type(content) ~= "string" then return end
    local okD, data = pcall(function() return HttpService:JSONDecode(content) end)
    if okD and type(data) == "table" then self._AutoData = data end
end

-- Gọi từ BindFlag mỗi khi 1 element có Flag được tạo
function MeizuLibrary:_ApplyAutoValue(flag, el)
    if not self.AutoLoad or not self._AutoData then return end
    local v = self._AutoData[flag]
    if v == nil then return end
    self._Loading = true
    pcall(el.Set, Deserialize(v), false)            -- hiện đúng giá trị đã lưu ngay lập tức, chưa kích hoạt tính năng
    self._Loading = false
    if self._AutoArmed then
        -- element tạo muộn (sau khi hub dựng xong): kích hoạt callback ngay sau khi đoạn code tạo nó chạy xong
        task.defer(function()
            if self.Destroyed then return end
            self._Loading = true
            pcall(el.Set, Deserialize(v), true)
            self._Loading = false
        end)
    else
        self._AutoPending[flag] = {El = el, Value = v}
    end
end

function MeizuLibrary:SetAutoSave(on)
    self.AutoSave = (on == true)
    if self.AutoSave then
        self._AutoArmed = true                       -- người dùng chủ động bật -> lưu luôn
        self:_QueueAutoSave()
    end
    self:_SaveUiPrefs()
    if self._SyncSettings then self._SyncSettings() end
end

function MeizuLibrary:SetAutoLoad(on)
    self.AutoLoad = (on == true)
    self:_SaveUiPrefs()
    if self._SyncSettings then self._SyncSettings() end
end

--// ============================ LIBRARY API ============================
local function ApplyThemeEntry(e, theme)
    for prop, key in pairs(e.Map) do
        if theme[key] then e.Object[prop] = theme[key] end
    end
end

function MeizuLibrary:ApplyTheme(name)
    local theme = self.Themes[name]
    if not theme then return end
    self.Theme = name
    local list = self._ThemeObjs
    PruneList(list)
    for i = 1, #list do
        pcall(ApplyThemeEntry, list[i], theme)
    end
    for _, fn in ipairs(self._ThemeHooks) do pcall(fn) end
    self:_SaveUiPrefs()
    if self._SyncSettings then self._SyncSettings() end
end

function MeizuLibrary:ApplyAccent(color)
    if typeof(color) ~= "Color3" then return end
    self.Accent = color
    local list = self._AccentObjs
    local n, j = #list, 0
    for i = 1, n do
        local e = list[i]
        local o = e.Object
        if o and o.Parent ~= nil then
            j = j + 1
            list[j] = e
            o[e.Prop] = Shade(color, e.Mult)
        end
    end
    for i = n, j + 1, -1 do list[i] = nil end
    for _, fn in ipairs(self._AccentHooks) do pcall(fn, color) end
end

-- Chọn màu nhấn do người dùng (lưu lại cho lần sau)
function MeizuLibrary:SetAccent(color)
    if typeof(color) ~= "Color3" then return end
    self._UserAccent = color
    if not self._RainbowConn then self:ApplyAccent(color) end
    self:_SaveUiPrefs()
end

function MeizuLibrary:SetRainbow(enabled)
    if enabled then
        if self._RainbowConn then return end
        local hue, acc = 0, 0
        self._RainbowConn = RunService.Heartbeat:Connect(function(dt)
            acc = acc + dt
            if acc < (self.PerfMode and 0.12 or 0.033) then return end   -- ~30 lần/giây (tiết kiệm: ~8)
            hue = (hue + acc * 0.35) % 1
            acc = 0
            self:ApplyAccent(Color3.fromHSV(hue, 0.65, 1))
        end)
    else
        if not self._RainbowConn then return end
        self._RainbowConn:Disconnect()
        self._RainbowConn = nil
        self:ApplyAccent(self._UserAccent or Color3.fromRGB(88, 101, 242))
    end
    if self._SyncSettings then self._SyncSettings() end
end

function MeizuLibrary:SetFont(name)
    if not self.FontPresets[name] then return false end
    self.FontName = name
    local list = self._FontObjs
    PruneList(list)
    for i = 1, #list do pcall(SetFontEntry, list[i]) end
    for _, fn in ipairs(self._FontHooks) do pcall(fn) end
    self:_SaveUiPrefs()
    if self._SyncSettings then self._SyncSettings() end
    return true
end

function MeizuLibrary:SetSound(enabled)
    self.SoundEnabled = (enabled == true)
    self:_SaveUiPrefs()
    if self._SyncSettings then self._SyncSettings() end
end

function MeizuLibrary:SetToggleKeybind(key)
    if typeof(key) == "EnumItem" then
        self.ToggleKeybind = key
        self:_SaveUiPrefs()
    end
end

function MeizuLibrary:SetPerformanceMode(on)
    self.PerfMode = (on == true)
    for _, fn in ipairs(self._PerfHooks) do pcall(fn, self.PerfMode) end
    self:_ApplyBlur()
    self:_SaveUiPrefs()
    if self._SyncSettings then self._SyncSettings() end
end

-- Cửa sổ kính mờ: nền các bề mặt trong suốt thêm một chút (nên bật cùng làm mờ nền game cho dễ đọc)
function MeizuLibrary:SetGlassWindow(on)
    self.GlassWindow = (on == true)
    local list = self._SurfaceObjs
    PruneList(list)
    for i = 1, #list do pcall(ApplySurface, list[i]) end
    self:_SaveUiPrefs()
    if self._SyncSettings then self._SyncSettings() end
end

-- Làm mờ cảnh game phía sau UI bằng BlurEffect (đặt dưới Camera, không đụng Lighting)
function MeizuLibrary:_ApplyBlur(instant)
    if self._Blur and not self._Blur.Parent then self._Blur = nil end      -- camera bị thay thế
    local want = self.BlurEnabled and self._WindowOpen and not self.PerfMode and not self.Destroyed
    local target = want and self.BlurSize or 0
    if not self._Blur then
        if target <= 0 then return end
        local ok, eff = pcall(function()
            local e = Instance.new("BlurEffect")
            e.Name = "MeizuBlur"
            e.Size = 0
            e.Parent = workspace.CurrentCamera or game:GetService("Lighting")
            return e
        end)
        if not ok then return end
        self._Blur = eff
    end
    Tween(self._Blur, instant and 0 or 0.35, {Size = target})
end

function MeizuLibrary:SetBlur(enabled, size)
    if enabled ~= nil then self.BlurEnabled = (enabled == true) end
    if size ~= nil then self.BlurSize = math.clamp(tonumber(size) or DEFAULT_BLUR_SIZE, 0, 40) end
    self:_ApplyBlur()
    self:_SaveUiPrefs()
    if self._SyncSettings then self._SyncSettings() end
end

function MeizuLibrary:SetWatermark(on)
    self.WatermarkOn = (on == true)
    if self._SetWatermarkImpl then self._SetWatermarkImpl(self.WatermarkOn) end
    self:_SaveUiPrefs()
    if self._SyncSettings then self._SyncSettings() end
end

function MeizuLibrary:_SetCollapsed(key, state)
    self.CollapsedSections[key] = (state == true)
    self:_SaveUiPrefs()
end

-- Đặt lại chủ đề / màu nhấn / phông / âm thanh / kính / blur / tiết kiệm về mặc định
-- (UI Cài đặt tự đồng bộ ở nơi gọi)
function MeizuLibrary:ResetAppearance()
    self:SetRainbow(false)
    self.UIScale = 1
    self.SoundEnabled = true
    self:ApplyTheme(self._BaseTheme or "Dark")
    local base = self._BaseAccent or Color3.fromRGB(88, 101, 242)
    self._UserAccent = base
    self:ApplyAccent(base)
    self:SetFont(DEFAULT_FONT)
    self:SetGlassWindow(false)
    self:SetBlur(false, DEFAULT_BLUR_SIZE)
    self:SetPerformanceMode(false)
    self:_SaveUiPrefs()
end

function MeizuLibrary:OnDestroy(fn)
    if type(fn) ~= "function" then return end
    self._DestroyHooks = self._DestroyHooks or {}
    table.insert(self._DestroyHooks, fn)
end

--// ---------------------- Ghi nhớ giao diện (ngôn ngữ, chủ đề, màu, phông...) ----------------------
local PREFS_FILE = "_ui.json"

function MeizuLibrary:_WriteUiPrefs()
    if not HasFileSystem() then return end
    local accent = self._UserAccent or self.Accent
    local data = {
        Language = self.Language,
        Theme    = self.Theme,
        Font     = self.FontName,
        Sound    = self.SoundEnabled,
        Scale    = self.UIScale,
        Accent   = {R = accent.R, G = accent.G, B = accent.B},
        Keybind  = self.ToggleKeybind and self.ToggleKeybind.Name or nil,
        Perf      = self.PerfMode,
        Glass     = self.GlassWindow,
        Blur      = self.BlurEnabled,
        BlurSize  = self.BlurSize,
        AutoSave  = self.AutoSave,
        AutoLoad  = self.AutoLoad,
        Watermark = self.WatermarkOn,
        Collapsed = self.CollapsedSections,
        Win       = self._SavedWin,
        Tab       = self._LastTabName,
    }
    pcall(function()
        EnsureFolder()
        writefile(self.Folder .. "/" .. PREFS_FILE, HttpService:JSONEncode(data))
    end)
end

function MeizuLibrary:_SaveUiPrefs()
    if not self.PersistUI or not HasFileSystem() or self.Destroyed then return end
    if self._PrefsPending then return end
    self._PrefsPending = true
    task.delay(0.6, function()
        if self._PrefsPending then
            self._PrefsPending = false
            self:_WriteUiPrefs()
        end
    end)
end

function MeizuLibrary:_LoadUiPrefs()
    if not self.PersistUI or not HasFileSystem() then return end
    local okR, content = pcall(readfile, self.Folder .. "/" .. PREFS_FILE)
    if not okR or type(content) ~= "string" then return end
    local okD, data = pcall(function() return HttpService:JSONDecode(content) end)
    if not okD or type(data) ~= "table" then return end
    if type(data.Language) == "string" and self.Languages[data.Language] then self.Language = data.Language end
    if type(data.Theme) == "string" and self.Themes[data.Theme] then self.Theme = data.Theme end
    if type(data.Font) == "string" and self.FontPresets[data.Font] then self.FontName = data.Font end
    if type(data.Sound) == "boolean" then self.SoundEnabled = data.Sound end
    if type(data.Scale) == "number" then self.UIScale = math.clamp(data.Scale, 0.6, 1.3) end
    if type(data.Accent) == "table" then
        local r, g, b = tonumber(data.Accent.R), tonumber(data.Accent.G), tonumber(data.Accent.B)
        if r and g and b then
            self.Accent = Color3.new(math.clamp(r, 0, 1), math.clamp(g, 0, 1), math.clamp(b, 0, 1))
            self._UserAccent = self.Accent
        end
    end
    if type(data.Keybind) == "string" then
        local ok, key = pcall(function() return Enum.KeyCode[data.Keybind] end)
        if ok and key then self.ToggleKeybind = key end
    end
    if type(data.Perf) == "boolean" then self.PerfMode = data.Perf end
    if type(data.Glass) == "boolean" then self.GlassWindow = data.Glass end
    if type(data.Blur) == "boolean" then self.BlurEnabled = data.Blur end
    if type(data.BlurSize) == "number" then self.BlurSize = math.clamp(data.BlurSize, 0, 40) end
    if type(data.AutoSave) == "boolean" then self.AutoSave = data.AutoSave end
    if type(data.AutoLoad) == "boolean" then self.AutoLoad = data.AutoLoad end
    if type(data.Watermark) == "boolean" then self.WatermarkOn = data.Watermark end
    if type(data.Collapsed) == "table" then
        for k, v in pairs(data.Collapsed) do
            if type(k) == "string" and type(v) == "boolean" then self.CollapsedSections[k] = v end
        end
    end
    if type(data.Win) == "table" then
        local function num(x) return (type(x) == "number" and x == x and math.abs(x) < 1e6) and x or nil end
        local w = data.Win
        self._SavedWin = {W = num(w.W), H = num(w.H), XS = num(w.XS), XO = num(w.XO), YS = num(w.YS), YO = num(w.YO)}
    end
    if type(data.Tab) == "string" then self._LastTabName = data.Tab end
end

--// ---------------------- Lưu / tải cấu hình tính năng (Flags) ----------------------
function MeizuLibrary:SaveSettings(name)
    if not HasFileSystem() then return false end
    local file = SanitizeFileName(name)
    local data = {}
    for flag, el in pairs(self._FlagElems) do
        local ok, v = pcall(el.Get)
        if ok and type(v) ~= "function" then
            data[flag] = Serialize(v)
        end
    end
    local ok = pcall(function()
        EnsureFolder()
        writefile(self.Folder .. "/" .. file .. ".json", HttpService:JSONEncode(data))
    end)
    return ok
end

-- silent = true: chỉ cập nhật giao diện, KHÔNG gọi callback. Mặc định có gọi callback để
-- tính năng (auto farm, ESP...) bật/tắt đúng theo công tắc vừa tải.
function MeizuLibrary:LoadSettings(name, silent)
    if not HasFileSystem() then return false end
    local content
    local candidates = {SanitizeFileName(name)}
    local raw = tostring(name or "")
    if raw ~= "" and not raw:find("[/\\]") and raw ~= candidates[1] then
        table.insert(candidates, 1, raw)      -- tương thích file lưu bằng tên gốc ở bản cũ
    end
    for _, file in ipairs(candidates) do
        local okR, c = pcall(readfile, self.Folder .. "/" .. file .. ".json")
        if okR and type(c) == "string" then content = c break end
    end
    if not content then return false end
    local okD, data = pcall(function() return HttpService:JSONDecode(content) end)
    if not okD or type(data) ~= "table" then return false end
    local fire = (not silent) and (self.LoadFiresCallbacks ~= false)
    self._Loading = true
    for flag, v in pairs(data) do
        local el = self._FlagElems[flag]       -- khoá cũ (__language, __toggleimage) tự bị bỏ qua
        if el then pcall(el.Set, Deserialize(v), fire) end
    end
    self._Loading = false
    if self.AutoSave and self._AutoArmed then self:_QueueAutoSave() end
    return true
end

function MeizuLibrary:ListConfigs()
    local list = {}
    if type(listfiles) ~= "function" then return list end
    local ok, files = pcall(listfiles, self.Folder)
    if not ok or type(files) ~= "table" then return list end
    for _, path in ipairs(files) do
        local base = tostring(path):match("([^/\\]+)%.json$")
        if base and base:sub(1, 1) ~= "_" and base ~= "language" then
            table.insert(list, base)
        end
    end
    table.sort(list, function(x, y) return x:lower() < y:lower() end)
    return list
end

function MeizuLibrary:Destroy()
    if self.Destroyed then return end
    if self._PrefsPending then
        self._PrefsPending = false
        self:_WriteUiPrefs()
    end
    self.Destroyed = true
    if self._DestroyHooks then
        for _, fn in ipairs(self._DestroyHooks) do pcall(fn) end
        self._DestroyHooks = nil
    end
    if self._RainbowConn then self._RainbowConn:Disconnect() self._RainbowConn = nil end
    for _, c in ipairs(self._Connections) do
        pcall(function() c:Disconnect() end)
    end
    self._Connections = {}
    self._ActiveDrags = {}
    self._DragPipelineInit = false          -- FIX: bản cũ quên reset -> tạo lại UI thì slider không kéo được
    if self._ScreenGui then
        pcall(function() self._ScreenGui:Destroy() end)
        self._ScreenGui = nil
    end
    if self._Blur then pcall(function() self._Blur:Destroy() end) self._Blur = nil end
    self._WindowOpen = false
    self._Loading, self._AutoSavePending = false, false
    self._AutoData, self._AutoPending, self._AutoArmed, self._AutoDirty = nil, {}, false, false
    self._SyncSettings = nil
    self._OnNotify, self._ClearUnread, self._SetWatermarkImpl = nil, nil, nil
    self._SurfaceObjs, self._PerfHooks = {}, {}
    self._ThemeObjs, self._AccentObjs = {}, {}
    self._ThemeHooks, self._AccentHooks, self._LangHooks, self._FontHooks = {}, {}, {}, {}
    self._LocBindings, self._FontObjs = {}, {}
    self._FlagElems = {}
    self._Notifs = {}
    self._NotifHolder = nil
    self._RootScale, self._PopScale = nil, nil
    self._Window = nil
end

--// ============================ CREATE WINDOW ============================
MeizuLibrary.CreateWindow = function(a, b)
    local config
    if a == MeizuLibrary then config = b else config = a end
    if type(config) ~= "table" then config = {} end

    -- Chạy lại cùng 1 hub (cùng Title) -> tự gỡ UI cũ, không bị chồng 2 cửa sổ
    pcall(function()
        local env = (type(getgenv) == "function" and getgenv()) or _G
        local reg = rawget(env, "__MeizuLibraryWindows")
        if type(reg) ~= "table" then
            reg = {}
            env.__MeizuLibraryWindows = reg
        end
        local id = tostring(config.Title or "Meizu Library")
        local old = reg[id]
        if type(old) == "table" and old ~= MeizuLibrary and type(old.Destroy) == "function" then
            pcall(old.Destroy, old)
        end
        reg[id] = MeizuLibrary
    end)

    if MeizuLibrary._ScreenGui then MeizuLibrary:Destroy() end
    MeizuLibrary.Destroyed = false
    MeizuLibrary._Notifs = {}

    -- Cấu hình gốc của hub (dùng cho nút "Đặt lại giao diện")
    MeizuLibrary._BaseTheme = "Dark"
    if type(config.Theme) == "string" and MeizuLibrary.Themes[config.Theme] then
        MeizuLibrary._BaseTheme = config.Theme
    end
    MeizuLibrary._BaseAccent = Color3.fromRGB(88, 101, 242)
    if typeof(config.Accent) == "Color3" then MeizuLibrary._BaseAccent = config.Accent end
    MeizuLibrary.Theme = MeizuLibrary._BaseTheme
    MeizuLibrary.Accent = MeizuLibrary._BaseAccent

    local keybind = config.ToggleKeybind
    if type(keybind) == "string" then
        local okK, key = pcall(function() return Enum.KeyCode[keybind] end)
        if okK and key then keybind = key end
    end
    if typeof(keybind) == "EnumItem" then MeizuLibrary.ToggleKeybind = keybind end
    if config.Language == "en" or config.Language == "vi" then MeizuLibrary.Language = config.Language end
    MeizuLibrary.PersistUI = (config.PersistUI ~= false)

    -- Giao diện người dùng đã chọn lần trước (ngôn ngữ, chủ đề, màu nhấn, phông, cỡ...) ưu tiên hơn mặc định
    MeizuLibrary:_LoadUiPrefs()
    MeizuLibrary:_LoadAutoData()
    MeizuLibrary._LastBind = os.clock()
    MeizuLibrary._UserAccent = MeizuLibrary.Accent

    local Window = {_Tabs = {}, _CurrentTab = nil, _BootSelected = false, _UserScale = MeizuLibrary.UIScale}
    MeizuLibrary._Window = Window

    local ScreenGui = CreateScreenGui()
    MeizuLibrary._ScreenGui = ScreenGui

    local WinSize = config.Size
    local W, H = DEFAULT_WINDOW_SIZE.X.Offset, DEFAULT_WINDOW_SIZE.Y.Offset
    if typeof(WinSize) == "UDim2" then
        if WinSize.X.Offset > 0 then W = WinSize.X.Offset end
        if WinSize.Y.Offset > 0 then H = WinSize.Y.Offset end
    end
    W, H = math.max(W, 440), math.max(H, 330)
    local DEFAULT_W, DEFAULT_H = W, H                 -- để "Đặt lại cửa sổ"
    local saved = MeizuLibrary._SavedWin              -- kích thước / vị trí người dùng đã chỉnh lần trước
    if saved and saved.W and saved.H then
        W, H = math.clamp(saved.W, 460, 1400), math.clamp(saved.H, 340, 1000)
    end
    local startPos = UDim2.new(0.5, 0, 0.5, 0)
    if saved and saved.XS and saved.XO and saved.YS and saved.YO then
        startPos = UDim2.new(saved.XS, saved.XO, saved.YS, saved.YO)
    end
    local SIDEBAR_W = SIDEBAR_WIDTH
    local HEADER_H = HEADER_HEIGHT

    local isOpen = false
    local IconWrap = nil

    --// ---------------- ROOT (vị trí + co giãn) -> POP (hiệu ứng mở) -> SHADOW + MAIN ----------------
    local Root = New("Frame", {
        Name = "Root",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = startPos,
        Size = UDim2.fromOffset(W, H),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Visible = false,
        Parent = ScreenGui,
    })
    local RootScale = New("UIScale", {Scale = 1, Parent = Root})
    MeizuLibrary._RootScale = RootScale
    -- AnchorPoint ở giữa để hiệu ứng mở/đóng phóng to-thu nhỏ quanh TÂM cửa sổ (không bung từ góc)
    local Pop = New("Frame", {
        Name = "Pop", BackgroundTransparency = 1, BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1), Parent = Root,
    })
    local PopScale = New("UIScale", {Scale = 0.92, Parent = Pop})
    MeizuLibrary._PopScale = PopScale

    -- Bóng đổ nằm NGOÀI CanvasGroup (bản cũ để trong Main nên bị cắt mất, không thấy bóng)
    local Shadow = New("ImageLabel", {
        Name = "Shadow", BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 90, 1, 90),
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = 0, Parent = Pop,
    })

    -- CanvasGroup tự bo góc & cắt mọi thứ bên trong -> Sidebar/Content không cần UICorner riêng
    -- (hết hẳn lỗi khuyết góc ở đường nối sidebar của bản cũ)
    local Main = New("CanvasGroup", {
        Name = "Main",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = T("Window"),
        BorderSizePixel = 0,
        GroupTransparency = 1,
        ZIndex = 1,
        Parent = Pop,
    })
    Register(Main, {BackgroundColor3 = "Window"})
    RegisterSurface(Main)
    New("UICorner", {CornerRadius = UDim.new(0, 14), Parent = Main})
    local MainStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.3, Parent = Main})
    Register(MainStroke, {Color = "Stroke"})

    --// ---------------- Vị trí / tự co theo màn hình ----------------
    local function ClampWindow(pos)
        local vp = ScreenGui.AbsoluteSize
        if vp.X <= 0 or vp.Y <= 0 then return pos end
        local sc = RootScale.Scale
        local hw, hh = (W * sc) / 2, (H * sc) / 2
        local cx = vp.X * pos.X.Scale + pos.X.Offset
        local cy = vp.Y * pos.Y.Scale + pos.Y.Offset
        local margin = 80      -- luôn chừa ít nhất 80px của cửa sổ trong màn hình, header không lọt lên trên
        local ncx = math.clamp(cx, margin - hw, vp.X - margin + hw)
        local ncy = math.clamp(cy, hh, math.max(vp.Y - margin + hh, hh))
        return UDim2.new(pos.X.Scale, pos.X.Offset + (ncx - cx), pos.Y.Scale, pos.Y.Offset + (ncy - cy))
    end

    local function UpdateFit()
        if not Root.Parent then return end
        local vp = ScreenGui.AbsoluteSize
        if vp.X <= 0 or vp.Y <= 0 then return end
        local want = Window._UserScale or 1
        local fit = math.min(want, (vp.X - 24) / W, (vp.Y - 24) / H)
        RootScale.Scale = math.max(fit, 0.45)
        Root.Position = ClampWindow(Root.Position)
    end
    table.insert(MeizuLibrary._Connections, ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateFit))

    function Window:SetScale(n)
        n = math.clamp(tonumber(n) or 1, 0.6, 1.3)
        Window._UserScale = n
        MeizuLibrary.UIScale = n
        UpdateFit()
        MeizuLibrary:_SaveUiPrefs()
    end

    -- Nhớ vị trí + kích thước cửa sổ cho lần chạy sau
    local function SaveWinState()
        local p = Root.Position
        MeizuLibrary._SavedWin = {W = W, H = H, XS = p.X.Scale, XO = p.X.Offset, YS = p.Y.Scale, YO = p.Y.Offset}
        MeizuLibrary:_SaveUiPrefs()
    end

    local function ApplySize(nw, nh)
        W, H = nw, nh
        Root.Size = UDim2.fromOffset(nw, nh)
        UpdateFit()
    end

    -- Kích thước tối đa: vừa màn hình ở tỉ lệ người dùng chọn (cửa sổ không bị tự co nhỏ chữ)
    local function MaxSize()
        local vp = ScreenGui.AbsoluteSize
        if vp.X <= 0 or vp.Y <= 0 then return 1400, 1000 end
        local want = math.max(Window._UserScale or 1, 0.01)
        return math.max(460, math.floor((vp.X - 24) / want)), math.max(340, math.floor((vp.Y - 24) / want))
    end

    function Window:SetSize(w, h)
        local maxW, maxH = MaxSize()
        ApplySize(math.clamp(math.floor((tonumber(w) or W) + 0.5), 460, maxW),
                  math.clamp(math.floor((tonumber(h) or H) + 0.5), 340, maxH))
        SaveWinState()
    end
    function Window:GetSize() return W, H end
    function Window:ResetLayout()
        ApplySize(DEFAULT_W, DEFAULT_H)
        Root.Position = UDim2.new(0.5, 0, 0.5, 0)
        UpdateFit()
        SaveWinState()
    end

    --// ======================== SIDEBAR ========================
    local Sidebar = New("Frame", {
        Name = "Sidebar", BackgroundColor3 = T("Sidebar"),
        Size = UDim2.new(0, SIDEBAR_W, 1, 0), BorderSizePixel = 0,
        ZIndex = 2, Parent = Main,
    })
    Register(Sidebar, {BackgroundColor3 = "Sidebar"})
    RegisterSurface(Sidebar)
    New("UIGradient", {
        Rotation = 90,
        Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(212, 212, 224)),
        Parent = Sidebar,
    })

    local Divider = New("Frame", {
        Name = "Divider", BackgroundColor3 = T("Stroke"), BackgroundTransparency = 0.35,
        Position = UDim2.new(0, SIDEBAR_W - 1, 0, 0), Size = UDim2.new(0, 1, 1, 0),
        BorderSizePixel = 0, ZIndex = 4, Parent = Main,
    })
    Register(Divider, {BackgroundColor3 = "Stroke"})

    -- Thương hiệu
    local BrandPill = New("Frame", {
        BackgroundColor3 = MeizuLibrary.Accent,
        Position = UDim2.new(0, 16, 0, 14), Size = UDim2.new(0, 3, 0, 32),
        BorderSizePixel = 0, ZIndex = 3, Parent = Sidebar,
    })
    RegisterAccent(BrandPill, "BackgroundColor3")
    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = BrandPill})

    local TitleLabel = TextObj("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 28, 0, 12),
        Size = UDim2.new(1, -44, 0, 22),
        TextColor3 = T("Text"), TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Text = tostring(config.Title or "Meizu Library"),
        ZIndex = 3, Parent = Sidebar,
    }, "Bold", 17)
    Register(TitleLabel, {TextColor3 = "Text"})

    local SubLabel = TextObj("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 28, 0, 34),
        Size = UDim2.new(1, -44, 0, 16),
        TextColor3 = T("SubText"), TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Text = tostring(config.SubTitle or ("v" .. MeizuLibrary.Version)),
        ZIndex = 3, Parent = Sidebar,
    }, "Regular", 11)
    Register(SubLabel, {TextColor3 = "SubText"})

    function Window:SetTitle(text)    TitleLabel.Text = tostring(text or "") end
    function Window:SetSubTitle(text) SubLabel.Text = tostring(text or "") end

    -- Vùng kéo phía sidebar (phủ phần thương hiệu)
    local BrandDrag = New("Frame", {
        Name = "BrandDrag", BackgroundTransparency = 1, BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 58), ZIndex = 6, Parent = Sidebar,
    })
    MakeDraggable(BrandDrag, Root, ClampWindow, SaveWinState)

    -- Ô tìm kiếm
    local SearchWrap = New("Frame", {
        Name = "Search", BackgroundColor3 = T("Input"),
        Position = UDim2.new(0, 12, 0, 64), Size = UDim2.new(1, -24, 0, 32),
        BorderSizePixel = 0, ZIndex = 3, Parent = Sidebar,
    })
    Register(SearchWrap, {BackgroundColor3 = "Input"})
    New("UICorner", {CornerRadius = UDim.new(0, 9), Parent = SearchWrap})
    local SearchStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.45, Parent = SearchWrap})
    Register(SearchStroke, {Color = "Stroke"})

    -- Biểu tượng kính lúp (vẽ bằng Frame, không phụ thuộc asset)
    local MagRing = New("Frame", {
        BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 11, 0.5, -1), Size = UDim2.fromOffset(9, 9),
        BorderSizePixel = 0, ZIndex = 4, Parent = SearchWrap,
    })
    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = MagRing})
    local MagStroke = New("UIStroke", {Color = T("SubText"), Thickness = 1.5, Parent = MagRing})
    Register(MagStroke, {Color = "SubText"})
    local MagHandle = New("Frame", {
        BackgroundColor3 = T("SubText"), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 20, 0.5, 4), Size = UDim2.fromOffset(5, 2), Rotation = 45,
        BorderSizePixel = 0, ZIndex = 4, Parent = SearchWrap,
    })
    Register(MagHandle, {BackgroundColor3 = "SubText"})

    local SearchBox = TextObj("TextBox", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 32, 0, 0), Size = UDim2.new(1, -60, 1, 0),
        Text = "", PlaceholderText = L("Search..."),
        PlaceholderColor3 = T("Placeholder"), TextColor3 = T("Text"),
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false, BorderSizePixel = 0,
        ZIndex = 4, Parent = SearchWrap,
    }, "Regular", 12)
    Register(SearchBox, {PlaceholderColor3 = "Placeholder", TextColor3 = "Text"})
    BindLoc(SearchBox, "PlaceholderText", "Search...")

    local ClearBtn = New("TextButton", {
        Text = "", AutoButtonColor = false, BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -6, 0.5, 0),
        Size = UDim2.fromOffset(22, 22), Visible = false,
        ZIndex = 5, Parent = SearchWrap,
    })
    DrawCross(ClearBtn, 8, 1.5, "SubText", 6)
    ClearBtn.Activated:Connect(function() SearchBox.Text = "" end)
    SearchBox.Focused:Connect(function()
        Tween(SearchStroke, 0.15, {Color = MeizuLibrary.Accent, Transparency = 0.1})
    end)
    SearchBox.FocusLost:Connect(function()
        Tween(SearchStroke, 0.2, {Color = T("Stroke"), Transparency = 0.45})
    end)

    -- Danh sách tab
    local TabsHolder = New("ScrollingFrame", {
        Name = "Tabs", BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 106),
        Size = UDim2.new(1, -20, 1, -168),
        ScrollBarThickness = 2, CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        BorderSizePixel = 0, ZIndex = 3, Parent = Sidebar,
    })
    RegisterAccent(TabsHolder, "ScrollBarImageColor3")
    New("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = TabsHolder})

    -- Thẻ người chơi
    local PlayerCard = New("Frame", {
        Name = "PlayerCard", BackgroundColor3 = T("Element"),
        Position = UDim2.new(0, 10, 1, -54), Size = UDim2.new(1, -20, 0, 44),
        BorderSizePixel = 0, ZIndex = 3, Parent = Sidebar,
    })
    Register(PlayerCard, {BackgroundColor3 = "Element"})
    RegisterSurface(PlayerCard)
    New("UICorner", {CornerRadius = UDim.new(0, 10), Parent = PlayerCard})
    local PlayerStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.5, Parent = PlayerCard})
    Register(PlayerStroke, {Color = "Stroke"})

    local Avatar = New("ImageLabel", {
        BackgroundColor3 = T("Tab"),
        Position = UDim2.new(0, 8, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.fromOffset(30, 30), BorderSizePixel = 0, ZIndex = 4, Parent = PlayerCard,
    })
    Register(Avatar, {BackgroundColor3 = "Tab"})
    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Avatar})
    task.spawn(function()
        local okT, thumb = pcall(function()
            return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        end)
        if okT and Avatar.Parent then Avatar.Image = thumb end
    end)

    local PName = TextObj("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 46, 0, 6), Size = UDim2.new(1, -54, 0, 18),
        TextColor3 = T("Text"), TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Text = LocalPlayer.DisplayName, ZIndex = 4, Parent = PlayerCard,
    }, "Bold", 12)
    Register(PName, {TextColor3 = "Text"})
    local PUser = TextObj("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 46, 0, 23), Size = UDim2.new(1, -54, 0, 14),
        TextColor3 = T("SubText"), TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Text = "@" .. LocalPlayer.Name, ZIndex = 4, Parent = PlayerCard,
    }, "Regular", 10)
    Register(PUser, {TextColor3 = "SubText"})

    --// ======================== CONTENT AREA ========================
    local ContentArea = New("Frame", {
        Name = "ContentArea", BackgroundTransparency = 1,
        Position = UDim2.new(0, SIDEBAR_W, 0, 0), Size = UDim2.new(1, -SIDEBAR_W, 1, 0),
        BorderSizePixel = 0, ZIndex = 2, Parent = Main,
    })

    -- Vùng chứa các trang: bắt đầu NGAY DƯỚI header nên nội dung cuộn không bao giờ đè lên header
    local PagesHolder = New("Frame", {
        Name = "Pages", BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, HEADER_H), Size = UDim2.new(1, 0, 1, -HEADER_H),
        ClipsDescendants = true, BorderSizePixel = 0, ZIndex = 1, Parent = ContentArea,
    })

    -- Nội dung mờ dần khi trượt lên dưới header / xuống sát đáy
    local FadeTop = New("Frame", {
        Name = "FadeTop", BackgroundColor3 = T("Window"),
        Position = UDim2.new(0, 0, 0, HEADER_H), Size = UDim2.new(1, 0, 0, 18),
        BorderSizePixel = 0, ZIndex = 9, Parent = ContentArea,
    })
    Register(FadeTop, {BackgroundColor3 = "Window"})
    RegisterSurface(FadeTop)
    New("UIGradient", {
        Rotation = 90,
        Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}),
        Parent = FadeTop,
    })
    local FadeBottom = New("Frame", {
        Name = "FadeBottom", BackgroundColor3 = T("Window"),
        AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 14),
        BorderSizePixel = 0, ZIndex = 9, Parent = ContentArea,
    })
    Register(FadeBottom, {BackgroundColor3 = "Window"})
    RegisterSurface(FadeBottom)
    New("UIGradient", {
        Rotation = 90,
        Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}),
        Parent = FadeBottom,
    })

    -- HEADER: thanh tiêu đề — vùng trống để KÉO cửa sổ
    local Header = New("Frame", {
        Name = "Header", BackgroundColor3 = T("Window"),
        Size = UDim2.new(1, 0, 0, HEADER_H), BorderSizePixel = 0,
        ZIndex = 10, Parent = ContentArea,
    })
    Register(Header, {BackgroundColor3 = "Window"})
    RegisterSurface(Header)

    local HeaderTitle = TextObj("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 0), Size = UDim2.new(1, -120, 1, 0),
        TextColor3 = T("Text"), TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd, Text = "",
        ZIndex = 11, Parent = Header,
    }, "Bold", 16)
    Register(HeaderTitle, {TextColor3 = "Text"})
    local HeaderBinding = BindLoc(HeaderTitle, "Text", "")

    local HeaderLine = New("Frame", {
        BackgroundColor3 = T("Stroke"), BackgroundTransparency = 0.45,
        AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 1),
        BorderSizePixel = 0, ZIndex = 11, Parent = Header,
    })
    Register(HeaderLine, {BackgroundColor3 = "Stroke"})
    local AccentLine = New("Frame", {
        BackgroundColor3 = MeizuLibrary.Accent, BackgroundTransparency = 0,
        AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 1),
        BorderSizePixel = 0, ZIndex = 12, Parent = Header,
    })
    RegisterAccent(AccentLine, "BackgroundColor3")
    New("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(0.55, 0.75),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = AccentLine,
    })

    local function HeaderButton(xoff)
        local btn = New("TextButton", {
            Name = "HeaderButton", Text = "", AutoButtonColor = false,
            BackgroundColor3 = T("Tab"), BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, xoff, 0.5, 0),
            Size = UDim2.fromOffset(28, 28),
            ZIndex = 12, BorderSizePixel = 0, Parent = Header,
        })
        Register(btn, {BackgroundColor3 = "Tab"})
        New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = btn})
        btn.MouseEnter:Connect(function() Tween(btn, 0.15, {BackgroundTransparency = 0.15}) end)
        btn.MouseLeave:Connect(function() Tween(btn, 0.2, {BackgroundTransparency = 1}) end)
        return btn
    end

    local MinBtn = HeaderButton(-48)
    local MinBar = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(10, 2), BackgroundColor3 = T("SubText"),
        BorderSizePixel = 0, ZIndex = 13, Parent = MinBtn,
    })
    Register(MinBar, {BackgroundColor3 = "SubText"})
    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = MinBar})

    local CloseBtn = HeaderButton(-14)
    local CloseBars = DrawCross(CloseBtn, 11, 2, "SubText", 13)
    CloseBtn.MouseEnter:Connect(function()
        for _, bar in ipairs(CloseBars) do Tween(bar, 0.15, {BackgroundColor3 = Color3.fromRGB(255, 95, 95)}) end
    end)
    CloseBtn.MouseLeave:Connect(function()
        for _, bar in ipairs(CloseBars) do Tween(bar, 0.2, {BackgroundColor3 = T("SubText")}) end
    end)

    -- Kéo cửa sổ bằng toàn bộ header (trừ 2 nút) + có kẹp trong màn hình
    MakeDraggable(Header, Root, ClampWindow, SaveWinState)

    --// RESIZE GRIP: kéo góc phải-dưới để đổi kích thước cửa sổ (nhớ cho lần sau)
    local Grip = New("TextButton", {
        Name = "ResizeGrip", Text = "", AutoButtonColor = false, BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -3, 1, -3), Size = UDim2.fromOffset(22, 22),
        BorderSizePixel = 0, ZIndex = 30, Parent = Main,
    })
    local gripBars = {}
    for i, g in ipairs({{16, 16, 4}, {12, 12, 9}, {8, 8, 14}}) do
        local bar = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(g[1], g[2]),
            Size = UDim2.fromOffset(g[3], 1.5), Rotation = -45,
            BackgroundColor3 = T("SubText"), BackgroundTransparency = 0.45,
            BorderSizePixel = 0, ZIndex = 31, Parent = Grip,
        })
        Register(bar, {BackgroundColor3 = "SubText"})
        gripBars[i] = bar
    end
    Grip.MouseEnter:Connect(function()
        for _, bar in ipairs(gripBars) do Tween(bar, 0.15, {BackgroundTransparency = 0.05}) end
    end)
    Grip.MouseLeave:Connect(function()
        for _, bar in ipairs(gripBars) do Tween(bar, 0.2, {BackgroundTransparency = 0.45}) end
    end)
    Grip.InputBegan:Connect(function(input)
        if not IsPointer(input) then return end
        local startPointer = PointerPos(input)
        local startW, startH, startPos0 = W, H, Root.Position
        local sc = math.max(RootScale.Scale, 0.01)
        AddDrag(input, {
            OnChanged = function(inp)
                local d = PointerPos(inp) - startPointer
                local maxW, maxH = MaxSize()
                local nw = math.clamp(math.floor(startW + d.X / sc + 0.5), 460, maxW)
                local nh = math.clamp(math.floor(startH + d.Y / sc + 0.5), 340, maxH)
                ApplySize(nw, nh)
                -- Root neo ở TÂM: dịch tâm nửa phần chênh lệch để góc trên-trái đứng yên, góc dưới-phải bám theo tay
                local s2 = RootScale.Scale
                Root.Position = ClampWindow(UDim2.new(
                    startPos0.X.Scale, startPos0.X.Offset + (nw - startW) * s2 / 2,
                    startPos0.Y.Scale, startPos0.Y.Offset + (nh - startH) * s2 / 2))
            end,
            OnEnd = function() SaveWinState() end,
        })
    end)

    -- Khung chứa nội dung hiển thị khi tìm kiếm không có kết quả
    local EmptyLabel = TextObj("TextLabel", {
        Name = "Empty", BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.45),
        Size = UDim2.new(1, -40, 0, 24),
        TextColor3 = T("SubText"), Text = "", Visible = false,
        ZIndex = 5, Parent = PagesHolder,
    }, "Medium", 13)
    Register(EmptyLabel, {TextColor3 = "SubText"})
    BindLoc(EmptyLabel, "Text", "No results")

    --// ======================== ELEMENT FACTORY ========================
    -- Hiển thị của 1 element = không bị ẩn bằng SetVisible + khớp tìm kiếm + section chứa nó không đang thu gọn
    -- (đang tìm kiếm thì bỏ qua trạng thái thu gọn để vẫn thấy kết quả).
    local function RecVisible(rec)
        if rec.Hidden then return false end
        if rec.SearchShow == false then return false end
        local sec = rec.Section
        if sec and sec.Collapsed and (Window._Query or "") == "" then return false end
        return true
    end
    local function RefreshRec(rec)
        if rec.Frame and rec.Frame.Parent then rec.Frame.Visible = RecVisible(rec) end
    end

    local function BindElements(target, container, tab, secRec)
        if target.CreateSection then return end

        -- Gọi bằng "." hay ":" đều được: el.SetTitle("x") / el:SetTitle("x")
        local function ArgAfterSelf(el, x, y)
            if x == el then return y end
            return x
        end

        local lastTitleBind, lastDescBind = nil, nil      -- do AddText ghi lại cho AddSearch / Decorate

        local function MakeCard(height, interactive)
            local Card
            local props = {
                BackgroundColor3 = T("Element"),
                Size = UDim2.new(1, 0, 0, height),
                ClipsDescendants = true, BorderSizePixel = 0,
                Parent = container,
            }
            if interactive then
                props.Text = ""
                props.AutoButtonColor = false
                Card = New("TextButton", props)
            else
                Card = New("Frame", props)
            end
            New("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Card})
            New("UIGradient", {
                Rotation = 90,
                Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(228, 228, 236)),
                Parent = Card,
            })
            local Stroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.45, Parent = Card})
            Register(Card, {BackgroundColor3 = "Element"})
            RegisterSurface(Card)
            Register(Stroke, {Color = "Stroke"})
            if interactive then
                local Hover = New("Frame", {
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.fromScale(1, 1),
                    ZIndex = 5, BorderSizePixel = 0, Parent = Card,
                })
                New("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Hover})
                Card.MouseEnter:Connect(function()
                    Tween(Hover, 0.15, {BackgroundTransparency = 0.93})
                    Tween(Stroke, 0.15, {Transparency = 0.2})
                end)
                Card.MouseLeave:Connect(function()
                    Tween(Hover, 0.25, {BackgroundTransparency = 1})
                    Tween(Stroke, 0.25, {Transparency = 0.45})
                end)
            end
            return Card
        end

        -- Tiêu đề (+ mô tả) của thẻ. Dùng kích thước PIXEL cố định để khi thẻ giãn ra (dropdown,
        -- bảng màu) chữ không bị nhảy xuống giữa thẻ như bản cũ.
        --   rowH    : chiều cao hàng đầu (căn giữa chữ khi không có mô tả)
        --   topAlign: ghim tiêu đề lên trên (slider, ...)
        local function AddText(Card, title, desc, rightSpace, rowH, topAlign)
            rightSpace = rightSpace or 70
            rowH = rowH or 42
            local hasDesc = (desc ~= nil and desc ~= "")
            local ty, th = 0, rowH
            if hasDesc or topAlign then ty, th = 8, 20 end

            local Title = TextObj("TextLabel", {
                BackgroundTransparency = 1,
                TextColor3 = T("Text"),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2.new(0, 14, 0, ty),
                Size = UDim2.new(1, -(14 + rightSpace), 0, th),
                Text = "", Parent = Card,
            }, "Medium", 13)
            Register(Title, {TextColor3 = "Text"})
            local titleBind = BindLoc(Title, "Text", tostring(title or ""))

            local Desc, descBind
            if hasDesc then
                Desc = TextObj("TextLabel", {
                    BackgroundTransparency = 1,
                    TextColor3 = T("SubText"),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Position = UDim2.new(0, 14, 0, 28),
                    Size = UDim2.new(1, -(14 + rightSpace), 0, 16),
                    Text = "", Parent = Card,
                }, "Regular", 11)
                Register(Desc, {TextColor3 = "SubText"})
                descBind = BindLoc(Desc, "Text", tostring(desc))
            end
            lastTitleBind, lastDescBind = titleBind, descBind
            return Title, Desc, titleBind, descBind
        end

        -- Đăng ký element vào bộ lọc tìm kiếm (chữ gốc + bản dịch, không phân biệt dấu)
        local function AddSearch(Card, ...)
            local rec = {
                Frame = Card, Text = SearchText(...), Section = secRec, SearchShow = true,
                TitleBind = lastTitleBind, DescBind = lastDescBind,
            }
            rec.Title, rec.Desc = (select(1, ...)), (select(2, ...))
            lastTitleBind, lastDescBind = nil, nil
            table.insert(tab._Elements, rec)
            if secRec then table.insert(secRec.Items, rec) end
            MeizuLibrary._LastBind = os.clock()
            RefreshRec(rec)          -- section đang thu gọn thì element mới tạo cũng ẩn ngay
            return rec
        end

        -- Các hàm dùng chung cho MỌI element: SetVisible / SetEnabled / SetTitle / SetDescription / Destroy
        local function Decorate(el, Card, rec, cfg)
            cfg = cfg or {}
            local lock
            if el.SetVisible == nil then
                el.SetVisible = function(x, y)
                    rec.Hidden = (ArgAfterSelf(el, x, y) == false)
                    RefreshRec(rec)
                end
            end
            if el.IsVisible == nil then el.IsVisible = function() return not rec.Hidden end end
            if el.SetEnabled == nil then
                el.SetEnabled = function(x, y)
                    rec.Enabled = (ArgAfterSelf(el, x, y) ~= false)
                    if not Card.Parent then return end
                    if not rec.Enabled then
                        if not lock then
                            -- lớp phủ Active chặn mọi thao tác chạm xuống element bên dưới
                            lock = New("Frame", {
                                Name = "Lock", BackgroundColor3 = T("Window"), BackgroundTransparency = 0.35,
                                Size = UDim2.fromScale(1, 1), Active = true,
                                BorderSizePixel = 0, ZIndex = 80, Parent = Card,
                            })
                            New("UICorner", {CornerRadius = UDim.new(0, 10), Parent = lock})
                            Register(lock, {BackgroundColor3 = "Window"})
                        end
                        lock.Visible = true
                    elseif lock then
                        lock.Visible = false
                    end
                end
            end
            if el.IsEnabled == nil then el.IsEnabled = function() return rec.Enabled ~= false end end
            -- SetTitle / SetDescription luôn tồn tại (không có dòng chữ tương ứng thì không làm gì, tránh lỗi nil)
            if el.SetTitle == nil then
                el.SetTitle = function(x, y)
                    if not rec.TitleBind then return end
                    local t = tostring(ArgAfterSelf(el, x, y) or "")
                    rec.TitleBind.Key = t
                    RefreshBinding(rec.TitleBind)
                    rec.Title = t
                    rec.Text = SearchText(rec.Title, rec.Desc)
                end
            end
            if el.SetDescription == nil then
                el.SetDescription = function(x, y)
                    if not rec.DescBind then return end
                    local t = tostring(ArgAfterSelf(el, x, y) or "")
                    rec.DescBind.Key = t
                    RefreshBinding(rec.DescBind)
                    rec.Desc = t
                    rec.Text = SearchText(rec.Title, rec.Desc)
                end
            end
            if el.Destroy == nil then
                el.Destroy = function()
                    for i, e in ipairs(tab._Elements) do
                        if e == rec then table.remove(tab._Elements, i) break end
                    end
                    if rec.Section then
                        for i, e in ipairs(rec.Section.Items) do
                            if e == rec then table.remove(rec.Section.Items, i) break end
                        end
                    end
                    if cfg.Flag and MeizuLibrary._FlagElems[cfg.Flag] == el then
                        MeizuLibrary._FlagElems[cfg.Flag] = nil
                        MeizuLibrary.Flags[cfg.Flag] = nil
                    end
                    if Card.Parent then Card:Destroy() end
                end
            end
            return el
        end

        local function BindFlag(el, flag, initial)
            if flag then
                MeizuLibrary._FlagElems[flag] = el
                MeizuLibrary.Flags[flag] = initial
                MeizuLibrary:_ApplyAutoValue(flag, el)       -- Auto Load: hiện giá trị đã lưu ngay khi tạo
            end
        end

        -- Mũi tên ">" vẽ bằng 2 thanh xoay
        local function DrawChevronRight(parent, xoff)
            local holder = New("Frame", {
                BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, xoff, 0.5, 0), Size = UDim2.fromOffset(10, 12),
                BorderSizePixel = 0, Parent = parent,
            })
            for i, rot in ipairs({45, -45}) do
                local bar = New("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.4, 0, i == 1 and 0.32 or 0.68, 0),
                    Size = UDim2.fromOffset(7, 2), Rotation = rot,
                    BackgroundColor3 = T("SubText"), BorderSizePixel = 0, Parent = holder,
                })
                Register(bar, {BackgroundColor3 = "SubText"})
                New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = bar})
            end
            return holder
        end

        --// SECTION (bấm vào tiêu đề để thu gọn / mở rộng — nhớ trạng thái cho lần sau)
        function target:CreateSection(name, collapsedDefault)
            name = tostring(name or "Section")
            local collapsible = (config.CollapsibleSections ~= false)
            local Sec = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BorderSizePixel = 0, Parent = container,
            })
            New("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Sec})
            local Head = New("TextButton", {
                Text = "", AutoButtonColor = false,
                BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 24),
                BorderSizePixel = 0, Parent = Sec,
            })
            local Bar = New("Frame", {
                BackgroundColor3 = MeizuLibrary.Accent,
                Position = UDim2.new(0, 2, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 3, 0, 12), BorderSizePixel = 0, Parent = Head,
            })
            RegisterAccent(Bar, "BackgroundColor3")
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Bar})

            local SecLabel = TextObj("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 13, 0, 0), Size = UDim2.new(0, 100, 1, 0),
                TextColor3 = T("SubText"), TextXAlignment = Enum.TextXAlignment.Left,
                Text = "", Parent = Head,
            }, "Bold", 11)
            Register(SecLabel, {TextColor3 = "SubText"})
            -- FIX tiếng Việt: UpperVN thay cho string.upper (string.upper làm hỏng chữ có dấu)
            BindLoc(SecLabel, "Text", name, UpperVN)

            -- Mũi tên thu gọn (tâm cố định để xoay không bị lệch)
            local Chev = New("Frame", {
                BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(12, 12),
                BorderSizePixel = 0, Visible = collapsible, Parent = Head,
            })
            for i, rot in ipairs({-45, 45}) do
                local bar = New("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5 + (i == 1 and -0.18 or 0.18), 0, 0.5, 0),
                    Size = UDim2.fromOffset(2, 7), Rotation = rot,
                    BackgroundColor3 = T("SubText"), BorderSizePixel = 0, Parent = Chev,
                })
                Register(bar, {BackgroundColor3 = "SubText"})
            end

            local Line = New("Frame", {
                BackgroundColor3 = T("Stroke"), BackgroundTransparency = 0.5,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 120, 0.5, 0), Size = UDim2.new(1, -150, 0, 1),
                BorderSizePixel = 0, Parent = Head,
            })
            Register(Line, {BackgroundColor3 = "Stroke"})
            local function LayoutHead()
                if not Head.Parent then return end
                local _, tw = MeasureText(SecLabel.Text, "Bold", 11, 600)
                SecLabel.Size = UDim2.new(0, tw + 4, 1, 0)
                local x = 13 + tw + 14
                Line.Position = UDim2.new(0, x, 0.5, 0)
                Line.Size = UDim2.new(1, -(x + (collapsible and 30 or 0)), 0, 1)
            end
            LayoutHead()
            OnLangChange(LayoutHead)
            OnFontChange(LayoutHead)

            local rec = {Frame = Sec, Head = Head, Text = SearchText(name), Items = {}}
            table.insert(tab._Sections, rec)
            MeizuLibrary._LastBind = os.clock()

            -- Trạng thái thu gọn: ưu tiên giá trị người dùng đã chọn (đã lưu), nếu chưa có thì dùng mặc định
            local key = tab._Name .. "/" .. name
            local persisted = MeizuLibrary.CollapsedSections[key]
            if persisted ~= nil then rec.Collapsed = persisted else rec.Collapsed = (collapsedDefault == true) end
            if not collapsible then rec.Collapsed = false end
            Chev.Rotation = rec.Collapsed and -90 or 0

            local function SetCollapsed(state, persist)
                state = (state == true) and collapsible
                if rec.Collapsed == state then return end
                rec.Collapsed = state
                Tween(Chev, 0.25, {Rotation = state and -90 or 0})
                for _, it in ipairs(rec.Items) do RefreshRec(it) end
                if persist then MeizuLibrary:_SetCollapsed(key, state) end
            end
            if collapsible then
                Head.Activated:Connect(function() SetCollapsed(not rec.Collapsed, true) end)
                Head.MouseEnter:Connect(function() Tween(SecLabel, 0.15, {TextColor3 = T("Text")}) end)
                Head.MouseLeave:Connect(function() Tween(SecLabel, 0.2, {TextColor3 = T("SubText")}) end)
            end

            local SectionObj = {Frame = Sec}
            SectionObj.Collapse = function(x, y) SetCollapsed(ArgAfterSelf(SectionObj, x, y) ~= false, true) end
            SectionObj.Expand = function() SetCollapsed(false, true) end
            SectionObj.Toggle = function() SetCollapsed(not rec.Collapsed, true) end
            SectionObj.IsCollapsed = function() return rec.Collapsed == true end
            BindElements(SectionObj, Sec, tab, rec)
            return SectionObj
        end

        --// BUTTON
        function target:CreateButton(cfg)
            cfg = cfg or {}
            local hasDesc = cfg.Description ~= nil
            local Card = MakeCard(hasDesc and 58 or 42, true)
            AddText(Card, cfg.Title or "Button", cfg.Description, 40)
            DrawChevronRight(Card, -16)

            Card.InputBegan:Connect(function(input)
                if IsPointer(input) then
                    local p = (PointerPos(input) - Card.AbsolutePosition) / GuiScale()
                    Ripple(Card, p.X, p.Y)
                end
            end)
            Card.Activated:Connect(function() SafeCall(cfg.Callback) end)
            local rec = AddSearch(Card, cfg.Title, cfg.Description)

            local el = {Frame = Card}
            el.Fire = function() SafeCall(cfg.Callback) end
            return Decorate(el, Card, rec, cfg)
        end

        --// TOGGLE
        function target:CreateToggle(cfg)
            cfg = cfg or {}
            local hasDesc = cfg.Description ~= nil
            local Card = MakeCard(hasDesc and 58 or 42, true)
            AddText(Card, cfg.Title or "Toggle", cfg.Description, 76)

            local Track = New("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -14, 0.5, 0),
                Size = UDim2.fromOffset(44, 24),
                BackgroundColor3 = T("ToggleOff"),
                BorderSizePixel = 0, Parent = Card,
            })
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Track})
            local TrackStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.55, Parent = Track})
            Register(TrackStroke, {Color = "Stroke"})
            local Knob = New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 3, 0.5, 0),
                Size = UDim2.fromOffset(18, 18),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0, ZIndex = 2, Parent = Track,
            })
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Knob})

            local state = (cfg.Default == true)
            local function Render(v, animate)
                if not Track.Parent then return end
                local color = v and MeizuLibrary.Accent or T("ToggleOff")
                local pos = UDim2.new(0, v and 23 or 3, 0.5, 0)
                if animate == false then
                    Track.BackgroundColor3 = color
                    Knob.Position = pos
                else
                    Tween(Track, 0.25, {BackgroundColor3 = color})
                    Tween(Knob, 0.3, {Position = pos}, Enum.EasingStyle.Back)
                end
            end
            local function Set(v, fire)
                v = (v == true)
                state = v
                Render(v)
                if cfg.Flag then SetFlag(cfg.Flag, v) end
                if fire then SafeCall(cfg.Callback, v) end
            end
            Card.Activated:Connect(function() Set(not state, true) end)
            Render(state, false)
            OnThemeChange(function() Render(state, false) end)
            OnAccentChange(function() if state then Render(true, false) end end)   -- FIX: đổi màu nhấn cập nhật công tắc đang bật

            local el = {Frame = Card, Get = function() return state end, Set = function(v, fire) Set(v, fire) end}
            BindFlag(el, cfg.Flag, state)
            local rec = AddSearch(Card, cfg.Title, cfg.Description)
            return Decorate(el, Card, rec, cfg)
        end

        --// SLIDER (kéo mượt trên mobile, có Increment / Suffix)
        function target:CreateSlider(cfg)
            cfg = cfg or {}
            local min, max = tonumber(cfg.Min) or 0, tonumber(cfg.Max) or 100
            if max <= min then max = min + 1 end
            local rounding = math.max(math.floor(tonumber(cfg.Rounding) or 0), 0)
            local increment = tonumber(cfg.Increment)
            if increment and increment <= 0 then increment = nil end
            local suffix = cfg.Suffix and tostring(cfg.Suffix) or ""
            local hasDesc = cfg.Description ~= nil
            local Card = MakeCard(hasDesc and 72 or 56, false)
            AddText(Card, cfg.Title or "Slider", cfg.Description, 100, nil, true)

            local ValueLabel = TextObj("TextLabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -14, 0, 8),
                Size = UDim2.fromOffset(84, 20),
                TextColor3 = T("Text"), TextXAlignment = Enum.TextXAlignment.Right,
                Text = "", Parent = Card,
            }, "Bold", 12)
            Register(ValueLabel, {TextColor3 = "Text"})

            -- Holder cao 20px cho dễ chạm trên điện thoại
            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 1, -26),
                Size = UDim2.new(1, -28, 0, 20),
                BorderSizePixel = 0, Parent = Card,
            })
            local Track = New("Frame", {
                BackgroundColor3 = T("Track"),
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 0, 6),
                BorderSizePixel = 0, Parent = Holder,
            })
            Register(Track, {BackgroundColor3 = "Track"})
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Track})
            local Fill = New("Frame", {
                BackgroundColor3 = MeizuLibrary.Accent,
                Size = UDim2.new(0, 0, 1, 0), BorderSizePixel = 0, Parent = Track,
            })
            RegisterAccent(Fill, "BackgroundColor3")
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Fill})
            local Knob = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.fromOffset(14, 14),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0, ZIndex = 3, Parent = Holder,
            })
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Knob})
            local KnobStroke = New("UIStroke", {Color = MeizuLibrary.Accent, Thickness = 2, Parent = Knob})
            RegisterAccent(KnobStroke, "Color")

            local function Snap(v)
                v = math.clamp(v, min, max)
                if increment then
                    v = math.clamp(min + math.floor((v - min) / increment + 0.5) * increment, min, max)
                end
                if rounding > 0 then
                    local m = 10 ^ rounding
                    v = math.floor(v * m + 0.5) / m
                elseif not increment then
                    v = math.floor(v + 0.5)
                end
                return v
            end
            local function Format(v)
                if rounding > 0 then return string.format("%." .. rounding .. "f", v) end
                if v % 1 ~= 0 then return string.format("%.2f", v) end
                return tostring(math.floor(v + 0.5))
            end

            local value = Snap(tonumber(cfg.Default) or min)
            local function Set(v, fire)
                v = Snap(tonumber(v) or min)
                value = v
                local pct = math.clamp((v - min) / (max - min), 0, 1)
                Fill.Size = UDim2.new(pct, 0, 1, 0)
                Knob.Position = UDim2.new(pct, 0, 0.5, 0)
                ValueLabel.Text = Format(v) .. suffix
                if cfg.Flag then SetFlag(cfg.Flag, v) end
                if fire then SafeCall(cfg.Callback, v) end
            end

            local dragging = false
            local releaseGuard = nil
            local function UpdateFromPointer(p)
                local pct = math.clamp((p.X - Track.AbsolutePosition.X) / math.max(Track.AbsoluteSize.X, 1), 0, 1)
                local nv = Snap(min + (max - min) * pct)
                if nv ~= value then Set(nv, true) end      -- không bắn callback khi giá trị không đổi
            end
            Holder.InputBegan:Connect(function(input)
                if not IsPointer(input) then return end
                dragging = true
                releaseGuard = BeginGuard(Card)
                Tween(Knob, 0.15, {Size = UDim2.fromOffset(18, 18)})
                UpdateFromPointer(PointerPos(input))
                AddDrag(input, {
                    OnChanged = function(inp)
                        if dragging then UpdateFromPointer(PointerPos(inp)) end
                    end,
                    OnEnd = function()
                        dragging = false
                        if releaseGuard then releaseGuard() releaseGuard = nil end
                        Tween(Knob, 0.2, {Size = UDim2.fromOffset(14, 14)})
                    end,
                })
            end)

            local el = {Frame = Card, Get = function() return value end, Set = function(v, fire) Set(v, fire) end}
            Set(value, false)
            BindFlag(el, cfg.Flag, value)
            local rec = AddSearch(Card, cfg.Title, cfg.Description)
            return Decorate(el, Card, rec, cfg)
        end

        --// DROPDOWN / MULTI DROPDOWN
        local function MakeDropdown(cfg, multi)
            cfg = cfg or {}
            local options = {}
            if type(cfg.Options) == "table" then
                for _, v in ipairs(cfg.Options) do table.insert(options, v) end
            end
            local hasDesc = cfg.Description ~= nil
            local headH = hasDesc and 58 or 42
            local Card = MakeCard(headH, true)
            AddText(Card, cfg.Title or "Dropdown", cfg.Description, 196, headH)

            local SelectedLabel = TextObj("TextLabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -38, 0, hasDesc and 8 or 0),
                Size = UDim2.new(0, 150, 0, hasDesc and 20 or headH),
                TextColor3 = T("SubText"),
                TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Text = "", Parent = Card,
            }, "Regular", 12)
            Register(SelectedLabel, {TextColor3 = "SubText"})

            -- Mũi tên "v": tâm cố định ở hàng đầu (bản cũ để AnchorPoint ở mép phải nên xoay là bị lệch,
            -- và neo theo 0.5 của cả thẻ nên khi mở danh sách mũi tên trôi xuống)
            local Arrow = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(1, -20, 0, hasDesc and 18 or (headH / 2)),
                Size = UDim2.fromOffset(12, 12),
                BackgroundTransparency = 1, Parent = Card,
            })
            for i, rot in ipairs({-45, 45}) do
                local bar = New("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5 + (i == 1 and -0.18 or 0.18), 0, 0.5, 0),
                    Size = UDim2.fromOffset(2, 7),
                    Rotation = rot,
                    BackgroundColor3 = T("SubText"),
                    BorderSizePixel = 0, Parent = Arrow,
                })
                Register(bar, {BackgroundColor3 = "SubText"})
            end

            local open = false
            local listH = 0
            local function CalcListH() listH = math.min(#options * 28 + 10, 164) end
            CalcListH()

            local selected
            if multi then
                selected = {}
                if type(cfg.Default) == "table" then
                    for _, v in ipairs(cfg.Default) do selected[v] = true end
                end
            else
                selected = cfg.Default
            end

            local List = New("ScrollingFrame", {
                BackgroundColor3 = T("Dropdown"),
                Position = UDim2.new(0, 10, 0, headH + 2),
                Size = UDim2.new(1, -20, 0, 0),
                CanvasSize = UDim2.new(),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 3, ScrollBarImageTransparency = 0.4,
                Visible = false, ClipsDescendants = true,
                BorderSizePixel = 0, ZIndex = 8, Parent = Card,
            })
            Register(List, {BackgroundColor3 = "Dropdown"})
            RegisterAccent(List, "ScrollBarImageColor3")
            New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = List})
            New("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = List})
            New("UIPadding", {
                PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = List})

            local OptionBtns = {}
            local OptValues = {}
            local SetOpen, Refresh

            local function GetSelected()
                if multi then
                    local list = {}
                    for k in pairs(selected) do table.insert(list, k) end
                    table.sort(list, function(x, y) return tostring(x) < tostring(y) end)
                    return list
                end
                return selected
            end

            local function IsSelected(value)
                if multi then return selected[value] == true end
                return selected ~= nil and tostring(selected) == tostring(value)
            end

            SetOpen = function(v)
                if not Card.Parent then return end
                open = v
                List.Visible = true
                Tween(Card, 0.28, {Size = UDim2.new(1, 0, 0, headH + (v and (listH + 8) or 0))}, Enum.EasingStyle.Quint)
                Tween(List, 0.28, {Size = UDim2.new(1, -20, 0, v and listH or 0)}, Enum.EasingStyle.Quint)
                Tween(Arrow, 0.25, {Rotation = v and 180 or 0})
                if v then
                    for i, Opt in ipairs(OptionBtns) do
                        Opt.TextTransparency = 1
                        task.delay(i * 0.02, function()
                            if Opt.Parent then Tween(Opt, 0.15, {TextTransparency = 0}) end
                        end)
                    end
                else
                    task.delay(0.3, function()
                        if not open and List.Parent then List.Visible = false end
                    end)
                end
            end

            Refresh = function(fire)
                if not Card.Parent then return end
                if multi then
                    local names = {}
                    for _, opt in ipairs(options) do
                        if selected[opt] then table.insert(names, tostring(opt)) end
                    end
                    SelectedLabel.Text = (#names > 0) and table.concat(names, ", ") or L("Select...")
                else
                    SelectedLabel.Text = (selected ~= nil) and tostring(selected) or L("Select...")
                end
                for _, Opt in ipairs(OptionBtns) do
                    local isSel = IsSelected(OptValues[Opt])
                    if multi then
                        local d = Opt:FindFirstChild("Dot")
                        if d then
                            Tween(d, 0.2, {
                                BackgroundTransparency = isSel and 0 or 1,
                                Size = UDim2.fromOffset(isSel and 10 or 6, isSel and 10 or 6),
                            })
                        end
                    end
                    Tween(Opt, 0.2, {TextColor3 = isSel and MeizuLibrary.Accent or T("Text")})
                end
                if cfg.Flag then SetFlag(cfg.Flag, GetSelected()) end
                if fire then SafeCall(cfg.Callback, GetSelected()) end
            end

            local function BuildOptions()
                for _, c in ipairs(OptionBtns) do c:Destroy() end
                OptionBtns = {}
                OptValues = {}
                for i, optName in ipairs(options) do
                    local Opt = TextObj("TextButton", {
                        Text = tostring(optName), AutoButtonColor = false,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 26),
                        TextColor3 = T("Text"),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 9, LayoutOrder = i,
                        BorderSizePixel = 0, Parent = List,
                    }, "Regular", 12)
                    New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Opt})
                    New("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 24), Parent = Opt})
                    OptValues[Opt] = optName
                    if multi then
                        local Dot = New("Frame", {
                            Name = "Dot",
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.new(1, 14, 0.5, 0),
                            Size = UDim2.fromOffset(6, 6),
                            BackgroundColor3 = MeizuLibrary.Accent,
                            BackgroundTransparency = 1,
                            ZIndex = 10, BorderSizePixel = 0, Parent = Opt,
                        })
                        RegisterAccent(Dot, "BackgroundColor3")
                        New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Dot})
                    end
                    Opt.MouseEnter:Connect(function() Tween(Opt, 0.12, {BackgroundTransparency = 0.92}) end)
                    Opt.MouseLeave:Connect(function() Tween(Opt, 0.2, {BackgroundTransparency = 1}) end)
                    Opt.Activated:Connect(function()
                        if multi then
                            if selected[optName] then selected[optName] = nil else selected[optName] = true end
                        else
                            selected = optName
                        end
                        Refresh(true)
                        if not multi then SetOpen(false) end
                    end)
                    table.insert(OptionBtns, Opt)
                end
            end

            Card.Activated:Connect(function() SetOpen(not open) end)
            BuildOptions()
            Refresh(false)
            OnThemeChange(function() Refresh(false) end)
            OnLangChange(function() Refresh(false) end)
            OnAccentChange(function()      -- đổi màu trực tiếp (không tween) để Rainbow không bị nặng
                if not Card.Parent then return end
                for _, Opt in ipairs(OptionBtns) do
                    if IsSelected(OptValues[Opt]) then Opt.TextColor3 = MeizuLibrary.Accent end
                end
            end)

            local el = {
                Frame = Card,
                Get = GetSelected,
                Set = function(v, fire)
                    if multi then
                        selected = {}
                        if type(v) == "table" then
                            for _, x in ipairs(v) do selected[x] = true end
                        end
                    else
                        selected = v
                    end
                    Refresh(fire == true)
                end,
            }

            -- Cập nhật danh sách option động (hỗ trợ cả dd:Refresh(list) lẫn dd.Refresh(list))
            local function UpdateOptions(newOptions)
                if not Card.Parent then return end
                if newOptions == nil then newOptions = options end
                local copy = {}
                if type(newOptions) == "table" then
                    for _, v in ipairs(newOptions) do table.insert(copy, v) end
                end
                options = copy

                -- bỏ lựa chọn không còn tồn tại trong list mới
                local valid = {}
                for _, v in ipairs(options) do valid[v] = true end
                if multi then
                    for k in pairs(selected) do
                        if not valid[k] then selected[k] = nil end
                    end
                elseif selected ~= nil and not valid[selected] then
                    selected = nil
                end

                CalcListH()
                BuildOptions()
                Refresh(false)

                -- nếu đang mở thì co/giãn lại cho khớp list mới
                if open then
                    Tween(Card, 0.2, {Size = UDim2.new(1, 0, 0, headH + listH + 8)}, Enum.EasingStyle.Quint)
                    Tween(List, 0.2, {Size = UDim2.new(1, -20, 0, listH)}, Enum.EasingStyle.Quint)
                end
            end

            local function ArgOf(x, y)
                if x == el then return y end    -- gọi bằng dấu ":" thì tham số đầu là chính el
                return x
            end

            el.UpdateOptions = function(x, y) UpdateOptions(ArgOf(x, y)) end
            el.Refresh       = el.UpdateOptions
            el.SetOptions    = el.UpdateOptions
            el.GetOptions    = function() return options end
            el.AddOption = function(x, y)
                local opt = ArgOf(x, y)
                if opt == nil then return end
                local list = {}
                for _, v in ipairs(options) do table.insert(list, v) end
                table.insert(list, opt)
                UpdateOptions(list)
            end
            el.RemoveOption = function(x, y)
                local opt = ArgOf(x, y)
                local list = {}
                for _, v in ipairs(options) do
                    if v ~= opt then table.insert(list, v) end
                end
                UpdateOptions(list)
            end
            el.Clear = function() UpdateOptions({}) end

            BindFlag(el, cfg.Flag, GetSelected())
            local rec = AddSearch(Card, cfg.Title, cfg.Description)
            return Decorate(el, Card, rec, cfg)
        end

        function target:CreateDropdown(cfg) return MakeDropdown(cfg, false) end
        function target:CreateMultiDropdown(cfg) return MakeDropdown(cfg, true) end

        --// KEYBIND
        function target:CreateKeybind(cfg)
            cfg = cfg or {}
            local hasDesc = cfg.Description ~= nil
            local Card = MakeCard(hasDesc and 58 or 42, false)
            AddText(Card, cfg.Title or "Keybind", cfg.Description, 130)

            local function ToKey(v)
                if typeof(v) == "EnumItem" then return v end
                if type(v) == "string" and v ~= "" and v ~= "None" then
                    local okK, key = pcall(function() return Enum.KeyCode[v] end)
                    if okK then return key end
                end
                return nil
            end

            local currentKey = ToKey(cfg.Default)
            local listening = false

            local BindBtn = TextObj("TextButton", {
                Text = "", AutoButtonColor = false,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -14, 0.5, 0),
                Size = UDim2.fromOffset(100, 28),
                BackgroundColor3 = T("Input"),
                TextColor3 = T("SubText"),
                BorderSizePixel = 0, Parent = Card,
            }, "Medium", 12)
            Register(BindBtn, {BackgroundColor3 = "Input"})
            New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = BindBtn})
            local BindStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.5, Parent = BindBtn})
            Register(BindStroke, {Color = "Stroke"})

            local function ShowKey()
                if listening then return end
                BindBtn.Text = currentKey and currentKey.Name or L("None")
            end
            ShowKey()
            OnLangChange(ShowKey)

            BindBtn.MouseEnter:Connect(function() Tween(BindBtn, 0.15, {TextColor3 = T("Text")}) end)
            BindBtn.MouseLeave:Connect(function() Tween(BindBtn, 0.2, {TextColor3 = T("SubText")}) end)
            BindBtn.Activated:Connect(function()
                if listening then return end
                listening = true
                BindBtn.Text = "..."
                Tween(BindStroke, 0.15, {Color = MeizuLibrary.Accent, Transparency = 0.1})
            end)

            local function Commit(key, fireChanged)
                currentKey = key
                if cfg.Flag then SetFlag(cfg.Flag, key and key.Name or "None") end
                if fireChanged then SafeCall(cfg.ChangedCallback, key) end
            end

            -- MỘT handler duy nhất cho cả "đang gán phím" và "phím kích hoạt"
            -- (bản cũ dùng 2 handler nên bấm gán xong là callback bị gọi luôn)
            local triggerConn = UserInputService.InputBegan:Connect(function(input, gp)
                if listening then
                    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
                    listening = false
                    Tween(BindStroke, 0.2, {Color = T("Stroke"), Transparency = 0.5})
                    if input.KeyCode == Enum.KeyCode.Escape then
                        -- hủy gán
                    elseif input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
                        Commit(nil, true)
                    else
                        Commit(input.KeyCode, true)
                    end
                    ShowKey()
                    return
                end
                if gp then return end
                if UserInputService:GetFocusedTextBox() then return end
                if input.UserInputType == Enum.UserInputType.Keyboard and currentKey and input.KeyCode == currentKey then
                    SafeCall(cfg.Callback, currentKey)
                end
            end)
            table.insert(MeizuLibrary._Connections, triggerConn)

            local el = {
                Frame = Card,
                Get = function() return currentKey and currentKey.Name or "None" end,
                Set = function(v)
                    Commit(ToKey(v), true)
                    ShowKey()
                end,
            }
            BindFlag(el, cfg.Flag, el.Get())
            local rec = AddSearch(Card, cfg.Title, cfg.Description)
            return Decorate(el, Card, rec, cfg)
        end

        --// INPUT
        function target:CreateInput(cfg)
            cfg = cfg or {}
            local hasDesc = cfg.Description ~= nil
            local Card = MakeCard(hasDesc and 58 or 42, false)
            AddText(Card, cfg.Title or "Input", cfg.Description, 206)

            local Box = TextObj("TextBox", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -14, 0.5, 0),
                Size = UDim2.fromOffset(170, 28),
                BackgroundColor3 = T("Input"),
                Text = tostring(cfg.Default or ""),
                PlaceholderText = "",
                PlaceholderColor3 = T("Placeholder"),
                TextColor3 = T("Text"),
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false, ClipsDescendants = true,
                BorderSizePixel = 0, Parent = Card,
            }, "Regular", 12)
            Register(Box, {BackgroundColor3 = "Input", PlaceholderColor3 = "Placeholder", TextColor3 = "Text"})
            BindLoc(Box, "PlaceholderText", tostring(cfg.Placeholder or "Type here..."))
            New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Box})
            New("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = Box})
            local BoxStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.5, Parent = Box})
            Register(BoxStroke, {Color = "Stroke"})

            if cfg.Numeric then
                local allowed = "%d"
                if cfg.AllowDecimal then allowed = allowed .. "%." end
                if cfg.AllowNegative then allowed = allowed .. "%-" end
                local pattern = "[^" .. allowed .. "]"
                Box:GetPropertyChangedSignal("Text"):Connect(function()
                    local cleaned = string.gsub(Box.Text, pattern, "")
                    if cleaned ~= Box.Text then Box.Text = cleaned end
                end)
            end
            if cfg.Flag then
                Box:GetPropertyChangedSignal("Text"):Connect(function()
                    SetFlag(cfg.Flag, Box.Text)
                end)
            end

            Box.Focused:Connect(function()
                Tween(Box, 0.2, {Size = UDim2.fromOffset(190, 30)})
                Tween(BoxStroke, 0.2, {Color = MeizuLibrary.Accent, Transparency = 0.1})
            end)
            -- FIX mobile: lưu giá trị cả khi bấm ra ngoài (enter = false), không chỉ khi nhấn Enter
            Box.FocusLost:Connect(function(enter)
                Tween(Box, 0.2, {Size = UDim2.fromOffset(170, 28)})
                Tween(BoxStroke, 0.25, {Color = T("Stroke"), Transparency = 0.5})
                if cfg.Flag then SetFlag(cfg.Flag, Box.Text) end
                SafeCall(cfg.Callback, Box.Text, enter)
            end)

            local el = {
                Frame = Card,
                Get = function() return Box.Text end,
                Set = function(v, fire)
                    Box.Text = tostring(v == nil and "" or v)
                    if cfg.Flag then SetFlag(cfg.Flag, Box.Text) end
                    if fire then SafeCall(cfg.Callback, Box.Text, false) end
                end,
            }
            BindFlag(el, cfg.Flag, Box.Text)
            local rec = AddSearch(Card, cfg.Title, cfg.Description)
            return Decorate(el, Card, rec, cfg)
        end

        --// COLOR PICKER (kéo được cả ô đậm/nhạt trên mọi thiết bị)
        function target:CreateColorPicker(cfg)
            cfg = cfg or {}
            local hasDesc = cfg.Description ~= nil
            local headH = hasDesc and 58 or 42
            local panelY = headH + 4
            local PANEL_H = 138
            local Card = MakeCard(headH, false)

            -- Header bấm mở/đóng (không đè lên panel màu)
            local Header = New("TextButton", {
                Text = "", AutoButtonColor = false, BackgroundTransparency = 1,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(1, 0, 0, headH),
                ZIndex = 2, BorderSizePixel = 0, Parent = Card,
            })
            New("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Header})
            Header.MouseEnter:Connect(function() Tween(Header, 0.15, {BackgroundTransparency = 0.94}) end)
            Header.MouseLeave:Connect(function() Tween(Header, 0.2, {BackgroundTransparency = 1}) end)

            AddText(Card, cfg.Title or "Color", cfg.Description, 130, headH)

            local h, s, v = Color3.toHSV(cfg.Default or MeizuLibrary.Accent)
            local color = Color3.fromHSV(h, s, v)

            -- Swatch + mã màu: neo bằng pixel ở hàng đầu để không trôi xuống khi bảng màu mở ra
            local Swatch = New("TextButton", {
                Text = "", AutoButtonColor = false,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -14, 0, headH / 2),
                Size = UDim2.fromOffset(36, 22),
                BackgroundColor3 = color,
                ZIndex = 3, BorderSizePixel = 0, Parent = Card,
            })
            New("UICorner", {CornerRadius = UDim.new(0, 7), Parent = Swatch})
            local SwStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.2, Parent = Swatch})
            Register(SwStroke, {Color = "Stroke"})

            local HexLabel = TextObj("TextLabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -58, 0, headH / 2),
                Size = UDim2.fromOffset(70, 20),
                TextColor3 = T("SubText"), TextXAlignment = Enum.TextXAlignment.Right,
                Text = "", ZIndex = 3, Parent = Card,
            }, "Regular", 11)
            Register(HexLabel, {TextColor3 = "SubText"})

            local Panel = New("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, panelY),
                Size = UDim2.new(1, -28, 0, 0),
                Visible = false, ClipsDescendants = true,
                BorderSizePixel = 0, Parent = Card,
            })

            -- Ô SV (đậm/nhạt)
            local SV = New("Frame", {
                Size = UDim2.new(1, 0, 0, 88),
                BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                ClipsDescendants = true, BorderSizePixel = 0,
                Active = true, ZIndex = 3, Parent = Panel,
            })
            New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = SV})
            local GW = New("Frame", {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255), Size = UDim2.fromScale(1, 1),
                BorderSizePixel = 0, ZIndex = 4, Parent = SV,
            })
            New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = GW})
            New("UIGradient", {Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}), Parent = GW})
            local GB = New("Frame", {
                BackgroundColor3 = Color3.fromRGB(0, 0, 0), Size = UDim2.fromScale(1, 1),
                BorderSizePixel = 0, ZIndex = 5, Parent = SV,
            })
            New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = GB})
            New("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}), Parent = GB})
            local SVKnob = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.fromOffset(12, 12),
                BackgroundTransparency = 1, ZIndex = 6, Parent = SV,
            })
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SVKnob})
            New("UIStroke", {Color = Color3.new(1, 1, 1), Thickness = 2, Parent = SVKnob})

            -- Thanh Hue (màu)
            local HueBar = New("Frame", {
                Position = UDim2.new(0, 0, 0, 96),
                Size = UDim2.new(1, 0, 0, 12),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0, Active = true, ZIndex = 3, Parent = Panel,
            })
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = HueBar})
            New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
                }),
                Parent = HueBar,
            })
            local HueKnob = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(h, 0, 0.5, 0),
                Size = UDim2.fromOffset(5, 18),
                BackgroundColor3 = Color3.new(1, 1, 1),
                ZIndex = 4, BorderSizePixel = 0, Parent = HueBar,
            })
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = HueKnob})
            New("UIStroke", {Color = Color3.fromRGB(0, 0, 0), Thickness = 1, Transparency = 0.6, Parent = HueKnob})

            local function Apply(fire)
                color = Color3.fromHSV(h, s, v)
                SV.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                Swatch.BackgroundColor3 = color
                SVKnob.Position = UDim2.new(s, 0, 1 - v, 0)
                HueKnob.Position = UDim2.new(h, 0, 0.5, 0)
                HexLabel.Text = string.format("#%02X%02X%02X",
                    math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
                if cfg.Flag then SetFlag(cfg.Flag, color) end
                if fire then SafeCall(cfg.Callback, color) end
            end

            -- Kéo bằng toạ độ con trỏ cùng hệ với AbsolutePosition (PointerPos) -> không lệch trục Y
            local draggingKind = nil
            local dragSession = nil
            local releaseGuard = nil

            local function UpdateSV(p)
                s = math.clamp((p.X - SV.AbsolutePosition.X) / math.max(SV.AbsoluteSize.X, 1), 0, 1)
                v = 1 - math.clamp((p.Y - SV.AbsolutePosition.Y) / math.max(SV.AbsoluteSize.Y, 1), 0, 1)
                Apply(true)
            end
            local function UpdateHue(p)
                h = math.clamp((p.X - HueBar.AbsolutePosition.X) / math.max(HueBar.AbsoluteSize.X, 1), 0, 1)
                Apply(true)
            end
            local function SessionAlive(session)
                for _, d in ipairs(MeizuLibrary._ActiveDrags) do
                    if d == session then return true end
                end
                return false
            end

            local function StartDrag(kind, input)
                if not IsPointer(input) then return end
                if dragSession and SessionAlive(dragSession) then return end   -- 1 lần chạm có thể bắn nhiều InputBegan
                draggingKind = kind
                releaseGuard = BeginGuard(Card)
                if kind == "sv" then UpdateSV(PointerPos(input)) else UpdateHue(PointerPos(input)) end
                dragSession = AddDrag(input, {
                    OnChanged = function(inp)
                        if draggingKind == "sv" then
                            UpdateSV(PointerPos(inp))
                        elseif draggingKind == "hue" then
                            UpdateHue(PointerPos(inp))
                        end
                    end,
                    OnEnd = function()
                        draggingKind = nil
                        dragSession = nil
                        if releaseGuard then releaseGuard() releaseGuard = nil end
                    end,
                })
            end

            SV.InputBegan:Connect(function(input) StartDrag("sv", input) end)
            GW.InputBegan:Connect(function(input) StartDrag("sv", input) end)
            GB.InputBegan:Connect(function(input) StartDrag("sv", input) end)
            HueBar.InputBegan:Connect(function(input) StartDrag("hue", input) end)

            -- Màu có sẵn (có thêm Gold hợp với theme Obsidian)
            local presets = {
                Color3.fromRGB(255, 255, 255), Color3.fromRGB(180, 180, 190), Color3.fromRGB(30, 30, 35),
                Color3.fromRGB(255, 86, 86),   Color3.fromRGB(255, 165, 60),  Color3.fromRGB(255, 220, 90),
                Color3.fromRGB(212, 175, 55),  Color3.fromRGB(90, 220, 120),  Color3.fromRGB(88, 101, 242),
                Color3.fromRGB(170, 90, 255),
            }
            local PresetRow = New("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 118),
                Size = UDim2.new(1, 0, 0, 18),
                BorderSizePixel = 0, Parent = Panel,
            })
            New("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), Parent = PresetRow})
            for _, preset in ipairs(presets) do
                local p = New("TextButton", {
                    Text = "", AutoButtonColor = false,
                    Size = UDim2.fromOffset(18, 18),
                    BackgroundColor3 = preset, BorderSizePixel = 0, ZIndex = 3, Parent = PresetRow,
                })
                New("UICorner", {CornerRadius = UDim.new(0, 5), Parent = p})
                local pStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.3, Parent = p})
                Register(pStroke, {Color = "Stroke"})
                p.Activated:Connect(function()
                    h, s, v = Color3.toHSV(preset)
                    Apply(true)
                end)
            end

            local open = false
            local function TogglePanel()
                if not Card.Parent then return end
                open = not open
                Panel.Visible = true
                Tween(Card, 0.3, {Size = UDim2.new(1, 0, 0, open and (panelY + PANEL_H + 8) or headH)}, Enum.EasingStyle.Quint)
                Tween(Panel, 0.3, {Size = UDim2.new(1, -28, 0, open and PANEL_H or 0)}, Enum.EasingStyle.Quint)
                if not open then
                    task.delay(0.32, function()
                        if not open and Panel.Parent then Panel.Visible = false end
                    end)
                end
            end
            Header.Activated:Connect(TogglePanel)
            Swatch.Activated:Connect(TogglePanel)

            local el = {
                Frame = Card,
                Get = function() return color end,
                Set = function(c, fire)
                    if typeof(c) == "Color3" then
                        h, s, v = Color3.toHSV(c)
                        Apply(fire == true)
                    end
                end,
            }
            Apply(false)
            BindFlag(el, cfg.Flag, color)
            local rec = AddSearch(Card, cfg.Title, cfg.Description)
            return Decorate(el, Card, rec, cfg)
        end

        --// PARAGRAPH (bố cục chiều cao tính thủ công, hỗ trợ RichText)
        function target:CreateParagraph(cfg)
            cfg = cfg or {}
            local PAD_X, PAD_T, PAD_B, GAP = 14, 12, 12, 4
            local Card = MakeCard(44, false)
            Card.ClipsDescendants = false

            New("UIPadding", {
                PaddingTop = UDim.new(0, PAD_T), PaddingBottom = UDim.new(0, PAD_B),
                PaddingLeft = UDim.new(0, PAD_X), PaddingRight = UDim.new(0, PAD_X),
                Parent = Card,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, GAP),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = Card,
            })

            local TitleLabel, ContentLabel, titleBind, contentBind, contentTheme
            local rec                                   -- gán sau khi AddSearch (closure bên dưới dùng tới)

            if cfg.Title ~= nil then
                TitleLabel = TextObj("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = "", TextColor3 = T("Text"),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    TextWrapped = true, RichText = false,
                    Size = UDim2.new(1, 0, 0, 18),
                    LayoutOrder = 1, Parent = Card,
                }, "Bold", 13)
                Register(TitleLabel, {TextColor3 = "Text"})
                titleBind = BindLoc(TitleLabel, "Text", tostring(cfg.Title))
            end

            if cfg.Content ~= nil then
                ContentLabel = TextObj("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = "", TextColor3 = T("SubText"),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    TextWrapped = true, RichText = true,
                    Size = UDim2.new(1, 0, 0, 16),
                    LayoutOrder = 2, Parent = Card,
                }, "Regular", 12)
                contentTheme = Register(ContentLabel, {TextColor3 = "SubText"})
                contentBind = BindLoc(ContentLabel, "Text", tostring(cfg.Content))
            end

            local function ApplyLayout()
                if not Card.Parent then return end
                local width = math.max(120, Card.AbsoluteSize.X / GuiScale() - (PAD_X * 2))
                local titleH, contentH = 0, 0
                if TitleLabel then
                    titleH = MeasureText(TitleLabel.Text, "Bold", 13, width)
                    TitleLabel.Size = UDim2.new(1, 0, 0, titleH)
                end
                if ContentLabel then
                    contentH = MeasureText(ContentLabel.Text, "Regular", 12, width) + 2
                    ContentLabel.Size = UDim2.new(1, 0, 0, contentH)
                end
                local total = PAD_T + titleH + contentH + PAD_B
                if TitleLabel and ContentLabel then total = total + GAP end
                Card.Size = UDim2.new(1, 0, 0, math.max(40, total))
            end

            local element = {Frame = Card, TitleLabel = TitleLabel, ContentLabel = ContentLabel}

            element.SetTitle = function(x, y)
                local text = ArgAfterSelf(element, x, y)
                if titleBind and TitleLabel and TitleLabel.Parent then
                    titleBind.Key = tostring(text == nil and "" or text)
                    RefreshBinding(titleBind)
                    rec.Title = titleBind.Key
                    rec.Text = SearchText(rec.Title, rec.Desc)
                    ApplyLayout()
                end
            end

            -- SetContent(text [, color]) — gọi bằng "." hay ":" đều được
            element.SetContent = function(x, y, z)
                local text, textColor
                if x == element then text, textColor = y, z else text, textColor = x, y end
                if contentBind and ContentLabel and ContentLabel.Parent then
                    local newText = tostring(text == nil and "" or text)
                    if contentBind.Key ~= newText then
                        contentBind.Key = newText
                        RefreshBinding(contentBind)
                        rec.Desc = newText
                        rec.Text = SearchText(rec.Title, rec.Desc)
                        ApplyLayout()
                    end
                    if textColor then
                        ContentLabel.TextColor3 = textColor
                        contentTheme.Map = {}       -- ngừng để theme ghi đè màu chữ tuỳ chỉnh
                    end
                end
            end
            element.Get = function() return ContentLabel and contentBind.Key or "" end
            element.Set = function(text) element.SetContent(text) end

            rec = AddSearch(Card, cfg.Title, cfg.Content)

            -- Đo lại khi chiều rộng thật của thẻ đã có / khi đổi phông / ngôn ngữ
            local lastWidth = 0
            Card:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                local width = Card.AbsoluteSize.X
                if math.abs(width - lastWidth) > 0.5 then
                    lastWidth = width
                    task.defer(ApplyLayout)
                end
            end)
            OnFontChange(ApplyLayout)
            OnLangChange(ApplyLayout)
            task.defer(ApplyLayout)
            return Decorate(element, Card, rec, cfg)
        end

        --// SEGMENTED — nút chọn dạng "giọt kính" trượt giữa các lựa chọn (kiểu iOS)
        function target:CreateSegmented(cfg)
            cfg = cfg or {}
            local options = {}
            if type(cfg.Options) == "table" then
                for _, v in ipairs(cfg.Options) do table.insert(options, v) end
            end
            local n = math.max(#options, 1)
            local hasDesc = cfg.Description ~= nil
            local Card = MakeCard(hasDesc and 98 or 82, false)
            AddText(Card, cfg.Title or "Segmented", cfg.Description, 14, nil, true)

            local Bar = New("Frame", {
                BackgroundColor3 = T("Input"),
                AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 14, 1, -12),
                Size = UDim2.new(1, -28, 0, 34), BorderSizePixel = 0, Parent = Card,
            })
            Register(Bar, {BackgroundColor3 = "Input"})
            New("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Bar})
            local BarStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.45, Parent = Bar})
            Register(BarStroke, {Color = "Stroke"})
            local Inner = New("Frame", {
                BackgroundTransparency = 1, Position = UDim2.new(0, 3, 0, 3), Size = UDim2.new(1, -6, 1, -6),
                BorderSizePixel = 0, Parent = Bar,
            })

            -- "Giọt kính" trượt với hiệu ứng nảy nhẹ
            local Thumb = New("Frame", {
                BackgroundColor3 = MeizuLibrary.Accent,
                Size = UDim2.new(1 / n, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0),
                BorderSizePixel = 0, ZIndex = 2, Parent = Inner,
            })
            RegisterAccent(Thumb, "BackgroundColor3")
            New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Thumb})
            New("UIGradient", {
                Rotation = 90,
                Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(196, 196, 210)),
                Parent = Thumb,
            })
            New("UIStroke", {Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Transparency = 0.72, Parent = Thumb})
            local ThumbSheen = New("Frame", {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(1, 0, 0.5, 0), BorderSizePixel = 0, ZIndex = 3, Parent = Thumb,
            })
            New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ThumbSheen})
            New("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.72), NumberSequenceKeypoint.new(1, 1)}),
                Parent = ThumbSheen,
            })

            local buttons = {}
            local index = 1
            local function IndexOf(v)
                for i, o in ipairs(options) do
                    if tostring(o) == tostring(v) then return i end
                end
                return nil
            end
            local function Style(animate)
                for i, B in ipairs(buttons) do
                    local color = (i == index) and Color3.fromRGB(255, 255, 255) or T("SubText")
                    if animate then Tween(B, 0.2, {TextColor3 = color}) else B.TextColor3 = color end
                end
            end
            local function Select(i, fire, animate)
                if i < 1 or i > #options then return end
                index = i
                local pos = UDim2.new((i - 1) / n, 0, 0, 0)
                if animate == false then Thumb.Position = pos else Tween(Thumb, 0.4, {Position = pos}, Enum.EasingStyle.Back) end
                Style(animate ~= false)
                if cfg.Flag then SetFlag(cfg.Flag, options[i]) end
                if fire then SafeCall(cfg.Callback, options[i]) end
            end

            for i, opt in ipairs(options) do
                local B = TextObj("TextButton", {
                    Text = tostring(opt), AutoButtonColor = false, BackgroundTransparency = 1,
                    Position = UDim2.new((i - 1) / n, 0, 0, 0), Size = UDim2.new(1 / n, 0, 1, 0),
                    TextColor3 = T("SubText"), TextTruncate = Enum.TextTruncate.AtEnd,
                    ZIndex = 4, BorderSizePixel = 0, Parent = Inner,
                }, "Medium", 12)
                buttons[i] = B
                B.Activated:Connect(function()
                    if index ~= i then Select(i, true) end
                end)
            end

            index = IndexOf(cfg.Default) or 1
            Thumb.Position = UDim2.new((index - 1) / n, 0, 0, 0)
            Style(false)
            OnThemeChange(function() Style(false) end)

            local el = {
                Frame = Card,
                Get = function() return options[index] end,
                Set = function(v, fire)
                    local i = IndexOf(v)
                    if i then Select(i, fire == true) end
                end,
            }
            BindFlag(el, cfg.Flag, options[index])
            local rec = AddSearch(Card, cfg.Title, cfg.Description)
            return Decorate(el, Card, rec, cfg)
        end

        --// PROGRESS — thanh tiến độ chỉ đọc (vd: tiến độ quest, thời gian còn lại)
        function target:CreateProgress(cfg)
            cfg = cfg or {}
            local min, max = tonumber(cfg.Min) or 0, tonumber(cfg.Max) or 100
            if max <= min then max = min + 1 end
            local hasDesc = cfg.Description ~= nil
            local Card = MakeCard(hasDesc and 72 or 56, false)
            AddText(Card, cfg.Title or "Progress", cfg.Description, 120, nil, true)

            local ValueLabel = TextObj("TextLabel", {
                BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -14, 0, 8), Size = UDim2.fromOffset(110, 20),
                TextColor3 = T("Text"), TextXAlignment = Enum.TextXAlignment.Right,
                Text = "", Parent = Card,
            }, "Bold", 12)
            Register(ValueLabel, {TextColor3 = "Text"})

            local Track = New("Frame", {
                BackgroundColor3 = T("Track"), AnchorPoint = Vector2.new(0, 1),
                Position = UDim2.new(0, 14, 1, -14), Size = UDim2.new(1, -28, 0, 8),
                BorderSizePixel = 0, Parent = Card,
            })
            Register(Track, {BackgroundColor3 = "Track"})
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Track})
            local Fill = New("Frame", {
                BackgroundColor3 = MeizuLibrary.Accent, Size = UDim2.new(0, 0, 1, 0),
                BorderSizePixel = 0, Parent = Track,
            })
            RegisterAccent(Fill, "BackgroundColor3")
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Fill})
            New("UIGradient", {
                Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 0)}),
                Parent = Fill,
            })

            local value = math.clamp(tonumber(cfg.Default) or min, min, max)
            local customText = nil
            local function FormatText()
                if customText then return customText end
                local fmt = cfg.Format
                if type(fmt) == "function" then
                    local okF, txt = pcall(fmt, value, min, max)
                    if okF and txt ~= nil then return tostring(txt) end
                elseif fmt == "fraction" then
                    return Comma(value) .. " / " .. Comma(max)
                end
                return string.format("%d%%", math.floor((value - min) / (max - min) * 100 + 0.5))
            end
            local function Render(animate)
                local pct = math.clamp((value - min) / (max - min), 0, 1)
                local size = UDim2.new(pct, 0, 1, 0)
                if animate then Tween(Fill, 0.45, {Size = size}) else Fill.Size = size end
                ValueLabel.Text = FormatText()
            end

            local el = {Frame = Card}
            el.Get = function() return value end
            -- SetValue(v [, text]) — text tuỳ chọn thay cho phần trăm (vd "3 / 10 quái"); text = false để bỏ
            el.SetValue = function(x, y, z)
                local v, text
                if x == el then v, text = y, z else v, text = x, y end
                value = math.clamp(tonumber(v) or value, min, max)
                if text == false then customText = nil elseif text ~= nil then customText = tostring(text) end
                Render(true)
            end
            el.Set = function(v) el.SetValue(v) end
            el.SetText = function(x, y)
                local t = ArgAfterSelf(el, x, y)
                customText = (t ~= nil and t ~= false) and tostring(t) or nil
                ValueLabel.Text = FormatText()
            end
            el.SetRange = function(x, y, z)
                local a, b
                if x == el then a, b = y, z else a, b = x, y end
                min, max = tonumber(a) or min, tonumber(b) or max
                if max <= min then max = min + 1 end
                value = math.clamp(value, min, max)
                Render(false)
            end
            Render(false)
            local rec = AddSearch(Card, cfg.Title, cfg.Description)
            return Decorate(el, Card, rec, cfg)
        end

        --// STEPPER — nút − / + (giữ để tăng/giảm liên tục, càng giữ càng nhanh)
        function target:CreateStepper(cfg)
            cfg = cfg or {}
            local min, max = tonumber(cfg.Min) or 0, tonumber(cfg.Max) or 100
            if max <= min then max = min + 1 end
            local step = tonumber(cfg.Step) or 1
            if step <= 0 then step = 1 end
            local rounding = math.max(math.floor(tonumber(cfg.Rounding) or 0), 0)
            local suffix = cfg.Suffix and tostring(cfg.Suffix) or ""
            local hasDesc = cfg.Description ~= nil
            local Card = MakeCard(hasDesc and 58 or 42, false)
            AddText(Card, cfg.Title or "Stepper", cfg.Description, 144)

            local Group = New("Frame", {
                BackgroundColor3 = T("Input"), AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(124, 30),
                BorderSizePixel = 0, Parent = Card,
            })
            Register(Group, {BackgroundColor3 = "Input"})
            New("UICorner", {CornerRadius = UDim.new(0, 9), Parent = Group})
            local GroupStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.45, Parent = Group})
            Register(GroupStroke, {Color = "Stroke"})

            local function StepButton(side, plus)
                local B = New("TextButton", {
                    Text = "", AutoButtonColor = false,
                    BackgroundColor3 = T("Tab"), BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(side, 0), Position = UDim2.new(side, 0, 0, 0),
                    Size = UDim2.fromOffset(32, 30), BorderSizePixel = 0, ZIndex = 3, Parent = Group,
                })
                Register(B, {BackgroundColor3 = "Tab"})
                New("UICorner", {CornerRadius = UDim.new(0, 9), Parent = B})
                local bars = {{10, 2}}
                if plus then bars[2] = {2, 10} end
                for _, sz in ipairs(bars) do
                    local g = New("Frame", {
                        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                        Size = UDim2.fromOffset(sz[1], sz[2]), BackgroundColor3 = T("Text"),
                        BorderSizePixel = 0, ZIndex = 4, Parent = B,
                    })
                    Register(g, {BackgroundColor3 = "Text"})
                    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = g})
                end
                B.MouseEnter:Connect(function() Tween(B, 0.15, {BackgroundTransparency = 0.2}) end)
                B.MouseLeave:Connect(function() Tween(B, 0.2, {BackgroundTransparency = 1}) end)
                return B
            end
            local Minus, Plus = StepButton(0, false), StepButton(1, true)
            local ValueLabel = TextObj("TextLabel", {
                BackgroundTransparency = 1, Position = UDim2.new(0, 32, 0, 0), Size = UDim2.new(1, -64, 1, 0),
                TextColor3 = T("Text"), Text = "", ZIndex = 3, Parent = Group,
            }, "Bold", 12)
            Register(ValueLabel, {TextColor3 = "Text"})

            local function Snap(v)
                v = math.clamp(v, min, max)
                v = math.clamp(min + math.floor((v - min) / step + 0.5) * step, min, max)
                if rounding > 0 then
                    local m = 10 ^ rounding
                    v = math.floor(v * m + 0.5) / m
                end
                return v
            end
            local function Format(v)
                if rounding > 0 then return string.format("%." .. rounding .. "f", v) end
                if v % 1 ~= 0 then return string.format("%.2f", v) end
                return tostring(math.floor(v + 0.5))
            end
            local value = Snap(tonumber(cfg.Default) or min)
            local function Apply(v, fire)
                v = Snap(tonumber(v) or value)
                value = v
                ValueLabel.Text = Format(v) .. suffix
                if cfg.Flag then SetFlag(cfg.Flag, v) end
                if fire then SafeCall(cfg.Callback, v) end
            end

            local function Hold(btn, dir)
                btn.InputBegan:Connect(function(input)
                    if not IsPointer(input) then return end
                    local alive = true
                    local function Tick()
                        local nv = Snap(value + dir * step)
                        if nv ~= value then Apply(nv, true) end
                    end
                    Tick()
                    AddDrag(input, {OnEnd = function() alive = false end})
                    task.spawn(function()
                        task.wait(0.4)
                        local gap = 0.14
                        while alive and btn.Parent do
                            Tick()
                            task.wait(gap)
                            gap = math.max(0.035, gap * 0.9)
                        end
                    end)
                end)
            end
            Hold(Minus, -1)
            Hold(Plus, 1)

            local el = {Frame = Card, Get = function() return value end, Set = function(v, fire) Apply(v, fire) end}
            Apply(value, false)
            BindFlag(el, cfg.Flag, value)
            local rec = AddSearch(Card, cfg.Title, cfg.Description)
            return Decorate(el, Card, rec, cfg)
        end

        --// LABEL — dòng ghi chú (tự xuống dòng, hỗ trợ RichText), SetText(text [, color])
        function target:CreateLabel(cfg)
            if type(cfg) ~= "table" then cfg = {Text = cfg} end
            local size = tonumber(cfg.Size) or 12
            local weight = cfg.Bold and "Bold" or "Regular"
            local Holder = New("Frame", {
                BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20),
                BorderSizePixel = 0, Parent = container,
            })
            local Lbl = TextObj("TextLabel", {
                BackgroundTransparency = 1, Position = UDim2.new(0, 6, 0, 0), Size = UDim2.new(1, -12, 1, 0),
                TextColor3 = cfg.Color or T("SubText"),
                TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true, RichText = true, Text = "", Parent = Holder,
            }, weight, size)
            local theme = Register(Lbl, {TextColor3 = "SubText"})
            if cfg.Color then theme.Map = {} end
            local bind = BindLoc(Lbl, "Text", tostring(cfg.Text or ""))

            local function Layout()
                if not Holder.Parent then return end
                local width = math.max(60, Holder.AbsoluteSize.X / GuiScale() - 12)
                Holder.Size = UDim2.new(1, 0, 0, MeasureText(Lbl.Text, weight, size, width) + 4)
            end
            local lastWidth = 0
            Holder:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                if math.abs(Holder.AbsoluteSize.X - lastWidth) > 0.5 then
                    lastWidth = Holder.AbsoluteSize.X
                    task.defer(Layout)
                end
            end)
            OnFontChange(Layout)
            OnLangChange(Layout)
            task.defer(Layout)

            local el = {Frame = Holder, LabelObject = Lbl}
            el.Get = function() return bind.Key end
            el.SetText = function(x, y, z)
                local text, color
                if x == el then text, color = y, z else text, color = x, y end
                bind.Key = tostring(text == nil and "" or text)
                RefreshBinding(bind)
                if color then
                    Lbl.TextColor3 = color
                    theme.Map = {}
                end
                Layout()
            end
            el.Set = function(text) el.SetText(text) end
            local rec = AddSearch(Holder, cfg.Text)
            return Decorate(el, Holder, rec, cfg)
        end

        --// DIVIDER — đường kẻ ngăn cách (ẩn khi đang tìm kiếm)
        function target:CreateDivider()
            local Holder = New("Frame", {
                BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 12),
                BorderSizePixel = 0, Parent = container,
            })
            local Line = New("Frame", {
                BackgroundColor3 = T("Stroke"), BackgroundTransparency = 0.45,
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, 1),
                BorderSizePixel = 0, Parent = Holder,
            })
            Register(Line, {BackgroundColor3 = "Stroke"})
            local rec = AddSearch(Holder)
            return Decorate({Frame = Holder}, Holder, rec, {})
        end
    end

    --// ======================== SEARCH (không phân biệt dấu / hoa thường) ========================
    function Window:_RefreshEmpty()
        local cur = Window._CurrentTab
        local q = Window._Query or ""
        EmptyLabel.Visible = (q ~= "" and cur ~= nil and (cur._Matches or 0) == 0)
    end

    local function ApplySearch(raw)
        local q = NormalizeSearch(raw or "")
        Window._Query = q
        local firstHit = nil
        for _, t in ipairs(Window._Tabs) do
            local nameHit = (q ~= "") and (t._SearchName:find(q, 1, true) ~= nil)
            local matches = 0
            for _, e in ipairs(t._Elements) do
                if e.Frame and e.Frame.Parent then
                    local show = (q == "") or nameHit or (e.Text:find(q, 1, true) ~= nil)
                    if not show and e.Section and e.Section.Text:find(q, 1, true) then show = true end
                    e.SearchShow = show
                    RefreshRec(e)                    -- kết hợp với SetVisible và trạng thái thu gọn
                    if show and not e.Hidden then matches = matches + 1 end
                end
            end
            -- ẩn tiêu đề section khi không còn mục nào khớp
            for _, sec in ipairs(t._Sections) do
                if sec.Frame and sec.Frame.Parent then
                    local vis = (q == "")
                    if not vis then
                        for _, it in ipairs(sec.Items) do
                            if it.Frame.Parent and it.SearchShow ~= false and not it.Hidden then vis = true break end
                        end
                    end
                    sec.Frame.Visible = vis
                end
            end
            t._Matches = matches
            if t._Button and t._Button.Parent then
                t._Button.Visible = (q == "") or matches > 0 or nameHit
            end
            if matches > 0 and (not firstHit or t._Order < firstHit._Order) then firstHit = t end
        end
        -- tab đang xem không có kết quả mà tab khác có -> chuyển sang tab đó
        local cur = Window._CurrentTab
        if q ~= "" and cur and (cur._Matches or 0) == 0 and firstHit then
            firstHit:Select()
        end
        Window:_RefreshEmpty()
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        ClearBtn.Visible = (SearchBox.Text ~= "")
        ApplySearch(SearchBox.Text)
    end)

    --// ======================== TABS ========================
    function Window:CreateTab(name, icon, order)
        if type(name) == "table" then      -- CreateTab{Name = "...", Icon = "...", Order = n}
            local c = name
            name, icon, order = c.Name or c.Title, c.Icon, c.Order
        end
        name = tostring(name or "Tab")

        local Tab = {_Elements = {}, _Sections = {}, _Name = name, _SearchName = SearchText(name), _Matches = 0}
        local btnOrder = tonumber(order) or (#Window._Tabs + 1)
        Tab._Order = btnOrder
        MeizuLibrary._LastBind = os.clock()

        local Btn = New("TextButton", {
            Name = "Tab_" .. name,
            Text = "", AutoButtonColor = false,
            BackgroundColor3 = T("Tab"), BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 36),
            LayoutOrder = btnOrder, BorderSizePixel = 0,
            ZIndex = 4, Parent = TabsHolder,
        })
        Register(Btn, {BackgroundColor3 = "Tab"})
        New("UICorner", {CornerRadius = UDim.new(0, 9), Parent = Btn})
        Tab._Button = Btn

        -- Ánh sáng accent mờ dần từ trái sang phải khi tab được chọn
        local Glow = New("Frame", {
            BackgroundColor3 = MeizuLibrary.Accent, BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, ZIndex = 4, Parent = Btn,
        })
        RegisterAccent(Glow, "BackgroundColor3")
        New("UICorner", {CornerRadius = UDim.new(0, 9), Parent = Glow})
        New("UIGradient", {
            Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}),
            Parent = Glow,
        })

        local Indicator = New("Frame", {
            BackgroundColor3 = MeizuLibrary.Accent,
            AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0),
            Size = UDim2.new(0, 3, 0, 0), BorderSizePixel = 0, ZIndex = 6, Parent = Btn,
        })
        RegisterAccent(Indicator, "BackgroundColor3")
        New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Indicator})

        -- Ô icon: có icon thì hiện icon, KHÔNG có thì hiện chấm tròn (không còn chỗ trống)
        local IconHolder = New("Frame", {
            BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 14, 0.5, 0), Size = UDim2.fromOffset(18, 18),
            BorderSizePixel = 0, ZIndex = 5, Parent = Btn,
        })
        local IconImage, IconDot
        local function BuildDot()
            IconDot = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(6, 6), BackgroundColor3 = T("SubText"),
                BorderSizePixel = 0, ZIndex = 5, Parent = IconHolder,
            })
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = IconDot})
        end
        local function BuildImage(asset)
            if IconDot then IconDot:Destroy() IconDot = nil end
            IconImage = New("ImageLabel", {
                BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
                Image = asset, ImageColor3 = T("SubText"),
                ScaleType = Enum.ScaleType.Fit, ZIndex = 5, Parent = IconHolder,
            })
        end

        local Label = TextObj("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 42, 0, 0), Size = UDim2.new(1, -52, 1, 0),
            TextColor3 = T("SubText"), TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Text = "", ZIndex = 5, Parent = Btn,
        }, "Medium", 13)
        BindLoc(Label, "Text", name)

        -- Huy hiệu ở mép phải của tab: Tab:SetBadge(true) = chấm, SetBadge(3) / SetBadge("NEW") = pill, SetBadge(nil) = ẩn
        local Badge = New("Frame", {
            Name = "Badge", BackgroundColor3 = MeizuLibrary.Accent,
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0, Visible = false, ZIndex = 7, Parent = Btn,
        })
        RegisterAccent(Badge, "BackgroundColor3")
        New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Badge})
        local BadgeText = TextObj("TextLabel", {
            BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "",
            TextColor3 = Color3.fromRGB(255, 255, 255), ZIndex = 8, Parent = Badge,
        }, "Bold", 10)
        Tab.SetBadge = function(x, y)
            local v = x
            if x == Tab then v = y end
            if v == nil or v == false then
                Badge.Visible = false
                Label.Size = UDim2.new(1, -52, 1, 0)
                return
            end
            local text = (v == true) and "" or tostring(v)
            if #text > 3 then text = text:sub(1, 2) .. "+" end
            BadgeText.Text = text
            local w = (text == "") and 10 or math.max(16, 9 + #text * 6)
            Badge.Size = UDim2.fromOffset(w, (text == "") and 10 or 16)
            Badge.Visible = true
            Label.Size = UDim2.new(1, -(52 + w), 1, 0)
            Tween(Badge, 0.3, {Size = Badge.Size}, Enum.EasingStyle.Back)
        end

        local selected = false
        local function ApplyStyle(animate)
            local labelColor = selected and T("Text") or T("SubText")
            local iconColor = selected and MeizuLibrary.Accent or T("SubText")
            local function Put(obj, prop, value)
                if not obj then return end
                if animate then Tween(obj, 0.2, {[prop] = value}) else obj[prop] = value end
            end
            Put(Label, "TextColor3", labelColor)
            Put(IconImage, "ImageColor3", iconColor)
            Put(IconDot, "BackgroundColor3", iconColor)
        end

        local assetStr = ResolveIcon(icon)
        if assetStr then
            BuildImage(assetStr)
        else
            BuildDot()
            if type(icon) == "string" and icon:sub(1, 4) == "http" then      -- icon từ URL: tải bất đồng bộ
                task.spawn(function()
                    local asset = ResolveImageAsset(icon)
                    if asset and IconHolder.Parent then
                        BuildImage(asset)
                        ApplyStyle(false)
                    end
                end)
            end
        end
        ApplyStyle(false)
        OnThemeChange(function() ApplyStyle(false) end)
        OnAccentChange(function() if selected then ApplyStyle(false) end end)

        Btn.MouseEnter:Connect(function()
            if not selected then Tween(Btn, 0.15, {BackgroundTransparency = 0.55}) end
        end)
        Btn.MouseLeave:Connect(function()
            if not selected then Tween(Btn, 0.2, {BackgroundTransparency = 1}) end
        end)

        local function Visuals(on)
            selected = on
            Tween(Btn, 0.2, {BackgroundTransparency = on and 0 or 1})
            Tween(Glow, 0.3, {BackgroundTransparency = on and 0.8 or 1})
            Tween(Indicator, 0.25, {Size = UDim2.new(0, 3, 0, on and 18 or 0)}, Enum.EasingStyle.Back)
            ApplyStyle(true)
        end

        -- Trang nội dung của tab (bắt đầu dưới header nên cuộn không đè lên header)
        local Page = New("CanvasGroup", {
            Name = "Page_" .. name, BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1), Visible = false, BorderSizePixel = 0,
            Parent = PagesHolder,
        })
        local Scroll = New("ScrollingFrame", {
            BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
            ScrollBarThickness = 3, ScrollBarImageTransparency = 0.3,
            CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            BorderSizePixel = 0, Parent = Page,
        })
        RegisterAccent(Scroll, "ScrollBarImageColor3")
        New("UIPadding", {
            PaddingTop = UDim.new(0, 18), PaddingBottom = UDim.new(0, 20),
            PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 16),
            Parent = Scroll,
        })
        New("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Scroll})
        Tab.Page, Tab.Scroll = Page, Scroll
        Tab._Btn, Tab._Label, Tab._Indicator, Tab._Page = Btn, Label, Indicator, Page   -- tương thích bản cũ

        function Tab:Select(auto)
            Window._AutoPicked = (auto == true)
            if Window._CurrentTab == Tab then return end
            local prev = Window._CurrentTab
            Window._CurrentTab = Tab
            if prev and prev._Deselect then prev._Deselect() end
            Visuals(true)
            Page.Visible = true
            Page.GroupTransparency = 1
            Page.Position = UDim2.new(0, 16, 0, 0)
            Tween(Page, 0.3, {GroupTransparency = 0})
            Tween(Page, 0.35, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Quint)
            HeaderBinding.Key = name
            RefreshBinding(HeaderBinding)
            Window:_RefreshEmpty()
            if auto ~= true and Tab ~= Window.SettingsTab then
                MeizuLibrary._LastTabName = name
                MeizuLibrary:_SaveUiPrefs()
            end
        end
        Tab._Deselect = function()
            Visuals(false)
            Page.Visible = false
        end
        Btn.Activated:Connect(function() Tab:Select() end)

        table.insert(Window._Tabs, Tab)
        BindElements(Tab, Scroll, Tab)
        Window:_AutoSelect()
        return Tab
    end

    -- Mở đúng tab đầu tiên của hub (không phải tab Cài đặt tự tạo) khi chưa ai chọn tab nào.
    function Window:_AutoSelect()
        if Window._CurrentTab and not Window._AutoPicked then return end
        local first = nil
        for _, t in ipairs(Window._Tabs) do
            if t ~= Window.SettingsTab and (not first or t._Order < first._Order) then first = t end
        end
        local target
        local last = MeizuLibrary._LastTabName          -- tab người dùng xem lần trước (nếu tab đó tồn tại)
        if last then
            for _, t in ipairs(Window._Tabs) do
                if t._Name == last and t ~= Window.SettingsTab then target = t break end
            end
        end
        target = target or first or Window.SettingsTab or Window._Tabs[1]
        if target and target ~= Window._CurrentTab then target:Select(true) end
        Window._AutoPicked = true
    end

    function Window:SelectTab(index)
        local t
        if type(index) == "number" then
            t = Window._Tabs[index]
        elseif type(index) == "string" then
            local want, wantNorm = index:lower(), NormalizeSearch(index)
            for _, tab in ipairs(Window._Tabs) do
                local hit = (tab._Name:lower() == want) or (NormalizeSearch(tab._Name) == wantNorm)
                if not hit then      -- khớp cả tên đã dịch: SelectTab("Cài đặt") = SelectTab("Settings")
                    local row = MeizuLibrary.LanguageMap[tab._Name]
                    if type(row) == "table" then
                        for _, v in pairs(row) do
                            if type(v) == "string" and NormalizeSearch(v) == wantNorm then hit = true end
                        end
                    end
                end
                if hit then t = tab break end
            end
        elseif type(index) == "table" and type(index.Select) == "function" then
            t = index
        end
        if t then t:Select() end
        return t
    end

    --// ======================== OPEN / CLOSE ========================
    local ToggleJelly = nil      -- gán khi tạo nút nổi: hiệu ứng "nhún" kiểu chất lỏng khi bật/tắt

    local function SetOpen(state)
        if state == isOpen then return end
        isOpen = state
        MeizuLibrary._WindowOpen = state
        MeizuLibrary:_ApplyBlur()                                  -- làm mờ nền game khi UI mở (nếu bật)
        if state and MeizuLibrary._ClearUnread then MeizuLibrary._ClearUnread() end
        if IconWrap then
            Tween(IconWrap, 0.5, {Rotation = state and 180 or 0}, Enum.EasingStyle.Back)
        end
        if ToggleJelly then ToggleJelly(state) end
        if state then
            Root.Visible = true
            UpdateFit()
            Tween(PopScale, 0.4, {Scale = 1}, Enum.EasingStyle.Back)
            Tween(Main, 0.3, {GroupTransparency = 0})
            Tween(Shadow, 0.4, {ImageTransparency = 0.5})
        else
            Tween(PopScale, 0.25, {Scale = 0.92}, Enum.EasingStyle.Quad)
            Tween(Main, 0.2, {GroupTransparency = 1})
            Tween(Shadow, 0.2, {ImageTransparency = 1})
            task.delay(0.26, function()
                if not isOpen and Root.Parent then Root.Visible = false end
            end)
        end
    end

    function Window:Toggle(state)
        if state == nil then state = not isOpen end
        SetOpen(state == true)
    end
    function Window:IsOpen() return isOpen end
    function Window:Destroy() MeizuLibrary:Destroy() end
    function Window:Notify(cfg, dur) return MeizuLibrary.Notify(MeizuLibrary, cfg, dur) end

    --// ======================== DIALOG ========================
    function Window:Dialog(cfg)
        cfg = (type(cfg) == "table") and cfg or {}
        local title   = L(tostring(cfg.Title or "Dialog"))
        local content = L(tostring(cfg.Content or ""))
        local buttons = cfg.Buttons
        if type(buttons) ~= "table" or #buttons == 0 then buttons = {{Title = "OK"}} end

        local DIALOG_W, PAD, BTN_H = 340, 20, 36
        local preset = CurrentPreset()
        local titleH = 15 + preset.SizeOffset + 6
        local contentW = DIALOG_W - PAD * 2
        local contentH = (content ~= "") and (MeasureText(content, "Regular", 13, contentW) + 2) or 0
        local totalH = PAD + titleH + ((contentH > 0) and (8 + contentH) or 0) + 18 + BTN_H + PAD

        -- Overlay chặn click xuyên xuống UI bên dưới (Active = true)
        local Overlay = New("Frame", {
            Name = "DialogOverlay",
            BackgroundColor3 = T("Overlay"), BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1), Active = true,
            BorderSizePixel = 0, ZIndex = 300, Parent = ScreenGui,
        })
        local Card = New("CanvasGroup", {
            BackgroundColor3 = T("Window"),
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(DIALOG_W, totalH),
            GroupTransparency = 1, BorderSizePixel = 0, ZIndex = 301, Parent = Overlay,
        })
        Register(Card, {BackgroundColor3 = "Window"})
        New("UICorner", {CornerRadius = UDim.new(0, 14), Parent = Card})
        local DStroke = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.25, Parent = Card})
        Register(DStroke, {Color = "Stroke"})
        local scale = New("UIScale", {Scale = 0.9, Parent = Card})

        local DTitle = TextObj("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, PAD, 0, PAD), Size = UDim2.new(1, -PAD * 2, 0, titleH),
            TextColor3 = T("Text"), TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Text = title, ZIndex = 302, Parent = Card,
        }, "Bold", 15)
        Register(DTitle, {TextColor3 = "Text"})

        if contentH > 0 then
            local DContent = TextObj("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, PAD, 0, PAD + titleH + 8), Size = UDim2.new(1, -PAD * 2, 0, contentH),
                TextColor3 = T("SubText"), TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true, RichText = true,
                Text = content, ZIndex = 302, Parent = Card,
            }, "Regular", 13)
            Register(DContent, {TextColor3 = "SubText"})
        end

        local Row = New("Frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, PAD, 1, -PAD), Size = UDim2.new(1, -PAD * 2, 0, BTN_H),
            BorderSizePixel = 0, ZIndex = 302, Parent = Card,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Row,
        })

        local closed = false
        local function Close(callback)
            if closed then return end
            closed = true
            Tween(Overlay, 0.2, {BackgroundTransparency = 1})
            Tween(scale, 0.2, {Scale = 0.92})
            Tween(Card, 0.2, {GroupTransparency = 1})
            task.delay(0.25, function() if Overlay then Overlay:Destroy() end end)
            if callback then SafeCall(callback) end
        end

        local btnW = math.clamp(math.floor((contentW - (#buttons - 1) * 8) / #buttons), 80, 150)
        for i, b in ipairs(buttons) do
            local primary = b.Primary
            if primary == nil then primary = (i == #buttons) end
            local B = TextObj("TextButton", {
                Text = L(tostring(b.Title or "OK")), AutoButtonColor = false,
                Size = UDim2.fromOffset(btnW, BTN_H),
                BackgroundColor3 = primary and MeizuLibrary.Accent or T("Tab"),
                TextColor3 = primary and Color3.fromRGB(255, 255, 255) or T("Text"),
                LayoutOrder = i, BorderSizePixel = 0, ZIndex = 303, Parent = Row,
            }, "Bold", 13)
            New("UICorner", {CornerRadius = UDim.new(0, 9), Parent = B})
            if primary then
                RegisterAccent(B, "BackgroundColor3")
            else
                Register(B, {BackgroundColor3 = "Tab", TextColor3 = "Text"})
                local BS = New("UIStroke", {Color = T("Stroke"), Thickness = 1, Transparency = 0.4, Parent = B})
                Register(BS, {Color = "Stroke"})
            end
            B.MouseEnter:Connect(function() Tween(B, 0.15, {BackgroundTransparency = 0.12}) end)
            B.MouseLeave:Connect(function() Tween(B, 0.2, {BackgroundTransparency = 0}) end)
            B.Activated:Connect(function() Close(b.Callback) end)
        end

        PlaySound("rbxasset://sounds/electronicpingshort.wav", 0.2, 0.9)
        Tween(Overlay, 0.2, {BackgroundTransparency = 0.4})
        Tween(scale, 0.3, {Scale = 1}, Enum.EasingStyle.Back)
        Tween(Card, 0.25, {GroupTransparency = 0})
        return {Close = function() Close() end}
    end

    -- Nút thu nhỏ / đóng trên header
    MinBtn.Activated:Connect(function() Window:Toggle(false) end)
    CloseBtn.Activated:Connect(function()
        Window:Dialog({
            Title = "Close UI",
            Content = "Do you want to close the UI completely?",
            Buttons = {
                {Title = "Cancel"},
                {Title = "Close", Callback = function() MeizuLibrary:Destroy() end},
            },
        })
    end)

    -- Phím bật/tắt UI
    table.insert(MeizuLibrary._Connections, UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if UserInputService:GetFocusedTextBox() then return end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == MeizuLibrary.ToggleKeybind then
            Window:Toggle()
        end
    end))

    --// ==================== NÚT NỔI — LIQUID GLASS (kiểu iOS 26) ====================
    -- Roblox không blur được nền phía sau UI nên "kính lỏng" được dựng bằng nhiều lớp:
    --   Shadow  -> Glass (thân kính ám màu + lens + caustic + gloss + glint + logo) -> RimB / RimA (viền sáng)
    -- Viền sáng là UIStroke + UIGradient lệch hướng, lắc nhẹ như ánh sáng đổi góc khi nghiêng kính.
    -- Chạm: co lại như giọt chất lỏng rồi bung ra (Elastic), gợn sóng tại điểm chạm, logo phóng đại như thấu kính.
    -- Bật/tắt UI: thân kính "nhún" (squash & stretch). Kéo: kính được nhấc lên, bóng đổ rộng hơn.
    if config.ToggleUIButton ~= false then
        local RADIUS = TOGGLE_BUTTON_RADIUS or 12
        local GLASS = (TOGGLE_BUTTON_STYLE ~= "Classic")
        local BTN_W = (TOGGLE_BUTTON_SIZE.X.Offset > 0) and TOGGLE_BUTTON_SIZE.X.Offset or 50
        local BTN_H = (TOGGLE_BUTTON_SIZE.Y.Offset > 0) and TOGGLE_BUTTON_SIZE.Y.Offset or 50
        local WHITE = Color3.fromRGB(255, 255, 255)

        -- Neo ở TÂM nút để phóng to / nhún không bị lệch. TOGGLE_BUTTON_POSITION vẫn hiểu là góc trên-trái.
        local P0 = TOGGLE_BUTTON_POSITION
        local ToggleBtn = New("Frame", {
            Name = "ToggleButton",
            BackgroundTransparency = 1, BorderSizePixel = 0, Active = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(P0.X.Scale, P0.X.Offset + BTN_W / 2, P0.Y.Scale, P0.Y.Offset + BTN_H / 2),
            Size = UDim2.fromOffset(BTN_W, BTN_H),
            ZIndex = 150, Parent = ScreenGui,
        })
        local BtnScale = New("UIScale", {Scale = 0, Parent = ToggleBtn})

        -- Bóng đổ mềm bên dưới (nhấc lên khi kéo)
        local BtnShadow = New("ImageLabel", {
            Name = "Shadow", BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 4),
            Size = UDim2.new(1, 36, 1, 36),
            Image = "rbxassetid://6014261993", ImageColor3 = Color3.fromRGB(0, 0, 0),
            ImageTransparency = 0.5, ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(49, 49, 450, 450),
            ZIndex = 148, Parent = ToggleBtn,
        })

        -- Vòng sóng lan ra khi UI đang ẩn (gợi ý bấm vào)
        local PulseRing = New("Frame", {
            Name = "PulseRing", BackgroundTransparency = 1, BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(BTN_W, BTN_H), ZIndex = 149, Parent = ToggleBtn,
        })
        New("UICorner", {CornerRadius = UDim.new(0, RADIUS), Parent = PulseRing})
        local PulseStroke = New("UIStroke", {Color = MeizuLibrary.Accent, Thickness = 2, Transparency = 1, Parent = PulseRing})
        RegisterAccent(PulseStroke, "Color")

        -- Shape: khối chịu hiệu ứng nhún (squash & stretch) — chứa kính + các viền
        local Shape = New("Frame", {
            Name = "Shape", BackgroundTransparency = 1, BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1), ZIndex = 151, Parent = ToggleBtn,
        })
        -- CanvasGroup: bo góc + cắt mọi lớp bên trong theo đúng hình dạng nút
        local Glass = New("CanvasGroup", {
            Name = "Glass",
            BackgroundColor3 = T("Sidebar"), BackgroundTransparency = GLASS and 1 or 0,
            BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 1, Parent = Shape,
        })
        New("UICorner", {CornerRadius = UDim.new(0, RADIUS), Parent = Glass})
        if not GLASS then Register(Glass, {BackgroundColor3 = "Sidebar"}) end

        -- Viền: UIStroke + UIGradient (gradient đặt trong stroke thì chỉ áp lên viền)
        local function MakeRim(name, thickness, color, seq, rotation, z)
            local rim = New("Frame", {
                Name = name, BackgroundTransparency = 1, BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 1), ZIndex = z, Parent = Shape,
            })
            New("UICorner", {CornerRadius = UDim.new(0, RADIUS), Parent = rim})
            local stroke = New("UIStroke", {Color = color, Thickness = thickness, Transparency = 0, Parent = rim})
            local grad = New("UIGradient", {Rotation = rotation, Transparency = seq, Parent = stroke})
            return stroke, grad
        end

        local Sheen, Glint, LogoGlow, GradA, GradB

        if GLASS then
            -- 1) Thân kính: ám màu, trong hơn ở phía trên và đậm dần xuống đáy.
            --    Toàn bộ độ trong suốt đặt trong gradient (nền = 0) nên không phụ thuộc cách Roblox cộng
            --    BackgroundTransparency với UIGradient.
            local glassT = math.clamp(TOGGLE_BUTTON_GLASS_ALPHA, 0, 1)
            local Body = New("Frame", {
                Name = "Body", BackgroundColor3 = TOGGLE_BUTTON_GLASS_TINT, BackgroundTransparency = 0,
                Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, ZIndex = 1, Parent = Glass,
            })
            New("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1 - (1 - glassT) * 0.84), NumberSequenceKeypoint.new(1, glassT)}),
                Parent = Body,
            })

            -- 2) Thấu kính: ánh sáng chiếu chéo từ góc trên-trái
            local Lens = New("Frame", {
                Name = "Lens", BackgroundColor3 = WHITE,
                Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, ZIndex = 2, Parent = Glass,
            })
            New("UIGradient", {
                Rotation = 45,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.82), NumberSequenceKeypoint.new(0.5, 0.95), NumberSequenceKeypoint.new(1, 1)}),
                Parent = Lens,
            })

            -- 3) Caustic: ánh sáng màu accent xuyên qua kính, tụ ở đáy (đổi màu theo accent / rainbow)
            local Caustic = New("Frame", {
                Name = "Caustic", BackgroundColor3 = MeizuLibrary.Accent,
                AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.fromScale(1, 0.62),
                BorderSizePixel = 0, ZIndex = 3, Parent = Glass,
            })
            RegisterAccent(Caustic, "BackgroundColor3", 1.12)
            New("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.76)}),
                Parent = Caustic,
            })

            -- 4) Quầng sáng sau logo (thở nhẹ)
            LogoGlow = New("ImageLabel", {
                Name = "LogoGlow", BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.new(1, 40, 1, 40),
                Image = "rbxassetid://6014261993", ImageColor3 = MeizuLibrary.Accent, ImageTransparency = 0.72,
                ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450),
                ZIndex = 4, Parent = Glass,
            })
            RegisterAccent(LogoGlow, "ImageColor3")

            -- 5) Gloss nửa trên: tràn hết chiều ngang, được CanvasGroup cắt theo hình nút nên chảy liền với viền
            --    (sáng lên khi chạm / hover)
            Sheen = New("Frame", {
                Name = "Sheen", BackgroundColor3 = WHITE, BackgroundTransparency = 0.35,
                Position = UDim2.fromScale(0, 0), Size = UDim2.fromScale(1, 0.58),
                BorderSizePixel = 0, ZIndex = 6, Parent = Glass,
            })
            New("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.66), NumberSequenceKeypoint.new(0.55, 0.88), NumberSequenceKeypoint.new(1, 1)}),
                Parent = Sheen,
            })

            -- 6) Vệt sáng quét ngang định kỳ
            Glint = New("Frame", {
                Name = "Glint", BackgroundColor3 = WHITE,
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(-0.5, 0, 0.5, 0),
                Size = UDim2.new(0.3, 0, 1.7, 0), Rotation = 22,
                BorderSizePixel = 0, ZIndex = 7, Parent = Glass,
            })
            New("UIGradient", {
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.7), NumberSequenceKeypoint.new(1, 1)}),
                Parent = Glint,
            })

            -- 7) Chấm phản chiếu góc trên-trái + vệt sáng bật lại ở đáy
            local Spec = New("Frame", {
                Name = "Spec", BackgroundColor3 = WHITE, BackgroundTransparency = 0.3,
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.24, 0.17),
                Size = UDim2.fromOffset(9, 3), Rotation = -28,
                BorderSizePixel = 0, ZIndex = 8, Parent = Glass,
            })
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Spec})
            local BottomGlint = New("Frame", {
                Name = "BottomGlint", BackgroundColor3 = WHITE,
                AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -3), Size = UDim2.new(0.56, 0, 0, 2),
                BorderSizePixel = 0, ZIndex = 8, Parent = Glass,
            })
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = BottomGlint})
            New("UIGradient", {
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.55), NumberSequenceKeypoint.new(1, 1)}),
                Parent = BottomGlint,
            })

            -- 8) Mép trong của tấm kính (độ dày). UIStroke vẽ BÊN NGOÀI khung nên khung phải thu vào 2px,
            --    nếu không vòng viền sẽ nằm ngoài CanvasGroup và bị cắt mất.
            local InnerEdge = New("Frame", {
                Name = "InnerEdge", BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.new(1, -4, 1, -4),
                BorderSizePixel = 0, ZIndex = 9, Parent = Glass,
            })
            New("UICorner", {CornerRadius = UDim.new(0, math.max(RADIUS - 2, 2)), Parent = InnerEdge})
            local InnerStroke = New("UIStroke", {Color = WHITE, Thickness = 1.5, Transparency = 0, Parent = InnerEdge})
            New("UIGradient", {
                Rotation = 45,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.78), NumberSequenceKeypoint.new(0.5, 0.96), NumberSequenceKeypoint.new(1, 0.72)}),
                Parent = InnerStroke,
            })

            -- 9) Viền ngoài: RimB (ánh accent, bù với RimA) + RimA (viền trắng sáng lệch hướng)
            local StrokeB
            StrokeB, GradB = MakeRim("RimB", 1, MeizuLibrary.Accent, NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.95), NumberSequenceKeypoint.new(0.5, 0.35), NumberSequenceKeypoint.new(1, 0.95)}), 235, 2)
            RegisterAccent(StrokeB, "Color", 1.35)
            local _, gradA = MakeRim("RimA", 1.5, WHITE, NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.05), NumberSequenceKeypoint.new(0.25, 0.6), NumberSequenceKeypoint.new(0.5, 0.88),
                NumberSequenceKeypoint.new(0.75, 0.6), NumberSequenceKeypoint.new(1, 0.1)}), 20, 3)
            GradA = gradA
        else
            -- Kiểu Classic: nền đặc + viền accent như bản cũ
            local classicStroke = MakeRim("Rim", 1.5, MeizuLibrary.Accent, NumberSequence.new(0.25), 0, 3)
            RegisterAccent(classicStroke, "Color")
        end

        -- Logo (giữ nguyên cơ chế cũ: PNG cố định, nếu tải lỗi thì hiện chữ "M")
        IconWrap = New("Frame", {
            Name = "IconWrap", BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1, -10, 1, -10), ZIndex = 10, Parent = Glass,
        })
        local LogoScale = New("UIScale", {Scale = 1, Parent = IconWrap})
        local ToggleImageL = New("ImageLabel", {
            Name = "ToggleImage", BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1), Visible = false,
            ScaleType = Enum.ScaleType.Fit, ImageTransparency = 0,
            ZIndex = 10, Parent = IconWrap,
        })
        local ToggleLetter = TextObj("TextLabel", {
            Name = "ToggleLetter", BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1), Text = "M",
            TextColor3 = MeizuLibrary.Accent, ZIndex = 10, Parent = IconWrap,
        }, "Black", 20)
        RegisterAccent(ToggleLetter, "TextColor3")

        task.spawn(function()
            local asset = ResolveImageAsset(TOGGLE_BUTTON_IMAGE)
            if asset and ToggleImageL.Parent then
                ToggleImageL.Image = asset
                ToggleImageL.Visible = true
                ToggleLetter.Visible = false
                MeizuLibrary._ToggleImage = TOGGLE_BUTTON_IMAGE
            end
        end)

        --// ---- Hoạt ảnh lặp: viền lắc nhẹ như ánh sáng đổi góc, quầng sáng logo thở (tắt được bằng Chế độ tiết kiệm) ----
        local loopTweens = {}
        local function Loop(obj, props, time, delayTime)
            local okL, tw = pcall(function()
                local t = TweenService:Create(obj,
                    TweenInfo.new(time, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, delayTime or 0),
                    props)
                t:Play()
                return t
            end)
            if okL and tw then table.insert(loopTweens, tw) end
        end
        local function StartLoops()
            if not GLASS then return end
            if GradA then Loop(GradA, {Rotation = 80}, 4.2) end
            if GradB then Loop(GradB, {Rotation = 175}, 5.6, 0.4) end
            if LogoGlow then Loop(LogoGlow, {ImageTransparency = 0.58}, 2.6) end
        end
        local function StopLoops()
            for _, tw in ipairs(loopTweens) do pcall(function() tw:Cancel() end) end
            loopTweens = {}
            if GradA then GradA.Rotation = 35 end
            if GradB then GradB.Rotation = 205 end
            if LogoGlow then LogoGlow.ImageTransparency = 0.66 end
        end
        if not MeizuLibrary.PerfMode then StartLoops() end
        OnPerfChange(function(perf) if perf then StopLoops() else StartLoops() end end)

        if GLASS then
            task.spawn(function()      -- vệt sáng quét ngang mỗi ~5 giây
                task.wait(1.2)
                while ToggleBtn.Parent and not MeizuLibrary.Destroyed do
                    if Glint and Glint.Parent and not MeizuLibrary.PerfMode then
                        Glint.Position = UDim2.new(-0.5, 0, 0.5, 0)
                        Tween(Glint, 0.9, {Position = UDim2.new(1.5, 0, 0.5, 0)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                    end
                    task.wait(4.5 + math.random() * 2)
                end
            end)
        end

        task.spawn(function()          -- sóng lan khi UI đang ẩn
            while ToggleBtn.Parent and not MeizuLibrary.Destroyed do
                if not isOpen and PulseRing.Parent and not MeizuLibrary.PerfMode then
                    PulseRing.Size = UDim2.fromOffset(BTN_W, BTN_H)
                    PulseStroke.Transparency = 0.35
                    Tween(PulseRing, 1.2, {Size = UDim2.fromOffset(BTN_W + 34, BTN_H + 34)}, Enum.EasingStyle.Quad)
                    Tween(PulseStroke, 1.2, {Transparency = 1}, Enum.EasingStyle.Quad)
                end
                task.wait(2.2)
            end
        end)

        --// ---- "Vật lý" chất lỏng: co khi chạm, nở khi hover, nhấc lên khi kéo ----
        local pressed, hovering, dragging = false, false, false
        local function ApplyPhysics()
            local target = 1
            if dragging then target = 1.12 elseif pressed then target = 0.9 elseif hovering then target = 1.07 end
            if pressed then
                Tween(BtnScale, 0.1, {Scale = target}, Enum.EasingStyle.Quad)
            elseif hovering and not dragging then
                Tween(BtnScale, 0.25, {Scale = target}, Enum.EasingStyle.Back)
            else
                Tween(BtnScale, 0.6, {Scale = target}, Enum.EasingStyle.Elastic)     -- bung ra như giọt chất lỏng
            end
            local magnify = (pressed or dragging)
            Tween(LogoScale, magnify and 0.12 or 0.4, {Scale = magnify and 1.14 or 1},
                magnify and Enum.EasingStyle.Quad or Enum.EasingStyle.Back)           -- logo phóng đại như thấu kính
            if Sheen then
                Tween(Sheen, 0.2, {BackgroundTransparency = (pressed or hovering or dragging) and 0.05 or 0.35})
            end
        end

        local function Lift(on)
            Tween(BtnShadow, 0.25, {
                Size = on and UDim2.new(1, 56, 1, 56) or UDim2.new(1, 36, 1, 36),
                Position = on and UDim2.new(0.5, 0, 0.5, 9) or UDim2.new(0.5, 0, 0.5, 4),
                ImageTransparency = on and 0.32 or 0.5,
            })
        end

        -- Gợn sóng tại điểm chạm (bị cắt gọn trong hình dạng nút nhờ CanvasGroup)
        local function WaterRipple(input)
            if not GLASS or not Glass.Parent then return end
            local sc = math.max(BtnScale.Scale, 0.2)
            local p = (PointerPos(input) - Glass.AbsolutePosition) / sc
            local ring = New("Frame", {
                BackgroundColor3 = WHITE, BackgroundTransparency = 0.82,
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(p.X, p.Y),
                Size = UDim2.fromOffset(6, 6), BorderSizePixel = 0, ZIndex = 20, Parent = Glass,
            })
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ring})
            local ringStroke = New("UIStroke", {Color = WHITE, Thickness = 1.5, Transparency = 0.35, Parent = ring})
            Tween(ring, 0.65, {Size = UDim2.fromOffset(BTN_W * 2.2, BTN_W * 2.2), BackgroundTransparency = 1}, Enum.EasingStyle.Quad)
            Tween(ringStroke, 0.65, {Transparency = 1}, Enum.EasingStyle.Quad)
            task.delay(0.7, function() if ring then ring:Destroy() end end)
        end

        -- Giữ nguyên cả nút trong màn hình
        local function ClampButton(pos)
            local vp = ScreenGui.AbsoluteSize
            if vp.X <= 0 or vp.Y <= 0 then return pos end
            local hw, hh = BTN_W / 2 + 6, BTN_H / 2 + 6
            local cx = vp.X * pos.X.Scale + pos.X.Offset
            local cy = vp.Y * pos.Y.Scale + pos.Y.Offset
            local ncx = math.clamp(cx, hw, math.max(vp.X - hw, hw))
            local ncy = math.clamp(cy, hh, math.max(vp.Y - hh, hh))
            return UDim2.new(pos.X.Scale, pos.X.Offset + (ncx - cx), pos.Y.Scale, pos.Y.Offset + (ncy - cy))
        end
        table.insert(MeizuLibrary._Connections, ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            ToggleBtn.Position = ClampButton(ToggleBtn.Position)
        end))

        --// ---- Hít vào mép màn hình (kiểu AssistiveTouch) + tuỳ chọn thu nửa khi không dùng ----
        local docked, dockToken = false, 0
        local function SetDocked(on)
            if on == docked then return end
            local vp = ScreenGui.AbsoluteSize
            local pos = ToggleBtn.Position
            local cx = vp.X * pos.X.Scale + pos.X.Offset
            local dir = (cx < vp.X / 2) and -1 or 1                      -- thò ra phía mép gần nhất
            docked = on
            Tween(ToggleBtn, 0.35, {Position = UDim2.new(pos.X.Scale, pos.X.Offset + BTN_W * 0.42 * dir * (on and 1 or -1),
                pos.Y.Scale, pos.Y.Offset)}, Enum.EasingStyle.Quint)
            Tween(Glass, 0.35, {GroupTransparency = on and 0.4 or 0})
        end
        local function ScheduleDock()
            if not TOGGLE_BUTTON_DOCK then return end
            dockToken = dockToken + 1
            local token = dockToken
            task.delay(3, function()
                if token == dockToken and ToggleBtn.Parent and not pressed and not dragging and not hovering then
                    SetDocked(true)
                end
            end)
        end
        local function Undock()
            dockToken = dockToken + 1
            SetDocked(false)
        end
        local function SnapToEdge()
            if not TOGGLE_BUTTON_SNAP then ScheduleDock() return end
            local vp = ScreenGui.AbsoluteSize
            if vp.X <= 0 or vp.Y <= 0 then return end
            local pos = ToggleBtn.Position
            local cx = vp.X * pos.X.Scale + pos.X.Offset
            local cy = vp.Y * pos.Y.Scale + pos.Y.Offset
            local hw, hh, margin = BTN_W / 2, BTN_H / 2, 10
            local tx = (cx < vp.X / 2) and (hw + margin) or (vp.X - hw - margin)
            local ty = math.clamp(cy, hh + margin, math.max(vp.Y - hh - margin, hh + margin))
            Tween(ToggleBtn, 0.55, {Position = UDim2.new(pos.X.Scale, pos.X.Offset + (tx - cx),
                pos.Y.Scale, pos.Y.Offset + (ty - cy))}, Enum.EasingStyle.Back)
            ScheduleDock()
        end

        --// ---- Huy hiệu "chưa đọc": số thông báo đến khi UI đang ẩn ----
        local UnreadBadge = New("Frame", {
            Name = "UnreadBadge", BackgroundColor3 = Color3.fromRGB(255, 69, 58),
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, -3, 0, 5), Size = UDim2.fromOffset(18, 18),
            BorderSizePixel = 0, Visible = false, ZIndex = 160, Parent = ToggleBtn,
        })
        New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = UnreadBadge})
        New("UIStroke", {Color = WHITE, Thickness = 1.5, Transparency = 0.35, Parent = UnreadBadge})
        local UnreadText = TextObj("TextLabel", {
            BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "",
            TextColor3 = WHITE, ZIndex = 161, Parent = UnreadBadge,
        }, "Bold", 10)
        local UnreadScale = New("UIScale", {Scale = 1, Parent = UnreadBadge})
        local unread = 0
        local function RenderUnread()
            if unread <= 0 then UnreadBadge.Visible = false return end
            local text = (unread > 9) and "9+" or tostring(unread)
            UnreadText.Text = text
            UnreadBadge.Size = UDim2.fromOffset(#text > 1 and 24 or 18, 18)
            UnreadBadge.Visible = true
            UnreadScale.Scale = 0.5
            Tween(UnreadScale, 0.4, {Scale = 1}, Enum.EasingStyle.Back)
        end
        MeizuLibrary._OnNotify = function()
            if not isOpen then unread = unread + 1 RenderUnread() end
        end
        MeizuLibrary._ClearUnread = function()
            unread = 0
            RenderUnread()
        end

        ToggleBtn.MouseEnter:Connect(function() hovering = true Undock() ApplyPhysics() end)
        ToggleBtn.MouseLeave:Connect(function() hovering = false ApplyPhysics() ScheduleDock() end)

        -- Một handler duy nhất cho cả bấm (click) lẫn kéo (drag); kéo > 6px thì không tính là click
        ToggleBtn.InputBegan:Connect(function(input)
            if not IsPointer(input) then return end
            local startPointer = PointerPos(input)
            local startPos = ToggleBtn.Position
            local moved = false
            pressed = true
            Undock()
            ApplyPhysics()
            WaterRipple(input)
            AddDrag(input, {
                OnChanged = function(inp)
                    local delta = PointerPos(inp) - startPointer
                    if not moved and delta.Magnitude >= 6 then
                        moved = true
                        pressed = false
                        dragging = true
                        ApplyPhysics()
                        Lift(true)
                    end
                    if moved then
                        ToggleBtn.Position = ClampButton(UDim2.new(
                            startPos.X.Scale, startPos.X.Offset + delta.X,
                            startPos.Y.Scale, startPos.Y.Offset + delta.Y))
                    end
                end,
                OnEnd = function()
                    pressed = false
                    dragging = false
                    ApplyPhysics()
                    Lift(false)
                    if not moved then Window:Toggle() else SnapToEdge() end
                end,
            })
        end)

        -- Nhún kiểu chất lỏng mỗi khi UI bật / tắt
        ToggleJelly = function(opening)
            if not Shape.Parent then return end
            Shape.Size = opening and UDim2.fromScale(1.16, 0.86) or UDim2.fromScale(0.86, 1.14)
            Tween(Shape, 0.75, {Size = UDim2.fromScale(1, 1)}, Enum.EasingStyle.Elastic)
        end

        Tween(BtnScale, 0.6, {Scale = 1}, Enum.EasingStyle.Back)
        ScheduleDock()
    end


    --// ==================== WATERMARK (FPS / PING / GIỜ) — thanh kính nổi, kéo được ====================
    do
        local WM_H = 30
        local WHITE = Color3.fromRGB(255, 255, 255)
        local WM = New("Frame", {
            Name = "Watermark", BackgroundTransparency = 1, BorderSizePixel = 0, Active = true,
            AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 14),
            Size = UDim2.fromOffset(200, WM_H), Visible = false, ZIndex = 140, Parent = ScreenGui,
        })
        local WMScale = New("UIScale", {Scale = 0.9, Parent = WM})
        local WMGlass = New("CanvasGroup", {
            Name = "Glass", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
            BorderSizePixel = 0, ZIndex = 1, Parent = WM,
        })
        New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = WMGlass})
        local WMBody = New("Frame", {
            BackgroundColor3 = TOGGLE_BUTTON_GLASS_TINT, Size = UDim2.fromScale(1, 1),
            BorderSizePixel = 0, ZIndex = 1, Parent = WMGlass,
        })
        New("UIGradient", {
            Rotation = 90,
            Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0.36)}),
            Parent = WMBody,
        })
        local WMSheen = New("Frame", {
            BackgroundColor3 = WHITE, Size = UDim2.fromScale(1, 0.55), BorderSizePixel = 0, ZIndex = 2, Parent = WMGlass,
        })
        New("UIGradient", {
            Rotation = 90,
            Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.78), NumberSequenceKeypoint.new(1, 1)}),
            Parent = WMSheen,
        })
        local WMDot = New("Frame", {
            BackgroundColor3 = MeizuLibrary.Accent, AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 12, 0.5, 0), Size = UDim2.fromOffset(8, 8), BorderSizePixel = 0, ZIndex = 4, Parent = WMGlass,
        })
        RegisterAccent(WMDot, "BackgroundColor3")
        New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = WMDot})
        local WMLabel = TextObj("TextLabel", {
            BackgroundTransparency = 1, Position = UDim2.new(0, 28, 0, 0), Size = UDim2.new(1, -38, 1, 0),
            TextColor3 = WHITE, TextXAlignment = Enum.TextXAlignment.Left, Text = "", ZIndex = 5, Parent = WMGlass,
        }, "Medium", 12)
        -- Viền sáng
        local WMRim = New("Frame", {
            BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, ZIndex = 6, Parent = WM,
        })
        New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = WMRim})
        local WMStroke = New("UIStroke", {Color = WHITE, Thickness = 1.2, Transparency = 0, Parent = WMRim})
        New("UIGradient", {
            Rotation = 20,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.15), NumberSequenceKeypoint.new(0.5, 0.88), NumberSequenceKeypoint.new(1, 0.25)}),
            Parent = WMStroke,
        })

        local function ClampWM(pos)
            local vp = ScreenGui.AbsoluteSize
            if vp.X <= 0 or vp.Y <= 0 then return pos end
            local hw = math.max(WM.AbsoluteSize.X / 2, 20)
            local cx = vp.X * pos.X.Scale + pos.X.Offset
            local cy = vp.Y * pos.Y.Scale + pos.Y.Offset
            local ncx = math.clamp(cx, hw, math.max(vp.X - hw, hw))
            local ncy = math.clamp(cy, 0, math.max(vp.Y - WM_H, 0))
            return UDim2.new(pos.X.Scale, pos.X.Offset + (ncx - cx), pos.Y.Scale, pos.Y.Offset + (ncy - cy))
        end
        MakeDraggable(WM, WM, ClampWM)

        local frames, acc, fps = 0, 0, 60
        local hbConn = nil
        local function PingMs()
            local okP, v = pcall(function()
                return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            if okP and type(v) == "number" then return math.floor(v + 0.5) end
            return nil
        end
        local function Refresh()
            if not WM.Parent then return end
            local ping = PingMs()
            local text = string.format("%s  |  %d FPS  |  %s  |  %s",
                TitleLabel.Text, math.floor(fps + 0.5), ping and (ping .. " ms") or "-- ms", os.date("%H:%M"))
            WMLabel.Text = text
            local _, tw = MeasureText(text, "Medium", 12, 700)
            WM.Size = UDim2.fromOffset(tw + 46, WM_H)
        end
        local function Stop()
            if hbConn then hbConn:Disconnect() hbConn = nil end
        end
        local function Start()
            if hbConn then return end
            frames, acc = 0, 0
            hbConn = RunService.Heartbeat:Connect(function(dt)
                frames = frames + 1
                acc = acc + dt
                if acc >= (MeizuLibrary.PerfMode and 1 or 0.5) then
                    fps = frames / acc
                    frames, acc = 0, 0
                    Refresh()
                end
            end)
            table.insert(MeizuLibrary._Connections, hbConn)
        end
        local function SetWatermark(on)
            if not WM.Parent then return end
            if on then
                WM.Visible = true
                Refresh()
                Start()
                Tween(WMScale, 0.35, {Scale = 1}, Enum.EasingStyle.Back)
            else
                Stop()
                Tween(WMScale, 0.2, {Scale = 0.9})
                task.delay(0.22, function()
                    if not MeizuLibrary.WatermarkOn and WM.Parent then WM.Visible = false end
                end)
            end
        end
        MeizuLibrary._SetWatermarkImpl = SetWatermark
        function Window:SetWatermark(on) MeizuLibrary:SetWatermark(on) end
        if MeizuLibrary.WatermarkOn then SetWatermark(true) end
    end

    --// ==================== HOÀN TẤT DỰNG UI -> KÍCH HOẠT AUTO LOAD / "LÊN ĐẠN" AUTO SAVE ====================
    -- Đợi hub dựng xong (không có element mới nào trong ~1.2 giây, tối đa 20 giây), sau đó:
    --   1) kích hoạt callback cho các giá trị đã lưu (tính năng thật sự chạy),
    --   2) cho phép Auto Save hoạt động (trước đó mọi giá trị mặc định lúc dựng UI đều bị bỏ qua).
    task.spawn(function()
        local started = os.clock()
        while not MeizuLibrary.Destroyed do
            task.wait(0.4)
            local now = os.clock()
            if now - MeizuLibrary._LastBind > 1.2 or now - started > 20 then break end
        end
        if MeizuLibrary.Destroyed then return end
        local applied = 0
        MeizuLibrary._Loading = true
        for _, p in pairs(MeizuLibrary._AutoPending) do
            if p.El then
                pcall(p.El.Set, Deserialize(p.Value), true)
                applied = applied + 1
            end
        end
        MeizuLibrary._AutoPending = {}
        MeizuLibrary._Loading = false
        MeizuLibrary._AutoArmed = true
        if MeizuLibrary.AutoSave and MeizuLibrary._AutoDirty then
            MeizuLibrary._AutoDirty = false
            MeizuLibrary:_QueueAutoSave()
        end
        if applied > 0 then
            MeizuLibrary:Notify({Title = "Config", Content = "Auto-loaded the last saved settings.", Type = "success", Duration = 3})
        end
    end)

    --// ==================== SETTINGS TAB (TỰ ĐỘNG) ====================
    if config.SettingsTab ~= false then
        local themeNames = {}
        for k in pairs(MeizuLibrary.Themes) do table.insert(themeNames, k) end
        table.sort(themeNames)

        -- Tab Cài đặt có icon (mặc định rbxassetid://10734950309) nên không còn bị trống
        local SettingsTab = Window:CreateTab("Settings", config.SettingsIcon or SETTINGS_TAB_ICON, 9999)
        Window.SettingsTab = SettingsTab
        SettingsTab:CreateParagraph({Title = "Meizu Library v" .. MeizuLibrary.Version, Content = ABOUT_KEY})

        --// Giao diện
        local Appearance = SettingsTab:CreateSection("Appearance")
        local themeDD = Appearance:CreateDropdown({
            Title = "Theme", Options = themeNames, Default = MeizuLibrary.Theme,
            Callback = function(v) if v then MeizuLibrary:ApplyTheme(v) end end,
        })
        local accentPicker = Appearance:CreateColorPicker({
            Title = "Accent Color", Default = MeizuLibrary._UserAccent or MeizuLibrary.Accent,
            Callback = function(c) MeizuLibrary:SetAccent(c) end,
        })
        local rainbowToggle = Appearance:CreateToggle({
            Title = "Rainbow Accent", Default = false,
            Callback = function(v) MeizuLibrary:SetRainbow(v) end,
        })
        local fontDD = Appearance:CreateDropdown({
            Title = "Font", Options = MeizuLibrary.FontOrder, Default = MeizuLibrary.FontName,
            Callback = function(v) if v then MeizuLibrary:SetFont(v) end end,
        })
        local scaleSlider = Appearance:CreateSlider({
            Title = "UI Scale", Min = 70, Max = 120, Increment = 5, Suffix = "%",
            Default = math.floor((MeizuLibrary.UIScale or 1) * 100 + 0.5),
            Callback = function(v) Window:SetScale(v / 100) end,
        })
        local glassToggle = Appearance:CreateToggle({
            Title = "Glass Window", Description = "Slightly transparent window surfaces",
            Default = MeizuLibrary.GlassWindow,
            Callback = function(v) MeizuLibrary:SetGlassWindow(v) end,
        })
        local blurToggle = Appearance:CreateToggle({
            Title = "Background Blur", Description = "Blur the game behind the UI while it is open",
            Default = MeizuLibrary.BlurEnabled,
            Callback = function(v) MeizuLibrary:SetBlur(v) end,
        })
        local blurSlider = Appearance:CreateSlider({
            Title = "Blur Strength", Min = 2, Max = 30, Default = MeizuLibrary.BlurSize,
            Callback = function(v) MeizuLibrary:SetBlur(nil, v) end,
        })
        local perfToggle = Appearance:CreateToggle({
            Title = "Performance Mode", Description = "Reduce effects to boost FPS",
            Default = MeizuLibrary.PerfMode,
            Callback = function(v) MeizuLibrary:SetPerformanceMode(v) end,
        })
        local soundToggle, langDD, wmToggle, autoSaveToggle, autoLoadToggle
        local function ResetAppearance()
            MeizuLibrary:ResetAppearance()
            Window:SetScale(1)
            themeDD.Set(MeizuLibrary.Theme)
            accentPicker.Set(MeizuLibrary._UserAccent or MeizuLibrary.Accent)
            rainbowToggle.Set(false)
            fontDD.Set(MeizuLibrary.FontName)
            scaleSlider.Set(100)
            glassToggle.Set(false)
            blurToggle.Set(false)
            blurSlider.Set(DEFAULT_BLUR_SIZE)
            perfToggle.Set(false)
            if soundToggle then soundToggle.Set(true) end
            MeizuLibrary:Notify({Title = "Appearance", Content = "Appearance has been reset.", Type = "success"})
        end
        Appearance:CreateButton({
            Title = "Reset Appearance",
            Description = "Restore theme, accent, font and scale to default",
            Callback = ResetAppearance,
        })
        Appearance:CreateButton({
            Title = "Reset Window",
            Description = "Restore the default size and position",
            Callback = function() Window:ResetLayout() end,
        })

        --// Chung
        local General = SettingsTab:CreateSection("General")
        local langNames = {}
        for _, code in ipairs(MeizuLibrary.LanguageOrder) do table.insert(langNames, MeizuLibrary.Languages[code]) end
        langDD = General:CreateDropdown({
            Title = "Language", Options = langNames, Default = MeizuLibrary.Languages[MeizuLibrary.Language],
            Callback = function(v) if v then MeizuLibrary:SetLanguage(v) end end,
        })
        General:CreateKeybind({
            Title = "Toggle UI Keybind", Default = MeizuLibrary.ToggleKeybind,
            ChangedCallback = function(key) if key then MeizuLibrary:SetToggleKeybind(key) end end,
        })
        soundToggle = General:CreateToggle({
            Title = "Sound Effects", Default = MeizuLibrary.SoundEnabled,
            Callback = function(v) MeizuLibrary:SetSound(v) end,
        })
        wmToggle = General:CreateToggle({
            Title = "Watermark (FPS / Ping)", Description = "Floating glass bar with FPS, ping and clock",
            Default = MeizuLibrary.WatermarkOn,
            Callback = function(v) MeizuLibrary:SetWatermark(v) end,
        })

        --// Cấu hình
        local Config = SettingsTab:CreateSection("Configuration")
        local configName = "config"
        local nameInput, savedDD
        nameInput = Config:CreateInput({
            Title = "Config Name", Default = configName, Placeholder = "Config Name",
            Callback = function(text) configName = tostring(text or "") end,
        })
        savedDD = Config:CreateDropdown({
            Title = "Saved Configs", Options = MeizuLibrary:ListConfigs(),
            Callback = function(name)
                if name then
                    configName = tostring(name)
                    nameInput.Set(configName)
                end
            end,
        })
        Config:CreateButton({
            Title = "Save Config",
            Callback = function()
                local name = Trim(configName)
                if name == "" then name = "config" end
                if not HasFileSystem() then
                    MeizuLibrary:Notify({Title = "Config", Content = "Your executor does not support file saving (writefile).", Type = "error"})
                    return
                end
                if MeizuLibrary:SaveSettings(name) then
                    MeizuLibrary:Notify({Title = "Config", Content = string.format(L("Config saved: %s"), EscapeRich(name)), Type = "success"})
                    savedDD.UpdateOptions(MeizuLibrary:ListConfigs())
                else
                    MeizuLibrary:Notify({Title = "Config", Content = "Could not save the config.", Type = "error"})
                end
            end,
        })
        Config:CreateButton({
            Title = "Load Config",
            Callback = function()
                local name = Trim(configName)
                if name == "" then name = "config" end
                if MeizuLibrary:LoadSettings(name) then
                    MeizuLibrary:Notify({Title = "Config", Content = string.format(L("Config loaded: %s"), EscapeRich(name)), Type = "success"})
                else
                    MeizuLibrary:Notify({Title = "Config", Content = "Config not found!", Type = "error"})
                end
            end,
        })
        autoSaveToggle = Config:CreateToggle({
            Title = "Auto Save", Description = "Save every change automatically",
            Default = MeizuLibrary.AutoSave,
            Callback = function(v) MeizuLibrary:SetAutoSave(v) end,
        })
        autoLoadToggle = Config:CreateToggle({
            Title = "Auto Load", Description = "Restore the last saved settings when the UI opens",
            Default = MeizuLibrary.AutoLoad,
            Callback = function(v) MeizuLibrary:SetAutoLoad(v) end,
        })
        -- Giữ các công tắc trong Cài đặt luôn khớp trạng thái thật, kể cả khi script gọi thẳng API
        -- (Library:SetBlur(true), :SetLanguage("en")...). Chỉ đồng bộ công tắc / danh sách chọn — KHÔNG đụng vào
        -- thanh trượt và bảng màu để không giật khi người dùng đang kéo.
        MeizuLibrary._SyncSettings = function()
            local function Put(el, value) if el then pcall(el.Set, value) end end
            Put(themeDD, MeizuLibrary.Theme)
            Put(fontDD, MeizuLibrary.FontName)
            Put(langDD, MeizuLibrary.Languages[MeizuLibrary.Language])
            Put(rainbowToggle, MeizuLibrary._RainbowConn ~= nil)
            Put(glassToggle, MeizuLibrary.GlassWindow)
            Put(blurToggle, MeizuLibrary.BlurEnabled)
            Put(perfToggle, MeizuLibrary.PerfMode)
            Put(soundToggle, MeizuLibrary.SoundEnabled)
            Put(wmToggle, MeizuLibrary.WatermarkOn)
            Put(autoSaveToggle, MeizuLibrary.AutoSave)
            Put(autoLoadToggle, MeizuLibrary.AutoLoad)
        end

        Config:CreateButton({
            Title = "Unload Library",
            Description = "Remove the whole UI from the game",
            Callback = function()
                Window:Dialog({
                    Title = "Unload Library",
                    Content = "Are you sure you want to unload the UI?",
                    Buttons = {
                        {Title = "Cancel"},
                        {Title = "Unload", Callback = function() MeizuLibrary:Destroy() end},
                    },
                })
            end,
        })
    end

    --// ==================== HOÀN TẤT ====================
    Window.Main = Main
    Window.Root = Root
    Window.ScreenGui = ScreenGui

    task.delay(0.15, function()
        if MeizuLibrary.Destroyed or not Root.Parent then return end
        Window:_AutoSelect()
        if config.AutoOpen ~= false then SetOpen(true) end
    end)

    return Window
end

return MeizuLibrary
