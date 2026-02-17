-- ============================================
-- ITG Webhook - Custom UI Library
-- Tema: Dark Modern (SpeedHub X Style)
-- ============================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}
Library.__index = Library

-- Theme Configuration
Library.Theme = {
    Background = Color3.fromRGB(15, 15, 20),
    Header = Color3.fromRGB(20, 20, 25),
    Sidebar = Color3.fromRGB(18, 18, 22),
    Content = Color3.fromRGB(25, 25, 30),
    Accent = Color3.fromRGB(0, 150, 255),
    AccentHover = Color3.fromRGB(0, 170, 255),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(40, 40, 45),
    Input = Color3.fromRGB(12, 12, 16),
    Success = Color3.fromRGB(0, 200, 100),
    Error = Color3.fromRGB(255, 80, 80),
    Warning = Color3.fromRGB(255, 180, 0),
}

-- State
Library.Tabs = {}
Library.Sections = {}
Library.CurrentTab = nil
Library.Window = nil

-- ============================================
-- Utility Functions
-- ============================================
local function AddStroke(instance, color, thickness)
    local s = Instance.new("UIStroke", instance)
    s.Color = color or Library.Theme.Border
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function CreateRoundedCorner(instance, radius)
    local c = Instance.new("UICorner", instance)
    c.CornerRadius = UDim.new(0, radius or 8)
    return c
end

-- ============================================
-- Main Window
-- ============================================
function Library:CreateWindow(config)
    config = config or {}
    local title = config.Title or "ITG Webhook"
    local width = config.Width or 650
    local height = config.Height or 450
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ITG_UI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    local ProtectGui = protectgui or (syn and syn.protect_gui) or (gethui and function(g) g.Parent = gethui() end) or function(g) g.Parent = CoreGui end
    pcall(function() ProtectGui(ScreenGui) end)
    ScreenGui.Parent = CoreGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Library.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    MainFrame.Size = UDim2.new(0, width, 0, height)
    MainFrame.Active = true
    MainFrame.Draggable = true
    CreateRoundedCorner(MainFrame, 10)
    AddStroke(MainFrame, Library.Theme.Border, 1)
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel", MainFrame)
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 50, 1, 50)
    Shadow.ZIndex = -1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.ScaleType = Enum.ScaleType.Slice
    
    -- Header
    local Header = Instance.new("Frame", MainFrame)
    Header.Name = "Header"
    Header.BackgroundColor3 = Library.Theme.Header
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 40)
    CreateRoundedCorner(Header, 10)
    
    -- Header Fix (bottom round)
    local HeaderFix = Instance.new("Frame", Header)
    HeaderFix.BackgroundColor3 = Library.Theme.Header
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Position = UDim2.new(0, 0, 1, -10)
    HeaderFix.Size = UDim2.new(1, 0, 0, 10)
    
    -- Title
    local Title = Instance.new("TextLabel", Header)
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0, 300, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "🎣 " .. title
    Title.TextColor3 = Library.Theme.Accent
    Title.TextSize = 16
    Title.TextXAlignment = "Left"
    Title.ZIndex = 2
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton", Header)
    CloseBtn.Name = "CloseBtn"
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    CloseBtn.Size = UDim2.new(0, 40, 1, 0)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Library.Theme.TextSecondary
    CloseBtn.TextSize = 24
    CloseBtn.ZIndex = 2
    
    CloseBtn.MouseEnter:Connect(function()
        CloseBtn.TextColor3 = Library.Theme.TextPrimary
        CloseBtn.BackgroundColor3 = Library.Theme.Error
        CloseBtn.BackgroundTransparency = 0
    end)
    CloseBtn.MouseLeave:Connect(function()
        CloseBtn.TextColor3 = Library.Theme.TextSecondary
        CloseBtn.BackgroundTransparency = 1
    end)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Name = "Sidebar"
    Sidebar.BackgroundColor3 = Library.Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.Size = UDim2.new(0, 160, 1, -40)
    
    local SidebarCorner = Instance.new("UICorner", Sidebar)
    SidebarCorner.CornerRadius = UDim.new(0, 0)
    
    -- Sidebar Container
    local SidebarContainer = Instance.new("ScrollingFrame", Sidebar)
    SidebarContainer.Name = "SidebarContainer"
    SidebarContainer.BackgroundTransparency = 1
    SidebarContainer.Size = UDim2.new(1, 0, 1, 0)
    SidebarContainer.BorderSizePixel = 0
    SidebarContainer.ScrollBarThickness = 0
    
    local SidebarLayout = Instance.new("UIListLayout", SidebarContainer)
    SidebarLayout.Padding = UDim.new(0, 4)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local SidebarPadding = Instance.new("UIPadding", SidebarContainer)
    SidebarPadding.PaddingTop = UDim.new(0, 10)
    SidebarPadding.PaddingBottom = UDim.new(0, 10)
    
    -- Content Container
    local ContentContainer = Instance.new("Frame", MainFrame)
    ContentContainer.Name = "ContentContainer"
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 160, 0, 40)
    ContentContainer.Size = UDim2.new(1, -160, 1, -40)
    
    -- Store references
    Library.Window = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Header = Header,
        Sidebar = Sidebar,
        SidebarContainer = SidebarContainer,
        ContentContainer = ContentContainer,
        CloseBtn = CloseBtn,
    }
    
    return Library
