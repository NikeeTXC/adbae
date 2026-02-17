print("ITG: Script Starting...")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local ScriptActive = true
local Connections = {}
local VirtualUser = game:GetService("VirtualUser")
local FishingController = require(ReplicatedStorage.Controllers.FishingController)

if not isfolder("XAL_Configs") then
    pcall(function() makefolder("XAL_Configs") end)
end

-- ============================================
-- MAIN UI LIBRARY (From UI/MainUi.lua)
-- ============================================

local Icons = {
    Nt        = "rbxassetid://84946340265305",
    lexshub   = "rbxassetid://71947103252559",
    player    = "rbxassetid://12120698352",
    web       = "rbxassetid://137601480983962",
    bag       = "rbxassetid://8601111810",
    shop      = "rbxassetid://4985385964",
    cart      = "rbxassetid://128874923961846",
    plug      = "rbxassetid://137601480983962",
    settings  = "rbxassetid://70386228443175",
    loop      = "rbxassetid://122032243989747",
    gps       = "rbxassetid://17824309485",
    compas    = "rbxassetid://125300760963399",
    gamepad   = "rbxassetid://84173963561612",
    boss      = "rbxassetid://13132186360",
    scroll    = "rbxassetid://114127804740858",
    menu      = "rbxassetid://6340513838",
    crosshair = "rbxassetid://12614416478",
    user      = "rbxassetid://108483430622128",
    stat      = "rbxassetid://12094445329",
    eyes      = "rbxassetid://14321059114",
    sword     = "rbxassetid://82472368671405",
    discord   = "rbxassetid://94434236999817",
    star      = "rbxassetid://107005941750079",
    skeleton  = "rbxassetid://17313330026",
    payment   = "rbxassetid://18747025078",
    scan      = "rbxassetid://109869955247116",
    alert     = "rbxassetid://73186275216515",
    question  = "rbxassetid://17510196486",
    idea      = "rbxassetid://16833255748",
    strom     = "rbxassetid://13321880293",
    water     = "rbxassetid://100076212630732",
    dcs       = "rbxassetid://15310731934",
    start     = "rbxassetid://108886429866687",
    next      = "rbxassetid://12662718374",
    rod       = "rbxassetid://103247953194129",
    fish      = "rbxassetid://97167558235554",
}

local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local viewport = workspace.CurrentCamera.ViewportSize

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

local function CircleClick(Button, X, Y)
    spawn(function()
        Button.ClipsDescendants = true
        local Circle = Instance.new("ImageLabel")
        Circle.Image = "rbxassetid://266543268"
        Circle.ImageColor3 = Color3.fromRGB(80, 80, 80)
        Circle.ImageTransparency = 0.8999999761581421
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.BackgroundTransparency = 1
        Circle.ZIndex = 10
        Circle.Name = "Circle"
        Circle.Parent = Button
        local NewX = X - Circle.AbsolutePosition.X
        local NewY = Y - Circle.AbsolutePosition.Y
        Circle.Position = UDim2.new(0, NewX, 0, NewY)
        local Size = 0
        if Button.AbsoluteSize.X > Button.AbsoluteSize.Y then Size = Button.AbsoluteSize.X * 1.5
        elseif Button.AbsoluteSize.X < Button.AbsoluteSize.Y then Size = Button.AbsoluteSize.Y * 1.5
        else Size = Button.AbsoluteSize.X * 1.5 end
        local Time = 0.5
        Circle:TweenSizeAndPosition(UDim2.new(0, Size, 0, Size), UDim2.new(0.5, -Size / 2, 0.5, -Size / 2), "Out", "Quad", Time, false, nil)
        for i = 1, 10 do
            Circle.ImageTransparency = Circle.ImageTransparency + 0.01
            wait(Time / 10)
        end
        Circle:Destroy()
    end)
end

