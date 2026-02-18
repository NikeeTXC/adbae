-- NikeeHUB FishIt - SpeedHub UI Version
-- Single File Version - Works with game:HttpGet()
-- GitHub: https://github.com/NikeeTXC/adbae

-- ============================================
-- SPEEDHUB UI LIBRARY (Embedded)
-- ============================================
local SpeedHubUI = {}
SpeedHubUI.Color = Color3.fromRGB(0, 139, 139)
SpeedHubUI.Themes = {
    Background = Color3.fromRGB(20, 22, 28),
    Header = Color3.fromRGB(25, 28, 35),
    Sidebar = Color3.fromRGB(18, 20, 25),
    Content = Color3.fromRGB(22, 24, 30),
    Accent = Color3.fromRGB(0, 139, 139),
    TextPrimary = Color3.fromRGB(240, 240, 240),
    TextSecondary = Color3.fromRGB(160, 165, 175),
    Border = Color3.fromRGB(45, 50, 60),
    Input = Color3.fromRGB(15, 16, 20),
    Success = Color3.fromRGB(75, 185, 115),
    Error = Color3.fromRGB(235, 85, 85)
}

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")

local function MakeDraggable(topbarobject, object)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    local function update(input)
        local delta = input.Position - dragStart
        TweenService:Create(object, TweenInfo.new(0.2), {
            Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        }):Play()
    end
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

local function CircleClick(button, x, y)
    spawn(function()
        button.ClipsDescendants = true
        local circle = Instance.new("ImageLabel")
        circle.Image = "rbxassetid://266543268"
        circle.ImageColor3 = Color3.fromRGB(80, 80, 80)
        circle.ImageTransparency = 0.9
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        circle.BackgroundTransparency = 1
        circle.ZIndex = 10
        circle.Name = "Circle"
        circle.Parent = button
        local newX = x - circle.AbsolutePosition.X
        local newY = y - circle.AbsolutePosition.Y
        circle.Position = UDim2.new(0, newX, 0, newY)
        local size = button.AbsoluteSize.X > button.AbsoluteSize.Y and button.AbsoluteSize.X * 1.5 or button.AbsoluteSize.Y * 1.5
        circle:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), "Out", "Quad", 0.5, false, nil)
        for i = 1, 10 do
            circle.ImageTransparency = circle.ImageTransparency + 0.01
            wait(0.05)
        end
        circle:Destroy()
    end)
end

function SpeedHubUI:AddStroke(instance, color, thickness)
    local s = Instance.new("UIStroke", instance)
    s.Color = color or self.Themes.Border
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

