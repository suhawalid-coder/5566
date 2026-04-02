print("🔥 Ahmed Hub Loaded")

game.StarterGui:SetCore("SendNotification", {
    Title = "احمد بطل",
    Text = "اشتغل السكربت ✅",
    Duration = 5
})

-- هنا حط سكربتك الكامل (Aimbot + ESP + Key)
-- تحميل WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- 🔐 Key
local SECRET_KEY = "5566"

WindUI.Services.mykeysystem = {
    Name = "Key System",
    Icon = "key",
    Args = {},

    New = function()
        local function validateKey(key)
            if key == SECRET_KEY then
                return true, "تم الدخول ✅"
            else
                return false, "كلمة السر خطأ ❌"
            end
        end

        return {
            Verify = validateKey,
            Copy = function()
                setclipboard("5566")
            end
        }
    end
}

-- 🏷️ نافذة
local Window = WindUI:CreateWindow({
    Title = "🔥 احمد بطل",
    Icon = "target",
    Author = "Ahmed",
    Folder = "AhmedHub",

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

    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(4,0,5,0)
    bill.AlwaysOnTop = true
    bill.Parent = LocalPlayer.PlayerGui

    local hpBG = Instance.new("Frame", bill)
    hpBG.Size = UDim2.new(1,0,0.25,0)
    hpBG.Position = UDim2.new(0,0,-0.6,0)

    local hpBar = Instance.new("Frame", hpBG)

    ESPTable[player] = {bill,hpBar,highlight}
end

for _,v in pairs(Players:GetPlayers()) do
    AddESP(v)
end
Players.PlayerAdded:Connect(AddESP)

-- تشغيل
RunService.RenderStepped:Connect(function()

    -- ESP
    for player,data in pairs(ESPTable) do
        local bill,hpBar,highlight = unpack(data)

        if ESP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if (not player.Team) or (not LocalPlayer.Team) or player.Team ~= LocalPlayer.Team then

                local root = player.Character.HumanoidRootPart
                local hum = player.Character:FindFirstChild("Humanoid")

                if hum then
                    bill.Adornee = root

                    local hp = hum.Health / hum.MaxHealth
                    hpBar.Size = UDim2.new(hp,0,1,0)

                    if hp > 0.7 then
                        hpBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
                    elseif hp > 0.3 then
                        hpBar.BackgroundColor3 = Color3.fromRGB(255,255,0)
                    else
                        hpBar.BackgroundColor3 = Color3.fromRGB(255,0,0)
                    end

                    highlight.Adornee = player.Character
                    highlight.FillColor = hpBar.BackgroundColor3

                    bill.Enabled = true
                    highlight.Enabled = true
                end
            else
                bill.Enabled = false
                highlight.Enabled = false
            end
        else
            bill.Enabled = false
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
