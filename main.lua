-- تحميل WindUI
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/footagesus/WindUI/main/dist/library.lua"))()

-- نافذة
local Window = WindUI:CreateWindow({
    Title = "🔥 ماب حياة السجن",
    Icon = "door-open",
    Author = "Ahmed",
    Folder = "AhmedHub",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
})

local Tab = Window:Tab({ Title = "التحكم", Icon = "settings" })

-- =========================
-- الإعدادات
-- =========================
local Settings = {
    تتبع = false,
    اظهار = false,
    طيران = false,
    FOV = false,
    فرق = true, -- 🔥 نظام الفرق

    قوة_القفز = 100,
    سرعة_الطيران = 60,
    سرعة_التتبع = 0.2,
    حجم_FOV = 150
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- =========================
-- التحقق من العدو
-- =========================
local function عدو(p)
    if not Settings.فرق then return true end
    if not p.Team or not LocalPlayer.Team then return true end
    return p.Team ~= LocalPlayer.Team
end

-- =========================
-- Toggles
-- =========================
Tab:Toggle({
    Title = "🎯 تتبع",
    Callback = function(v) Settings.تتبع = v end
})

Tab:Toggle({
    Title = "👁️ ESP",
    Callback = function(v) Settings.اظهار = v end
})

Tab:Toggle({
    Title = "🕊️ Fly",
    Callback = function(v) Settings.طيران = v end
})

Tab:Toggle({
    Title = "🎯 FOV",
    Callback = function(v) Settings.FOV = v end
})

Tab:Toggle({
    Title = "👥 نظام الفرق",
    Default = true,
    Callback = function(v) Settings.فرق = v end
})

-- =========================
-- Sliders
-- =========================
Tab:Slider({
    Title = "🦘 قوة القفز",
    Min = 50,
    Max = 300,
    Value = 100,
    Callback = function(v)
        Settings.قوة_القفز = v
        if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = v
        end
    end
})

Tab:Slider({
    Title = "🕊️ سرعة الطيران",
    Min = 20,
    Max = 200,
    Value = 60,
    Callback = function(v)
        Settings.سرعة_الطيران = v
    end
})

Tab:Slider({
    Title = "⚡ سرعة التتبع",
    Min = 1,
    Max = 10,
    Value = 5,
    Callback = function(v)
        Settings.سرعة_التتبع = v / 10
    end
})

Tab:Slider({
    Title = "📏 حجم FOV",
    Min = 50,
    Max = 400,
    Value = 150,
    Callback = function(v)
        Settings.حجم_FOV = v
    end
})

-- =========================
-- Buttons
-- =========================
Tab:Button({
    Title = "🛑 إيقاف كلشي",
    Callback = function()
        Settings.تتبع = false
        Settings.اظهار = false
        Settings.طيران = false
        Settings.FOV = false
    end
})

Tab:Button({
    Title = "🚀 سرعة خارقة",
    Callback = function()
        Settings.سرعة_الطيران = 150
        Settings.سرعة_التتبع = 0.5
    end
})

Tab:Button({
    Title = "🦘 قفز خارق",
    Callback = function()
        Settings.قوة_القفز = 250
        if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 250
        end
    end
})

-- =========================
-- FOV
-- =========================
local circle = Drawing.new("Circle")
circle.Thickness = 2
circle.Filled = false
circle.Color = Color3.fromRGB(255,0,0)

-- =========================
-- ESP
-- =========================
local ESP = {}

local function AddESP(p)
    if p == LocalPlayer then return end

    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(4,0,2,0)
    bill.AlwaysOnTop = true

    local txt = Instance.new("TextLabel", bill)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.TextScaled = true

    ESP[p] = {bill, txt}
end

for _,v in pairs(Players:GetPlayers()) do AddESP(v) end
Players.PlayerAdded:Connect(AddESP)

-- =========================
-- Fly
-- =========================
local bv, bg

-- =========================
-- تشغيل
-- =========================
RunService.RenderStepped:Connect(function()

    -- FOV
    circle.Visible = Settings.FOV
    circle.Radius = Settings.حجم_FOV
    circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    -- ESP
    for p,data in pairs(ESP) do
        if Settings.اظهار and p.Character and عدو(p) then
            local hum = p.Character:FindFirstChild("Humanoid")

            data[1].Adornee = p.Character.Head
            data[1].Parent = p.Character

            if hum then
                data[2].Text = p.Name.." ❤️"..math.floor(hum.Health)
            end

            data[1].Enabled = true
        else
            data[1].Enabled = false
        end
    end

    -- تتبع
    if Settings.تتبع then
        local closest = nil
        local dist = math.huge

        for _,v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and عدو(v) then
                local pos, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)

                if vis then
                    local mag = (Vector2.new(pos.X,pos.Y) - Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude

                    if mag < Settings.حجم_FOV and mag < dist then
                        dist = mag
                        closest = v
                    end
                end
            end
        end

        if closest then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, closest.Character.Head.Position),
                Settings.سرعة_التتبع
            )
        end
    end

    -- Fly
    if Settings.طيران and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if hrp then
            if not bv then
                bv = Instance.new("BodyVelocity", hrp)
                bv.MaxForce = Vector3.new(1e5,1e5,1e5)

                bg = Instance.new("BodyGyro", hrp)
                bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
            end

            bv.Velocity = Camera.CFrame.LookVector * Settings.سرعة_الطيران
            bg.CFrame = Camera.CFrame
        end
    else
        if bv then bv:Destroy() bv=nil end
        if bg then bg:Destroy() bg=nil end
    end

end)