function SpeedHubUI:ShowNotification(msg, isError)
    local NotifFrame = Instance.new("Frame")
    NotifFrame.BackgroundColor3 = self.Themes.Background
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Position = UDim2.new(0.5, -110, 0.1, 0)
    NotifFrame.Size = UDim2.new(0, 220, 0, 40)
    NotifFrame.ZIndex = 200
    NotifFrame.Parent = CoreGui
    local NotifCorner = Instance.new("UICorner", NotifFrame)
    NotifCorner.CornerRadius = UDim.new(0, 8)
    self:AddStroke(NotifFrame, isError and self.Themes.Error or self.Themes.Accent, 1.5)
    local Icon = Instance.new("Frame", NotifFrame)
    Icon.BackgroundColor3 = isError and self.Themes.Error or self.Themes.Accent
    Icon.Size = UDim2.new(0, 4, 1, -10)
    Icon.Position = UDim2.new(0, 8, 0.5, -((40-10)/2))
    local IconCorner = Instance.new("UICorner", Icon)
    IconCorner.CornerRadius = UDim.new(1, 0)
    local Label = Instance.new("TextLabel", NotifFrame)
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 20, 0, 0)
    Label.Size = UDim2.new(1, -25, 1, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = msg
    Label.TextColor3 = self.Themes.TextPrimary
    Label.TextSize = 13
    Label.ZIndex = 201
    NotifFrame.BackgroundTransparency = 1
    Label.TextTransparency = 1
    Icon.BackgroundTransparency = 1
    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(Label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(Icon, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -110, 0.15, 0)}):Play()
    task.delay(2.5, function()
        if NotifFrame then
            TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1, Position = UDim2.new(0.5, -110, 0.1, 0)}):Play()
            TweenService:Create(Label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(Icon, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.wait(0.3)
            NotifFrame:Destroy()
        end
    end)
end

function SpeedHubUI:CreateWindow(config)
    config = config or {}
    local title = config.Title or "SpeedHub"
    local footer = config.Footer or ""
    local color = config.Color or self.Color
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Name = "SpeedHubUI_" .. tostring(math.random(1000, 9999))
    ScreenGui.Parent = CoreGui
    
    local DropShadowHolder = Instance.new("Frame", ScreenGui)
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.BorderSizePixel = 0
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadowHolder.Size = UDim2.new(0, 640, 0, 400)
    
    local DropShadow = Instance.new("ImageLabel", DropShadowHolder)
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.fromRGB(15, 15, 15)
    DropShadow.ImageTransparency = 1
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 47, 1, 47)
    
    local Main = Instance.new("Frame", DropShadow)
    Main.BackgroundColor3 = self.Themes.Background
    Main.BackgroundTransparency = 0.1
    Main.BorderSizePixel = 0
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(1, -47, 1, -47)
    local MainCorner = Instance.new("UICorner", Main)
    MainCorner.CornerRadius = UDim.new(0, 8)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = color
    MainStroke.Thickness = 1.5
    
    local Top = Instance.new("Frame", Main)
    Top.BackgroundColor3 = self.Themes.Header
    Top.BackgroundTransparency = 0
    Top.BorderSizePixel = 0
    Top.Size = UDim2.new(1, 0, 0, 38)
    local TopCorner = Instance.new("UICorner", Top)
    TopCorner.CornerRadius = UDim.new(0, 8)
    
    local TitleLabel = Instance.new("TextLabel", Top)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = color
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.BackgroundTransparency = 0.999
    TitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TitleLabel.BorderSizePixel = 0
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    
    local FooterLabel = Instance.new("TextLabel", Top)
    FooterLabel.Font = Enum.Font.GothamBold
    FooterLabel.Text = footer
    FooterLabel.TextColor3 = color
    FooterLabel.TextSize = 14
    FooterLabel.TextXAlignment = Enum.TextXAlignment.Left
    FooterLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    FooterLabel.BackgroundTransparency = 0.999
    FooterLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    FooterLabel.BorderSizePixel = 0
    FooterLabel.Size = UDim2.new(1, -(TitleLabel.TextBounds.X + 104), 1, 0)
    FooterLabel.Position = UDim2.new(0, TitleLabel.TextBounds.X + 15, 0, 0)
    
    local Close = Instance.new("TextButton", Top)
    Close.Font = Enum.Font.SourceSans
    Close.Text = ""
    Close.TextColor3 = Color3.fromRGB(0, 0, 0)
    Close.TextSize = 14
    Close.AnchorPoint = Vector2.new(1, 0.5)
    Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Close.BackgroundTransparency = 0.999
    Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Close.BorderSizePixel = 0
    Close.Position = UDim2.new(1, -8, 0.5, 0)
    Close.Size = UDim2.new(0, 25, 0, 25)
    local CloseImg = Instance.new("ImageLabel", Close)
    CloseImg.Image = "rbxassetid://9886659671"
    CloseImg.AnchorPoint = Vector2.new(0.5, 0.5)
    CloseImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseImg.BackgroundTransparency = 0.999
    CloseImg.Position = UDim2.new(0.49, 0, 0.5, 0)
    CloseImg.Size = UDim2.new(1, -8, 1, -8)
    
    local Min = Instance.new("TextButton", Top)
    Min.Font = Enum.Font.SourceSans
    Min.Text = ""
    Min.TextColor3 = Color3.fromRGB(0, 0, 0)
    Min.TextSize = 14
    Min.AnchorPoint = Vector2.new(1, 0.5)
    Min.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Min.BackgroundTransparency = 0.999
    Min.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Min.BorderSizePixel = 0
    Min.Position = UDim2.new(1, -38, 0.5, 0)
    Min.Size = UDim2.new(0, 25, 0, 25)
    local MinImg = Instance.new("ImageLabel", Min)
    MinImg.Image = "rbxassetid://9886659276"
    MinImg.AnchorPoint = Vector2.new(0.5, 0.5)
    MinImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MinImg.BackgroundTransparency = 0.999
    MinImg.ImageTransparency = 0.2
    MinImg.Position = UDim2.new(0.5, 0, 0.5, 0)
    MinImg.Size = UDim2.new(1, -9, 1, -9)
    
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.BackgroundColor3 = self.Themes.Sidebar
    Sidebar.Position = UDim2.new(0, 0, 0, 38)
    Sidebar.Size = UDim2.new(0, 120, 1, -38)
    Sidebar.BorderSizePixel = 0
    local SidebarCorner = Instance.new("UICorner", Sidebar)
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    
    local MenuContainer = Instance.new("Frame", Sidebar)
    MenuContainer.BackgroundTransparency = 1
    MenuContainer.Size = UDim2.new(1, 0, 1, -10)
    MenuContainer.Position = UDim2.new(0, 0, 0, 5)
    local MenuLayout = Instance.new("UIListLayout", MenuContainer)
    MenuLayout.Padding = UDim.new(0, 2)
    MenuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", MenuContainer).PaddingTop = UDim.new(0, 8)
    
    local ContentContainer = Instance.new("Frame", Main)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 125, 0, 43)
    ContentContainer.Size = UDim2.new(1, -130, 1, -48)
    
    local Pages = {}
    local TabButtons = {}
    local CurrentPage = nil
    
    local function AddPage(name)
        local Page = Instance.new("ScrollingFrame", ContentContainer)
        Page.Name = "Page_" .. name
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = color
        Page.Visible = false
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 6)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        table.insert(Pages, Page)
        return Page
    end
    
    local function AddTab(name, target, isDefault)
        local TabBtn = Instance.new("TextButton", MenuContainer)
        TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, -10, 0, 26)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.Text = name
        TabBtn.TextColor3 = self.Themes.TextSecondary
        TabBtn.TextSize = 11
        local TabCorner = Instance.new("UICorner", TabBtn)
        TabCorner.CornerRadius = UDim.new(0, 4)
        
        local Indicator = Instance.new("Frame", TabBtn)
        Indicator.Name = "ActiveIndicator"
        Indicator.BackgroundColor3 = color
        Indicator.BorderSizePixel = 0
        Indicator.Position = UDim2.new(0, 2, 0.5, -8)
        Indicator.Size = UDim2.new(0, 3, 0, 16)
        Indicator.Visible = false
        local IndicatorCorner = Instance.new("UICorner", Indicator)
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, page in pairs(ContentContainer:GetChildren()) do
                if page:IsA("ScrollingFrame") or page:IsA("Frame") then
                    page.Visible = false
                end
            end
            target.Visible = true
            for _, child in pairs(MenuContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child.TextColor3 = self.Themes.TextSecondary
                    child.Font = Enum.Font.GothamMedium
                    child.BackgroundTransparency = 1
                    local line = child:FindFirstChild("ActiveIndicator")
                    if line then line.Visible = false end
                end
            end
            TabBtn.TextColor3 = self.Themes.TextPrimary
            TabBtn.Font = Enum.Font.GothamBold
            TabBtn.BackgroundTransparency = 0.95
            TabBtn.BackgroundColor3 = self.Themes.TextPrimary
            Indicator.Visible = true
        end)
        
        if isDefault then
            TabBtn.TextColor3 = self.Themes.TextPrimary
            TabBtn.Font = Enum.Font.GothamBold
            TabBtn.BackgroundTransparency = 0.95
            TabBtn.BackgroundColor3 = self.Themes.TextPrimary
            Indicator.Visible = true
            target.Visible = true
            CurrentPage = target
        end
        
        table.insert(TabButtons, TabBtn)
        return TabBtn
    end
    
    local function CreateToggle(parent, text, settingKey, callback, validationFunc)
        local Frame = Instance.new("Frame", parent)
        Frame.BackgroundColor3 = self.Themes.Content
        Frame.BackgroundTransparency = 0
        Frame.Size = UDim2.new(1, -5, 0, 36)
        Frame.BorderSizePixel = 0
        local FrameCorner = Instance.new("UICorner", Frame)
        FrameCorner.CornerRadius = UDim.new(0, 6)
        self:AddStroke(Frame, self.Themes.Border, 1)
        
        local Label = Instance.new("TextLabel", Frame)
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.Size = UDim2.new(0, 180, 1, 0)
        Label.Font = Enum.Font.GothamBold
        Label.Text = text
        Label.TextColor3 = self.Themes.TextPrimary
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        
        local default = false
        local Switch = Instance.new("TextButton", Frame)
        Switch.BackgroundColor3 = default and self.Themes.Success or self.Themes.Input
        Switch.BackgroundTransparency = 0
        Switch.Position = UDim2.new(1, -45, 0.5, -10)
        Switch.Size = UDim2.new(0, 36, 0, 20)
        Switch.Text = ""
        local SwitchCorner = Instance.new("UICorner", Switch)
        SwitchCorner.CornerRadius = UDim.new(1, 0)
        
        local Circle = Instance.new("Frame", Switch)
        Circle.BackgroundColor3 = Color3.new(1, 1, 1)
        Circle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        Circle.Size = UDim2.new(0, 16, 0, 16)
        local CircleCorner = Instance.new("UICorner", Circle)
        CircleCorner.CornerRadius = UDim.new(1, 0)
        
        local function UpdateUI(state)
            local targetColor = state and self.Themes.Success or self.Themes.Input
            local targetPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            Circle:TweenPosition(targetPos, "Out", "Sine", 0.15, true)
        end
        
        Switch.MouseButton1Click:Connect(function()
            CircleClick(Switch, Mouse.X, Mouse.Y)
            local n = not (Switch.BackgroundColor3 == self.Themes.Success)
            if n and validationFunc and not validationFunc() then return end
            UpdateUI(n)
            if callback then callback(n) end
        end)
        
        return {Set = function(v) UpdateUI(v) end}
    end
    
    local function CreateButton(parent, labelText, btnText, btnColor, callback)
        local Frame = Instance.new("Frame", parent)
        Frame.BackgroundColor3 = self.Themes.Content
        Frame.BackgroundTransparency = 0
        Frame.Size = UDim2.new(1, -5, 0, 36)
        Frame.BorderSizePixel = 0
        local FrameCorner = Instance.new("UICorner", Frame)
        FrameCorner.CornerRadius = UDim.new(0, 6)
        self:AddStroke(Frame, self.Themes.Border, 1)
        
        local Label = Instance.new("TextLabel", Frame)
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.Size = UDim2.new(0, 180, 1, 0)
        Label.Font = Enum.Font.GothamBold
        Label.Text = labelText
        Label.TextColor3 = self.Themes.TextPrimary
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        
        local Btn = Instance.new("TextButton", Frame)
        Btn.BackgroundColor3 = btnColor or color
        Btn.BackgroundTransparency = 0.1
        Btn.Position = UDim2.new(1, -80, 0.5, -11)
        Btn.Size = UDim2.new(0, 70, 0, 22)
        Btn.Font = Enum.Font.GothamBold
        Btn.Text = btnText
        Btn.TextColor3 = Color3.new(1, 1, 1)
        Btn.TextSize = 11
        local BtnCorner = Instance.new("UICorner", Btn)
        BtnCorner.CornerRadius = UDim.new(0, 4)
        
        Btn.MouseButton1Click:Connect(function()
            CircleClick(Btn, Mouse.X, Mouse.Y)
            if callback then callback() end
        end)
    end
    
    local function CreateInput(parent, placeholder, default, callback, height)
        local Frame = Instance.new("Frame", parent)
        Frame.BackgroundColor3 = self.Themes.Content
        local finalHeight = height and (height - 2) or 32
        Frame.Size = UDim2.new(1, -5, 0, finalHeight)
        Frame.BorderSizePixel = 0
        local FrameCorner = Instance.new("UICorner", Frame)
        FrameCorner.CornerRadius = UDim.new(0, 6)
        self:AddStroke(Frame, self.Themes.Border, 1)
        
        local Label = Instance.new("TextLabel", Frame)
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.Size = UDim2.new(0, 140, 1, 0)
        Label.Font = Enum.Font.GothamBold
        Label.Text = placeholder
        Label.TextColor3 = self.Themes.TextSecondary
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        
        local inputX = (finalHeight > 34) and 160 or 150
        local inputWidth = (finalHeight > 34) and 170 or 160
        
        local InputBg = Instance.new("Frame", Frame)
        InputBg.BackgroundColor3 = self.Themes.Input
        InputBg.Position = UDim2.new(0, inputX, 0.5, -10)
        InputBg.Size = UDim2.new(1, -inputWidth, 0, 20)
        InputBg.ClipsDescendants = true
        local InputCorner = Instance.new("UICorner", InputBg)
        InputCorner.CornerRadius = UDim.new(0, 4)
        self:AddStroke(InputBg, self.Themes.Border, 1)
        
        local Input = Instance.new("TextBox", InputBg)
        Input.BackgroundTransparency = 1
        Input.Position = UDim2.new(0, 5, 0, 0)
        Input.Size = UDim2.new(1, -10, 1, 0)
        Input.Font = Enum.Font.GothamMedium
        Input.Text = default
        Input.PlaceholderText = "Paste here..."
        Input.TextColor3 = self.Themes.TextPrimary
        Input.TextSize = 11
        Input.TextXAlignment = Enum.TextXAlignment.Left
        Input.ClearTextOnFocus = false
        
        Input.Focused:Connect(function()
            self:AddStroke(InputBg, color, 1)
        end)
        Input.FocusLost:Connect(function()
            self:AddStroke(InputBg, self.Themes.Border, 1)
            callback(Input.Text, Input)
        end)
        
        return Input
    end
    
    local function CreateDropdown(parent, labelText, options, default, callback)
        local Frame = Instance.new("Frame", parent)
        Frame.BackgroundColor3 = self.Themes.Content
        Frame.Size = UDim2.new(1, -5, 0, 36)
        Frame.BorderSizePixel = 0
        local FrameCorner = Instance.new("UICorner", Frame)
        FrameCorner.CornerRadius = UDim.new(0, 6)
        self:AddStroke(Frame, self.Themes.Border, 1)
        
        local Label = Instance.new("TextLabel", Frame)
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.Size = UDim2.new(0, 140, 1, 0)
        Label.Font = Enum.Font.GothamBold
        Label.Text = labelText
        Label.TextColor3 = self.Themes.TextPrimary
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        
        local currentVal = default or (options and options[1]) or "None"
        
        local DropBtn = Instance.new("TextButton", Frame)
        DropBtn.BackgroundColor3 = self.Themes.Input
        DropBtn.Position = UDim2.new(0, 160, 0.5, -10)
        DropBtn.Size = UDim2.new(1, -170, 0, 20)
        DropBtn.Font = Enum.Font.GothamMedium
        DropBtn.Text = currentVal .. " v"
        DropBtn.TextColor3 = self.Themes.TextPrimary
        DropBtn.TextSize = 11
        local DropCorner = Instance.new("UICorner", DropBtn)
        DropCorner.CornerRadius = UDim.new(0, 4)
        self:AddStroke(DropBtn, self.Themes.Border, 1)
        
        DropBtn.MouseButton1Click:Connect(function()
            CircleClick(DropBtn, Mouse.X, Mouse.Y)
            if Main:FindFirstChild("DropdownList_" .. labelText) then
                Main:FindFirstChild("DropdownList_" .. labelText):Destroy()
                return
            end
            
            local Float = Instance.new("ScrollingFrame", Main)
            Float.Name = "DropdownList_" .. labelText
            Float.BackgroundColor3 = self.Themes.Content
            Float.Size = UDim2.new(0, 200, 0, math.min(#options * 25 + 5, 200))
            Float.Position = UDim2.new(0.5, -100, 0.5, -75)
            Float.ZIndex = 200
            Float.ScrollBarThickness = 4
            local FloatCorner = Instance.new("UICorner", Float)
            FloatCorner.CornerRadius = UDim.new(0, 6)
            self:AddStroke(Float, color, 1)
            
            local ListLayout = Instance.new("UIListLayout", Float)
            ListLayout.Padding = UDim.new(0, 2)
            
            for _, opt in ipairs(options) do
                local OBtn = Instance.new("TextButton", Float)
                OBtn.Size = UDim2.new(1, 0, 0, 25)
                OBtn.BackgroundColor3 = self.Themes.Input
                OBtn.BackgroundTransparency = 0.5
                OBtn.Text = opt
                OBtn.TextColor3 = self.Themes.TextPrimary
                OBtn.Font = Enum.Font.GothamMedium
                OBtn.TextSize = 11
                
                OBtn.MouseButton1Click:Connect(function()
                    currentVal = opt
                    DropBtn.Text = currentVal .. " v"
                    callback(opt)
                    Float:Destroy()
                end)
            end
            
            local Close = Instance.new("TextButton", Float)
            Close.Size = UDim2.new(1, 0, 0, 20)
            Close.BackgroundColor3 = self.Themes.Error
            Close.Text = "CLOSE"
            Close.TextColor3 = Color3.new(1, 1, 1)
            Close.TextSize = 10
            Close.MouseButton1Click:Connect(function() Float:Destroy() end)
        end)
    end
    
    MakeDraggable(Top, DropShadowHolder)
    
    Close.MouseButton1Click:Connect(function()
        CircleClick(Close, Mouse.X, Mouse.Y)
        ScreenGui:Destroy()
    end)
    
    Min.MouseButton1Click:Connect(function()
        CircleClick(Min, Mouse.X, Mouse.Y)
        DropShadowHolder.Visible = false
    end)
    
    return {
        AddPage = AddPage,
        AddTab = AddTab,
        CreateToggle = CreateToggle,
        CreateButton = CreateButton,
        CreateInput = CreateInput,
        CreateDropdown = CreateDropdown,
        AddStroke = self.AddStroke,
        Themes = self.Themes,
        Color = color
    }
end

-- ============================================
-- NIKEEHUB FISHIT - MAIN SCRIPT
-- ============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local FishingController = require(ReplicatedStorage.Controllers.FishingController)

local ScriptActive = true
local Connections = {}
local ScreenGui

local function CleanupScript()
    ScriptActive = false
    for _, v in pairs(Connections) do
        pcall(function() v:Disconnect() end)
    end
    Connections = {}
    if TextChatService then
        TextChatService.OnIncomingMessage = nil
    end
    if ScreenGui then ScreenGui:Destroy() end
    print("❌ NikeeHUB System: Script closed and cleanup complete.")
    if getgenv then getgenv().Byu_Stop = nil end
end

if getgenv then
    getgenv().Byu_Stop = CleanupScript
end

if not isfolder("Nikee_Configs") then
    pcall(function() makefolder("Nikee_Configs") end)
end

local Theme = SpeedHubUI.Themes
local AccentColor = SpeedHubUI.Color

local Current_Webhook_Fish = ""
local Current_Webhook_Leave = ""
local Current_Webhook_List = ""
local Current_Webhook_Admin = ""
local SecretList = {
    "Crystal Crab", "Orca", "Zombie Shark", "Zombie Megalodon", "Dead Zombie Shark",
    "Blob Shark", "Ghost Shark", "Skeleton Narwhal", "Ghost Worm Fish", "Worm Fish",
    "Megalodon", "1x1x1x1 Comet Shark", "Bloodmoon Whale", "Lochness Monster",
    "Monster Shark", "Eerie Shark", "Great Whale", "Frostborn Shark", "Armored Shark",
    "Scare", "Queen Crab", "King Crab", "Cryoshade Glider", "Panther Eel",
    "Giant Squid", "Depthseeker Ray", "Robot Kraken", "Mosasaur Shark", "King Jelly",
    "Bone Whale", "Elshark Gran Maja", "Elpirate Gran Maja", "Ancient Whale", "Gladiator Shark",
    "Ancient Lochness Monster", "Talon Serpent", "Hacker Shark", "ElRetro Gran Maja",
    "Strawberry Choc Megalodon", "Krampus Shark", "Emerald Winter Whale",
    "Winter Frost Shark", "Icebreaker Whale", "Leviathan", "Pirate Megalodon", "Viridis Lurker",
    "Cursed Kraken", "Ancient Magma Whale", "Rainbow Comet Shark", "Love Nessie",
}
local StoneList = { "Ruby" }

local FishingAreas = {
    ["Leviathan Den"] = {Pos = Vector3.new(3431.640, -287.726, 3529.052), Look = Vector3.new(-0.176, 0.444, -0.879)},
    ["Crystal Depths"] = {Pos = Vector3.new(5820.647, -907.482, 15425.794), Look = Vector3.new(0.131, -0.666, 0.735)},
    ["Pirate Cove"] = {Pos = Vector3.new(3479.794, 4.192, 3451.693), Look = Vector3.new(0.578, -0.396, -0.713)},
    ["Pirate Tresure"] = {Pos = Vector3.new(3305.745, -302.160, 3028.795), Look = Vector3.new(-0.331, -0.396, -0.856)},
    ["Maze Door Room"] = {Pos = Vector3.new(3446.691, -287.845, 3402.136), Look = Vector3.new(0.324, -0.396, 0.859)},
    ["Ancient Jungle"] = {Pos = Vector3.new(1535.639, 3.159, -193.352), Look = Vector3.new(0.505, 0, 0.863)},
    ["Coral Reef"] = {Pos = Vector3.new(-3207.538, 6.087, 2011.079), Look = Vector3.new(0.973, 0, 0.229)},
    ["Crater Island"] = {Pos = Vector3.new(1058.976, 2.330, 5032.878), Look = Vector3.new(-0.789, 0, 0.615)},
    ["Ancient Ruin"] = {Pos = Vector3.new(6031.981, -585.924, 4713.157), Look = Vector3.new(0.316, 0, -0.949)},
    ["Enchant Room"] = {Pos = Vector3.new(3255.670, -1301.530, 1371.790), Look = Vector3.new(0, 0, -1)},
    ["Fisherman Island"] = {Pos = Vector3.new(74.030, 9.530, 2705.230), Look = Vector3.new(0, 0, -1)},
    ["Kohana"] = {Pos = Vector3.new(-668.732, 3, 681.580), Look = Vector3.new(0.889, 0, 0.458)},
    ["Lost Isle"] = {Pos = Vector3.new(-3804.105, 2.344, -904.653), Look = Vector3.new(-0.901, 0, 0.433)},
    ["Sacred Temple"] = {Pos = Vector3.new(1461.815, -22.125, -670.234), Look = Vector3.new(-0.990, 0, 0.143)},
    ["Second Enchant Altar"] = {Pos = Vector3.new(1479.587, 128.295, -604.224), Look = Vector3.new(-0.298, 0, -0.955)},
    ["Sisyphus Statue"] = {Pos = Vector3.new(-3743.745, -135.074, -1007.554), Look = Vector3.new(0.310, 0, 0.951)},
    ["Treasure Room"] = {Pos = Vector3.new(-3598.440, -281.274, -1645.855), Look = Vector3.new(-0.065, 0, -0.998)},
    ["Tropical Island"] = {Pos = Vector3.new(-2162.920, 2.825, 3638.445), Look = Vector3.new(0.381, 0, 0.925)},
    ["Underground Cellar"] = {Pos = Vector3.new(2118.417, -91.448, -733.800), Look = Vector3.new(0.854, 0, 0.521)},
    ["Volcano"] = {Pos = Vector3.new(-552.797, 21.174, 186.940), Look = Vector3.new(-0.251, -0.534, -0.808)},
    ["Volcanic Cavern"] = {Pos = Vector3.new(1249.005, 82.830, -10224.920), Look = Vector3.new(-0.649, -0.666, 0.368)},
}

local Settings = {
    SecretEnabled = false,
    RubyEnabled = false,
    MutationCrystalized = false,
    CaveCrystalEnabled = false,
    LeaveEnabled = false,
    PlayerNonPSAuto = false,
    ForeignDetection = false,
    SpoilerName = true,
    PingMonitor = false,
    AutoExecute = false,
    NoAnimation = false,
    RemoveVFX = false,
    DisablePopups = false,
    EvolvedEnabled = false
}

task.spawn(function()
    Players.LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    pcall(function()
        for i,v in pairs(getconnections(Players.LocalPlayer.Idled)) do
            v:Disable()
        end
    end)
    print("NikeeHUB: Anti-AFK Active")
end)

local TagList = {}
local TagUIElements = {}
local UI_FishInput, UI_LeaveInput, UI_ListInput, UI_AdminInput

local SessionStart = tick()
local SessionStats = {
    Secret = 0,
    Ruby = 0,
    Evolved = 0,
    Crystalized = 0,
    CaveCrystal = 0,
    TotalSent = 0
}
local UI_StatsLabels = {}
local ToggleRegistry = {}

local function ShowNotification(msg, isError)
    SpeedHubUI:ShowNotification(msg, isError)
end

local function UpdateTagData()
    if #TagList == 0 then
        for i = 1, 20 do TagList[i] = {"", ""} end
    end
end
UpdateTagData()

local function TeleportToLookAt(position, lookVector)
    local Character = Players.LocalPlayer.Character
    if not Character then Character = Players.LocalPlayer.CharacterAdded:Wait() end
    local hrp = Character:WaitForChild("HumanoidRootPart", 5)
    if hrp and typeof(position) == "Vector3" and typeof(lookVector) == "Vector3" then
        local targetCFrame = CFrame.new(position, position + lookVector)
        hrp.CFrame = targetCFrame * CFrame.new(0, 3, 0)
        ShowNotification("Teleported!", false)
    else
        ShowNotification("Invalid TP Data", true)
    end
end

local RPath = {"Packages", "_Index", "sleitnick_net@0.2.0", "net"}
local function GetRemote(name)
    local curr = ReplicatedStorage
    for _, child in ipairs(RPath) do
        curr = curr:WaitForChild(child, 1)
        if not curr then return nil end
    end
    return curr:FindFirstChild(name)
end

local function getFishCount()
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui", 5)
    if not playerGui then return 0 end
    local inv = playerGui:FindFirstChild("Inventory")
    if inv then
        local label = inv:FindFirstChild("Main") and inv.Main:FindFirstChild("Top") and inv.Main.Top:FindFirstChild("Options") and inv.Main.Top.Options:FindFirstChild("Fish") and inv.Main.Top.Options.Fish:FindFirstChild("Label") and inv.Main.Top.Options.Fish.Label:FindFirstChild("BagSize")
        if label then
            return tonumber((label.Text or "0/???"):match("(%d+)/")) or 0
        end
    end
    return 0
end

ScreenGui = SpeedHubUI:CreateWindow({
    Title = "NikeeHUB",
    Footer = "FishIt",
    Color = AccentColor
})

local Page_SessionStats = ScreenGui:AddPage("SessionStats")
local Page_Fhising = ScreenGui:AddPage("Fhising")
local Page_Teleport = ScreenGui:AddPage("Teleport")
local Page_Webhook = ScreenGui:AddPage("Webhook")
local Page_AdminBoost = ScreenGui:AddPage("AdminBoost")
local Page_Tag = ScreenGui:AddPage("TagDiscord")
local Page_Setting = ScreenGui:AddPage("Setting")
local Page_Save = ScreenGui:AddPage("SaveConfig")

ScreenGui.AddTab("Server Info", Page_SessionStats, true)
ScreenGui.AddTab("Fhising", Page_Fhising)
ScreenGui.AddTab("Teleport", Page_Teleport)
ScreenGui.AddTab("Notification", Page_Webhook)
ScreenGui.AddTab("Admin Boost", Page_AdminBoost)
ScreenGui.AddTab("List Player", Page_Tag)
ScreenGui.AddTab("Setting", Page_Setting)
ScreenGui.AddTab("Save Config", Page_Save)

-- Server Info Tab
local StatsHeader = Instance.new("Frame", Page_SessionStats)
StatsHeader.BackgroundTransparency = 1
StatsHeader.Size = UDim2.new(1, -5, 0, 32)
local UptimeLabel = Instance.new("TextLabel", StatsHeader)
UptimeLabel.BackgroundTransparency = 1
UptimeLabel.Size = UDim2.new(0.5, -5, 1, 0)
UptimeLabel.Font = Enum.Font.GothamBold
UptimeLabel.Text = "Uptime: 00h 00m 00s"
UptimeLabel.TextColor3 = Theme.TextPrimary
UptimeLabel.TextSize = 13
UptimeLabel.TextXAlignment = Enum.TextXAlignment.Left
UI_StatsLabels["Uptime"] = UptimeLabel

local SendStatsBtn = Instance.new("TextButton", StatsHeader)
SendStatsBtn.BackgroundColor3 = AccentColor
SendStatsBtn.Position = UDim2.new(0.5, 0, 0, 0)
SendStatsBtn.Size = UDim2.new(0.5, 0, 1, 0)
SendStatsBtn.Font = Enum.Font.GothamBold
SendStatsBtn.Text = "SEND STATS"
SendStatsBtn.TextColor3 = Color3.new(1, 1, 1)
SendStatsBtn.TextSize = 11
Instance.new("UICorner", SendStatsBtn).CornerRadius = UDim.new(0, 6)

local ServerTitle = "XALSCENT"
ScreenGui.CreateInput(Page_SessionStats, "Server Title", ServerTitle, function(v) ServerTitle = v end)

local function CreateStatItem(parent, label, key)
    local Frame = Instance.new("Frame", parent)
    Frame.BackgroundColor3 = Theme.Content
    Frame.Size = UDim2.new(1, -5, 0, 24)
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
    local Title = Instance.new("TextLabel", Frame)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 8, 0, 0)
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Font = Enum.Font.GothamMedium
    Title.Text = label
    Title.TextColor3 = Theme.TextSecondary
    Title.TextSize = 11
    Title.TextXAlignment = Enum.TextXAlignment.Left
    local Value = Instance.new("TextLabel", Frame)
    Value.BackgroundTransparency = 1
    Value.Position = UDim2.new(0.7, 0, 0, 0)
    Value.Size = UDim2.new(0.3, -8, 1, 0)
    Value.Font = Enum.Font.GothamBold
    Value.Text = "0"
    Value.TextColor3 = AccentColor
    Value.TextSize = 11
    Value.TextXAlignment = Enum.TextXAlignment.Right
    UI_StatsLabels[key] = Value
end

CreateStatItem(Page_SessionStats, "Secret Fish Caught", "Secret")
CreateStatItem(Page_SessionStats, "Ruby Gemstones", "Ruby")
CreateStatItem(Page_SessionStats, "Evolved Stones", "Evolved")
CreateStatItem(Page_SessionStats, "Crystalized Mutations", "Crystalized")
CreateStatItem(Page_SessionStats, "Cave Crystals Found", "CaveCrystal")

SendStatsBtn.MouseButton1Click:Connect(function()
    if not ScriptActive then return end
    if Current_Webhook_Admin == "" then ShowNotification("Admin Webhook Empty!", true) return end
    ShowNotification("Sending Stats...", false)
    local diff = tick() - SessionStart
    local h = math.floor(diff / 3600); local m = math.floor((diff % 3600) / 60); local s = math.floor(diff % 60)
    local timeStr = string.format("%02dh %02dm %02ds", h, m, s)
    local contentStr = "📊 SERVER: " .. ServerTitle .. "\n⏱️ Uptime: " .. timeStr .. "\n📡 Total: " .. SessionStats.TotalSent .. "\n⚓ Secrets: " .. SessionStats.Secret .. "\n💎 Rubies: " .. SessionStats.Ruby .. "\n🔮 Evolved: " .. SessionStats.Evolved .. "\n✨ Crystalized: " .. SessionStats.Crystalized .. "\n⛏️ Cave Crystals: " .. SessionStats.CaveCrystal
    task.spawn(function()
        local embed = {["username"] = "NikeeHUB Stats", ["avatar_url"] = "https://i.imgur.com/CWWGnhO.jpeg", ["embeds"] = {{["title"] = "Session Report", ["description"] = "```\n" .. contentStr .. "\n```", ["color"] = 5763719, ["footer"] = {["text"] = "NikeeHUB Webhook"}}}}
        pcall(function() httpRequest({Url = Current_Webhook_Admin, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode(embed)}) end)
    end)
end)

task.spawn(function()
    while ScriptActive do
        if UI_StatsLabels["Uptime"] then
            local diff = tick() - SessionStart
            local h = math.floor(diff / 3600); local m = math.floor((diff % 3600) / 60); local s = math.floor(diff % 60)
            UI_StatsLabels["Uptime"].Text = string.format("Uptime: %02dh %02dm %02ds", h, m, s)
        end
        task.wait(1)
    end
end)

-- Fhising Tab
local DetectorStuckEnabled = false
local StuckThreshold = 15
local LastFishCount = 0
local StuckTimer = 0
local SavedCFrame = nil

ScreenGui.CreateToggle(Page_Fhising, "Detector Stuck (15s)", false, function(state)
    DetectorStuckEnabled = state
    if state then
        LastFishCount = getFishCount()
        StuckTimer = 0
        local char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
        SavedCFrame = char:WaitForChild("HumanoidRootPart").CFrame
        task.spawn(function()
            while DetectorStuckEnabled and ScriptActive do
                task.wait(1)
                local currentFish = getFishCount()
                if currentFish == LastFishCount then
                    StuckTimer = StuckTimer + 1
                    if StuckTimer >= StuckThreshold then
                        ShowNotification("Stuck Detected! Resetting...", true)
                        local char = Players.LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then SavedCFrame = char.HumanoidRootPart.CFrame end
                        if char then char:BreakJoints() end
                        local newChar = Players.LocalPlayer.CharacterAdded:Wait()
                        local hrp = newChar:WaitForChild("HumanoidRootPart")
                        task.wait(0.5)
                        hrp.CFrame = SavedCFrame
                        StuckTimer = 0
                        LastFishCount = getFishCount()
                        local RE_Equip = GetRemote("RE/EquipToolFromHotbar")
                        if RE_Equip then pcall(function() RE_Equip:FireServer(1) end) end
                    end
                else
                    LastFishCount = currentFish
                    StuckTimer = 0
                end
            end
        end)
    end
end, nil)

local AutoShakeEnabled = false
ScreenGui.CreateToggle(Page_Fhising, "Auto Click Fishing", false, function(val)
    AutoShakeEnabled = val
    local clickEffect = Players.LocalPlayer.PlayerGui:FindFirstChild("!!! Click Effect")
    if AutoShakeEnabled then
        if clickEffect then clickEffect.Enabled = false end
        task.spawn(function()
            while AutoShakeEnabled and ScriptActive do
                pcall(function() FishingController:RequestFishingMinigameClick() end)
                task.wait(0.1)
            end
        end)
    elseif clickEffect then
        clickEffect.Enabled = true
    end
end, nil)

local AutoSellEnabled = false
local SellValue = 600
ScreenGui.CreateToggle(Page_Fhising, "Auto Sell (10m / 600 Items)", false, function(state)
    AutoSellEnabled = state
    if state then
        local RF_Sell = GetRemote("RF/SellAllItems")
        if not RF_Sell then ShowNotification("Remote Sell Missing!", true) AutoSellEnabled = false return end
        task.spawn(function()
            local LastSellTime = tick()
            while AutoSellEnabled and ScriptActive do
                if (tick() - LastSellTime) >= 600 then pcall(function() RF_Sell:InvokeServer() end) LastSellTime = tick() end
                local Replion = require(ReplicatedStorage.Packages.Replion).Client:WaitReplion("Data", 1)
                if Replion then
                    local s, d = pcall(function() return Replion:GetExpect("Inventory") end)
                    if s and d and d.Items and #d.Items >= SellValue then pcall(function() RF_Sell:InvokeServer() end) LastSellTime = tick() task.wait(1) end
                end
                task.wait(1)
            end
        end)
    end
end, nil)

local WeatherList = {"Wind", "Cloudy", "Storm"}
local SimpleWeatherEnabled = false
ScreenGui.CreateToggle(Page_Fhising, "Enable Auto Buy Weather", false, function(state)
    SimpleWeatherEnabled = state
    if state then
        local RF_BuyWeather = GetRemote("RF/PurchaseWeatherEvent")
        if not RF_BuyWeather then ShowNotification("Remote Weather Missing!", true) SimpleWeatherEnabled = false return end
        task.spawn(function()
            while SimpleWeatherEnabled and ScriptActive do
                for _, w in ipairs(WeatherList) do
                    if not SimpleWeatherEnabled then break end
                    pcall(function() RF_BuyWeather:InvokeServer(w) end)
                    task.wait(2)
                end
                task.wait(5)
            end
        end)
    end
end, nil)

local TotemList = {"Luck Totem", "Mutation Totem", "Shiny Totem"}
local SelectedTotem = "Luck Totem"
local TotemMap = {["Luck Totem"]=1, ["Mutation Totem"]=2, ["Shiny Totem"]=3}
local AutoTotemEnabled = false

ScreenGui.CreateDropdown(Page_Fhising, "Select Totem", TotemList, "Luck Totem", function(v) SelectedTotem = v end)
ScreenGui.CreateToggle(Page_Fhising, "Enable Auto Spawn Totem", false, function(state)
    AutoTotemEnabled = state
    if state then
        local RE_Spawn = GetRemote("RE/SpawnTotem")
        local RE_Equip = GetRemote("RE/EquipToolFromHotbar")
        if not RE_Spawn then ShowNotification("Remote Totem Missing!", true) AutoTotemEnabled = false return end
        task.spawn(function()
            while AutoTotemEnabled and ScriptActive do
                local Replion = require(ReplicatedStorage.Packages.Replion).Client:WaitReplion("Data", 2)
                local uuid = nil
                if Replion then
                    local s, d = pcall(function() return Replion:GetExpect("Inventory") end)
                    if s and d and d.Totems then
                        for _, i in ipairs(d.Totems) do
                            if tonumber(i.Id) == TotemMap[SelectedTotem] and (i.Count or 1) >= 1 then uuid = i.UUID break end
                        end
                    end
                end
                if uuid then
                    pcall(function() RE_Spawn:FireServer(uuid) end)
                    task.wait(1)
                    pcall(function() RE_Equip:FireServer(1) end)
                    task.wait(3600)
                else
                    ShowNotification("Totem UUID Not Found!", true)
                    task.wait(5)
                end
            end
        end)
    end
end, nil)

-- Teleport Tab
local sortedAreas = {}
for name, _ in pairs(FishingAreas) do table.insert(sortedAreas, name) end
table.sort(sortedAreas)

for i = 1, #sortedAreas, 2 do
    local name1 = sortedAreas[i]
    local name2 = sortedAreas[i+1]
    local Row = Instance.new("Frame", Page_Teleport)
    Row.BackgroundTransparency = 1
    Row.Size = UDim2.new(1, 0, 0, 35)
    local data1 = FishingAreas[name1]
    ScreenGui.CreateButton(Row, name1, "TP", AccentColor, function()
        TeleportToLookAt(data1.Pos, data1.Look)
    end)
    if name2 then
        local data2 = FishingAreas[name2]
        local Btn2 = Instance.new("TextButton", Row)
        Btn2.BackgroundColor3 = AccentColor
        Btn2.BackgroundTransparency = 0.1
        Btn2.Size = UDim2.new(0.5, -3, 1, -10)
        Btn2.Position = UDim2.new(0.5, 3, 0, 5)
        Btn2.Font = Enum.Font.GothamBold
        Btn2.Text = name2
        Btn2.TextColor3 = Color3.new(1,1,1)
        Btn2.TextSize = 11
        Instance.new("UICorner", Btn2).CornerRadius = UDim.new(0, 4)
        Btn2.MouseButton1Click:Connect(function()
            TeleportToLookAt(data2.Pos, data2.Look)
        end)
    end
end

-- Notification Tab
local View_Notif = Instance.new("Frame", Page_Webhook)
View_Notif.BackgroundTransparency = 1
View_Notif.Size = UDim2.new(1, 0, 0, 0)
View_Notif.AutomaticSize = Enum.AutomaticSize.Y
local ListLayout_Notif = Instance.new("UIListLayout", View_Notif)
ListLayout_Notif.Padding = UDim.new(0, 6)

ScreenGui.CreateToggle(View_Notif, "Secret Fish Caught", "SecretEnabled", function(v) Settings.SecretEnabled = v end, function() return Current_Webhook_Fish ~= "" end)
ScreenGui.CreateToggle(View_Notif, "Ruby Gemstone", "RubyEnabled", function(v) Settings.RubyEnabled = v end, function() return Current_Webhook_Fish ~= "" end)
ScreenGui.CreateToggle(View_Notif, "Notif Cave Crystal", "CaveCrystalEnabled", function(v) Settings.CaveCrystalEnabled = v end, function() return Current_Webhook_Fish ~= "" end)
ScreenGui.CreateToggle(View_Notif, "Evolved Enchant Stone", "EvolvedEnabled", function(v) Settings.EvolvedEnabled = v end, function() return Current_Webhook_Fish ~= "" end)
ScreenGui.CreateToggle(View_Notif, "Mutation Crystalized (Legendary)", "MutationCrystalized", function(v) Settings.MutationCrystalized = v end, function() return Current_Webhook_Fish ~= "" end)

local View_Webhook = Instance.new("Frame", Page_Webhook)
View_Webhook.BackgroundTransparency = 1
View_Webhook.Size = UDim2.new(1, 0, 0, 0)
View_Webhook.AutomaticSize = Enum.AutomaticSize.Y
View_Webhook.Visible = false
local ListLayout_Webhook = Instance.new("UIListLayout", View_Webhook)
ListLayout_Webhook.Padding = UDim.new(0, 6)

UI_FishInput = ScreenGui.CreateInput(View_Webhook, "Fish Caught", Current_Webhook_Fish, function(v) Current_Webhook_Fish = v end)
UI_LeaveInput = ScreenGui.CreateInput(View_Webhook, "Player Leave", Current_Webhook_Leave, function(v) Current_Webhook_Leave = v end)
UI_ListInput = ScreenGui.CreateInput(View_Webhook, "Player List", Current_Webhook_List, function(v) Current_Webhook_List = v end)
UI_AdminInput = ScreenGui.CreateInput(View_Webhook, "Admin Host", Current_Webhook_Admin, function(v) Current_Webhook_Admin = v end)

-- Admin Boost Tab
ScreenGui.CreateToggle(Page_AdminBoost, "Deteksi Player Asing", "ForeignDetection", function(v) Settings.ForeignDetection = v end, function() return Current_Webhook_Admin ~= "" end)
ScreenGui.CreateToggle(Page_AdminBoost, "Hide Player Name (Spoiler)", "SpoilerName", function(v) Settings.SpoilerName = v end, nil)
ScreenGui.CreateToggle(Page_AdminBoost, "Lag Detector (Ping > 500ms)", "PingMonitor", function(v) Settings.PingMonitor = v end, function() return Current_Webhook_Admin ~= "" end)
ScreenGui.CreateToggle(Page_AdminBoost, "Player Leave Server", "LeaveEnabled", function(v) Settings.LeaveEnabled = v end, function() return Current_Webhook_Leave ~= "" end)
ScreenGui.CreateToggle(Page_AdminBoost, "Player Not On Server (30 minutes)", "PlayerNonPSAuto", function(v) Settings.PlayerNonPSAuto = v end, function() return Current_Webhook_List ~= "" end)

-- List Player Tab
for i = 1, 20 do
    local rowData = TagList[i]
    local Row = Instance.new("Frame", Page_Tag)
    Row.BackgroundColor3 = Theme.Content
    Row.BackgroundTransparency = 0
    Row.Size = UDim2.new(1, -5, 0, 28)
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 5)
    local labelText = "List " .. i .. ":"
    if i == 1 then labelText = "Host 1:" end
    if i == 2 then labelText = "Host 2:" end
    local Num = Instance.new("TextLabel", Row)
    Num.BackgroundTransparency = 1
    Num.Position = UDim2.new(0, 8, 0, 0)
    Num.Size = UDim2.new(0, 50, 1, 0)
    Num.Font = Enum.Font.GothamBold
    Num.Text = labelText
    Num.TextColor3 = (i <= 2) and AccentColor or Theme.TextSecondary
    Num.TextSize = 11
    Num.TextXAlignment = Enum.TextXAlignment.Left
    local UserInput = Instance.new("TextBox", Row)
    UserInput.BackgroundTransparency = 1
    UserInput.Position = UDim2.new(0, 55, 0, 0)
    UserInput.Size = UDim2.new(0.45, -60, 1, 0)
    UserInput.Font = Enum.Font.GothamBold
    UserInput.Text = rowData[1]
    UserInput.PlaceholderText = "Username"
    UserInput.TextColor3 = Theme.TextPrimary
    UserInput.TextSize = 12
    UserInput.TextXAlignment = Enum.TextXAlignment.Left
    UserInput.ClearTextOnFocus = false
    local Sep = Instance.new("Frame", Row)
    Sep.BackgroundColor3 = Theme.Border
    Sep.BorderSizePixel = 0
    Sep.Position = UDim2.new(0.45, 5, 0.2, 0)
    Sep.Size = UDim2.new(0, 1, 0.6, 0)
    local IDInput = Instance.new("TextBox", Row)
    IDInput.BackgroundTransparency = 1
    IDInput.Position = UDim2.new(0.45, 15, 0, 0)
    IDInput.Size = UDim2.new(0.55, -15, 1, 0)
    IDInput.Font = Enum.Font.GothamBold
    IDInput.Text = rowData[2]
    IDInput.PlaceholderText = "Discord ID (Optional)"
    IDInput.TextColor3 = Theme.TextSecondary
    IDInput.TextSize = 12
    IDInput.TextXAlignment = Enum.TextXAlignment.Left
    IDInput.ClearTextOnFocus = false
    TagUIElements[i] = {User = UserInput, ID = IDInput}
    local function Sync() TagList[i] = {UserInput.Text, IDInput.Text} end
    UserInput.FocusLost:Connect(Sync)
    IDInput.FocusLost:Connect(Sync)
