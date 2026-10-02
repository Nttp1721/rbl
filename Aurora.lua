--[[
    ╔═══════════════════════════════════════════════╗
    ║  AURORA UI LIBRARY  v1.0.0  (Roblox / Luau)   ║
    ║  Modern • Smooth • Easy API (Fluent-style)    ║
    ╚═══════════════════════════════════════════════╝

    Components : Window, Tab, Section, Button, Toggle, Slider, Dropdown (Multi),
                 Input, Keybind, Colorpicker, Paragraph, Label
    Systems    : Notify, Dialog, 4 Themes (Dark/Light/Midnight/Rose),
                 Drag + Resize + Minimize key, Mobile button, Save/Load config
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local Aurora = {
	Version = "1.0.0",
	Options = {},
	Theme = "Dark",
	ConfigFolder = "Aurora/configs",
}

----------------------------------------------------------------------
-- THEMES
----------------------------------------------------------------------
local function C(r, g, b) return Color3.fromRGB(r, g, b) end

Aurora.Themes = {
	Dark = {
		Background = C(20, 20, 25), Surface = C(28, 28, 35), Element = C(34, 34, 43),
		ElementHover = C(44, 44, 56), Stroke = C(54, 54, 68), Text = C(240, 240, 246),
		SubText = C(150, 150, 168), Accent = C(112, 128, 255),
	},
	Light = {
		Background = C(243, 244, 247), Surface = C(255, 255, 255), Element = C(255, 255, 255),
		ElementHover = C(236, 238, 244), Stroke = C(222, 224, 232), Text = C(28, 30, 38),
		SubText = C(110, 114, 128), Accent = C(79, 110, 247),
	},
	Midnight = {
		Background = C(10, 14, 26), Surface = C(15, 21, 38), Element = C(20, 28, 50),
		ElementHover = C(28, 38, 66), Stroke = C(38, 52, 86), Text = C(230, 236, 250),
		SubText = C(130, 146, 180), Accent = C(56, 189, 248),
	},
	Rose = {
		Background = C(24, 16, 20), Surface = C(33, 22, 28), Element = C(41, 28, 35),
		ElementHover = C(54, 37, 46), Stroke = C(72, 49, 62), Text = C(250, 236, 242),
		SubText = C(178, 142, 158), Accent = C(244, 114, 182),
	},
}

local function T() return Aurora.Themes[Aurora.Theme] end

----------------------------------------------------------------------
-- CORE HELPERS
----------------------------------------------------------------------
local registry, refreshers, connections = {}, {}, {}

local function Connect(signal, fn)
	local c = signal:Connect(fn)
	table.insert(connections, c)
	return c
end

local function Tween(obj, time, props, style)
	local tw = TweenService:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end

local function bind(inst, prop, key)
	inst[prop] = T()[key]
	table.insert(registry, { inst, prop, key })
end

local function OnTheme(fn)
	table.insert(refreshers, fn)
	fn()
end

local Defaults = {
	Frame = { BorderSizePixel = 0 },
	CanvasGroup = { BorderSizePixel = 0 },
	TextLabel = {
		BackgroundTransparency = 1, BorderSizePixel = 0, Text = "",
		Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
	},
	TextButton = {
		BorderSizePixel = 0, AutoButtonColor = false, Text = "",
		Font = Enum.Font.GothamMedium, TextSize = 13,
	},
	TextBox = { BorderSizePixel = 0, Font = Enum.Font.GothamMedium, TextSize = 13, ClearTextOnFocus = false },
	ScrollingFrame = { BorderSizePixel = 0, BackgroundTransparency = 1, ScrollBarThickness = 3 },
	ImageLabel = { BackgroundTransparency = 1, BorderSizePixel = 0 },
}

local function New(class, props, children)
	local o = Instance.new(class)
	local d = Defaults[class]
	if d then for k, v in pairs(d) do o[k] = v end end
	local parent, theme
	if props then
		for k, v in pairs(props) do
			if k == "Parent" then parent = v
			elseif k == "Theme" then theme = v
			else o[k] = v end
		end
	end
	if theme then for p, key in pairs(theme) do bind(o, p, key) end end
	if children then for _, c in ipairs(children) do c.Parent = o end end
	if parent then o.Parent = parent end
	return o
end

local function Corner(r) return New("UICorner", { CornerRadius = UDim.new(0, r) }) end
local function Stroke(key, th)
	return New("UIStroke", { Thickness = th or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Theme = { Color = key or "Stroke" } })
end
local function Pad(l, t, r, b)
	return New("UIPadding", { PaddingLeft = UDim.new(0, l), PaddingTop = UDim.new(0, t), PaddingRight = UDim.new(0, r), PaddingBottom = UDim.new(0, b) })
end
local function List(pad, dir)
	return New("UIListLayout", { Padding = UDim.new(0, pad or 0), SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = dir or Enum.FillDirection.Vertical })
end

local function isPointer(i)
	return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end
local function isMove(i)
	return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch
end

-- kéo thả trên 1 vùng (slider, colorpicker)
local function Drag(area, onMove)
	local active = false
	area.InputBegan:Connect(function(i)
		if isPointer(i) then active = true; onMove(i.Position) end
	end)
	Connect(UIS.InputChanged, function(i)
		if active and isMove(i) then onMove(i.Position) end
	end)
	Connect(UIS.InputEnded, function(i)
		if isPointer(i) then active = false end
	end)
end

local function MakeDraggable(handle, target)
	local dragging, startPos, startMouse = false, nil, nil
	handle.InputBegan:Connect(function(i)
		if isPointer(i) then
			dragging = true
			startMouse = i.Position
			startPos = target.Position
		end
	end)
	Connect(UIS.InputChanged, function(i)
		if dragging and isMove(i) then
			local d = i.Position - startMouse
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	Connect(UIS.InputEnded, function(i)
		if isPointer(i) then dragging = false end
	end)
end

local function Hover(btn, row)
	btn.MouseEnter:Connect(function() Tween(row, 0.15, { BackgroundColor3 = T().ElementHover }) end)
	btn.MouseLeave:Connect(function() Tween(row, 0.15, { BackgroundColor3 = T().Element }) end)
end

function Aurora:GetTheme() return T() end

function Aurora:SetTheme(name)
	local th = self.Themes[name]
	if not th then return end
	self.Theme = name
	for i = #registry, 1, -1 do
		local r = registry[i]
		if not r[1].Parent then
			table.remove(registry, i)
		else
			Tween(r[1], 0.25, { [r[2]] = th[r[3]] })
		end
	end
	for _, fn in ipairs(refreshers) do pcall(fn) end
end

----------------------------------------------------------------------
-- GUI ROOT + NOTIFY
----------------------------------------------------------------------
local function ensureGui()
	if Aurora.Gui and Aurora.Gui.Parent then return Aurora.Gui end
	local gui = New("ScreenGui", {
		Name = "Aurora_UI", ResetOnSpawn = false, IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999,
	})
	if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
	local ok = pcall(function() gui.Parent = (gethui and gethui()) or CoreGui end)
	if not ok or not gui.Parent then
		gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end
	for _, c in ipairs(gui.Parent:GetChildren()) do
		if c ~= gui and c.Name == "Aurora_UI" then c:Destroy() end
	end
	Aurora.Gui = gui

	Aurora.NotifyHolder = New("Frame", {
		AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, -16),
		Size = UDim2.new(0, 320, 1, -32), BackgroundTransparency = 1, ZIndex = 200, Parent = gui,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right,
		}),
	})
	return gui