local Chloex = {}
function Chloex:MakeNotify(NotifyConfig)
    local NotifyConfig = NotifyConfig or {}
    NotifyConfig.Title = NotifyConfig.Title or "NikeeHUB"
    NotifyConfig.Description = NotifyConfig.Description or "Notification"
    NotifyConfig.Content = NotifyConfig.Content or "Content"
    NotifyConfig.Color = NotifyConfig.Color or Color3.fromRGB(0, 139, 139)
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
            NotifyLayout.BackgroundTransparency = 0.9990000128746033
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
        local NotifyFrameReal = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local DropShadowHolder = Instance.new("Frame")
        local DropShadow = Instance.new("ImageLabel")
        local Top = Instance.new("Frame")
        local TextLabel = Instance.new("TextLabel")
        local UICorner1 = Instance.new("UICorner")
        local TextLabel1 = Instance.new("TextLabel")
        local Close = Instance.new("TextButton")
        local ImageLabel = Instance.new("ImageLabel")
        local TextLabel2 = Instance.new("TextLabel")

        NotifyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        NotifyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NotifyFrame.BorderSizePixel = 0
        NotifyFrame.Size = UDim2.new(1, 0, 0, 150)
        NotifyFrame.Name = "NotifyFrame"
        NotifyFrame.BackgroundTransparency = 1
        NotifyFrame.Parent = CoreGui.NotifyGui.NotifyLayout
        NotifyFrame.AnchorPoint = Vector2.new(0, 1)
        NotifyFrame.Position = UDim2.new(0, 0, 1, -(NotifyPosHeigh))

        NotifyFrameReal.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        NotifyFrameReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NotifyFrameReal.BorderSizePixel = 0
        NotifyFrameReal.Position = UDim2.new(0, 400, 0, 0)
        NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
        NotifyFrameReal.Name = "NotifyFrameReal"
        NotifyFrameReal.Parent = NotifyFrame

        UICorner.Parent = NotifyFrameReal
        UICorner.CornerRadius = UDim.new(0, 8)

        DropShadowHolder.BackgroundTransparency = 1
        DropShadowHolder.BorderSizePixel = 0
        DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
        DropShadowHolder.ZIndex = 0
        DropShadowHolder.Name = "DropShadowHolder"
        DropShadowHolder.Parent = NotifyFrameReal

        Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Top.BackgroundTransparency = 0.9990000128746033
        Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Top.BorderSizePixel = 0
        Top.Size = UDim2.new(1, 0, 0, 36)
        Top.Name = "Top"
        Top.Parent = NotifyFrameReal

        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.Text = NotifyConfig.Title
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextSize = 14
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.BackgroundTransparency = 0.9990000128746033
        TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel.BorderSizePixel = 0
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.Parent = Top
        TextLabel.Position = UDim2.new(0, 10, 0, 0)

        UICorner1.Parent = Top
        UICorner1.CornerRadius = UDim.new(0, 5)

        TextLabel1.Font = Enum.Font.GothamBold
        TextLabel1.Text = NotifyConfig.Description
        TextLabel1.TextColor3 = NotifyConfig.Color
        TextLabel1.TextSize = 14
        TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel1.BackgroundTransparency = 0.9990000128746033
        TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel1.BorderSizePixel = 0
        TextLabel1.Size = UDim2.new(1, 0, 1, 0)
        TextLabel1.Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
        TextLabel1.Parent = Top

        Close.Font = Enum.Font.SourceSans
        Close.Text = ""
        Close.TextColor3 = Color3.fromRGB(0, 0, 0)
        Close.TextSize = 14
        Close.AnchorPoint = Vector2.new(1, 0.5)
        Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Close.BackgroundTransparency = 0.9990000128746033
        Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Close.BorderSizePixel = 0
        Close.Position = UDim2.new(1, -5, 0.5, 0)
        Close.Size = UDim2.new(0, 25, 0, 25)
        Close.Name = "Close"
        Close.Parent = Top

        ImageLabel.Image = "rbxassetid://9886659671"
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ImageLabel.BackgroundTransparency = 0.9990000128746033
        ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ImageLabel.BorderSizePixel = 0
        ImageLabel.Position = UDim2.new(0.49000001, 0, 0.5, 0)
        ImageLabel.Size = UDim2.new(1, -8, 1, -8)
        ImageLabel.Parent = Close

        TextLabel2.Font = Enum.Font.GothamBold
        TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel2.TextSize = 13
        TextLabel2.Text = NotifyConfig.Content
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
        TextLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel2.BackgroundTransparency = 0.9990000128746033
        TextLabel2.TextColor3 = Color3.fromRGB(150.0000062584877, 150.0000062584877, 150.0000062584877)
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

function Nt(msg, delay, color, title, desc)
    return Chloex:MakeNotify({
        Title = title or "NikeeHUB",
        Description = desc or "Notification",
        Content = msg or "Content",
        Color = color or Color3.fromRGB(0, 139, 139),
        Delay = delay or 4
    })
end

-- ============================================
-- MAIN WINDOW CREATION
-- ============================================

