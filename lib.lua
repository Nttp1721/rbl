--[[
    ═══════════════════════════════════════════════════════════════════
    MEIZU LIBRARY v3.0 "Luxe"  +  MEIZU EXTRAS v1.1  —  BẢN GHÉP SẴN
    ═══════════════════════════════════════════════════════════════════
    ⚠ FILE NÀY ĐÃ GHÉP SẴN library + extras → DÙNG LUÔN, ĐỪNG GHÉP THÊM!
    (Bản ghép thủ công theo hướng dẫn cũ bị lỗi cú pháp vì lệnh return
     nằm giữa file → loadstring trả nil → "attempt to call a nil value")

    CÁCH DÙNG — chọn 1 trong 2:
    ─────────────────────────────────────────────────────────────────
    CÁCH 1 • TẢI TỪ LINK (thay link cũ bằng link file này):
        local MeizuLibrary = loadstring(game:HttpGet("LINK_FILE_NÀY"))()
        local Window = MeizuLibrary:CreateWindow{ Title = "Hub của tôi" }
        -- tiện ích extras dùng biến global MeizuExtras (đã tự nạp):
        MeizuExtras:EnableWatermark{ ShowFPS = true, ShowPing = true }

    CÁCH 2 • DÁN TRỰC TIẾP vào executor:
        Dán toàn bộ file, viết hub của bạn vào chỗ đánh dấu
        "VIẾT HUB CỦA BẠN TẠI ĐÂY" gần cuối file (ngay TRÊN dòng
        return MeizuLibrary), ví dụ:
            local Window = MeizuLibrary:CreateWindow{ Title = "Hub của tôi" }
            Extras:EnableWatermark{ ShowFPS = true }

    SỬA TRONG BẢN NÀY (v3.0.1):
      • Fix "attempt to call a nil value" ở dòng 1 (nguyên nhân như trên).
      • Thêm MEIZU SAFE-ENV: môi trường thiếu getgenv/gethui/writefile...
        tự được thay bằng bản giả an toàn → chạy được cả trong Roblox Studio.
      • Extras tự Init + tự bám theme/màu nhấn của library, không cần gọi tay.
]]

--// ════════════════ MEIZU SAFE-ENV (giữ nguyên, đừng xoá) ════════════════
-- Tự thay hàm executor bị thiếu bằng bản giả an toàn → hết lỗi
-- "attempt to call a nil value" trên môi trường yếu / Roblox Studio.
do
	local function _mzMissing(name)
		warn("[MEIZU SAFE-ENV] Moi truong thieu '" .. name .. "' -> da thay bang ban gia an toan")
	end

	if type(getgenv) ~= "function" then
		getgenv = function() return _G end
		_mzMissing("getgenv")
	end

	if type(gethui) ~= "function" then
		gethui = function()
			local plr = game:GetService("Players").LocalPlayer
			if plr then
				local pg = plr:FindFirstChildOfClass("PlayerGui")
				if pg then return pg end
			end
			return game:GetService("CoreGui")
		end
		_mzMissing("gethui")
	end

	if type(syn) ~= "table" then syn = {} end
	if type(syn.protect_gui) ~= "function" then
		syn.protect_gui = function(gui) return gui end
		_mzMissing("syn.protect_gui")
	end

	do
		local MEM = {}
		if type(writefile) ~= "function" then
			writefile = function(n, d) MEM[tostring(n)] = tostring(d) end
			_mzMissing("writefile (ghi RAM)")
		end
		if type(readfile) ~= "function" then
			readfile = function(n) return MEM[tostring(n)] or "" end
			_mzMissing("readfile (doc RAM)")
		end
		if type(appendfile) ~= "function" then
			appendfile = function(n, d) MEM[tostring(n)] = (MEM[tostring(n)] or "") .. tostring(d) end
		end
		if type(isfile) ~= "function" then
			isfile = function(n) return MEM[tostring(n)] ~= nil end
		end
		if type(isfolder) ~= "function" then isfolder = function() return false end end
		if type(makefolder) ~= "function" then makefolder = function() end end
		if type(listfiles) ~= "function" then listfiles = function() return {} end end
	end

	if type(setclipboard) ~= "function" then
		setclipboard = function(txt)
			warn("[MEIZU SAFE-ENV] setclipboard khong kha dung. Noi dung: " .. tostring(txt))
		end
	end
	if type(identifyexecutor) ~= "function" then
		identifyexecutor = function() return "Unknown/Studio" end
	end
	if type(request) ~= "function" and type(http_request) ~= "function" then
		http_request = function() return { Success = false, StatusCode = 0, Body = "", Headers = {} } end
		request = http_request
		_mzMissing("request")
	elseif type(http_request) ~= "function" and type(request) == "function" then
		http_request = request
	end
	if type(cloneref) ~= "function" then cloneref = function(obj) return obj end end
	if type(hookfunction) ~= "function" then hookfunction = function(old) return old end end
	if type(loadstring) ~= "function" then
		loadstring = function()
			warn("[MEIZU SAFE-ENV] loadstring khong kha dung -> dan code truc tiep, dung tai link!")
			return nil
		end
	end
end

--[[ ════════════════════════════════════════════════════════════
     PHẦN 1 • MEIZU LIBRARY v3.0 "Luxe" (nguyên vẹn, không sửa chữ nào)
     ════════════════════════════════════════════════════════════ ]]

