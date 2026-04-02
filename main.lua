-- إشعار
print("🔥 Ahmed Hub Loaded")

pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "احمد بطل",
        Text = "اشتغل السكربت ✅",
        Duration = 5
    })
end)

-- تحميل UI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- 🔐 Key
local KEY = "5566"

WindUI.Services.mykeysystem = {
    Name = "Key System",
    Icon = "key",
    Args = {},

    New = function()
        return {
            Verify = function(k)
                if k == KEY then
                    return true, "صح ✅"
                else
                    return false, "خطأ ❌"
                end
            end,
            Copy = function()
                setclipboard("5566")
            end
        }
    end
}

-- نافذة
local Window = WindUI:CreateWindow({
    Title = "🔥 احمد بطل",
    Icon = "target",
    Author = "Ahmed",

    KeySystem = {
        Note = "اكتب الكود 🔑",
        API = {
            { Type = "mykeysystem" }
        }
    }
})

local Tab = Window:Tab({
    Title = "Main",
    Icon = "zap"
})

-- خدمات
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Aimbot = false
local ESP = true

-- أزرار
Tab:Toggle({
    Title = "Aimbot",
    Callback = function(v)
        Aimbot = v
    end
})

Tab:Toggle({
    Title = "ESP",
    Callback = function(v)
        ESP = v
    end
})

-- أقرب لاعب
local function GetClosest()
    local closest, dist = nil, math.huge

    for _,v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            if (not v.Team) or (not LocalPlayer.Team) or v.Team ~= LocalPlayer.Team then
                
                local mag = (v.Character.Head.Position - Camera.CFrame.Position).Magnitude
                if mag < dist then
                    dist = mag
                    closest = v
                end
            end
        end
    end

    return closest
end

-- ESP
local ESPTable = {}

local function AddESP(player)
    if player == LocalPlayer then return end

    local highlight = Instance.new("Highlight")
    highlight.Parent = game.CoreGui

    ESPTable[player] = highlight
end

for _,v in pairs(Players:GetPlayers()) do
    AddESP(v)
end
Players.PlayerAdded:Connect(AddESP)

-- تشغيل
RunService.RenderStepped:Connect(function()

    -- ESP
    for player,highlight in pairs(ESPTable) do
        if ESP and player.Character then
            if (not player.Team) or (not LocalPlayer.Team) or player.Team ~= LocalPlayer.Team then
                highlight.Adornee = player.Character
                highlight.FillColor = Color3.fromRGB(255,0,0)
                highlight.Enabled = true
            else
                highlight.Enabled = false
            end
        else
            highlight.Enabled = false
        end
    end

    -- 🎯 Aimbot سريع
    if Aimbot then
        local t = GetClosest()
        if t and t.Character and t.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
        end
    end
end)
