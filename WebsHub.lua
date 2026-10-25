-- ============================================
-- WEBSHUB UI LIBRARY v1.1
-- ============================================

local WebsHub = {}
WebsHub.__index = WebsHub
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local COLORS = {
    Background = Color3.fromRGB(20, 20, 25), Sidebar = Color3.fromRGB(15, 15, 20),
    Tab = Color3.fromRGB(30, 30, 38), TabActive = Color3.fromRGB(60, 60, 80),
    Section = Color3.fromRGB(25, 25, 32), Element = Color3.fromRGB(35, 35, 45),
    ElementHover = Color3.fromRGB(45, 45, 55), Accent = Color3.fromRGB(100, 100, 200),
    AccentActive = Color3.fromRGB(140, 140, 255), Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(150, 150, 160), ToggleOn = Color3.fromRGB(80, 200, 120),
    ToggleOff = Color3.fromRGB(60, 60, 70), Slider = Color3.fromRGB(100, 100, 200),
    Stroke = Color3.fromRGB(50, 50, 60),
}

local NotificationsGui = Instance.new("ScreenGui")
NotificationsGui.Name = "WebsHub_Notifications"
NotificationsGui.Parent = CoreGui
NotificationsGui.ResetOnSpawn = false
local notificationY = 20

function WebsHub:Notify(title, content, duration)
    duration = duration or 3
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 60)
    frame.Position = UDim2.new(1, -320, 0, notificationY)
    frame.BackgroundColor3 = COLORS.Background
    frame.BorderSizePixel = 0
    frame.Parent = NotificationsGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = COLORS.Accent stroke.Thickness = 1.5 stroke.Parent = frame
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 22) titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1 titleLabel.Text = title titleLabel.TextColor3 = COLORS.Accent
    titleLabel.TextSize = 15 titleLabel.Font = Enum.Font.GothamBold titleLabel.TextXAlignment = Enum.TextXAlignment.Left titleLabel.Parent = frame
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, -20, 0, 30) contentLabel.Position = UDim2.new(0, 10, 0, 25)
    contentLabel.BackgroundTransparency = 1 contentLabel.Text = content contentLabel.TextColor3 = COLORS.Text
    contentLabel.TextSize = 13 contentLabel.Font = Enum.Font.Gotham contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextWrapped = true contentLabel.Parent = frame
    notificationY = notificationY + 70
    frame.Position = UDim2.new(1, 50, 0, frame.Position.Y.Offset)
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back), { Position = UDim2.new(1, -320, 0, frame.Position.Y.Offset) }):Play()
    task.delay(duration, function()
        TweenService:Create(frame, TweenInfo.new(0.3), { Position = UDim2.new(1, 50, 0, frame.Position.Y.Offset), BackgroundTransparency = 1 }):Play()
        task.wait(0.3) frame:Destroy() notificationY = notificationY - 70
    end)
end