--[[
    ███╗   ███╗███████╗██╗███████╗██╗   ██╗
    ████╗ ████║██╔════╝██║██╔════╝╚██╗ ██╔╝
    ██╔████╔██║█████╗  ██║███████╗ ╚████╔╝
    ██║╚██╔╝██║██╔══╝  ██║╚════██║  ╚██╔╝
    ██║ ╚═╝ ██║███████╗██║███████║   ██║
    ╚═╝     ╚═╝╚══════╝╚═╝╚══════╝   ╚═╝
    MEIZU LIBRARY v3.0 "Luxe" — Modern UI Library cho Roblox (Fluent-inspired)
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
      Library.Utils = {UpperVN, StripAccents, NormalizeSearch, EscapeRich}

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
--// ====================================================

local MeizuLibrary = {
    Version       = "3.0",
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

MeizuLibrary.Utils = {
    UpperVN         = UpperVN,
    StripAccents    = StripAccents,
    NormalizeSearch = NormalizeSearch,
    EscapeRich      = EscapeRich,
    SanitizeFileName = SanitizeFileName,
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
            if acc < 0.033 then return end          -- ~30 lần/giây là đủ mượt
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
end

function MeizuLibrary:SetFont(name)
    if not self.FontPresets[name] then return false end
    self.FontName = name
    local list = self._FontObjs
    PruneList(list)
    for i = 1, #list do pcall(SetFontEntry, list[i]) end
    for _, fn in ipairs(self._FontHooks) do pcall(fn) end
    self:_SaveUiPrefs()
    return true
end

function MeizuLibrary:SetSound(enabled)
    self.SoundEnabled = (enabled == true)
    self:_SaveUiPrefs()
end

function MeizuLibrary:SetToggleKeybind(key)
    if typeof(key) == "EnumItem" then
        self.ToggleKeybind = key
        self:_SaveUiPrefs()
    end
end

-- Đặt lại chủ đề / màu nhấn / phông / âm thanh về mặc định (UI Cài đặt tự đồng bộ ở nơi gọi)
function MeizuLibrary:ResetAppearance()
    self:SetRainbow(false)
    self.UIScale = 1
    self.SoundEnabled = true
    self:ApplyTheme(self._BaseTheme or "Dark")
    local base = self._BaseAccent or Color3.fromRGB(88, 101, 242)
    self._UserAccent = base
    self:ApplyAccent(base)
    self:SetFont(DEFAULT_FONT)
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
    for flag, v in pairs(data) do
        local el = self._FlagElems[flag]       -- khoá cũ (__language, __toggleimage) tự bị bỏ qua
        if el then pcall(el.Set, Deserialize(v), fire) end
    end
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
    local SIDEBAR_W = SIDEBAR_WIDTH
    local HEADER_H = HEADER_HEIGHT

    local isOpen = false
    local IconWrap = nil

    --// ---------------- ROOT (vị trí + co giãn) -> POP (hiệu ứng mở) -> SHADOW + MAIN ----------------
    local Root = New("Frame", {
        Name = "Root",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
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

    --// ======================== SIDEBAR ========================
    local Sidebar = New("Frame", {
        Name = "Sidebar", BackgroundColor3 = T("Sidebar"),
        Size = UDim2.new(0, SIDEBAR_W, 1, 0), BorderSizePixel = 0,
        ZIndex = 2, Parent = Main,
    })
    Register(Sidebar, {BackgroundColor3 = "Sidebar"})
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
    MakeDraggable(BrandDrag, Root, ClampWindow)

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
    MakeDraggable(Header, Root, ClampWindow)

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
    local function BindElements(target, container, tab, secRec)
        if target.CreateSection then return end

        -- Gọi bằng "." hay ":" đều được: el.SetTitle("x") / el:SetTitle("x")
        local function ArgAfterSelf(el, x, y)
            if x == el then return y end
            return x
        end

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
            return Title, Desc, titleBind, descBind
        end

        -- Đăng ký element vào bộ lọc tìm kiếm (chữ gốc + bản dịch, không phân biệt dấu)
        local function AddSearch(Card, ...)
            local rec = {Frame = Card, Text = SearchText(...), Section = secRec}
            table.insert(tab._Elements, rec)
            if secRec then table.insert(secRec.Items, rec) end
        end

        local function BindFlag(el, flag, initial)
            if flag then
                MeizuLibrary._FlagElems[flag] = el
                MeizuLibrary.Flags[flag] = initial
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

        --// SECTION
        function target:CreateSection(name)
            name = tostring(name or "Section")
            local Sec = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BorderSizePixel = 0, Parent = container,
            })
            New("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Sec})
            local Head = New("Frame", {
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

            local Line = New("Frame", {
                BackgroundColor3 = T("Stroke"), BackgroundTransparency = 0.5,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 120, 0.5, 0), Size = UDim2.new(1, -120, 0, 1),
                BorderSizePixel = 0, Parent = Head,
            })
            Register(Line, {BackgroundColor3 = "Stroke"})
            local function LayoutHead()
                if not Head.Parent then return end
                local _, tw = MeasureText(SecLabel.Text, "Bold", 11, 600)
                SecLabel.Size = UDim2.new(0, tw + 4, 1, 0)
                local x = 13 + tw + 14
                Line.Position = UDim2.new(0, x, 0.5, 0)
                Line.Size = UDim2.new(1, -x, 0, 1)
            end
            LayoutHead()
            OnLangChange(LayoutHead)
            OnFontChange(LayoutHead)

            local rec = {Frame = Sec, Head = Head, Text = SearchText(name), Items = {}}
            table.insert(tab._Sections, rec)

            local SectionObj = {Frame = Sec}
            BindElements(SectionObj, Sec, tab, rec)
            return SectionObj
        end

        --// BUTTON
        function target:CreateButton(cfg)
            cfg = cfg or {}
            local hasDesc = cfg.Description ~= nil
            local Card = MakeCard(hasDesc and 58 or 42, true)
            local _, _, titleBind = AddText(Card, cfg.Title or "Button", cfg.Description, 40)
            DrawChevronRight(Card, -16)

            Card.InputBegan:Connect(function(input)
                if IsPointer(input) then
                    local p = (PointerPos(input) - Card.AbsolutePosition) / GuiScale()
                    Ripple(Card, p.X, p.Y)
                end
            end)
            Card.Activated:Connect(function() SafeCall(cfg.Callback) end)
            AddSearch(Card, cfg.Title, cfg.Description)

            local el = {Frame = Card}
            el.Fire = function() SafeCall(cfg.Callback) end
            el.SetTitle = function(x, y)
                titleBind.Key = tostring(ArgAfterSelf(el, x, y) or "")
                RefreshBinding(titleBind)
            end
            return el
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
                if cfg.Flag then MeizuLibrary.Flags[cfg.Flag] = v end
                if fire then SafeCall(cfg.Callback, v) end
            end
            Card.Activated:Connect(function() Set(not state, true) end)
            Render(state, false)
            OnThemeChange(function() Render(state, false) end)
            OnAccentChange(function() if state then Render(true, false) end end)   -- FIX: đổi màu nhấn cập nhật công tắc đang bật

            local el = {Frame = Card, Get = function() return state end, Set = function(v, fire) Set(v, fire) end}
            BindFlag(el, cfg.Flag, state)
            AddSearch(Card, cfg.Title, cfg.Description)
            return el
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
                if cfg.Flag then MeizuLibrary.Flags[cfg.Flag] = v end
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
            AddSearch(Card, cfg.Title, cfg.Description)
            return el
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
                if cfg.Flag then MeizuLibrary.Flags[cfg.Flag] = GetSelected() end
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
            AddSearch(Card, cfg.Title, cfg.Description)
            return el
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
                if cfg.Flag then MeizuLibrary.Flags[cfg.Flag] = key and key.Name or "None" end
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
            AddSearch(Card, cfg.Title, cfg.Description)
            return el
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
                    MeizuLibrary.Flags[cfg.Flag] = Box.Text
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
                if cfg.Flag then MeizuLibrary.Flags[cfg.Flag] = Box.Text end
                SafeCall(cfg.Callback, Box.Text, enter)
            end)

            local el = {
                Frame = Card,
                Get = function() return Box.Text end,
                Set = function(v, fire)
                    Box.Text = tostring(v == nil and "" or v)
                    if cfg.Flag then MeizuLibrary.Flags[cfg.Flag] = Box.Text end
                    if fire then SafeCall(cfg.Callback, Box.Text, false) end
                end,
            }
            BindFlag(el, cfg.Flag, Box.Text)
            AddSearch(Card, cfg.Title, cfg.Description)
            return el
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
                if cfg.Flag then MeizuLibrary.Flags[cfg.Flag] = color end
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
            AddSearch(Card, cfg.Title, cfg.Description)
            return el
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

            AddSearch(Card, cfg.Title, cfg.Content)

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
            return element
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
                    e.Frame.Visible = show
                    if show then matches = matches + 1 end
                end
            end
            -- ẩn tiêu đề section khi không còn mục nào hiển thị
            for _, sec in ipairs(t._Sections) do
                if sec.Frame and sec.Frame.Parent then
                    local vis = (q == "")
                    if not vis then
                        for _, it in ipairs(sec.Items) do
                            if it.Frame.Parent and it.Frame.Visible then vis = true break end
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
        local target = first or Window.SettingsTab or Window._Tabs[1]
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

        --// ---- Hoạt ảnh lặp: viền lắc nhẹ như ánh sáng đổi góc, quầng sáng logo thở ----
        local function Loop(obj, props, time, delayTime)
            pcall(function()
                TweenService:Create(obj,
                    TweenInfo.new(time, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, delayTime or 0),
                    props):Play()
            end)
        end
        if GLASS then
            if GradA then Loop(GradA, {Rotation = 80}, 4.2) end
            if GradB then Loop(GradB, {Rotation = 175}, 5.6, 0.4) end
            if LogoGlow then Loop(LogoGlow, {ImageTransparency = 0.58}, 2.6) end
            task.spawn(function()      -- vệt sáng quét ngang mỗi ~5 giây
                task.wait(1.2)
                while ToggleBtn.Parent and not MeizuLibrary.Destroyed do
                    if Glint and Glint.Parent then
                        Glint.Position = UDim2.new(-0.5, 0, 0.5, 0)
                        Tween(Glint, 0.9, {Position = UDim2.new(1.5, 0, 0.5, 0)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                    end
                    task.wait(4.5 + math.random() * 2)
                end
            end)
        end

        task.spawn(function()          -- sóng lan khi UI đang ẩn
            while ToggleBtn.Parent and not MeizuLibrary.Destroyed do
                if not isOpen and PulseRing.Parent then
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

        ToggleBtn.MouseEnter:Connect(function() hovering = true ApplyPhysics() end)
        ToggleBtn.MouseLeave:Connect(function() hovering = false ApplyPhysics() end)

        -- Một handler duy nhất cho cả bấm (click) lẫn kéo (drag); kéo > 6px thì không tính là click
        ToggleBtn.InputBegan:Connect(function(input)
            if not IsPointer(input) then return end
            local startPointer = PointerPos(input)
            local startPos = ToggleBtn.Position
            local moved = false
            pressed = true
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
                    if not moved then Window:Toggle() end
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
    end

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
        local soundToggle
        local function ResetAppearance()
            MeizuLibrary:ResetAppearance()
            Window:SetScale(1)
            themeDD.Set(MeizuLibrary.Theme)
            accentPicker.Set(MeizuLibrary._UserAccent or MeizuLibrary.Accent)
            rainbowToggle.Set(false)
            fontDD.Set(MeizuLibrary.FontName)
            scaleSlider.Set(100)
            if soundToggle then soundToggle.Set(true) end
            MeizuLibrary:Notify({Title = "Appearance", Content = "Appearance has been reset.", Type = "success"})
        end
        Appearance:CreateButton({
            Title = "Reset Appearance",
            Description = "Restore theme, accent, font and scale to default",
            Callback = ResetAppearance,
        })

        --// Chung
        local General = SettingsTab:CreateSection("General")
        local langNames = {}
        for _, code in ipairs(MeizuLibrary.LanguageOrder) do table.insert(langNames, MeizuLibrary.Languages[code]) end
        General:CreateDropdown({
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


--[[ ════════════════════════════════════════════════════════════
     PHẦN 2 • MEIZU EXTRAS v1.1 (nguyên vẹn, đã kiểm tra cú pháp)
     ════════════════════════════════════════════════════════════ ]]

--[[
    ███╗   ███╗███████╗██╗███████╗██╗   ██╗
    ██╔████╔██║██╔════╝██║██╔════╝╚██╗ ██╔╝
    ██║██╔╝██╗█████╗  ██║███████╗ ╚████╔╝
    ██║███╗██║██╔══╝  ██║╚════██║  ╚██╔╝
    ███╔███╔██║██║███╗██║███████║   ██║
    ╚═╝ ╚══╝ ╚═╝╚════╝╚═╝╚══════╝   ╚═╝
    MEIZU EXTRAS v1.0 — Bộ tiện ích nhỏ mở rộng cho Meizu Library v3.0 "Luxe"
    ===========================================================================
    CÁCH DÙNG: Dán toàn bộ file này xuống CUỐI file library (hoặc loadstring riêng),
    KHÔNG cần sửa gì file library cả.

      Extras:Init(MeizuLibrary)     -- (tùy chọn) tự bám theme/màu nhấn của library
      Extras:EnableWatermark{...}   -- Thanh kính: FPS / Ping / Giờ / Uptime / Chữ riêng (kéo được)
      Extras:EnableKeyVisualizer()  -- Hiện phím vừa bấm kiểu streamer (hỗ trợ LMB/RMB/TAP)
      Extras:EnableLogger{...}      -- Console nổi ghi log: Extras:Log / :Warn / :Error / :ClearLog
      Extras:AttachTooltip(obj, s)  -- Tooltip kính theo chuột, tự lật khi sát mép màn hình
      Extras:NewContextMenu(obj, m) -- Menu chuột phải cho BẤT KỲ element / GuiObject nào
      Extras:SetPanicKey(KeyCode.F8)-- 1 phím ẩn/hiện TOÀN BỘ UI (library + extras)
      Extras:ToggleFPSBoost(true)   -- Giảm đồ hoạ tăng FPS (hoàn tác được nguyên trạng)
      Extras:EnableAntiAFK(true)    -- Chống bị kick vì đứng yên
      Extras:SyncTheme()            -- Cập nhật lại màu cho widget theo theme hiện tại
      Extras:Destroy()              -- Dọn sạch toàn bộ tiện ích
]]

local Extras = { Version = "1.0", Library = nil, _Gui = nil, SoundEnabled = true }

local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local TextService      = game:GetService("TextService")
local Players          = game:GetService("Players")
local Lighting         = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- ===== BẢNG MÀU (SyncTheme sẽ tự cập nhật theo library) =====
local C = {
    Bg     = Color3.fromRGB(18, 20, 28),
    Panel  = Color3.fromRGB(22, 25, 34),
    Text   = Color3.fromRGB(240, 242, 248),
    Sub    = Color3.fromRGB(148, 153, 168),
    Stroke = Color3.fromRGB(45, 50, 66),
    Accent = Color3.fromRGB(88, 101, 242),
    Ok     = Color3.fromRGB(80, 200, 120),
    Warn   = Color3.fromRGB(255, 184, 77),
    Err    = Color3.fromRGB(255, 95, 95),
}

-- ===== HELPERS =====
local function New(class, props, children)
    local obj = Instance.new(class)
    local parent = nil
    if props then
        for k, v in pairs(props) do
            if k == "Parent" then parent = v else obj[k] = v end
        end
    end
    if children then
        for _, ch in ipairs(children) do ch.Parent = obj end
    end
    if parent then obj.Parent = parent end
    return obj
end

local function Tween(obj, time, props, style, dir)
    if not obj then return end
    pcall(function()
        TweenService:Create(obj,
            TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
            props):Play()
    end)
end

local function Round(obj, px)
    New("UICorner", {CornerRadius = UDim.new(0, px or 8), Parent = obj})
end

local function Measure(text, size, font, width)
    local ok, v = pcall(function()
        return TextService:GetTextSize(tostring(text), size, font or Enum.Font.SourceSans,
            Vector2.new(width or 2000, 10000))
    end)
    if ok and v then return math.max(math.ceil(v.X), 4), math.max(math.ceil(v.Y), size) end
    return #tostring(text) * math.floor(size * 0.55), size
end

local function MousePos()
    local ok, p = pcall(function() return UserInputService:GetMouseLocation() end)
    if ok and p then return p end
    return Vector2.new(0, 0)
end

local function ScreenSize()
    local ok, v = pcall(function() return workspace.CurrentCamera.ViewportSize end)
    if ok and v then return v end
    return Vector2.new(1920, 1080)
end

local function PlayClick(vol, speed)
    if not Extras.SoundEnabled then return end
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxasset://sounds/electronicpingshort.wav"
        s.Volume = vol or 0.15
        s.PlaybackSpeed = speed or 1.3
        s.Parent = game:GetService("SoundService")
        s:Play()
        task.delay(2, function() if s then s:Destroy() end end)
    end)
end

local function GetGui()
    if Extras._Gui and Extras._Gui.Parent then return Extras._Gui end
    local gui = Instance.new("ScreenGui")
    gui.Name = "MeizuExtras"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 9998
    local ok = pcall(function()
        if type(syn) == "table" and type(syn.protect_gui) == "function" then syn.protect_gui(gui) end
        local parent = (type(gethui) == "function" and gethui()) or game:GetService("CoreGui")
        gui.Parent = parent
    end)
    if not ok or not gui.Parent then
        local lp = Players.LocalPlayer
        if lp then gui.Parent = lp:WaitForChild("PlayerGui") end
    end
    Extras._Gui = gui
    return gui
end

-- Kéo widget (chuột + cảm ứng), gọn nhẹ dùng riêng cho extras
local function Draggable(handle, target)
    handle.Active = true
    handle.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local startPos = target.Position
        local sx, sy = input.Position.X, input.Position.Y
        local moveConn, upConn
        moveConn = UserInputService.InputChanged:Connect(function(inp)
            if inp.UserInputType ~= Enum.UserInputType.MouseMovement
            and inp.UserInputType ~= Enum.UserInputType.Touch then return end
            local dx, dy = inp.Position.X - sx, inp.Position.Y - sy
            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + dx,
                startPos.Y.Scale, startPos.Y.Offset + dy)
        end)
        upConn = UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                if moveConn then moveConn:Disconnect() end
                if upConn then upConn:Disconnect() end
            end
        end)
    end)
end

-- Chấp nhận cả GuiObject lẫn element của library (tự dò field GUI phổ biến)
local function ResolveTarget(target)
    if type(target) == "table" then
        for _, k in ipairs({"Frame", "Main", "Container", "Button", "Hitbox", "Object", "Instance", "Element"}) do
            local v = target[k]
            if typeof(v) == "Instance" and v:IsA("GuiObject") then return v end
        end
        return nil
    end
    if typeof(target) == "Instance" and target:IsA("GuiObject") then return target end
    return nil
end

--// ==================== 1) WATERMARK (FPS / PING / GIỜ / UPTIME) ====================
local WM = nil

function Extras:DisableWatermark()
    if not WM then return end
    if WM._c1 then WM._c1:Disconnect() end
    if WM._c2 then WM._c2:Disconnect() end
    if WM.Card then WM.Card:Destroy() end
    WM = nil
end

function Extras:EnableWatermark(cfg)
    cfg = cfg or {}
    self:DisableWatermark()
    local gui = GetGui()

    local showText  = cfg.Text ~= nil and cfg.Text ~= false
    local showFPS   = cfg.ShowFPS ~= false
    local showPing  = cfg.ShowPing ~= false
    local showClock = cfg.ShowClock ~= false
    local showUp    = cfg.ShowUptime ~= false

    local Card = New("CanvasGroup", {
        Name = "Watermark",
        BackgroundColor3 = C.Bg,
        BackgroundTransparency = 0.15,
        Position = cfg.Position or UDim2.new(0, 16, 0, 16),
        Size = UDim2.fromOffset(160, 34),
        GroupTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 50, Parent = gui,
    })
    Round(Card, 10)
    New("UIStroke", {Color = C.Stroke, Thickness = 1, Transparency = 0.25, Parent = Card})

    local Dot = New("Frame", {
        BackgroundColor3 = C.Accent,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 10, 0.5, 0),
        Size = UDim2.fromOffset(8, 8),
        BorderSizePixel = 0, ZIndex = 51, Parent = Card,
    })
    Round(Dot, 4)

    local Label = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 26, 0, 0),
        Size = UDim2.new(1, -32, 1, 0),
        Font = Enum.Font.SourceSansSemibold,
        TextSize = 14,
        TextColor3 = C.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "", ZIndex = 51, Parent = Card,
    })

    local frames, acc, fps, ping = 0, 0, 60, 0
    local t0 = os.clock()

    local c1 = RunService.RenderStepped:Connect(function(dt)
        frames = frames + 1
        acc = acc + dt
        if acc >= 0.5 then
            fps = math.floor(frames / acc + 0.5)
            frames = 0
            acc = 0
        end
    end)

    local function Refresh()
        local parts = {}
        if showText and cfg.Text then table.insert(parts, tostring(cfg.Text)) end
        if showFPS then table.insert(parts, fps .. " FPS") end
        if showPing then table.insert(parts, string.format("%.0f ms", ping * 1000)) end
        if showUp then
            local up = os.clock() - t0
            table.insert(parts, string.format("%d:%02d:%02d",
                math.floor(up / 3600), math.floor(up / 60) % 60, math.floor(up) % 60))
        end
        if showClock then table.insert(parts, os.date("%H:%M:%S")) end
        local txt = table.concat(parts, "  •  ")
        Label.Text = txt
        local w = Measure(txt, 14, Enum.Font.SourceSansSemibold)
        Card.Size = UDim2.fromOffset(w + 40, 34)
    end

    local tAcc = 1
    local c2 = RunService.Heartbeat:Connect(function(dt)
        pcall(function()
            local p = LocalPlayer:GetNetworkPing()
            if p >= 0 and p < 5 then ping = p end
        end)
        tAcc = tAcc + dt
        if tAcc >= 0.5 then
            tAcc = 0
            Refresh()
        end
    end)

    Draggable(Card, Card)
    WM = {Card = Card, Dot = Dot, Label = Label, _c1 = c1, _c2 = c2}

    -- chấm accent "thở" nhẹ
    task.spawn(function()
        while WM and WM.Card == Card and Card.Parent do
            Tween(Dot, 0.8, {BackgroundTransparency = 0.45})
            task.wait(0.8)
            if not (WM and WM.Card == Card) then break end
            Tween(Dot, 0.8, {BackgroundTransparency = 0})
            task.wait(0.8)
        end
    end)

    Tween(Card, 0.3, {GroupTransparency = 0})
    Refresh()
    PlayClick(0.12, 1.4)

    return {
        SetText = function(s) cfg.Text = s Refresh() end,
        Destroy = function() Extras:DisableWatermark() end,
    }
end

--// ==================== 2) KEY VISUALIZER (KIỂU STREAMER) ====================
local KV = nil

function Extras:DisableKeyVisualizer()
    if not KV then return end
    if KV._c then KV._c:Disconnect() end
    if KV.Holder then KV.Holder:Destroy() end
    KV = nil
end

function Extras:EnableKeyVisualizer(cfg)
    cfg = cfg or {}
    self:DisableKeyVisualizer()
    local gui = GetGui()

    local Holder = New("Frame", {
        Name = "KeyVisualizer",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = cfg.Position or UDim2.new(0.5, 0, 1, -70),
        Size = UDim2.fromOffset(500, 60),
        ZIndex = 60, Parent = gui,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 6),
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = Holder,
    })

    local count, order = 0, 0
    local function AddPill(name)
        if count >= 12 then return end
        count = count + 1
        order = order + 1
        local Pill = New("CanvasGroup", {
            BackgroundColor3 = C.Bg,
            BackgroundTransparency = 0.1,
            Size = UDim2.fromOffset(0, 30),
            ClipsDescendants = true,
            LayoutOrder = order,
            GroupTransparency = 0,
            BorderSizePixel = 0, ZIndex = 61, Parent = Holder,
        })
        Round(Pill, 8)
        New("UIStroke", {Color = C.Stroke, Thickness = 1, Transparency = 0.3, Parent = Pill})
        New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 4, 0, 0),
            Size = UDim2.new(1, -8, 1, 0),
            Font = Enum.Font.SourceSansSemibold, TextSize = 14,
            TextColor3 = C.Text, Text = name,
            ZIndex = 62, Parent = Pill,
        })
        local w = Measure(name, 14, Enum.Font.SourceSansSemibold)
        local sc = New("UIScale", {Scale = 0.7, Parent = Pill})
        Tween(sc, 0.25, {Scale = 1}, Enum.EasingStyle.Back)
        Tween(Pill, 0.18, {Size = UDim2.fromOffset(w + 16, 30)})
        task.delay(1.1, function()
            count = count - 1
            Tween(Pill, 0.3, {GroupTransparency = 1})
            task.delay(0.32, function() if Pill then Pill:Destroy() end end)
        end)
    end

    local function KeyName(input)
        local t = input.UserInputType
        if t == Enum.UserInputType.Keyboard then
            local n = input.KeyCode.Name
            if n ~= "Unknown" then return n end
            return nil
        end
        if t == Enum.UserInputType.MouseButton1 then return "LMB" end
        if t == Enum.UserInputType.MouseButton2 then return "RMB" end
        if t == Enum.UserInputType.MouseButton3 then return "MMB" end
        if t == Enum.UserInputType.Touch then return "TAP" end
        return nil
    end

    local c = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        local name = KeyName(input)
        if name then AddPill(name) end
    end)

    KV = {Holder = Holder, _c = c}
    return {Destroy = function() Extras:DisableKeyVisualizer() end}