end

-- Setting Tab
local WalkOnWaterEnabled = false
local WaterPlatform = nil
local WalkConnection = nil

ScreenGui.CreateToggle(Page_Setting, "Walk On Water", false, function(state)
    WalkOnWaterEnabled = state
    if state then
        if not WaterPlatform then
            WaterPlatform = Instance.new("Part")
            WaterPlatform.Name = "WaterPlatform"
            WaterPlatform.Anchored = true
            WaterPlatform.CanCollide = true
            WaterPlatform.Transparency = 1
            WaterPlatform.Size = Vector3.new(15, 1, 15)
            WaterPlatform.Parent = workspace
        end
        if WalkConnection then WalkConnection:Disconnect() end
        WalkConnection = RunService.RenderStepped:Connect(function()
            if not ScriptActive or not WalkOnWaterEnabled then return end
            local char = Players.LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            if not WaterPlatform or not WaterPlatform.Parent then
                WaterPlatform = Instance.new("Part")
                WaterPlatform.Name = "WaterPlatform"
                WaterPlatform.Anchored = true
                WaterPlatform.CanCollide = true
                WaterPlatform.Transparency = 1
                WaterPlatform.Size = Vector3.new(15, 1, 15)
                WaterPlatform.Parent = workspace
            end
            local params = RaycastParams.new()
            params.FilterDescendantsInstances = {workspace.Terrain}
            params.FilterType = Enum.RaycastFilterType.Include
            params.IgnoreWater = false
            local origin = hrp.Position + Vector3.new(0, 5, 0)
            local dir = Vector3.new(0, -500, 0)
            local res = workspace:Raycast(origin, dir, params)
            if res and res.Material == Enum.Material.Water then
                local waterHeight = res.Position.Y
                WaterPlatform.Position = Vector3.new(hrp.Position.X, waterHeight, hrp.Position.Z)
                if hrp.Position.Y < (waterHeight + 2) and hrp.Position.Y > (waterHeight - 5) then
                    if not UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        hrp.CFrame = CFrame.new(hrp.Position.X, waterHeight + 3.2, hrp.Position.Z)
                    end
                end
            else
                WaterPlatform.Position = Vector3.new(hrp.Position.X, -500, hrp.Position.Z)
            end
        end)
    else
        WalkOnWaterEnabled = false
        if WalkConnection then WalkConnection:Disconnect() WalkConnection = nil end
        if WaterPlatform then WaterPlatform:Destroy() WaterPlatform = nil end
    end
end, nil)

