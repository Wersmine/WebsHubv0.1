-- ============================================
-- WEBSHUB ALL-IN-ONE (FINAL) by Webs_My
-- ============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local HubWindow = Rayfield:CreateWindow({
    Name = "WebsHub Launcher",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "by Webs_My",
    ConfigurationSaving = { Enabled = false }
})
local HubTab = HubWindow:CreateTab("Меню", 4483362458)

local UniversalWindow, DroneWindow, ChaosWindow, FlightWindow = nil, nil, nil, nil
local function closeAll()
    if UniversalWindow then UniversalWindow:Destroy() end
    if DroneWindow then DroneWindow:Destroy() end
    if ChaosWindow then ChaosWindow:Destroy() end
    if FlightWindow then FlightWindow:Destroy() end
    UniversalWindow, DroneWindow, ChaosWindow, FlightWindow = nil, nil, nil, nil
end

-- ============================================
-- 1. УНИВЕРСАЛ
-- ============================================
local function StartUniversal()
    UniversalWindow = Rayfield:CreateWindow({Name = "Webs_My v4", LoadingTitle = "Загрузка...", LoadingSubtitle = "by Webs_My", ConfigurationSaving = { Enabled = false }})
    
    -- HUD (Координаты и FPS)
    local HudGui = Instance.new("ScreenGui", game.CoreGui)
    HudGui.Name = "UniversalHUD" HudGui.ResetOnSpawn = false
    local HudFrame = Instance.new("Frame", HudGui)
    HudFrame.Size = UDim2.new(0, 250, 0, 50) HudFrame.Position = UDim2.new(0, 10, 0, 120)
    HudFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) HudFrame.BackgroundTransparency = 0.3
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

    local Main = UniversalWindow:CreateTab("Main", 4483362458)
    local Move = UniversalWindow:CreateTab("Movement", 4483362458)
    local Esp = UniversalWindow:CreateTab("ESP", 4483362458)
    local Aim = UniversalWindow:CreateTab("Aimbot", 4483362458)
    local Plr = UniversalWindow:CreateTab("Players", 4483362458)
    local Tp = UniversalWindow:CreateTab("Teleport", 4483362458)
    local Rage = UniversalWindow:CreateTab("Rage", 4483362458)

    -- Main
    local ws, jp = 16, 50
    Main:CreateSlider({Name="Speed",Range={16,1000},Increment=1,CurrentValue=16,Callback=function(v) ws=v; if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed=v end end})
    Main:CreateSlider({Name="Jump",Range={50,5000},Increment=5,CurrentValue=50,Callback=function(v) jp=v; if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower=v end end})

    -- Move
    local noclip = false
    Move:CreateToggle({Name="Noclip",CurrentValue=false,Callback=function(s) noclip = s end})
    RunService.Stepped:Connect(function() if noclip and LocalPlayer.Character then for _,p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end)
    
    local fly = false
    local bv
    Move:CreateToggle({Name="Fly",CurrentValue=false,Callback=function(s) 
        fly = s 
        if fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
            bv.MaxForce = Vector3.new(1e6,1e6,1e6)
        elseif not fly and bv then bv:Destroy() end
    end})
    RunService.RenderStepped:Connect(function()
        if fly and bv and LocalPlayer.Character then
            local cam = workspace.CurrentCamera
            local move = LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MoveDirection
            bv.Velocity = cam.CFrame.LookVector * move.Z * 100 + cam.CFrame.RightVector * move.X * 100
        end
    end)

    -- ESP
    local espBox = false
    local boxes = {}
    Esp:CreateToggle({Name="ESP Box",CurrentValue=false,Callback=function(s) espBox=s end})
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

    -- Aim
    local aim = false
    Aim:CreateToggle({Name="Aimbot",CurrentValue=false,Callback=function(s) aim=s end})
    RunService:BindToRenderStep("AimCam", Enum.RenderPriority.Camera.Value + 1, function()
        if not aim then return end
        local cam = workspace.CurrentCamera
        local closest = nil
        local dist = 300
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

    -- Players
    local selP = nil
    local drop = Plr:CreateDropdown({Name="Player",Options={"none"},CurrentOption={"none"},Callback=function(opt) if opt[1]~="none" then selP = Players:FindFirstChild(opt[1]) end end})
    Plr:CreateButton({Name="Update List",Callback=function() local names={"none"}; for _,p in pairs(Players:GetPlayers()) do if p~=LocalPlayer then table.insert(names,p.Name) end end; drop:Refresh(names) end})
    Plr:CreateButton({Name="Teleport to Player",Callback=function() if selP and selP.Character and LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = selP.Character.HumanoidRootPart.CFrame end end})
    Plr:CreateButton({Name="Kill Player",Callback=function() if selP and selP.Character then local h = selP.Character:FindFirstChildOfClass("Humanoid") if h then h.Health = 0 end end end})

    -- TELEPORT (Возвращаем!)
    local savedPoints = {}
    for i = 1, 5 do
        Tp:CreateButton({Name="Save Point "..i, Callback=function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                savedPoints[i] = LocalPlayer.Character.HumanoidRootPart.Position
                Rayfield:Notify({Title="Saved", Content="Point "..i, Duration=2})
            end
        end})
        Tp:CreateButton({Name="Teleport to Point "..i, Callback=function()
            if savedPoints[i] and LocalPlayer.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(savedPoints[i] + Vector3.new(0,3,0))
            end
        end})
    end

    -- Rage
    local invis = false
    Rage:CreateToggle({Name="Invisible",CurrentValue=false,Callback=function(s) invis=s end})
    RunService.Heartbeat:Connect(function() if invis and LocalPlayer.Character then for _,p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.Transparency=1 end end end end)
end

-- ============================================
-- 2. ДРОН
-- ============================================
local function StartDrone()
    DroneWindow = Rayfield:CreateWindow({Name = "FPV Drone", LoadingTitle = "Загрузка...", LoadingSubtitle = "by Webs_My", ConfigurationSaving = { Enabled = false }})
    local Main = DroneWindow:CreateTab("Дрон", 4483362458)
    local autoFarm = false
    Main:CreateToggle({Name="Автофарм",CurrentValue=false,Callback=function(s) autoFarm=s end})
    
    local function click() if mouse1click then pcall(mouse1click) end end
    RunService.Heartbeat:Connect(function()
        if not autoFarm then return end
        local drone = workspace:FindFirstChild(LocalPlayer.Name .. "_FPVDrone") if not drone then return end
        local closest, dist = nil, math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then dist = d; closest = p.Character.HumanoidRootPart end
            end
        end
        if closest then drone:PivotTo(CFrame.new(closest.Position - Vector3.new(0,2,0))) end
    end)
    task.spawn(function()
        while task.wait(5) do
            if autoFarm and LocalPlayer.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(1919, 66, -401))
                task.wait(0.5)
                workspace.CurrentCamera.CFrame = CFrame.new(Vector3.new(1919, 76, -401), Vector3.new(1919, 66, -401))
                task.wait(0.5)
                for i=1,8 do click() task.wait(0.15) end
            end
        end
    end)
