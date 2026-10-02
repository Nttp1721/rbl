local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local fileName = "meizunew.png"
local imageUrl = "https://i.ibb.co/rG31XyYV/meizunew.png"

local ASSET_LOGO = ""
pcall(function()
    if isfile and writefile and getcustomasset then
        if not isfile(fileName) then
            writefile(fileName, game:HttpGet(imageUrl))
        end
        ASSET_LOGO = getcustomasset(fileName)
    end
end)

local DISCORD_LINK = "https://discord.gg/sylphins"

-- Auto-copy Discord link to clipboard
if setclipboard then
    pcall(function()
        setclipboard(DISCORD_LINK)
    end)
end
