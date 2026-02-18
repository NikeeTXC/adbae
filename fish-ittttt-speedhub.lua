-- NikeeHUB FishIt - SpeedHub UI Version
-- GitHub: https://github.com/MajestySkie/Chloe-X
-- Usage: loadstring(game:HttpGet("https://raw.githubusercontent.com/MajestySkie/Chloe-X/main/Main/ChloeX"))()

-- ============================================
-- MENGHUB UI LIBRARY (Inline - SpeedHub)
-- ============================================
local MengHub = (function()
    local HttpService = game:GetService("HttpService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Mouse = LocalPlayer:GetMouse()
    local CoreGui = game:GetService("CoreGui")
    local viewport = workspace.CurrentCamera.ViewportSize
    
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
    
    local function safeSize(pxWidth, pxHeight)
        local scaleX = pxWidth / viewport.X
        local scaleY = pxHeight / viewport.Y
        if isMobile then
            if scaleX > 0.5 then scaleX = 0.5 end
            if scaleY > 0.3 then scaleY = 0.3 end
        end
        return UDim2.new(scaleX, 0, scaleY, 0)
    end
    
    local Icons = {
        player = "rbxassetid://12120698352", web = "rbxassetid://137601480983962", bag = "rbxassetid://8601111810",
        shop = "rbxassetid://4985385964", settings = "rbxassetid://70386228443175", gps = "rbxassetid://17824309485",
        user = "rbxassetid://108483430622128", stat = "rbxassetid://12094445329", alert = "rbxassetid://73186275216515",
        fish = "rbxassetid://97167558235554", star = "rbxassetid://107005941750079",
    }
    
    local function MakeDraggable(topbarobject, object)
        local Dragging, DragInput, DragStart, StartPosition = false, nil, nil, nil
        topbarobject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = input.Position
                StartPosition = object.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then Dragging = false end
                end)
            end
        end)
        topbarobject.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                DragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == DragInput and Dragging then
                local Delta = input.Position - DragStart
                local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
                TweenService:Create(object, TweenInfo.new(0.2), { Position = pos }):Play()
            end
        end)
    end
    
    local function CircleClick(Button, X, Y)
        spawn(function()
            Button.ClipsDescendants = true
            local Circle = Instance.new("ImageLabel")
            Circle.Image = "rbxassetid://266543268"
            Circle.ImageColor3 = Color3.fromRGB(80, 80, 80)
            Circle.ImageTransparency = 0.9
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.BackgroundTransparency = 1
            Circle.ZIndex = 10
            Circle.Name = "Circle"
            Circle.Parent = Button
            local NewX = X - Circle.AbsolutePosition.X
            local NewY = Y - Circle.AbsolutePosition.Y
            Circle.Position = UDim2.new(0, NewX, 0, NewY)
            local Size = Button.AbsoluteSize.X > Button.AbsoluteSize.Y and Button.AbsoluteSize.X * 1.5 or Button.AbsoluteSize.Y * 1.5
            Circle:TweenSizeAndPosition(UDim2.new(0, Size, 0, Size), UDim2.new(0.5, -Size / 2, 0.5, -Size / 2), "Out", "Quad", 0.5, false, nil)
            for i = 1, 10 do
                Circle.ImageTransparency = Circle.ImageTransparency + 0.01
                wait(0.05)
            end
            Circle:Destroy()
        end)
    end
    
    local Menghub = {}
    
    function Menghub:MakeNotify(NotifyConfig)
        NotifyConfig = NotifyConfig or {}
        local Title = NotifyConfig.Title or "Meng Hub"
        local Content = NotifyConfig.Content or "Notification"
        local Color = NotifyConfig.Color or Color3.fromRGB(255, 0, 255)
        local Delay = NotifyConfig.Delay or 5
        
        if not CoreGui:FindFirstChild("NotifyGui") then
            local NotifyGui = Instance.new("ScreenGui")
            NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            NotifyGui.Name = "NotifyGui"
            NotifyGui.Parent = CoreGui
        end
        
        if not CoreGui.NotifyGui:FindFirstChild("NotifyLayout") then
            local NotifyLayout = Instance.new("Frame")
            NotifyLayout.AnchorPoint = Vector2.new(1, 1)
            NotifyLayout.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NotifyLayout.BackgroundTransparency = 1
            NotifyLayout.Position = UDim2.new(1, -30, 1, -30)
            NotifyLayout.Size = UDim2.new(0, 320, 1, 0)
            NotifyLayout.Name = "NotifyLayout"
            NotifyLayout.Parent = CoreGui.NotifyGui
        end
        
        local NotifyFrame = Instance.new("Frame")
        NotifyFrame.BackgroundColor3 = Color3.fromRGB(29, 30, 35)
        NotifyFrame.BorderSizePixel = 0
        NotifyFrame.Size = UDim2.new(1, 0, 0, 70)
        NotifyFrame.BackgroundTransparency = 1
        NotifyFrame.Parent = CoreGui.NotifyGui.NotifyLayout
        NotifyFrame.AnchorPoint = Vector2.new(0, 1)
        
        local NotifyReal = Instance.new("Frame", NotifyFrame)
        NotifyReal.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        NotifyReal.Position = UDim2.new(0, 400, 0, 0)
        NotifyReal.Size = UDim2.new(1, 0, 1, 0)
        Instance.new("UICorner", NotifyReal).CornerRadius = UDim.new(0, 10)
        local UIStroke = Instance.new("UIStroke", NotifyReal)
        UIStroke.Color = Color3.fromRGB(40, 40, 45)
        UIStroke.Thickness = 1
        
        local TextLabel = Instance.new("TextLabel", NotifyReal)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Position = UDim2.new(0, 10, 0, 10)
        TextLabel.Size = UDim2.new(1, -20, 0, 20)
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.Text = Title
        TextLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
        TextLabel.TextSize = 14
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local TextLabel2 = Instance.new("TextLabel", NotifyReal)
        TextLabel2.BackgroundTransparency = 1
        TextLabel2.Position = UDim2.new(0, 10, 0, 30)
        TextLabel2.Size = UDim2.new(1, -20, 0, 13)
        TextLabel2.Font = Enum.Font.Gotham
        TextLabel2.Text = Content
        TextLabel2.TextColor3 = Color
        TextLabel2.TextSize = 13
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
        
        local Close = Instance.new("TextButton", NotifyReal)
        Close.BackgroundTransparency = 1
        Close.Position = UDim2.new(1, -8, 0, 5)
        Close.Size = UDim2.new(0, 24, 0, 24)
        Close.Text = ""
        local CloseImg = Instance.new("ImageLabel", Close)
        CloseImg.Image = "rbxassetid://9886659671"
        CloseImg.ImageColor3 = Color3.fromRGB(160, 160, 165)
        CloseImg.AnchorPoint = Vector2.new(0.5, 0.5)
        CloseImg.BackgroundTransparency = 1
        CloseImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        CloseImg.Size = UDim2.new(0.7, 0, 0.7, 0)
        
        Close.MouseButton1Click:Connect(function()
            TweenService:Create(NotifyReal, TweenInfo.new(0.3), { Position = UDim2.new(0, 400, 0, 0) }):Play()
            task.delay(0.3, function() NotifyFrame:Destroy() end)
        end)
        
        TweenService:Create(NotifyReal, TweenInfo.new(0.3), { Position = UDim2.new(0, 0, 0, 0) }):Play()
        task.delay(Delay, function()
            if NotifyFrame and NotifyFrame.Parent then
                TweenService:Create(NotifyReal, TweenInfo.new(0.3), { Position = UDim2.new(0, 400, 0, 0) }):Play()
                task.delay(0.3, function() NotifyFrame:Destroy() end)
            end
        end)
    end
    
    function Menghub:Window(GuiConfig)
        GuiConfig = GuiConfig or {}
        local Title = GuiConfig.Title or "Meng Hub"
        local Footer = GuiConfig.Footer or "MengHub"
        local Color = GuiConfig.Color or Color3.fromRGB(255, 0, 255)
        local Icon = GuiConfig.Icon or "rbxassetid://80659354137631"
        
        local Menghubb = Instance.new("ScreenGui")
        Menghubb.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        Menghubb.Name = "Menghubb"
        Menghubb.ResetOnSpawn = false
        Menghubb.Parent = CoreGui
        
        local DropShadowHolder = Instance.new("Frame", Menghubb)
        DropShadowHolder.BackgroundTransparency = 1
        DropShadowHolder.BorderSizePixel = 0
        DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
        DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
        DropShadowHolder.Size = safeSize(640, 400)
        
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
        Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Main.BackgroundTransparency = 0.1
        Main.BorderSizePixel = 0
        Main.AnchorPoint = Vector2.new(0.5, 0.5)
        Main.Position = UDim2.new(0.5, 0, 0.5, 0)
        Main.Size = UDim2.new(1, -47, 1, -47)
        Instance.new("UICorner", Main)
        local MainStroke = Instance.new("UIStroke", Main)
        MainStroke.Thickness = 1.2
        MainStroke.Color = Color
        MainStroke.Transparency = 0.6
        
        local Top = Instance.new("Frame", Main)
        Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Top.BackgroundTransparency = 0.999
        Top.BorderSizePixel = 0
        Top.Size = UDim2.new(1, 0, 0, 38)
        Instance.new("UICorner", Top)
        
        local TitleIcon = Instance.new("ImageLabel", Top)
        TitleIcon.BackgroundTransparency = 1
        TitleIcon.BorderSizePixel = 0
        TitleIcon.AnchorPoint = Vector2.new(0, 0.5)
        TitleIcon.Position = UDim2.new(0, 10, 0.5, 0)
        TitleIcon.Size = UDim2.new(0, 20, 0, 20)
        TitleIcon.Image = Icon
        
        local TitleLabel = Instance.new("TextLabel", Top)
        TitleLabel.BackgroundTransparency = 0.999
        TitleLabel.BorderSizePixel = 0
        TitleLabel.Position = UDim2.new(0, 35, 0, 0)
        TitleLabel.Size = UDim2.new(1, -135, 1, 0)
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.Text = Title
        TitleLabel.TextColor3 = Color
        TitleLabel.TextSize = 14
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local FooterLabel = Instance.new("TextLabel", Top)
        FooterLabel.BackgroundTransparency = 0.999
        FooterLabel.BorderSizePixel = 0
        FooterLabel.Position = UDim2.new(0, 25 + TitleLabel.TextBounds.X + 10, 0, 0)
        FooterLabel.Size = UDim2.new(1, -(TitleLabel.TextBounds.X + 104), 1, 0)
        FooterLabel.Font = Enum.Font.GothamBold
        FooterLabel.Text = Footer
        FooterLabel.TextColor3 = Color
        FooterLabel.TextSize = 14
        FooterLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local Close = Instance.new("TextButton", Top)
        Close.BackgroundTransparency = 0.999
        Close.BorderSizePixel = 0
        Close.AnchorPoint = Vector2.new(1, 0.5)
        Close.Position = UDim2.new(1, -8, 0.5, 0)
        Close.Size = UDim2.new(0, 25, 0, 25)
        Close.Text = ""
        local CloseImg = Instance.new("ImageLabel", Close)
        CloseImg.Image = "rbxassetid://9886659671"
        CloseImg.AnchorPoint = Vector2.new(0.5, 0.5)
        CloseImg.BackgroundTransparency = 0.999
        CloseImg.Position = UDim2.new(0.49, 0, 0.5, 0)
        CloseImg.Size = UDim2.new(1, -8, 1, -8)
        
        local Min = Instance.new("TextButton", Top)
        Min.BackgroundTransparency = 0.999
        Min.BorderSizePixel = 0
        Min.AnchorPoint = Vector2.new(1, 0.5)
        Min.Position = UDim2.new(1, -38, 0.5, 0)
        Min.Size = UDim2.new(0, 25, 0, 25)
        Min.Text = ""
        local MinImg = Instance.new("ImageLabel", Min)
        MinImg.Image = "rbxassetid://9886659276"
        MinImg.AnchorPoint = Vector2.new(0.5, 0.5)
        MinImg.BackgroundTransparency = 0.999
        MinImg.ImageTransparency = 0.2
        MinImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        MinImg.Size = UDim2.new(1, -9, 1, -9)
        
        local LayersTab = Instance.new("Frame", Main)
        LayersTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        LayersTab.BackgroundTransparency = 0.999
        LayersTab.BorderSizePixel = 0
        LayersTab.Position = UDim2.new(0, 9, 0, 50)
        LayersTab.Size = UDim2.new(0, 120, 1, -59)
        Instance.new("UICorner", LayersTab).CornerRadius = UDim.new(0, 2)
        
        local ScrollTab = Instance.new("ScrollingFrame", LayersTab)
        ScrollTab.CanvasSize = UDim2.new(0, 0, 1.1, 0)
        ScrollTab.ScrollBarThickness = 0
        ScrollTab.Active = true
        ScrollTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ScrollTab.BackgroundTransparency = 0.999
        ScrollTab.BorderSizePixel = 0
        ScrollTab.Size = UDim2.new(1, 0, 1, 0)
        local UIListLayout = Instance.new("UIListLayout", ScrollTab)
        UIListLayout.Padding = UDim.new(0, 3)
        
        local DecideFrame = Instance.new("Frame", Main)
        DecideFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DecideFrame.BackgroundTransparency = 0.85
        DecideFrame.BorderSizePixel = 0
        DecideFrame.AnchorPoint = Vector2.new(0.5, 0)
        DecideFrame.Position = UDim2.new(0.5, 0, 0, 38)
        DecideFrame.Size = UDim2.new(1, 0, 0, 1)
        
        local Layers = Instance.new("Frame", Main)
        Layers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Layers.BackgroundTransparency = 0.999
        Layers.BorderSizePixel = 0
        Layers.Position = UDim2.new(0, 147, 0, 50)
        Layers.Size = UDim2.new(1, -156, 1, -59)
        Instance.new("UICorner", Layers).CornerRadius = UDim.new(0, 2)
        
        local NameTab = Instance.new("TextLabel", Layers)
        NameTab.BackgroundTransparency = 0.999
        NameTab.BorderSizePixel = 0
        NameTab.Size = UDim2.new(1, 0, 0, 30)
        NameTab.Font = Enum.Font.GothamBold
        NameTab.Text = ""
        NameTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        NameTab.TextSize = 24
        NameTab.TextXAlignment = Enum.TextXAlignment.Left
        
        local LayersReal = Instance.new("Frame", Layers)
        LayersReal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        LayersReal.BackgroundTransparency = 0.999
        LayersReal.BorderSizePixel = 0
        LayersReal.ClipsDescendants = true
        LayersReal.AnchorPoint = Vector2.new(0, 1)
        LayersReal.Position = UDim2.new(0, 0, 1, 0)
        LayersReal.Size = UDim2.new(1, 0, 1, -33)
        
        local LayersFolder = Instance.new("Folder", LayersReal)
        local LayersPageLayout = Instance.new("UIPageLayout", LayersFolder)
        LayersPageLayout.TweenTime = 0.5
        LayersPageLayout.EasingDirection = Enum.EasingDirection.InOut
        LayersPageLayout.EasingStyle = Enum.EasingStyle.Quad
        
        local GuiFunc = {}
        local Tabs = {}
        local CountTab = 0
        
        Min.MouseButton1Click:Connect(function()
            CircleClick(Min, Mouse.X, Mouse.Y)
            DropShadowHolder.Visible = false
        end)
        
        Close.MouseButton1Click:Connect(function()
            CircleClick(Close, Mouse.X, Mouse.Y)
            local Overlay = Instance.new("Frame", DropShadowHolder)
            Overlay.Size = UDim2.new(1, 0, 1, 0)
            Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Overlay.BackgroundTransparency = 0.3
            Overlay.ZIndex = 50
            local Dialog = Instance.new("Frame", Overlay)
            Dialog.Size = UDim2.new(0, 300, 0, 150)
            Dialog.Position = UDim2.new(0.5, -150, 0.5, -75)
            Dialog.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Dialog.BorderSizePixel = 0
            Dialog.ZIndex = 51
            Instance.new("UICorner", Dialog).CornerRadius = UDim.new(0, 8)
            local DialogTitle = Instance.new("TextLabel", Dialog)
            DialogTitle.BackgroundTransparency = 1
            DialogTitle.Position = UDim2.new(0, 0, 0, 4)
            DialogTitle.Size = UDim2.new(1, 0, 0, 40)
            DialogTitle.Font = Enum.Font.GothamBold
            DialogTitle.Text = "Meng Hub Window"
            DialogTitle.TextSize = 22
            DialogTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            DialogTitle.ZIndex = 52
            local DialogMsg = Instance.new("TextLabel", Dialog)
            DialogMsg.BackgroundTransparency = 1
            DialogMsg.Position = UDim2.new(0, 10, 0, 30)
            DialogMsg.Size = UDim2.new(1, -20, 0, 60)
            DialogMsg.Font = Enum.Font.Gotham
            DialogMsg.Text = "Do you want to close this window?"
            DialogMsg.TextSize = 14
            DialogMsg.TextColor3 = Color3.fromRGB(200, 200, 200)
            DialogMsg.TextWrapped = true
            DialogMsg.ZIndex = 52
            local Yes = Instance.new("TextButton", Dialog)
            Yes.Size = UDim2.new(0.45, -10, 0, 35)
            Yes.Position = UDim2.new(0.05, 0, 1, -55)
            Yes.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Yes.BackgroundTransparency = 0.935
            Yes.Text = "Yes"
            Yes.Font = Enum.Font.GothamBold
            Yes.TextSize = 15
            Yes.TextColor3 = Color3.fromRGB(255, 255, 255)
            Yes.TextTransparency = 0.3
            Yes.ZIndex = 52
            Instance.new("UICorner", Yes).CornerRadius = UDim.new(0, 6)
            local Cancel = Instance.new("TextButton", Dialog)
            Cancel.Size = UDim2.new(0.45, -10, 0, 35)
            Cancel.Position = UDim2.new(0.5, 10, 1, -55)
            Cancel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Cancel.BackgroundTransparency = 0.935
            Cancel.Text = "Cancel"
            Cancel.Font = Enum.Font.GothamBold
            Cancel.TextSize = 15
            Cancel.TextColor3 = Color3.fromRGB(255, 255, 255)
            Cancel.TextTransparency = 0.3
            Cancel.ZIndex = 52
            Instance.new("UICorner", Cancel).CornerRadius = UDim.new(0, 6)
            Yes.MouseButton1Click:Connect(function()
                if Menghubb then Menghubb:Destroy() end
            end)
            Cancel.MouseButton1Click:Connect(function() Overlay:Destroy() end)
        end)
        
        local ToggleKey = Enum.KeyCode.F3
        UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == ToggleKey then
                DropShadowHolder.Visible = not DropShadowHolder.Visible
            end
        end)
        
        MakeDraggable(Top, DropShadowHolder)
        DropShadowHolder.Size = UDim2.new(0, 115 + TitleLabel.TextBounds.X + 1 + FooterLabel.TextBounds.X, 0, 350)
        
        function Tabs:AddTab(TabConfig)
            TabConfig = TabConfig or {}
            local TabName = TabConfig.Name or "Tab"
            local TabIcon = TabConfig.Icon or ""
            
            local ScrolLayers = Instance.new("ScrollingFrame", LayersFolder)
            ScrolLayers.ScrollBarThickness = 0
            ScrolLayers.Active = true
            ScrolLayers.LayoutOrder = CountTab
            ScrolLayers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ScrolLayers.BackgroundTransparency = 0.999
            ScrolLayers.BorderSizePixel = 0
            ScrolLayers.Size = UDim2.new(1, 0, 1, 0)
            ScrolLayers.Name = "ScrolLayers"
            local UIListLayout1 = Instance.new("UIListLayout", ScrolLayers)
            UIListLayout1.Padding = UDim.new(0, 3)
            
            local Tab = Instance.new("Frame", ScrollTab)
            Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Tab.BackgroundTransparency = CountTab == 0 and 0.92 or 0.999
            Tab.BorderSizePixel = 0
            Tab.LayoutOrder = CountTab
            Tab.Size = UDim2.new(1, 0, 0, 30)
            Tab.Name = "Tab"
            Instance.new("UICorner", Tab).CornerRadius = UDim.new(0, 4)
            
            local TabButton = Instance.new("TextButton", Tab)
            TabButton.Font = Enum.Font.GothamBold
            TabButton.Text = ""
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabButton.TextSize = 15
            TabButton.TextXAlignment = Enum.TextXAlignment.Left
            TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TabButton.BackgroundTransparency = 0.999
            TabButton.BorderSizePixel = 0
            TabButton.Size = UDim2.new(1, 0, 1, 0)
            TabButton.Name = "TabButton"
            
            local TabNameLabel = Instance.new("TextLabel", Tab)
            TabNameLabel.Font = Enum.Font.GothamBold
            TabNameLabel.Text = "| " .. TabName
            TabNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabNameLabel.TextSize = 15
            TabNameLabel.TextXAlignment = Enum.TextXAlignment.Left
            TabNameLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TabNameLabel.BackgroundTransparency = 0.999
            TabNameLabel.BorderSizePixel = 0
            TabNameLabel.Size = UDim2.new(1, 0, 1, 0)
            TabNameLabel.Position = UDim2.new(0, 30, 0, 0)
            TabNameLabel.Name = "TabName"
            
            local FeatureImg = Instance.new("ImageLabel", Tab)
            FeatureImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            FeatureImg.BackgroundTransparency = 0.999
            FeatureImg.BorderSizePixel = 0
            FeatureImg.Position = UDim2.new(0, 9, 0, 7)
            FeatureImg.Size = UDim2.new(0, 16, 0, 16)
            FeatureImg.Name = "FeatureImg"
            
            if CountTab == 0 then
                LayersPageLayout:JumpToIndex(0)
                NameTab.Text = TabName
                local ChooseFrame = Instance.new("Frame", Tab)
                ChooseFrame.BackgroundColor3 = Color
                ChooseFrame.BorderSizePixel = 0
                ChooseFrame.Position = UDim2.new(0, 2, 0, 9)
                ChooseFrame.Size = UDim2.new(0, 1, 0, 12)
                ChooseFrame.Name = "ChooseFrame"
                local UIStroke2 = Instance.new("UIStroke", ChooseFrame)
                UIStroke2.Color = Color
                UIStroke2.Thickness = 1.6
                Instance.new("UICorner", ChooseFrame)
            end
            
            if TabIcon ~= "" and Icons[TabIcon] then
                FeatureImg.Image = Icons[TabIcon]
            end
            
            TabButton.MouseButton1Click:Connect(function()
                CircleClick(TabButton, Mouse.X, Mouse.Y)
                local FrameChoose = nil
                for _, s in ScrollTab:GetChildren() do
                    for _, v in s:GetChildren() do
                        if v.Name == "ChooseFrame" then FrameChoose = v break end
                    end
                end
                if FrameChoose and Tab.LayoutOrder ~= LayersPageLayout.CurrentPage.LayoutOrder then
                    for _, TabFrame in ScrollTab:GetChildren() do
                        if TabFrame.Name == "Tab" then
                            TweenService:Create(TabFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), { BackgroundTransparency = 0.999 }):Play()
                        end
                    end
                    TweenService:Create(Tab, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), { BackgroundTransparency = 0.92 }):Play()
                    TweenService:Create(FrameChoose, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Position = UDim2.new(0, 2, 0, 9 + (33 * Tab.LayoutOrder)) }):Play()
                    LayersPageLayout:JumpToIndex(Tab.LayoutOrder)
                    task.wait(0.05)
                    NameTab.Text = TabName
                end
            end)
            
            local Sections = {}
            local CountSection = 0
            
            function Sections:AddSection(SectionTitle, AlwaysOpen)
                SectionTitle = SectionTitle or "Title"
                local Section = Instance.new("Frame", ScrolLayers)
                Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Section.BackgroundTransparency = 0.999
                Section.BorderSizePixel = 0
                Section.LayoutOrder = CountSection
                Section.ClipsDescendants = true
                Section.Size = UDim2.new(1, 0, 0, 30)
                Section.Name = "Section"
                
                local SectionReal = Instance.new("Frame", Section)
                SectionReal.AnchorPoint = Vector2.new(0.5, 0)
                SectionReal.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                SectionReal.BackgroundTransparency = 0.5
                SectionReal.BorderSizePixel = 0
                SectionReal.Position = UDim2.new(0.5, 0, 0, 0)
                SectionReal.Size = UDim2.new(1, -2, 0, 30)
                SectionReal.Name = "SectionReal"
                Instance.new("UICorner", SectionReal).CornerRadius = UDim.new(0, 6)
                local SectionOutline = Instance.new("UIStroke", SectionReal)
                SectionOutline.Color = Color3.fromRGB(189, 162, 241)
                SectionOutline.Thickness = 1.5
                SectionOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                SectionOutline.Transparency = 0.2
                
                local SectionButton = Instance.new("TextButton", SectionReal)
                SectionButton.Font = Enum.Font.SourceSans
                SectionButton.Text = ""
                SectionButton.BackgroundTransparency = 0.999
                SectionButton.BorderSizePixel = 0
                SectionButton.Size = UDim2.new(1, 0, 1, 0)
                SectionButton.Name = "SectionButton"
                
                local FeatureFrame = Instance.new("Frame", SectionReal)
                FeatureFrame.AnchorPoint = Vector2.new(1, 0.5)
                FeatureFrame.BackgroundTransparency = 0.999
                FeatureFrame.BorderSizePixel = 0
                FeatureFrame.Position = UDim2.new(1, -5, 0.5, 0)
                FeatureFrame.Size = UDim2.new(0, 20, 0, 20)
                FeatureFrame.Name = "FeatureFrame"
                
                local FeatureImg = Instance.new("ImageLabel", FeatureFrame)
                FeatureImg.Image = "rbxassetid://16851841101"
                FeatureImg.AnchorPoint = Vector2.new(0.5, 0.5)
                FeatureImg.BackgroundTransparency = 0.999
                FeatureImg.BorderSizePixel = 0
                FeatureImg.Position = UDim2.new(0.5, 0, 0.5, 0)
                FeatureImg.Rotation = -90
                FeatureImg.Size = UDim2.new(1, 6, 1, 6)
                FeatureImg.Name = "FeatureImg"
                
                local SectionTitleLabel = Instance.new("TextLabel", SectionReal)
                SectionTitleLabel.Font = Enum.Font.GothamBold
                SectionTitleLabel.Text = SectionTitle
                SectionTitleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                SectionTitleLabel.TextSize = 15
                SectionTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
                SectionTitleLabel.AnchorPoint = Vector2.new(0, 0.5)
                SectionTitleLabel.BackgroundTransparency = 0.999
                SectionTitleLabel.BorderSizePixel = 0
                SectionTitleLabel.Position = UDim2.new(0, 10, 0.5, 0)
                SectionTitleLabel.Size = UDim2.new(1, -50, 0, 13)
                SectionTitleLabel.Name = "SectionTitle"
                
                local SectionDecideFrame = Instance.new("Frame", Section)
                SectionDecideFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SectionDecideFrame.BorderSizePixel = 0
                SectionDecideFrame.AnchorPoint = Vector2.new(0.5, 0)
                SectionDecideFrame.Position = UDim2.new(0.5, 0, 0, 33)
                SectionDecideFrame.Size = UDim2.new(0, 0, 0, 2)
                SectionDecideFrame.Name = "SectionDecideFrame"
                Instance.new("UICorner", SectionDecideFrame)
                local UIGradient = Instance.new("UIGradient", SectionDecideFrame)
                UIGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
                    ColorSequenceKeypoint.new(0.5, Color),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
                })
                
                local SectionAdd = Instance.new("Frame", Section)
                SectionAdd.AnchorPoint = Vector2.new(0.5, 0)
                SectionAdd.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SectionAdd.BackgroundTransparency = 0.999
                SectionAdd.BorderSizePixel = 0
                SectionAdd.ClipsDescendants = true
                SectionAdd.LayoutOrder = 1
                SectionAdd.Position = UDim2.new(0.5, 0, 0, 38)
                SectionAdd.Size = UDim2.new(1, 0, 0, 100)
                SectionAdd.Name = "SectionAdd"
                Instance.new("UICorner", SectionAdd).CornerRadius = UDim.new(0, 2)
                local UIListLayout2 = Instance.new("UIListLayout", SectionAdd)
                UIListLayout2.Padding = UDim.new(0, 3)
                
                local OpenSection = false
                if AlwaysOpen == true then
                    SectionButton:Destroy()
                    FeatureFrame:Destroy()
                    OpenSection = true
                elseif AlwaysOpen == false then
                    OpenSection = true
                end
                
                SectionButton.MouseButton1Click:Connect(function()
                    CircleClick(SectionButton, Mouse.X, Mouse.Y)
                    OpenSection = not OpenSection
                    if OpenSection then
                        TweenService:Create(FeatureImg, TweenInfo.new(0.25), { Rotation = 0 }):Play()
                    else
                        TweenService:Create(FeatureImg, TweenInfo.new(0.25), { Rotation = -90 }):Play()
                    end
                end)
                
                local Items = {}
                local CountItem = 0
                
                function Items:AddToggle(ToggleConfig)
                    ToggleConfig = ToggleConfig or {}
                    local TTitle = ToggleConfig.Title or "Title"
                    local TContent = ToggleConfig.Content or ""
                    local TDefault = ToggleConfig.Default or false
                    local TCallback = ToggleConfig.Callback or function() end
                    
                    local Toggle = Instance.new("Frame", SectionAdd)
                    Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Toggle.BackgroundTransparency = 0.935
                    Toggle.BorderSizePixel = 0
                    Toggle.LayoutOrder = CountItem
                    Toggle.Size = UDim2.new(1, 0, 0, 46)
                    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 4)
                    
                    local ToggleTitle = Instance.new("TextLabel", Toggle)
                    ToggleTitle.BackgroundTransparency = 1
                    ToggleTitle.Position = UDim2.new(0, 10, 0, 10)
                    ToggleTitle.Size = UDim2.new(1, -100, 0, 13)
                    ToggleTitle.Font = Enum.Font.GothamBold
                    ToggleTitle.Text = TTitle
                    ToggleTitle.TextColor3 = Color3.fromRGB(231, 231, 231)
                    ToggleTitle.TextSize = 15
                    ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
                    
                    local ToggleContent = Instance.new("TextLabel", Toggle)
                    ToggleContent.BackgroundTransparency = 1
                    ToggleContent.Position = UDim2.new(0, 10, 0, 23)
                    ToggleContent.Size = UDim2.new(1, -100, 0, 12)
                    ToggleContent.Font = Enum.Font.GothamBold
                    ToggleContent.Text = TContent
                    ToggleContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ToggleContent.TextSize = 14
                    ToggleContent.TextTransparency = 0.6
                    ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
                    
                    local ToggleButton = Instance.new("TextButton", Toggle)
                    ToggleButton.BackgroundTransparency = 1
                    ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                    ToggleButton.Text = ""
                    
                    local FeatureFrame2 = Instance.new("Frame", Toggle)
                    FeatureFrame2.AnchorPoint = Vector2.new(1, 0.5)
                    FeatureFrame2.BackgroundTransparency = 0.92
                    FeatureFrame2.BorderSizePixel = 0
                    FeatureFrame2.Position = UDim2.new(1, -15, 0.5, 0)
                    FeatureFrame2.Size = UDim2.new(0, 30, 0, 15)
                    FeatureFrame2.Name = "FeatureFrame"
                    Instance.new("UICorner", FeatureFrame2)
                    local UIStroke8 = Instance.new("UIStroke", FeatureFrame2)
                    UIStroke8.Color = Color3.fromRGB(255, 255, 255)
                    UIStroke8.Thickness = 2
                    UIStroke8.Transparency = 0.9
                    
                    local ToggleCircle = Instance.new("Frame", FeatureFrame2)
                    ToggleCircle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                    ToggleCircle.BorderSizePixel = 0
                    ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
                    ToggleCircle.Name = "ToggleCircle"
                    Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(0, 15)
                    
                    local ToggleValue = TDefault
                    local function UpdateToggle(Value)
                        ToggleValue = Value
                        if Value then
                            TweenService:Create(ToggleTitle, TweenInfo.new(0.2), { TextColor3 = Color }):Play()
                            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), { Position = UDim2.new(0, 15, 0, 0) }):Play()
                            TweenService:Create(UIStroke8, TweenInfo.new(0.2), { Color = Color, Transparency = 0 }):Play()
                            TweenService:Create(FeatureFrame2, TweenInfo.new(0.2), { BackgroundColor3 = Color, BackgroundTransparency = 0 }):Play()
                        else
                            TweenService:Create(ToggleTitle, TweenInfo.new(0.2), { TextColor3 = Color3.fromRGB(230, 230, 230) }):Play()
                            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), { Position = UDim2.new(0, 0, 0, 0) }):Play()
                            TweenService:Create(UIStroke8, TweenInfo.new(0.2), { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.9 }):Play()
                            TweenService:Create(FeatureFrame2, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.92 }):Play()
                        end
                        task.spawn(function() TCallback(Value) end)
                    end
                    
                    ToggleButton.MouseButton1Click:Connect(function()
                        UpdateToggle(not ToggleValue)
                    end)
                    
                    UpdateToggle(ToggleValue)
                    CountItem = CountItem + 1
                    return {Set = function(v) UpdateToggle(v) end, Value = ToggleValue}
                end
                
                function Items:AddButton(ButtonConfig)
                    ButtonConfig = ButtonConfig or {}
                    local BTitle = ButtonConfig.Title or "Button"
                    local BSubTitle = ButtonConfig.SubTitle
                    local BCallback = ButtonConfig.Callback or function() end
                    local BSubCallback = ButtonConfig.SubCallback or function() end
                    
                    local Button = Instance.new("Frame", SectionAdd)
                    Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Button.BackgroundTransparency = 0.935
                    Button.Size = UDim2.new(1, 0, 0, 40)
                    Button.LayoutOrder = CountItem
                    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)
                    
                    local MainButton = Instance.new("TextButton", Button)
                    MainButton.Font = Enum.Font.GothamBold
                    MainButton.Text = BTitle
                    MainButton.TextSize = 14
                    MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    MainButton.TextTransparency = 0.3
                    MainButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    MainButton.BackgroundTransparency = 0.935
                    MainButton.Size = BSubTitle and UDim2.new(0.5, -8, 1, -10) or UDim2.new(1, -12, 1, -10)
                    MainButton.Position = UDim2.new(0, 6, 0, 5)
                    Instance.new("UICorner", MainButton).CornerRadius = UDim.new(0, 4)
                    MainButton.MouseButton1Click:Connect(BCallback)
                    
                    if BSubTitle then
                        local SubButton = Instance.new("TextButton", Button)
                        SubButton.Font = Enum.Font.GothamBold
                        SubButton.Text = BSubTitle
                        SubButton.TextSize = 14
                        SubButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                        SubButton.TextTransparency = 0.3
                        SubButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        SubButton.BackgroundTransparency = 0.935
                        SubButton.Size = UDim2.new(0.5, -8, 1, -10)
                        SubButton.Position = UDim2.new(0.5, 2, 0, 5)
                        Instance.new("UICorner", SubButton).CornerRadius = UDim.new(0, 4)
                        SubButton.MouseButton1Click:Connect(BSubCallback)
                    end
                    
                    CountItem = CountItem + 1
                end
                
                function Items:AddPanel(PanelConfig)
                    PanelConfig = PanelConfig or {}
                    local PTitle = PanelConfig.Title or "Title"
                    local PPlaceholder = PanelConfig.Placeholder or ""
                    local PDefault = PanelConfig.Default or ""
                    local PButtonText = PanelConfig.ButtonText or "Confirm"
                    local PCallback = PanelConfig.ButtonCallback or function() end
                    
                    local Panel = Instance.new("Frame", SectionAdd)
                    Panel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Panel.BackgroundTransparency = 0.935
                    Panel.Size = UDim2.new(1, 0, 0, 88)
                    Panel.LayoutOrder = CountItem
                    Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 4)
                    
                    local Title = Instance.new("TextLabel", Panel)
                    Title.BackgroundTransparency = 1
                    Title.Position = UDim2.new(0, 10, 0, 10)
                    Title.Size = UDim2.new(1, -20, 0, 13)
                    Title.Font = Enum.Font.GothamBold
                    Title.Text = PTitle
                    Title.TextSize = 15
                    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Title.TextXAlignment = Enum.TextXAlignment.Left
                    
                    local InputFrame = Instance.new("Frame", Panel)
                    InputFrame.AnchorPoint = Vector2.new(0.5, 0)
                    InputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    InputFrame.BackgroundTransparency = 0.95
                    InputFrame.Position = UDim2.new(0.5, 0, 0, 48)
                    InputFrame.Size = UDim2.new(1, -20, 0, 30)
                    Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 4)
                    
                    local InputBox = Instance.new("TextBox", InputFrame)
                    InputBox.Font = Enum.Font.GothamBold
                    InputBox.PlaceholderText = PPlaceholder
                    InputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
                    InputBox.Text = PDefault
                    InputBox.TextSize = 11
                    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                    InputBox.BackgroundTransparency = 1
                    InputBox.TextXAlignment = Enum.TextXAlignment.Left
                    InputBox.Size = UDim2.new(1, -10, 1, -6)
                    InputBox.Position = UDim2.new(0, 5, 0, 3)
                    
                    local ButtonMain = Instance.new("TextButton", Panel)
                    ButtonMain.Font = Enum.Font.GothamBold
                    ButtonMain.Text = PButtonText
                    ButtonMain.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ButtonMain.TextSize = 14
                    ButtonMain.TextTransparency = 0.3
                    ButtonMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    ButtonMain.BackgroundTransparency = 0.935
                    ButtonMain.Size = UDim2.new(1, -20, 0, 30)
                    ButtonMain.Position = UDim2.new(0, 10, 0, 52)
                    Instance.new("UICorner", ButtonMain).CornerRadius = UDim.new(0, 6)
                    ButtonMain.MouseButton1Click:Connect(function()
                        PCallback(InputBox.Text)
                    end)
                    
                    CountItem = CountItem + 1
                    return {GetInput = function() return InputBox.Text end}
                end
                
                function Items:AddParagraph(ParaConfig)
                    ParaConfig = ParaConfig or {}
                    local PaTitle = ParaConfig.Title or "Title"
                    local PaContent = ParaConfig.Content or "Content"
                    
                    local Paragraph = Instance.new("Frame", SectionAdd)
                    Paragraph.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Paragraph.BackgroundTransparency = 0.935
                    Paragraph.Size = UDim2.new(1, 0, 0, 46)
                    Paragraph.LayoutOrder = CountItem
                    Instance.new("UICorner", Paragraph).CornerRadius = UDim.new(0, 4)
                    
                    local ParaTitle = Instance.new("TextLabel", Paragraph)
                    ParaTitle.BackgroundTransparency = 1
                    ParaTitle.Position = UDim2.new(0, 10, 0, 10)
                    ParaTitle.Size = UDim2.new(1, -20, 0, 13)
                    ParaTitle.Font = Enum.Font.GothamBold
                    ParaTitle.Text = PaTitle
                    ParaTitle.TextColor3 = Color3.fromRGB(231, 231, 231)
                    ParaTitle.TextSize = 15
                    ParaTitle.TextXAlignment = Enum.TextXAlignment.Left
                    
                    local ParaContent = Instance.new("TextLabel", Paragraph)
                    ParaContent.BackgroundTransparency = 1
                    ParaContent.Position = UDim2.new(0, 10, 0, 25)
                    ParaContent.Size = UDim2.new(1, -20, 0, 14)
                    ParaContent.Font = Enum.Font.Gotham
                    ParaContent.Text = PaContent
                    ParaContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ParaContent.TextSize = 14
                    ParaContent.TextXAlignment = Enum.TextXAlignment.Left
                    
                    CountItem = CountItem + 1
                    return {}
                end
                
                CountSection = CountSection + 1
                return Items
            end
            
            CountTab = CountTab + 1
            return Sections
        end
        
        return Tabs
    end
    
    return Menghub