function WebsHub:CreateWindow(config)
    local self = setmetatable({}, WebsHub)
    self.Tabs = {} self.ActiveTab = nil
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "WebsHub_" .. (config.Name or "UI")
    self.ScreenGui.Parent = CoreGui self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.DisplayOrder = 999

    self.Main = Instance.new("Frame")
    self.Main.Size = UDim2.new(0, 500, 0, 350) self.Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    self.Main.BackgroundColor3 = COLORS.Background self.Main.BorderSizePixel = 0
    self.Main.Active = true self.Main.Draggable = true self.Main.Parent = self.ScreenGui
    Instance.new("UICorner", self.Main).CornerRadius = UDim.new(0, 12)
    local mainStroke = Instance.new("UIStroke", self.Main)
    mainStroke.Color = COLORS.Stroke mainStroke.Thickness = 1.5 mainStroke.Parent = self.Main

    self.TopBar = Instance.new("Frame")
    self.TopBar.Size = UDim2.new(1, 0, 0, 40) self.TopBar.BackgroundColor3 = COLORS.Sidebar
    self.TopBar.BorderSizePixel = 0 self.TopBar.Parent = self.Main
    Instance.new("UICorner", self.TopBar).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -100, 1, 0) title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1 title.Text = config.Name or "WebsHub" title.TextColor3 = COLORS.Text
    title.TextSize = 18 title.Font = Enum.Font.GothamBold title.TextXAlignment = Enum.TextXAlignment.Left title.Parent = self.TopBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 25, 0, 25) closeBtn.Position = UDim2.new(1, -30, 0, 7)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60) closeBtn.Text = "×"
    closeBtn.TextColor3 = COLORS.Text closeBtn.TextSize = 18 closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0 closeBtn.Parent = self.TopBar
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    closeBtn.MouseButton1Click:Connect(function() self.ScreenGui:Destroy() end)

    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Size = UDim2.new(0, 120, 1, -45) self.Sidebar.Position = UDim2.new(0, 5, 0, 45)
    self.Sidebar.BackgroundColor3 = COLORS.Sidebar self.Sidebar.BorderSizePixel = 0 self.Sidebar.Parent = self.Main
    Instance.new("UICorner", self.Sidebar).CornerRadius = UDim.new(0, 10)
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 4) sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder sidebarLayout.Parent = self.Sidebar
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 6) sidebarPadding.PaddingLeft = UDim.new(0, 4) sidebarPadding.PaddingRight = UDim.new(0, 4) sidebarPadding.Parent = self.Sidebar

    self.Content = Instance.new("Frame")
    self.Content.Size = UDim2.new(1, -135, 1, -45) self.Content.Position = UDim2.new(0, 130, 0, 45)
    self.Content.BackgroundTransparency = 1 self.Content.BorderSizePixel = 0 self.Content.Parent = self.Main
    return self
end

function WebsHub:CreateTab(name)
    local tab = {} tab.Name = name tab.Parent = self
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, 0, 1, 0) container.BackgroundTransparency = 1
    container.BorderSizePixel = 0 container.ScrollBarThickness = 3 container.ScrollBarImageColor3 = COLORS.Accent
    container.CanvasSize = UDim2.new(0, 0, 0, 0) container.Visible = false container.Parent = self.Content
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4) layout.SortOrder = Enum.SortOrder.LayoutOrder layout.Parent = container
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 4) padding.PaddingLeft = UDim.new(0, 6) padding.PaddingRight = UDim.new(0, 6) padding.Parent = container
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8) end)
    tab.Container = container
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 30) tabBtn.BackgroundColor3 = COLORS.Tab
    tabBtn.Text = "  " .. name tabBtn.TextColor3 = COLORS.TextDim tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.GothamBold tabBtn.TextXAlignment = Enum.TextXAlignment.Left tabBtn.BorderSizePixel = 0 tabBtn.Parent = self.Sidebar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    tab.Button = tabBtn
    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            TweenService:Create(t.Button, TweenInfo.new(0.2), { BackgroundColor3 = COLORS.Tab }):Play()
            t.Button.TextColor3 = COLORS.TextDim t.Container.Visible = false
        end
        TweenService:Create(tabBtn, TweenInfo.new(0.2), { BackgroundColor3 = COLORS.TabActive }):Play()
        tabBtn.TextColor3 = COLORS.Text container.Visible = true self.ActiveTab = tab
    end)
    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then tabBtn.BackgroundColor3 = COLORS.TabActive tabBtn.TextColor3 = COLORS.Text container.Visible = true self.ActiveTab = tab end
    return tab
end

function WebsHub:CreateSection(tab, name)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, -12, 0, 20) section.BackgroundTransparency = 1
    section.Text = "  " .. name section.TextColor3 = COLORS.Accent
    section.TextSize = 12 section.Font = Enum.Font.GothamBold section.TextXAlignment = Enum.TextXAlignment.Left section.Parent = tab.Container
    return section
end

function WebsHub:CreateButton(tab, config)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 30) btn.BackgroundColor3 = COLORS.Element
    btn.Text = config.Name btn.TextColor3 = COLORS.Text btn.TextSize = 12
    btn.Font = Enum.Font.Gotham btn.BorderSizePixel = 0 btn.Parent = tab.Container
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = COLORS.ElementHover }):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = COLORS.Element }):Play() end)
    btn.MouseButton1Click:Connect(function() if config.Callback then pcall(config.Callback) end end)
    return btn
end

