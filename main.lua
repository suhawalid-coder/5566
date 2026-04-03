print("🔥 Ahmed Hub Loaded")

pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "🔥 ماب حياة السجن",
        Text = "اشتغل السكربت ✅",
        Duration = 5
    })
end)

-- تحميل WindUI
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/footagesus/WindUI/main/dist/library.lua"))()

-- Key System
WindUI.Services.mysuper = {
    Name = "Ahmed Key System",
    Icon = "key",
    Args = {"ServiceId","SuperId"},

    New = function()
        function validateKey(key)
            local validKeys = {
                ["AHMED123"]=true,
                ["VIP5566"]=true,
            }
            if validKeys[key] then
                return true,"✅ صحيح"
            else
                return false,"❌ خطأ"
            end
        end

        function copyLink()
            setclipboard("https://rekonise.com/key-cltk6")
        end

        return {Verify=validateKey,Copy=copyLink}
    end
}

-- نافذة
local Window = WindUI:CreateWindow({
    Title="🔥 ماب حياة السجن",
    Icon="door-open",
    Author="Ahmed",
    Folder="AhmedHub",
    Size=UDim2.fromOffset(580,460),
    Transparent=true,
    Theme="Dark",

    KeySystem={
        Note="🔑 اضغط حتى تروح للرابط",
        URL="https://rekonise.com/key-cltk6",
        SaveKey=true,
        API={{
            Title="Get Key 🔑",
            Desc="اضغط يوديك للرابط",
            Type="mysuper",
            ServiceId="AHMED",
            SuperId="5566",
        }}
    }
})

local Tab = Window:Tab({Title="التحكم",Icon="settings"})

-- Services
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Camera=workspace.CurrentCamera
local LocalPlayer=Players.LocalPlayer

-- Safe Mode
local Safe={Delay=0.03,MaxFly=80,MaxJump=150}

-- Settings
local Settings={
    تتبع=false,اظهار=false,طيران=false,FOV=false,فرق=true,
    قوة_القفز=100,سرعة_الطيران=60,سرعة_التتبع=0.2,حجم_FOV=150
}

local function Clamp()
    if Settings.سرعة_الطيران>Safe.MaxFly then Settings.سرعة_الطيران=Safe.MaxFly end
    if Settings.قوة_القفز>Safe.MaxJump then Settings.قوة_القفز=Safe.MaxJump end
end

local function Enemy(p)
    if not Settings.فرق then return true end
    if not p.Team or not LocalPlayer.Team then return true end
    return p.Team~=LocalPlayer.Team
end

-- UI
Tab:Toggle({Title="🎯 تتبع",Callback=function(v) Settings.تتبع=v end})
Tab:Toggle({Title="👁️ ESP",Callback=function(v) Settings.اظهار=v end})
Tab:Toggle({Title="🕊️ Fly",Callback=function(v) Settings.طيران=v end})
Tab:Toggle({Title="🎯 FOV",Callback=function(v) Settings.FOV=v end})
Tab:Toggle({Title="👥 نظام الفرق",Default=true,Callback=function(v) Settings.فرق=v end})

Tab:Slider({
    Title="🦘 Jump",Min=50,Max=300,Value=100,
    Callback=function(v)
        Settings.قوة_القفز=v
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower=v
        end
    end
})

Tab:Slider({Title="🕊️ Fly Speed",Min=20,Max=200,Value=60,Callback=function(v) Settings.سرعة_الطيران=v end})
Tab:Slider({Title="⚡ Aim Speed",Min=1,Max=10,Value=5,Callback=function(v) Settings.سرعة_التتبع=v/10 end})
Tab:Slider({Title="📏 FOV",Min=50,Max=400,Value=150,Callback=function(v) Settings.حجم_FOV=v end})

-- 📱 زر AIM
local AimButton=Instance.new("TextButton",game.CoreGui)
AimButton.Size=UDim2.new(0,100,0,50)
AimButton.Position=UDim2.new(1,-120,1,-100)
AimButton.Text="🎯 AIM OFF"