end)()

-- ============================================
-- NIKEEHUB FISHIT - MAIN SCRIPT
-- ============================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local ScriptActive = true
local Connections = {}
local VirtualUser = game:GetService("VirtualUser")
local FishingController = require(ReplicatedStorage.Controllers.FishingController)

local function CleanupScript()
    ScriptActive = false
    for _, v in pairs(Connections) do pcall(function() v:Disconnect() end) end
    Connections = {}
    if TextChatService then TextChatService.OnIncomingMessage = nil end
    print("❌ NikeeHUB System: Script closed")
end

if not isfolder("Nikee_Configs") then pcall(function() makefolder("Nikee_Configs") end) end

local Current_Webhook_Fish, Current_Webhook_Leave, Current_Webhook_List, Current_Webhook_Admin = "", "", "", ""
local SecretList = {"Crystal Crab", "Orca", "Zombie Shark", "Zombie Megalodon", "Dead Zombie Shark", "Blob Shark", "Ghost Shark", "Skeleton Narwhal", "Ghost Worm Fish", "Worm Fish", "Megalodon", "1x1x1x1 Comet Shark", "Bloodmoon Whale", "Lochness Monster", "Monster Shark", "Eerie Shark", "Great Whale", "Frostborn Shark", "Armored Shark", "Scare", "Queen Crab", "King Crab", "Cryoshade Glider", "Panther Eel", "Giant Squid", "Depthseeker Ray", "Robot Kraken", "Mosasaur Shark", "King Jelly", "Bone Whale", "Elshark Gran Maja", "Elpirate Gran Maja", "Ancient Whale", "Gladiator Shark", "Ancient Lochness Monster", "Talon Serpent", "Hacker Shark", "ElRetro Gran Maja", "Strawberry Choc Megalodon", "Krampus Shark", "Emerald Winter Whale", "Winter Frost Shark", "Icebreaker Whale", "Leviathan", "Pirate Megalodon", "Viridis Lurker", "Cursed Kraken", "Ancient Magma Whale", "Rainbow Comet Shark", "Love Nessie"}
local StoneList = {"Ruby"}

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

