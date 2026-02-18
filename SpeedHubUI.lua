-- SpeedHubUI Library
-- UI Library untuk NikeeHUB FishIt
-- Usage: local SpeedHubUI = loadstring(readfile("SpeedHubUI.lua"))()

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")

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

local Icons = {
    player = "rbxassetid://12120698352",
    web = "rbxassetid://137601480983962",
    bag = "rbxassetid://8601111810",
    settings = "rbxassetid://70386228443175",
    gps = "rbxassetid://17824309485",
    user = "rbxassetid://108483430622128",
    stat = "rbxassetid://12094445329",
    alert = "rbxassetid://73186275216515",
    fish = "rbxassetid://97167558235554",
    star = "rbxassetid://107005941750079",
}

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

function SpeedHubUI:CreateWindow(config)
    config = config or {}
    local title = config.Title or "SpeedHub"
    local footer = config.Footer or ""
    local color = config.Color or self.Color
    local icon = config.Icon or "rbxassetid://80659354137631"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Name = "SpeedHubUI"
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
    
    local function AddStroke(instance, color, thickness)
        local s = Instance.new("UIStroke", instance)
        s.Color = color or self.Themes.Border
        s.Thickness = thickness or 1
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        return s
    end
    
    local function CreateToggle(parent, text, settingKey, callback, validationFunc)
        local Frame = Instance.new("Frame", parent)
        Frame.BackgroundColor3 = self.Themes.Content
        Frame.BackgroundTransparency = 0
        Frame.Size = UDim2.new(1, -5, 0, 36)
        Frame.BorderSizePixel = 0
        local FrameCorner = Instance.new("UICorner", Frame)
        FrameCorner.CornerRadius = UDim.new(0, 6)
        AddStroke(Frame, self.Themes.Border, 1)
        
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
        AddStroke(Frame, self.Themes.Border, 1)
        
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
        AddStroke(Frame, self.Themes.Border, 1)
        
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
        AddStroke(InputBg, self.Themes.Border, 1)
        
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
            AddStroke(InputBg, color, 1)
        end)
        Input.FocusLost:Connect(function()
            AddStroke(InputBg, self.Themes.Border, 1)
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
        AddStroke(Frame, self.Themes.Border, 1)
        
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
        AddStroke(DropBtn, self.Themes.Border, 1)
        
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
            AddStroke(Float, color, 1)
            
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
        AddStroke = AddStroke,
        Themes = self.Themes,
        Color = color
    }
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

return SpeedHubUI
