-- إشعار
print("🔥 Ahmed Hub Loaded")

pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "احمد بطل",
        Text = "اشتغل السكربت ✅",
        Duration = 5
    })
end)

-- UI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Key
local KEY = "5566"

WindUI.Services.mykeysystem = {
    Name = "Key System",
    Icon = "key",
    Args = {},
    New = function()
        return {
            Verify = function(k)
                return k == KEY, k == KEY and "صح ✅" or "خطأ ❌"
            end,
            Copy = function()
                setclipboard("https://rekonise.com/key-cltk6")
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
        Note = "انسخ الرابط وخذ الكود 🔑",
        API = {
            { Type = "mykeysystem" }
        }
    }
})

local Tab = Window:Tab({ Title = "Main", Icon = "zap" })

-- خدمات
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Aimbot = false
local ESP = false
local Holding = false

-- أزرار
Tab:Button({Title="تشغيل Aimbot 🎯",Callback=function() Aimbot=true end})
Tab:Button({Title="ايقاف Aimbot ❌",Callback=function() Aimbot=false end})
Tab:Button({Title="تشغيل ESP 👁️",Callback=function() ESP=true end})
Tab:Button({Title="ايقاف ESP ❌",Callback=function() ESP=false end})

-- 📱 زر Aim للموبايل
local aimBtn = Instance.new("TextButton", game.CoreGui)
aimBtn.Size = UDim2.new(0,80,0,80)
aimBtn.Position = UDim2.new(1,-100,1,-120)
aimBtn.Text = "AIM"
aimBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
aimBtn.TextScaled = true

aimBtn.MouseButton1Down:Connect(function()
    Holding = true
end)

aimBtn.MouseButton1Up:Connect(function()
    Holding = false
end)

-- Team Check
local function IsEnemy(player)
    if player == LocalPlayer then return false end
    if LocalPlayer.Team and player.Team then
        return player.Team ~= LocalPlayer.Team
    end
    return true
end

-- Wall Check
local function IsVisible(target)
    local origin = Camera.CFrame.Position
    local direction = (target.Position - origin)

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character}

    local result = workspace:Raycast(origin, direction, params)
    if result then
        return result.Instance:IsDescendantOf(target.Parent)
    end
    return true
end

-- أقرب لاعب (Head فقط)
local function GetClosest()
    local closest, dist = nil, math.huge

    for _,v in pairs(Players:GetPlayers()) do
        if IsEnemy(v) and v.Character and v.Character:FindFirstChild("Head") then
            
            local head = v.Character.Head
            local mag = (head.Position - Camera.CFrame.Position).Magnitude

            if IsVisible(head) and mag < dist then
                dist = mag
                closest = v
            end
        end
    end

    return closest
end

-- ESP متطور
local ESPTable = {}

local function AddESP(player)
    if player == LocalPlayer then return end

    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.3
    highlight.Parent = game.CoreGui

    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(4,0,2,0)
    bill.AlwaysOnTop = true

    local text = Instance.new("TextLabel", bill)
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextScaled = true
    text.TextColor3 = Color3.new(1,1,1)

    ESPTable[player] = {highlight=highlight, bill=bill, text=text}
end

for _,v in pairs(Players:GetPlayers()) do
    AddESP(v)
end
Players.PlayerAdded:Connect(AddESP)

-- تشغيل
RunService.RenderStepped:Connect(function()

    -- ESP
    for player,data in pairs(ESPTable) do
        if player ~= LocalPlayer
        and player.Character
        and player.Character:FindFirstChild("Head")
        and player.Character:FindFirstChild("Humanoid") then

            local hum = player.Character.Humanoid
            local head = player.Character.Head
            local dist = math.floor((head.Position - Camera.CFrame.Position).Magnitude)

            if ESP and IsEnemy(player) then
                data.highlight.Adornee = player.Character
                data.highlight.FillColor = Color3.fromRGB(255,0,0)
                data.highlight.Enabled = true

                data.bill.Adornee = head
                data.bill.Parent = player.Character
                data.text.Text = player.Name.." | ❤️ "..math.floor(hum.Health).." | 📏 "..dist

                data.bill.Enabled = true
            else
                data.highlight.Enabled = false
                data.bill.Enabled = false
            end
        end
    end

    -- 🎯 Aimbot (Head فقط + زر موبايل)
    if Aimbot and Holding then
        local t = GetClosest()
        if t and t.Character and t.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
        end
    end
end)