function WebsHub:CreateToggle(tab, config)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 30) frame.BackgroundColor3 = COLORS.Element
    frame.BorderSizePixel = 0 frame.Parent = tab.Container
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0) label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1 label.Text = config.Name label.TextColor3 = COLORS.Text
    label.TextSize = 12 label.Font = Enum.Font.Gotham label.TextXAlignment = Enum.TextXAlignment.Left label.Parent = frame
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 36, 0, 18) toggle.Position = UDim2.new(1, -44, 0.5, -9)
    toggle.BackgroundColor3 = config.CurrentValue and COLORS.ToggleOn or COLORS.ToggleOff
    toggle.BorderSizePixel = 0 toggle.Parent = frame
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14) knob.Position = config.CurrentValue and UDim2.new(1, -16, 0, 2) or UDim2.new(0, 2, 0, 2)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255) knob.BorderSizePixel = 0 knob.Parent = toggle
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local state = config.CurrentValue or false
    local function updateToggle()
        TweenService:Create(toggle, TweenInfo.new(0.2), { BackgroundColor3 = state and COLORS.ToggleOn or COLORS.ToggleOff }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), { Position = state and UDim2.new(1, -16, 0, 2) or UDim2.new(0, 2, 0, 2) }):Play()
    end
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0) btn.BackgroundTransparency = 1 btn.Text = "" btn.Parent = frame
    btn.MouseButton1Click:Connect(function()
        state = not state updateToggle() if config.Callback then pcall(config.Callback, state) end
    end)
    return frame
end

function WebsHub:CreateSlider(tab, config)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 45) frame.BackgroundColor3 = COLORS.Element
    frame.BorderSizePixel = 0 frame.Parent = tab.Container
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, 18) label.Position = UDim2.new(0, 8, 0, 4)
    label.BackgroundTransparency = 1 label.Text = config.Name label.TextColor3 = COLORS.Text
    label.TextSize = 12 label.Font = Enum.Font.Gotham label.TextXAlignment = Enum.TextXAlignment.Left label.Parent = frame
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 18) valueLabel.Position = UDim2.new(1, -60, 0, 4)
    valueLabel.BackgroundTransparency = 1 valueLabel.Text = tostring(config.CurrentValue or config.Min or 0)
    valueLabel.TextColor3 = COLORS.Accent valueLabel.TextSize = 12 valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right valueLabel.Parent = frame
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -16, 0, 5) sliderBg.Position = UDim2.new(0, 8, 0, 28)
    sliderBg.BackgroundColor3 = COLORS.ToggleOff sliderBg.BorderSizePixel = 0 sliderBg.Parent = frame
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0, 0, 1, 0) sliderFill.BackgroundColor3 = COLORS.Slider
    sliderFill.BorderSizePixel = 0 sliderFill.Parent = sliderBg
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
    local dragging = false local min = config.Min or 0 local max = config.Max or 100 local value = config.CurrentValue or min
    local function updateFromInput(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * pos) valueLabel.Text = tostring(value) sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        if config.Callback then pcall(config.Callback, value) end
    end
    local initPos = (value - min) / (max - min)
    sliderFill.Size = UDim2.new(initPos, 0, 1, 0) valueLabel.Text = tostring(value)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0) btn.BackgroundTransparency = 1 btn.Text = "" btn.Parent = frame
    btn.MouseButton1Down:Connect(function() dragging = true local mouseLoc = UserInputService:GetMouseLocation() updateFromInput({Position = mouseLoc}) end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateFromInput(input) end end)
    return frame
end

function WebsHub:CreateMinimizeButton(position)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 35, 0, 35) toggleBtn.Position = position or UDim2.new(0, 20, 0.5, -17)
    toggleBtn.BackgroundColor3 = COLORS.Accent toggleBtn.Text = "W" toggleBtn.TextColor3 = COLORS.Text
    toggleBtn.TextSize = 18 toggleBtn.Font = Enum.Font.GothamBold toggleBtn.BorderSizePixel = 0
    toggleBtn.Draggable = true toggleBtn.Parent = self.ScreenGui
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
    local stroke = Instance.new("UIStroke", toggleBtn) stroke.Color = COLORS.AccentActive stroke.Thickness = 2 stroke.Parent = toggleBtn
    toggleBtn.MouseButton1Click:Connect(function() self.Main.Visible = not self.Main.Visible toggleBtn.Text = self.Main.Visible and "W" or "▲" end)
    return toggleBtn
end

return WebsHub