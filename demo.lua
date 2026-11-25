-- Demo cho Meizu Library v4.0. Chay file nay de thu moi phan tu.
-- Cach tai: dat lib_v4.lua len repo roi doi URL ben duoi, hoac: loadstring(readfile("lib_v4.lua"))()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/lib_v4.lua"))()

Library:AddTranslation({ vi = { ["Auto Farm"] = "Tự động farm", ["Combat"] = "Chiến đấu", ["Walk speed"] = "Tốc độ chạy" } })

local Window = Library:CreateWindow({ Title = "Meizu", Subtitle = "v4.0 Graphite", ToggleKey = Enum.KeyCode.RightShift, AutoLoad = false })

local Main = Window:CreateTab("Main")
local Farm = Main:CreateSection("Combat")
Farm:CreateToggle({ Title = "Auto Farm", Description = "Gõ Ctrl+K rồi tìm 'farm' để bật nhanh", Flag = "farm", Tooltip = "Bật / tắt farm tự động", Callback = function(v) print("farm", v) end })
Farm:CreateSlider({ Title = "Walk speed", Min = 16, Max = 120, Default = 16, Suffix = " st/s", Flag = "speed", Callback = function(v) print("speed", v) end })
Farm:CreateToggle({ Title = "Locked feature", Description = "Vô hiệu hóa bằng Disabled = true hoặc el:SetEnabled(false)", Disabled = true })
Farm:CreateStepper({ Title = "Targets", Min = 1, Max = 10, Default = 3, Flag = "targets" })
Farm:CreateSegmented({ Title = "Mode", Options = { "Safe", "Normal", "Rage" }, Default = "Normal", Flag = "mode" })
Farm:CreateButton({ Title = "Say hello", ButtonText = "Run", Callback = function()
    Library:Notify({ Title = "Xin chào", Content = "Thư viện đang chạy tốt.", Type = "success", Duration = 3 })
end })

local Pick = Main:CreateSection("Select")
Pick:CreateDropdown({ Title = "Weapon", Options = { "Sword", "Bow", "Staff", "Dagger" }, Default = "Sword", Flag = "weapon" })
local many = {}
for i = 1, 300 do many[i] = "Item " .. i end
Pick:CreateMultiDropdown({ Title = "Big list (300)", Options = many, Default = { "Item 1" }, Flag = "items" })
Pick:CreateKeybind({ Title = "Dash", Default = Enum.KeyCode.Q, Mode = "Press", Flag = "dash", Callback = function() print("dash") end })
Pick:CreateKeybind({ Title = "Sprint (hold)", Default = Enum.KeyCode.LeftShift, Mode = "Hold", Flag = "sprint", Callback = function(on) print("sprint", on) end })
Pick:CreateInput({ Title = "Player name", Placeholder = "Name...", Flag = "target", Callback = function(t) print("name", t) end })
Pick:CreateColorPicker({ Title = "ESP color", Default = Color3.fromRGB(255, 120, 60), Flag = "esp", Callback = function(c) print("esp", c) end })

local Live = Window:CreateTab("Live")
local Stats = Live:CreateSection("Stats")
local stat = Stats:CreateStat({ Title = "Coins", Value = "0" })
local prog = Stats:CreateProgress({ Title = "Quest", Default = 0 })
local spark = Stats:CreateSparkline({ Title = "Coins / min", Points = 40, Decimals = 0 })
Stats:CreateParagraph({ Title = "Ghi chú", Content = "Sparkline chỉ đổi Size của 40 thanh cố định nên gần như không tốn FPS." })
Stats:CreateDivider()
Stats:CreateLabel("Số liệu bên trên được cập nhật mỗi 0.5 giây.")

local Group = Window:CreateTabGroup("Extra")
local Misc = Group:CreateTab("Misc")
Misc:CreateButton({ Title = "Open dialog", ButtonText = "Open", Callback = function()
    Window:Dialog({ Title = "Xác nhận", Content = "Bạn có chắc muốn tiếp tục?", Buttons = {
        { Title = "Cancel" },
        { Title = "OK", Style = "Primary", Callback = function() Library:Notify({ Title = "Đã xác nhận", Duration = 2 }) end },
    } })
end })

task.spawn(function()
    local coins, quest = 0, 0
    while Library.Window == Window and task.wait(0.5) do
        coins = coins + math.random(0, 40)
        quest = (quest + math.random(1, 4)) % 101
        stat:Set(tostring(coins))
        prog:Set(quest)
        spark:Push(math.random(20, 90))
    end
end)
