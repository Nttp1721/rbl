local MeizuLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/lib.lua"))()   -- library v3.0 của bạn, KHÔNG ĐỔI GÌ
local Window = MeizuLibrary:CreateWindow{ Title = "MEIZU HUB" }
local Tab = Window:CreateTab("Chính", "rbxassetid://10734950309")

local Extras = loadstring(...)()          -- file v2.0 này
Extras:Attach(MeizuLibrary)               -- gọi SAU khi đã CreateWindow

-- Nhóm 1+2: element mới & section gập
local sec = Extras:CreateCollapsible(Tab, "Tự Động Farm", false)
sec:CreateToggle  -- ← toggle của library vẫn dùng riêng, còn element mới thì:
Extras:CreateDivider(sec, {Title = "Tiến độ"})
Extras:CreateProgress(Tab, {Name = "Kinh nghiệm", Flag = "exp", Max = 100, Callback = function(v) print(v) end})
Extras:CreateStepper(Tab, {Name = "Độ trễ", Flag = "delay", Default = 5, Min = 1, Max = 60, Step = 1})
Extras:CreateSegmented(Tab, {Name = "Chế độ", Flag = "mode", Options = {"Thường", "Nhanh", "Max"}, Default = 1})
Extras:CreateLabel(Tab, {Title = "MEIZU HUB v3.1", Description = "Cảm ơn đã sử dụng!"})

-- Nhóm 3: hệ thống
Extras:EnableAutoSave{Name = "meizu_hub"}
Extras:EnableRememberWindow()
Extras:EnableResize{MinW = 460, MinH = 320}
Extras:EnableSnapButton{Window = Window, Icon = "rbxassetid://10734950309"}
Extras:EnableBlur{Radius = 8}
Extras:EnableWatermark{Text = "MEIZU HUB"}
Extras:EnablePowerSave(false)  -- bật true khi muốn tiết kiệm pin