end

--// ==================== 3) LOGGER / CONSOLE NỔI ====================
local LOG = nil

function Extras:DisableLogger()
    if not LOG then return end
    if LOG._c then LOG._c:Disconnect() end
    if LOG.Panel then LOG.Panel:Destroy() end
    LOG = nil
end

function Extras:Log(msg, tag)
    if LOG and LOG.AddLine then LOG.AddLine(msg, tag) end
end

function Extras:ClearLog()
    if LOG and LOG.Clear then LOG.Clear() end
end

function Extras:EnableLogger(cfg)
    cfg = cfg or {}
    self:DisableLogger()
    local gui = GetGui()
    local maxEntries = math.max(cfg.Max or 60, 10)
    local W = cfg.Width or 340

    local Panel = New("CanvasGroup", {
        Name = "Logger",
        BackgroundColor3 = C.Bg,
        BackgroundTransparency = 0.05,
        AnchorPoint = Vector2.new(0, 1),
        Position = cfg.Position or UDim2.new(0, 16, 1, -16),
        Size = UDim2.fromOffset(W, cfg.Height or 180),
        ClipsDescendants = true,
        BorderSizePixel = 0, ZIndex = 70, Parent = gui,
    })
    Round(Panel, 10)
    New("UIStroke", {Color = C.Stroke, Thickness = 1, Transparency = 0.25, Parent = Panel})

    local Header = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 28),
        ZIndex = 71, Parent = Panel,
    })
    New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -90, 1, 0),
        Font = Enum.Font.SourceSansBold, TextSize = 13,
        TextColor3 = C.Text, TextXAlignment = Enum.TextXAlignment.Left,
        Text = "MEIZU LOGGER", ZIndex = 72, Parent = Header,
    })
    local ClearBtn = New("TextButton", {
        BackgroundTransparency = 1, AutoButtonColor = false,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -50, 0, 0),
        Size = UDim2.fromOffset(42, 28),
        Font = Enum.Font.SourceSansSemibold, TextSize = 11,
        TextColor3 = C.Sub, Text = "CLEAR",
        ZIndex = 72, Parent = Header,
    })
    local HideBtn = New("TextButton", {
        BackgroundTransparency = 1, AutoButtonColor = false,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -8, 0, 0),
        Size = UDim2.fromOffset(22, 28),
        Font = Enum.Font.SourceSansBold, TextSize = 13,
        TextColor3 = C.Sub, Text = "X",
        ZIndex = 72, Parent = Header,
    })

    local List = New("ScrollingFrame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 1, -32),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.Stroke,
        BorderSizePixel = 0, ZIndex = 71, Parent = Panel,
    })
    local Layout = New("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = List,
    })
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        List.CanvasSize = UDim2.fromOffset(0, Layout.AbsoluteContentSize + 8)
        List.CanvasPosition = Vector2.new(0, math.max(Layout.AbsoluteContentSize - List.AbsoluteSize.Y + 8, 0))
    end)

    local entries, order = 0, 0
    local function AddLine(msg, tag)
        tag = tostring(tag or "info")
        local color = (tag == "ok" and C.Ok) or (tag == "warn" and C.Warn)
                     or (tag == "err" and C.Err) or C.Accent
        order = order + 1
        local full = os.date("%H:%M:%S") .. "  " .. tostring(msg)
        local _, h = Measure(full, 12, Enum.Font.SourceSans, W - 26)
        local Row = New("Frame", {
            BackgroundColor3 = C.Panel,
            BackgroundTransparency = 0.35,
            Size = UDim2.new(1, -8, 0, h + 8),
            LayoutOrder = -order,
            BorderSizePixel = 0, ZIndex = 71, Parent = List,
        })
        Round(Row, 5)
        New("Frame", {
            BackgroundColor3 = color,
            Position = UDim2.new(0, 4, 0, 4),
            Size = UDim2.new(0, 2, 1, -8),
            BorderSizePixel = 0, ZIndex = 72, Parent = Row,
        })
        New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 4),
            Size = UDim2.new(1, -16, 1, -8),
            Font = Enum.Font.SourceSans, TextSize = 12,
            TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true, Text = full,
            ZIndex = 72, Parent = Row,
        })
        entries = entries + 1
        if entries > maxEntries then
            for _, ch in ipairs(List:GetChildren()) do
                if ch:IsA("Frame") then
                    ch:Destroy()
                    entries = entries - 1
                    break
                end
            end
        end
    end

    local function ClearAll()
        for _, ch in ipairs(List:GetChildren()) do
            if ch:IsA("Frame") then ch:Destroy() end
        end
        entries = 0
    end
    ClearBtn.Activated:Connect(function() ClearAll() PlayClick(0.1, 1.5) end)

    local hidden = false
    local function Toggle()
        hidden = not hidden
        if hidden then
            Tween(Panel, 0.22, {GroupTransparency = 1})
            task.delay(0.24, function() if hidden then Panel.Visible = false end end)
        else
            Panel.Visible = true
            Tween(Panel, 0.22, {GroupTransparency = 0})
        end
    end
    HideBtn.Activated:Connect(Toggle)

    local key = cfg.Keybind or Enum.KeyCode.F4
    local c = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == key then Toggle() end
    end)

    Draggable(Header, Panel)
    LOG = {Panel = Panel, List = List, AddLine = AddLine, Clear = ClearAll, _c = c}
    self:Log("Logger san sang — nhan " .. key.Name .. " de an/hien", "ok")
    return {
        Toggle = Toggle,
        Destroy = function() Extras:DisableLogger() end,
    }
