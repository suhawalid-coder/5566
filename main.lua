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

-- نافذة
local Window = WindUI:CreateWindow({
    Title = "My Super Hub",
    Icon = "door-open",
    Author = "Ahmed",
    Size = UDim2.fromOffset(580,460),

    KeySystem = {
        Key = {"5566"},
        Note = "اكتب الكود  🔑",
        URL = "https://rekonise.com/key-cltk6",
        SaveKey = false
    }
})

local Tab = Window:Tab({Title="Main",Icon="zap"})

-- خدمات
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Aimbot = false
local ESP = false
local JumpPower = 120

-- أزرار
Tab:Button({Title="تشغيل Aimbot 🎯",Callback=function()Aimbot=true end})
Tab:Button({Title="ايقاف Aimbot ❌",Callback=function()Aimbot=false end})
Tab:Button({Title="تشغيل ESP 👁️",Callback=function()ESP=true end})
Tab:Button({Title="ايقاف ESP ❌",Callback=function()ESP=false end})

Tab:Button({
    Title="زيادة القفز 🦘",
    Callback=function()
        JumpPower = JumpPower + 50
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = JumpPower
        end
    end
})

Tab:Button({
    Title="تقليل القفز ⬇️",
    Callback=function()
        JumpPower = math.max(50, JumpPower - 50)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = JumpPower
        end
    end
})

-- حياة اللاعب
local function IsAlive(player)
    if not player.Character then return false end
    local hum = player.Character:FindFirstChild("Humanoid")
    return hum and hum.Health > 0
end

-- فريق
local function IsEnemy(player)
    if player == LocalPlayer then return false end
    if LocalPlayer.Team and player.Team then
        return player.Team ~= LocalPlayer.Team
    end
    return true
end

-- جدار
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

-- أقرب هدف
local function GetClosest()
    local closest, dist = nil, math.huge

    for _,v in pairs(Players:GetPlayers()) do
        if IsEnemy(v) and IsAlive(v) and v.Character and v.Character:FindFirstChild("Head") then
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

-- ESP
local ESPTable = {}

local function AddESP(player)
    if player == LocalPlayer then return end

    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.3
    highlight.Parent = game.CoreGui

    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(6,0,3,0)
    bill.AlwaysOnTop = true

    local text = Instance.new("TextLabel", bill)
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextScaled = true
    text.TextSize = 20
    text.Font = Enum.Font.GothamBold
    text.TextColor3 = Color3.new(1,1,1)

    ESPTable[player] = {highlight=highlight, bill=bill, text=text}
end

for _,v in pairs(Players:GetPlayers()) do
    AddESP(v)
end
Players.PlayerAdded:Connect(AddESP)

-- قفز
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum.JumpPower = JumpPower
end)

-- تشغيل
RunService.RenderStepped:Connect(function()

    -- ESP
    for player,data in pairs(ESPTable) do
        if ESP and IsEnemy(player) and IsAlive(player) and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local hum = player.Character:FindFirstChild("Humanoid")

            if head and hum then
                local dist = math.floor((head.Position - Camera.CFrame.Position).Magnitude)

                data.highlight.Adornee = player.Character
                data.highlight.FillColor = Color3.fromRGB(255,0,0)
                data.highlight.Enabled = true

                data.bill.Adornee = head
                data.bill.Parent = player.Character
                data.text.Text = player.Name.." | ❤️ "..math.floor(hum.Health).." | 📏 "..dist
                data.bill.Enabled = true
            end
        else
            if data.highlight then data.highlight.Enabled=false end
            if data.bill then data.bill.Enabled=false end
        end
    end

    -- Aimbot
    if Aimbot then
        local t = GetClosest()
        if t and IsAlive(t) and t.Character and t.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
        end
    end
end)