local DisableNotificationConnection = nil
ScreenGui.CreateToggle(Page_Setting, "Remove Fish Notification Pop-up", "DisablePopups", function(state)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local SmallNotification = PlayerGui:FindFirstChild("Small Notification")
    if not SmallNotification then
        SmallNotification = PlayerGui:WaitForChild("Small Notification", 5)
    end
    if state then
        if SmallNotification then
            DisableNotificationConnection = RunService.RenderStepped:Connect(function()
                if not ScriptActive then
                    if DisableNotificationConnection then DisableNotificationConnection:Disconnect() end
                    return
                end
                SmallNotification.Enabled = false
            end)
            ShowNotification("Pop-up Diblokir", false)
        end
    else
        if DisableNotificationConnection then
            DisableNotificationConnection:Disconnect()
            DisableNotificationConnection = nil
        end
        if SmallNotification then SmallNotification.Enabled = true end
        ShowNotification("Pop-up Diaktifkan", false)
    end
end, nil)

local isNoAnimationActive = false
local originalAnimator = nil
local originalAnimateScript = nil

local function DisableAnimations()
    local character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local animateScript = character:FindFirstChild("Animate")
    if animateScript and animateScript:IsA("LocalScript") and animateScript.Enabled then
        originalAnimateScript = animateScript.Enabled
        animateScript.Enabled = false
    end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        originalAnimator = animator
        animator:Destroy()
    end