end

--// ==================== 4) TOOLTIP (THEO CHUỘT, TỰ LẬT SÁT MÉP) ====================
local TT = nil
local function EnsureTooltip()
    if TT and TT.Card.Parent then return TT end
    local Card = New("CanvasGroup", {
        Name = "Tooltip",
        BackgroundColor3 = C.Bg,
        BackgroundTransparency = 0.05,
        Size = UDim2.fromOffset(20, 20),
        Visible = false,
        GroupTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 300, Parent = GetGui(),
    })
    Round(Card, 6)
    New("UIStroke", {Color = C.Stroke, Thickness = 1, Transparency = 0.2, Parent = Card})
    local Label = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 5),
        Size = UDim2.new(1, -16, 1, -10),
        Font = Enum.Font.SourceSans, TextSize = 13,
        TextColor3 = C.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true, Text = "",
        ZIndex = 301, Parent = Card,
    })
    TT = {Card = Card, Label = Label}
    return TT
end

function Extras:AttachTooltip(target, text)
    if text == nil then return nil end
    target = ResolveTarget(target)
    if not target then return nil end

    local tip = EnsureTooltip()
    local shown = false
    local moveConn = nil

    local function Place(w, h)
        local m = MousePos()
        local sw = ScreenSize()
        local x, y = m.X + 14, m.Y + 18
        if x + w > sw.X - 8 then x = m.X - w - 14 end
        if y + h > sw.Y - 8 then y = m.Y - h - 16 end
        if x < 8 then x = 8 end
        if y < 8 then y = 8 end
        tip.Card.Position = UDim2.fromOffset(x, y)
    end

    target.MouseEnter:Connect(function()
        tip.Label.Text = tostring(text)
        local w, h = Measure(text, 13, Enum.Font.SourceSans, 260)
        w = math.min(w + 16, 276)
        h = h + 10
        tip.Card.Size = UDim2.fromOffset(w, h)
        Place(w, h)
        shown = true
        tip.Card.Visible = true
        Tween(tip.Card, 0.15, {GroupTransparency = 0})
        if moveConn then moveConn:Disconnect() end
        moveConn = UserInputService.InputChanged:Connect(function(inp)
            if inp.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            Place(tip.Card.Size.X.Offset, tip.Card.Size.Y.Offset)
        end)
    end)

    target.MouseLeave:Connect(function()
        shown = false
        if moveConn then moveConn:Disconnect() moveConn = nil end
        Tween(tip.Card, 0.12, {GroupTransparency = 1})
        task.delay(0.14, function()
            if not shown and TT == tip then tip.Card.Visible = false end
        end)
    end)
    return target