end

-- ============================================
-- 3. ХАОС
-- ============================================
local function StartChaos()
    ChaosWindow = Rayfield:CreateWindow({Name = "Chaos", LoadingTitle = "Загрузка...", LoadingSubtitle = "by Webs_My", ConfigurationSaving = { Enabled = false }})
    local Main = ChaosWindow:CreateTab("Хаос", 4483362458)
    local fly = false local bv
    Main:CreateToggle({Name="Fly 200",CurrentValue=false,Callback=function(s) fly = s if fly and LocalPlayer.Character then bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart) bv.MaxForce = Vector3.new(1e6,1e6,1e6) elseif bv then bv:Destroy() end end})
    RunService.RenderStepped:Connect(function() if fly and bv and LocalPlayer.Character then local cam = workspace.CurrentCamera local move = LocalPlayer.Character.Humanoid.MoveDirection bv.Velocity = cam.CFrame.LookVector * move.Z * 200 + cam.CFrame.RightVector * move.X * 200 end end)
    Main:CreateButton({Name="Подбросить всех на 1 триллион",Callback=function() for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then p.Character:PivotTo(CFrame.new(p.Character.HumanoidRootPart.Position.X, 1000000000000, p.Character.HumanoidRootPart.Position.Z)) end end end})
end

-- ============================================
-- 4. A LONG FLIGHT
-- ============================================
local function StartFlight()
    FlightWindow = Rayfield:CreateWindow({Name = "A Long Flight", LoadingTitle = "Загрузка...", LoadingSubtitle = "by Webs_My", ConfigurationSaving = { Enabled = false }})
    local Main = FlightWindow:CreateTab("Flight", 4483362458)
    local god, trig = false, false
    Main:CreateToggle({Name="God Mode",CurrentValue=false,Callback=function(s) god=s end})
    RunService.Heartbeat:Connect(function() if god and LocalPlayer.Character then local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if h and h.Health < h.MaxHealth then h.Health = h.MaxHealth end end end)
    Main:CreateToggle({Name="Trigger Bot",CurrentValue=false,Callback=function(s) trig=s end})
    RunService.RenderStepped:Connect(function()
        if trig and LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
            if tool then
                local ray = Ray.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.LookVector * 150)
                local hit, pos = workspace:FindPartOnRay(ray, LocalPlayer.Character)
                if hit and hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid") then tool:Activate() end
            end
        end
    end)
end

-- ============================================
-- КНОПКИ ХАБА
-- ============================================
HubTab:CreateSection("Скрипты")
HubTab:CreateButton({Name="🚀 Универсал", Callback=function() closeAll() StartUniversal() end})
HubTab:CreateButton({Name="🚁 Дрон", Callback=function() closeAll() StartDrone() end})
HubTab:CreateButton({Name="💥 Хаос", Callback=function() closeAll() StartChaos() end})
HubTab:CreateButton({Name="✈️ A Long Flight", Callback=function() closeAll() StartFlight() end})

Rayfield:Notify({Title="WebsHub", Content="HUD и ТП на месте!", Duration=4})