end

local function EnableAnimations()
    local character = Players.LocalPlayer.Character
    local animateScript = character and character:FindFirstChild("Animate")
    if animateScript and originalAnimateScript ~= nil then
        animateScript.Enabled = originalAnimateScript
    end
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if not humanoid:FindFirstChildOfClass("Animator") then
            if originalAnimator then originalAnimator.Parent = humanoid else Instance.new("Animator", humanoid) end
        end
    end
end

table.insert(Connections, Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
    if isNoAnimationActive then
        task.wait(0.2)
        DisableAnimations()
    end
end))

ScreenGui.CreateToggle(Page_Setting, "No Animation", "NoAnimation", function(state)
    isNoAnimationActive = state
    if state then
        DisableAnimations()
        ShowNotification("No Animation ON", false)
    else
        EnableAnimations()
        ShowNotification("No Animation OFF", false)
    end
end, nil)

local VFXControllerModule = require(ReplicatedStorage.Controllers.VFXController)
local originalVFXHandle = VFXControllerModule.Handle
local isVFXDisabled = false

ScreenGui.CreateToggle(Page_Setting, "Remove Skin Effect", "RemoveVFX", function(state)
    isVFXDisabled = state
    if state then
        VFXControllerModule.Handle = function(...) end
        VFXControllerModule.RenderAtPoint = function(...) end
        VFXControllerModule.RenderInstance = function(...) end
        local cosmeticFolder = workspace:FindFirstChild("CosmeticFolder")
        if cosmeticFolder then pcall(function() cosmeticFolder:ClearAllChildren() end) end
        ShowNotification("No Skin Effect ON", false)
    else
        VFXControllerModule.Handle = originalVFXHandle
        ShowNotification("Skin Effect Restored (Rejoin to fully fix)", false)
    end
end, nil)