end

--// ==================== 5) CONTEXT MENU (CHUỘT PHẢI) ====================
local OpenMenu = nil

function Extras:NewContextMenu(target, items)
    if type(items) ~= "table" then return nil end
    target = ResolveTarget(target)
    if not target then return nil end
    local handle = {Close = function()
        if OpenMenu and OpenMenu.Owner == handle then OpenMenu.Close() end
    end}

    target.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
        if OpenMenu then OpenMenu.Close() end

        local rowH, width, totalH = 30, 0, 0
        for _, it in ipairs(items) do
            if type(it) == "table" then
                if it.Separator then
                    totalH = totalH + 9
                else
                    local w = Measure(tostring(it.Text or "..."), 13, Enum.Font.SourceSansSemibold)
                    if w + 44 > width then width = w + 44 end
                    totalH = totalH + rowH
                end
            end
        end
        if totalH == 0 then return end
        width = math.max(width, 130)

        local m, sw = MousePos(), ScreenSize()
        local x, y = m.X, m.Y
        if x + width > sw.X - 8 then x = sw.X - width - 8 end
        if y + totalH > sw.Y - 8 then y = sw.Y - totalH - 8 end
        if x < 8 then x = 8 end
        if y < 8 then y = 8 end

        local Menu = New("CanvasGroup", {
            Name = "ContextMenu",
            BackgroundColor3 = C.Bg,
            BackgroundTransparency = 0.05,
            Position = UDim2.fromOffset(x, y),
            Size = UDim2.fromOffset(width, totalH),
            GroupTransparency = 1,
            ClipsDescendants = true,
            BorderSizePixel = 0, ZIndex = 400, Parent = GetGui(),
        })
        Round(Menu, 8)
        New("UIStroke", {Color = C.Stroke, Thickness = 1, Transparency = 0.2, Parent = Menu})

        local closed = false
        local globalConn
        local function Close()
            if closed then return end
            closed = true
            if globalConn then globalConn:Disconnect() globalConn = nil end
            Tween(Menu, 0.15, {GroupTransparency = 1})
            task.delay(0.17, function() if Menu then Menu:Destroy() end end)
            if OpenMenu and OpenMenu.Owner == handle then OpenMenu = nil end
        end
        handle.Close = Close

        globalConn = UserInputService.InputBegan:Connect(function(inp)
            local t = inp.UserInputType
            if t ~= Enum.UserInputType.MouseButton1 and t ~= Enum.UserInputType.Touch then return end
            local px, py = inp.Position.X, inp.Position.Y
            if px >= x and px <= x + width and py >= y and py <= y + totalH then return end
            Close()
        end)

        local oy = 0
        for _, it in ipairs(items) do
            if type(it) == "table" and it.Separator then
                New("Frame", {
                    BackgroundColor3 = C.Stroke,
                    Position = UDim2.new(0, 8, 0, oy + 4),
                    Size = UDim2.new(1, -16, 0, 1),
                    BorderSizePixel = 0, ZIndex = 401, Parent = Menu,
                })
                oy = oy + 9
            elseif type(it) == "table" then
                local disabled = it.Disabled == true
                local Item = New("TextButton", {
                    BackgroundColor3 = C.Accent,
                    BackgroundTransparency = 1,
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 4, 0, oy),
                    Size = UDim2.new(1, -8, 0, rowH),
                    Text = "", ZIndex = 401, Parent = Menu,
                })
                Round(Item, 6)
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -20, 1, 0),
                    Font = Enum.Font.SourceSansSemibold, TextSize = 13,
                    TextColor3 = disabled and C.Sub or C.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Text = tostring(it.Text or "..."),
                    ZIndex = 402, Parent = Item,
                })
                Item.MouseEnter:Connect(function()
                    if not disabled then Tween(Item, 0.12, {BackgroundTransparency = 0.82}) end
                end)
                Item.MouseLeave:Connect(function()
                    Tween(Item, 0.12, {BackgroundTransparency = 1})
                end)
                Item.Activated:Connect(function()
                    if disabled then return end
                    Close()
                    PlayClick(0.12, 1.5)
                    if type(it.Callback) == "function" then
                        task.spawn(function()
                            local ok, err = pcall(it.Callback)
                            if not ok then warn("[MeizuExtras] Menu error: " .. tostring(err)) end
                        end)
                    end
                end)
                oy = oy + rowH
            end
        end

        OpenMenu = {Owner = handle, Close = Close}
        Tween(Menu, 0.18, {GroupTransparency = 0})
        PlayClick(0.1, 1.35)
    end)
    return handle
