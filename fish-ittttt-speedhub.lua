-- ============================================
-- NikeeHUB - FishIt Script (SpeedHub UI Version)
-- SpeedHubUI Library Embedded (No external file needed)
-- ============================================

-- ============================================
-- SPEEDHUB UI LIBRARY (EMBEDDED)
-- ============================================
local SpeedHubUI = (function()
    local HttpService = game:GetService("HttpService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Mouse = LocalPlayer:GetMouse()
    local CoreGui = game:GetService("CoreGui")
    local viewport = workspace.CurrentCamera.ViewportSize

    local ConfigPath = "Meng Hub/Config/"
    if not isfolder("Meng Hub") then makefolder("Meng Hub") end
    if not isfolder("Meng Hub/Config") then makefolder("Meng Hub/Config") end

    local ConfigData = {}
    local Elements = {}
    local CURRENT_VERSION = nil

    local function SaveConfig(name)
        local fileName = ConfigPath .. (name or "Default") .. ".json"
        if writefile then
            ConfigData._version = CURRENT_VERSION
            writefile(fileName, HttpService:JSONEncode(ConfigData))
        end
    end

    local function LoadConfigFromFile(name)
        local fileName = ConfigPath .. (name or "Default") .. ".json"
        if isfile and isfile(fileName) then
            local success, result = pcall(function()
                return HttpService:JSONDecode(readfile(fileName))
            end)
            if success and type(result) == "table" then
                ConfigData = result
                if LoadConfigElements then LoadConfigElements() end
                return true
            end
        end
        return false
    end

    function LoadConfigElements()
        for key, element in pairs(Elements) do
            local targetValue = ConfigData[key]
            if element.Set then
                if targetValue ~= nil then
                    element:Set(targetValue)
                else
                    if element.Type == "Toggle" then
                        element:Set(false)
                    elseif element.Type == "Slider" then
                        element:Set(element.Default or 0)
                    elseif element.Type == "Dropdown" then
                        element:Set(element.Default or "")
                    elseif element.Type == "Input" then
                        element:Set("")
                    end
                end
            end
        end
    end

    local Icons = {
        player = "rbxassetid://12120698352",
        web = "rbxassetid://137601480983962",
        bag = "rbxassetid://8601111810",
        shop = "rbxassetid://4985385964",
        cart = "rbxassetid://128874923961846",
        plug = "rbxassetid://137601480983962",
        settings = "rbxassetid://70386228443175",
        loop = "rbxassetid://122032243989747",
        gps = "rbxassetid://17824309485",
        compas = "rbxassetid://125300760963399",
        gamepad = "rbxassetid://84173963561612",
        boss = "rbxassetid://13132186360",
        scroll = "rbxassetid://114127804740858",
        menu = "rbxassetid://6340513838",
        crosshair = "rbxassetid://12614416478",
        user = "rbxassetid://108483430622128",
        stat = "rbxassetid://12094445329",
        eyes = "rbxassetid://14321059114",
        sword = "rbxassetid://82472368671405",
        discord = "rbxassetid://94434236999817",
        star = "rbxassetid://107005941750079",
        skeleton = "rbxassetid://17313330026",
        payment = "rbxassetid://18747025078",
        scan = "rbxassetid://109869955247116",
        alert = "rbxassetid://73186275216515",
        question = "rbxassetid://17510196486",
        idea = "rbxassetid://16833255748",
        strom = "rbxassetid://13321880293",
        water = "rbxassetid://100076212630732",
        dcs = "rbxassetid://15310731934",
        start = "rbxassetid://108886429866687",
        next = "rbxassetid://12662718374",
        rod = "rbxassetid://103247953194129",
        fish = "rbxassetid://97167558235554",
    }

    local function isMobileDevice()
        return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
    end
    local isMobile = isMobileDevice()

    local function safeSize(pxWidth, pxHeight)
        local scaleX = pxWidth / viewport.X
        local scaleY = pxHeight / viewport.Y
        if isMobile then
            if scaleX > 0.5 then scaleX = 0.5 end
            if scaleY > 0.3 then scaleY = 0.3 end
        end
        return UDim2.new(scaleX, 0, scaleY, 0)
    end

    local function MakeDraggable(topbarobject, object)
        local function CustomPos(topbarobject, object)
            local Dragging, DragInput, DragStart, StartPosition
            local function UpdatePos(input)
                local Delta = input.Position - DragStart
                local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
                local Tween = TweenService:Create(object, TweenInfo.new(0.2), { Position = pos })
                Tween:Play()
            end
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
                if input == DragInput and Dragging then UpdatePos(input) end
            end)
        end
        local function CustomSize(object)
            local Dragging, DragInput, DragStart, StartSize
            local minSizeX, minSizeY, defSizeX, defSizeY = 100, 100, isMobile and 470 or 640, isMobile and 270 or 400
            object.Size = UDim2.new(0, defSizeX, 0, defSizeY)
            local changesizeobject = Instance.new("Frame")
            changesizeobject.AnchorPoint = Vector2.new(1, 1)
            changesizeobject.BackgroundTransparency = 1
            changesizeobject.Size = UDim2.new(0, 40, 0, 40)
            changesizeobject.Position = UDim2.new(1, 20, 1, 20)
            changesizeobject.Name = "changesizeobject"
            changesizeobject.Parent = object
            local function UpdateSize(input)
                local Delta = input.Position - DragStart
                local newWidth = math.max(StartSize.X.Offset + Delta.X, minSizeX)
                local newHeight = math.max(StartSize.Y.Offset + Delta.Y, minSizeY)
                local Tween = TweenService:Create(object, TweenInfo.new(0.2), { Size = UDim2.new(0, newWidth, 0, newHeight) })
                Tween:Play()
            end
            changesizeobject.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    DragStart = input.Position
                    StartSize = object.Size
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then Dragging = false end
                    end)
                end
            end)
            changesizeobject.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then DragInput = input end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if input == DragInput and Dragging then UpdateSize(input) end
            end)
        end
        CustomSize(object)
        CustomPos(topbarobject, object)
    end

    function CircleClick(Button, X, Y)
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
            local Time = 0.5
            Circle:TweenSizeAndPosition(UDim2.new(0, Size, 0, Size), UDim2.new(0.5, -Size / 2, 0.5, -Size / 2), "Out", "Quad", Time, false, nil)
            for i = 1, 10 do
                Circle.ImageTransparency = Circle.ImageTransparency + 0.01
                wait(Time / 10)
            end
            Circle:Destroy()
        end)
    end

    local Menghub = {}

    function Menghub:MakeNotify(NotifyConfig)
        local NotifyConfig = NotifyConfig or {}
        NotifyConfig.Title = NotifyConfig.Title or "Meng Hub"
        NotifyConfig.Description = NotifyConfig.Description or "Notification"
        NotifyConfig.Content = NotifyConfig.Content or "Content"
        NotifyConfig.Color = NotifyConfig.Color or Color3.fromRGB(255, 0, 255)
        NotifyConfig.Time = NotifyConfig.Time or 0.5
        NotifyConfig.Delay = NotifyConfig.Delay or 5
        local NotifyFunction = {}
        spawn(function()
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
                NotifyLayout.BackgroundTransparency = 0.999
                NotifyLayout.BorderColor3 = Color3.fromRGB(0, 0, 0)
                NotifyLayout.BorderSizePixel = 0
                NotifyLayout.Position = UDim2.new(1, -30, 1, -30)
                NotifyLayout.Size = UDim2.new(0, 320, 1, 0)
                NotifyLayout.Name = "NotifyLayout"
                NotifyLayout.Parent = CoreGui.NotifyGui
                local Count = 0
                CoreGui.NotifyGui.NotifyLayout.ChildRemoved:Connect(function()
                    Count = 0
                    for i, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
                        TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Position = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 12) * Count)) }):Play()
                        Count = Count + 1
                    end
                end)
            end
            local NotifyPosHeigh = 0
            for i, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
                NotifyPosHeigh = -(v.Position.Y.Offset) + v.Size.Y.Offset + 12
            end
            local NotifyFrame = Instance.new("Frame")
            NotifyFrame.BackgroundColor3 = Color3.fromRGB(29, 30, 35)
            NotifyFrame.BorderColor3 = Color3.fromRGB(29, 30, 35)
            NotifyFrame.BorderSizePixel = 0
            NotifyFrame.Size = UDim2.new(1, 0, 0, 150)
            NotifyFrame.Name = "NotifyFrame"
            NotifyFrame.BackgroundTransparency = 1
            NotifyFrame.Parent = CoreGui.NotifyGui.NotifyLayout
            NotifyFrame.AnchorPoint = Vector2.new(0, 1)
            NotifyFrame.Position = UDim2.new(0, 0, 1, -(NotifyPosHeigh))
            local NotifyFrameReal = Instance.new("Frame")
            NotifyFrameReal.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            NotifyFrameReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
            NotifyFrameReal.BorderSizePixel = 0
            NotifyFrameReal.Position = UDim2.new(0, 400, 0, 0)
            NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
            NotifyFrameReal.Name = "NotifyFrameReal"
            NotifyFrameReal.Parent = NotifyFrame
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 8)
            UICorner.Parent = NotifyFrameReal
            local DropShadowHolder = Instance.new("Frame")
            DropShadowHolder.BackgroundTransparency = 1
            DropShadowHolder.BorderSizePixel = 0
            DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
            DropShadowHolder.ZIndex = 0
            DropShadowHolder.Name = "DropShadowHolder"
            DropShadowHolder.Parent = NotifyFrameReal
            local Top = Instance.new("Frame")
            Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Top.BackgroundTransparency = 0.999
            Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Top.BorderSizePixel = 0
            Top.Size = UDim2.new(1, 0, 0, 36)
            Top.Name = "Top"
            Top.Parent = NotifyFrameReal
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.Text = NotifyConfig.Title
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 14
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 0.999
            TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TextLabel.BorderSizePixel = 0
            TextLabel.Size = UDim2.new(1, 0, 1, 0)
            TextLabel.Parent = Top
            TextLabel.Position = UDim2.new(0, 10, 0, 0)
            local UICorner1 = Instance.new("UICorner")
            UICorner1.CornerRadius = UDim.new(0, 5)
            UICorner1.Parent = Top
            local TextLabel1 = Instance.new("TextLabel")
            TextLabel1.Font = Enum.Font.GothamBold
            TextLabel1.Text = NotifyConfig.Description
            TextLabel1.TextColor3 = NotifyConfig.Color
            TextLabel1.TextSize = 14
            TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel1.BackgroundTransparency = 0.999
            TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TextLabel1.BorderSizePixel = 0
            TextLabel1.Size = UDim2.new(1, 0, 1, 0)
            TextLabel1.Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
            TextLabel1.Parent = Top
            local Close = Instance.new("TextButton")
            Close.Font = Enum.Font.SourceSans
            Close.Text = ""
            Close.TextColor3 = Color3.fromRGB(0, 0, 0)
            Close.TextSize = 14
            Close.AnchorPoint = Vector2.new(1, 0.5)
            Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Close.BackgroundTransparency = 0.999
            Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Close.BorderSizePixel = 0
            Close.Position = UDim2.new(1, -5, 0.5, 0)
            Close.Size = UDim2.new(0, 25, 0, 25)
            Close.Name = "Close"
            Close.Parent = Top
            local ImageLabel = Instance.new("ImageLabel")
            ImageLabel.Image = "rbxassetid://9886659671"
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ImageLabel.BackgroundTransparency = 0.999
            ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ImageLabel.BorderSizePixel = 0
            ImageLabel.Position = UDim2.new(0.49, 0, 0.5, 0)
            ImageLabel.Size = UDim2.new(1, -8, 1, -8)
            ImageLabel.Parent = Close
            local TextLabel2 = Instance.new("TextLabel")
            TextLabel2.Font = Enum.Font.GothamBold
            TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel2.TextSize = 13
            TextLabel2.Text = NotifyConfig.Content
            TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
            TextLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel2.BackgroundTransparency = 0.999
            TextLabel2.TextColor3 = Color3.fromRGB(150, 150, 150)
            TextLabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TextLabel2.BorderSizePixel = 0
            TextLabel2.Position = UDim2.new(0, 10, 0, 27)
            TextLabel2.Parent = NotifyFrameReal
            TextLabel2.Size = UDim2.new(1, -20, 0, 13)
            TextLabel2.Size = UDim2.new(1, -20, 0, 13 + (13 * (TextLabel2.TextBounds.X // TextLabel2.AbsoluteSize.X)))
            TextLabel2.TextWrapped = true
            if TextLabel2.AbsoluteSize.Y < 27 then
                NotifyFrame.Size = UDim2.new(1, 0, 0, 65)
            else
                NotifyFrame.Size = UDim2.new(1, 0, 0, TextLabel2.AbsoluteSize.Y + 40)
            end
            local waitbruh = false
            function NotifyFunction:Close()
                if waitbruh then return false end
                waitbruh = true
                TweenService:Create(NotifyFrameReal, TweenInfo.new(tonumber(NotifyConfig.Time), Enum.EasingStyle.Back, Enum.EasingDirection.InOut), { Position = UDim2.new(0, 400, 0, 0) }):Play()
                task.wait(tonumber(NotifyConfig.Time) / 1.2)
                NotifyFrame:Destroy()
            end
            Close.Activated:Connect(function() NotifyFunction:Close() end)
            TweenService:Create(NotifyFrameReal, TweenInfo.new(tonumber(NotifyConfig.Time), Enum.EasingStyle.Back, Enum.EasingDirection.InOut), { Position = UDim2.new(0, 0, 0, 0) }):Play()
            task.wait(tonumber(NotifyConfig.Delay))
            NotifyFunction:Close()
        end)
        return NotifyFunction
    end

    function Menghub:Window(GuiConfig)
        GuiConfig = GuiConfig or {}
        GuiConfig.Title = GuiConfig.Title or "Meng Hub"
        GuiConfig.Footer = GuiConfig.Footer or "MengHub >:D"
        GuiConfig.Color = GuiConfig.Color or Color3.fromRGB(255, 0, 255)
        GuiConfig["Tab Width"] = GuiConfig["Tab Width"] or 120
        GuiConfig.Version = GuiConfig.Version or 1
        GuiConfig.Image = GuiConfig.Image or "rbxassetid://0"
        CURRENT_VERSION = GuiConfig.Version
        local GuiFunc = {}
        local Menghubb = Instance.new("ScreenGui")
        Menghubb.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        Menghubb.Name = "Menghubb"
        Menghubb.ResetOnSpawn = false
        Menghubb.Parent = CoreGui
        local DropShadowHolder = Instance.new("Frame")
        DropShadowHolder.BackgroundTransparency = 1
        DropShadowHolder.BorderSizePixel = 0
        DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
        DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
        DropShadowHolder.Size = safeSize(640, 400)
        DropShadowHolder.ZIndex = 0
        DropShadowHolder.Name = "DropShadowHolder"
        DropShadowHolder.Parent = Menghubb
        local DropShadow = Instance.new("ImageLabel")
        DropShadow.Image = "rbxassetid://6015897843"
        DropShadow.ImageColor3 = Color3.fromRGB(15, 15, 15)
        DropShadow.ImageTransparency = 1
        DropShadow.ScaleType = Enum.ScaleType.Slice
        DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
        DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        DropShadow.BackgroundTransparency = 1
        DropShadow.BorderSizePixel = 0
        DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        DropShadow.Size = UDim2.new(1, 47, 1, 47)
        DropShadow.ZIndex = 0
        DropShadow.Name = "DropShadow"
        DropShadow.Parent = DropShadowHolder
        local Main = Instance.new("Frame")
        Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Main.BackgroundTransparency = 0.1
        Main.AnchorPoint = Vector2.new(0.5, 0.5)
        Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Main.BorderSizePixel = 0
        Main.Position = UDim2.new(0.5, 0, 0.5, 0)
        Main.Size = UDim2.new(1, -47, 1, -47)
        Main.Name = "Main"
        Main.Parent = DropShadow
        local UICorner = Instance.new("UICorner")
        UICorner.Parent = Main
        local Top = Instance.new("Frame")
        Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Top.BackgroundTransparency = 0.999
        Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Top.BorderSizePixel = 0
        Top.Size = UDim2.new(1, 0, 0, 38)
        Top.Name = "Top"
        Top.Parent = Main
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.Text = GuiConfig.Title
        TitleLabel.TextColor3 = GuiConfig.Color
        TitleLabel.TextSize = 14
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TitleLabel.BackgroundTransparency = 0.999
        TitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TitleLabel.BorderSizePixel = 0
        TitleLabel.Size = UDim2.new(1, -100, 1, 0)
        TitleLabel.Position = UDim2.new(0, 10, 0, 0)
        TitleLabel.Parent = Top
        local UICorner1 = Instance.new("UICorner")
        UICorner1.Parent = Top
        local FooterLabel = Instance.new("TextLabel")
        FooterLabel.Font = Enum.Font.GothamBold
        FooterLabel.Text = GuiConfig.Footer
        FooterLabel.TextColor3 = GuiConfig.Color
        FooterLabel.TextSize = 14
        FooterLabel.TextXAlignment = Enum.TextXAlignment.Left
        FooterLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        FooterLabel.BackgroundTransparency = 0.999
        FooterLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        FooterLabel.BorderSizePixel = 0
        FooterLabel.Size = UDim2.new(1, -(TitleLabel.TextBounds.X + 104), 1, 0)
        FooterLabel.Position = UDim2.new(0, TitleLabel.TextBounds.X + 15, 0, 0)
        FooterLabel.Parent = Top
        local Close = Instance.new("TextButton")
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
        Close.Name = "Close"
        Close.Parent = Top
        local CloseIcon = Instance.new("ImageLabel")
        CloseIcon.Image = "rbxassetid://9886659671"
        CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        CloseIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        CloseIcon.BackgroundTransparency = 0.999
        CloseIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
        CloseIcon.BorderSizePixel = 0
        CloseIcon.Position = UDim2.new(0.49, 0, 0.5, 0)
        CloseIcon.Size = UDim2.new(1, -8, 1, -8)
        CloseIcon.Parent = Close
        local Min = Instance.new("TextButton")
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
        Min.Name = "Min"
        Min.Parent = Top
        local MinIcon = Instance.new("ImageLabel")
        MinIcon.Image = "rbxassetid://9886659276"
        MinIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        MinIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        MinIcon.BackgroundTransparency = 0.999
        MinIcon.ImageTransparency = 0.2
        MinIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
        MinIcon.BorderSizePixel = 0
        MinIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
        MinIcon.Size = UDim2.new(1, -9, 1, -9)
        MinIcon.Parent = Min
        local LayersTab = Instance.new("Frame")
        LayersTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        LayersTab.BackgroundTransparency = 0.999
        LayersTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LayersTab.BorderSizePixel = 0
        LayersTab.Position = UDim2.new(0, 9, 0, 50)
        LayersTab.Size = UDim2.new(0, GuiConfig["Tab Width"], 1, -59)
        LayersTab.Name = "LayersTab"
        LayersTab.Parent = Main
        local UICorner2 = Instance.new("UICorner")
        UICorner2.CornerRadius = UDim.new(0, 2)
        UICorner2.Parent = LayersTab
        local DecideFrame = Instance.new("Frame")
        DecideFrame.AnchorPoint = Vector2.new(0.5, 0)
        DecideFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DecideFrame.BackgroundTransparency = 0.85
        DecideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        DecideFrame.BorderSizePixel = 0
        DecideFrame.Position = UDim2.new(0.5, 0, 0, 38)
        DecideFrame.Size = UDim2.new(1, 0, 0, 1)
        DecideFrame.Name = "DecideFrame"
        DecideFrame.Parent = Main
        local Layers = Instance.new("Frame")
        Layers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Layers.BackgroundTransparency = 0.999
        Layers.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Layers.BorderSizePixel = 0
        Layers.Position = UDim2.new(0, GuiConfig["Tab Width"] + 18, 0, 50)
        Layers.Size = UDim2.new(1, -(GuiConfig["Tab Width"] + 9 + 18), 1, -59)
        Layers.Name = "Layers"
        Layers.Parent = Main
        local UICorner6 = Instance.new("UICorner")
        UICorner6.CornerRadius = UDim.new(0, 2)
        UICorner6.Parent = Layers
        local NameTab = Instance.new("TextLabel")
        NameTab.Font = Enum.Font.GothamBold
        NameTab.Text = ""
        NameTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        NameTab.TextSize = 24
        NameTab.TextWrapped = true
        NameTab.TextXAlignment = Enum.TextXAlignment.Left
        NameTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NameTab.BackgroundTransparency = 0.999
        NameTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NameTab.BorderSizePixel = 0
        NameTab.Size = UDim2.new(1, 0, 0, 30)
        NameTab.Name = "NameTab"
        NameTab.Parent = Layers
        local LayersReal = Instance.new("Frame")
        LayersReal.AnchorPoint = Vector2.new(0, 1)
        LayersReal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        LayersReal.BackgroundTransparency = 0.999
        LayersReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LayersReal.BorderSizePixel = 0
        LayersReal.ClipsDescendants = true
        LayersReal.Position = UDim2.new(0, 0, 1, 0)
        LayersReal.Size = UDim2.new(1, 0, 1, -33)
        LayersReal.Name = "LayersReal"
        LayersReal.Parent = Layers
        local LayersFolder = Instance.new("Folder")
        LayersFolder.Name = "LayersFolder"
        LayersFolder.Parent = LayersReal
        local LayersPageLayout = Instance.new("UIPageLayout")
        LayersPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LayersPageLayout.Name = "LayersPageLayout"
        LayersPageLayout.Parent = LayersFolder
        LayersPageLayout.TweenTime = 0.5
        LayersPageLayout.EasingDirection = Enum.EasingDirection.InOut
        LayersPageLayout.EasingStyle = Enum.EasingStyle.Quad
        local ScrollTab = Instance.new("ScrollingFrame")
        ScrollTab.CanvasSize = UDim2.new(0, 0, 1.1, 0)
        ScrollTab.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
        ScrollTab.ScrollBarThickness = 0
        ScrollTab.Active = true
        ScrollTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ScrollTab.BackgroundTransparency = 0.999
        ScrollTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ScrollTab.BorderSizePixel = 0
        ScrollTab.Size = UDim2.new(1, 0, 1, 0)
        ScrollTab.Name = "ScrollTab"
        ScrollTab.Parent = LayersTab
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 3)
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = ScrollTab
        local function UpdateSize1()
            local OffsetY = 0
            for _, child in ScrollTab:GetChildren() do
                if child.Name ~= "UIListLayout" then
                    OffsetY = OffsetY + 3 + child.Size.Y.Offset
                end
            end
            ScrollTab.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
        end
        ScrollTab.ChildAdded:Connect(UpdateSize1)
        ScrollTab.ChildRemoved:Connect(UpdateSize1)
        function GuiFunc:DestroyGui()
            if CoreGui:FindFirstChild("Menghubb") then
                Menghubb:Destroy()
            end
        end
        Min.Activated:Connect(function()
            CircleClick(Min, Mouse.X, Mouse.Y)
            DropShadowHolder.Visible = false
        end)
        Close.Activated:Connect(function()
            CircleClick(Close, Mouse.X, Mouse.Y)
            GuiFunc:DestroyGui()
            if CoreGui:FindFirstChild("ToggleUIButton") then
                CoreGui.ToggleUIButton:Destroy()
            end
        end)
        local ToggleKey = Enum.KeyCode.F3
        UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == ToggleKey then
                if DropShadowHolder then
                    DropShadowHolder.Visible = not DropShadowHolder.Visible
                end
            end
        end)
        function GuiFunc:ToggleUI()
            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Parent = CoreGui
            ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            ScreenGui.Name = "ToggleUIButton"
            local MainButton = Instance.new("ImageLabel")
            MainButton.Parent = ScreenGui
            MainButton.Size = UDim2.new(0, 40, 0, 40)
            MainButton.Position = UDim2.new(0, 20, 0, 100)
            MainButton.BackgroundTransparency = 1
            MainButton.Image = "rbxassetid://" .. GuiConfig.Image
            MainButton.ScaleType = Enum.ScaleType.Fit
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = MainButton
            local Button = Instance.new("TextButton")
            Button.Parent = MainButton
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.BackgroundTransparency = 1
            Button.Text = ""
            Button.MouseButton1Click:Connect(function()
                if DropShadowHolder then
                    DropShadowHolder.Visible = not DropShadowHolder.Visible
                end
            end)
            local dragging = false
            local dragStart, startPos
            local function update(input)
                local delta = input.Position - dragStart
                MainButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
            Button.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = MainButton.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input)
                end
            end)
        end
        GuiFunc:ToggleUI()
        DropShadowHolder.Size = UDim2.new(0, 115 + TitleLabel.TextBounds.X + 1 + FooterLabel.TextBounds.X, 0, 350)
        MakeDraggable(Top, DropShadowHolder)
        local Tabs = {}
        local CountTab = 0
        function Tabs:AddTab(TabConfig)
            local TabConfig = TabConfig or {}
            TabConfig.Name = TabConfig.Name or "Tab"
            TabConfig.Icon = TabConfig.Icon or ""
            local ScrolLayers = Instance.new("ScrollingFrame")
            ScrolLayers.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
            ScrolLayers.ScrollBarThickness = 0
            ScrolLayers.Active = true
            ScrolLayers.LayoutOrder = CountTab
            ScrolLayers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ScrolLayers.BackgroundTransparency = 0.999
            ScrolLayers.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ScrolLayers.BorderSizePixel = 0
            ScrolLayers.Size = UDim2.new(1, 0, 1, 0)
            ScrolLayers.Name = "ScrolLayers"
            ScrolLayers.Parent = LayersFolder
            local UIListLayout1 = Instance.new("UIListLayout")
            UIListLayout1.Padding = UDim.new(0, 3)
            UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout1.Parent = ScrolLayers
            local Tab = Instance.new("Frame")
            Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Tab.BackgroundTransparency = CountTab == 0 and 0.92 or 0.999
            Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Tab.BorderSizePixel = 0
            Tab.LayoutOrder = CountTab
            Tab.Size = UDim2.new(1, 0, 0, 30)
            Tab.Name = "Tab"
            Tab.Parent = ScrollTab
            local UICorner3 = Instance.new("UICorner")
            UICorner3.CornerRadius = UDim.new(0, 4)
            UICorner3.Parent = Tab
            local TabButton = Instance.new("TextButton")
            TabButton.Font = Enum.Font.GothamBold
            TabButton.Text = ""
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabButton.TextSize = 13
            TabButton.TextXAlignment = Enum.TextXAlignment.Left
            TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TabButton.BackgroundTransparency = 0.999
            TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TabButton.BorderSizePixel = 0
            TabButton.Size = UDim2.new(1, 0, 1, 0)
            TabButton.Name = "TabButton"
            TabButton.Parent = Tab
            local TabName = Instance.new("TextLabel")
            TabName.Font = Enum.Font.GothamBold
            TabName.Text = "| " .. tostring(TabConfig.Name)
            TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabName.TextSize = 13
            TabName.TextXAlignment = Enum.TextXAlignment.Left
            TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TabName.BackgroundTransparency = 0.999
            TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TabName.BorderSizePixel = 0
            TabName.Size = UDim2.new(1, 0, 1, 0)
            TabName.Position = UDim2.new(0, 30, 0, 0)
            TabName.Name = "TabName"
            TabName.Parent = Tab
            local FeatureImg = Instance.new("ImageLabel")
            FeatureImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            FeatureImg.BackgroundTransparency = 0.999
            FeatureImg.BorderColor3 = Color3.fromRGB(0, 0, 0)
            FeatureImg.BorderSizePixel = 0
            FeatureImg.Position = UDim2.new(0, 9, 0, 7)
            FeatureImg.Size = UDim2.new(0, 16, 0, 16)
            FeatureImg.Name = "FeatureImg"
            FeatureImg.Parent = Tab
            if CountTab == 0 then
                LayersPageLayout:JumpToIndex(0)
                NameTab.Text = TabConfig.Name
                local ChooseFrame = Instance.new("Frame")
                ChooseFrame.BackgroundColor3 = GuiConfig.Color
                ChooseFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ChooseFrame.BorderSizePixel = 0
                ChooseFrame.Position = UDim2.new(0, 2, 0, 9)
                ChooseFrame.Size = UDim2.new(0, 1, 0, 12)
                ChooseFrame.Name = "ChooseFrame"
                ChooseFrame.Parent = Tab
                local UIStroke2 = Instance.new("UIStroke")
                UIStroke2.Color = GuiConfig.Color
                UIStroke2.Thickness = 1.6
                UIStroke2.Parent = ChooseFrame
                local UICorner4 = Instance.new("UICorner")
                UICorner4.Parent = ChooseFrame
            end
            if TabConfig.Icon ~= "" then
                if Icons[TabConfig.Icon] then
                    FeatureImg.Image = Icons[TabConfig.Icon]
                else
                    FeatureImg.Image = TabConfig.Icon
                end
            end
            TabButton.Activated:Connect(function()
                CircleClick(TabButton, Mouse.X, Mouse.Y)
                local FrameChoose
                for a, s in ScrollTab:GetChildren() do
                    for i, v in s:GetChildren() do
                        if v.Name == "ChooseFrame" then
                            FrameChoose = v
                            break
                        end
                    end
                end
                if FrameChoose ~= nil and Tab.LayoutOrder ~= LayersPageLayout.CurrentPage.LayoutOrder then
                    for _, TabFrame in ScrollTab:GetChildren() do
                        if TabFrame.Name == "Tab" then
                            TweenService:Create(TabFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), { BackgroundTransparency = 0.999 }):Play()
                        end
                    end
                    TweenService:Create(Tab, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), { BackgroundTransparency = 0.92 }):Play()
                    TweenService:Create(FrameChoose, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Position = UDim2.new(0, 2, 0, 9 + (33 * Tab.LayoutOrder)) }):Play()
                    LayersPageLayout:JumpToIndex(Tab.LayoutOrder)
                    task.wait(0.05)
                    NameTab.Text = TabConfig.Name
                    TweenService:Create(FrameChoose, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Size = UDim2.new(0, 1, 0, 20) }):Play()
                    task.wait(0.2)
                    TweenService:Create(FrameChoose, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Size = UDim2.new(0, 1, 0, 12) }):Play()
                end
            end)
            local Sections = {}
            local CountSection = 0
            function Sections:AddSection(Title, AlwaysOpen)
                local Title = Title or "Title"
                local Section = Instance.new("Frame")
                Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Section.BackgroundTransparency = 0.999
                Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Section.BorderSizePixel = 0
                Section.LayoutOrder = CountSection
                Section.ClipsDescendants = true
                Section.LayoutOrder = 1
                Section.Size = UDim2.new(1, 0, 0, 30)
                Section.Name = "Section"
                Section.Parent = ScrolLayers
                local SectionReal = Instance.new("Frame")
                SectionReal.AnchorPoint = Vector2.new(0.5, 0)
                SectionReal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SectionReal.BackgroundTransparency = 0.935
                SectionReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SectionReal.BorderSizePixel = 0
                SectionReal.LayoutOrder = 1
                SectionReal.Position = UDim2.new(0.5, 0, 0, 0)
                SectionReal.Size = UDim2.new(1, 1, 0, 30)
                SectionReal.Name = "SectionReal"
                SectionReal.Parent = Section
                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = SectionReal
                local SectionButton = Instance.new("TextButton")
                SectionButton.Font = Enum.Font.SourceSans
                SectionButton.Text = ""
                SectionButton.TextColor3 = Color3.fromRGB(0, 0, 0)
                SectionButton.TextSize = 14
                SectionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SectionButton.BackgroundTransparency = 0.999
                SectionButton.BorderSizePixel = 0
                SectionButton.Size = UDim2.new(1, 0, 1, 0)
                SectionButton.Name = "SectionButton"
                SectionButton.Parent = SectionReal
                local FeatureFrame = Instance.new("Frame")
                FeatureFrame.AnchorPoint = Vector2.new(1, 0.5)
                FeatureFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                FeatureFrame.BackgroundTransparency = 0.999
                FeatureFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                FeatureFrame.BorderSizePixel = 0
                FeatureFrame.Position = UDim2.new(1, -5, 0.5, 0)
                FeatureFrame.Size = UDim2.new(0, 20, 0, 20)
                FeatureFrame.Name = "FeatureFrame"
                FeatureFrame.Parent = SectionReal
                local FeatureImg = Instance.new("ImageLabel")
                FeatureImg.Image = "rbxassetid://16851841101"
                FeatureImg.AnchorPoint = Vector2.new(0.5, 0.5)
                FeatureImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                FeatureImg.BackgroundTransparency = 0.999
                FeatureImg.BorderColor3 = Color3.fromRGB(0, 0, 0)
                FeatureImg.BorderSizePixel = 0
                FeatureImg.Position = UDim2.new(0.5, 0, 0.5, 0)
                FeatureImg.Rotation = -90
                FeatureImg.Size = UDim2.new(1, 6, 1, 6)
                FeatureImg.Name = "FeatureImg"
                FeatureImg.Parent = FeatureFrame
                local SectionTitle = Instance.new("TextLabel")
                SectionTitle.Font = Enum.Font.GothamBold
                SectionTitle.Text = Title
                SectionTitle.TextColor3 = Color3.fromRGB(231, 231, 231)
                SectionTitle.TextSize = 13
                SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
                SectionTitle.TextYAlignment = Enum.TextYAlignment.Top
                SectionTitle.AnchorPoint = Vector2.new(0, 0.5)
                SectionTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SectionTitle.BackgroundTransparency = 0.999
                SectionTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SectionTitle.BorderSizePixel = 0
                SectionTitle.Position = UDim2.new(0, 10, 0.5, 0)
                SectionTitle.Size = UDim2.new(1, -50, 0, 13)
                SectionTitle.Name = "SectionTitle"
                SectionTitle.Parent = SectionReal
                local SectionDecideFrame = Instance.new("Frame")
                SectionDecideFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SectionDecideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SectionDecideFrame.AnchorPoint = Vector2.new(0.5, 0)
                SectionDecideFrame.BorderSizePixel = 0
                SectionDecideFrame.Position = UDim2.new(0.5, 0, 0, 33)
                SectionDecideFrame.Size = UDim2.new(0, 0, 0, 2)
                SectionDecideFrame.Name = "SectionDecideFrame"
                SectionDecideFrame.Parent = Section
                local UICorner1 = Instance.new("UICorner")
                UICorner1.Parent = SectionDecideFrame
                local UIGradient = Instance.new("UIGradient")
                UIGradient.Color = ColorSequence.new {
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
                    ColorSequenceKeypoint.new(0.5, GuiConfig.Color),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
                }
                UIGradient.Parent = SectionDecideFrame
                local SectionAdd = Instance.new("Frame")
                SectionAdd.AnchorPoint = Vector2.new(0.5, 0)
                SectionAdd.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SectionAdd.BackgroundTransparency = 0.999
                SectionAdd.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SectionAdd.BorderSizePixel = 0
                SectionAdd.ClipsDescendants = true
                SectionAdd.LayoutOrder = 1
                SectionAdd.Position = UDim2.new(0.5, 0, 0, 38)
                SectionAdd.Size = UDim2.new(1, 0, 0, 100)
                SectionAdd.Name = "SectionAdd"
                SectionAdd.Parent = Section
                local UICorner8 = Instance.new("UICorner")
                UICorner8.CornerRadius = UDim.new(0, 2)
                UICorner8.Parent = SectionAdd
                local UIListLayout2 = Instance.new("UIListLayout")
                UIListLayout2.Padding = UDim.new(0, 3)
                UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout2.Parent = SectionAdd
                local OpenSection = false
                local function UpdateSizeScroll()
                    local OffsetY = 0
                    for _, child in ScrolLayers:GetChildren() do
                        if child.Name ~= "UIListLayout" then
                            OffsetY = OffsetY + 3 + child.Size.Y.Offset
                        end
                    end
                    ScrolLayers.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
                end
                local function UpdateSizeSection()
                    if OpenSection then
                        local SectionSizeYWidth = 38
                        for _, v in SectionAdd:GetChildren() do
                            if v.Name ~= "UIListLayout" and v.Name ~= "UICorner" then
                                SectionSizeYWidth = SectionSizeYWidth + v.Size.Y.Offset + 3
                            end
                        end
                        TweenService:Create(FeatureFrame, TweenInfo.new(0.5), { Rotation = 90 }):Play()
                        TweenService:Create(Section, TweenInfo.new(0.5), { Size = UDim2.new(1, 1, 0, SectionSizeYWidth) }):Play()
                        TweenService:Create(SectionAdd, TweenInfo.new(0.5), { Size = UDim2.new(1, 0, 0, SectionSizeYWidth - 38) }):Play()
                        TweenService:Create(SectionDecideFrame, TweenInfo.new(0.5), { Size = UDim2.new(1, 0, 0, 2) }):Play()
                        task.wait(0.5)
                        UpdateSizeScroll()
                    end
                end
                if AlwaysOpen == true then
                    SectionButton:Destroy()
                    FeatureFrame:Destroy()
                    OpenSection = true
                    UpdateSizeSection()
                elseif AlwaysOpen == false then
                    OpenSection = true
                    UpdateSizeSection()
                else
                    OpenSection = false
                end
                if AlwaysOpen ~= true then
                    SectionButton.Activated:Connect(function()
                        CircleClick(SectionButton, Mouse.X, Mouse.Y)
                        if OpenSection then
                            TweenService:Create(FeatureFrame, TweenInfo.new(0.5), { Rotation = 0 }):Play()
                            TweenService:Create(Section, TweenInfo.new(0.5), { Size = UDim2.new(1, 1, 0, 30) }):Play()
                            TweenService:Create(SectionDecideFrame, TweenInfo.new(0.5), { Size = UDim2.new(0, 0, 0, 2) }):Play()
                            OpenSection = false
                            task.wait(0.5)
                            UpdateSizeScroll()
                        else
                            OpenSection = true
                            UpdateSizeSection()
                        end
                    end)
                end
                if AlwaysOpen == true or AlwaysOpen == false then
                    OpenSection = true
                    local SectionSizeYWidth = 38
                    for _, v in SectionAdd:GetChildren() do
                        if v.Name ~= "UIListLayout" and v.Name ~= "UICorner" then
                            SectionSizeYWidth = SectionSizeYWidth + v.Size.Y.Offset + 3
                        end
                    end
                    FeatureFrame.Rotation = 90
                    Section.Size = UDim2.new(1, 1, 0, SectionSizeYWidth)
                    SectionAdd.Size = UDim2.new(1, 0, 0, SectionSizeYWidth - 38)
                    SectionDecideFrame.Size = UDim2.new(1, 0, 0, 2)
                    UpdateSizeScroll()
                end
                SectionAdd.ChildAdded:Connect(UpdateSizeSection)
                SectionAdd.ChildRemoved:Connect(UpdateSizeSection)
                local layout = ScrolLayers:FindFirstChildOfClass("UIListLayout")
                if layout then
                    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                        ScrolLayers.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
                    end)
                end
                local Items = {}
                local CountItem = 0
                function Items:AddToggle(ToggleConfig)
                    local ToggleConfig = ToggleConfig or {}
                    ToggleConfig.Title = ToggleConfig.Title or "Title"
                    ToggleConfig.Title2 = ToggleConfig.Title2 or ""
                    ToggleConfig.Content = ToggleConfig.Content or ""
                    ToggleConfig.Default = ToggleConfig.Default or false
                    ToggleConfig.Callback = ToggleConfig.Callback or function() end
                    local configKey = "Toggle_" .. ToggleConfig.Title
                    if ConfigData[configKey] ~= nil then
                        ToggleConfig.Default = ConfigData[configKey]
                    end
                    local ToggleFunc = { Value = ToggleConfig.Default }
                    local Toggle = Instance.new("Frame")
                    local UICorner20 = Instance.new("UICorner")
                    local ToggleTitle = Instance.new("TextLabel")
                    local ToggleContent = Instance.new("TextLabel")
                    local ToggleButton = Instance.new("TextButton")
                    local FeatureFrame2 = Instance.new("Frame")
                    local UICorner22 = Instance.new("UICorner")
                    local UIStroke8 = Instance.new("UIStroke")
                    local ToggleCircle = Instance.new("Frame")
                    local UICorner23 = Instance.new("UICorner")
                    Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Toggle.BackgroundTransparency = 0.935
                    Toggle.BorderSizePixel = 0
                    Toggle.LayoutOrder = CountItem
                    Toggle.Name = "Toggle"
                    Toggle.Parent = SectionAdd
                    UICorner20.CornerRadius = UDim.new(0, 4)
                    UICorner20.Parent = Toggle
                    ToggleTitle.Font = Enum.Font.GothamBold
                    ToggleTitle.Text = ToggleConfig.Title
                    ToggleTitle.TextSize = 13
                    ToggleTitle.TextColor3 = Color3.fromRGB(231, 231, 231)
                    ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
                    ToggleTitle.TextYAlignment = Enum.TextYAlignment.Top
                    ToggleTitle.BackgroundTransparency = 1
                    ToggleTitle.Position = UDim2.new(0, 10, 0, 10)
                    ToggleTitle.Size = UDim2.new(1, -100, 0, 13)
                    ToggleTitle.Name = "ToggleTitle"
                    ToggleTitle.Parent = Toggle
                    local ToggleTitle2 = Instance.new("TextLabel")
                    ToggleTitle2.Font = Enum.Font.GothamBold
                    ToggleTitle2.Text = ToggleConfig.Title2
                    ToggleTitle2.TextSize = 12
                    ToggleTitle2.TextColor3 = Color3.fromRGB(231, 231, 231)
                    ToggleTitle2.TextXAlignment = Enum.TextXAlignment.Left
                    ToggleTitle2.TextYAlignment = Enum.TextYAlignment.Top
                    ToggleTitle2.BackgroundTransparency = 1
                    ToggleTitle2.Position = UDim2.new(0, 10, 0, 23)
                    ToggleTitle2.Size = UDim2.new(1, -100, 0, 12)
                    ToggleTitle2.Name = "ToggleTitle2"
                    ToggleTitle2.Parent = Toggle
                    ToggleContent.Font = Enum.Font.GothamBold
                    ToggleContent.Text = ToggleConfig.Content
                    ToggleContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ToggleContent.TextSize = 12
                    ToggleContent.TextTransparency = 0.6
                    ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
                    ToggleContent.TextYAlignment = Enum.TextYAlignment.Bottom
                    ToggleContent.BackgroundTransparency = 1
                    ToggleContent.Size = UDim2.new(1, -100, 0, 12)
                    ToggleContent.Name = "ToggleContent"
                    ToggleContent.Parent = Toggle
                    if ToggleConfig.Title2 ~= "" then
                        Toggle.Size = UDim2.new(1, 0, 0, 57)
                        ToggleContent.Position = UDim2.new(0, 10, 0, 36)
                        ToggleTitle2.Visible = true
                    else
                        Toggle.Size = UDim2.new(1, 0, 0, 46)
                        ToggleContent.Position = UDim2.new(0, 10, 0, 23)
                        ToggleTitle2.Visible = false
                    end
                    ToggleContent.Size = UDim2.new(1, -100, 0, 12 + (12 * (ToggleContent.TextBounds.X // ToggleContent.AbsoluteSize.X)))
                    ToggleContent.TextWrapped = true
                    if ToggleConfig.Title2 ~= "" then
                        Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 47)
                    else
                        Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 33)
                    end
                    ToggleContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                        ToggleContent.TextWrapped = false
                        ToggleContent.Size = UDim2.new(1, -100, 0, 12 + (12 * (ToggleContent.TextBounds.X // ToggleContent.AbsoluteSize.X)))
                        if ToggleConfig.Title2 ~= "" then
                            Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 47)
                        else
                            Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 33)
                        end
                        ToggleContent.TextWrapped = true
                        UpdateSizeSection()
                    end)
                    ToggleButton.Font = Enum.Font.SourceSans
                    ToggleButton.Text = ""
                    ToggleButton.BackgroundTransparency = 1
                    ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                    ToggleButton.Name = "ToggleButton"
                    ToggleButton.Parent = Toggle
                    FeatureFrame2.AnchorPoint = Vector2.new(1, 0.5)
                    FeatureFrame2.BackgroundTransparency = 0.92
                    FeatureFrame2.BorderSizePixel = 0
                    FeatureFrame2.Position = UDim2.new(1, -15, 0.5, 0)
                    FeatureFrame2.Size = UDim2.new(0, 30, 0, 15)
                    FeatureFrame2.Name = "FeatureFrame"
                    FeatureFrame2.Parent = Toggle
                    UICorner22.Parent = FeatureFrame2
                    UIStroke8.Color = Color3.fromRGB(255, 255, 255)
                    UIStroke8.Thickness = 2
                    UIStroke8.Transparency = 0.9
                    UIStroke8.Parent = FeatureFrame2
                    ToggleCircle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                    ToggleCircle.BorderSizePixel = 0
                    ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
                    ToggleCircle.Name = "ToggleCircle"
                    ToggleCircle.Parent = FeatureFrame2
                    UICorner23.CornerRadius = UDim.new(0, 15)
                    UICorner23.Parent = ToggleCircle
                    ToggleButton.Activated:Connect(function()
                        ToggleFunc.Value = not ToggleFunc.Value
                        ToggleFunc:Set(ToggleFunc.Value)
                    end)
                    function ToggleFunc:Set(Value)
                        if typeof(ToggleConfig.Callback) == "function" then
                            local ok, err = pcall(function() ToggleConfig.Callback(Value) end)
                            if not ok then warn("Toggle Callback error:", err) end
                        end
                        ConfigData[configKey] = Value
                        SaveConfig()
                        if Value then
                            TweenService:Create(ToggleTitle, TweenInfo.new(0.2), { TextColor3 = GuiConfig.Color }):Play()
                            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), { Position = UDim2.new(0, 15, 0, 0) }):Play()
                            TweenService:Create(UIStroke8, TweenInfo.new(0.2), { Color = GuiConfig.Color, Transparency = 0 }):Play()
                            TweenService:Create(FeatureFrame2, TweenInfo.new(0.2), { BackgroundColor3 = GuiConfig.Color, BackgroundTransparency = 0 }):Play()
                        else
                            TweenService:Create(ToggleTitle, TweenInfo.new(0.2), { TextColor3 = Color3.fromRGB(230, 230, 230) }):Play()
                            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), { Position = UDim2.new(0, 0, 0, 0) }):Play()
                            TweenService:Create(UIStroke8, TweenInfo.new(0.2), { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.9 }):Play()
                            TweenService:Create(FeatureFrame2, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.92 }):Play()
                        end
                    end
                    ToggleFunc:Set(ToggleFunc.Value)
                    CountItem = CountItem + 1
                    Elements[configKey] = ToggleFunc
                    return ToggleFunc
                end
                function Items:AddButton(ButtonConfig)
                    ButtonConfig = ButtonConfig or {}
                    ButtonConfig.Title = ButtonConfig.Title or "Button"
                    ButtonConfig.Callback = ButtonConfig.Callback or function() end
                    local Button = Instance.new("Frame")
                    Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Button.BackgroundTransparency = 0.935
                    Button.Size = UDim2.new(1, 0, 0, 40)
                    Button.LayoutOrder = CountItem
                    Button.Parent = SectionAdd
                    local UICorner = Instance.new("UICorner")
                    UICorner.CornerRadius = UDim.new(0, 4)
                    UICorner.Parent = Button
                    local MainButton = Instance.new("TextButton")
                    MainButton.Font = Enum.Font.GothamBold
                    MainButton.Text = ButtonConfig.Title
                    MainButton.TextSize = 12
                    MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    MainButton.TextTransparency = 0.3
                    MainButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    MainButton.BackgroundTransparency = 0.935
                    MainButton.Size = ButtonConfig.SubTitle and UDim2.new(0.5, -8, 1, -10) or UDim2.new(1, -12, 1, -10)
                    MainButton.Position = UDim2.new(0, 6, 0, 5)
                    MainButton.Parent = Button
                    local mainCorner = Instance.new("UICorner")
                    mainCorner.CornerRadius = UDim.new(0, 4)
                    mainCorner.Parent = MainButton
                    MainButton.MouseButton1Click:Connect(function()
                        CircleClick(MainButton, Mouse.X, Mouse.Y)
                        ButtonConfig.Callback()
                    end)
                    if ButtonConfig.SubTitle then
                        local SubButton = Instance.new("TextButton")
                        SubButton.Font = Enum.Font.GothamBold
                        SubButton.Text = ButtonConfig.SubTitle
                        SubButton.TextSize = 12
                        SubButton.TextTransparency = 0.3
                        SubButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                        SubButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        SubButton.BackgroundTransparency = 0.935
                        SubButton.Size = UDim2.new(0.5, -8, 1, -10)
                        SubButton.Position = UDim2.new(0.5, 2, 0, 5)
                        SubButton.Parent = Button
                        local subCorner = Instance.new("UICorner")
                        subCorner.CornerRadius = UDim.new(0, 4)
                        subCorner.Parent = SubButton
                        SubButton.MouseButton1Click:Connect(ButtonConfig.SubCallback)
                    end
                    CountItem = CountItem + 1
                end
                function Items:AddInput(InputConfig)
                    InputConfig = InputConfig or {}
                    InputConfig.Title = InputConfig.Title or "Title"
                    InputConfig.Content = InputConfig.Content or ""
                    InputConfig.Callback = InputConfig.Callback or function() end
                    InputConfig.Default = InputConfig.Default or ""
                    local configKey = "Input_" .. InputConfig.Title
                    if ConfigData[configKey] ~= nil then
                        InputConfig.Default = ConfigData[configKey]
                    end
                    local InputFunc = { Value = InputConfig.Default }
                    local Input = Instance.new("Frame")
                    local UICorner12 = Instance.new("UICorner")
                    local InputTitle = Instance.new("TextLabel")
                    local InputContent = Instance.new("TextLabel")
                    local InputFrame = Instance.new("Frame")
                    local UICorner13 = Instance.new("UICorner")
                    local InputTextBox = Instance.new("TextBox")
                    Input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Input.BackgroundTransparency = 0.935
                    Input.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Input.BorderSizePixel = 0
                    Input.LayoutOrder = CountItem
                    Input.Size = UDim2.new(1, 0, 0, 46)
                    Input.Name = "Input"
                    Input.Parent = SectionAdd
                    UICorner12.CornerRadius = UDim.new(0, 4)
                    UICorner12.Parent = Input
                    InputTitle.Font = Enum.Font.GothamBold
                    InputTitle.Text = InputConfig.Title or "TextBox"
                    InputTitle.TextSize = 13
                    InputTitle.TextXAlignment = Enum.TextXAlignment.Left
                    InputTitle.TextYAlignment = Enum.TextYAlignment.Top
                    InputTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    InputTitle.BackgroundTransparency = 0.999
                    InputTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    InputTitle.BorderSizePixel = 0
                    InputTitle.Position = UDim2.new(0, 10, 0, 10)
                    InputTitle.Size = UDim2.new(1, -180, 0, 13)
                    InputTitle.Name = "InputTitle"
                    InputTitle.Parent = Input
                    InputContent.Font = Enum.Font.GothamBold
                    InputContent.Text = InputConfig.Content or "This is a TextBox"
                    InputContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                    InputContent.TextSize = 12
                    InputContent.TextTransparency = 0.6
                    InputContent.TextWrapped = true
                    InputContent.TextXAlignment = Enum.TextXAlignment.Left
                    InputContent.TextYAlignment = Enum.TextYAlignment.Bottom
                    InputContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    InputContent.BackgroundTransparency = 0.999
                    InputContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    InputContent.BorderSizePixel = 0
                    InputContent.Position = UDim2.new(0, 10, 0, 25)
                    InputContent.Size = UDim2.new(1, -180, 0, 12)
                    InputContent.Name = "InputContent"
                    InputContent.Parent = Input
                    InputContent.Size = UDim2.new(1, -180, 0, 12 + (12 * (InputContent.TextBounds.X // InputContent.AbsoluteSize.X)))
                    InputContent.TextWrapped = true
                    Input.Size = UDim2.new(1, 0, 0, InputContent.AbsoluteSize.Y + 33)
                    InputContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                        InputContent.TextWrapped = false
                        InputContent.Size = UDim2.new(1, -180, 0, 12 + (12 * (InputContent.TextBounds.X // InputContent.AbsoluteSize.X)))
                        Input.Size = UDim2.new(1, 0, 0, InputContent.AbsoluteSize.Y + 33)
                        InputContent.TextWrapped = true
                        UpdateSizeSection()
                    end)
                    InputFrame.AnchorPoint = Vector2.new(1, 0.5)
                    InputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    InputFrame.BackgroundTransparency = 0.95
                    InputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    InputFrame.BorderSizePixel = 0
                    InputFrame.ClipsDescendants = true
                    InputFrame.Position = UDim2.new(1, -7, 0.5, 0)
                    InputFrame.Size = UDim2.new(0, 148, 0, 30)
                    InputFrame.Name = "InputFrame"
                    InputFrame.Parent = Input
                    UICorner13.CornerRadius = UDim.new(0, 4)
                    UICorner13.Parent = InputFrame
                    InputTextBox.CursorPosition = -1
                    InputTextBox.Font = Enum.Font.GothamBold
                    InputTextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
                    InputTextBox.PlaceholderText = "Input Here"
                    InputTextBox.Text = InputConfig.Default
                    InputTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                    InputTextBox.TextSize = 12
                    InputTextBox.TextXAlignment = Enum.TextXAlignment.Left
                    InputTextBox.AnchorPoint = Vector2.new(0, 0.5)
                    InputTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    InputTextBox.BackgroundTransparency = 0.999
                    InputTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    InputTextBox.BorderSizePixel = 0
                    InputTextBox.Position = UDim2.new(0, 5, 0.5, 0)
                    InputTextBox.Size = UDim2.new(1, -10, 1, -8)
                    InputTextBox.Name = "InputTextBox"
                    InputTextBox.Parent = InputFrame
                    function InputFunc:Set(Value)
                        InputTextBox.Text = Value
                        InputFunc.Value = Value
                        InputConfig.Callback(Value)
                        ConfigData[configKey] = Value
                        SaveConfig()
                    end
                    InputFunc:Set(InputFunc.Value)
                    InputTextBox.FocusLost:Connect(function()
                        InputFunc:Set(InputTextBox.Text)
                    end)
                    CountItem = CountItem + 1
                    Elements[configKey] = InputFunc
                    return InputFunc
                end
                function Items:AddDropdown(DropdownConfig)
                    local DropdownConfig = DropdownConfig or {}
                    DropdownConfig.Title = DropdownConfig.Title or "Title"
                    DropdownConfig.Content = DropdownConfig.Content or ""
                    DropdownConfig.Multi = DropdownConfig.Multi or false
                    DropdownConfig.Options = DropdownConfig.Options or {}
                    DropdownConfig.Default = DropdownConfig.Default or (DropdownConfig.Multi and {} or nil)
                    DropdownConfig.Callback = DropdownConfig.Callback or function() end
                    local configKey = "Dropdown_" .. DropdownConfig.Title
                    if ConfigData[configKey] ~= nil then
                        DropdownConfig.Default = ConfigData[configKey]
                    end
                    local DropdownFunc = { Value = DropdownConfig.Default, Options = DropdownConfig.Options }
                    local Dropdown = Instance.new("Frame")
                    local DropdownButton = Instance.new("TextButton")
                    local UICorner10 = Instance.new("UICorner")
                    local DropdownTitle = Instance.new("TextLabel")
                    local DropdownContent = Instance.new("TextLabel")
                    local SelectOptionsFrame = Instance.new("Frame")
                    local UICorner11 = Instance.new("UICorner")
                    local OptionSelecting = Instance.new("TextLabel")
                    local OptionImg = Instance.new("ImageLabel")
                    Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Dropdown.BackgroundTransparency = 0.935
                    Dropdown.BorderSizePixel = 0
                    Dropdown.LayoutOrder = CountItem
                    Dropdown.Size = UDim2.new(1, 0, 0, 46)
                    Dropdown.Name = "Dropdown"
                    Dropdown.Parent = SectionAdd
                    DropdownButton.Text = ""
                    DropdownButton.BackgroundTransparency = 1
                    DropdownButton.Size = UDim2.new(1, 0, 1, 0)
                    DropdownButton.Name = "ToggleButton"
                    DropdownButton.Parent = Dropdown
                    UICorner10.CornerRadius = UDim.new(0, 4)
                    UICorner10.Parent = Dropdown
                    DropdownTitle.Font = Enum.Font.GothamBold
                    DropdownTitle.Text = DropdownConfig.Title
                    DropdownTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                    DropdownTitle.TextSize = 13
                    DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
                    DropdownTitle.BackgroundTransparency = 1
                    DropdownTitle.Position = UDim2.new(0, 10, 0, 10)
                    DropdownTitle.Size = UDim2.new(1, -180, 0, 13)
                    DropdownTitle.Name = "DropdownTitle"
                    DropdownTitle.Parent = Dropdown
                    DropdownContent.Font = Enum.Font.GothamBold
                    DropdownContent.Text = DropdownConfig.Content
                    DropdownContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                    DropdownContent.TextSize = 12
                    DropdownContent.TextTransparency = 0.6
                    DropdownContent.TextWrapped = true
                    DropdownContent.TextXAlignment = Enum.TextXAlignment.Left
                    DropdownContent.BackgroundTransparency = 1
                    DropdownContent.Position = UDim2.new(0, 10, 0, 25)
                    DropdownContent.Size = UDim2.new(1, -180, 0, 12)
                    DropdownContent.Name = "DropdownContent"
                    DropdownContent.Parent = Dropdown
                    SelectOptionsFrame.AnchorPoint = Vector2.new(1, 0.5)
                    SelectOptionsFrame.BackgroundTransparency = 0.95
                    SelectOptionsFrame.Position = UDim2.new(1, -7, 0.5, 0)
                    SelectOptionsFrame.Size = UDim2.new(0, 148, 0, 30)
                    SelectOptionsFrame.Name = "SelectOptionsFrame"
                    SelectOptionsFrame.LayoutOrder = CountDropdown
                    SelectOptionsFrame.Parent = Dropdown
                    UICorner11.CornerRadius = UDim.new(0, 4)
                    UICorner11.Parent = SelectOptionsFrame
                    DropdownButton.Activated:Connect(function()
                        -- Simplified dropdown for now
                        SpeedHubUI:MakeNotify({
                            Title = "Dropdown",
                            Description = "Info",
                            Content = "Dropdown clicked - select: " .. tostring(DropdownFunc.Value),
                            Color = GuiConfig.Color,
                            Delay = 2
                        })
                    end)
                    OptionSelecting.Font = Enum.Font.GothamBold
                    OptionSelecting.Text = DropdownConfig.Multi and "Select Options" or "Select Option"
                    OptionSelecting.TextColor3 = Color3.fromRGB(255, 255, 255)
                    OptionSelecting.TextSize = 12
                    OptionSelecting.TextTransparency = 0.6
                    OptionSelecting.TextXAlignment = Enum.TextXAlignment.Left
                    OptionSelecting.AnchorPoint = Vector2.new(0, 0.5)
                    OptionSelecting.BackgroundTransparency = 1
                    OptionSelecting.Position = UDim2.new(0, 5, 0.5, 0)
                    OptionSelecting.Size = UDim2.new(1, -30, 1, -8)
                    OptionSelecting.Name = "OptionSelecting"
                    OptionSelecting.Parent = SelectOptionsFrame
                    OptionImg.Image = "rbxassetid://16851841101"
                    OptionImg.ImageColor3 = Color3.fromRGB(230, 230, 230)
                    OptionImg.AnchorPoint = Vector2.new(1, 0.5)
                    OptionImg.BackgroundTransparency = 1
                    OptionImg.Position = UDim2.new(1, 0, 0.5, 0)
                    OptionImg.Size = UDim2.new(0, 25, 0, 25)
                    OptionImg.Name = "OptionImg"
                    OptionImg.Parent = SelectOptionsFrame
                    function DropdownFunc:Set(Value)
                        if DropdownConfig.Multi then
                            DropdownFunc.Value = type(Value) == "table" and Value or {}
                        else
                            DropdownFunc.Value = (type(Value) == "table" and Value[1]) or Value
                        end
                        ConfigData[configKey] = DropdownFunc.Value
                        SaveConfig()
                        OptionSelecting.Text = tostring(DropdownFunc.Value) or "Select Option"
                        if DropdownConfig.Callback then
                            DropdownConfig.Callback(DropdownFunc.Value)
                        end
                    end
                    DropdownFunc:Set(DropdownFunc.Value)
                    CountItem = CountItem + 1
                    CountDropdown = CountDropdown + 1
                    Elements[configKey] = DropdownFunc
                    return DropdownFunc
                end
                CountSection = CountSection + 1
                return Items
            end
            CountTab = CountTab + 1
            return Sections
        end
        return GuiFunc, Tabs
    end

    return Menghub
end)()

-- ============================================
-- MAIN SCRIPT CODE
-- ============================================

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local FishingController = require(ReplicatedStorage.Controllers.FishingController)

-- Script State
local ScriptActive = true
local Connections = {}

-- Cleanup function
local function CleanupScript()
    ScriptActive = false
    for _, v in pairs(Connections) do
        pcall(function() v:Disconnect() end)
    end
    Connections = {}
    if TextChatService then
        TextChatService.OnIncomingMessage = nil
    end
    print("❌ NikeeHUB System: Script closed and cleanup complete.")
end

-- Anti-AFK
task.spawn(function()
    while ScriptActive do
        task.wait(5)
        pcall(function()
            local core = game:GetService("CoreGui")
            if core:FindFirstChild("DarkDetex") or core:FindFirstChild("RemoteSpy") or core:FindFirstChild("TurtleSpy") then
            end
        end)
    end
end)

task.spawn(function()
    local VirtualUser = game:GetService("VirtualUser")
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

-- Data & Settings
local Current_Webhook_Fish = ""
local Current_Webhook_Leave = ""
local Current_Webhook_List = ""
local Current_Webhook_Admin = ""
local LastDisconnectTime = 0

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
    ["Ancient Jungle"] = {Pos = Vector3.new(1535.639, 3.159, -193.352), Look = Vector3.new(0.505, -0.000, 0.863)},
    ["Coral Reef"] = {Pos = Vector3.new(-3207.538, 6.087, 2011.079), Look = Vector3.new(0.973, 0.000, 0.229)},
    ["Crater Island"] = {Pos = Vector3.new(1058.976, 2.330, 5032.878), Look = Vector3.new(-0.789, 0.000, 0.615)},
    ["Ancient Ruin"] = {Pos = Vector3.new(6031.981, -585.924, 4713.157), Look = Vector3.new(0.316, -0.000, -0.949)},
    ["Enchant Room"] = {Pos = Vector3.new(3255.670, -1301.530, 1371.790), Look = Vector3.new(-0.000, -0.000, -1.000)},
    ["Fisherman Island"] = {Pos = Vector3.new(74.030, 9.530, 2705.230), Look = Vector3.new(-0.000, -0.000, -1.000)},
    ["Kohana"] = {Pos = Vector3.new(-668.732, 3.000, 681.580), Look = Vector3.new(0.889, -0.000, 0.458)},
    ["Lost Isle"] = {Pos = Vector3.new(-3804.105, 2.344, -904.653), Look = Vector3.new(-0.901, -0.000, 0.433)},
    ["Sacred Temple"] = {Pos = Vector3.new(1461.815, -22.125, -670.234), Look = Vector3.new(-0.990, -0.000, 0.143)},
    ["Second Enchant Altar"] = {Pos = Vector3.new(1479.587, 128.295, -604.224), Look = Vector3.new(-0.298, 0.000, -0.955)},
    ["Sisyphus Statue"] = {Pos = Vector3.new(-3743.745, -135.074, -1007.554), Look = Vector3.new(0.310, 0.000, 0.951)},
    ["Treasure Room"] = {Pos = Vector3.new(-3598.440, -281.274, -1645.855), Look = Vector3.new(-0.065, 0.000, -0.998)},
    ["Tropical Island"] = {Pos = Vector3.new(-2162.920, 2.825, 3638.445), Look = Vector3.new(0.381, -0.000, 0.925)},
    ["Underground Cellar"] = {Pos = Vector3.new(2118.417, -91.448, -733.800), Look = Vector3.new(0.854, 0.000, 0.521)},
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

-- Tag Discord System
local TagList = {}
for i = 1, 20 do TagList[i] = {"", ""} end

-- Session Stats
local SessionStart = tick()
local SessionStats = {
    Secret = 0,
    Ruby = 0,
    Evolved = 0,
    Crystalized = 0,
    CaveCrystal = 0,
    TotalSent = 0
}

-- ============================================
-- HELPER FUNCTIONS
-- ============================================
local function TeleportToLookAt(position, lookVector)
    local Character = Players.LocalPlayer.Character
    if not Character then Character = Players.LocalPlayer.CharacterAdded:Wait() end
    local hrp = Character:WaitForChild("HumanoidRootPart", 5)
    if hrp and typeof(position) == "Vector3" and typeof(lookVector) == "Vector3" then
        local targetCFrame = CFrame.new(position, position + lookVector)
        hrp.CFrame = targetCFrame * CFrame.new(0, 3, 0)
        SpeedHubUI:MakeNotify({
            Title = "NikeeHUB",
            Description = "Teleport",
            Content = "Teleported successfully!",
            Color = Color3.fromRGB(0, 139, 139),
            Delay = 2
        })
    else
        SpeedHubUI:MakeNotify({
            Title = "NikeeHUB",
            Description = "Error",
            Content = "Invalid TP Data",
            Color = Color3.fromRGB(235, 85, 85),
            Delay = 2
        })
    end
end

local function StripTags(str) return string.gsub(str, "<[^>]+>", "") end

local function GetUsername(chatName)
    local trimmedChatName = chatName:match("^%s*(.-)%s*$")
    for _, p in ipairs(Players:GetPlayers()) do
        if p.DisplayName == trimmedChatName or p.Name == trimmedChatName then
            return p.Name
        end
    end
    return trimmedChatName
end

local function ParseDataSmart(cleanMsg)
    local msg = string.gsub(cleanMsg, "%[Server%]: ", "")
    local p, f, w = string.match(msg, "^(.*) obtained an? (.*) %((.*)%)")
    if not p then
        p, f = string.match(msg, "^(.*) obtained an? (.*)")
        w = "N/A"
    end
    if p and f then
        if string.sub(f, -1) == "!" or string.sub(f, -1) == "." then
            f = string.sub(f, 1, -2)
        end
        f = f:match("^%s*(.-)%s*$")
        local mutation = nil
        local finalItem = f
        local lowerFullItem = string.lower(f)
        local allTargets = {}
        for _, v in pairs(SecretList) do table.insert(allTargets, v) end
        for _, v in pairs(StoneList) do table.insert(allTargets, v) end
        table.insert(allTargets, "Evolved Enchant Stone")
        for _, baseName in pairs(allTargets) do
            if string.find(lowerFullItem, string.lower(baseName) .. "$") then
                local s, e = string.find(lowerFullItem, string.lower(baseName) .. "$")
                if s > 1 then
                    local prefixRaw = string.sub(f, 1, s - 1)
                    local checkMut = prefixRaw
                    checkMut = string.gsub(checkMut, "Big%s*", "")
                    checkMut = string.gsub(checkMut, "Shiny%s*", "")
                    checkMut = string.gsub(checkMut, "Sparkling%s*", "")
                    checkMut = string.gsub(checkMut, "Giant%s*", "")
                    checkMut = string.gsub(checkMut, "^%s*(.-)%s*$", "%1")
                    if checkMut == "" then
                        mutation = nil
                        finalItem = f
                    else
                        mutation = checkMut
                        finalItem = string.gsub(f, prefixRaw, "")
                        finalItem = string.gsub(finalItem, "^%s*(.-)%s*$", "%1")
                    end
                else
                    mutation = nil
                    finalItem = f
                end
                break
            end
        end
        return { Player = p, Item = finalItem, Mutation = mutation, Weight = w }
    end
    return nil
end

local function GetRemote(name)
    local RPath = {"Packages", "_Index", "sleitnick_net@0.2.0", "net"}
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
        local label = inv:FindFirstChild("Main") and inv.Main:FindFirstChild("Top") and inv.Main.Top:FindFirstChild("Options") and inv.Main.Top.Options.Fish:FindFirstChild("Label") and inv.Main.Top.Options.Fish.Label:FindFirstChild("BagSize")
        if label then
            return tonumber((label.Text or "0/???"):match("(%d+)/")) or 0
        end
    end
    return 0
end

-- ============================================
-- CREATE SPEEDHUB UI
-- ============================================
local Window, Tabs = SpeedHubUI:Window({
    Title = "NikeeHUB",
    Footer = "FishIt",
    Color = Color3.fromRGB(0, 139, 139),
    Image = "rbxassetid://0",
    Version = 1
})

-- Create Tabs
local Tab_ServerInfo = Window:AddTab({ Name = "Server Info", Icon = "stat" })
local Tab_Fhising = Window:AddTab({ Name = "Fhising", Icon = "fish" })
local Tab_Teleport = Window:AddTab({ Name = "Teleport", Icon = "gps" })
local Tab_Notification = Window:AddTab({ Name = "Notification", Icon = "alert" })
local Tab_AdminBoost = Window:AddTab({ Name = "Admin Boost", Icon = "player" })
local Tab_TagDiscord = Window:AddTab({ Name = "List Player", Icon = "discord" })
local Tab_Setting = Window:AddTab({ Name = "Setting", Icon = "settings" })
local Tab_SaveConfig = Window:AddTab({ Name = "Save Config", Icon = "bag" })

-- ============================================
-- SERVER INFO TAB
-- ============================================
local Section_Stats = Tab_ServerInfo:AddSection("Session Statistics", true)

Section_Stats:AddButton({
    Title = "Send Session Stats",
    Callback = function()
        if Current_Webhook_Admin == "" then
            SpeedHubUI:MakeNotify({
                Title = "NikeeHUB",
                Description = "Error",
                Content = "Admin Webhook Empty!",
                Color = Color3.fromRGB(235, 85, 85),
                Delay = 2
            })
            return
        end
        SpeedHubUI:MakeNotify({
            Title = "NikeeHUB",
            Description = "Sending",
            Content = "Sending stats...",
            Color = Color3.fromRGB(0, 139, 139),
            Delay = 2
        })
        local diff = tick() - SessionStart
        local h = math.floor(diff / 3600)
        local m = math.floor((diff % 3600) / 60)
        local s = math.floor(diff % 60)
        local timeStr = string.format("%02dh %02dm %02ds", h, m, s)
        local contentStr = "📊 SERVER: NikeeHUB\n"
        contentStr = contentStr .. "⏱️ Uptime: " .. timeStr .. "\n"
        contentStr = contentStr .. "📡 Total Webhooks: " .. SessionStats.TotalSent .. "\n\n"
        contentStr = contentStr .. "⚡ Secrets: " .. SessionStats.Secret .. "\n"
        contentStr = contentStr .. "💎 Rubies: " .. SessionStats.Ruby .. "\n"
        contentStr = contentStr .. "🔮 Evolved: " .. SessionStats.Evolved .. "\n"
        contentStr = contentStr .. "✨ Crystalized: " .. SessionStats.Crystalized .. "\n"
        contentStr = contentStr .. "⛏️ Cave Crystals: " .. SessionStats.CaveCrystal
        task.spawn(function()
            local embed = {
                ["username"] = "NikeeHUB Stats",
                ["avatar_url"] = "https://i.imgur.com/CWWGnhO.jpeg",
                ["embeds"] = {{
                    ["title"] = "Session Report",
                    ["description"] = "```\n" .. contentStr .. "\n```",
                    ["color"] = 5763719,
                    ["footer"] = { ["text"] = "NikeeHUB Webhook", ["icon_url"] = "https://i.imgur.com/CWWGnhO.jpeg" }
                }}
            }
            httpRequest({
                Url = Current_Webhook_Admin,
                Method = "POST",
                Headers = {["Content-Type"]="application/json"},
                Body = HttpService:JSONEncode(embed)
            })
        end)
    end
})

-- Uptime display
local UptimeFrame = Instance.new("Frame")
UptimeFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UptimeFrame.BackgroundTransparency = 0.935
UptimeFrame.Size = UDim2.new(1, 0, 0, 40)
UptimeFrame.Parent = Section_Stats
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = UptimeFrame
local UptimeLabel = Instance.new("TextLabel")
UptimeLabel.BackgroundTransparency = 1
UptimeLabel.Size = UDim2.new(1, -20, 1, 0)
UptimeLabel.Font = Enum.Font.GothamBold
UptimeLabel.Text = "Uptime: 00h 00m 00s"
UptimeLabel.TextColor3 = Color3.fromRGB(0, 139, 139)
UptimeLabel.TextSize = 13
UptimeLabel.TextXAlignment = "Left"
UptimeLabel.Position = UDim2.new(0, 10, 0, 0)
UptimeLabel.Parent = UptimeFrame

task.spawn(function()
    while ScriptActive do
        local diff = tick() - SessionStart
        local h = math.floor(diff / 3600)
        local m = math.floor((diff % 3600) / 60)
        local s = math.floor(diff % 60)
        UptimeLabel.Text = string.format("Uptime: %02dh %02dm %02ds", h, m, s)
        task.wait(1)
    end
end)

-- ============================================
-- FHISING TAB
-- ============================================
local Section_Fhising = Tab_Fhising:AddSection("Fishing Automation", true)

-- Detector Stuck
local DetectorStuckEnabled = false
local StuckThreshold = 15
local LastFishCount = 0
local StuckTimer = 0
local SavedCFrame = nil

Section_Fhising:AddToggle({
    Title = "Detector Stuck (15s)",
    Content = "Auto reset if stuck for 15 seconds",
    Default = false,
    Callback = function(state)
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
                            SpeedHubUI:MakeNotify({
                                Title = "NikeeHUB",
                                Description = "Stuck Detected",
                                Content = "Resetting character...",
                                Color = Color3.fromRGB(235, 85, 85),
                                Delay = 2
                            })
                            local char = Players.LocalPlayer.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                SavedCFrame = char.HumanoidRootPart.CFrame
                            end
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
    end
})

-- Auto Click Fishing
local AutoShakeEnabled = false
Section_Fhising:AddToggle({
    Title = "Auto Click Fishing",
    Content = "Automatically click during fishing minigame",
    Default = false,
    Callback = function(val)
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
    end
})

-- Auto Sell
local AutoSellEnabled = false
local SellValue = 600
Section_Fhising:AddToggle({
    Title = "Auto Sell",
    Content = "Automatically sell items (10m / 600 items)",
    Default = false,
    Callback = function(state)
        AutoSellEnabled = state
        if state then
            local RF_Sell = GetRemote("RF/SellAllItems")
            if not RF_Sell then
                SpeedHubUI:MakeNotify({
                    Title = "NikeeHUB",
                    Description = "Error",
                    Content = "Remote Sell Missing!",
                    Color = Color3.fromRGB(235, 85, 85),
                    Delay = 2
                })
                AutoSellEnabled = false
                return
            end
            task.spawn(function()
                local LastSellTime = tick()
                while AutoSellEnabled and ScriptActive do
                    if (tick() - LastSellTime) >= 600 then
                        pcall(function() RF_Sell:InvokeServer() end)
                        LastSellTime = tick()
                    end
                    local Replion = require(game:GetService("ReplicatedStorage").Packages.Replion).Client:WaitReplion("Data", 1)
                    if Replion then
                        local s, d = pcall(function() return Replion:GetExpect("Inventory") end)
                        if s and d and d.Items then
                            if #d.Items >= SellValue then
                                pcall(function() RF_Sell:InvokeServer() end)
                                LastSellTime = tick()
                                task.wait(1)
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- Auto Weather
local WeatherList = { "Wind", "Cloudy", "Storm" }
local SimpleWeatherEnabled = false
Section_Fhising:AddToggle({
    Title = "Auto Buy Weather",
    Content = "Automatically purchase weather effects",
    Default = false,
    Callback = function(state)
        SimpleWeatherEnabled = state
        if state then
            local RF_BuyWeather = GetRemote("RF/PurchaseWeatherEvent")
            if not RF_BuyWeather then
                SpeedHubUI:MakeNotify({
                    Title = "NikeeHUB",
                    Description = "Error",
                    Content = "Remote Weather Missing!",
                    Color = Color3.fromRGB(235, 85, 85),
                    Delay = 2
                })
                SimpleWeatherEnabled = false
                return
            end
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
    end
})

-- Auto Totem
local TotemList = {"Luck Totem", "Mutation Totem", "Shiny Totem"}
local SelectedTotem = "Luck Totem"
local TotemMap = {["Luck Totem"]=1, ["Mutation Totem"]=2, ["Shiny Totem"]=3}
local AutoTotemEnabled = false

Section_Fhising:AddDropdown({
    Title = "Select Totem",
    Content = "Choose which totem to spawn",
    Options = TotemList,
    Default = "Luck Totem",
    Callback = function(v)
        SelectedTotem = v
    end
})

Section_Fhising:AddToggle({
    Title = "Auto Spawn Totem",
    Content = "Automatically spawn selected totem",
    Default = false,
    Callback = function(state)
        AutoTotemEnabled = state
        if state then
            local RE_Spawn = GetRemote("RE/SpawnTotem")
            local RE_Equip = GetRemote("RE/EquipToolFromHotbar")
            if not RE_Spawn then
                SpeedHubUI:MakeNotify({
                    Title = "NikeeHUB",
                    Description = "Error",
                    Content = "Remote Totem Missing!",
                    Color = Color3.fromRGB(235, 85, 85),
                    Delay = 2
                })
                AutoTotemEnabled = false
                return
            end
            task.spawn(function()
                while AutoTotemEnabled and ScriptActive do
                    local Replion = require(game:GetService("ReplicatedStorage").Packages.Replion).Client:WaitReplion("Data", 2)
                    local uuid = nil
                    if Replion then
                        local s, d = pcall(function() return Replion:GetExpect("Inventory") end)
                        if s and d and d.Totems then
                            for _, i in ipairs(d.Totems) do
                                if tonumber(i.Id) == TotemMap[SelectedTotem] and (i.Count or 1) >= 1 then
                                    uuid = i.UUID
                                    break
                                end
                            end
                        end
                    end
                    if uuid then
                        pcall(function() RE_Spawn:FireServer(uuid) end)
                        task.wait(1)
                        pcall(function() RE_Equip:FireServer(1) end)
                        task.wait(3600)
                    else
                        SpeedHubUI:MakeNotify({
                            Title = "NikeeHUB",
                            Description = "Error",
                            Content = "Totem UUID Not Found!",
                            Color = Color3.fromRGB(235, 85, 85),
                            Delay = 2
                        })
                        task.wait(5)
                    end
                end
            end)
        end
    end
})

-- ============================================
-- TELEPORT TAB
-- ============================================
local Section_Teleport = Tab_Teleport:AddSection("Teleport Locations", true)

local sortedAreas = {}
for name, _ in pairs(FishingAreas) do table.insert(sortedAreas, name) end
table.sort(sortedAreas)

for _, name in ipairs(sortedAreas) do
    Section_Teleport:AddButton({
        Title = "TP to " .. name,
        Callback = function()
            local data = FishingAreas[name]
            TeleportToLookAt(data.Pos, data.Look)
        end
    })
end

-- ============================================
-- NOTIFICATION TAB
-- ============================================
local Section_Webhook = Tab_Notification:AddSection("Webhook URLs", false)

Section_Webhook:AddInput({
    Title = "Fish Caught Webhook",
    Content = "Discord webhook URL for fish catches",
    Default = "",
    Callback = function(v) Current_Webhook_Fish = v end
})

Section_Webhook:AddInput({
    Title = "Player Leave Webhook",
    Content = "Discord webhook URL for player leave",
    Default = "",
    Callback = function(v) Current_Webhook_Leave = v end
})

Section_Webhook:AddInput({
    Title = "Player List Webhook",
    Content = "Discord webhook URL for player list",
    Default = "",
    Callback = function(v) Current_Webhook_List = v end
})

Section_Webhook:AddInput({
    Title = "Admin Host Webhook",
    Content = "Discord webhook URL for admin alerts",
    Default = "",
    Callback = function(v) Current_Webhook_Admin = v end
})

-- Notification Toggles
local Section_Notif = Tab_Notification:AddSection("Notification Settings", true)

Section_Notif:AddToggle({
    Title = "Secret Fish Caught",
    Content = "Send webhook when secret fish is caught",
    Default = false,
    Callback = function(v) Settings.SecretEnabled = v end
})

Section_Notif:AddToggle({
    Title = "Ruby Gemstone",
    Content = "Send webhook when ruby is found",
    Default = false,
    Callback = function(v) Settings.RubyEnabled = v end
})

Section_Notif:AddToggle({
    Title = "Evolved Enchant Stone",
    Content = "Send webhook when evolved stone is obtained",
    Default = false,
    Callback = function(v) Settings.EvolvedEnabled = v end
})

Section_Notif:AddToggle({
    Title = "Mutation Crystalized",
    Content = "Send webhook for crystalized mutations",
    Default = false,
    Callback = function(v) Settings.MutationCrystalized = v end
})

Section_Notif:AddToggle({
    Title = "Cave Crystal",
    Content = "Send webhook when cave crystal is found",
    Default = false,
    Callback = function(v) Settings.CaveCrystalEnabled = v end
})

-- ============================================
-- ADMIN BOOST TAB
-- ============================================
local Section_Admin = Tab_AdminBoost:AddSection("Admin Features", false)

Section_Admin:AddToggle({
    Title = "Foreign Detection",
    Content = "Detect players not in the tag list",
    Default = false,
    Callback = function(v) Settings.ForeignDetection = v end
})

Section_Admin:AddToggle({
    Title = "Hide Player Name (Spoiler)",
    Content = "Hide player names with spoiler tag",
    Default = true,
    Callback = function(v) Settings.SpoilerName = v end
})

Section_Admin:AddToggle({
    Title = "Lag Detector (Ping > 500ms)",
    Content = "Alert when server ping is high",
    Default = false,
    Callback = function(v) Settings.PingMonitor = v end
})

Section_Admin:AddToggle({
    Title = "Player Leave Server",
    Content = "Track when players leave",
    Default = false,
    Callback = function(v) Settings.LeaveEnabled = v end
})

Section_Admin:AddToggle({
    Title = "Player Not On Server (30 min)",
    Content = "Auto check missing players every 30 minutes",
    Default = false,
    Callback = function(v) Settings.PlayerNonPSAuto = v end
})

-- Player list buttons
local Section_AdminBtns = Tab_AdminBoost:AddSection("Quick Actions", true)

Section_AdminBtns:AddButton({
    Title = "Player On Server",
    Callback = function()
        if Current_Webhook_List == "" then
            SpeedHubUI:MakeNotify({
                Title = "NikeeHUB",
                Description = "Error",
                Content = "Webhook Missing!",
                Color = Color3.fromRGB(235, 85, 85),
                Delay = 2
            })
            return
        end
        SpeedHubUI:MakeNotify({
            Title = "NikeeHUB",
            Description = "Sending",
            Content = "Sending player list...",
            Color = Color3.fromRGB(0, 139, 139),
            Delay = 2
        })
        local all = Players:GetPlayers()
        local str = "Current Players (" .. #all .. "):\n\n"
        for i, p in ipairs(all) do
            str = str .. i .. ". " .. p.DisplayName .. " (@" .. p.Name .. ")\n"
        end
        task.spawn(function()
            local p = {
                ["username"] = "NikeeHUB",
                ["avatar_url"] = "https://i.imgur.com/CWWGnhO.jpeg",
                ["embeds"] = {{
                    ["title"] = "Manual Player List",
                    ["description"] = "```\n" .. str .. "\n```",
                    ["color"] = 5763719,
                    ["footer"] = { ["text"] = "NikeeHUB Webhook", ["icon_url"] = "https://i.imgur.com/CWWGnhO.jpeg" }
                }}
            }
            httpRequest({
                Url = Current_Webhook_List,
                Method = "POST",
                Headers = {["Content-Type"]="application/json"},
                Body = HttpService:JSONEncode(p)
            })
        end)
    end
})

Section_AdminBtns:AddButton({
    Title = "Player NOT On Server",
    Callback = function()
        if Current_Webhook_List == "" then
            SpeedHubUI:MakeNotify({
                Title = "NikeeHUB",
                Description = "Error",
                Content = "Webhook Player List Empty!",
                Color = Color3.fromRGB(235, 85, 85),
                Delay = 2
            })
            return
        end
        local current = {}
        for _, p in ipairs(Players:GetPlayers()) do current[string.lower(p.Name)] = true end
        local missingNames = {}
        local missingTags = {}
        for i = 1, 20 do
            local name = TagList[i][1]
            local discId = TagList[i][2]
            if name ~= "" and not current[string.lower(name)] then
                table.insert(missingNames, name)
                if discId and discId ~= "" then
                    table.insert(missingTags, "<@" .. discId .. ">")
                end
            end
        end
        local txt = "Missing Players (" .. #missingNames .. "):\n\n"
        if #missingNames == 0 then
            txt = "All tagged players are in the server!"
        else
            for i, v in ipairs(missingNames) do
                txt = txt .. i .. ". " .. v .. "\n"
            end
        end
        local contentMsg = ""
        if #missingTags > 0 then
            contentMsg = " **Peringatan:** " .. table.concat(missingTags, " ") .. " belum masuk server!"
        end
        task.spawn(function()
            local p = {
                ["username"] = "NikeeHUB",
                ["avatar_url"] = "https://i.imgur.com/CWWGnhO.jpeg",
                ["content"] = contentMsg,
                ["embeds"] = {{
                    ["title"] = "Player Not On Server",
                    ["description"] = "```\n" .. txt .. "\n```",
                    ["color"] = 16733440,
                    ["footer"] = { ["text"] = "NikeeHUB Webhook", ["icon_url"] = "https://i.imgur.com/CWWGnhO.jpeg" }
                }}
            }
            httpRequest({
                Url = Current_Webhook_List,
                Method = "POST",
                Headers = {["Content-Type"]="application/json"},
                Body = HttpService:JSONEncode(p)
            })
        end)
    end
})

-- ============================================
-- TAG DISCORD TAB
-- ============================================
local Section_TagList = Tab_TagDiscord:AddSection("Player Tag List (Host 1 & 2 get pinged)", true)

for i = 1, 20 do
    local labelText = "List " .. i .. ":"
    if i == 1 then labelText = "Host 1:" end
    if i == 2 then labelText = "Host 2:" end
    Section_TagList:AddInput({
        Title = labelText .. " Username",
        Content = "Enter Roblox username",
        Default = TagList[i][1],
        Callback = function(v) TagList[i][1] = v end
    })
    Section_TagList:AddInput({
        Title = labelText .. " Discord ID",
        Content = "Enter Discord ID (optional, for pings)",
        Default = TagList[i][2],
        Callback = function(v) TagList[i][2] = v end
    })
end

-- ============================================
-- SETTING TAB
-- ============================================
local Section_Settings = Tab_Setting:AddSection("Script Settings", false)

-- Walk On Water
local WalkOnWaterEnabled = false
local WaterPlatform = nil
local WalkConnection = nil

Section_Settings:AddToggle({
    Title = "Walk On Water",
    Content = "Allow walking on water surface",
    Default = false,
    Callback = function(state)
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
                if not ScriptActive then
                    if WalkConnection then WalkConnection:Disconnect() end
                    return
                end
                local char = Players.LocalPlayer.Character
                if not WalkOnWaterEnabled or not char then return end
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
    end
})

-- Remove Fish Notification
local DisableNotificationConnection = nil
Section_Settings:AddToggle({
    Title = "Remove Fish Notification Pop-up",
    Content = "Block fish catch notifications",
    Default = false,
    Callback = function(state)
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
                SpeedHubUI:MakeNotify({
                    Title = "NikeeHUB",
                    Description = "Settings",
                    Content = "Pop-up Blocked",
                    Color = Color3.fromRGB(0, 139, 139),
                    Delay = 2
                })
            end
        else
            if DisableNotificationConnection then
                DisableNotificationConnection:Disconnect()
                DisableNotificationConnection = nil
            end
            if SmallNotification then SmallNotification.Enabled = true end
            SpeedHubUI:MakeNotify({
                Title = "NikeeHUB",
                Description = "Settings",
                Content = "Pop-up Enabled",
                Color = Color3.fromRGB(0, 139, 139),
                Delay = 2
            })
        end
    end
})

-- No Animation
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

Section_Settings:AddToggle({
    Title = "No Animation",
    Content = "Disable character animations",
    Default = false,
    Callback = function(state)
        isNoAnimationActive = state
        if state then
            DisableAnimations()
            SpeedHubUI:MakeNotify({
                Title = "NikeeHUB",
                Description = "Settings",
                Content = "No Animation ON",
                Color = Color3.fromRGB(0, 139, 139),
                Delay = 2
            })
        else
            EnableAnimations()
            SpeedHubUI:MakeNotify({
                Title = "NikeeHUB",
                Description = "Settings",
                Content = "No Animation OFF",
                Color = Color3.fromRGB(0, 139, 139),
                Delay = 2
            })
        end
    end
})

-- Remove VFX
local VFXControllerModule = require(ReplicatedStorage.Controllers.VFXController)
local originalVFXHandle = VFXControllerModule.Handle
local isVFXDisabled = false

Section_Settings:AddToggle({
    Title = "Remove Skin Effect",
    Content = "Disable visual effects",
    Default = false,
    Callback = function(state)
        isVFXDisabled = state
        if state then
            VFXControllerModule.Handle = function(...) end
            VFXControllerModule.RenderAtPoint = function(...) end
            VFXControllerModule.RenderInstance = function(...) end
            local cosmeticFolder = workspace:FindFirstChild("CosmeticFolder")
            if cosmeticFolder then pcall(function() cosmeticFolder:ClearAllChildren() end) end
            SpeedHubUI:MakeNotify({
                Title = "NikeeHUB",
                Description = "Settings",
                Content = "No Skin Effect ON",
                Color = Color3.fromRGB(0, 139, 139),
                Delay = 2
            })
        else
            VFXControllerModule.Handle = originalVFXHandle
            SpeedHubUI:MakeNotify({
                Title = "NikeeHUB",
                Description = "Settings",
                Content = "Skin Effect Restored (Rejoin to fully fix)",
                Color = Color3.fromRGB(0, 139, 139),
                Delay = 2
            })
        end
    end
})

Section_Settings:AddToggle({
    Title = "Auto Execute on Server Hop",
    Content = "Automatically execute script on teleport",
    Default = false,
    Callback = function(v) Settings.AutoExecute = v end
})

-- ============================================
-- SAVE CONFIG TAB
-- ============================================
local Section_Save = Tab_SaveConfig:AddSection("Configuration Manager", true)

Section_Save:AddInput({
    Title = "Config Name",
    Content = "Enter a name for your config",
    Default = "Default",
    Callback = function(v) end
})

Section_Save:AddButton({
    Title = "SAVE CONFIG",
    Callback = function()
        if not isfolder("Nikee_Configs") then makefolder("Nikee_Configs") end
        local configName = "Default"
        local saveData = {
            Webhooks = {
                Fish = Current_Webhook_Fish,
                Leave = Current_Webhook_Leave,
                List = Current_Webhook_List,
                Admin = Current_Webhook_Admin
            },
            Players = TagList,
            Settings = Settings
        }
        local jsonSuccess, encodedData = pcall(function() return HttpService:JSONEncode(saveData) end)
        if not jsonSuccess then
            SpeedHubUI:MakeNotify({
                Title = "NikeeHUB",
                Description = "Error",
                Content = "Encoding Error!",
                Color = Color3.fromRGB(235, 85, 85),
                Delay = 2
            })
            return
        end
        local success, err = pcall(function()
            writefile("Nikee_Configs/" .. configName .. ".json", encodedData)
        end)
        if success then
            SpeedHubUI:MakeNotify({
                Title = "NikeeHUB",
                Description = "Success",
                Content = "Config Saved!",
                Color = Color3.fromRGB(0, 139, 139),
                Delay = 2
            })
        else
            SpeedHubUI:MakeNotify({
                Title = "NikeeHUB",
                Description = "Error",
                Content = "Write Error: " .. tostring(err),
                Color = Color3.fromRGB(235, 85, 85),
                Delay = 2
            })
        end
    end
})

Section_Save:AddButton({
    Title = "LOAD CONFIG",
    Callback = function()
        if not isfile("Nikee_Configs/Default.json") then
            SpeedHubUI:MakeNotify({
                Title = "NikeeHUB",
                Description = "Error",
                Content = "Config not found!",
                Color = Color3.fromRGB(235, 85, 85),
                Delay = 2
            })
            return
        end
        local success, content = pcall(function() return readfile("Nikee_Configs/Default.json") end)
        if not success then
            SpeedHubUI:MakeNotify({
                Title = "NikeeHUB",
                Description = "Error",
                Content = "Read Failed!",
                Color = Color3.fromRGB(235, 85, 85),
                Delay = 2
            })
            return
        end
        local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(content) end)
        if decodeSuccess and data then
            if data.Webhooks then
                Current_Webhook_Fish = data.Webhooks.Fish or ""
                Current_Webhook_Leave = data.Webhooks.Leave or ""
                Current_Webhook_List = data.Webhooks.List or ""
                Current_Webhook_Admin = data.Webhooks.Admin or ""
            end
            if data.Players then
                TagList = data.Players
                for i = 1, 20 do
                    if not TagList[i] or type(TagList[i]) ~= "table" then TagList[i] = {"", ""} end
                end
            end
            if data.Settings then
                for k, v in pairs(data.Settings) do
                    if Settings[k] ~= nil then
                        Settings[k] = v
                    end
                end
            end
            SpeedHubUI:MakeNotify({
                Title = "NikeeHUB",
                Description = "Success",
                Content = "Config Loaded!",
                Color = Color3.fromRGB(0, 139, 139),
                Delay = 2
            })
        else
            SpeedHubUI:MakeNotify({
                Title = "NikeeHUB",
                Description = "Error",
                Content = "JSON Error!",
                Color = Color3.fromRGB(235, 85, 85),
                Delay = 2
            })
        end
    end
})

Section_Save:AddButton({
    Title = "DELETE CONFIG",
    Callback = function()
        if not isfile("Nikee_Configs/Default.json") then
            SpeedHubUI:MakeNotify({
                Title = "NikeeHUB",
                Description = "Error",
                Content = "Config not found!",
                Color = Color3.fromRGB(235, 85, 85),
                Delay = 2
            })
            return
        end
        delfile("Nikee_Configs/Default.json")
        SpeedHubUI:MakeNotify({
            Title = "NikeeHUB",
            Description = "Success",
            Content = "Config Deleted!",
            Color = Color3.fromRGB(0, 139, 139),
            Delay = 2
        })
    end
})

-- ============================================
-- WEBHOOK & CHAT MONITORING
-- ============================================
local function SendWebhook(data, category)
    if not ScriptActive then return end
    if category == "SECRET" and not Settings.SecretEnabled then return end
    if category == "STONE" and not Settings.RubyEnabled then return end
    if category == "EVOLVED" and not Settings.EvolvedEnabled then return end
    if category == "CRYSTALIZED" and not Settings.MutationCrystalized then return end
    if category == "CAVECRYSTAL" and not Settings.CaveCrystalEnabled then return end
    if category == "LEAVE" and not Settings.LeaveEnabled then return end
    local TargetURL = ""
    local contentMsg = ""
    local realUser = GetUsername(data.Player)
    local discordId = nil
    for i = 1, 20 do
        if TagList[i][1] ~= "" and string.lower(TagList[i][1]) == string.lower(realUser) then
            discordId = TagList[i][2]
            break
        end
    end
    if discordId and discordId ~= "" then
        if category == "LEAVE" then
            contentMsg = "User Left: <@" .. discordId .. ">"
        else
            contentMsg = "GG! <@" .. discordId .. ">"
        end
    end
    if category == "LEAVE" then
        TargetURL = Current_Webhook_Leave
    elseif category == "PLAYERS" then
        TargetURL = Current_Webhook_List
    else
        TargetURL = Current_Webhook_Fish
    end
    if not TargetURL or TargetURL == "" or string.find(TargetURL, "MASUKKAN_URL") then return end
    local embedTitle = ""
    local embedColor = 3447003
    local descriptionText = ""
    local pName = Settings.SpoilerName and ("||`" .. data.Player .. "`||") or ("`" .. data.Player .. "`")
    if category == "SECRET" then
        SessionStats.Secret = SessionStats.Secret + 1
        embedTitle = "Secret Caught!"
        embedColor = 3447003
        local lines = { "⚓ Fish: " .. data.Item }
        if data.Mutation and data.Mutation ~= "None" then table.insert(lines, "🧬 Mutation: " .. data.Mutation) end
        table.insert(lines, "⚖️ Weight: " .. data.Weight)
        descriptionText = "Player: " .. pName .. "\n\n```\n" .. table.concat(lines, "\n") .. "\n```"
    elseif category == "STONE" then
        SessionStats.Ruby = SessionStats.Ruby + 1
        embedTitle = "Ruby Gemstone!"
        embedColor = 16753920
        local lines = { "💎 Stone: " .. data.Item }
        if data.Mutation and data.Mutation ~= "None" then table.insert(lines, "✨ Mutation: " .. data.Mutation) end
        table.insert(lines, "⚖️ Weight: " .. data.Weight)
        descriptionText = "Player: " .. pName .. "\n\n```\n" .. table.concat(lines, "\n") .. "\n```"
    elseif category == "EVOLVED" then
        SessionStats.Evolved = SessionStats.Evolved + 1
        embedTitle = "Evolved Stone!"
        embedColor = 10181046
        local lines = { "🔮 Item: " .. data.Item }
        descriptionText = "Player: " .. pName .. "\n\n```\n" .. table.concat(lines, "\n") .. "\n```"
    elseif category == "CRYSTALIZED" then
        SessionStats.Crystalized = SessionStats.Crystalized + 1
        embedTitle = "CRYSTALIZED MUTATION!"
        embedColor = 3407871
        local lines = { "💎 Fish: " .. data.Item }
        table.insert(lines, "✨ Mutation: Crystalized")
        table.insert(lines, "⚖️ Weight: " .. data.Weight)
        descriptionText = "Player: " .. pName .. "\n\n```\n" .. table.concat(lines, "\n") .. "\n```"
    elseif category == "LEAVE" then
        local dispName = data.DisplayName or data.Player
        embedTitle = dispName .. " Left the server."
        embedColor = 16711680
        descriptionText = "👤 **@" .. data.Player .. "**"
    elseif category == "PLAYERS" then
        embedTitle = "👥 List Player In Server"
        embedColor = 5763719
        descriptionText = "Information\n" .. data.ListText
    elseif category == "CAVECRYSTAL" then
        SessionStats.CaveCrystal = SessionStats.CaveCrystal + 1
        embedTitle = "💎 Cave Crystal Event!"
        embedColor = 16776960
        descriptionText = "Information\n" .. data.ListText
    end
    SessionStats.TotalSent = SessionStats.TotalSent + 1
    local embedData = {
        ["username"] = "NikeeHUB",
        ["avatar_url"] = "https://i.imgur.com/CWWGnhO.jpeg",
        ["content"] = contentMsg,
        ["embeds"] = {{
            ["title"] = embedTitle,
            ["description"] = descriptionText,
            ["color"] = embedColor,
            ["footer"] = { ["text"] = "NikeeHUB Webhook", ["icon_url"] = "https://i.imgur.com/CWWGnhO.jpeg" }
        }}
    }
    pcall(function()
        httpRequest({
            Url = TargetURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(embedData)
        })
    end)
end

local function CheckAndSend(msg)
    if not ScriptActive then return end
    local cleanMsg = StripTags(msg)
    local lowerMsg = string.lower(cleanMsg)
    if string.find(lowerMsg, "evolved enchant stone") then
        local tempMsg = string.gsub(cleanMsg, "^%[Server%]:%s*", "")
        local p = string.match(tempMsg, "^(.*) obtained an?")
        if p then p = p:match("^%s*(.-)%s*$") else p = "Unknown Player" end
        local data = { Player = p, Item = "Evolved Enchant Stone", Mutation = "None", Weight = "N/A" }
        SendWebhook(data, "EVOLVED")
        return
    end
    if string.find(lowerMsg, "crystalized") then
        local tempMsg = string.gsub(cleanMsg, "^%[Server%]:%s*", "")
        local p, item_full, w = string.match(tempMsg, "^(.*) obtained an? (.*) %((.*)%)")
        if not p then
            p, item_full = string.match(tempMsg, "^(.*) obtained an? (.*)")
            w = "N/A"
        end
        if p and item_full then
            local finalItem = item_full
            local s, e = string.find(string.lower(item_full), "crystalized")
            if s then
                finalItem = string.sub(item_full, e + 1)
                finalItem = string.gsub(finalItem, "^%s+", "")
            end
            local check = string.lower(finalItem)
            local allowed = {"bioluminescent octopus", "blossom jelly", "cute dumbo", "star snail", "blue sea dragon"}
            local isAllowed = false
            for _, v in ipairs(allowed) do
                if string.find(check, v) then isAllowed = true; break end
            end
            if isAllowed then
                local data = { Player = p, Item = finalItem, Mutation = "Crystalized", Weight = w }
                SendWebhook(data, "CRYSTALIZED")
                return
            end
        end
    end
    if string.find(lowerMsg, "obtained an?") or string.find(lowerMsg, "chance!") then
        local data = ParseDataSmart(cleanMsg)
        if data then
            if data.Mutation and string.find(string.lower(data.Mutation), "crystalized") then
                SendWebhook(data, "CRYSTALIZED")
                return
            end
            if string.find(string.lower(data.Item), "evolved enchant stone") then
                SendWebhook(data, "EVOLVED")
                return
            end
            for _, name in pairs(StoneList) do
                if string.find(string.lower(data.Item), string.lower(name)) then
                    if string.find(string.lower(data.Item), "ruby") then
                        if data.Mutation and string.find(string.lower(data.Mutation), "gemstone") then
                            SendWebhook(data, "STONE")
                        end
                    else
                        SendWebhook(data, "STONE")
                    end
                    return
                end
            end
            for _, name in pairs(SecretList) do
                if string.find(string.lower(data.Item), string.lower(name)) then
                    SendWebhook(data, "SECRET")
                    return
                end
            end
        end
    end
end

-- Chat monitoring
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

-- Player leave monitoring
table.insert(Connections, Players.PlayerRemoving:Connect(function(p)
    if not ScriptActive then return end
    task.spawn(function()
        SendWebhook({ Player = p.Name, DisplayName = p.DisplayName }, "LEAVE")
    end)
end))

-- Foreign player detection
table.insert(Connections, Players.PlayerAdded:Connect(function(p)
    if not ScriptActive then return end
    if Settings.ForeignDetection then
        local isWhitelisted = false
        local checkName = string.lower(p.Name)
        for i = 1, 20 do
            local wlName = TagList[i][1] or ""
            if wlName ~= "" and string.lower(wlName) == checkName then
                isWhitelisted = true
                break
            end
        end
        if not isWhitelisted then
            task.spawn(function()
                if Current_Webhook_Admin == "" then return end
                local adminTags = ""
                local id1 = (TagList[1] and TagList[1][2]) or ""
                local id2 = (TagList[2] and TagList[2][2]) or ""
                if id1 ~= "" then adminTags = adminTags .. "<@" .. id1 .. "> " end
                if id2 ~= "" then adminTags = adminTags .. "<@" .. id2 .. "> " end
                local contentStr = "Foreign Player Detected!" .. adminTags
                local embed = {
                    ["username"] = "NikeeHUB Security",
                    ["avatar_url"] = "https://i.imgur.com/CWWGnhO.jpeg",
                    ["content"] = contentStr,
                    ["embeds"] = {{
                        ["title"] = "Player Information",
                        ["description"] = "```\nName: " .. p.DisplayName .. "\nUsername: " .. p.Name .. "\n```",
                        ["color"] = 16711680,
                        ["footer"] = { ["text"] = "NikeeHUB Webhook", ["icon_url"] = "https://i.imgur.com/CWWGnhO.jpeg" }
                    }}
                }
                pcall(function()
                    httpRequest({
                        Url = Current_Webhook_Admin,
                        Method = "POST",
                        Headers = {["Content-Type"]="application/json"},
                        Body = HttpService:JSONEncode(embed)
                    })
                end)
            end)
        end
    end
end))

-- Ping monitor
local LastPingAlert = 0
task.spawn(function()
    while ScriptActive do
        task.wait(5)
        if Settings.PingMonitor and ScriptActive then
            local success, ping = pcall(function()
                return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            if success and ping > 500 then
                if tick() - LastPingAlert > 60 then
                    LastPingAlert = tick()
                    task.spawn(function()
                        if Current_Webhook_Admin == "" then return end
                        local embed = {
                            ["username"] = "NikeeHUB",
                            ["avatar_url"] = "https://i.imgur.com/CWWGnhO.jpeg",
                            ["content"] = "⚠️ **HIGH PING DETECTED!**",
                            ["embeds"] = {{
                                ["title"] = "Server Lag Alert",
                                ["description"] = "```\nCurrent Ping: " .. math.floor(ping) .. " ms\n```",
                                ["color"] = 16776960,
                                ["footer"] = { ["text"] = "NikeeHUB Webhook", ["icon_url"] = "https://i.imgur.com/CWWGnhO.jpeg" }
                            }}
                        }
                        pcall(function()
                            httpRequest({
                                Url = Current_Webhook_Admin,
                                Method = "POST",
                                Headers = {["Content-Type"]="application/json"},
                                Body = HttpService:JSONEncode(embed)
                            })
                        end)
                    end)
                end
            end
        end
    end
end)

-- Cave Crystal watcher
local CaveCrystalDebounce = 0
local function StartInventoryWatcher()
    local Backpack = Players.LocalPlayer:WaitForChild("Backpack", 10)
    if not Backpack then return end
    table.insert(Connections, Backpack.ChildAdded:Connect(function(child)
        if not ScriptActive then return end
        if child.Name == "Cave Crystal" then
            if tick() - CaveCrystalDebounce > 10 then
                CaveCrystalDebounce = tick()
                SendWebhook({ Player = Players.LocalPlayer.Name, ListText = "⛏️ **Found a Cave Crystal!**" }, "CAVECRYSTAL")
            end
        end
    end))
end
task.spawn(StartInventoryWatcher)

-- AutoExecute Queue
task.spawn(function()
    local success, err = pcall(function()
        local queueTeleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
        if queueTeleport then
            local TpService = game:GetService("TeleportService")
            local TeleportingConn = TpService.TeleportInit:Connect(function()
                if Settings.AutoExecute then
                    print("NikeeHUB: Queuing Auto Execute...")
                    pcall(function()
                        queueTeleport([[
                            task.wait(5)
                            local paths = {"XAL CLOUD/FishIt/47.lua", "47.lua", "FishIt/47.lua"}
                            local scriptCode = nil
                            for _, p in ipairs(paths) do
                                local s, c = pcall(function() return readfile(p) end)
                                if s and c then scriptCode = c; break end
                            end
                            if scriptCode then
                                loadstring(scriptCode)()
                            else
                                warn("NikeeHUB AutoExecute: Could not find script file to execute!")
                            end
                        ]])
                    end)
                end
            end)
            table.insert(Connections, TeleportingConn)
        end
    end)
    if not success then warn("NikeeHUB: AutoExecute Not Supported: " .. tostring(err)) end
end)

print("✅ NikeeHUB System Session v1.0 Loaded! (SpeedHub UI Embedded)")