ScreenGui.CreateToggle(Page_Setting, "Auto Execute on Server Hop", "AutoExecute", function(v) Settings.AutoExecute = v end, nil)

-- Save Config Tab
local SaveInput = ScreenGui.CreateInput(Page_Save, "Config Name", "", function(v) end, 36)

local SaveBtn = Instance.new("TextButton", Page_Save)
SaveBtn.BackgroundColor3 = AccentColor
SaveBtn.Size = UDim2.new(1, -5, 0, 28)
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.Text = "SAVE CONFIG"
SaveBtn.TextColor3 = Color3.new(1,1,1)
SaveBtn.TextSize = 11
Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, 6)

local ListLabel = Instance.new("TextLabel", Page_Save)
ListLabel.BackgroundTransparency = 1
ListLabel.Size = UDim2.new(1, 0, 0, 20)
ListLabel.Font = Enum.Font.GothamBold
ListLabel.Text = "Saved Configs"
ListLabel.TextColor3 = Theme.TextSecondary
ListLabel.TextSize = 11
ListLabel.TextXAlignment = Enum.TextXAlignment.Left

local ConfigList = Instance.new("ScrollingFrame", Page_Save)
ConfigList.BackgroundColor3 = Theme.Content
ConfigList.Size = UDim2.new(1, -5, 0, 80)
ConfigList.BorderSizePixel = 0
ConfigList.ScrollBarThickness = 3
ConfigList.ScrollBarImageColor3 = AccentColor
ConfigList.CanvasSize = UDim2.new(0,0,0,0)
ConfigList.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", ConfigList).CornerRadius = UDim.new(0, 6)
SpeedHubUI:AddStroke(ConfigList, Theme.Border, 1)
local ConfigLayout = Instance.new("UIListLayout", ConfigList)
ConfigLayout.Padding = UDim.new(0, 2)
Instance.new("UIPadding", ConfigList).PaddingLeft = UDim.new(0, 4)
Instance.new("UIPadding", ConfigList).PaddingTop = UDim.new(0, 4)