end

-- ============================================
-- Tab System
-- ============================================
function Library:CreateTab(name, icon)
    if not Library.Window then
        warn("[ITG UI] CreateWindow must be called before CreateTab")
        return nil
    end
    
    local tabId = "Tab_" .. name:gsub(" ", "_")
    
    -- Tab Button
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = tabId .. "_Btn"
    TabBtn.Parent = Library.Window.SidebarContainer
    TabBtn.BackgroundColor3 = Library.Theme.Content
    TabBtn.BackgroundTransparency = 1
    TabBtn.Size = UDim2.new(1, -12, 0, 36)
    TabBtn.BorderSizePixel = 0
    CreateRoundedCorner(TabBtn, 6)
    
    -- Icon Label
    local IconLabel = Instance.new("TextLabel", TabBtn)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Position = UDim2.new(0, 10, 0, 0)
    IconLabel.Size = UDim2.new(0, 30, 1, 0)
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.Text = icon or "📄"
    IconLabel.TextColor3 = Library.Theme.TextSecondary
    IconLabel.TextSize = 16
    IconLabel.TextXAlignment = "Left"
    
    -- Text Label
    local TextLabel = Instance.new("TextLabel", TabBtn)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0, 38, 0, 0)
    TextLabel.Size = UDim2.new(1, -48, 1, 0)
    TextLabel.Font = Enum.Font.GothamMedium
    TextLabel.Text = name
    TextLabel.TextColor3 = Library.Theme.TextSecondary
    TextLabel.TextSize = 13
    TextLabel.TextXAlignment = "Left"
    
    -- Active Indicator (left bar)
    local Indicator = Instance.new("Frame", TabBtn)
    Indicator.Name = "Indicator"
    Indicator.BackgroundColor3 = Library.Theme.Accent
    Indicator.BorderSizePixel = 0
    Indicator.Position = UDim2.new(0, 0, 0.5, -10)
    Indicator.Size = UDim2.new(0, 3, 0, 20)
    Indicator.Visible = false
    CreateRoundedCorner(Indicator, 2)
    
    -- Content Page
    local ContentPage = Instance.new("ScrollingFrame")
    ContentPage.Name = tabId .. "_Page"
    ContentPage.Parent = Library.Window.ContentContainer
    ContentPage.BackgroundTransparency = 1
    ContentPage.Size = UDim2.new(1, 0, 1, 0)
    ContentPage.BorderSizePixel = 0
    ContentPage.ScrollBarThickness = 5
    ContentPage.ScrollBarImageColor3 = Library.Theme.Accent
    ContentPage.Visible = false
    ContentPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentPage.BottomImage = "rbxassetid://6652743245"
    ContentPage.TopImage = "rbxassetid://6652743245"
    ContentPage.MidImage = "rbxassetid://6652743245"
    
    local PageLayout = Instance.new("UIListLayout", ContentPage)
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local PagePadding = Instance.new("UIPadding", ContentPage)
    PagePadding.PaddingLeft = UDim.new(0, 12)
    PagePadding.PaddingRight = UDim.new(0, 12)
    PagePadding.PaddingTop = UDim.new(0, 12)
    PagePadding.PaddingBottom = UDim.new(0, 12)
    
    -- Tab Click Event
    TabBtn.MouseButton1Click:Connect(function()
        -- Hide all pages
        for _, child in pairs(Library.Window.ContentContainer:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        
        -- Reset all tab buttons
        for _, child in pairs(Library.Window.SidebarContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundTransparency = 1
                child.BackgroundColor3 = Library.Theme.Content
                local ind = child:FindFirstChild("Indicator")
                if ind then ind.Visible = false end
                
                local iconLbl = child:FindFirstChild("IconLabel")
                local textLbl = child:FindFirstChild("TextLabel")
                if iconLbl then iconLbl.TextColor3 = Library.Theme.TextSecondary end
                if textLbl then textLbl.TextColor3 = Library.Theme.TextSecondary end
                if textLbl then textLbl.Font = Enum.Font.GothamMedium end
            end
        end
        
        -- Set active
        ContentPage.Visible = true
        TabBtn.BackgroundTransparency = 0
        TabBtn.BackgroundColor3 = Library.Theme.Content
        Indicator.Visible = true
        if IconLabel then IconLabel.TextColor3 = Library.Theme.TextPrimary end
        if TextLabel then 
            TextLabel.TextColor3 = Library.Theme.TextPrimary 
            TextLabel.Font = Enum.Font.GothamBold
        end
    end)
    
    local tabData = {
        Button = TabBtn,
        Page = ContentPage,
        Indicator = Indicator,
    }
    
    Library.Tabs[name] = tabData
    return tabData
end

-- ============================================
-- Section (Card Container)
-- ============================================
function Library:CreateSection(tabName, title)
    local tab = Library.Tabs[tabName]
    if not tab then
        warn("[ITG UI] Tab '" .. tabName .. "' not found")
        return nil
    end
    
    local Section = Instance.new("Frame")
    Section.Name = "Section_" .. title:gsub(" ", "_")
    Section.Parent = tab.Page
    Section.BackgroundColor3 = Library.Theme.Content
    Section.BorderSizePixel = 0
    Section.Size = UDim2.new(1, 0, 0, 0)
    Section.AutomaticSize = Enum.AutomaticSize.Y
    CreateRoundedCorner(Section, 8)
    AddStroke(Section, Library.Theme.Border, 1)
    
    -- Section Header
    if title and title ~= "" then
        local SectionHeader = Instance.new("Frame", Section)
        SectionHeader.Name = "Header"
        SectionHeader.BackgroundTransparency = 1
        SectionHeader.Size = UDim2.new(1, 0, 0, 30)
        SectionHeader.BorderSizePixel = 0
        
        local HeaderLabel = Instance.new("TextLabel", SectionHeader)
        HeaderLabel.BackgroundTransparency = 1
        HeaderLabel.Position = UDim2.new(0, 10, 0, 0)
        HeaderLabel.Size = UDim2.new(1, -20, 1, 0)
        HeaderLabel.Font = Enum.Font.GothamBold
        HeaderLabel.Text = title
        HeaderLabel.TextColor3 = Library.Theme.TextPrimary
        HeaderLabel.TextSize = 13
        HeaderLabel.TextXAlignment = "Left"
    end
    
    -- Section Container
    local SectionContainer = Instance.new("Frame", Section)
    SectionContainer.Name = "Container"
    SectionContainer.BackgroundTransparency = 1
    SectionContainer.Position = UDim2.new(0, 0, 0, title and title ~= "" and 30 or 0)
    SectionContainer.Size = UDim2.new(1, 0, 1, 0)
    SectionContainer.BorderSizePixel = 0
    
    local ContainerLayout = Instance.new("UIListLayout", SectionContainer)
    ContainerLayout.Padding = UDim.new(0, 6)
    ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContainerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local ContainerPadding = Instance.new("UIPadding", SectionContainer)
    ContainerPadding.PaddingTop = UDim.new(0, 8)
    ContainerPadding.PaddingBottom = UDim.new(0, 8)
    ContainerPadding.PaddingLeft = UDim.new(0, 10)
    ContainerPadding.PaddingRight = UDim.new(0, 10)
    
    -- Update canvas size when children change
    ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Section.Size = UDim2.new(1, 0, 0, ContainerLayout.AbsoluteContentSize.Y + (title and title ~= "" and 30 or 0) + 16)
    end)
    
    return SectionContainer
end

-- ============================================
-- Toggle Component
-- ============================================
function Library:CreateToggle(parent, config)
    local text = config.Text or "Toggle"
    local default = config.Default or false
    local callback = config.Callback or function() end
    local tooltip = config.Tooltip or ""
    
    local Frame = Instance.new("Frame")
    Frame.Parent = parent
    Frame.BackgroundColor3 = Library.Theme.Input
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.new(1, 0, 0, 40)
    CreateRoundedCorner(Frame, 6)
    
    -- Text Label
    local Label = Instance.new("TextLabel", Frame)
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(0, 280, 1, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = text
    Label.TextColor3 = Library.Theme.TextPrimary
    Label.TextSize = 13
    Label.TextXAlignment = "Left"
    
    -- Toggle Switch
    local Switch = Instance.new("Frame", Frame)
    Switch.BackgroundColor3 = default and Library.Theme.Success or Library.Theme.Input
    Switch.Position = UDim2.new(1, -48, 0.5, -12)
    Switch.Size = UDim2.new(0, 42, 0, 24)
    CreateRoundedCorner(Switch, 12)
    AddStroke(Switch, Library.Theme.Border, 1)
    
    -- Toggle Circle
    local Circle = Instance.new("Frame", Switch)
    Circle.BackgroundColor3 = Library.Theme.TextPrimary
    Circle.Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    Circle.Size = UDim2.new(0, 20, 0, 20)
    CreateRoundedCorner(Circle, 10)
    
    -- Update Function
    local function UpdateToggle(state)
        local targetColor = state and Library.Theme.Success or Library.Theme.Input
        local targetPos = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        
        TweenService:Create(Switch, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
        Circle:TweenPosition(targetPos, "Out", "Sine", 0.15, true)
    end
    
    -- Click Handler
    local ClickBtn = Instance.new("TextButton", Frame)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
    ClickBtn.Text = ""
    ClickBtn.ZIndex = 10
    
    local currentState = default
    
    ClickBtn.MouseButton1Click:Connect(function()
        currentState = not currentState
        UpdateToggle(currentState)
        callback(currentState)
    end)
    
    -- Hover effect
    Frame.MouseEnter:Connect(function()
        Frame.BackgroundColor3 = Library.Theme.Border
    end)
    Frame.MouseLeave:Connect(function()
        Frame.BackgroundColor3 = Library.Theme.Input
    end)
    
    return {
        Frame = Frame,
        Update = UpdateToggle,
        GetState = function() return currentState end,
    }
end

-- ============================================
-- Button Component
-- ============================================
function Library:CreateButton(parent, config)
    local text = config.Text or "Button"
    local color = config.Color or Library.Theme.Accent
    local callback = config.Callback or function() end
    local size = config.Size or UDim2.new(1, 0, 0, 36)
    
    local Btn = Instance.new("TextButton")
    Btn.Parent = parent
    Btn.BackgroundColor3 = color
    Btn.BorderSizePixel = 0
    Btn.Size = size
    CreateRoundedCorner(Btn, 6)
    
    local BtnLabel = Instance.new("TextLabel", Btn)
    BtnLabel.BackgroundTransparency = 1
    BtnLabel.Size = UDim2.new(1, 0, 1, 0)
    BtnLabel.Font = Enum.Font.GothamBold
    BtnLabel.Text = text
    BtnLabel.TextColor3 = Library.Theme.TextPrimary
    BtnLabel.TextSize = 13
    
    -- Hover Effect
    Btn.MouseEnter:Connect(function()
        Btn.BackgroundColor3 = Color3.new(
            math.min(color.R + 0.1, 1),
            math.min(color.G + 0.1, 1),
            math.min(color.B + 0.1, 1)
        )
    end)
    Btn.MouseLeave:Connect(function()
        Btn.BackgroundColor3 = color
    end)
    
    -- Click Effect
    Btn.MouseButton1Click:Connect(function()
        callback()
    end)
    
    return Btn
end

-- ============================================
-- Input Component
-- ============================================
function Library:CreateInput(parent, config)
    local placeholder = config.Placeholder or "Enter text..."
    local default = config.Default or ""
    local callback = config.Callback or function() end
    local height = config.Height or 36
    
    local Frame = Instance.new("Frame")
    Frame.Parent = parent
    Frame.BackgroundColor3 = Library.Theme.Input
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.new(1, 0, 0, height)
    CreateRoundedCorner(Frame, 6)
    AddStroke(Frame, Library.Theme.Border, 1)
    
    local Input = Instance.new("TextBox", Frame)
    Input.BackgroundTransparency = 1
    Input.Position = UDim2.new(0, 10, 0, 0)
    Input.Size = UDim2.new(1, -20, 1, 0)
    Input.Font = Enum.Font.GothamMedium
    Input.Text = default
    Input.PlaceholderText = placeholder
    Input.PlaceholderColor3 = Library.Theme.TextSecondary
    Input.TextColor3 = Library.Theme.TextPrimary
    Input.TextSize = 13
    Input.TextXAlignment = "Left"
    Input.ClearTextOnFocus = false
    
    -- Focus Events
    Input.Focused:Connect(function()
        AddStroke(Frame, Library.Theme.Accent, 2)
    end)
    Input.FocusLost:Connect(function()
        AddStroke(Frame, Library.Theme.Border, 1)
        callback(Input.Text)
    end)
    
    return {
        Frame = Frame,
        TextBox = Input,
        GetText = function() return Input.Text end,
        SetText = function(txt) Input.Text = txt end,
    }
end

-- ============================================
-- Label Component
-- ============================================
function Library:CreateLabel(parent, config)
    local text = config.Text or "Label"
    local color = config.Color or Library.Theme.TextPrimary
    local size = config.Size or 13
    local bold = config.Bold or false
    
    local Label = Instance.new("TextLabel")
    Label.Parent = parent
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 0, 24)
    Label.Font = bold and Enum.Font.GothamBold or Enum.Font.GothamMedium
    Label.Text = text
    Label.TextColor3 = color
    Label.TextSize = size
    Label.TextXAlignment = "Left"
    
    return Label
end

-- ============================================
-- Divider Component
-- ============================================
function Library:CreateDivider(parent)
    local Divider = Instance.new("Frame")
    Divider.Parent = parent
    Divider.BackgroundColor3 = Library.Theme.Border
    Divider.BorderSizePixel = 0
    Divider.Size = UDim2.new(1, 0, 0, 1)
    
    return Divider
end

-- ============================================
-- Notification Function
-- ============================================
function Library:Notification(config)
    local message = config.Message or "Notification"
    local type = config.Type or "info" -- info, success, error, warning
    local duration = config.Duration or 2.5
    
    local color = Library.Theme.Accent
    if type == "success" then color = Library.Theme.Success
    elseif type == "error" then color = Library.Theme.Error
    elseif type == "warning" then color = Library.Theme.Warning
    end
    
    local ScreenGui = Players.LocalPlayer:FindFirstChildWhichIsA("ScreenGui")
    if not ScreenGui then ScreenGui = Library.Window.ScreenGui end
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Parent = ScreenGui
    NotifFrame.BackgroundColor3 = Library.Theme.Header
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Position = UDim2.new(0.5, -100, 0.1, 0)
    NotifFrame.Size = UDim2.new(0, 200, 0, 40)
    NotifFrame.ZIndex = 1000
    CreateRoundedCorner(NotifFrame, 8)
    AddStroke(NotifFrame, color, 2)
    
    local Icon = Instance.new("Frame", NotifFrame)
    Icon.BackgroundColor3 = color
    Icon.Size = UDim2.new(0, 4, 1, -10)
    Icon.Position = UDim2.new(0, 8, 0.5, -((40-10)/2))
    CreateRoundedCorner(Icon, 2)
    
    local Label = Instance.new("TextLabel", NotifFrame)
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 20, 0, 0)
    Label.Size = UDim2.new(1, -25, 1, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = message
    Label.TextColor3 = Library.Theme.TextPrimary
    Label.TextSize = 13
    Label.ZIndex = 1001
    
    -- Animate In
    NotifFrame.BackgroundTransparency = 1
    Label.TextTransparency = 1
    Icon.BackgroundTransparency = 1
    
    TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(Icon, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -100, 0.15, 0)}):Play()
    
    -- Animate Out
    task.delay(duration, function()
        TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1, Position = UDim2.new(0.5, -100, 0.1, 0)}):Play()
        TweenService:Create(Label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(Icon, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        NotifFrame:Destroy()
    end)
end

-- ============================================
-- Close Button Handler
-- ============================================
function Library:OnClose(callback)
    if Library.Window and Library.Window.CloseBtn then
        Library.Window.CloseBtn.MouseButton1Click:Connect(callback)
    end
end

-- ============================================
-- Return Library
-- ============================================
return Library