end

function Aurora:Notify(cfg)
	ensureGui()
	cfg = cfg or {}
	local dur = cfg.Duration or 4
	local wrap = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1, Parent = self.NotifyHolder,
	})
	local card = New("CanvasGroup", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(1, 40, 0, 0), GroupTransparency = 1, Parent = wrap,
		Theme = { BackgroundColor3 = "Surface" },
	}, { Corner(10), Stroke("Stroke"), Pad(14, 12, 14, 12), List(5) })

	New("TextLabel", {
		Text = cfg.Title or "Notification", Font = Enum.Font.GothamBold, TextSize = 14,
		Size = UDim2.new(1, 0, 0, 18), LayoutOrder = 1, Parent = card, Theme = { TextColor3 = "Text" },
	})
	if cfg.Content then
		New("TextLabel", {
			Text = cfg.Content, TextSize = 12, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
			Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2,
			Parent = card, Theme = { TextColor3 = "SubText" },
		})
	end
	local track = New("Frame", { Size = UDim2.new(1, 0, 0, 3), LayoutOrder = 3, Parent = card, Theme = { BackgroundColor3 = "Element" } }, { Corner(2) })
	local fill = New("Frame", { Size = UDim2.fromScale(1, 1), Parent = track, Theme = { BackgroundColor3 = "Accent" } }, { Corner(2) })

	Tween(card, 0.35, { Position = UDim2.new(0, 0, 0, 0), GroupTransparency = 0 })
	Tween(fill, dur, { Size = UDim2.fromScale(0, 1) }, Enum.EasingStyle.Linear)
	task.delay(dur, function()
		if not wrap.Parent then return end
		Tween(card, 0.3, { Position = UDim2.new(1, 40, 0, 0), GroupTransparency = 1 })
		task.wait(0.3)
		wrap:Destroy()
	end)
end

----------------------------------------------------------------------
-- ELEMENT HELPERS
----------------------------------------------------------------------
local function order(tab) tab._n = (tab._n or 0) + 1; return tab._n end

local function Row(tab, height)
	return New("Frame", {
		Size = UDim2.new(1, 0, 0, height), LayoutOrder = order(tab), Parent = tab.Page,
		Theme = { BackgroundColor3 = "Element" },
	}, { Corner(8), Stroke("Stroke") })
end

local function Labels(row, title, desc, rightPad, headerH)
	rightPad = rightPad or 12
	local t = New("TextLabel", { Text = title or "", TextTruncate = Enum.TextTruncate.AtEnd, Parent = row, Theme = { TextColor3 = "Text" } })
	local d
	if desc then
		t.Position = UDim2.fromOffset(12, 9)
		t.Size = UDim2.new(1, -(rightPad + 12), 0, 16)
		d = New("TextLabel", {
			Text = desc, TextSize = 12, TextTruncate = Enum.TextTruncate.AtEnd,
			Position = UDim2.fromOffset(12, 28), Size = UDim2.new(1, -(rightPad + 12), 0, 16),
			Parent = row, Theme = { TextColor3 = "SubText" },
		})
	else
		t.Position = UDim2.fromOffset(12, 0)
		t.Size = UDim2.new(1, -(rightPad + 12), 0, headerH or 42)
	end
	return { Title = t, Desc = d }