local ActionWrapper = Instance.new("Frame", Page_Save)
ActionWrapper.BackgroundTransparency = 1
ActionWrapper.Size = UDim2.new(1, -5, 0, 28)
local LoadBtn = Instance.new("TextButton", ActionWrapper)
LoadBtn.BackgroundColor3 = Theme.Success
LoadBtn.Size = UDim2.new(0.48, 0, 1, 0)
LoadBtn.Font = Enum.Font.GothamBold
LoadBtn.Text = "LOAD"
LoadBtn.TextColor3 = Color3.new(1,1,1)
LoadBtn.TextSize = 11
Instance.new("UICorner", LoadBtn).CornerRadius = UDim.new(0, 6)
local DeleteBtn = Instance.new("TextButton", ActionWrapper)
DeleteBtn.BackgroundColor3 = Theme.Error
DeleteBtn.Position = UDim2.new(0.52, 0, 0, 0)
DeleteBtn.Size = UDim2.new(0.48, 0, 1, 0)
DeleteBtn.Font = Enum.Font.GothamBold
DeleteBtn.Text = "DELETE"
DeleteBtn.TextColor3 = Color3.new(1,1,1)
DeleteBtn.TextSize = 11
Instance.new("UICorner", DeleteBtn).CornerRadius = UDim.new(0, 6)

local selectedConfig = nil

local function RefreshConfigList()
    for _, v in pairs(ConfigList:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    selectedConfig = nil
    LoadBtn.BackgroundColor3 = Theme.Input
    local success, files = pcall(function() return listfiles("Nikee_Configs") end)
    if not success or not files then files = {} end
    for _, file in pairs(files) do
        local name = file:match("([^/\\]+)$") or file
        name = name:gsub("%.json$", "")
        local Btn = Instance.new("TextButton", ConfigList)
        Btn.BackgroundColor3 = Theme.Background
        Btn.Size = UDim2.new(1, -8, 0, 24)
        Btn.Font = Enum.Font.GothamMedium
        Btn.Text = "  " .. name
        Btn.TextColor3 = Theme.TextSecondary
        Btn.TextSize = 11
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
        Btn.MouseButton1Click:Connect(function()
            for _, b in pairs(ConfigList:GetChildren()) do
                if b:IsA("TextButton") then
                    b.BackgroundColor3 = Theme.Background
                    b.TextColor3 = Theme.TextSecondary
                end
            end
            Btn.BackgroundColor3 = AccentColor
            Btn.TextColor3 = Color3.new(1, 1, 1)
            selectedConfig = name
            LoadBtn.BackgroundColor3 = Theme.Success
        end)
    end
end

local function LoadConfig(configName)
    local success, content = pcall(function() return readfile("Nikee_Configs/" .. configName .. ".json") end)
    if not success then ShowNotification("Read Failed!", true) return false end
    local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(content) end)
    if decodeSuccess and data then
        if data.Webhooks then
            Current_Webhook_Fish = data.Webhooks.Fish or ""
            Current_Webhook_Leave = data.Webhooks.Leave or ""
            Current_Webhook_List = data.Webhooks.List or ""
            if UI_FishInput then UI_FishInput.Text = Current_Webhook_Fish end
            if UI_LeaveInput then UI_LeaveInput.Text = Current_Webhook_Leave end
            if UI_ListInput then UI_ListInput.Text = Current_Webhook_List end
            Current_Webhook_Admin = data.Webhooks.Admin or ""
            if UI_AdminInput then UI_AdminInput.Text = Current_Webhook_Admin end
        end
        if data.Players then
            TagList = data.Players
            for i = 1, 20 do
                if not TagList[i] or type(TagList[i]) ~= "table" then TagList[i] = {"", ""} end
            end
            if #TagUIElements > 0 then
                for i = 1, 20 do
                    if TagUIElements[i] then
                        TagUIElements[i].User.Text = TagList[i][1] or ""
                        TagUIElements[i].ID.Text = TagList[i][2] or ""
                    end
                end
            end
        end
        if data.Settings then
            for k, v in pairs(data.Settings) do
                if Settings[k] ~= nil then
                    Settings[k] = v
                    if ToggleRegistry[k] then
                        ToggleRegistry[k](v)
                    end
                end
            end
        end
        ShowNotification("Config Loaded!", false)
        return true
    else
        ShowNotification("JSON Error!", true)
        return false
    end
end

SaveBtn.MouseButton1Click:Connect(function()
    local name = SaveInput.Text
    if name == "" then ShowNotification("Name cannot be empty!", true) return end
    local validKeys = {"SecretEnabled", "RubyEnabled", "MutationCrystalized", "CaveCrystalEnabled", "LeaveEnabled", "PlayerNonPSAuto", "ForeignDetection", "SpoilerName", "PingMonitor", "AutoExecute", "NoAnimation", "RemoveVFX", "DisablePopups", "EvolvedEnabled"}
    local cleanSettings = {}
    for _, key in ipairs(validKeys) do
        if Settings[key] ~= nil then cleanSettings[key] = Settings[key] end
    end
    local cleanPlayers = {}
    for i = 1, 20 do
        if TagList[i] and type(TagList[i]) == "table" then
            cleanPlayers[i] = {tostring(TagList[i][1] or ""), tostring(TagList[i][2] or "")}
        else
            cleanPlayers[i] = {"", ""}
        end
    end
    local cleanWebhooks = {Fish = tostring(Current_Webhook_Fish or ""), Leave = tostring(Current_Webhook_Leave or ""), List = tostring(Current_Webhook_List or ""), Admin = tostring(Current_Webhook_Admin or "")}
    local saveData = {Webhooks = cleanWebhooks, Players = cleanPlayers, Settings = cleanSettings}
    local jsonSuccess, encodedData = pcall(function() return HttpService:JSONEncode(saveData) end)
    if not jsonSuccess then ShowNotification("Encoding Error: " .. tostring(encodedData), true) return end
    local success, err = pcall(function()
        if not isfolder("Nikee_Configs") then makefolder("Nikee_Configs") end
        writefile("Nikee_Configs/" .. name .. ".json", encodedData)
    end)
    if success then
        ShowNotification("Config Saved!", false)
        RefreshConfigList()
    else
        ShowNotification("Write Error: " .. tostring(err), true)
    end
end)

LoadBtn.MouseButton1Click:Connect(function()
    if not selectedConfig then ShowNotification("Select a config!", true) return end
    LoadConfig(selectedConfig)
end)

DeleteBtn.MouseButton1Click:Connect(function()
    if not selectedConfig then return end
    delfile("Nikee_Configs/" .. selectedConfig .. ".json")
    ShowNotification("Deleted!", false)
    RefreshConfigList()
end)

RefreshConfigList()

-- Webhook & Chat Functions
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local function StripTags(str) return string.gsub(str, "<[^>]+>", "") end
local function GetUsername(chatName)
    local trimmed = chatName:match("^%s*(.-)%s*$")
    for _, p in ipairs(Players:GetPlayers()) do
        if p.DisplayName == trimmed or p.Name == trimmed then return p.Name end
    end
    return trimmed
end

local function ParseDataSmart(cleanMsg)
    local msg = string.gsub(cleanMsg, "%[Server%]: ", "")
    local p, f, w = string.match(msg, "^(.*) obtained an? (.*) %((.*)%)")
    if not p then p, f = string.match(msg, "^(.*) obtained an? (.*)") w = "N/A" end
    if p and f then
        if string.sub(f, -1) == "!" or string.sub(f, -1) == "." then f = string.sub(f, 1, -2) end
        f = f:match("^%s*(.-)%s*$")
        local mutation, finalItem, lowerFullItem = nil, f, string.lower(f)
        local allTargets = {}
        for _, v in pairs(SecretList) do table.insert(allTargets, v) end
        for _, v in pairs(StoneList) do table.insert(allTargets, v) end
        table.insert(allTargets, "Evolved Enchant Stone")
        for _, baseName in pairs(allTargets) do
            if string.find(lowerFullItem, string.lower(baseName) .. "$") then
                local s, e = string.find(lowerFullItem, string.lower(baseName) .. "$")
                if s > 1 then
                    local prefixRaw = string.sub(f, 1, s - 1)
                    local checkMut = prefixRaw:gsub("Big%s*", ""):gsub("Shiny%s*", ""):gsub("Sparkling%s*", ""):gsub("Giant%s*", ""):match("^%s*(.-)%s*$")
                    if checkMut == "" then mutation = nil finalItem = f else mutation = checkMut finalItem = string.gsub(f, prefixRaw, ""):match("^%s*(.-)%s*$") end
                else mutation = nil finalItem = f end
                break
            end
        end
        return {Player = p, Item = finalItem, Mutation = mutation, Weight = w}
    end
    return nil
end