local Settings = {SecretEnabled=false, RubyEnabled=false, MutationCrystalized=false, CaveCrystalEnabled=false, LeaveEnabled=false, PlayerNonPSAuto=false, ForeignDetection=false, SpoilerName=true, PingMonitor=false, AutoExecute=false, NoAnimation=false, RemoveVFX=false, DisablePopups=false, EvolvedEnabled=false}

task.spawn(function()
    Players.LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    pcall(function() for i,v in pairs(getconnections(Players.LocalPlayer.Idled)) do v:Disable() end end)
    print("NikeeHUB: Anti-AFK Active")
end)

local TagList = {}
for i = 1, 20 do TagList[i] = {"", ""} end
local SessionStart = tick()
local SessionStats = {Secret=0, Ruby=0, Evolved=0, Crystalized=0, CaveCrystal=0, TotalSent=0}

local function ShowNotification(msg, isError)
    if not ScriptActive then return end
    if MengHub and MengHub:MakeNotify then
        MengHub:MakeNotify({
            Title = isError and "Error" or "NikeeHUB",
            Description = isError and "Alert" or "Notification",
            Content = msg,
            Color = isError and Color3.fromRGB(235, 85, 85) or Color3.fromRGB(0, 139, 139),
            Delay = 3
        })
    end