end

local function Args(id, cfg)
	if type(id) == "table" then return nil, id end
	return id, cfg or {}
end

local function Obj(kind, value, cb)
	local o = { Type = kind, Value = value, _cbs = {} }
	if cb then table.insert(o._cbs, cb) end
	function o:OnChanged(fn) table.insert(self._cbs, fn) end
	function o:_fire() for _, f in ipairs(self._cbs) do task.spawn(f, self.Value) end end
	function o:_init() if self.Value ~= nil then task.defer(function() self:_fire() end) end end
	return o
end

local function Register(id, obj)
	if id then Aurora.Options[id] = obj end
end

----------------------------------------------------------------------
-- WINDOW
----------------------------------------------------------------------
function Aurora:CreateWindow(cfg)
	cfg = cfg or {}
	if cfg.Theme then self:SetTheme(cfg.Theme) end
	local gui = ensureGui()
	local touch = UIS.TouchEnabled and not UIS.KeyboardEnabled
	local size = cfg.Size or (touch and UDim2.fromOffset(500, 330) or UDim2.fromOffset(620, 440))
	local sideW = touch and 130 or 160

	local Window = { Tabs = {}, Visible = true }

	local root = New("Frame", {
		Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(size.X.Offset, size.Y.Offset), BackgroundTransparency = 1, Parent = gui,
	})
	local scale = New("UIScale", { Scale = 0.9, Parent = root })
	Tween(scale, 0.4, { Scale = 1 })

	New("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 44, 1, 44), ZIndex = 0, Image = "rbxassetid://6014261993",
		ImageColor3 = Color3.new(0, 0, 0), ImageTransparency = 0.55,
		ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450), Parent = root,
	})

	local main = New("Frame", {
		Size = UDim2.fromScale(1, 1), ZIndex = 1, Parent = root, Theme = { BackgroundColor3 = "Background" },
	}, { Corner(10), Stroke("Stroke") })

	-- Top bar
	local top = New("Frame", { Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1, Parent = main })
	local titleBox = New("Frame", {
		Position = UDim2.fromOffset(16, 0), Size = UDim2.new(1, -100, 1, 0), BackgroundTransparency = 1, Parent = top,
	}, { New("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8),
		VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder,
	}) })
	New("TextLabel", {
		Text = cfg.Title or "Aurora", Font = Enum.Font.GothamBold, TextSize = 15, AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.fromOffset(0, 20), LayoutOrder = 1, Parent = titleBox, Theme = { TextColor3 = "Text" },
	})
	if cfg.SubTitle then
		New("TextLabel", {
			Text = cfg.SubTitle, TextSize = 12, AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, 20), LayoutOrder = 2, Parent = titleBox, Theme = { TextColor3 = "SubText" },
		})
	end

	local function TopButton(txt, xOff)
		local b = New("TextButton", {
			Text = txt, TextSize = 18, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, xOff, 0.5, 0),
			Size = UDim2.fromOffset(28, 28), BackgroundTransparency = 1, Parent = top,
			Theme = { TextColor3 = "SubText", BackgroundColor3 = "ElementHover" },
		}, { Corner(6) })
		b.MouseEnter:Connect(function() Tween(b, 0.15, { BackgroundTransparency = 0 }) end)
		b.MouseLeave:Connect(function() Tween(b, 0.15, { BackgroundTransparency = 1 }) end)
		return b
	end
	local closeBtn = TopButton("×", -10)
	local minBtn = TopButton("–", -42)

	New("Frame", { Position = UDim2.fromOffset(0, 46), Size = UDim2.new(1, 0, 0, 1), Parent = main, Theme = { BackgroundColor3 = "Stroke" } })
	MakeDraggable(top, root)

	-- Sidebar
	local tabList = New("ScrollingFrame", {
		Position = UDim2.fromOffset(0, 47), Size = UDim2.new(0, sideW, 1, -47), CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0, Parent = main,
	}, { Pad(10, 10, 10, 10), List(4) })
	New("Frame", { Position = UDim2.fromOffset(sideW, 47), Size = UDim2.new(0, 1, 1, -47), Parent = main, Theme = { BackgroundColor3 = "Stroke" } })

	-- Content
	local content = New("Frame", {
		Position = UDim2.fromOffset(sideW + 1, 47), Size = UDim2.new(1, -(sideW + 1), 1, -47),
		BackgroundTransparency = 1, ClipsDescendants = true, Parent = main,
	})

	-- Resize grip
	local grip = New("TextButton", {
		Text = "◢", TextSize = 10, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -3, 1, -3),
		Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1, ZIndex = 5, Parent = main,
		Theme = { TextColor3 = "SubText" },
	})
	local resizing, rMouse, rSize, rPos = false, nil, nil, nil
	grip.InputBegan:Connect(function(i)
		if isPointer(i) then
			resizing = true
			rMouse = i.Position
			rSize = Vector2.new(root.Size.X.Offset, root.Size.Y.Offset)
			rPos = root.Position
		end
	end)
	Connect(UIS.InputChanged, function(i)
		if resizing and isMove(i) then
			local d = i.Position - rMouse
			local w = math.clamp(rSize.X + d.X, 440, 1000)
			local h = math.clamp(rSize.Y + d.Y, 300, 800)
			root.Size = UDim2.fromOffset(w, h)
			root.Position = UDim2.new(rPos.X.Scale, rPos.X.Offset + (w - rSize.X) / 2, rPos.Y.Scale, rPos.Y.Offset + (h - rSize.Y) / 2)
		end
	end)
	Connect(UIS.InputEnded, function(i) if isPointer(i) then resizing = false end end)

	----------------------------------------------------------------
	-- visibility
	----------------------------------------------------------------
	function Window:SetVisible(v)
		self.Visible = v
		if v then
			root.Visible = true
			Tween(scale, 0.3, { Scale = 1 })
		else
			Tween(scale, 0.2, { Scale = 0.92 })
			task.delay(0.2, function() if not self.Visible then root.Visible = false end end)
		end
	end
	function Window:Toggle() self:SetVisible(not self.Visible) end
	function Window:Destroy() Aurora:Destroy() end
	function Window:Notify(c) Aurora:Notify(c) end

	minBtn.MouseButton1Click:Connect(function() Window:SetVisible(false) end)
	closeBtn.MouseButton1Click:Connect(function()
		Window:Dialog({
			Title = "Đóng giao diện?", Content = "UI sẽ bị xóa hoàn toàn. Bạn có chắc không?",
			Buttons = { { Title = "Hủy" }, { Title = "Đóng", Callback = function() Aurora:Destroy() end } },
		})
	end)

	local minKey = cfg.MinimizeKey or Enum.KeyCode.RightControl
	Connect(UIS.InputBegan, function(input, gp)
		if not gp and input.KeyCode == minKey then Window:Toggle() end
	end)

	if cfg.MobileButton ~= false and UIS.TouchEnabled then
		local fb = New("TextButton", {
			Text = "☰", TextSize = 20, Size = UDim2.fromOffset(44, 44), Position = UDim2.new(0, 16, 0, 70), Parent = gui,
			Theme = { BackgroundColor3 = "Surface", TextColor3 = "Text" },
		}, { New("UICorner", { CornerRadius = UDim.new(1, 0) }), Stroke("Stroke") })
		fb.MouseButton1Click:Connect(function() Window:Toggle() end)
	end

	----------------------------------------------------------------
	-- dialog
	----------------------------------------------------------------
	function Window:Dialog(d)
		local overlay = New("TextButton", {
			Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1,
			ZIndex = 100, Parent = main,
		}, { Corner(10) })
		Tween(overlay, 0.2, { BackgroundTransparency = 0.45 })
		local card = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(320, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = overlay,
			Theme = { BackgroundColor3 = "Surface" },
		}, { Corner(10), Stroke("Stroke"), Pad(18, 16, 18, 16), List(10) })
		New("TextLabel", { Text = d.Title or "Dialog", Font = Enum.Font.GothamBold, TextSize = 15, Size = UDim2.new(1, 0, 0, 20), LayoutOrder = 1, Parent = card, Theme = { TextColor3 = "Text" } })
		New("TextLabel", {
			Text = d.Content or "", TextSize = 13, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
			Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2, Parent = card,
			Theme = { TextColor3 = "SubText" },
		})
		local btnRow = New("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, LayoutOrder = 3, Parent = card }, {
			New("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
			}),
		})
		local function close()
			Tween(overlay, 0.2, { BackgroundTransparency = 1 })
			card:Destroy()
			task.delay(0.2, function() overlay:Destroy() end)
		end
		for idx, b in ipairs(d.Buttons or { { Title = "OK" } }) do
			local primary = idx == #(d.Buttons or { 1 })
			local btn = New("TextButton", {
				Text = b.Title, Size = UDim2.fromOffset(90, 32), LayoutOrder = idx, Parent = btnRow,
				Theme = { BackgroundColor3 = primary and "Accent" or "Element", TextColor3 = primary and "Background" or "Text" },
			}, { Corner(6) })
			btn.MouseButton1Click:Connect(function()
				close()
				if b.Callback then task.spawn(b.Callback) end
			end)
		end
	end

	----------------------------------------------------------------
	-- tabs
	----------------------------------------------------------------
	function Window:SelectTab(t)
		if type(t) == "number" then t = self.Tabs[t] end
		if not t then return end
		self.Current = t
		for _, x in ipairs(self.Tabs) do
			x.Page.Visible = (x == t)
			x._render()
		end
	end

	function Window:AddTab(tcfg)
		tcfg = type(tcfg) == "string" and { Title = tcfg } or tcfg or {}
		local Tab = { Window = self, Title = tcfg.Title or "Tab" }

		local btn = New("TextButton", {
			Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, LayoutOrder = #self.Tabs + 1,
			Parent = tabList, Theme = { BackgroundColor3 = "Element" },
		}, { Corner(6) })
		local bar = New("Frame", {
			AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(3, 16),
			BackgroundTransparency = 1, Parent = btn, Theme = { BackgroundColor3 = "Accent" },
		}, { Corner(2) })
		local hasIcon = tcfg.Icon and tcfg.Icon ~= ""
		if hasIcon then
			New("ImageLabel", {
				Image = tcfg.Icon, Position = UDim2.fromOffset(12, 9), Size = UDim2.fromOffset(16, 16),
				Parent = btn, Theme = { ImageColor3 = "SubText" },
			})
		end
		local label = New("TextLabel", {
			Text = Tab.Title, Position = UDim2.fromOffset(hasIcon and 36 or 14, 0), Size = UDim2.new(1, -44, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd, Parent = btn,
		})

		Tab.Page = New("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false, Parent = content, Theme = { ScrollBarImageColor3 = "Stroke" },
		}, { Pad(14, 12, 14, 12), List(8) })

		Tab._render = function()
			local on = Window.Current == Tab
			Tween(btn, 0.2, { BackgroundTransparency = on and 0 or 1 })
			Tween(bar, 0.2, { BackgroundTransparency = on and 0 or 1 })
			Tween(label, 0.2, { TextColor3 = on and T().Text or T().SubText })
		end
		OnTheme(Tab._render)

		btn.MouseButton1Click:Connect(function() Window:SelectTab(Tab) end)
		btn.MouseEnter:Connect(function()
			if Window.Current ~= Tab then Tween(btn, 0.15, { BackgroundTransparency = 0.6 }) end
		end)
		btn.MouseLeave:Connect(function()
			if Window.Current ~= Tab then Tween(btn, 0.15, { BackgroundTransparency = 1 }) end
		end)

		table.insert(self.Tabs, Tab)
		if #self.Tabs == 1 then self:SelectTab(Tab) end

		--------------------------------------------------------------
		-- SECTION / LABEL / PARAGRAPH
		--------------------------------------------------------------
		function Tab:AddSection(title)
			local f = New("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = order(self), Parent = self.Page })
			New("TextLabel", {
				Text = title, Font = Enum.Font.GothamBold, TextSize = 12, Position = UDim2.fromOffset(4, 0),
				Size = UDim2.new(1, -4, 1, -4), Parent = f, Theme = { TextColor3 = "Accent" },
			})
			New("Frame", { Position = UDim2.new(0, 0, 1, -1), Size = UDim2.new(1, 0, 0, 1), Parent = f, Theme = { BackgroundColor3 = "Stroke" } })
		end

		function Tab:AddLabel(text)
			local l = New("TextLabel", {
				Text = text, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
				Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = order(self),
				Parent = self.Page, Theme = { TextColor3 = "SubText" },
			}, { Pad(4, 2, 4, 2) })
			return { SetText = function(_, t) l.Text = t end }
		end

		function Tab:AddParagraph(c)
			local row = New("Frame", {
				Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = order(self),
				Parent = self.Page, Theme = { BackgroundColor3 = "Element" },
			}, { Corner(8), Stroke("Stroke"), Pad(12, 10, 12, 10), List(4) })
			local t = New("TextLabel", { Text = c.Title or "", Font = Enum.Font.GothamBold, Size = UDim2.new(1, 0, 0, 16), LayoutOrder = 1, Parent = row, Theme = { TextColor3 = "Text" } })
			local d = New("TextLabel", {
				Text = c.Content or "", TextSize = 12, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
				Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2, Parent = row,
				Theme = { TextColor3 = "SubText" },
			})
			return { SetTitle = function(_, v) t.Text = v end, SetContent = function(_, v) d.Text = v end }
		end

		--------------------------------------------------------------
		-- BUTTON
		--------------------------------------------------------------
		function Tab:AddButton(c)
			local row = Row(self, c.Description and 56 or 42)
			Labels(row, c.Title, c.Description, 36)
			New("TextLabel", {
				Text = "›", TextSize = 22, TextXAlignment = Enum.TextXAlignment.Center, AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -12, 0.5, -2), Size = UDim2.fromOffset(16, 20), Parent = row, Theme = { TextColor3 = "SubText" },
			})
			local btn = New("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = row })
			Hover(btn, row)
			btn.MouseButton1Click:Connect(function()
				Tween(row, 0.08, { BackgroundColor3 = T().Stroke })
				task.delay(0.1, function() Tween(row, 0.2, { BackgroundColor3 = T().Element }) end)
				if c.Callback then task.spawn(c.Callback) end
			end)
		end

		--------------------------------------------------------------
		-- TOGGLE
		--------------------------------------------------------------
		function Tab:AddToggle(id, c)
			id, c = Args(id, c)
			local obj = Obj("Toggle", c.Default == true, c.Callback)
			local row = Row(self, c.Description and 56 or 42)
			Labels(row, c.Title, c.Description, 60)
			local track = New("Frame", {
				AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(40, 20), Parent = row,
			}, { Corner(10) })
			local knob = New("Frame", {
				AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.fromOffset(14, 14),
				BackgroundColor3 = Color3.new(1, 1, 1), Parent = track,
			}, { Corner(7) })
			local function render()
				local on = obj.Value
				Tween(track, 0.2, { BackgroundColor3 = on and T().Accent or T().Stroke })
				Tween(knob, 0.2, { Position = on and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) })
			end
			OnTheme(render)
			function obj:SetValue(v, silent)
				v = v and true or false
				if v == self.Value then return end
				self.Value = v
				render()
				if not silent then self:_fire() end
			end
			local btn = New("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = row })
			Hover(btn, row)
			btn.MouseButton1Click:Connect(function() obj:SetValue(not obj.Value) end)
			Register(id, obj)
			obj:_init()
			return obj
		end

		--------------------------------------------------------------
		-- SLIDER
		--------------------------------------------------------------
		function Tab:AddSlider(id, c)
			id, c = Args(id, c)
			local min, max = c.Min or 0, c.Max or 100
			local rounding = c.Rounding or 0
			local obj = Obj("Slider", c.Default or min, c.Callback)
			local row = Row(self, 56)
			New("TextLabel", { Text = c.Title or "", Position = UDim2.fromOffset(12, 9), Size = UDim2.new(1, -110, 0, 16), TextTruncate = Enum.TextTruncate.AtEnd, Parent = row, Theme = { TextColor3 = "Text" } })
			local valLabel = New("TextLabel", {
				TextXAlignment = Enum.TextXAlignment.Right, AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -12, 0, 9), Size = UDim2.fromOffset(90, 16), Parent = row, Theme = { TextColor3 = "SubText" },
			})
			local bar = New("Frame", {
				Position = UDim2.fromOffset(12, 38), Size = UDim2.new(1, -24, 0, 6), Parent = row, Theme = { BackgroundColor3 = "Stroke" },
			}, { Corner(3) })
			local fill = New("Frame", { Size = UDim2.fromScale(0, 1), Parent = bar, Theme = { BackgroundColor3 = "Accent" } }, { Corner(3) })
			New("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(1, 0.5), Size = UDim2.fromOffset(14, 14),
				BackgroundColor3 = Color3.new(1, 1, 1), Parent = fill,
			}, { Corner(7), Stroke("Accent", 2) })

			local fmtStr = "%." .. rounding .. "f"
			function obj:SetValue(v, silent)
				v = tonumber(v) or self.Value
				v = math.clamp(v, min, max)
				v = tonumber(string.format(fmtStr, v))
				self.Value = v
				local a = (max > min) and (v - min) / (max - min) or 0
				Tween(fill, 0.08, { Size = UDim2.fromScale(a, 1) })
				valLabel.Text = string.format(fmtStr, v) .. (c.Suffix or "")
				if not silent then self:_fire() end
			end
			obj:SetValue(obj.Value, true)

			local hit = New("TextButton", { Position = UDim2.fromOffset(6, 28), Size = UDim2.new(1, -12, 0, 26), BackgroundTransparency = 1, Parent = row })
			Drag(hit, function(pos)
				local a = math.clamp((pos.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
				local v = min + (max - min) * a
				local before = obj.Value
				obj:SetValue(v)
				if before == obj.Value then return end
			end)
			Register(id, obj)
			obj:_init()
			return obj
		end

		--------------------------------------------------------------
		-- DROPDOWN
		--------------------------------------------------------------
		function Tab:AddDropdown(id, c)
			id, c = Args(id, c)
			local multi = c.Multi == true
			local values = c.Values or {}
			local obj = Obj("Dropdown", multi and {} or nil, c.Callback)
			obj.Values = values

			local row = Row(self, 42)
			row.ClipsDescendants = true
			Labels(row, c.Title, nil, 170, 42)
			local head = New("TextButton", {
				AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 8), Size = UDim2.fromOffset(150, 26),
				Parent = row, Theme = { BackgroundColor3 = "Surface" },
			}, { Corner(6), Stroke("Stroke") })
			local valLabel = New("TextLabel", {
				Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -30, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = head, Theme = { TextColor3 = "Text" },
			})
			local arrow = New("TextLabel", {
				Text = "▾", TextXAlignment = Enum.TextXAlignment.Center, AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -6, 0.5, 0), Size = UDim2.fromOffset(14, 14), Parent = head, Theme = { TextColor3 = "SubText" },
			})
			local list = New("ScrollingFrame", {
				Position = UDim2.fromOffset(8, 48), Size = UDim2.new(1, -16, 0, 0), CanvasSize = UDim2.new(),
				AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, Parent = row,
				Theme = { ScrollBarImageColor3 = "Stroke" },
			}, { List(2) })

			local items, listH, open = {}, 0, false

			local function display()
				if multi then
					local t = {}
					for _, n in ipairs(values) do if obj.Value[n] then t[#t + 1] = n end end
					valLabel.Text = #t > 0 and table.concat(t, ", ") or "None"
				else
					valLabel.Text = obj.Value or "None"
				end
			end
			local function refresh()
				for name, it in pairs(items) do
					local sel = multi and obj.Value[name] or (obj.Value == name)
					Tween(it.btn, 0.15, { BackgroundTransparency = sel and 0 or 1 })
					it.lbl.TextColor3 = sel and T().Accent or T().Text
				end
				display()
			end
			local function setOpen(o)
				open = o
				Tween(row, 0.25, { Size = UDim2.new(1, 0, 0, o and (42 + listH + 14) or 42) })
				Tween(arrow, 0.25, { Rotation = o and 180 or 0 })
			end
			local function build()
				for _, it in pairs(items) do it.btn:Destroy() end
				items = {}
				for i, name in ipairs(values) do
					name = tostring(name)
					local b = New("TextButton", {
						Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, LayoutOrder = i, Parent = list,
						Theme = { BackgroundColor3 = "ElementHover" },
					}, { Corner(6) })
					local l = New("TextLabel", { Text = name, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -20, 1, 0), Parent = b })
					items[name] = { btn = b, lbl = l }
					b.MouseButton1Click:Connect(function()
						if multi then
							if obj.Value[name] then obj.Value[name] = nil else obj.Value[name] = true end
						else
							obj.Value = name
							setOpen(false)
						end
						refresh()
						obj:_fire()
					end)
				end
				listH = math.min(#values, 5) * 30
				list.Size = UDim2.new(1, -16, 0, listH)
				if open then setOpen(true) end
				refresh()
			end

			function obj:SetValue(v, silent)
				if multi then
					local map = {}
					if type(v) == "table" then
						for k, val in pairs(v) do
							if type(k) == "number" then map[tostring(val)] = true elseif val then map[k] = true end
						end
					end
					self.Value = map
				else
					if type(v) == "number" then v = values[v] end
					self.Value = v and tostring(v) or nil
				end
				refresh()
				if not silent then self:_fire() end
			end
			function obj:SetValues(new)
				values = new or {}
				self.Values = values
				build()
			end

			OnTheme(refresh)
			build()
			if c.Default ~= nil then obj:SetValue(c.Default, true) end

			head.MouseButton1Click:Connect(function() setOpen(not open) end)
			Register(id, obj)
			obj:_init()
			return obj
		end

		--------------------------------------------------------------
		-- INPUT
		--------------------------------------------------------------
		function Tab:AddInput(id, c)
			id, c = Args(id, c)
			local obj = Obj("Input", c.Default or "", c.Callback)
			local w = c.Width or 150
			local row = Row(self, c.Description and 56 or 42)
			Labels(row, c.Title, c.Description, w + 12)
			local st = Stroke("Stroke")
			local box = New("TextBox", {
				Text = obj.Value, PlaceholderText = c.Placeholder or "", AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(w, 26), ClipsDescendants = true,
				TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
				Theme = { BackgroundColor3 = "Surface", TextColor3 = "Text", PlaceholderColor3 = "SubText" },
			}, { Corner(6), st, Pad(8, 0, 8, 0) })
			box.Focused:Connect(function() Tween(st, 0.15, { Color = T().Accent }) end)
			function obj:SetValue(v, silent)
				self.Value = tostring(v or "")
				box.Text = self.Value
				if not silent then self:_fire() end
			end
			box.FocusLost:Connect(function()
				Tween(st, 0.15, { Color = T().Stroke })
				local txt = box.Text
				if c.Numeric then txt = tostring(tonumber(txt) or obj.Value) end
				obj:SetValue(txt)
			end)
			Register(id, obj)
			obj:_init()
			return obj
		end

		--------------------------------------------------------------
		-- KEYBIND
		--------------------------------------------------------------
		function Tab:AddKeybind(id, c)
			id, c = Args(id, c)
			local def = c.Default
			if typeof(def) == "EnumItem" then def = def.Name end
			local obj = Obj("Keybind", def or "None", c.ChangedCallback)
			obj.Mode = c.Mode or "Press" -- Press | Toggle | Hold
			obj.State = false
			local row = Row(self, c.Description and 56 or 42)
			Labels(row, c.Title, c.Description, 100)
			local btn = New("TextButton", {
				Text = obj.Value, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0),
				Size = UDim2.fromOffset(84, 26), Parent = row, Theme = { BackgroundColor3 = "Surface", TextColor3 = "Text" },
			}, { Corner(6), Stroke("Stroke") })
			local listening = false
			function obj:SetValue(v, silent)
				if typeof(v) == "EnumItem" then v = v.Name end
				self.Value = v or "None"
				btn.Text = self.Value
				if not silent then self:_fire() end
			end
			function obj:GetState() return self.State end
			btn.MouseButton1Click:Connect(function() listening = true; btn.Text = "..." end)
			Connect(UIS.InputBegan, function(input, gp)
				if listening then
					if input.UserInputType == Enum.UserInputType.Keyboard then
						listening = false
						obj:SetValue(input.KeyCode == Enum.KeyCode.Escape and "None" or input.KeyCode.Name)
					end
					return
				end
				if gp or obj.Value == "None" then return end
				if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == obj.Value then
					if obj.Mode == "Toggle" then obj.State = not obj.State else obj.State = true end
					if c.Callback then task.spawn(c.Callback, obj.State) end
				end
			end)
			Connect(UIS.InputEnded, function(input)
				if obj.Mode == "Hold" and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == obj.Value then
					obj.State = false
					if c.Callback then task.spawn(c.Callback, false) end
				end
			end)
			Register(id, obj)
			return obj
		end

		--------------------------------------------------------------
		-- COLORPICKER
		--------------------------------------------------------------
		function Tab:AddColorpicker(id, c)
			id, c = Args(id, c)
			local obj = Obj("Colorpicker", c.Default or Color3.fromRGB(255, 255, 255), c.Callback)
			local row = Row(self, 42)
			row.ClipsDescendants = true
			Labels(row, c.Title, nil, 60, 42)
			local swatch = New("TextButton", {
				AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 10), Size = UDim2.fromOffset(36, 22),
				BackgroundColor3 = obj.Value, Parent = row,
			}, { Corner(6), Stroke("Stroke") })

			local h, s, v = obj.Value:ToHSV()
			local sv = New("Frame", {
				Position = UDim2.fromOffset(12, 52), Size = UDim2.new(1, -52, 0, 100),
				BackgroundColor3 = Color3.fromHSV(h, 1, 1), Parent = row,
			}, { Corner(6) })
			New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), Parent = sv },
				{ Corner(6), New("UIGradient", { Transparency = NumberSequence.new(0, 1) }) })
			New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), Parent = sv },
				{ Corner(6), New("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0) }) })
			local svCursor = New("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(12, 12), BackgroundColor3 = Color3.new(1, 1, 1),
				ZIndex = 4, Parent = sv,
			}, { New("UICorner", { CornerRadius = UDim.new(1, 0) }), New("UIStroke", { Thickness = 2, Color = Color3.new(0, 0, 0) }) })
			local svHit = New("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 3, Parent = sv })

			local hue = New("Frame", {
				AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 52), Size = UDim2.fromOffset(16, 100),
				BackgroundColor3 = Color3.new(1, 1, 1), Parent = row,
			}, { Corner(6), New("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
					ColorSequenceKeypoint.new(1 / 6, Color3.fromRGB(255, 255, 0)),
					ColorSequenceKeypoint.new(2 / 6, Color3.fromRGB(0, 255, 0)),
					ColorSequenceKeypoint.new(3 / 6, Color3.fromRGB(0, 255, 255)),
					ColorSequenceKeypoint.new(4 / 6, Color3.fromRGB(0, 0, 255)),
					ColorSequenceKeypoint.new(5 / 6, Color3.fromRGB(255, 0, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
				}),
			}) })
			local hueCursor = New("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(1, 4, 0, 4), BackgroundColor3 = Color3.new(1, 1, 1),
				ZIndex = 4, Parent = hue,
			}, { Corner(2), New("UIStroke", { Thickness = 1, Color = Color3.new(0, 0, 0) }) })
			local hueHit = New("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 3, Parent = hue })

			local function apply(silent)
				local col = Color3.fromHSV(h, s, v)
				obj.Value = col
				swatch.BackgroundColor3 = col
				sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
				svCursor.Position = UDim2.fromScale(s, 1 - v)
				hueCursor.Position = UDim2.fromScale(0.5, h)
				if not silent then obj:_fire() end
			end
			function obj:SetValue(col, silent)
				if typeof(col) ~= "Color3" then return end
				h, s, v = col:ToHSV()
				apply(silent)
			end
			Drag(svHit, function(pos)
				s = math.clamp((pos.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
				v = 1 - math.clamp((pos.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
				apply()
			end)
			Drag(hueHit, function(pos)
				h = math.clamp((pos.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 0.999)
				apply()
			end)
			apply(true)

			local open = false
			swatch.MouseButton1Click:Connect(function()
				open = not open
				Tween(row, 0.25, { Size = UDim2.new(1, 0, 0, open and 164 or 42) })
			end)
			Register(id, obj)
			obj:_init()
			return obj
		end

		return Tab
	end

	return Window
end

----------------------------------------------------------------------
-- CONFIG SAVE / LOAD
----------------------------------------------------------------------
local function hasFS()
	return writefile and readfile and isfile and makefolder and isfolder and true or false
end

function Aurora:SaveConfig(name)
	if not hasFS() then return false, "Executor không hỗ trợ file system" end
	local data = {}
	for id, o in pairs(self.Options) do
		local val = o.Value
		if o.Type == "Colorpicker" then
			val = { math.floor(val.R * 255 + 0.5), math.floor(val.G * 255 + 0.5), math.floor(val.B * 255 + 0.5) }
		end
		data[id] = { Type = o.Type, Value = val }
	end
	local path = ""
	for part in string.gmatch(self.ConfigFolder, "[^/]+") do
		path = (path == "") and part or (path .. "/" .. part)
		if not isfolder(path) then makefolder(path) end
	end
	writefile(self.ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
	return true
end

function Aurora:LoadConfig(name)
	if not hasFS() then return false, "Executor không hỗ trợ file system" end
	local file = self.ConfigFolder .. "/" .. name .. ".json"
	if not isfile(file) then return false, "Không tìm thấy config" end
	local ok, data = pcall(function() return HttpService:JSONDecode(readfile(file)) end)
	if not ok then return false, "Config bị lỗi" end
	for id, item in pairs(data) do
		local o = self.Options[id]
		if o and o.Type == item.Type and item.Value ~= nil then
			local val = item.Value
			if o.Type == "Colorpicker" then val = Color3.fromRGB(val[1], val[2], val[3]) end
			pcall(o.SetValue, o, val)
		end
	end
	return true
end

function Aurora:ListConfigs()
	local out = {}
	if hasFS() and listfiles and isfolder(self.ConfigFolder) then
		for _, p in ipairs(listfiles(self.ConfigFolder)) do
			local n = p:match("([^/\\]+)%.json$")
			if n then table.insert(out, n) end
		end
	end
	return out
end

----------------------------------------------------------------------
function Aurora:Destroy()
	for _, c in ipairs(connections) do c:Disconnect() end
	table.clear(connections)
	table.clear(registry)
	table.clear(refreshers)
	table.clear(self.Options)
	if self.Gui then self.Gui:Destroy(); self.Gui = nil end
end

return Aurora