AimButton.MouseButton1Click:Connect(function()
    Settings.تتبع=not Settings.تتبع
    AimButton.Text=Settings.تتبع and "🎯 AIM ON" or "🎯 AIM OFF"
end)

-- 📱 زر ESP
local ESPButton=Instance.new("TextButton",game.CoreGui)
ESPButton.Size=UDim2.new(0,100,0,50)
ESPButton.Position=UDim2.new(1,-120,1,-160)
ESPButton.Text="👁️ ESP OFF"

ESPButton.MouseButton1Click:Connect(function()
    Settings.اظهار=not Settings.اظهار
    ESPButton.Text=Settings.اظهار and "👁️ ESP ON" or "👁️ ESP OFF"
end)

-- FOV
local circle=Drawing.new("Circle")
circle.Thickness=2
circle.Filled=false

-- ESP
local ESP={}
local function AddESP(p)
    if p==LocalPlayer then return end
    local bill=Instance.new("BillboardGui")
    bill.Size=UDim2.new(4,0,2,0)
    bill.AlwaysOnTop=true
    local txt=Instance.new("TextLabel",bill)
    txt.Size=UDim2.new(1,0,1,0)
    txt.BackgroundTransparency=1
    txt.TextScaled=true
    ESP[p]={bill,txt}
end

for _,v in pairs(Players:GetPlayers()) do AddESP(v) end
Players.PlayerAdded:Connect(AddESP)

-- Fly
local bv,bg

-- LOOP
RunService.RenderStepped:Connect(function()

    task.wait(Safe.Delay)
    Clamp()

    circle.Visible=Settings.FOV
    circle.Radius=Settings.حجم_FOV
    circle.Position=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)

    -- ESP
    for p,data in pairs(ESP) do
        if Settings.اظهار and p.Character and Enemy(p) then
            local head=p.Character:FindFirstChild("Head")
            local hum=p.Character:FindFirstChild("Humanoid")
            if head and hum and hum.Health>0 then
                data[1].Adornee=head
                data[1].Parent=head
                data[2].Text=p.Name.." ❤️"..math.floor(hum.Health)
                data[1].Enabled=true
            else
                data[1].Enabled=false
            end
        else
            data[1].Enabled=false
        end
    end

    -- AIM (مصلح 💀)
    if Settings.تتبع then
        local closest,dist=nil,math.huge

        for _,v in pairs(Players:GetPlayers()) do
            if v~=LocalPlayer and v.Character and Enemy(v) then
                local hum=v.Character:FindFirstChild("Humanoid")
                local head=v.Character:FindFirstChild("Head")

                if hum and hum.Health>0 and head then
                    local pos,vis=Camera:WorldToViewportPoint(head.Position)

                    if vis then
                        local mag=(Vector2.new(pos.X,pos.Y)-Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude
                        if mag<Settings.حجم_FOV and mag<dist then
                            dist=mag
                            closest=v
                        end
                    end
                end
            end
        end

        if closest and closest.Character then
            local head=closest.Character:FindFirstChild("Head")
            local hum=closest.Character:FindFirstChild("Humanoid")

            if head and hum and hum.Health>0 then
                Camera.CFrame=Camera.CFrame:Lerp(
                    CFrame.new(Camera.CFrame.Position,head.Position),
                    math.clamp(Settings.سرعة_التتبع,0.05,0.5)
                )
            end
        end
    end

    -- Fly
    if Settings.طيران and LocalPlayer.Character then
        local hrp=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            if not bv then
                bv=Instance.new("BodyVelocity",hrp)
                bv.MaxForce=Vector3.new(1e5,1e5,1e5)
                bg=Instance.new("BodyGyro",hrp)
                bg.MaxTorque=Vector3.new(1e5,1e5,1e5)
            end
            bv.Velocity=Camera.CFrame.LookVector*Settings.سرعة_الطيران
            bg.CFrame=Camera.CFrame
        end
    else
        if bv then bv:Destroy() bv=nil end
        if bg then bg:Destroy() bg=nil end
    end

end)