end

--// ==================== 6) PANIC KEY (ẨN/HIỆN TOÀN BỘ UI) ====================
local Panic = {Conn = nil, Hidden = false, Affected = {}}

function Extras:SetPanicKey(key)
    if Panic.Conn then Panic.Conn:Disconnect() Panic.Conn = nil end
    if not key then return end
    Panic.Conn = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == key then Extras:TogglePanic() end
    end)
end

function Extras:TogglePanic()
    if not Panic.Hidden then
        Panic.Affected = {}
        if Extras._Gui and Extras._Gui.Parent then
            table.insert(Panic.Affected, {Gui = Extras._Gui, Was = Extras._Gui.Enabled})
            Extras._Gui.Enabled = false
        end
        local function Scan(parent)
            if not parent then return end
            pcall(function()
                for _, ch in ipairs(parent:GetChildren()) do
                    if ch:IsA("ScreenGui")
                    and (ch.Name == "MeizuLibrary" or ch.Name:sub(1, 13) == "MeizuLibrary_") then
                        table.insert(Panic.Affected, {Gui = ch, Was = ch.Enabled})
                        ch.Enabled = false
                    end
                end
            end)
        end
        if type(gethui) == "function" then pcall(function() Scan(gethui()) end) end
        if LocalPlayer then
            pcall(function() Scan(LocalPlayer:FindFirstChild("PlayerGui")) end)
        end
        Panic.Hidden = true
    else
        for _, e in ipairs(Panic.Affected) do
            if e.Gui and e.Gui.Parent then e.Gui.Enabled = e.Was end
        end
        Panic.Affected = {}
        Panic.Hidden = false
    end
    return Panic.Hidden