function Chloex:Window(GuiConfig)
    GuiConfig = GuiConfig or {}
    GuiConfig.Title = GuiConfig.Title or "NikeeHUB"
    GuiConfig.Footer = GuiConfig.Footer or "ITG Webhook"
    GuiConfig.Color = GuiConfig.Color or Color3.fromRGB(0, 139, 139)
    GuiConfig["Tab Width"] = GuiConfig["Tab Width"] or 120
    GuiConfig.Version = GuiConfig.Version or 1
    GuiConfig.Image = GuiConfig.Image or "rbxassetid://108886429866687"

    local GuiFunc = {}
    local Elements = {}
    local ConfigData = {}
    local CURRENT_VERSION = GuiConfig.Version

    local Chloeex = Instance.new("ScreenGui")
    Chloeex.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Chloeex.Name = "Chloeex"
    Chloeex.ResetOnSpawn = false
    Chloeex.Parent = CoreGui

    local DropShadowHolder = Instance.new("Frame")
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.BorderSizePixel = 0
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadowHolder.Size = safeSize(640, 400)
    DropShadowHolder.ZIndex = 0
    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = Chloeex

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
    Main.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    Main.BackgroundTransparency = 0
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(1, -47, 1, -47)
    Main.Name = "Main"
    Main.Parent = DropShadow

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Main

    local Top = Instance.new("Frame")
    Top.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
    Top.BackgroundTransparency = 0
    Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Top.BorderSizePixel = 0
    Top.Size = UDim2.new(1, 0, 0, 38)
    Top.Name = "Top"
    Top.Parent = Main

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 8)
    TopCorner.Parent = Top

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.Text = GuiConfig.Title
    TextLabel.TextColor3 = GuiConfig.Color
    TextLabel.TextSize = 14
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 0.9990000128746033
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(1, -100, 1, 0)
    TextLabel.Position = UDim2.new(0, 10, 0, 0)
    TextLabel.Parent = Top

    local TextLabel1 = Instance.new("TextLabel")
    TextLabel1.Font = Enum.Font.GothamBold
    TextLabel1.Text = GuiConfig.Footer
    TextLabel1.TextColor3 = GuiConfig.Color
    TextLabel1.TextSize = 14
    TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel1.BackgroundTransparency = 0.9990000128746033
    TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel1.BorderSizePixel = 0
    TextLabel1.Size = UDim2.new(1, -(TextLabel.TextBounds.X + 104), 1, 0)
    TextLabel1.Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
    TextLabel1.Parent = Top

    local Close = Instance.new("TextButton")
    Close.Font = Enum.Font.SourceSans
    Close.Text = ""
    Close.TextColor3 = Color3.fromRGB(0, 0, 0)
    Close.TextSize = 14
    Close.AnchorPoint = Vector2.new(1, 0.5)
    Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Close.BackgroundTransparency = 0.9990000128746033
    Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Close.BorderSizePixel = 0
    Close.Position = UDim2.new(1, -8, 0.5, 0)
    Close.Size = UDim2.new(0, 25, 0, 25)
    Close.Name = "Close"
    Close.Parent = Top

    local ImageLabel1 = Instance.new("ImageLabel")
    ImageLabel1.Image = "rbxassetid://9886659671"
    ImageLabel1.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel1.BackgroundTransparency = 0.9990000128746033
    ImageLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel1.BorderSizePixel = 0
    ImageLabel1.Position = UDim2.new(0.49, 0, 0.5, 0)
    ImageLabel1.Size = UDim2.new(1, -8, 1, -8)
    ImageLabel1.Parent = Close

    local Min = Instance.new("TextButton")
    Min.Font = Enum.Font.SourceSans
    Min.Text = ""
    Min.TextColor3 = Color3.fromRGB(0, 0, 0)
    Min.TextSize = 14
    Min.AnchorPoint = Vector2.new(1, 0.5)
    Min.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Min.BackgroundTransparency = 0.9990000128746033
    Min.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Min.BorderSizePixel = 0
    Min.Position = UDim2.new(1, -38, 0.5, 0)
    Min.Size = UDim2.new(0, 25, 0, 25)
    Min.Name = "Min"
    Min.Parent = Top

    local ImageLabel2 = Instance.new("ImageLabel")
    ImageLabel2.Image = "rbxassetid://9886659670"
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel2.BackgroundTransparency = 0.9990000128746033
    ImageLabel2.ImageTransparency = 0.2
    ImageLabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel2.BorderSizePixel = 0
    ImageLabel2.Position = UDim2.new(0.5, 0, 0.5, 0)
    ImageLabel2.Size = UDim2.new(1, -9, 1, -9)
    ImageLabel2.Parent = Min

    local LayersTab = Instance.new("Frame")
    LayersTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LayersTab.BackgroundTransparency = 0.9990000128746033
    LayersTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LayersTab.BorderSizePixel = 0
    LayersTab.Position = UDim2.new(0, 9, 0, 50)
    LayersTab.Size = UDim2.new(0, GuiConfig["Tab Width"], 1, -59)
    LayersTab.Name = "LayersTab"
    LayersTab.Parent = Main

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 2)
    TabCorner.Parent = LayersTab

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
    Layers.BackgroundTransparency = 0.9990000128746033
    Layers.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Layers.BorderSizePixel = 0
    Layers.Position = UDim2.new(0, GuiConfig["Tab Width"] + 18, 0, 50)
    Layers.Size = UDim2.new(1, -(GuiConfig["Tab Width"] + 9 + 18), 1, -59)
    Layers.Name = "Layers"
    Layers.Parent = Main

    local LayersCorner = Instance.new("UICorner")
    LayersCorner.CornerRadius = UDim.new(0, 2)
    LayersCorner.Parent = Layers

    local NameTab = Instance.new("TextLabel")
    NameTab.Font = Enum.Font.GothamBold
    NameTab.Text = ""
    NameTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameTab.TextSize = 24
    NameTab.TextWrapped = true
    NameTab.TextXAlignment = Enum.TextXAlignment.Left
    NameTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NameTab.BackgroundTransparency = 0.9990000128746033
    NameTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NameTab.BorderSizePixel = 0
    NameTab.Size = UDim2.new(1, 0, 0, 30)
    NameTab.Name = "NameTab"
    NameTab.Parent = Layers

    local LayersReal = Instance.new("Frame")
    LayersReal.AnchorPoint = Vector2.new(0, 1)
    LayersReal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LayersReal.BackgroundTransparency = 0.9990000128746033
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
    ScrollTab.CanvasSize = UDim2.new(0, 0, 1.10000002, 0)
    ScrollTab.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
    ScrollTab.ScrollBarThickness = 0
    ScrollTab.Active = true
    ScrollTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ScrollTab.BackgroundTransparency = 0.9990000128746033
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
        if CoreGui:FindFirstChild("Chloeex") then Chloeex:Destroy() end
    end

    Min.Activated:Connect(function()
        CircleClick(Min, Mouse.X, Mouse.Y)
        DropShadowHolder.Visible = false
    end)

    Close.Activated:Connect(function()
        CircleClick(Close, Mouse.X, Mouse.Y)
        local Overlay = Instance.new("Frame")
        Overlay.Size = UDim2.new(1, 0, 1, 0)
        Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Overlay.BackgroundTransparency = 0.3
        Overlay.ZIndex = 50
        Overlay.Parent = DropShadowHolder

        local Dialog = Instance.new("ImageLabel")
        Dialog.Size = UDim2.new(0, 300, 0, 150)
        Dialog.Position = UDim2.new(0.5, -150, 0.5, -75)
        Dialog.Image = "rbxassetid://9542022979"
        Dialog.ImageTransparency = 0
        Dialog.BorderSizePixel = 0
        Dialog.ZIndex = 51
        Dialog.Parent = Overlay
        Instance.new("UICorner", Dialog).CornerRadius = UDim.new(0, 8)

        local DialogGlow = Instance.new("Frame")
        DialogGlow.Size = UDim2.new(0, 310, 0, 160)
        DialogGlow.Position = UDim2.new(0.5, -155, 0.5, -80)
        DialogGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DialogGlow.BackgroundTransparency = 0.75
        DialogGlow.BorderSizePixel = 0
        DialogGlow.ZIndex = 50
        DialogGlow.Parent = Overlay
        Instance.new("UICorner", DialogGlow).CornerRadius = UDim.new(0, 10)

        local Gradient = Instance.new("UIGradient")
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 191, 255)),
            ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 140, 255)),
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 191, 255))
        })
        Gradient.Rotation = 90
        Gradient.Parent = DialogGlow

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 40)
        Title.Position = UDim2.new(0, 0, 0, 4)
        Title.BackgroundTransparency = 1
        Title.Font = Enum.Font.GothamBold
        Title.Text = "NikeeHUB Window"
        Title.TextSize = 22
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.ZIndex = 52
        Title.Parent = Dialog

        local Message = Instance.new("TextLabel")
        Message.Size = UDim2.new(1, -20, 0, 60)
        Message.Position = UDim2.new(0, 10, 0, 30)
        Message.BackgroundTransparency = 1
        Message.Font = Enum.Font.Gotham
        Message.Text = "Do you want to close this window?\nYou will not be able to open it again"
        Message.TextSize = 14
        Message.TextColor3 = Color3.fromRGB(200, 200, 200)
        Message.TextWrapped = true
        Message.ZIndex = 52
        Message.Parent = Dialog

        local Yes = Instance.new("TextButton")
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
        Yes.Name = "Yes"
        Yes.Parent = Dialog
        Instance.new("UICorner", Yes).CornerRadius = UDim.new(0, 6)

        local Cancel = Instance.new("TextButton")
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
        Cancel.Name = "Cancel"
        Cancel.Parent = Dialog
        Instance.new("UICorner", Cancel).CornerRadius = UDim.new(0, 6)

        Yes.MouseButton1Click:Connect(function()
            if Chloeex then Chloeex:Destroy() end
            if game.CoreGui:FindFirstChild("ToggleUIButton") then game.CoreGui.ToggleUIButton:Destroy() end
            ScriptActive = false
        end)

        Cancel.MouseButton1Click:Connect(function() Overlay:Destroy() end)
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
        Instance.new("UICorner", MainButton).CornerRadius = UDim.new(0, 6)

        local Button = Instance.new("TextButton")
        Button.Parent = MainButton
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.BackgroundTransparency = 1
        Button.Text = ""

        Button.MouseButton1Click:Connect(function()
            if DropShadowHolder then DropShadowHolder.Visible = not DropShadowHolder.Visible end
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
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
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

    DropShadowHolder.Size = UDim2.new(0, 115 + TextLabel.TextBounds.X + 1 + TextLabel1.TextBounds.X, 0, 350)
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
        ScrolLayers.BackgroundTransparency = 0.9990000128746033
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
        if CountTab == 0 then
            Tab.BackgroundTransparency = 0.92
        else
            Tab.BackgroundTransparency = 0.999
        end
        Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Tab.BorderSizePixel = 0
        Tab.LayoutOrder = CountTab
        Tab.Size = UDim2.new(1, 0, 0, 30)
        Tab.Name = "Tab"
        Tab.Parent = ScrollTab

        Instance.new("UICorner", Tab).CornerRadius = UDim.new(0, 4)

        local TabButton = Instance.new("TextButton")
        TabButton.Font = Enum.Font.GothamBold
        TabButton.Text = ""
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 13
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundTransparency = 0.9990000128746033
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
        TabName.BackgroundTransparency = 0.9990000128746033
        TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabName.BorderSizePixel = 0
        TabName.Size = UDim2.new(1, 0, 1, 0)
        TabName.Position = UDim2.new(0, 30, 0, 0)
        TabName.Name = "TabName"
        TabName.Parent = Tab

        local FeatureImg = Instance.new("ImageLabel")
        FeatureImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        FeatureImg.BackgroundTransparency = 0.9990000128746033
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

            Instance.new("UICorner", ChooseFrame).CornerRadius = UDim.new(0, 4)
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
            Section.BackgroundTransparency = 0.9990000128746033
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
            Instance.new("UICorner", SectionReal).CornerRadius = UDim.new(0, 4)

            local SectionButton = Instance.new("TextButton")
            SectionButton.Font = Enum.Font.SourceSans
            SectionButton.Text = ""
            SectionButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            SectionButton.TextSize = 14
            SectionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionButton.BackgroundTransparency = 0.9990000128746033
            SectionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SectionButton.BorderSizePixel = 0
            SectionButton.Size = UDim2.new(1, 0, 1, 0)
            SectionButton.Name = "SectionButton"
            SectionButton.Parent = SectionReal

            local FeatureFrame = Instance.new("Frame")
            FeatureFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            FeatureFrame.BackgroundTransparency = 1
            FeatureFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            FeatureFrame.BorderSizePixel = 0
            FeatureFrame.Position = UDim2.new(0, 8, 0, 10)
            FeatureFrame.Size = UDim2.new(0, 16, 0, 10)
            FeatureFrame.Name = "FeatureFrame"
            FeatureFrame.Parent = SectionReal

            local ArrowImg = Instance.new("ImageLabel")
            ArrowImg.Image = "rbxassetid://16851841101"
            ArrowImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
            AnchorPoint = Vector2.new(0.5, 0.5)
            ArrowImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ArrowImg.BackgroundTransparency = 0.9990000128746033
            ArrowImg.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ArrowImg.BorderSizePixel = 0
            ArrowImg.Position = UDim2.new(0.5, 0, 0.5, 0)
            ArrowImg.Size = UDim2.new(1, 0, 1, 0)
            ArrowImg.Name = "ArrowImg"
            ArrowImg.Parent = FeatureFrame

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = Title
            SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.TextSize = 13
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.BackgroundTransparency = 0.9990000128746033
            SectionTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SectionTitle.BorderSizePixel = 0
            SectionTitle.Position = UDim2.new(0, 30, 0, 0)
            SectionTitle.Size = UDim2.new(1, -10, 1, 0)
            SectionTitle.Name = "SectionTitle"
            SectionTitle.Parent = SectionReal

            local SectionDecideFrame = Instance.new("Frame")
            SectionDecideFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionDecideFrame.BackgroundTransparency = 0.9990000128746033
            SectionDecideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SectionDecideFrame.BorderSizePixel = 0
            SectionDecideFrame.Position = UDim2.new(0, 0, 1, 0)
            SectionDecideFrame.Size = UDim2.new(0, 0, 0, 2)
            SectionDecideFrame.Name = "SectionDecideFrame"
            SectionDecideFrame.Parent = SectionReal

            local SectionAdd = Instance.new("Frame")
            SectionAdd.AnchorPoint = Vector2.new(0.5, 0)
            SectionAdd.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionAdd.BackgroundTransparency = 0.9990000128746033
            SectionAdd.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SectionAdd.BorderSizePixel = 0
            SectionAdd.Position = UDim2.new(0.5, 0, 0, 38)
            SectionAdd.Size = UDim2.new(1, 0, 0, 0)
            SectionAdd.Name = "SectionAdd"
            SectionAdd.Parent = Section

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

            local Items = {}
            local CountItem = 0

            function Items:AddToggle(ToggleConfig)
                local ToggleConfig = ToggleConfig or {}
                ToggleConfig.Title = ToggleConfig.Title or "Title"
                ToggleConfig.Title2 = ToggleConfig.Title2 or ""
                ToggleConfig.Content = ToggleConfig.Content or ""
                ToggleConfig.Default = ToggleConfig.Default or false
                ToggleConfig.Callback = ToggleConfig.Callback or function() end

                local Toggle = Instance.new("Frame")
                Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Toggle.BackgroundTransparency = 0.935
                Toggle.BorderSizePixel = 0
                Toggle.LayoutOrder = CountItem
                Toggle.Name = "Toggle"
                Toggle.Parent = SectionAdd

                Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 4)

                local ToggleTitle = Instance.new("TextLabel")
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

                local ToggleContent = Instance.new("TextLabel")
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

                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Font = Enum.Font.SourceSans
                ToggleButton.Text = ""
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Position = UDim2.new(1, -50, 0, 10)
                ToggleButton.Size = UDim2.new(0, 40, 0, 20)
                ToggleButton.Name = "ToggleButton"
                ToggleButton.Parent = Toggle

                local ToggleCircle = Instance.new("Frame")
                ToggleCircle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                ToggleCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ToggleCircle.BorderSizePixel = 0
                ToggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
                ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
                ToggleCircle.Name = "ToggleCircle"
                ToggleCircle.Parent = ToggleButton
                Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

                local UIStroke8 = Instance.new("UIStroke")
                UIStroke8.Color = Color3.fromRGB(90, 90, 90)
                UIStroke8.Thickness = 1.6
                UIStroke8.Parent = ToggleCircle

                local ToggleFunc = { Value = ToggleConfig.Default }

                local function UpdateToggle(state)
                    ToggleFunc.Value = state
                    local targetColor = state and GuiConfig.Color or Color3.fromRGB(60, 60, 60)
                    local targetPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), { BackgroundColor3 = targetColor }):Play()
                    ToggleCircle:TweenPosition(targetPos, "Out", "Sine", 0.15, true)
                end

                UpdateToggle(ToggleConfig.Default)

                ToggleButton.MouseButton1Click:Connect(function()
                    ToggleFunc.Value = not ToggleFunc.Value
                    UpdateToggle(ToggleFunc.Value)
                    ToggleConfig.Callback(ToggleFunc.Value)
                end)

                function ToggleFunc:Set(state)
                    UpdateToggle(state)
                    ToggleConfig.Callback(state)
                end

                CountItem = CountItem + 1
                return ToggleFunc
            end

            function Items:AddInput(InputConfig)
                local InputConfig = InputConfig or {}
                InputConfig.Title = InputConfig.Title or "Title"
                InputConfig.Content = InputConfig.Content or ""
                InputConfig.Placeholder = InputConfig.Placeholder or "Input Here"
                InputConfig.Default = InputConfig.Default or ""
                InputConfig.Callback = InputConfig.Callback or function() end

                local Input = Instance.new("Frame")
                Input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Input.BackgroundTransparency = 0.935
                Input.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Input.BorderSizePixel = 0
                Input.LayoutOrder = CountItem
                Input.Size = UDim2.new(1, 0, 0, 46)
                Input.Name = "Input"
                Input.Parent = SectionAdd

                Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 4)

                local InputTitle = Instance.new("TextLabel")
                InputTitle.Font = Enum.Font.GothamBold
                InputTitle.Text = InputConfig.Title
                InputTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                InputTitle.TextSize = 13
                InputTitle.TextXAlignment = Enum.TextXAlignment.Left
                InputTitle.TextYAlignment = Enum.TextYAlignment.Top
                InputTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                InputTitle.BackgroundTransparency = 0.9990000128746033
                InputTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                InputTitle.BorderSizePixel = 0
                InputTitle.Position = UDim2.new(0, 10, 0, 10)
                InputTitle.Size = UDim2.new(1, -180, 0, 13)
                InputTitle.Name = "InputTitle"
                InputTitle.Parent = Input

                local InputContent = Instance.new("TextLabel")
                InputContent.Font = Enum.Font.GothamBold
                InputContent.Text = InputConfig.Content
                InputContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputContent.TextSize = 12
                InputContent.TextTransparency = 0.6
                InputContent.TextWrapped = true
                InputContent.TextXAlignment = Enum.TextXAlignment.Left
                InputContent.TextYAlignment = Enum.TextYAlignment.Bottom
                InputContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                InputContent.BackgroundTransparency = 0.9990000128746033
                InputContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
                InputContent.BorderSizePixel = 0
                InputContent.Position = UDim2.new(0, 10, 0, 25)
                InputContent.Size = UDim2.new(1, -180, 0, 12)
                InputContent.Name = "InputContent"
                InputContent.Parent = Input

                InputContent.Size = UDim2.new(1, -180, 0, 12 + (12 * (InputContent.TextBounds.X // InputContent.AbsoluteSize.X)))
                InputContent.TextWrapped = true
                Input.Size = UDim2.new(1, 0, 0, InputContent.AbsoluteSize.Y + 33)

                local InputFrame = Instance.new("Frame")
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
                Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 4)

                local InputTextBox = Instance.new("TextBox")
                InputTextBox.CursorPosition = -1
                InputTextBox.Font = Enum.Font.GothamBold
                InputTextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
                InputTextBox.PlaceholderText = InputConfig.Placeholder
                InputTextBox.Text = InputConfig.Default
                InputTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputTextBox.TextSize = 12
                InputTextBox.TextXAlignment = Enum.TextXAlignment.Left
                InputTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                InputTextBox.BackgroundTransparency = 0.9990000128746033
                InputTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
                InputTextBox.BorderSizePixel = 0
                InputTextBox.Position = UDim2.new(0, 5, 0.5, 0)
                InputTextBox.Size = UDim2.new(1, -10, 1, -8)
                InputTextBox.Name = "InputTextBox"
                InputTextBox.Parent = InputFrame

                local InputFunc = { Value = InputConfig.Default }

                function InputFunc:Set(Value)
                    InputTextBox.Text = Value
                    InputFunc.Value = Value
                    InputConfig.Callback(Value)
                end

                InputFunc:Set(InputFunc.Value)

                InputTextBox.FocusLost:Connect(function()
                    InputFunc:Set(InputTextBox.Text)
                end)

                CountItem = CountItem + 1
                return InputFunc
            end

            function Items:AddButton(ButtonConfig)
                local ButtonConfig = ButtonConfig or {}
                ButtonConfig.Title = ButtonConfig.Title or "Confirm"
                ButtonConfig.Callback = ButtonConfig.Callback or function() end
                ButtonConfig.SubTitle = ButtonConfig.SubTitle or nil
                ButtonConfig.SubCallback = ButtonConfig.SubCallback or function() end

                local Button = Instance.new("Frame")
                Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Button.BackgroundTransparency = 0.935
                Button.Size = UDim2.new(1, 0, 0, 40)
                Button.LayoutOrder = CountItem
                Button.Parent = SectionAdd

                Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)

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
                Instance.new("UICorner", MainButton).CornerRadius = UDim.new(0, 4)

                MainButton.MouseButton1Click:Connect(ButtonConfig.Callback)

                if ButtonConfig.SubTitle then
                    local SubButton = Instance.new("TextButton")
                    SubButton.Font = Enum.Font.GothamBold
                    SubButton.Text = ButtonConfig.SubTitle
                    SubButton.TextSize = 12
                    SubButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    SubButton.TextTransparency = 0.3
                    SubButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    SubButton.BackgroundTransparency = 0.935
                    SubButton.Size = UDim2.new(0.5, -8, 1, -10)
                    SubButton.Position = UDim2.new(0.5, 2, 0, 5)
                    SubButton.Parent = Button
                    Instance.new("UICorner", SubButton).CornerRadius = UDim.new(0, 4)

                    SubButton.MouseButton1Click:Connect(ButtonConfig.SubCallback)
                end

                CountItem = CountItem + 1
            end

            return Items
        end

        CountSection = CountSection + 1
        return Sections
    end

    CountTab = CountTab + 1
    return Tabs
end

-- ============================================
-- CREATE WINDOW & TABS
-- ============================================

local Window = Chloex:Window({
    Title = "NikeeHUB",
    Footer = "ITG Webhook",
    Color = Color3.fromRGB(0, 139, 139),
    Image = "rbxassetid://108886429866687"
})

-- Tab: Webhook
local WebhookTab = Window:AddTab({ Name = "Webhook", Icon = "web" })
local WebhookSection = WebhookSection or WebhookTab:AddSection("Webhook URLs", true)

-- Tab: Settings
local SettingsTab = Window:AddTab({ Name = "Settings", Icon = "settings" })
local SettingsSection = SettingsTab:AddSection("General Settings", true)

-- Tab: Fishing
local FishingTab = Window:AddTab({ Name = "Fishing", Icon = "fish" })
local FishingSection = FishingTab:AddSection("Fishing Features", true)

-- Tab: Teleport
local TeleportTab = Window:AddTab({ Name = "Teleport", Icon = "gps" })
local TeleportSection = TeleportTab:AddSection("Teleport Locations", true)

-- Tab: Session Stats
local StatsTab = Window:AddTab({ Name = "Session Stats", Icon = "stat" })
local StatsSection = StatsTab:AddSection("Statistics", true)

-- Tab: Save Config
local SaveTab = Window:AddTab({ Name = "Save Config", Icon = "bag" })
local SaveSection = SaveTab:AddSection("Configuration", true)

print("✅ NikeeHUB UI Loaded!")

-- ============================================
-- ORIGINAL FUNCTIONALITY VARIABLES
-- ============================================

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

local Current_Webhook_Fish = ""
local Current_Webhook_Leave = ""
local Current_Webhook_List = ""
local Current_Webhook_Admin = ""
local LastDisconnectTime = 0
local AdminID_1 = ""
local AdminID_2 = ""

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

local TagList = {}
local TagUIElements = {}
for i = 1, 20 do TagList[i] = {"", ""} end

local SessionStart = tick()
local SessionStats = {
    Secret = 0,
    Ruby = 0,
    Evolved = 0,
    Crystalized = 0,
    CaveCrystal = 0,
    TotalSent = 0
}

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
        Nt("Teleported!", 3, Color3.fromRGB(0, 208, 255), "Teleport", "Success")
    else
        Nt("Invalid TP Data", 3, Color3.fromRGB(235, 85, 85), "Teleport", "Error")
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
        local label = inv:FindFirstChild("Main") and inv.Main:FindFirstChild("Top") and inv.Main.Top:FindFirstChild("Options") and inv.Main.Top.Options.Fish:FindFirstChild("Label") and inv.Main.Top.Options.Fish.Label:FindFirstChild("BagSize")
        if label then
            return tonumber((label.Text or "0/???"):match("(%d+)/")) or 0
        end
    end
    return 0
end

-- ============================================
-- WEBHOOK FUNCTIONS
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
        ["avatar_url"] = "https://i.imgur.com/sblcM31.jpeg",
        ["content"] = contentMsg,
        ["embeds"] = {{
            ["title"] = embedTitle,
            ["description"] = descriptionText,
            ["color"] = embedColor,
            ["footer"] = { ["text"] = "NikeeHUB", ["icon_url"] = "https://i.imgur.com/sblcM31.jpeg" }
        }}
    }
    pcall(function()
        httpRequest({ Url = TargetURL, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode(embedData) })
    end)
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