local function SendWebhook(data, category)
    if not ScriptActive then return end
    if category == "SECRET" and not Settings.SecretEnabled then return end
    if category == "STONE" and not Settings.RubyEnabled then return end
    if category == "EVOLVED" and not Settings.EvolvedEnabled then return end
    if category == "CRYSTALIZED" and not Settings.MutationCrystalized then return end
    if category == "CAVECRYSTAL" and not Settings.CaveCrystalEnabled then return end
    if category == "LEAVE" and not Settings.LeaveEnabled then return end
    local TargetURL, contentMsg, realUser = "", "", GetUsername(data.Player)
    local discordId = nil
    for i = 1, 20 do if TagList[i][1] ~= "" and string.lower(TagList[i][1]) == string.lower(realUser) then discordId = TagList[i][2] break end end
    if discordId and discordId ~= "" then contentMsg = category == "LEAVE" and "User Left: <@" .. discordId .. ">" or "GG! <@" .. discordId .. ">" end
    if category == "LEAVE" then TargetURL = Current_Webhook_Leave elseif category == "PLAYERS" then TargetURL = Current_Webhook_List else TargetURL = Current_Webhook_Fish end
    if not TargetURL or TargetURL == "" or string.find(TargetURL, "MASUKKAN_URL") then return end
    local embedTitle, embedColor, descriptionText = "", 3447003, ""
    local pName = Settings.SpoilerName and ("||`" .. data.Player .. "`||") or ("`" .. data.Player .. "`")
    if category == "SECRET" then
        SessionStats.Secret = SessionStats.Secret + 1
        embedTitle = "Secret Caught!"
        embedColor = 3447003
        local lines = {"⚓ Fish: " .. data.Item}
        if data.Mutation and data.Mutation ~= "None" then table.insert(lines, "🧬 Mutation: " .. data.Mutation) end
        table.insert(lines, "⚖️ Weight: " .. data.Weight)
        descriptionText = "Player: " .. pName .. "\n\n```\n" .. table.concat(lines, "\n") .. "\n```"
    elseif category == "STONE" then
        SessionStats.Ruby = SessionStats.Ruby + 1
        embedTitle = "Ruby Gemstone!"
        embedColor = 16753920
        local lines = {"💎 Stone: " .. data.Item}
        if data.Mutation and data.Mutation ~= "None" then table.insert(lines, "✨ Mutation: " .. data.Mutation) end
        table.insert(lines, "⚖️ Weight: " .. data.Weight)
        descriptionText = "Player: " .. pName .. "\n\n```\n" .. table.concat(lines, "\n") .. "\n```"
    elseif category == "EVOLVED" then
        SessionStats.Evolved = SessionStats.Evolved + 1
        embedTitle = "Evolved Stone!"
        embedColor = 10181046
        descriptionText = "Player: " .. pName .. "\n\n```\n🔮 Item: " .. data.Item .. "\n```"
    elseif category == "CRYSTALIZED" then
        SessionStats.Crystalized = SessionStats.Crystalized + 1
        embedTitle = "CRYSTALIZED MUTATION!"
        embedColor = 3407871
        local lines = {"💎 Fish: " .. data.Item, "✨ Mutation: Crystalized", "⚖️ Weight: " .. data.Weight}
        descriptionText = "Player: " .. pName .. "\n\n```\n" .. table.concat(lines, "\n") .. "\n```"
    elseif category == "LEAVE" then
        embedTitle = (data.DisplayName or data.Player) .. " Left the server."
        embedColor = 16711680
        descriptionText = "👤 **@" .. data.Player .. "**"
    elseif category == "CAVECRYSTAL" then
        SessionStats.CaveCrystal = SessionStats.CaveCrystal + 1
        embedTitle = "💎 Cave Crystal Event!"
        embedColor = 16776960
        descriptionText = data.ListText
    end
    SessionStats.TotalSent = SessionStats.TotalSent + 1
    local embedData = {["username"] = "NikeeHUB", ["avatar_url"] = "https://i.imgur.com/CWWGnhO.jpeg", ["content"] = contentMsg, ["embeds"] = {{["title"] = embedTitle, ["description"] = descriptionText, ["color"] = embedColor, ["footer"] = {["text"] = "NikeeHUB Webhook", ["icon_url"] = "https://i.imgur.com/CWWGnhO.jpeg"}}}}
    pcall(function() httpRequest({Url = TargetURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(embedData)}) end)
end

local function CheckAndSend(msg)
    if not ScriptActive then return end
    local cleanMsg = StripTags(msg)
    local lowerMsg = string.lower(cleanMsg)
    if string.find(lowerMsg, "evolved enchant stone") then
        local tempMsg = string.gsub(cleanMsg, "^%[Server%]:%s*", "")
        local p = string.match(tempMsg, "^(.*) obtained an?") or "Unknown Player"
        SendWebhook({Player = p, Item = "Evolved Enchant Stone", Mutation = "None", Weight = "N/A"}, "EVOLVED")
        return
    end
    if string.find(lowerMsg, "crystalized") then
        local tempMsg = string.gsub(cleanMsg, "^%[Server%]:%s*", "")
        local p, item_full, w = string.match(tempMsg, "^(.*) obtained an? (.*) %((.*)%)")
        if not p then p, item_full = string.match(tempMsg, "^(.*) obtained an? (.*)") w = "N/A" end
        if p and item_full then
            local finalItem = item_full
            local s, e = string.find(string.lower(item_full), "crystalized")
            if s then finalItem = string.sub(item_full, e + 1):gsub("^%s+", "") end
            local check = string.lower(finalItem)
            local allowed = {"bioluminescent octopus", "blossom jelly", "cute dumbo", "star snail", "blue sea dragon"}
            local isAllowed = false
            for _, v in ipairs(allowed) do if string.find(check, v) then isAllowed = true break end end
            if isAllowed then SendWebhook({Player = p, Item = finalItem, Mutation = "Crystalized", Weight = w}, "CRYSTALIZED") return end
        end
    end
    if string.find(lowerMsg, "obtained an?") or string.find(lowerMsg, "chance!") then
        local data = ParseDataSmart(cleanMsg)
        if data then
            if data.Mutation and string.find(string.lower(data.Mutation), "crystalized") then SendWebhook(data, "CRYSTALIZED") return end
            if string.find(string.lower(data.Item), "evolved enchant stone") then SendWebhook(data, "EVOLVED") return end
            for _, name in pairs(StoneList) do
                if string.find(string.lower(data.Item), string.lower(name)) then
                    if string.find(string.lower(data.Item), "ruby") then
                        if data.Mutation and string.find(string.lower(data.Mutation), "gemstone") then SendWebhook(data, "STONE") end
                    else SendWebhook(data, "STONE") end
                    return
                end
            end
            for _, name in pairs(SecretList) do if string.find(string.lower(data.Item), string.lower(name)) then SendWebhook(data, "SECRET") return end end
        end
    end
end

if TextChatService then
    TextChatService.OnIncomingMessage = function(m)
        if not ScriptActive then return end
        if m.TextSource == nil then CheckAndSend(m.Text) end
    end
end

local ChatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents", 3)
if ChatEvents then
    local OnMessage = ChatEvents:WaitForChild("OnMessageDoneFiltering", 3)
    if OnMessage then
        table.insert(Connections, OnMessage.OnClientEvent:Connect(function(d)
            if not ScriptActive then return end
            if d and d.Message then CheckAndSend(d.Message) end
        end))
    end
end

table.insert(Connections, Players.PlayerRemoving:Connect(function(p)
    if not ScriptActive then return end
    task.spawn(function() SendWebhook({Player = p.Name, DisplayName = p.DisplayName}, "LEAVE") end)
end))

table.insert(Connections, Players.PlayerAdded:Connect(function(p)
    if not ScriptActive then return end
    if Settings.ForeignDetection then
        local isWhitelisted = false
        local checkName = string.lower(p.Name)
        for i = 1, 20 do
            local wlName = TagList[i][1] or ""
            if wlName ~= "" and string.lower(wlName) == checkName then isWhitelisted = true break end
        end
        if not isWhitelisted then
            task.spawn(function()
                if Current_Webhook_Admin == "" then return end
                local adminTags = ""
                local id1 = (TagList[1] and TagList[1][2]) or ""
                local id2 = (TagList[2] and TagList[2][2]) or ""
                if id1 ~= "" then adminTags = adminTags .. "<@" .. id1 .. "> " end
                if id2 ~= "" then adminTags = adminTags .. "<@" .. id2 .. "> " end
                local embed = {["username"] = "NikeeHUB", ["avatar_url"] = "https://i.imgur.com/CWWGnhO.jpeg", ["content"] = adminTags ~= "" and "⚠️ " .. adminTags or "", ["embeds"] = {{["title"] = "Foreign Player Detected", ["description"] = "```\nPlayer: " .. p.Name .. "\nDisplay: " .. p.DisplayName .. "\n```", ["color"] = 16711680, ["footer"] = {["text"] = "NikeeHUB"}}}}
                pcall(function() httpRequest({Url = Current_Webhook_Admin, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode(embed)}) end)
            end)
        end
    end
end))

local LastPingAlert = 0
task.spawn(function()
    while ScriptActive do
        task.wait(5)
        if Settings.PingMonitor and ScriptActive then
            local success, ping = pcall(function() return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() end)
            if success and ping > 500 and tick() - LastPingAlert > 60 then
                LastPingAlert = tick()
                task.spawn(function()
                    if Current_Webhook_Admin == "" then return end
                    local embed = {["username"] = "NikeeHUB", ["avatar_url"] = "https://i.imgur.com/CWWGnhO.jpeg", ["content"] = "⚠️ **HIGH PING!**", ["embeds"] = {{["title"] = "Server Lag Alert", ["description"] = "```\nPing: " .. math.floor(ping) .. " ms\n```", ["color"] = 16776960, ["footer"] = {["text"] = "NikeeHUB"}}}}
                    pcall(function() httpRequest({Url = Current_Webhook_Admin, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode(embed)}) end)
                end)
            end
        end
    end
end)

local CaveCrystalDebounce = 0
local function StartInventoryWatcher()
    local Backpack = Players.LocalPlayer:WaitForChild("Backpack", 10)
    if not Backpack then return end
    table.insert(Connections, Backpack.ChildAdded:Connect(function(child)
        if not ScriptActive then return end
        if child.Name == "Cave Crystal" and tick() - CaveCrystalDebounce > 10 then
            CaveCrystalDebounce = tick()
            SendWebhook({Player = Players.LocalPlayer.Name, ListText = "⛏️ **Found a Cave Crystal!**"}, "CAVECRYSTAL")
        end
    end))
end
task.spawn(StartInventoryWatcher)

print("✅ NikeeHUB System Session v1.0 (SpeedHub UI) Loaded!")