end

--// ==================== 7) FPS BOOST (HOÀN TÁC ĐƯỢC) ====================
local Boost = {On = false, Saved = {}}

function Extras:ToggleFPSBoost(on)
    on = (on == nil) and (not Boost.On) or (on == true)
    if on == Boost.On then return Boost.On end
    if on then
        Boost.Saved = {}
        pcall(function()
            Boost.Saved.Quality = settings().Rendering.QualityLevel
            settings().Rendering.QualityLevel = 1
        end)
        pcall(function()
            Boost.Saved.Shadows = Lighting.GlobalShadows
            Lighting.GlobalShadows = false
        end)
        pcall(function()
            local t = workspace:FindFirstChildOfClass("Terrain")
            if t then
                Boost.Saved.Decoration = t.Decoration
                t.Decoration = false
            end
        end)
        Boost.On = true
    else
        pcall(function()
            if Boost.Saved.Quality then settings().Rendering.QualityLevel = Boost.Saved.Quality end
        end)
        pcall(function()
            if Boost.Saved.Shadows ~= nil then Lighting.GlobalShadows = Boost.Saved.Shadows end
        end)
        pcall(function()
            local t = workspace:FindFirstChildOfClass("Terrain")
            if t and Boost.Saved.Decoration ~= nil then t.Decoration = Boost.Saved.Decoration end
        end)
        Boost.On = false
        Boost.Saved = {}
    end
    return Boost.On
