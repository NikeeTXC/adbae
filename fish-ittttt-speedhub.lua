-- NikeeHUB FishIt - SpeedHub UI Version
-- GitHub: https://github.com/MajestySkie/Chloe-X
-- Usage: loadstring(game:HttpGet("https://raw.githubusercontent.com/MajestySkie/Chloe-X/main/Main/ChloeX"))()

-- ============================================
-- MENGHUB UI LIBRARY (Inline - SpeedHub)
-- ============================================
local MengHub = (function()
local HttpService = game:GetService("HttpService")
local ConfigPath = "Meng Hub_Abyss/Config/"
if not isfolder("Meng Hub_Abyss") then makefolder("Meng Hub_Abyss") end
if not isfolder("Meng Hub_Abyss/Config") then makefolder("Meng Hub_Abyss/Config") end
local ConfigData = {}
local Elements = {}
local CURRENT_VERSION = nil
local Icons = {
    player = "rbxassetid://12120698352", web = "rbxassetid://137601480983962", bag = "rbxassetid://8601111810",
    shop = "rbxassetid://4985385964", cart = "rbxassetid://128874923961846", plug = "rbxassetid://137601480983962",
    settings = "rbxassetid://70386228443175", loop = "rbxassetid://122032243989747", gps = "rbxassetid://17824309485",
    compas = "rbxassetid://125300760963399", gamepad = "rbxassetid://84173963561612", boss = "rbxassetid://13132186360",
    scroll = "rbxassetid://114127804740858", menu = "rbxassetid://6340513838", crosshair = "rbxassetid://12614416478",
    user = "rbxassetid://108483430622128", stat = "rbxassetid://12094445329", eyes = "rbxassetid://14321059114",
    sword = "rbxassetid://82472368671405", discord = "rbxassetid://94434236999817", star = "rbxassetid://107005941750079",
    skeleton = "rbxassetid://17313330026", payment = "rbxassetid://18747025078", scan = "rbxassetid://109869955247116",
    alert = "rbxassetid://73186275216515", question = "rbxassetid://17510196486", idea = "rbxassetid://16833255748",
    strom = "rbxassetid://13321880293", water = "rbxassetid://100076212630732", dcs = "rbxassetid://15310731934",
    start = "rbxassetid://108886429866687", next = "rbxassetid://12662718374", rod = "rbxassetid://103247953194129",
    fish = "rbxassetid://97167558235554",
}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")
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
        local minSizeX, minSizeY, defSizeX, defSizeY
        if isMobile then minSizeX, minSizeY, defSizeX, defSizeY = 100, 100, 470, 270
        else minSizeX, minSizeY, defSizeX, defSizeY = 100, 100, 640, 400 end
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
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                DragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == DragInput and Dragging then UpdateSize(input) end
        end)
    end
    CustomSize(object)
    CustomPos(topbarobject, object)
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
local Menghub = {}
function Menghub:MakeNotify(NotifyConfig)
    local NotifyConfig = NotifyConfig or {}
    NotifyConfig.Title = NotifyConfig.Title or "Meng Hub"
    NotifyConfig.Description = NotifyConfig.Description or "Notification"
    NotifyConfig.Content = NotifyConfig.Content or "Content"
    NotifyConfig.Color = NotifyConfig.Color or Color3.fromRGB(255, 0, 255)
    NotifyConfig.Time = NotifyConfig.Time or 0.5
    NotifyConfig.Delay = NotifyConfig.Delay or 5
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
            NotifyLayout.BackgroundTransparency = 1
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
        local LeftIcon = Instance.new("ImageLabel")
        local ContentFrame = Instance.new("Frame")
        local Top = Instance.new("Frame")
        local TextLabel = Instance.new("TextLabel")
        local TextLabel1 = Instance.new("TextLabel")
        local Close = Instance.new("TextButton")
        local ImageLabel = Instance.new("ImageLabel")
        local TextLabel2 = Instance.new("TextLabel")
        NotifyFrame.BackgroundColor3 = Color3.fromRGB(29, 30, 35)
        NotifyFrame.BorderColor3 = Color3.fromRGB(29, 30, 35)
        NotifyFrame.BorderSizePixel = 0
        NotifyFrame.Size = UDim2.new(1, 0, 0, 150)
        NotifyFrame.Name = "NotifyFrame"
        NotifyFrame.BackgroundTransparency = 1
        NotifyFrame.Parent = CoreGui.NotifyGui.NotifyLayout
        NotifyFrame.AnchorPoint = Vector2.new(0, 1)
        NotifyFrame.Position = UDim2.new(0, 0, 1, -(NotifyPosHeigh))
        NotifyFrameReal.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        NotifyFrameReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NotifyFrameReal.BorderSizePixel = 0
        NotifyFrameReal.Position = UDim2.new(0, 400, 0, 0)
        NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
        NotifyFrameReal.Name = "NotifyFrameReal"
        NotifyFrameReal.Parent = NotifyFrame
        local UICorner = Instance.new("UICorner", NotifyFrameReal)
        UICorner.CornerRadius = UDim.new(0, 10)
        local UIStroke = Instance.new("UIStroke", NotifyFrameReal)
        UIStroke.Color = Color3.fromRGB(40, 40, 45)
        UIStroke.Thickness = 1
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        LeftIcon.Image = "rbxassetid://99236135648613"
        LeftIcon.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
        LeftIcon.BorderSizePixel = 0
        LeftIcon.Size = UDim2.new(0, 55, 1, 0)
        LeftIcon.ScaleType = Enum.ScaleType.Fit
        LeftIcon.Parent = NotifyFrameReal
        Instance.new("UICorner", LeftIcon).CornerRadius = UDim.new(0, 10)
        ContentFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.BorderSizePixel = 0
        ContentFrame.Position = UDim2.new(0, 55, 0, 0)
        ContentFrame.Size = UDim2.new(1, -55, 1, 0)
        ContentFrame.Name = "ContentFrame"
        ContentFrame.Parent = NotifyFrameReal
        Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Top.BackgroundTransparency = 1
        Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Top.BorderSizePixel = 0
        Top.Size = UDim2.new(1, 0, 0, 36)
        Top.Name = "Top"
        Top.Parent = ContentFrame
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.Text = NotifyConfig.Title
        TextLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
        TextLabel.TextSize = 14
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(1, -50, 1, 0)
        TextLabel.Parent = Top
        TextLabel.Position = UDim2.new(0, 10, 0, 0)
        TextLabel1.Font = Enum.Font.GothamMedium
        TextLabel1.Text = NotifyConfig.Description
        TextLabel1.TextColor3 = NotifyConfig.Color
        TextLabel1.TextSize = 13
        TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel1.BackgroundTransparency = 1
        TextLabel1.Size = UDim2.new(1, 0, 1, 0)
        TextLabel1.Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
        TextLabel1.Parent = Top
        Close.Text = ""
        Close.AnchorPoint = Vector2.new(1, 0.5)
        Close.BackgroundTransparency = 1
        Close.Position = UDim2.new(1, -8, 0.5, 0)
        Close.Size = UDim2.new(0, 24, 0, 24)
        Close.Name = "Close"
        Close.Parent = Top
        ImageLabel.Image = "rbxassetid://9886659671"
        ImageLabel.ImageColor3 = Color3.fromRGB(160, 160, 165)
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
        ImageLabel.Size = UDim2.new(0.7, 0, 0.7, 0)
        ImageLabel.Parent = Close
        TextLabel2.Font = Enum.Font.Gotham
        TextLabel2.TextColor3 = Color3.fromRGB(160, 160, 165)
        TextLabel2.TextSize = 13
        TextLabel2.Text = NotifyConfig.Content
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
        TextLabel2.BackgroundTransparency = 1
        TextLabel2.Position = UDim2.new(0, 10, 0, 30)
        TextLabel2.Size = UDim2.new(1, -20, 0, 13)
        TextLabel2.TextWrapped = true
        TextLabel2.Parent = ContentFrame
        TextLabel2.Size = UDim2.new(1, -20, 0, 13 + (13 * (TextLabel2.TextBounds.X // TextLabel2.AbsoluteSize.X)))
        local waitbruh = false
        local NotifyFunction = {}
        function NotifyFunction:Close()
            if waitbruh then return false end
            waitbruh = true
            TweenService:Create(NotifyFrameReal, TweenInfo.new(tonumber(NotifyConfig.Time), Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Position = UDim2.new(0, 400, 0, 0) }):Play()
            task.wait(tonumber(NotifyConfig.Time) / 1.2)
            NotifyFrame:Destroy()
        end
        Close.Activated:Connect(function() NotifyFunction:Close() end)
        TweenService:Create(NotifyFrameReal, TweenInfo.new(tonumber(NotifyConfig.Time), Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = UDim2.new(0, 0, 0, 0) }):Play()
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
    GuiConfig.Icon = GuiConfig.Icon or "rbxassetid://80659354137631"
    CURRENT_VERSION = GuiConfig.Version
    local GuiFunc = {}
    local Menghubb = Instance.new("ScreenGui")
    local DropShadowHolder = Instance.new("Frame")
    local DropShadow = Instance.new("ImageLabel")
    local Main = Instance.new("Frame")
    local Top = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")
    local TextLabel1 = Instance.new("TextLabel")
    local TitleIcon = Instance.new("ImageLabel")
    local Close = Instance.new("TextButton")
    local ImageLabel1 = Instance.new("ImageLabel")
    local Min = Instance.new("TextButton")
    local ImageLabel2 = Instance.new("ImageLabel")
    local LayersTab = Instance.new("Frame")
    local DecideFrame = Instance.new("Frame")
    local Layers = Instance.new("Frame")
    local NameTab = Instance.new("TextLabel")
    local LayersReal = Instance.new("Frame")
    local LayersFolder = Instance.new("Folder")
    local LayersPageLayout = Instance.new("UIPageLayout")
    Menghubb.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Menghubb.Name = "Menghubb"
    Menghubb.ResetOnSpawn = false
    Menghubb.Parent = game:GetService("CoreGui")
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.BorderSizePixel = 0
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    if isMobile then DropShadowHolder.Size = safeSize(470, 270)
    else DropShadowHolder.Size = safeSize(640, 400) end
    DropShadowHolder.ZIndex = 0
    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = Menghubb
    DropShadowHolder.Position = UDim2.new(0, (Menghubb.AbsoluteSize.X // 2 - DropShadowHolder.Size.X.Offset // 2), 0, (Menghubb.AbsoluteSize.Y // 2 - DropShadowHolder.Size.Y.Offset // 2))
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
    Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Main.BackgroundTransparency = 0.1
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(1, -47, 1, -47)
    Main.Name = "Main"
    Main.Parent = DropShadow
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Thickness = 1.2
    MainStroke.Color = GuiConfig.Color
    MainStroke.Transparency = 0.6
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Instance.new("UICorner", Main)
    Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Top.BackgroundTransparency = 0.999
    Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Top.BorderSizePixel = 0
    Top.Size = UDim2.new(1, 0, 0, 38)
    Top.Name = "Top"
    Top.Parent = Main
    TitleIcon.Name = "TitleIcon"
    TitleIcon.Parent = Top
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.BorderSizePixel = 0
    TitleIcon.AnchorPoint = Vector2.new(0, 0.5)
    TitleIcon.Position = UDim2.new(0, 10, 0.5, 0)
    TitleIcon.Size = UDim2.new(0, 20, 0, 20)
    TitleIcon.Image = GuiConfig.Icon
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.Text = GuiConfig.Title
    TextLabel.TextColor3 = GuiConfig.Color
    TextLabel.TextSize = 14
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 0.999
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(1, -135, 1, 0)
    TextLabel.Position = UDim2.new(0, 35, 0, 0)
    TextLabel.Parent = Top
    Instance.new("UICorner", Top)
    TextLabel1.Font = Enum.Font.GothamBold
    TextLabel1.Text = GuiConfig.Footer
    TextLabel1.TextColor3 = GuiConfig.Color
    TextLabel1.TextSize = 14
    TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel1.BackgroundTransparency = 0.999
    TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel1.BorderSizePixel = 0
    TextLabel1.Size = UDim2.new(1, -(TextLabel.TextBounds.X + 104), 1, 0)
    TextLabel1.Position = UDim2.new(0, 25 + TextLabel.TextBounds.X + 10, 0, 0)
    TextLabel1.Parent = Top
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
    ImageLabel1.Image = "rbxassetid://9886659671"
    ImageLabel1.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel1.BackgroundTransparency = 0.999
    ImageLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel1.BorderSizePixel = 0
    ImageLabel1.Position = UDim2.new(0.49, 0, 0.5, 0)
    ImageLabel1.Size = UDim2.new(1, -8, 1, -8)
    ImageLabel1.Parent = Close
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
    ImageLabel2.Image = "rbxassetid://9886659276"
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel2.BackgroundTransparency = 0.999
    ImageLabel2.ImageTransparency = 0.2
    ImageLabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel2.BorderSizePixel = 0
    ImageLabel2.Position = UDim2.new(0.5, 0, 0.5, 0)
    ImageLabel2.Size = UDim2.new(1, -9, 1, -9)
    ImageLabel2.Parent = Min
    LayersTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LayersTab.BackgroundTransparency = 0.999
    LayersTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LayersTab.BorderSizePixel = 0
    LayersTab.Position = UDim2.new(0, 9, 0, 50)
    LayersTab.Size = UDim2.new(0, GuiConfig["Tab Width"], 1, -59)
    LayersTab.Name = "LayersTab"
    LayersTab.Parent = Main
    Instance.new("UICorner", LayersTab).CornerRadius = UDim.new(0, 2)
    DecideFrame.AnchorPoint = Vector2.new(0.5, 0)
    DecideFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DecideFrame.BackgroundTransparency = 0.85
    DecideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DecideFrame.BorderSizePixel = 0
    DecideFrame.Position = UDim2.new(0.5, 0, 0, 38)
    DecideFrame.Size = UDim2.new(1, 0, 0, 1)
    DecideFrame.Name = "DecideFrame"
    DecideFrame.Parent = Main
    Layers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Layers.BackgroundTransparency = 0.999
    Layers.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Layers.BorderSizePixel = 0
    Layers.Position = UDim2.new(0, GuiConfig["Tab Width"] + 18, 0, 50)
    Layers.Size = UDim2.new(1, -(GuiConfig["Tab Width"] + 9 + 18), 1, -59)
    Layers.Name = "Layers"
    Layers.Parent = Main
    Instance.new("UICorner", Layers).CornerRadius = UDim.new(0, 2)
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
    LayersFolder.Name = "LayersFolder"
    LayersFolder.Parent = LayersReal
    LayersPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LayersPageLayout.Name = "LayersPageLayout"
    LayersPageLayout.TweenTime = 0.5
    LayersPageLayout.EasingDirection = Enum.EasingDirection.InOut
    LayersPageLayout.EasingStyle = Enum.EasingStyle.Quad
    LayersPageLayout.Parent = LayersFolder
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
    local UIListLayout = Instance.new("UIListLayout", ScrollTab)
    UIListLayout.Padding = UDim.new(0, 3)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local function UpdateSize1()
        local OffsetY = 0
        for _, child in ScrollTab:GetChildren() do
            if child.Name ~= "UIListLayout" then OffsetY = OffsetY + 3 + child.Size.Y.Offset end
        end
        ScrollTab.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
    end
    ScrollTab.ChildAdded:Connect(UpdateSize1)
    ScrollTab.ChildRemoved:Connect(UpdateSize1)
    function GuiFunc:DestroyGui()
        if CoreGui:FindFirstChild("Menghubb") then Menghubb:Destroy() end
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
        local Dialog = Instance.new("Frame")
        Dialog.Size = UDim2.new(0, 300, 0, 150)
        Dialog.Position = UDim2.new(0.5, -150, 0.5, -75)
        Dialog.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
        local Gradient = Instance.new("UIGradient", DialogGlow)
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 191, 255)),
            ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 140, 255)),
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 191, 255))
        })
        Gradient.Rotation = 90
        local Title = Instance.new("TextLabel", Dialog)
        Title.Size = UDim2.new(1, 0, 0, 40)
        Title.Position = UDim2.new(0, 0, 0, 4)
        Title.BackgroundTransparency = 1
        Title.Font = Enum.Font.GothamBold
        Title.Text = "Meng Hub Window"
        Title.TextSize = 22
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.ZIndex = 52
        local Message = Instance.new("TextLabel", Dialog)
        Message.Size = UDim2.new(1, -20, 0, 60)
        Message.Position = UDim2.new(0, 10, 0, 30)
        Message.BackgroundTransparency = 1
        Message.Font = Enum.Font.Gotham
        Message.Text = "Do you want to close this window?\nYou will not be able to open it again"
        Message.TextSize = 14
        Message.TextColor3 = Color3.fromRGB(200, 200, 200)
        Message.TextWrapped = true
        Message.ZIndex = 52
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
        Yes.Name = "Yes"
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
        Cancel.Name = "Cancel"
        Instance.new("UICorner", Cancel).CornerRadius = UDim.new(0, 6)
        Yes.MouseButton1Click:Connect(function()
            ConfigData = { _version = CURRENT_VERSION }
            ScriptLoaded = false
            NoclipEnabled = false
            if Menghubb then Menghubb:Destroy() end
            if game.CoreGui:FindFirstChild("ToggleUIButton") then game.CoreGui.ToggleUIButton:Destroy() end
        end)
        Cancel.MouseButton1Click:Connect(function() Overlay:Destroy() end)
    end)
    local ToggleKey = Enum.KeyCode.F3
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == ToggleKey then
            if DropShadowHolder then DropShadowHolder.Visible = not DropShadowHolder.Visible end
        end
    end)
    function GuiFunc:ToggleUI()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Parent = game:GetService("CoreGui")
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Name = "ToggleUIButton"
        local MainButton = Instance.new("ImageLabel", ScreenGui)
        MainButton.Size = UDim2.new(0, 40, 0, 40)
        MainButton.Position = UDim2.new(0, 20, 0, 100)
        MainButton.BackgroundTransparency = 1
        MainButton.Image = "rbxassetid://" .. (GuiConfig.Image or "80659354137631")
        MainButton.ScaleType = Enum.ScaleType.Fit
        Instance.new("UICorner", MainButton).CornerRadius = UDim.new(0, 6)
        local Button = Instance.new("TextButton", MainButton)
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
        game:GetService("UserInputService").InputChanged:Connect(function(input)
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
        ScrolLayers.BackgroundTransparency = 0.999
        ScrolLayers.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ScrolLayers.BorderSizePixel = 0
        ScrolLayers.Size = UDim2.new(1, 0, 1, 0)
        ScrolLayers.Name = "ScrolLayers"
        ScrolLayers.Parent = LayersFolder
        local UIListLayout1 = Instance.new("UIListLayout", ScrolLayers)
        UIListLayout1.Padding = UDim.new(0, 3)
        UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
        local Tab = Instance.new("Frame", ScrollTab)
        Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        if CountTab == 0 then Tab.BackgroundTransparency = 0.92 else Tab.BackgroundTransparency = 0.999 end
        Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
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
        TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 1, 0)
        TabButton.Name = "TabButton"
        TabButton.Parent = Tab
        local TabName = Instance.new("TextLabel", Tab)
        TabName.Font = Enum.Font.GothamBold
        TabName.Text = "| " .. tostring(TabConfig.Name)
        TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabName.TextSize = 15
        TabName.TextXAlignment = Enum.TextXAlignment.Left
        TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabName.BackgroundTransparency = 0.999
        TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabName.BorderSizePixel = 0
        TabName.Size = UDim2.new(1, 0, 1, 0)
        TabName.Position = UDim2.new(0, 30, 0, 0)
        TabName.Name = "TabName"
        local FeatureImg = Instance.new("ImageLabel", Tab)
        FeatureImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        FeatureImg.BackgroundTransparency = 0.999
        FeatureImg.BorderColor3 = Color3.fromRGB(0, 0, 0)
        FeatureImg.BorderSizePixel = 0
        FeatureImg.Position = UDim2.new(0, 9, 0, 7)
        FeatureImg.Size = UDim2.new(0, 16, 0, 16)
        FeatureImg.Name = "FeatureImg"
        if CountTab == 0 then
            LayersPageLayout:JumpToIndex(0)
            NameTab.Text = TabConfig.Name
            local ChooseFrame = Instance.new("Frame", Tab)
            ChooseFrame.BackgroundColor3 = GuiConfig.Color
            ChooseFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ChooseFrame.BorderSizePixel = 0
            ChooseFrame.Position = UDim2.new(0, 2, 0, 9)
            ChooseFrame.Size = UDim2.new(0, 1, 0, 12)
            ChooseFrame.Name = "ChooseFrame"
            local UIStroke2 = Instance.new("UIStroke", ChooseFrame)
            UIStroke2.Color = GuiConfig.Color
            UIStroke2.Thickness = 1.6
            Instance.new("UICorner", ChooseFrame)
        end
        if TabConfig.Icon ~= "" then
            if Icons[TabConfig.Icon] then FeatureImg.Image = Icons[TabConfig.Icon]
            else FeatureImg.Image = TabConfig.Icon end
        end
        TabButton.Activated:Connect(function()
            CircleClick(TabButton, Mouse.X, Mouse.Y)
            local FrameChoose
            for a, s in ScrollTab:GetChildren() do
                for i, v in s:GetChildren() do
                    if v.Name == "ChooseFrame" then FrameChoose = v break end
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
            SectionOutline.Name = "SectionOutline"
            SectionOutline.Color = Color3.fromRGB(189, 162, 241)
            SectionOutline.Thickness = 1.5
            SectionOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            SectionOutline.Transparency = 0.2
            local SectionButton = Instance.new("TextButton", SectionReal)
            SectionButton.Font = Enum.Font.SourceSans
            SectionButton.Text = ""
            SectionButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            SectionButton.TextSize = 14
            SectionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionButton.BackgroundTransparency = 0.999
            SectionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
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
            FeatureImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            FeatureImg.BackgroundTransparency = 0.999
            FeatureImg.BorderColor3 = Color3.fromRGB(0, 0, 0)
            FeatureImg.BorderSizePixel = 0
            FeatureImg.Position = UDim2.new(0.5, 0, 0.5, 0)
            FeatureImg.Rotation = -90
            FeatureImg.Size = UDim2.new(1, 6, 1, 6)
            FeatureImg.Name = "FeatureImg"
            local SectionTitle = Instance.new("TextLabel", SectionReal)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = Title
            SectionTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
            SectionTitle.TextSize = 15
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
            local SectionDecideFrame = Instance.new("Frame", Section)
            SectionDecideFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionDecideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SectionDecideFrame.AnchorPoint = Vector2.new(0.5, 0)
            SectionDecideFrame.BorderSizePixel = 0
            SectionDecideFrame.Position = UDim2.new(0.5, 0, 0, 33)
            SectionDecideFrame.Size = UDim2.new(0, 0, 0, 2)
            SectionDecideFrame.Name = "SectionDecideFrame"
            Instance.new("UICorner", SectionDecideFrame)
            local UIGradient = Instance.new("UIGradient", SectionDecideFrame)
            UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
                ColorSequenceKeypoint.new(0.5, GuiConfig.Color),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
            })
            local SectionAdd = Instance.new("Frame", Section)
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
            Instance.new("UICorner", SectionAdd).CornerRadius = UDim.new(0, 2)
            local UIListLayout2 = Instance.new("UIListLayout", SectionAdd)
            UIListLayout2.Padding = UDim.new(0, 3)
            UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
            local OpenSection = false
            local isAnimating = false
            local ANIM_TIME = 0.25
            local ANIM_STYLE = Enum.EasingStyle.Quart
            local ANIM_DIR = Enum.EasingDirection.Out
            local function UpdateSizeScroll()
                local OffsetY = 0
                for _, child in ScrolLayers:GetChildren() do
                    if child.Name ~= "UIListLayout" then OffsetY = OffsetY + 3 + child.Size.Y.Offset end
                end
                ScrolLayers.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
            end
            local function UpdateSizeSection()
                if OpenSection then
                    local SectionSizeYWitdh = 38
                    for _, v in SectionAdd:GetChildren() do
                        if v.Name ~= "UIListLayout" and v.Name ~= "UICorner" then
                            SectionSizeYWitdh = SectionSizeYWitdh + v.Size.Y.Offset + 3
                        end
                    end
                    local tweenInfo = TweenInfo.new(ANIM_TIME, ANIM_STYLE, ANIM_DIR)
                    local tweens = {
                        TweenService:Create(FeatureImg, tweenInfo, { Rotation = 0 }),
                        TweenService:Create(Section, tweenInfo, { Size = UDim2.new(1, 1, 0, SectionSizeYWitdh) }),
                        TweenService:Create(SectionAdd, tweenInfo, { Size = UDim2.new(1, 0, 0, SectionSizeYWitdh - 38) }),
                        TweenService:Create(SectionDecideFrame, tweenInfo, { Size = UDim2.new(1, 0, 0, 2) })
                    }
                    for _, tween in tweens do tween:Play() end
                    task.delay(ANIM_TIME, UpdateSizeScroll)
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
                    if isAnimating then return end
                    isAnimating = true
                    CircleClick(SectionButton, Mouse.X, Mouse.Y)
                    local tweenInfo = TweenInfo.new(ANIM_TIME, ANIM_STYLE, ANIM_DIR)
                    if OpenSection then
                        local tweens = {
                            TweenService:Create(FeatureImg, tweenInfo, { Rotation = -90 }),
                            TweenService:Create(Section, tweenInfo, { Size = UDim2.new(1, 1, 0, 30) }),
                            TweenService:Create(SectionDecideFrame, tweenInfo, { Size = UDim2.new(0, 0, 0, 2) })
                        }
                        for _, tween in tweens do tween:Play() end
                        OpenSection = false
                        task.delay(ANIM_TIME, function() UpdateSizeScroll() isAnimating = false end)
                    else
                        OpenSection = true
                        UpdateSizeSection()
                        task.delay(ANIM_TIME, function() isAnimating = false end)
                    end
                end)
            end
            if AlwaysOpen == true or AlwaysOpen == false then
                OpenSection = true
                local SectionSizeYWitdh = 38
                for _, v in SectionAdd:GetChildren() do
                    if v.Name ~= "UIListLayout" and v.Name ~= "UICorner" then
                        SectionSizeYWitdh = SectionSizeYWitdh + v.Size.Y.Offset + 3
                    end
                end
                FeatureImg.Rotation = 0
                Section.Size = UDim2.new(1, 1, 0, SectionSizeYWitdh)
                SectionAdd.Size = UDim2.new(1, 0, 0, SectionSizeYWitdh - 38)
                SectionDecideFrame.Size = UDim2.new(1, 0, 0, 2)
                UpdateSizeScroll()
            end
            SectionAdd.ChildAdded:Connect(function() task.wait(0.05) UpdateSizeSection() end)
            SectionAdd.ChildRemoved:Connect(function() task.wait(0.05) UpdateSizeSection() end)
            local layout = ScrolLayers:FindFirstChildOfClass("UIListLayout")
            if layout then
                layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    ScrolLayers.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
                end)
            end
            local Items = {}
            local CountItem = 0
            function Items:AddParagraph(ParagraphConfig)
                local ParagraphConfig = ParagraphConfig or {}
                ParagraphConfig.Title = ParagraphConfig.Title or "Title"
                ParagraphConfig.Content = ParagraphConfig.Content or "Content"
                local ParagraphFunc = {}
                local Paragraph = Instance.new("Frame", SectionAdd)
                Paragraph.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Paragraph.BackgroundTransparency = 0.935
                Paragraph.BorderSizePixel = 0
                Paragraph.LayoutOrder = CountItem
                Paragraph.Size = UDim2.new(1, 0, 0, 46)
                Paragraph.Name = "Paragraph"
                Instance.new("UICorner", Paragraph).CornerRadius = UDim.new(0, 4)
                local iconOffset = 10
                if ParagraphConfig.Icon then
                    local IconImg = Instance.new("ImageLabel", Paragraph)
                    IconImg.Size = UDim2.new(0, 20, 0, 20)
                    IconImg.Position = UDim2.new(0, 8, 0, 12)
                    IconImg.BackgroundTransparency = 1
                    IconImg.Name = "ParagraphIcon"
                    if Icons and Icons[ParagraphConfig.Icon] then IconImg.Image = Icons[ParagraphConfig.Icon]
                    else IconImg.Image = ParagraphConfig.Icon end
                    iconOffset = 30
                end
                local ParagraphTitle = Instance.new("TextLabel", Paragraph)
                ParagraphTitle.Font = Enum.Font.GothamBold
                ParagraphTitle.Text = ParagraphConfig.Title
                ParagraphTitle.TextColor3 = Color3.fromRGB(231, 231, 231)
                ParagraphTitle.TextSize = 15
                ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
                ParagraphTitle.TextYAlignment = Enum.TextYAlignment.Top
                ParagraphTitle.BackgroundTransparency = 1
                ParagraphTitle.Position = UDim2.new(0, iconOffset, 0, 10)
                ParagraphTitle.Size = UDim2.new(1, -16, 0, 13)
                ParagraphTitle.Name = "ParagraphTitle"
                local ParagraphContent = Instance.new("TextLabel", Paragraph)
                ParagraphContent.Font = Enum.Font.Gotham
                ParagraphContent.Text = ParagraphConfig.Content
                ParagraphContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                ParagraphContent.TextSize = 14
                ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
                ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
                ParagraphContent.BackgroundTransparency = 1
                ParagraphContent.Position = UDim2.new(0, iconOffset, 0, 25)
                ParagraphContent.Name = "ParagraphContent"
                ParagraphContent.TextWrapped = false
                ParagraphContent.RichText = true
                ParagraphContent.Size = UDim2.new(1, -16, 0, ParagraphContent.TextBounds.Y)
                local function UpdateSize()
                    local totalHeight = ParagraphContent.TextBounds.Y + 33
                    Paragraph.Size = UDim2.new(1, 0, 0, totalHeight)
                end
                UpdateSize()
                ParagraphContent:GetPropertyChangedSignal("TextBounds"):Connect(UpdateSize)
                function ParagraphFunc:SetContent(content)
                    content = content or "Content"
                    ParagraphContent.Text = content
                    UpdateSize()
                end
                CountItem = CountItem + 1
                return ParagraphFunc
            end
            function Items:AddPanel(PanelConfig)
                PanelConfig = PanelConfig or {}
                PanelConfig.Title = PanelConfig.Title or "Title"
                PanelConfig.Content = PanelConfig.Content or ""
                PanelConfig.Placeholder = PanelConfig.Placeholder or nil
                PanelConfig.Default = PanelConfig.Default or ""
                PanelConfig.ButtonText = PanelConfig.Button or PanelConfig.ButtonText or "Confirm"
                PanelConfig.ButtonCallback = PanelConfig.Callback or PanelConfig.ButtonCallback or function() end
                PanelConfig.SubButtonText = PanelConfig.SubButton or PanelConfig.SubButtonText or nil
                PanelConfig.SubButtonCallback = PanelConfig.SubCallback or PanelConfig.SubButtonCallback or function() end
                local configKey = "Panel_" .. PanelConfig.Title
                if ConfigData[configKey] ~= nil then PanelConfig.Default = ConfigData[configKey] end
                local PanelFunc = { Value = PanelConfig.Default }
                local baseHeight = 50
                if PanelConfig.Placeholder then baseHeight = baseHeight + 40 end
                if PanelConfig.SubButtonText then baseHeight = baseHeight + 40 else baseHeight = baseHeight + 36 end
                local Panel = Instance.new("Frame", SectionAdd)
                Panel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Panel.BackgroundTransparency = 0.935
                Panel.Size = UDim2.new(1, 0, 0, baseHeight)
                Panel.LayoutOrder = CountItem
                Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 4)
                local Title = Instance.new("TextLabel", Panel)
                Title.Font = Enum.Font.GothamBold
                Title.Text = PanelConfig.Title
                Title.TextSize = 15
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 10, 0, 10)
                Title.Size = UDim2.new(1, -20, 0, 13)
                local Content = Instance.new("TextLabel", Panel)
                Content.Font = Enum.Font.Gotham
                Content.Text = PanelConfig.Content
                Content.TextSize = 14
                Content.TextColor3 = Color3.fromRGB(255, 255, 255)
                Content.TextTransparency = 0
                Content.TextXAlignment = Enum.TextXAlignment.Left
                Content.BackgroundTransparency = 1
                Content.RichText = true
                Content.Position = UDim2.new(0, 10, 0, 28)
                Content.Size = UDim2.new(1, -20, 0, 14)
                local InputBox
                if PanelConfig.Placeholder then
                    local InputFrame = Instance.new("Frame", Panel)
                    InputFrame.AnchorPoint = Vector2.new(0.5, 0)
                    InputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    InputFrame.BackgroundTransparency = 0.95
                    InputFrame.Position = UDim2.new(0.5, 0, 0, 48)
                    InputFrame.Size = UDim2.new(1, -20, 0, 30)
                    Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 4)
                    InputBox = Instance.new("TextBox", InputFrame)
                    InputBox.Font = Enum.Font.GothamBold
                    InputBox.PlaceholderText = PanelConfig.Placeholder
                    InputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
                    InputBox.Text = PanelConfig.Default
                    InputBox.TextSize = 11
                    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                    InputBox.BackgroundTransparency = 1
                    InputBox.TextXAlignment = Enum.TextXAlignment.Left
                    InputBox.Size = UDim2.new(1, -10, 1, -6)
                    InputBox.Position = UDim2.new(0, 5, 0, 3)
                end
                local yBtn = PanelConfig.Placeholder and 88 or 48
                local ButtonMain = Instance.new("TextButton", Panel)
                ButtonMain.Font = Enum.Font.GothamBold
                ButtonMain.Text = PanelConfig.ButtonText
                ButtonMain.TextColor3 = Color3.fromRGB(255, 255, 255)
                ButtonMain.TextSize = 14
                ButtonMain.TextTransparency = 0.3
                ButtonMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ButtonMain.BackgroundTransparency = 0.935
                ButtonMain.Size = PanelConfig.SubButtonText and UDim2.new(0.5, -12, 0, 30) or UDim2.new(1, -20, 0, 30)
                ButtonMain.Position = UDim2.new(0, 10, 0, yBtn)
                Instance.new("UICorner", ButtonMain).CornerRadius = UDim.new(0, 6)
                ButtonMain.MouseButton1Click:Connect(function()
                    PanelConfig.ButtonCallback(InputBox and InputBox.Text or "")
                end)
                if PanelConfig.SubButtonText then
                    local SubButton = Instance.new("TextButton", Panel)
                    SubButton.Font = Enum.Font.GothamBold
                    SubButton.Text = PanelConfig.SubButtonText
                    SubButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    SubButton.TextSize = 14
                    SubButton.TextTransparency = 0.3
                    SubButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    SubButton.BackgroundTransparency = 0.935
                    SubButton.Size = UDim2.new(0.5, -12, 0, 30)
                    SubButton.Position = UDim2.new(0.5, 2, 0, yBtn)
                    Instance.new("UICorner", SubButton).CornerRadius = UDim.new(0, 6)
                    SubButton.MouseButton1Click:Connect(function()
                        PanelConfig.SubButtonCallback(InputBox and InputBox.Text or "")
                    end)
                end
                if InputBox then
                    InputBox.FocusLost:Connect(function()
                        PanelFunc.Value = InputBox.Text
                        ConfigData[configKey] = InputBox.Text
                    end)
                end
                function PanelFunc:GetInput() return InputBox and InputBox.Text or "" end
                CountItem = CountItem + 1
                return PanelFunc
            end
            function Items:AddButton(ButtonConfig)
                ButtonConfig = ButtonConfig or {}
                ButtonConfig.Title = ButtonConfig.Title or "Confirm"
                ButtonConfig.Callback = ButtonConfig.Callback or function() end
                ButtonConfig.SubTitle = ButtonConfig.SubTitle or nil
                ButtonConfig.SubCallback = ButtonConfig.SubCallback or function() end
                local Button = Instance.new("Frame", SectionAdd)
                Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Button.BackgroundTransparency = 0.935
                Button.Size = UDim2.new(1, 0, 0, 40)
                Button.LayoutOrder = CountItem
                Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)
                local MainButton = Instance.new("TextButton", Button)
                MainButton.Font = Enum.Font.GothamBold
                MainButton.Text = ButtonConfig.Title
                MainButton.TextSize = 14
                MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                MainButton.TextTransparency = 0.3
                MainButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                MainButton.BackgroundTransparency = 0.935
                MainButton.Size = ButtonConfig.SubTitle and UDim2.new(0.5, -8, 1, -10) or UDim2.new(1, -12, 1, -10)
                MainButton.Position = UDim2.new(0, 6, 0, 5)
                Instance.new("UICorner", MainButton).CornerRadius = UDim.new(0, 4)
                MainButton.MouseButton1Click:Connect(ButtonConfig.Callback)
                if ButtonConfig.SubTitle then
                    local SubButton = Instance.new("TextButton", Button)
                    SubButton.Font = Enum.Font.GothamBold
                    SubButton.Text = ButtonConfig.SubTitle
                    SubButton.TextSize = 14
                    SubButton.TextTransparency = 0.3
                    SubButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    SubButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    SubButton.BackgroundTransparency = 0.935
                    SubButton.Size = UDim2.new(0.5, -8, 1, -10)
                    SubButton.Position = UDim2.new(0.5, 2, 0, 5)
                    Instance.new("UICorner", SubButton).CornerRadius = UDim.new(0, 4)
                    SubButton.MouseButton1Click:Connect(ButtonConfig.SubCallback)
                end
                CountItem = CountItem + 1
            end
            function Items:AddToggle(ToggleConfig)
                local ToggleConfig = ToggleConfig or {}
                ToggleConfig.Title = ToggleConfig.Title or "Title"
                ToggleConfig.Title2 = ToggleConfig.Title2 or ""
                ToggleConfig.Content = ToggleConfig.Content or ""
                ToggleConfig.Default = ToggleConfig.Default or false
                ToggleConfig.Callback = ToggleConfig.Callback or function() end
                local configKey = "Toggle_" .. ToggleConfig.Title
                if ConfigData[configKey] ~= nil then ToggleConfig.Default = ConfigData[configKey] end
                local ToggleFunc = { Value = ToggleConfig.Default }
                local isInCallback = false
                local Toggle = Instance.new("Frame", SectionAdd)
                Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Toggle.BackgroundTransparency = 0.935
                Toggle.BorderSizePixel = 0
                Toggle.LayoutOrder = CountItem
                Toggle.Name = "Toggle"
                Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 4)
                local ToggleTitle = Instance.new("TextLabel", Toggle)
                ToggleTitle.Font = Enum.Font.GothamBold
                ToggleTitle.Text = ToggleConfig.Title
                ToggleTitle.TextSize = 15
                ToggleTitle.TextColor3 = Color3.fromRGB(231, 231, 231)
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
                ToggleTitle.TextYAlignment = Enum.TextYAlignment.Top
                ToggleTitle.BackgroundTransparency = 1
                ToggleTitle.Position = UDim2.new(0, 10, 0, 10)
                ToggleTitle.Size = UDim2.new(1, -100, 0, 13)
                ToggleTitle.Name = "ToggleTitle"
                local ToggleTitle2 = Instance.new("TextLabel", Toggle)
                ToggleTitle2.Font = Enum.Font.GothamBold
                ToggleTitle2.Text = ToggleConfig.Title2
                ToggleTitle2.TextSize = 14
                ToggleTitle2.TextColor3 = Color3.fromRGB(231, 231, 231)
                ToggleTitle2.TextXAlignment = Enum.TextXAlignment.Left
                ToggleTitle2.TextYAlignment = Enum.TextYAlignment.Top
                ToggleTitle2.BackgroundTransparency = 1
                ToggleTitle2.Position = UDim2.new(0, 10, 0, 23)
                ToggleTitle2.Size = UDim2.new(1, -100, 0, 12)
                ToggleTitle2.Name = "ToggleTitle2"
                local ToggleContent = Instance.new("TextLabel", Toggle)
                ToggleContent.Font = Enum.Font.GothamBold
                ToggleContent.Text = ToggleConfig.Content
                ToggleContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleContent.TextSize = 14
                ToggleContent.TextTransparency = 0.6
                ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
                ToggleContent.TextYAlignment = Enum.TextYAlignment.Bottom
                ToggleContent.BackgroundTransparency = 1
                ToggleContent.Size = UDim2.new(1, -100, 0, 12)
                ToggleContent.Name = "ToggleContent"
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
                if ToggleConfig.Title2 ~= "" then Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 47)
                else Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 33) end
                ToggleContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                    ToggleContent.TextWrapped = false
                    ToggleContent.Size = UDim2.new(1, -100, 0, 12 + (12 * (ToggleContent.TextBounds.X // ToggleContent.AbsoluteSize.X)))
                    if ToggleConfig.Title2 ~= "" then Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 47)
                    else Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 33) end
                    ToggleContent.TextWrapped = true
                    UpdateSizeSection()
                end)
                local ToggleButton = Instance.new("TextButton", Toggle)
                ToggleButton.Font = Enum.Font.SourceSans
                ToggleButton.Text = ""
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                ToggleButton.Name = "ToggleButton"
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
                ToggleButton.Activated:Connect(function()
                    ToggleFunc.Value = not ToggleFunc.Value
                    ToggleFunc:Set(ToggleFunc.Value)
                end)
                function ToggleFunc:Set(Value)
                    ToggleFunc.Value = Value
                    ConfigData[configKey] = Value
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
                    if not isInCallback then
                        isInCallback = true
                        task.spawn(function()
                            if typeof(ToggleConfig.Callback) == "function" then
                                local ok, err = pcall(function() ToggleConfig.Callback(Value) end)
                                if not ok then warn("Toggle Callback error:", err) end
                            end
                            task.wait(0.05)
                            isInCallback = false
                        end)
                    end
                end
                ToggleFunc:Set(ToggleFunc.Value)
                CountItem = CountItem + 1
                ToggleFunc.Type = "Toggle"
                Elements[configKey] = ToggleFunc
                return ToggleFunc
            end
            function Items:AddSlider(SliderConfig)
                local SliderConfig = SliderConfig or {}
                SliderConfig.Title = SliderConfig.Title or "Slider"
                SliderConfig.Content = SliderConfig.Content or ""
                SliderConfig.Increment = SliderConfig.Increment or 1
                SliderConfig.Min = SliderConfig.Min or 0
                SliderConfig.Max = SliderConfig.Max or 100
                SliderConfig.Default = SliderConfig.Default or 50
                SliderConfig.Callback = SliderConfig.Callback or function() end
                local configKey = "Slider_" .. SliderConfig.Title
                if ConfigData[configKey] ~= nil then SliderConfig.Default = ConfigData[configKey] end
                local SliderFunc = { Value = SliderConfig.Default }
                local Slider = Instance.new("Frame", SectionAdd)
                Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Slider.BackgroundTransparency = 0.935
                Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Slider.BorderSizePixel = 0
                Slider.LayoutOrder = CountItem
                Slider.Size = UDim2.new(1, 0, 0, 46)
                Slider.Name = "Slider"
                Instance.new("UICorner", Slider).CornerRadius = UDim.new(0, 4)
                local SliderTitle = Instance.new("TextLabel", Slider)
                SliderTitle.Font = Enum.Font.GothamBold
                SliderTitle.Text = SliderConfig.Title
                SliderTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                SliderTitle.TextSize = 15
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                SliderTitle.TextYAlignment = Enum.TextYAlignment.Top
                SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderTitle.BackgroundTransparency = 0.999
                SliderTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderTitle.BorderSizePixel = 0
                SliderTitle.Position = UDim2.new(0, 10, 0, 10)
                SliderTitle.Size = UDim2.new(1, -180, 0, 13)
                SliderTitle.Name = "SliderTitle"
                local SliderContent = Instance.new("TextLabel", Slider)
                SliderContent.Font = Enum.Font.GothamBold
                SliderContent.Text = SliderConfig.Content
                SliderContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderContent.TextSize = 14
                SliderContent.TextTransparency = 0.6
                SliderContent.TextXAlignment = Enum.TextXAlignment.Left
                SliderContent.TextYAlignment = Enum.TextYAlignment.Bottom
                SliderContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderContent.BackgroundTransparency = 0.999
                SliderContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderContent.BorderSizePixel = 0
                SliderContent.Position = UDim2.new(0, 10, 0, 25)
                SliderContent.Size = UDim2.new(1, -180, 0, 12)
                SliderContent.Name = "SliderContent"
                SliderContent.Size = UDim2.new(1, -180, 0, 12 + (12 * (SliderContent.TextBounds.X // SliderContent.AbsoluteSize.X)))
                SliderContent.TextWrapped = true
                Slider.Size = UDim2.new(1, 0, 0, SliderContent.AbsoluteSize.Y + 33)
                SliderContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                    SliderContent.TextWrapped = false
                    SliderContent.Size = UDim2.new(1, -180, 0, 12 + (12 * (SliderContent.TextBounds.X // SliderContent.AbsoluteSize.X)))
                    Slider.Size = UDim2.new(1, 0, 0, SliderContent.AbsoluteSize.Y + 33)
                    SliderContent.TextWrapped = true
                    UpdateSizeSection()
                end)
                local SliderInput = Instance.new("Frame", Slider)
                SliderInput.AnchorPoint = Vector2.new(0, 0.5)
                SliderInput.BackgroundColor3 = GuiConfig.Color
                SliderInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderInput.BackgroundTransparency = 1
                SliderInput.BorderSizePixel = 0
                SliderInput.Position = UDim2.new(1, -155, 0.5, 0)
                SliderInput.Size = UDim2.new(0, 28, 0, 20)
                SliderInput.Name = "SliderInput"
                Instance.new("UICorner", SliderInput).CornerRadius = UDim.new(0, 2)
                local TextBox = Instance.new("TextBox", SliderInput)
                TextBox.Font = Enum.Font.GothamBold
                TextBox.Text = "90"
                TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextBox.TextSize = 15
                TextBox.TextWrapped = true
                TextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                TextBox.BackgroundTransparency = 0.999
                TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
                TextBox.BorderSizePixel = 0
                TextBox.Position = UDim2.new(0, -1, 0, 0)
                TextBox.Size = UDim2.new(1, 0, 1, 0)
                local SliderFrame = Instance.new("Frame", Slider)
                SliderFrame.AnchorPoint = Vector2.new(1, 0.5)
                SliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderFrame.BackgroundTransparency = 0.8
                SliderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Position = UDim2.new(1, -20, 0.5, 0)
                SliderFrame.Size = UDim2.new(0, 100, 0, 3)
                SliderFrame.Name = "SliderFrame"
                Instance.new("UICorner", SliderFrame)
                local SliderDraggable = Instance.new("Frame", SliderFrame)
                SliderDraggable.AnchorPoint = Vector2.new(0, 0.5)
                SliderDraggable.BackgroundColor3 = GuiConfig.Color
                SliderDraggable.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderDraggable.BorderSizePixel = 0
                SliderDraggable.Position = UDim2.new(0, 0, 0.5, 0)
                SliderDraggable.Size = UDim2.new(0.9, 0, 0, 1)
                SliderDraggable.Name = "SliderDraggable"
                Instance.new("UICorner", SliderDraggable)
                local SliderCircle = Instance.new("Frame", SliderDraggable)
                SliderCircle.AnchorPoint = Vector2.new(1, 0.5)
                SliderCircle.BackgroundColor3 = GuiConfig.Color
                SliderCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderCircle.BorderSizePixel = 0
                SliderCircle.Position = UDim2.new(1, 4, 0.5, 0)
                SliderCircle.Size = UDim2.new(0, 8, 0, 8)
                SliderCircle.Name = "SliderCircle"
                Instance.new("UICorner", SliderCircle)
                local UIStroke6 = Instance.new("UIStroke", SliderCircle)
                UIStroke6.Color = GuiConfig.Color
                local Dragging = false
                local function Round(Number, Factor)
                    local Result = math.floor(Number / Factor + (math.sign(Number) * 0.5)) * Factor
                    if Result < 0 then Result = Result + Factor end
                    return Result
                end
                function SliderFunc:Set(Value)
                    Value = math.clamp(Round(Value, SliderConfig.Increment), SliderConfig.Min, SliderConfig.Max)
                    SliderFunc.Value = Value
                    TextBox.Text = tostring(Value)
                    TweenService:Create(SliderDraggable, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.fromScale((Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 1) }):Play()
                    SliderConfig.Callback(Value)
                    ConfigData[configKey] = Value
                end
                SliderFrame.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        TweenService:Create(SliderCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 14, 0, 14) }):Play()
                        local SizeScale = math.clamp((Input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
                        SliderFunc:Set(SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale))
                    end
                end)
                SliderFrame.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = false
                        TweenService:Create(SliderCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 8, 0, 8) }):Play()
                    end
                end)
                SliderFrame.MouseMoved:Connect(function(X, Y)
                    if Dragging then
                        local SizeScale = math.clamp((X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
                        SliderFunc:Set(SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale))
                    end
                end)
                SliderFunc:Set(SliderFunc.Value)
                CountItem = CountItem + 1
                SliderFunc.Type = "Slider"
                Elements[configKey] = SliderFunc
                return SliderFunc
            end
            function Items:AddDivider()
                local Divider = Instance.new("Frame", SectionAdd)
                Divider.Name = "Divider"
                Divider.AnchorPoint = Vector2.new(0.5, 0)
                Divider.Position = UDim2.new(0.5, 0, 0, 0)
                Divider.Size = UDim2.new(1, 0, 0, 2)
                Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Divider.BackgroundTransparency = 0
                Divider.BorderSizePixel = 0
                Divider.LayoutOrder = CountItem
                local UIGradient = Instance.new("UIGradient", Divider)
                UIGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
                    ColorSequenceKeypoint.new(0.5, GuiConfig.Color),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
                })
                Instance.new("UICorner", Divider).CornerRadius = UDim.new(0, 2)
                CountItem = CountItem + 1
                return Divider
            end
            function Items:AddSubSection(title)
                title = title or "Sub Section"
                local SubSection = Instance.new("Frame", SectionAdd)
                SubSection.Name = "SubSection"
                SubSection.Parent = SectionAdd
                SubSection.BackgroundTransparency = 1
                SubSection.Size = UDim2.new(1, 0, 0, 22)
                SubSection.LayoutOrder = CountItem
                local Background = Instance.new("Frame", SubSection)
                Background.Size = UDim2.new(1, 0, 1, 0)
                Background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Background.BackgroundTransparency = 0.935
                Background.BorderSizePixel = 0
                Instance.new("UICorner", Background).CornerRadius = UDim.new(0, 6)
                local Label = Instance.new("TextLabel", SubSection)
                Label.Parent = SubSection
                Label.AnchorPoint = Vector2.new(0, 0.5)
                Label.Position = UDim2.new(0, 10, 0.5, 0)
                Label.Size = UDim2.new(1, -20, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Font = Enum.Font.GothamBold
                Label.Text = "─ " .. title .. " ─"
                Label.TextColor3 = Color3.fromRGB(230, 230, 230)
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                CountItem = CountItem + 1
                return SubSection
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

-- Services & Variables
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

-- Cleanup
local function CleanupScript()
    ScriptActive = false
    for _, v in pairs(Connections) do pcall(function() v:Disconnect() end) end
    Connections = {}
    if TextChatService then TextChatService.OnIncomingMessage = nil end
    print("❌ NikeeHUB System: Script closed")
    if getgenv then getgenv().Byu_Stop = nil end
end
if getgenv then getgenv().Byu_Stop = CleanupScript end

-- Config folder
if not isfolder("Nikee_Configs") then pcall(function() makefolder("Nikee_Configs") end) end

-- Globals
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

-- Anti-AFK
task.spawn(function()
    Players.LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    pcall(function() for i,v in pairs(getconnections(Players.LocalPlayer.Idled)) do v:Disable() end end)
    print("NikeeHUB: Anti-AFK Active")
end)

-- Tag System
local TagList = {}
for i = 1, 20 do TagList[i] = {"", ""} end
local SessionStart = tick()
local SessionStats = {Secret=0, Ruby=0, Evolved=0, Crystalized=0, CaveCrystal=0, TotalSent=0}

-- Notification
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

-- Teleport
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

-- Get Remote
local RPath = {"Packages", "_Index", "sleitnick_net@0.2.0", "net"}
local function GetRemote(name)
    local curr = ReplicatedStorage
    for _, child in ipairs(RPath) do
        curr = curr:WaitForChild(child, 1)
        if not curr then return nil end
    end
    return curr:FindFirstChild(name)
end

-- Get fish count
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

-- Feature variables
local DetectorStuckEnabled, AutoShakeEnabled, AutoSellEnabled, SimpleWeatherEnabled, AutoTotemEnabled = false, false, false, false, false
local StuckThreshold, LastFishCount, StuckTimer, SavedCFrame = 15, 0, 0, nil
local SellValue = 600
local WeatherList = {"Wind", "Cloudy", "Storm"}
local TotemList = {"Luck Totem", "Mutation Totem", "Shiny Totem"}
local SelectedTotem = "Luck Totem"
local TotemMap = {["Luck Totem"]=1, ["Mutation Totem"]=2, ["Shiny Totem"]=3}
local WalkOnWaterEnabled, isNoAnimationActive, isVFXDisabled = false, false, false
local WaterPlatform, WalkConnection = nil, nil
local originalAnimator, originalAnimateScript = nil, nil
local VFXControllerModule = require(ReplicatedStorage.Controllers.VFXController)
local originalVFXHandle = VFXControllerModule.Handle
local ServerTitle = "XALSCENT"

-- Create UI
local Window = nil
if MengHub then
    Window = MengHub:Window({
        Title = "NikeeHUB",
        Footer = "FishIt",
        Color = Color3.fromRGB(0, 139, 139),
        Version = 1.0,
        Icon = "rbxassetid://80659354137631"
    })
    
    -- Tabs
    local Tab_ServerInfo = Window:AddTab({Name = "Server Info", Icon = "stat"})
    local Tab_Fhising = Window:AddTab({Name = "Fhising", Icon = "fish"})
    local Tab_Teleport = Window:AddTab({Name = "Teleport", Icon = "gps"})
    local Tab_Notification = Window:AddTab({Name = "Notification", Icon = "alert"})
    local Tab_AdminBoost = Window:AddTab({Name = "Admin Boost", Icon = "player"})
    local Tab_ListPlayer = Window:AddTab({Name = "List Player", Icon = "user"})
    local Tab_Setting = Window:AddTab({Name = "Setting", Icon = "settings"})
    local Tab_SaveConfig = Window:AddTab({Name = "Save Config", Icon = "bag"})
    
    -- Server Info
    local Section_Stats = Tab_ServerInfo:AddSection("Session Statistics", false)
    Section_Stats:AddParagraph({Title = "Uptime", Content = "Tracking...", Icon = "stat"})
    Section_Stats:AddParagraph({Title = "Secret Fish Caught", Content = "0", Icon = "fish"})
    Section_Stats:AddParagraph({Title = "Ruby Gemstones", Content = "0", Icon = "star"})
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
    
    -- Fhising
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
    
    -- Teleport
    local Section_Teleport = Tab_Teleport:AddSection("Fishing Areas", false)
    local sortedAreas = {}
    for name, _ in pairs(FishingAreas) do table.insert(sortedAreas, name) end
    table.sort(sortedAreas)
    for _, areaName in ipairs(sortedAreas) do
        local data = FishingAreas[areaName]
        Section_Teleport:AddButton({Title = "📍 " .. areaName, Callback = function() TeleportToLookAt(data.Pos, data.Look) end})
    end
    
    -- Notification
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
    
    -- Admin Boost
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
    
    -- List Player
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
    
    -- Setting
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
    
    -- Save Config
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

-- High ping monitor
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

-- Webhook functions
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

-- Player leave
table.insert(Connections, Players.PlayerRemoving:Connect(function(p)
    if not ScriptActive then return end
    task.spawn(function() SendWebhook({Player = p.Name, DisplayName = p.DisplayName}, "LEAVE") end)
end))

-- Foreign player detection
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

-- Cave crystal watcher
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

-- Autoload config
task.delay(1, function()
    if isfile("Nikee_Configs/autoload.json") then
        local s, c = pcall(function() return readfile("Nikee_Configs/autoload.json") end)
        if s then
            local s2, d = pcall(function() return HttpService:JSONDecode(c) end)
            if s2 and d and d.enabled and d.config then
                print("🔄 Autoloading Config: " .. d.config)
            end
        end
    end
end)