end

local function TeleportToLookAt(position, lookVector)
    local Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
    local hrp = Character:WaitForChild("HumanoidRootPart", 5)
    if hrp and typeof(position) == "Vector3" and typeof(lookVector) == "Vector3" then
        hrp.CFrame = CFrame.new(position, position + lookVector) * CFrame.new(0, 3, 0)
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

local DetectorStuckEnabled, AutoShakeEnabled, AutoSellEnabled, SimpleWeatherEnabled, AutoTotemEnabled = false, false, false, false, false
local StuckThreshold, LastFishCount, StuckTimer, SavedCFrame = 15, 0, 0, nil
local SellValue = 600
local WeatherList = {"Wind", "Cloudy", "Storm"}
local TotemList = {"Luck Totem", "Mutation Totem", "Shiny Totem"}
local SelectedTotem = "Luck Totem"
local TotemMap = {["Luck Totem"]=1, ["Mutation Totem"]=2, ["Shiny Totem"]=3}
local WalkOnWaterEnabled, isNoAnimationActive, isVFXDisabled = false, false, false
local WaterPlatform, WalkConnection = nil, nil
local originalVFXHandle = require(ReplicatedStorage.Controllers.VFXController).Handle
local ServerTitle = "XALSCENT"

local Window = nil
if MengHub then
    Window = MengHub:Window({
        Title = "NikeeHUB",
        Footer = "FishIt",
        Color = Color3.fromRGB(0, 139, 139),
        Version = 1.0,
        Icon = "rbxassetid://80659354137631"
    })
    
    local Tab_ServerInfo = Window:AddTab({Name = "Server Info", Icon = "stat"})
    local Tab_Fhising = Window:AddTab({Name = "Fhising", Icon = "fish"})
    local Tab_Teleport = Window:AddTab({Name = "Teleport", Icon = "gps"})
    local Tab_Notification = Window:AddTab({Name = "Notification", Icon = "alert"})
    local Tab_AdminBoost = Window:AddTab({Name = "Admin Boost", Icon = "player"})
    local Tab_ListPlayer = Window:AddTab({Name = "List Player", Icon = "user"})
    local Tab_Setting = Window:AddTab({Name = "Setting", Icon = "settings"})
    local Tab_SaveConfig = Window:AddTab({Name = "Save Config", Icon = "bag"})
    
    local Section_Stats = Tab_ServerInfo:AddSection("Session Statistics", false)
    Section_Stats:AddParagraph({Title = "Uptime", Content = "Tracking..."})
    Section_Stats:AddParagraph({Title = "Secret Fish Caught", Content = "0"})
    Section_Stats:AddParagraph({Title = "Ruby Gemstones", Content = "0"})
    Section_Stats:AddPanel({Title = "Server Title", Placeholder = "Enter server title", Default = ServerTitle, ButtonText = "Update", ButtonCallback = function(v) ServerTitle = v end})
    Section_Stats:AddButton({Title = "Send Stats to Webhook", Callback = function()
        if Current_Webhook_Admin == "" then ShowNotification("Admin Webhook Empty!", true) return end
        ShowNotification("Sending Stats...", false)
        local diff = tick() - SessionStart
        local h, m, s = math.floor(diff / 3600), math.floor((diff % 3600) / 60), math.floor(diff % 60)
        local contentStr = string.format("📊 SERVER: %s\n⏱️ Uptime: %02dh %02dm %02ds\n📡 Total: %d\n⚓ Secrets: %d\n💎 Rubies: %d\n🔮 Evolved: %d\n✨ Crystalized: %d\n⛏️ Cave Crystals: %d", ServerTitle, h, m, s, SessionStats.TotalSent, SessionStats.Secret, SessionStats.Ruby, SessionStats.Evolved, SessionStats.Crystalized, SessionStats.CaveCrystal)
        task.spawn(function()
            local embed = {["username"] = "NikeeHUB Stats", ["avatar_url"] = "https://i.imgur.com/CWWGnhO.jpeg", ["embeds"] = {{["title"] = "Session Report", ["description"] = "```\n" .. contentStr .. "\n```", ["color"] = 5763719, ["footer"] = {["text"] = "NikeeHUB Webhook"}}}}
            pcall(function() httpRequest({Url = Current_Webhook_Admin, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode(embed)}) end)
        end)
    end})
    
    local Section_Fishing = Tab_Fhising:AddSection("Fishing Features", false)
    Section_Fishing:AddToggle({Title = "Detector Stuck (15s)", Content = "Auto reset when stuck", Default = false, Callback = function(state)
        DetectorStuckEnabled = state
        if state then
            LastFishCount, StuckTimer = getFishCount(), 0
            SavedCFrame = (Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart").CFrame
            task.spawn(function()
                while DetectorStuckEnabled and ScriptActive do
                    task.wait(1)
                    local currentFish = getFishCount()
                    if currentFish == LastFishCount then
                        StuckTimer = StuckTimer + 1
                        if StuckTimer >= StuckThreshold then
                            ShowNotification("Stuck Detected! Resetting...", true)
                            SavedCFrame = (Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart").CFrame
                            if Players.LocalPlayer.Character then Players.LocalPlayer.Character:BreakJoints() end
                            local newChar = Players.LocalPlayer.CharacterAdded:Wait()
                            local hrp = newChar:WaitForChild("HumanoidRootPart")
                            task.wait(0.5)
                            hrp.CFrame = SavedCFrame
                            StuckTimer, LastFishCount = 0, getFishCount()
                            local RE_Equip = GetRemote("RE/EquipToolFromHotbar")
                            if RE_Equip then pcall(function() RE_Equip:FireServer(1) end) end
                        end
                    else LastFishCount, StuckTimer = currentFish, 0 end
                end
            end)
        end
    end})
    Section_Fishing:AddToggle({Title = "Auto Click Fishing", Content = "Auto click during minigame", Default = false, Callback = function(val)
        AutoShakeEnabled = val
        if AutoShakeEnabled then
            task.spawn(function()
                while AutoShakeEnabled and ScriptActive do
                    pcall(function() FishingController:RequestFishingMinigameClick() end)
                    task.wait(0.1)
                end
            end)
        end
    end})
    Section_Fishing:AddToggle({Title = "Auto Sell (10m / 600 Items)", Content = "Auto sell fish", Default = false, Callback = function(state)
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
    end})
    Section_Fishing:AddToggle({Title = "Enable Auto Buy Weather", Content = "Auto buy weather changes", Default = false, Callback = function(state)
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
    end})
    Section_Fishing:AddToggle({Title = "Enable Auto Spawn Totem", Content = "Auto spawn totems", Default = false, Callback = function(state)
        AutoTotemEnabled = state
        if state then
            local RE_Spawn, RE_Equip = GetRemote("RE/SpawnTotem"), GetRemote("RE/EquipToolFromHotbar")
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
                    else ShowNotification("Totem UUID Not Found!", true) task.wait(5) end
                end
            end)
        end
    end})
    
    local Section_Teleport = Tab_Teleport:AddSection("Fishing Areas", false)
    local sortedAreas = {}
    for name, _ in pairs(FishingAreas) do table.insert(sortedAreas, name) end
    table.sort(sortedAreas)
    for _, areaName in ipairs(sortedAreas) do
        local data = FishingAreas[areaName]
        Section_Teleport:AddButton({Title = "📍 " .. areaName, Callback = function() TeleportToLookAt(data.Pos, data.Look) end})
    end
    
    local Section_Notif = Tab_Notification:AddSection("Notification Toggles", false)
    Section_Notif:AddToggle({Title = "Secret Fish Caught", Content = "Webhook on secret fish", Default = false, Callback = function(v) Settings.SecretEnabled = v end})
    Section_Notif:AddToggle({Title = "Ruby Gemstone", Content = "Webhook on ruby", Default = false, Callback = function(v) Settings.RubyEnabled = v end})
    Section_Notif:AddToggle({Title = "Cave Crystal", Content = "Webhook on cave crystal", Default = false, Callback = function(v) Settings.CaveCrystalEnabled = v end})
    Section_Notif:AddToggle({Title = "Evolved Enchant Stone", Content = "Webhook on evolved stone", Default = false, Callback = function(v) Settings.EvolvedEnabled = v end})
    Section_Notif:AddToggle({Title = "Mutation Crystalized", Content = "Webhook on crystalized", Default = false, Callback = function(v) Settings.MutationCrystalized = v end})
    
    local Section_Webhook = Tab_Notification:AddSection("Webhook URLs", false)
    Section_Webhook:AddPanel({Title = "Fish Caught Webhook", Placeholder = "https://discord.com/api/webhooks/...", Default = Current_Webhook_Fish, ButtonText = "Test", ButtonCallback = function(url)
        Current_Webhook_Fish = url
        if url == "" then ShowNotification("URL Empty!", true) return end
        ShowNotification("Sending Test...", false)
        task.spawn(function()
            local p = {content = "✅ **TEST:** Fish Connected!", username = "NikeeHUB", avatar_url = "https://i.imgur.com/CWWGnhO.jpeg"}
            local success, response = pcall(function() return httpRequest({Url = url, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode(p)}) end)
            if success and response and response.StatusCode < 300 then ShowNotification("Success!", false) else ShowNotification("Failed!", true) end
        end)
    end})
    Section_Webhook:AddPanel({Title = "Player Leave Webhook", Placeholder = "https://discord.com/api/webhooks/...", Default = Current_Webhook_Leave, ButtonText = "Test", ButtonCallback = function(url) Current_Webhook_Leave = url end})
    Section_Webhook:AddPanel({Title = "Player List Webhook", Placeholder = "https://discord.com/api/webhooks/...", Default = Current_Webhook_List, ButtonText = "Test", ButtonCallback = function(url) Current_Webhook_List = url end})
    Section_Webhook:AddPanel({Title = "Admin Host Webhook", Placeholder = "https://discord.com/api/webhooks/...", Default = Current_Webhook_Admin, ButtonText = "Test", ButtonCallback = function(url) Current_Webhook_Admin = url end})
    Section_Webhook:AddButton({Title = "Test All Connections", Callback = function()
        local c = 0
        if Current_Webhook_Fish ~= "" then task.spawn(function() pcall(function() httpRequest({Url = Current_Webhook_Fish, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode({content = "✅ **TEST:** Fish Connected!", username = "NikeeHUB", avatar_url = "https://i.imgur.com/CWWGnhO.jpeg"})}) end) end) c=c+1 end
        if Current_Webhook_Leave ~= "" then task.spawn(function() pcall(function() httpRequest({Url = Current_Webhook_Leave, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode({content = "✅ **TEST:** Leave Connected!", username = "NikeeHUB", avatar_url = "https://i.imgur.com/CWWGnhO.jpeg"})}) end) end) c=c+1 end
        if Current_Webhook_List ~= "" then task.spawn(function() pcall(function() httpRequest({Url = Current_Webhook_List, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode({content = "✅ **TEST:** List Connected!", username = "NikeeHUB", avatar_url = "https://i.imgur.com/CWWGnhO.jpeg"})}) end) end) c=c+1 end
        if Current_Webhook_Admin ~= "" then task.spawn(function() pcall(function() httpRequest({Url = Current_Webhook_Admin, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode({content = "✅ **TEST:** Admin Connected!", username = "NikeeHUB", avatar_url = "https://i.imgur.com/CWWGnhO.jpeg"})}) end) end) c=c+1 end
        if c == 0 then ShowNotification("No Webhooks Set!", true) end
    end})
    
    local Section_Admin = Tab_AdminBoost:AddSection("Admin Features", false)
    Section_Admin:AddToggle({Title = "Deteksi Player Asing", Content = "Detect foreign players", Default = false, Callback = function(v) Settings.ForeignDetection = v end})
    Section_Admin:AddToggle({Title = "Hide Player Name (Spoiler)", Content = "Hide names with spoiler", Default = true, Callback = function(v) Settings.SpoilerName = v end})
    Section_Admin:AddToggle({Title = "Lag Detector (Ping > 500ms)", Content = "Alert on high ping", Default = false, Callback = function(v) Settings.PingMonitor = v end})
    Section_Admin:AddToggle({Title = "Player Leave Server", Content = "Track player leave", Default = false, Callback = function(v) Settings.LeaveEnabled = v end})
    Section_Admin:AddToggle({Title = "Player Not On Server (30m)", Content = "Auto check missing players", Default = false, Callback = function(v) Settings.PlayerNonPSAuto = v end})
    local Section_AdminBtn = Tab_AdminBoost:AddSection("Manual Actions", false)
    Section_AdminBtn:AddButton({Title = "Player On Server", SubTitle = "Send List", Callback = function()
        if Current_Webhook_List == "" then ShowNotification("Webhook Missing!", true) return end
        ShowNotification("Sending List...", false)
        local all = Players:GetPlayers()
        local str = "Current Players (" .. #all .. "):\n\n"
        for i, p in ipairs(all) do str = str .. i .. ". " .. p.DisplayName .. " (@" .. p.Name .. ")\n" end
        task.spawn(function()
            local p = {["username"] = "NikeeHUB", ["avatar_url"] = "https://i.imgur.com/CWWGnhO.jpeg", ["embeds"] = {{["title"] = "Manual Player List", ["description"] = "```\n" .. str .. "\n```", ["color"] = 5763719, ["footer"] = {["text"] = "NikeeHUB Webhook"}}}}
            httpRequest({Url = Current_Webhook_List, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode(p)})
        end)
    end})
    Section_AdminBtn:AddButton({Title = "Player NOT On Server", SubTitle = "Check Missing", Callback = function()
        if Current_Webhook_List == "" then ShowNotification("Webhook Empty!", true) return end
        ShowNotification("Checking Players...", false)
        local current = {}
        for _, p in ipairs(Players:GetPlayers()) do current[string.lower(p.Name)] = true end
        local missingNames, missingTags = {}, {}
        for i = 1, 20 do
            local name, discId = TagList[i][1], TagList[i][2]
            if name ~= "" and not current[string.lower(name)] then
                table.insert(missingNames, name)
                if discId and discId ~= "" then table.insert(missingTags, "<@" .. discId .. ">") end
            end
        end
        local txt = "Missing Players (" .. #missingNames .. "):\n\n"
        if #missingNames == 0 then txt = "All tagged players are in the server!" else for i, v in ipairs(missingNames) do txt = txt .. i .. ". " .. v .. "\n" end end
        local contentMsg = ""
        if #missingTags > 0 then contentMsg = " **Peringatan:** " .. table.concat(missingTags, " ") .. " belum masuk server!" end
        task.spawn(function()
            local p = {["username"] = "NikeeHUB", ["avatar_url"] = "https://i.imgur.com/CWWGnhO.jpeg", ["content"] = contentMsg, ["embeds"] = {{["title"] = "Player Not On Server", ["description"] = "```\n" .. txt .. "\n```", ["color"] = 16733440, ["footer"] = {["text"] = "NikeeHUB Webhook"}}}}
            httpRequest({Url = Current_Webhook_List, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode(p)})
        end)
    end})
    
    local Section_PlayerList = Tab_ListPlayer:AddSection("Player Tag List (Max 20)", false)
    Section_PlayerList:AddParagraph({Title = "Instructions", Content = "Add up to 20 players with Discord IDs (Format: Username:DiscordID)"})
    for i = 1, 20 do
        local labelText = "List " .. i .. ":"
        if i == 1 then labelText = "Host 1:" end
        if i == 2 then labelText = "Host 2:" end
        Section_PlayerList:AddPanel({Title = labelText, Placeholder = "Username:DiscordID", Default = TagList[i][1] .. ":" .. TagList[i][2], ButtonText = "Save", ButtonCallback = function(val)
            local split = string.split(val, ":")
            TagList[i] = {split[1] or "", split[2] or ""}
            ShowNotification("Player " .. i .. " saved!", false)
        end})
    end
    Section_PlayerList:AddPanel({Title = "Bulk Import", Placeholder = "Username1:123456789\nUsername2:987654321", Default = "", ButtonText = "Import", ButtonCallback = function(text)
        local addedCount, currentIndex = 0, 3
        while currentIndex <= 20 and TagList[currentIndex][1] ~= "" do currentIndex = currentIndex + 1 end
        if currentIndex > 20 then ShowNotification("List Full!", true) return end
        for line in text:gmatch("[^\r\n]+") do
            if currentIndex > 20 then break end
            local split = string.split(line, ":")
            local user = (split[1] or ""):match("^%s*(.-)%s*$")
            local id = (split[2] or ""):match("^%s*(.-)%s*$")
            if user ~= "" then TagList[currentIndex] = {user, id} currentIndex = currentIndex + 1 addedCount = addedCount + 1 end
        end
        if addedCount > 0 then ShowNotification("Imported " .. addedCount .. " Players!", false) else ShowNotification("No Data Found!", true) end
    end})
    
    local Section_Settings = Tab_Setting:AddSection("Game Settings", false)
    Section_Settings:AddToggle({Title = "Walk On Water", Content = "Walk on water surface", Default = false, Callback = function(state)
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
                local res = workspace:Raycast(hrp.Position + Vector3.new(0, 5, 0), Vector3.new(0, -500, 0), params)
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
            if WalkConnection then WalkConnection:Disconnect() WalkConnection = nil end
            if WaterPlatform then WaterPlatform:Destroy() WaterPlatform = nil end
        end
    end})
    Section_Settings:AddToggle({Title = "Remove Fish Notification Pop-up", Content = "Disable in-game popups", Default = false, Callback = function(state)
        Settings.DisablePopups = state
        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
        local SmallNotification = PlayerGui:FindFirstChild("Small Notification")
        if state then
            if SmallNotification then task.spawn(function() while Settings.DisablePopups and ScriptActive do SmallNotification.Enabled = false task.wait(0.1) end end) end
            ShowNotification("Pop-up Blocked", false)
        else
            if SmallNotification then SmallNotification.Enabled = true end
            ShowNotification("Pop-up Enabled", false)
        end
    end})
    Section_Settings:AddToggle({Title = "No Animation", Content = "Disable animations", Default = false, Callback = function(state)
        isNoAnimationActive = state
        if state then
            local character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local animateScript = character:FindFirstChild("Animate")
                if animateScript then animateScript.Enabled = false end
                local animator = humanoid:FindFirstChildOfClass("Animator")
                if animator then animator:Destroy() end
            end
            ShowNotification("No Animation ON", false)
        else
            local character = Players.LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid and not humanoid:FindFirstChildOfClass("Animator") then Instance.new("Animator", humanoid) end
            ShowNotification("No Animation OFF", false)
        end
    end})
    Section_Settings:AddToggle({Title = "Remove Skin Effect", Content = "Disable VFX", Default = false, Callback = function(state)
        isVFXDisabled = state
        if state then
            local VFXControllerModule = require(ReplicatedStorage.Controllers.VFXController)
            VFXControllerModule.Handle = function(...) end
            VFXControllerModule.RenderAtPoint = function(...) end
            VFXControllerModule.RenderInstance = function(...) end
            local cosmeticFolder = workspace:FindFirstChild("CosmeticFolder")
            if cosmeticFolder then pcall(function() cosmeticFolder:ClearAllChildren() end) end
            ShowNotification("No Skin Effect ON", false)
        else
            VFXControllerModule.Handle = originalVFXHandle
            ShowNotification("Skin Effect Restored", false)
        end
    end})
    Section_Settings:AddToggle({Title = "Auto Execute on Server Hop", Content = "Auto run on teleport", Default = false, Callback = function(state) Settings.AutoExecute = state end})
    
    local Section_Save = Tab_SaveConfig:AddSection("Configuration", false)
    Section_Save:AddPanel({Title = "Save Config", Placeholder = "Config Name", Default = "", ButtonText = "Save", ButtonCallback = function(name)
        if name == "" then ShowNotification("Name cannot be empty!", true) return end
        local saveData = {
            Webhooks = {Fish = Current_Webhook_Fish, Leave = Current_Webhook_Leave, List = Current_Webhook_List, Admin = Current_Webhook_Admin},
            Players = TagList,
            Settings = Settings
        }
        local success, encodedData = pcall(function() return HttpService:JSONEncode(saveData) end)
        if not success then ShowNotification("Encoding Error!", true) return end
        local s, err = pcall(function()
            if not isfolder("Nikee_Configs") then makefolder("Nikee_Configs") end
            writefile("Nikee_Configs/" .. name .. ".json", encodedData)
        end)
        if s then ShowNotification("Config Saved!", false) else ShowNotification("Write Error: " .. tostring(err), true) end
    end})
    Section_Save:AddPanel({Title = "Load Config", Placeholder = "Config Name", Default = "", ButtonText = "Load", ButtonCallback = function(configName)
        local success, content = pcall(function() return readfile("Nikee_Configs/" .. configName .. ".json") end)
        if not success then ShowNotification("Read Failed!", true) return end
        local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(content) end)
        if decodeSuccess and data then
            if data.Webhooks then Current_Webhook_Fish, Current_Webhook_Leave, Current_Webhook_List, Current_Webhook_Admin = data.Webhooks.Fish or "", data.Webhooks.Leave or "", data.Webhooks.List or "", data.Webhooks.Admin or "" end
            if data.Players then TagList = data.Players end
            if data.Settings then for k, v in pairs(data.Settings) do if Settings[k] ~= nil then Settings[k] = v end end end
            ShowNotification("Config Loaded!", false)
        else ShowNotification("JSON Error!", true) end
    end})
    Section_Save:AddPanel({Title = "Delete Config", Placeholder = "Config Name", Default = "", ButtonText = "Delete", ButtonCallback = function(name)
        if isfile("Nikee_Configs/" .. name .. ".json") then
            delfile("Nikee_Configs/" .. name .. ".json")
            ShowNotification("Deleted!", false)
        else ShowNotification("Config Not Found!", true) end
    end})
end

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
                local id1, id2 = (TagList[1] and TagList[1][2]) or "", (TagList[2] and TagList[2][2]) or ""
                if id1 ~= "" then adminTags = adminTags .. "<@" .. id1 .. "> " end
                if id2 ~= "" then adminTags = adminTags .. "<@" .. id2 .. "> " end
                local embed = {["username"] = "NikeeHUB", ["avatar_url"] = "https://i.imgur.com/CWWGnhO.jpeg", ["content"] = adminTags ~= "" and "⚠️ " .. adminTags or "", ["embeds"] = {{["title"] = "Foreign Player Detected", ["description"] = "```\nPlayer: " .. p.Name .. "\nDisplay: " .. p.DisplayName .. "\n```", ["color"] = 16711680, ["footer"] = {["text"] = "NikeeHUB"}}}}
                pcall(function() httpRequest({Url = Current_Webhook_Admin, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode(embed)}) end)
            end)
        end
    end
end))

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