end

function Extras:IsFPSBoosted()
    return Boost.On
end

--// ==================== 8) ANTI-AFK ====================
local AntiAFK = {Conn = nil}

function Extras:EnableAntiAFK(on)
    on = (on == nil) and true or (on == true)
    if on then
        if AntiAFK.Conn then return true end
        if not LocalPlayer then return false end
        AntiAFK.Conn = LocalPlayer.Idled:Connect(function()
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end)
    else
        if AntiAFK.Conn then AntiAFK.Conn:Disconnect() AntiAFK.Conn = nil end
    end
    return on
end

--// ==================== KẾT NỐI LIBRARY (TÙY CHỌN) ====================
function Extras:SyncTheme()
    local lib = self.Library
    if not lib then return end
    local th = lib.Themes and lib.Themes[lib.Theme]
    if th then
        C.Bg     = th.Window or C.Bg
        C.Panel  = th.Element or C.Panel
        C.Text   = th.Text or C.Text
        C.Sub    = th.SubText or C.Sub
        C.Stroke = th.Stroke or C.Stroke
    end
    if lib.Accent then C.Accent = lib.Accent end
    -- làm mới màu các widget đang mở
    if WM and WM.Card then
        WM.Card.BackgroundColor3 = C.Bg
        WM.Label.TextColor3 = C.Text
        WM.Dot.BackgroundColor3 = C.Accent
    end
    if LOG and LOG.Panel then
        LOG.Panel.BackgroundColor3 = C.Bg
    end
end

function Extras:Init(library)
    self.Library = library
    if not library then return self end
    if library.SoundEnabled ~= nil then self.SoundEnabled = library.SoundEnabled end
    -- mỗi khi library đổi theme/màu nhấn -> extras đổi theo
    local oldTheme = library.ApplyTheme
    if type(oldTheme) == "function" then
        library.ApplyTheme = function(lib, name)
            oldTheme(lib, name)
            Extras:SyncTheme()
        end
    end
    local oldAccent = library.ApplyAccent
    if type(oldAccent) == "function" then
        library.ApplyAccent = function(lib, color)
            oldAccent(lib, color)
            Extras:SyncTheme()
        end
    end
    self:SyncTheme()
    return self
end

function Extras:Destroy()
    if Panic.Conn then Panic.Conn:Disconnect() end
    if AntiAFK.Conn then AntiAFK.Conn:Disconnect() end
    if Boost.On then self:ToggleFPSBoost(false) end
    if OpenMenu then OpenMenu.Close() end
    self:DisableWatermark()
    self:DisableKeyVisualizer()
    self:DisableLogger()
    if self._Gui then
        self._Gui:Destroy()
        self._Gui = nil
    end
end

-- chống chồng bản: chạy lại script -> gỡ bản extras cũ
pcall(function()
    if type(getgenv) == "function" then
        local old = getgenv().MeizuExtras
        if old and old ~= Extras and type(old.Destroy) == "function" then old:Destroy() end
        getgenv().MeizuExtras = Extras
    end
end)


--// ════════════════ GHÉP & KÍCH HOẠT TỰ ĐỘNG ════════════════
local MeizuExtras = Extras -- bí danh: dùng MeizuExtras hay Extras đều được

pcall(function()
	local env = (type(getgenv) == "function" and getgenv()) or _G
	rawset(env, "MeizuLibrary", MeizuLibrary)
	rawset(env, "MeizuExtras", Extras)
end)

pcall(function() Extras:Init(MeizuLibrary) end)

print("[MEIZU] Nap thanh cong: Library v3.0 'Luxe' + Extras v1.1")
print("[MEIZU] Tien ich: MeizuExtras:EnableWatermark{...} / EnableKeyVisualizer() / EnableLogger{...} / SetPanicKey(...)")

--// ════════ VIẾT HUB CỦA BẠN TẠI ĐÂY (khi dán trực tiếp) ════════
-- local Window = MeizuLibrary:CreateWindow{ Title = "Hub của tôi", SubTitle = "by Meizu" }
-- local Tab = Window:CreateTab("Chính", "rbxassetid://10734950309")
-- local Sec = Tab:CreateSection("Tính năng")
-- Sec:CreateToggle({ Title = "Watermark", Callback = function(v)
--     MeizuExtras:EnableWatermark{ Text = "Meizu", ShowFPS = true, ShowPing = v }
-- end })
-- MeizuExtras:EnableKeyVisualizer()
-- MeizuExtras:SetPanicKey(Enum.KeyCode.F8)

return MeizuLibrary