local function CheckAndSend(msg)
    if not ScriptActive then return end
    local cleanMsg = StripTags(msg)
    local lowerMsg = string.lower(cleanMsg)

    if string.find(lowerMsg, "evolved enchant stone") then
        local tempMsg = string.gsub(cleanMsg, "^%[Server%]:%s*", "")
        local p = string.match(tempMsg, "^(.*) obtained an?")
        if not p then p = "Unknown Player" end
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

-- ============================================
-- CHAT MONITORING
-- ============================================

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

-- ============================================
-- PLAYER REMOVE/ADD MONITORING
-- ============================================

table.insert(Connections, Players.PlayerRemoving:Connect(function(p)
    if not ScriptActive then return end
    task.spawn(function() SendWebhook({ Player = p.Name, DisplayName = p.DisplayName }, "LEAVE") end)
end))

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
                    ["avatar_url"] = "https://i.imgur.com/sblcM31.jpeg",
                    ["content"] = contentStr,
                    ["embeds"] = {{
                        ["title"] = "Player Information",
                        ["description"] = "```\nName: " .. p.DisplayName .. "\nUsername: " .. p.Name .. "\n```",
                        ["color"] = 16711680,
                        ["footer"] = { ["text"] = "NikeeHUB", ["icon_url"] = "https://i.imgur.com/sblcM31.jpeg" }
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

-- ============================================
-- BUILD UI ELEMENTS
-- ============================================

-- Webhook Section
local FishInput = WebhookSection:AddInput({
    Title = "Fish Webhook",
    Content = "Webhook URL for fish catches",
    Placeholder = "Paste webhook URL...",
    Default = "",
    Callback = function(v) Current_Webhook_Fish = v end
})

local LeaveInput = WebhookSection:AddInput({
    Title = "Leave Webhook",
    Content = "Webhook URL for player leaves",
    Placeholder = "Paste webhook URL...",
    Default = "",
    Callback = function(v) Current_Webhook_Leave = v end
})

local ListInput = WebhookSection:AddInput({
    Title = "List Webhook",
    Content = "Webhook URL for player lists",
    Placeholder = "Paste webhook URL...",
    Default = "",
    Callback = function(v) Current_Webhook_List = v end
})

local AdminInput = WebhookSection:AddInput({
    Title = "Admin Webhook",
    Content = "Webhook URL for admin alerts",
    Placeholder = "Paste webhook URL...",
    Default = "",
    Callback = function(v) Current_Webhook_Admin = v end
})

WebhookSection:AddButton({
    Title = "Test All Webhooks",
    Callback = function()
        Nt("Testing webhooks...", 3, Color3.fromRGB(0, 139, 139), "Webhook Test", "Info")
    end
})

-- Settings Section
SettingsSection:AddToggle({
    Title = "Secret Fish",
    Content = "Enable webhook for secret fish",
    Default = false,
    Callback = function(v) Settings.SecretEnabled = v end
})

SettingsSection:AddToggle({
    Title = "Ruby Gemstone",
    Content = "Enable webhook for ruby gemstones",
    Default = false,
    Callback = function(v) Settings.RubyEnabled = v end
})

SettingsSection:AddToggle({
    Title = "Evolved Stone",
    Content = "Enable webhook for evolved enchant stone",
    Default = false,
    Callback = function(v) Settings.EvolvedEnabled = v end
})

SettingsSection:AddToggle({
    Title = "Mutation Crystalized",
    Content = "Enable webhook for crystalized mutations",
    Default = false,
    Callback = function(v) Settings.MutationCrystalized = v end
})

SettingsSection:AddToggle({
    Title = "Cave Crystal",
    Content = "Enable webhook for cave crystals",
    Default = false,
    Callback = function(v) Settings.CaveCrystalEnabled = v end
})

SettingsSection:AddToggle({
    Title = "Leave Message",
    Content = "Enable webhook when players leave",
    Default = false,
    Callback = function(v) Settings.LeaveEnabled = v end
})

SettingsSection:AddToggle({
    Title = "Foreign Detection",
    Content = "Alert when non-whitelisted players join",
    Default = false,
    Callback = function(v) Settings.ForeignDetection = v end
})

SettingsSection:AddToggle({
    Title = "Spoiler Name",
    Content = "Hide player names with spoiler tags",
    Default = true,
    Callback = function(v) Settings.SpoilerName = v end
})

SettingsSection:AddToggle({
    Title = "No Animation",
    Content = "Disable character animations",
    Default = false,
    Callback = function(v)
        if v then
            local character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local animator = humanoid:FindFirstChildOfClass("Animator")
                if animator then animator:Destroy() end
            end
            local animateScript = character:FindFirstChild("Animate")
            if animateScript then animateScript.Enabled = false end
        end
    end
})

-- Fishing Section
local AutoShakeEnabled = false
FishingSection:AddToggle({
    Title = "Auto Click Fishing",
    Content = "Automatically click during fishing minigame",
    Default = false,
    Callback = function(v)
        AutoShakeEnabled = v
        if v then
            task.spawn(function()
                while AutoShakeEnabled and ScriptActive do
                    pcall(function() FishingController:RequestFishingMinigameClick() end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

local AutoSellEnabled = false
FishingSection:AddToggle({
    Title = "Auto Sell",
    Content = "Automatically sell fish every 10 minutes",
    Default = false,
    Callback = function(v)
        AutoSellEnabled = v
        if v then
            local RF_Sell = GetRemote("RF/SellAllItems")
            if RF_Sell then
                task.spawn(function()
                    while AutoSellEnabled and ScriptActive do
                        pcall(function() RF_Sell:InvokeServer() end)
                        task.wait(600)
                    end
                end)
            end
        end
    end
})

-- Teleport Section
local sortedAreas = {}
for name, _ in pairs(FishingAreas) do table.insert(sortedAreas, name) end
table.sort(sortedAreas)

for i = 1, #sortedAreas, 2 do
    local name1 = sortedAreas[i]
    local name2 = sortedAreas[i+1]
    local data1 = FishingAreas[name1]
    
    TeleportSection:AddButton({
        Title = "TP to " .. name1,
        Callback = function()
            TeleportToLookAt(data1.Pos, data1.Look)
        end
    })
    
    if name2 then
        local data2 = FishingAreas[name2]
        TeleportSection:AddButton({
            Title = "TP to " .. name2,
            Callback = function()
                TeleportToLookAt(data2.Pos, data2.Look)
            end
        })
    end
end

-- Stats Section
local UptimeLabel = Instance.new("TextLabel")
UptimeLabel.BackgroundTransparency = 1
UptimeLabel.Size = UDim2.new(1, 0, 0, 20)
UptimeLabel.Font = Enum.Font.GothamBold
UptimeLabel.Text = "Uptime: 00h 00m 00s"
UptimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UptimeLabel.TextSize = 13
UptimeLabel.TextXAlignment = "Left"
UptimeLabel.Parent = StatsSection

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

StatsSection:AddButton({
    Title = "Send Stats to Webhook",
    Callback = function()
        if Current_Webhook_Admin == "" then
            Nt("Admin webhook is empty!", 3, Color3.fromRGB(235, 85, 85), "Error", "Stats")
            return
        end
        Nt("Sending stats...", 3, Color3.fromRGB(0, 139, 139), "Stats", "Info")
    end
})

-- Save Config Section
local ConfigNameInput = SaveSection:AddInput({
    Title = "Config Name",
    Content = "Enter a name for your config",
    Placeholder = "MyConfig",
    Default = "",
    Callback = function() end
})

SaveSection:AddButton({
    Title = "Save Config",
    Callback = function()
        local name = ConfigNameInput.Value
        if name == "" then
            Nt("Config name cannot be empty!", 3, Color3.fromRGB(235, 85, 85), "Error", "Save")
            return
        end
        Nt("Config saved: " .. name, 3, Color3.fromRGB(75, 185, 115), "Success", "Save")
    end
})

SaveSection:AddButton({
    Title = "Load Config",
    Callback = function()
        Nt("Config loading feature", 3, Color3.fromRGB(0, 139, 139), "Info", "Load")
    end
})

-- ============================================
-- ANTI-AFK
-- ============================================

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
    print("XAL: Anti-AFK Active")
end)

-- ============================================
-- CAVE CRYSTAL WATCHER
-- ============================================

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

print("✅ NikeeHUB System v1.0 Loaded!")
print("🎣 Happy Fishing!")
