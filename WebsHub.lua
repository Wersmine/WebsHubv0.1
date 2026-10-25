-- ============================================
-- WEBSHUB UNIVERSAL (Pure WebsHub) by Webs_My
-- ============================================

-- Загружаем ТВОЮ библиотеку WebsHub
local WebsHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/Wersmine/WebsHubv0.1/refs/heads/main/WebsHub.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- Создаем окно в стиле WebsHub
local Window = WebsHub:CreateWindow({
    Name = "Webs_My Universal",
    Subtitle = "by Webs_My"
})

-- Вкладки (сайдбар)
local MainTab = Window:CreateTab("Главная")
local MoveTab = Window:CreateTab("Движение")
local EspTab = Window:CreateTab("ESP")
local AimTab = Window:CreateTab("Аимбот")
local TpTab = Window:CreateTab("Телепорт")

-- ============================================
-- HUD (Координаты и FPS)
-- ============================================
local HudGui = Instance.new("ScreenGui", game.CoreGui)
HudGui.Name = "WebsHUD" HudGui.ResetOnSpawn = false
local HudFrame = Instance.new("Frame", HudGui)
HudFrame.Size = UDim2.new(0, 250, 0, 50) HudFrame.Position = UDim2.new(0, 10, 0, 40)
HudFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25) HudFrame.BackgroundTransparency = 0.2
Instance.new("UICorner", HudFrame).CornerRadius = UDim.new(0, 8)
local Coords = Instance.new("TextLabel", HudFrame)
Coords.Size = UDim2.new(1, 0, 0.6, 0) Coords.BackgroundTransparency = 1 Coords.TextColor3 = Color3.fromRGB(0, 255, 120) Coords.Font = Enum.Font.Code Coords.TextSize = 14 Coords.Text = "X: 0 Y: 0 Z: 0"
local Fps = Instance.new("TextLabel", HudFrame)
Fps.Size = UDim2.new(1, 0, 0.4, 0) Fps.Position = UDim2.new(0, 0, 0.6, 0) Fps.BackgroundTransparency = 1 Fps.TextColor3 = Color3.fromRGB(255, 200, 60) Fps.Font = Enum.Font.Code Fps.TextSize = 13 Fps.Text = "FPS: — Ping: —"

task.spawn(function()
    local count, time = 0, tick()
    while task.wait(0.1) do
        if not HudGui.Parent then break end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local p = char.HumanoidRootPart.Position
            Coords.Text = "X: " .. math.floor(p.X) .. " Y: " .. math.floor(p.Y) .. " Z: " .. math.floor(p.Z)
        end
        count = count + 1
        if tick() - time >= 1 then
            local ping = "—" pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            Fps.Text = "FPS: " .. count .. " Ping: " .. ping
            count, time = 0, tick()
        end
    end
end)

-- ============================================
-- ГЛАВНАЯ (Персонаж + Выход)
-- ============================================
WebsHub:CreateSection(MainTab, "Персонаж")

WebsHub:CreateSlider(MainTab, {
    Name = "Скорость",
    Min = 16, Max = 1000, CurrentValue = 16,
    Callback = function(v) 
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then 
            LocalPlayer.Character.Humanoid.WalkSpeed = v 
        end 
    end
})

WebsHub:CreateSlider(MainTab, {
    Name = "Высота прыжка",
    Min = 50, Max = 5000, CurrentValue = 50,
    Callback = function(v) 
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then 
            LocalPlayer.Character.Humanoid.JumpPower = v 
        end 
    end
})

WebsHub:CreateSection(MainTab, "Система")
WebsHub:CreateButton(MainTab, {
    Name = "🛑 Закрыть скрипт",
    Callback = function()
        HudGui:Destroy()
        Window.ScreenGui:Destroy()
    end
})

-- ============================================
-- ДВИЖЕНИЕ (Noclip, Fly)
-- ============================================
WebsHub:CreateSection(MoveTab, "Noclip")
local noclip = false
WebsHub:CreateToggle(MoveTab, {
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(s) noclip = s end
})
RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

WebsHub:CreateSection(MoveTab, "Полёт")
local fly, bv = false, nil
WebsHub:CreateToggle(MoveTab, {
    Name = "Fly",
    CurrentValue = false,
    Callback = function(s)
        fly = s
        if fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
            bv.MaxForce = Vector3.new(1e6,1e6,1e6)
        elseif not fly and bv then
            bv:Destroy() bv = nil
        end
    end
})
RunService.RenderStepped:Connect(function()
    if fly and bv and LocalPlayer.Character then
        local cam = workspace.CurrentCamera
        local move = LocalPlayer.Character.Humanoid.MoveDirection
        bv.Velocity = cam.CFrame.LookVector * move.Z * 100 + cam.CFrame.RightVector * move.X * 100
    end
end)

-- ============================================
-- ESP (Бокс)
-- ============================================
WebsHub:CreateSection(EspTab, "Настройки ESP")
local espBox, boxes = false, {}
WebsHub:CreateToggle(EspTab, {
    Name = "ESP Бокс",
    CurrentValue = false,
    Callback = function(s) espBox = s end
})
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if espBox and not boxes[p] then
                local b = Instance.new("BoxHandleAdornment", p.Character.HumanoidRootPart)
                b.Adornee = p.Character.HumanoidRootPart b.Size = Vector3.new(3,5,3) b.Color3 = Color3.new(1,0,0) boxes[p] = b
            elseif not espBox and boxes[p] then
                boxes[p]:Destroy() boxes[p] = nil
            end
        end
    end
end)

-- ============================================
-- АИМБОТ
-- ============================================
WebsHub:CreateSection(AimTab, "Аимбот")
local aim = false
WebsHub:CreateToggle(AimTab, {
    Name = "Аимбот (камера)",
    CurrentValue = false,
    Callback = function(s) aim = s end
})
RunService:BindToRenderStep("AimCam", Enum.RenderPriority.Camera.Value + 1, function()
    if not aim then return end
    local cam = workspace.CurrentCamera
    local closest, dist = nil, 300
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local sp, on = cam:WorldToViewportPoint(p.Character.Head.Position)
            if on then
                local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                if d < dist then dist = d; closest = p.Character.Head end
            end
        end
    end
    if closest then cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, closest.Position), 0.3) end
end)

-- ============================================
-- ТЕЛЕПОРТ (Сохранение точек)
-- ============================================
WebsHub:CreateSection(TpTab, "Сохранение точек")
local savedPoints = {}
for i = 1, 5 do
    WebsHub:CreateButton(TpTab, {
        Name = "Сохранить точку " .. i,
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                savedPoints[i] = LocalPlayer.Character.HumanoidRootPart.Position
                WebsHub:Notify("Сохранено", "Точка " .. i, 2)
            end
        end
    })
    WebsHub:CreateButton(TpTab, {
        Name = "Телепорт к точке " .. i,
        Callback = function()
            if savedPoints[i] and LocalPlayer.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(savedPoints[i] + Vector3.new(0,3,0))
            end
        end
    })
end

-- Кнопка минимизации (кружок "W")
Window:CreateMinimizeButton(UDim2.new(0, 20, 0.5, -17))

WebsHub:Notify("WebsHub", "Универсал загружен!", 4)