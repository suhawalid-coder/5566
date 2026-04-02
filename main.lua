-- إشعار البداية
print("🔥 Ahmed Hub Loaded")

pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "احمد بطل",
        Text = "انتظر إدخال الكود 🔑",
        Duration = 5
    })
end)

-- خدمات
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🔐 واجهة الكي
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,300,0,180)
Frame.Position = UDim2.new(0.5,-150,0.5,-90)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,35)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "🔐 Key System"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.TextScaled = true

local Box = Instance.new("TextBox", Frame)
Box.Size = UDim2.new(0.8,0,0,40)
Box.Position = UDim2.new(0.1,0,0.4,0)
Box.PlaceholderText = "اكتب الكود هنا..."
Box.Text = ""

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(0.8,0,0,40)
Button.Position = UDim2.new(0.1,0,0.7,0)
Button.Text = "دخول"

local GetKey = Instance.new("TextButton", Frame)
GetKey.Size = UDim2.new(0.8,0,0,25)
GetKey.Position = UDim2.new(0.1,0,0.9,0)
GetKey.Text = "🔗 نسخ رابط الكود"

-- نسخ الرابط
GetKey.MouseButton1Click:Connect(function()
    setclipboard("https://rekonise.com/key-cltk6")
end)

local KEY = "5566"

-- تحقق
Button.MouseButton1Click:Connect(function()
    if Box.Text == KEY then
        
        ScreenGui:Destroy()

        game.StarterGui:SetCore("SendNotification", {
            Title = "نجاح",
            Text = "تم الدخول ✅",
            Duration = 3
        })

        -- تحميل UI
        local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

        local Window = WindUI:CreateWindow({
            Title = "🔥 احمد بطل",
            Icon = "target",
            Author = "Ahmed"
        })

        local Tab = Window:Tab({
            Title = "Main",
            Icon = "zap"
        })

        -- خدمات
        local RunService = game:GetService("RunService")
        local Camera = workspace.CurrentCamera

        local Aimbot = false
        local ESP = false

        -- أزرار
        Tab:Button({
            Title = "تشغيل Aimbot 🎯",
            Callback = function()
                Aimbot = true
            end
        })

        Tab:Button({
            Title = "ايقاف Aimbot ❌",
            Callback = function()
                Aimbot = false
            end
        })

        Tab:Button({
            Title = "تشغيل ESP 👁️",
            Callback = function()
                ESP = true
            end
        })

        Tab:Button({
            Title = "ايقاف ESP ❌",
            Callback = function()
                ESP = false
            end
        })

        -- 🚫 Wall Check
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

        -- 🎯 أقرب لاعب
        local function GetClosest()
            local closest, dist = nil, math.huge

            for _,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                    if (not v.Team) or (not LocalPlayer.Team) or v.Team ~= LocalPlayer.Team then
                        
                        local head = v.Character.Head
                        local mag = (head.Position - Camera.CFrame.Position).Magnitude

                        if IsVisible(head) and mag < dist then
                            dist = mag
                            closest = v
                        end
                    end
                end
            end

            return closest
        end

        -- 👁️ ESP
        local ESPTable = {}

        local function AddESP(player)
            if player == LocalPlayer then return end

            local highlight = Instance.new("Highlight")
            highlight.FillTransparency = 0.3
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
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    
                    if ESP and ((not player.Team) or (not LocalPlayer.Team) or player.Team ~= LocalPlayer.Team) then
                        
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

            -- Aimbot
            if Aimbot then
                local t = GetClosest()
                if t and t.Character and t.Character:FindFirstChild("Head") then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
                end
            end
        end)

    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "خطأ",
            Text = "الكود غلط ❌",
            Duration = 3
        })
    end
end)
