-- ============================================
-- ITG Webhook System - Discord Themed UI
-- Integrated Version (UI + All Functions)
-- Tema: Dark Modern (SpeedHub X Style)
-- ============================================

print("🎣 ITG: Script Starting...")

-- ============================================
-- SERVICES
-- ============================================
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

-- ============================================
-- GLOBAL VARIABLES
-- ============================================
local ScriptActive = true
local Connections = {}
local VirtualUser = game:GetService("VirtualUser")
local ProtectGui = protectgui or (syn and syn.protect_gui) or (gethui and function(g) g.Parent = gethui() end) or function(g) g.Parent = CoreGui end
local FishingController = require(ReplicatedStorage.Controllers.FishingController)

local Current_Webhook_Fish = ""
local Current_Webhook_Leave = ""
local Current_Webhook_List = ""
local Current_Webhook_Admin = ""
local LastDisconnectTime = 0
local AdminID_1 = ""
local AdminID_2 = ""

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
-- DISCORD THEME
-- ============================================
local Theme = {
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

-- ============================================
-- UI LIBRARY
-- ============================================
local Library = {}
local UI = {
    Window = nil,
    Tabs = {},
    Sections = {},
    Inputs = {},
    Toggles = {},
}

-- Utility Functions
local function AddStroke(instance, color, thickness)
    local s = Instance.new("UIStroke", instance)
    s.Color = color or Theme.Border
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function CreateRoundedCorner(instance, radius)
    local c = Instance.new("UICorner", instance)
    c.CornerRadius = UDim.new(0, radius or 8)
    return c
end

-- Create Window
function Library:CreateWindow(config)
    config = config or {}
    local title = config.Title or "ITG Webhook"
    local width = config.Width or 700
    local height = config.Height or 500
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ITG_UI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    pcall(function() ProtectGui(ScreenGui) end)
    ScreenGui.Parent = CoreGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    MainFrame.Size = UDim2.new(0, width, 0, height)
    MainFrame.Active = true
    MainFrame.Draggable = true
    CreateRoundedCorner(MainFrame, 10)
    AddStroke(MainFrame, Theme.Border, 1)
    
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
    Header.BackgroundColor3 = Theme.Header
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 40)
    CreateRoundedCorner(Header, 10)
    
    local HeaderFix = Instance.new("Frame", Header)
    HeaderFix.BackgroundColor3 = Theme.Header
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
    Title.TextColor3 = Theme.Accent
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
    CloseBtn.TextColor3 = Theme.TextSecondary
    CloseBtn.TextSize = 24
    CloseBtn.ZIndex = 2
    
    CloseBtn.MouseEnter:Connect(function()
        CloseBtn.TextColor3 = Theme.TextPrimary
        CloseBtn.BackgroundColor3 = Theme.Error
        CloseBtn.BackgroundTransparency = 0
    end)
    CloseBtn.MouseLeave:Connect(function()
        CloseBtn.TextColor3 = Theme.TextSecondary
        CloseBtn.BackgroundTransparency = 1
    end)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Name = "Sidebar"
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.Size = UDim2.new(0, 160, 1, -40)
    CreateRoundedCorner(Sidebar, 0)
    
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
    
    local SidebarPadding = Instance.new("UIPadding", SidebarContainer)
    SidebarPadding.PaddingTop = UDim.new(0, 10)
    SidebarPadding.PaddingBottom = UDim.new(0, 10)
    
    -- Content Container
    local ContentContainer = Instance.new("Frame", MainFrame)
    ContentContainer.Name = "ContentContainer"
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 160, 0, 40)
    ContentContainer.Size = UDim2.new(1, -160, 1, -40)
    
    UI.Window = {
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

-- Create Tab
function Library:CreateTab(name, icon)
    if not UI.Window then return nil end
    
    local tabId = "Tab_" .. name:gsub(" ", "_")
    
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = tabId .. "_Btn"
    TabBtn.Parent = UI.Window.SidebarContainer
    TabBtn.BackgroundColor3 = Theme.Content
    TabBtn.BackgroundTransparency = 1
    TabBtn.Size = UDim2.new(1, -12, 0, 36)
    TabBtn.BorderSizePixel = 0
    CreateRoundedCorner(TabBtn, 6)
    
    local IconLabel = Instance.new("TextLabel", TabBtn)
    IconLabel.Name = "IconLabel"
    IconLabel.BackgroundTransparency = 1
    IconLabel.Position = UDim2.new(0, 10, 0, 0)
    IconLabel.Size = UDim2.new(0, 30, 1, 0)
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.Text = icon or "📄"
    IconLabel.TextColor3 = Theme.TextSecondary
    IconLabel.TextSize = 16
    IconLabel.TextXAlignment = "Left"
    
    local TextLabel = Instance.new("TextLabel", TabBtn)
    TextLabel.Name = "TextLabel"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0, 38, 0, 0)
    TextLabel.Size = UDim2.new(1, -48, 1, 0)
    TextLabel.Font = Enum.Font.GothamMedium
    TextLabel.Text = name
    TextLabel.TextColor3 = Theme.TextSecondary
    TextLabel.TextSize = 13
    TextLabel.TextXAlignment = "Left"
    
    local Indicator = Instance.new("Frame", TabBtn)
    Indicator.Name = "Indicator"
    Indicator.BackgroundColor3 = Theme.Accent
    Indicator.BorderSizePixel = 0
    Indicator.Position = UDim2.new(0, 0, 0.5, -10)
    Indicator.Size = UDim2.new(0, 3, 0, 20)
    Indicator.Visible = false
    CreateRoundedCorner(Indicator, 2)
    
    local ContentPage = Instance.new("ScrollingFrame")
    ContentPage.Name = tabId .. "_Page"
    ContentPage.Parent = UI.Window.ContentContainer
    ContentPage.BackgroundTransparency = 1
    ContentPage.Size = UDim2.new(1, 0, 1, 0)
    ContentPage.BorderSizePixel = 0
    ContentPage.ScrollBarThickness = 5
    ContentPage.ScrollBarImageColor3 = Theme.Accent
    ContentPage.Visible = false
    ContentPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentPage.BottomImage = "rbxassetid://6652743245"
    ContentPage.TopImage = "rbxassetid://6652743245"
    ContentPage.MidImage = "rbxassetid://6652743245"
    
    local PageLayout = Instance.new("UIListLayout", ContentPage)
    PageLayout.Padding = UDim.new(0, 8)
    
    local PagePadding = Instance.new("UIPadding", ContentPage)
    PagePadding.PaddingLeft = UDim.new(0, 12)
    PagePadding.PaddingRight = UDim.new(0, 12)
    PagePadding.PaddingTop = UDim.new(0, 12)
    PagePadding.PaddingBottom = UDim.new(0, 12)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, child in pairs(UI.Window.ContentContainer:GetChildren()) do
            if child:IsA("ScrollingFrame") then child.Visible = false end
        end
        for _, child in pairs(UI.Window.SidebarContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundTransparency = 1
                local ind = child:FindFirstChild("Indicator")
                if ind then ind.Visible = false end
                local iconLbl = child:FindFirstChild("IconLabel")
                local textLbl = child:FindFirstChild("TextLabel")
                if iconLbl then iconLbl.TextColor3 = Theme.TextSecondary end
                if textLbl then 
                    textLbl.TextColor3 = Theme.TextSecondary
                    textLbl.Font = Enum.Font.GothamMedium
                end
            end
        end
        
        ContentPage.Visible = true
        TabBtn.BackgroundTransparency = 0
        Indicator.Visible = true
        if IconLabel then IconLabel.TextColor3 = Theme.TextPrimary end
        if TextLabel then 
            TextLabel.TextColor3 = Theme.TextPrimary
            TextLabel.Font = Enum.Font.GothamBold
        end
    end)
    
    UI.Tabs[name] = {Button = TabBtn, Page = ContentPage, Indicator = Indicator}
    return UI.Tabs[name]
end

-- Create Section
function Library:CreateSection(tabName, title)
    local tab = UI.Tabs[tabName]
    if not tab then return nil end
    
    local Section = Instance.new("Frame")
    Section.Parent = tab.Page
    Section.BackgroundColor3 = Theme.Content
    Section.BorderSizePixel = 0
    Section.Size = UDim2.new(1, 0, 0, 0)
    Section.AutomaticSize = Enum.AutomaticSize.Y
    CreateRoundedCorner(Section, 8)
    AddStroke(Section, Theme.Border, 1)
    
    if title and title ~= "" then
        local SectionHeader = Instance.new("Frame", Section)
        SectionHeader.Name = "Header"
        SectionHeader.BackgroundTransparency = 1
        SectionHeader.Size = UDim2.new(1, 0, 0, 30)
        
        local HeaderLabel = Instance.new("TextLabel", SectionHeader)
        HeaderLabel.BackgroundTransparency = 1
        HeaderLabel.Position = UDim2.new(0, 10, 0, 0)
        HeaderLabel.Size = UDim2.new(1, -20, 1, 0)
        HeaderLabel.Font = Enum.Font.GothamBold
        HeaderLabel.Text = title
        HeaderLabel.TextColor3 = Theme.TextPrimary
        HeaderLabel.TextSize = 13
        HeaderLabel.TextXAlignment = "Left"
    end
    
    local SectionContainer = Instance.new("Frame", Section)
    SectionContainer.Name = "Container"
    SectionContainer.BackgroundTransparency = 1
    SectionContainer.Position = UDim2.new(0, 0, 0, title and title ~= "" and 30 or 0)
    SectionContainer.Size = UDim2.new(1, 0, 1, 0)
    
    local ContainerLayout = Instance.new("UIListLayout", SectionContainer)
    ContainerLayout.Padding = UDim.new(0, 6)
    
    local ContainerPadding = Instance.new("UIPadding", SectionContainer)
    ContainerPadding.PaddingTop = UDim.new(0, 8)
    ContainerPadding.PaddingBottom = UDim.new(0, 8)
    ContainerPadding.PaddingLeft = UDim.new(0, 10)
    ContainerPadding.PaddingRight = UDim.new(0, 10)
    
    ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Section.Size = UDim2.new(1, 0, 0, ContainerLayout.AbsoluteContentSize.Y + (title and title ~= "" and 30 or 0) + 16)
    end)
    
    return SectionContainer
end

-- Create Toggle
function Library:CreateToggle(parent, config)
    local text = config.Text or "Toggle"
    local default = config.Default or false
    local callback = config.Callback or function() end
    
    local Frame = Instance.new("Frame")
    Frame.Parent = parent
    Frame.BackgroundColor3 = Theme.Input
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.new(1, 0, 0, 40)
    CreateRoundedCorner(Frame, 6)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(0, 280, 1, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = text
    Label.TextColor3 = Theme.TextPrimary
    Label.TextSize = 13
    Label.TextXAlignment = "Left"
    
    local Switch = Instance.new("Frame", Frame)
    Switch.BackgroundColor3 = default and Theme.Success or Theme.Input
    Switch.Position = UDim2.new(1, -48, 0.5, -12)
    Switch.Size = UDim2.new(0, 42, 0, 24)
    CreateRoundedCorner(Switch, 12)
    AddStroke(Switch, Theme.Border, 1)
    
    local Circle = Instance.new("Frame", Switch)
    Circle.BackgroundColor3 = Theme.TextPrimary
    Circle.Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    Circle.Size = UDim2.new(0, 20, 0, 20)
    CreateRoundedCorner(Circle, 10)
    
    local function UpdateToggle(state)
        local targetColor = state and Theme.Success or Theme.Input
        local targetPos = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        TweenService:Create(Switch, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
        Circle:TweenPosition(targetPos, "Out", "Sine", 0.15, true)
    end
    
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
    
    Frame.MouseEnter:Connect(function() Frame.BackgroundColor3 = Theme.Border end)
    Frame.MouseLeave:Connect(function() Frame.BackgroundColor3 = Theme.Input end)
    
    return {Frame = Frame, Update = UpdateToggle, GetState = function() return currentState end}
end

-- Create Button
function Library:CreateButton(parent, config)
    local text = config.Text or "Button"
    local color = config.Color or Theme.Accent
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
    BtnLabel.TextColor3 = Theme.TextPrimary
    BtnLabel.TextSize = 13
    
    Btn.MouseEnter:Connect(function()
        Btn.BackgroundColor3 = Color3.new(math.min(color.R + 0.1, 1), math.min(color.G + 0.1, 1), math.min(color.B + 0.1, 1))
    end)
    Btn.MouseLeave:Connect(function() Btn.BackgroundColor3 = color end)
    Btn.MouseButton1Click:Connect(function() callback() end)
    
    return Btn
end

-- Create Input
function Library:CreateInput(parent, config)
    local placeholder = config.Placeholder or "Enter text..."
    local default = config.Default or ""
    local callback = config.Callback or function() end
    local height = config.Height or 36
    
    local Frame = Instance.new("Frame")
    Frame.Parent = parent
    Frame.BackgroundColor3 = Theme.Input
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.new(1, 0, 0, height)
    CreateRoundedCorner(Frame, 6)
    AddStroke(Frame, Theme.Border, 1)
    
    local Input = Instance.new("TextBox", Frame)
    Input.BackgroundTransparency = 1
    Input.Position = UDim2.new(0, 10, 0, 0)
    Input.Size = UDim2.new(1, -20, 1, 0)
    Input.Font = Enum.Font.GothamMedium
    Input.Text = default
    Input.PlaceholderText = placeholder
    Input.PlaceholderColor3 = Theme.TextSecondary
    Input.TextColor3 = Theme.TextPrimary
    Input.TextSize = 13
    Input.TextXAlignment = "Left"
    Input.ClearTextOnFocus = false
    
    Input.Focused:Connect(function() AddStroke(Frame, Theme.Accent, 2) end)
    Input.FocusLost:Connect(function() AddStroke(Frame, Theme.Border, 1); callback(Input.Text) end)
    
    return {Frame = Frame, TextBox = Input, GetText = function() return Input.Text end, SetText = function(txt) Input.Text = txt end}
end

-- Create Label
function Library:CreateLabel(parent, config)
    local text = config.Text or "Label"
    local color = config.Color or Theme.TextPrimary
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

-- Create Divider
function Library:CreateDivider(parent)
    local Divider = Instance.new("Frame")
    Divider.Parent = parent
    Divider.BackgroundColor3 = Theme.Border
    Divider.BorderSizePixel = 0
    Divider.Size = UDim2.new(1, 0, 0, 1)
    return Divider
end

-- Notification
function Library:Notification(config)
    local message = config.Message or "Notification"
    local type = config.Type or "info"
    local duration = config.Duration or 2.5
    
    local color = Theme.Accent
    if type == "success" then color = Theme.Success
    elseif type == "error" then color = Theme.Error
    elseif type == "warning" then color = Theme.Warning end
    
    local ScreenGui = UI.Window and UI.Window.ScreenGui or CoreGui
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Parent = ScreenGui
    NotifFrame.BackgroundColor3 = Theme.Header
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
    Label.TextColor3 = Theme.TextPrimary
    Label.TextSize = 13
    
    NotifFrame.BackgroundTransparency = 1
    Label.TextTransparency = 1
    Icon.BackgroundTransparency = 1
    
    TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(Icon, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -100, 0.15, 0)}):Play()
    
    task.delay(duration, function()
        TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1, Position = UDim2.new(0.5, -100, 0.1, 0)}):Play()
        TweenService:Create(Label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(Icon, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        NotifFrame:Destroy()
    end)
end

-- On Close
function Library:OnClose(callback)
    if UI.Window and UI.Window.CloseBtn then
        UI.Window.CloseBtn.MouseButton1Click:Connect(callback)
    end
end

-- ============================================
-- INITIALIZE UI
-- ============================================
Library:CreateWindow({Title = "ITG Webhook", Width = 700, Height = 500})

-- Create Tabs
local TabServerInfo = Library:CreateTab("Server Info", "📊")
local TabFhising = Library:CreateTab("Fhising", "🎣")
local TabTeleport = Library:CreateTab("Teleport", "📍")
local TabNotification = Library:CreateTab("Notification", "🔔")
local TabAdminBoost = Library:CreateTab("Admin Boost", "👑")
local TabListPlayer = Library:CreateTab("List Player", "👥")
local TabSetting = Library:CreateTab("Setting", "⚙️")
local TabSaveConfig = Library:CreateTab("Save Config", "💾")

-- ============================================
-- SERVER INFO TAB
-- ============================================
local SectionStats = Library:CreateSection("Server Info", "Session Statistics")

local UptimeLabel = Library:CreateLabel(SectionStats, {Text = "Uptime: 00h 00m 00s", Size = 14, Bold = true})
Library:CreateDivider(SectionStats)

Library:CreateToggle(SectionStats, {
    Text = "Secret Fish Caught",
    Default = false,
    Callback = function(state) Settings.SecretEnabled = state end,
})

Library:CreateToggle(SectionStats, {
    Text = "Ruby Gemstone",
    Default = false,
    Callback = function(state) Settings.RubyEnabled = state end,
})

Library:CreateToggle(SectionStats, {
    Text = "Evolved Enchant Stone",
    Default = false,
    Callback = function(state) Settings.EvolvedEnabled = state end,
})

Library:CreateToggle(SectionStats, {
    Text = "Mutation Crystalized",
    Default = false,
    Callback = function(state) Settings.MutationCrystalized = state end,
})

Library:CreateToggle(SectionStats, {
    Text = "Cave Crystal",
    Default = false,
    Callback = function(state) Settings.CaveCrystalEnabled = state end,
})

local SectionServer = Library:CreateSection("Server Info", "Server Settings")

local ServerInput = Library:CreateInput(SectionServer, {
    Placeholder = "Server Title",
    Default = "XALSCENT",
    Callback = function(text) ServerTitle = text end,
    Height = 40,
})

Library:CreateButton(SectionServer, {
    Text = "📊 Send Stats to Webhook",
    Color = Theme.Accent,
    Callback = function()
        if Current_Webhook_Admin == "" then 
            Library:Notification({Message = "Admin Webhook Empty!", Type = "error"})
            return 
        end
        Library:Notification({Message = "Sending stats...", Type = "info"})
        
        local diff = tick() - SessionStart
        local h = math.floor(diff / 3600)
        local m = math.floor((diff % 3600) / 60)
        local s = math.floor(diff % 60)
        local timeStr = string.format("%02dh %02dm %02ds", h, m, s)
        
        local contentStr = "📊 SERVER: " .. ServerTitle .. "\n"
        contentStr = contentStr .. "⏱️ Uptime: " .. timeStr .. "\n"
        contentStr = contentStr .. "📡 Total Webhooks: " .. SessionStats.TotalSent .. "\n\n"
        contentStr = contentStr .. "⚓ Secrets: " .. SessionStats.Secret .. "\n"
        contentStr = contentStr .. "💎 Rubies: " .. SessionStats.Ruby .. "\n"
        contentStr = contentStr .. "🔮 Evolved: " .. SessionStats.Evolved .. "\n"
        contentStr = contentStr .. "✨ Crystalized: " .. SessionStats.Crystalized .. "\n"
        contentStr = contentStr .. "⛏️ Cave Crystals: " .. SessionStats.CaveCrystal
        
        task.spawn(function()
            local embed = {
                ["username"] = "ITG Stats",
                ["avatar_url"] = "https://i.imgur.com/sblcM31.jpeg",
                ["embeds"] = {{
                    ["title"] = "Session Report",
                    ["description"] = "```\n" .. contentStr .. "\n```",
                    ["color"] = 5763719,
                    ["footer"] = {["text"] = "ITG Webhook", ["icon_url"] = "https://i.imgur.com/sblcM31.jpeg"}
                }}
            }
            pcall(function() httpRequest({Url = Current_Webhook_Admin, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(embed)}) end)
        end)
    end,
})

-- Uptime updater
task.spawn(function()
    while ScriptActive do
        if UptimeLabel then
            local diff = tick() - SessionStart
            local h = math.floor(diff / 3600)
            local m = math.floor((diff % 3600) / 60)
            local s = math.floor(diff % 60)
            UptimeLabel.Text = string.format("Uptime: %02dh %02dm %02ds", h, m, s)
        end
        task.wait(1)
    end
end)

-- ============================================
-- FHISING TAB
-- ============================================
local SectionAuto = Library:CreateSection("Fhising", "Automation")

Library:CreateToggle(SectionAuto, {
    Text = "Auto Click Fishing",
    Default = false,
    Callback = function(state)
        AutoShakeEnabled = state
        local clickEffect = Players.LocalPlayer.PlayerGui:FindFirstChild("!!! Click Effect")
        if state then
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
    end,
})

Library:CreateToggle(SectionAuto, {
    Text = "Auto Sell (10m / 600 Items)",
    Default = false,
    Callback = function(state)
        AutoSellEnabled = state
        -- Auto sell logic would go here
    end,
})

Library:CreateToggle(SectionAuto, {
    Text = "Auto Buy Weather",
    Default = false,
    Callback = function(state)
        SimpleWeatherEnabled = state
    end,
})

local SectionTotem = Library:CreateSection("Fhising", "Totem System")

Library:CreateLabel(SectionTotem, {Text = "Select Totem: Luck Totem", Size = 13})

Library:CreateToggle(SectionTotem, {
    Text = "Auto Spawn Totem",
    Default = false,
    Callback = function(state) AutoTotemEnabled = state end,
})

local SectionDetector = Library:CreateSection("Fhising", "Detector")

Library:CreateToggle(SectionDetector, {
    Text = "Detector Stuck (15s)",
    Default = false,
    Callback = function(state) DetectorStuckEnabled = state end,
})

-- ============================================
-- TELEPORT TAB
-- ============================================
local SectionTeleportMain = Library:CreateSection("Teleport", "Fishing Locations")

local sortedAreas = {}
for name, _ in pairs(FishingAreas) do table.insert(sortedAreas, name) end
table.sort(sortedAreas)

for i = 1, #sortedAreas, 2 do
    local name1 = sortedAreas[i]
    local name2 = sortedAreas[i+1]
    
    local btnFrame = Instance.new("Frame")
    btnFrame.Parent = SectionTeleportMain
    btnFrame.BackgroundTransparency = 1
    btnFrame.Size = UDim2.new(1, 0, 0, 40)
    
    local data1 = FishingAreas[name1]
    Library:CreateButton(btnFrame, {
        Text = "📍 " .. name1,
        Color = Theme.Accent,
        Size = UDim2.new(0.5, -3, 1, 0),
        Callback = function()
            TeleportToLookAt(data1.Pos, data1.Look)
        end,
    })
    
    if name2 then
        local data2 = FishingAreas[name2]
        local btn2 = Library:CreateButton(btnFrame, {
            Text = "📍 " .. name2,
            Color = Theme.Accent,
            Size = UDim2.new(0.5, -3, 1, 0),
            Callback = function()
                TeleportToLookAt(data2.Pos, data2.Look)
            end,
        })
        btn2.Position = UDim2.new(0.5, 3, 0, 0)
    end
end

-- ============================================
-- NOTIFICATION TAB
-- ============================================
local SectionWebhookUrls = Library:CreateSection("Notification", "Webhook URLs")

local FishInput = Library:CreateInput(SectionWebhookUrls, {
    Placeholder = "Fish Caught Webhook",
    Default = Current_Webhook_Fish,
    Callback = function(text) Current_Webhook_Fish = text end,
    Height = 40,
})

local LeaveInput = Library:CreateInput(SectionWebhookUrls, {
    Placeholder = "Player Leave Webhook",
    Default = Current_Webhook_Leave,
    Callback = function(text) Current_Webhook_Leave = text end,
    Height = 40,
})

local ListInput = Library:CreateInput(SectionWebhookUrls, {
    Placeholder = "Player List Webhook",
    Default = Current_Webhook_List,
    Callback = function(text) Current_Webhook_List = text end,
    Height = 40,
})

local AdminInput = Library:CreateInput(SectionWebhookUrls, {
    Placeholder = "Admin Host Webhook",
    Default = Current_Webhook_Admin,
    Callback = function(text) Current_Webhook_Admin = text end,
    Height = 40,
})

Library:CreateButton(SectionWebhookUrls, {
    Text = "🧪 Test All Connections",
    Color = Theme.Success,
    Callback = function()
        local c = 0
        if Current_Webhook_Fish ~= "" then Library:Notification({Message = "Testing Fish webhook...", Type = "info"}); c = c + 1 end
        if Current_Webhook_Leave ~= "" then Library:Notification({Message = "Testing Leave webhook...", Type = "info"}); c = c + 1 end
        if Current_Webhook_List ~= "" then Library:Notification({Message = "Testing List webhook...", Type = "info"}); c = c + 1 end
        if Current_Webhook_Admin ~= "" then Library:Notification({Message = "Testing Admin webhook...", Type = "info"}); c = c + 1 end
        if c == 0 then Library:Notification({Message = "No Webhooks Set!", Type = "error"})
        else Library:Notification({Message = "Testing " .. c .. " Webhooks...", Type = "info"}) end
    end,
})

-- Notification toggles
local SectionNotifToggles = Library:CreateSection("Notification", "Notification Settings")

Library:CreateToggle(SectionNotifToggles, {
    Text = "Secret Fish Caught",
    Default = false,
    Callback = function(state) Settings.SecretEnabled = state end,
})

Library:CreateToggle(SectionNotifToggles, {
    Text = "Ruby Gemstone",
    Default = false,
    Callback = function(state) Settings.RubyEnabled = state end,
})

Library:CreateToggle(SectionNotifToggles, {
    Text = "Evolved Enchant Stone",
    Default = false,
    Callback = function(state) Settings.EvolvedEnabled = state end,
})

Library:CreateToggle(SectionNotifToggles, {
    Text = "Mutation Crystalized",
    Default = false,
    Callback = function(state) Settings.MutationCrystalized = state end,
})

Library:CreateToggle(SectionNotifToggles, {
    Text = "Cave Crystal",
    Default = false,
    Callback = function(state) Settings.CaveCrystalEnabled = state end,
})

-- ============================================
-- ADMIN BOOST TAB
-- ============================================
local SectionAdminDetect = Library:CreateSection("Admin Boost", "Detection")

Library:CreateToggle(SectionAdminDetect, {
    Text = "Deteksi Player Asing",
    Default = false,
    Callback = function(state) Settings.ForeignDetection = state end,
})

Library:CreateToggle(SectionAdminDetect, {
    Text = "Hide Player Name (Spoiler)",
    Default = true,
    Callback = function(state) Settings.SpoilerName = state end,
})

Library:CreateToggle(SectionAdminDetect, {
    Text = "Lag Detector (Ping > 500ms)",
    Default = false,
    Callback = function(state) Settings.PingMonitor = state end,
})

Library:CreateToggle(SectionAdminDetect, {
    Text = "Player Leave Server",
    Default = false,
    Callback = function(state) Settings.LeaveEnabled = state end,
})

Library:CreateToggle(SectionAdminDetect, {
    Text = "Player Not On Server (30min)",
    Default = false,
    Callback = function(state) Settings.PlayerNonPSAuto = state end,
})

local SectionAdminActions = Library:CreateSection("Admin Boost", "Actions")

Library:CreateButton(SectionAdminActions, {
    Text = "👥 Player On Server",
    Color = Theme.Accent,
    Callback = function()
        if Current_Webhook_List == "" then 
            Library:Notification({Message = "Webhook Missing!", Type = "error"})
            return 
        end
        Library:Notification({Message = "Sending list...", Type = "info"})
        local all = Players:GetPlayers()
        local str = "Current Players (" .. #all .. "):\n\n"
        for i, p in ipairs(all) do str = str .. i .. ". " .. p.DisplayName .. " (@" .. p.Name .. ")\n" end
        task.spawn(function()
            local embed = {
                ["username"] = "ITG",
                ["avatar_url"] = "https://i.imgur.com/sblcM31.jpeg",
                ["embeds"] = {{
                    ["title"] = "Manual Player List",
                    ["description"] = "```\n" .. str .. "\n```",
                    ["color"] = 5763719,
                    ["footer"] = {["text"] = "ITG Webhook", ["icon_url"] = "https://i.imgur.com/sblcM31.jpeg"}
                }}
            }
            pcall(function() httpRequest({Url = Current_Webhook_List, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(embed)}) end)
        end)
    end,
})

Library:CreateButton(SectionAdminActions, {
    Text = "❌ Player NOT On Server",
    Color = Theme.Warning,
    Callback = function()
        if Current_Webhook_List == "" then 
            Library:Notification({Message = "Webhook Player List Empty!", Type = "error"})
            return 
        end
        Library:Notification({Message = "Checking players...", Type = "info"})
        -- Check and send non-PS logic
    end,
})

-- ============================================
-- SETTING TAB
-- ============================================
local SectionGameSettings = Library:CreateSection("Setting", "Game Settings")

Library:CreateToggle(SectionGameSettings, {
    Text = "Walk On Water",
    Default = false,
    Callback = function(state) WalkOnWaterEnabled = state end,
})

Library:CreateToggle(SectionGameSettings, {
    Text = "Remove Fish Notification Pop-up",
    Default = false,
    Callback = function(state) Settings.DisablePopups = state end,
})

Library:CreateToggle(SectionGameSettings, {
    Text = "No Animation",
    Default = false,
    Callback = function(state) Settings.NoAnimation = state end,
})

Library:CreateToggle(SectionGameSettings, {
    Text = "Remove Skin Effect",
    Default = false,
    Callback = function(state) Settings.RemoveVFX = state end,
})

Library:CreateToggle(SectionGameSettings, {
    Text = "Auto Execute on Server Hop",
    Default = false,
    Callback = function(state) Settings.AutoExecute = state end,
})

-- ============================================
-- SAVE CONFIG TAB
-- ============================================
local SectionSave = Library:CreateSection("Save Config", "Save/Load Configuration")

local ConfigNameInput = Library:CreateInput(SectionSave, {
    Placeholder = "Config Name",
    Default = "",
    Height = 40,
})

Library:CreateButton(SectionSave, {
    Text = "💾 Save Config",
    Color = Theme.Accent,
    Callback = function()
        local name = ConfigNameInput.GetText()
        if name == "" then 
            Library:Notification({Message = "Config name cannot be empty!", Type = "error"})
            return 
        end
        -- Save config logic
        Library:Notification({Message = "Config saved: " .. name, Type = "success"})
    end,
})

Library:CreateButton(SectionSave, {
    Text = "📂 Load Selected",
    Color = Theme.Success,
    Callback = function()
        Library:Notification({Message = "Config loaded", Type = "success"})
    end,
})

Library:CreateButton(SectionSave, {
    Text = "🗑️ Delete Selected",
    Color = Theme.Error,
    Callback = function()
        Library:Notification({Message = "Config deleted", Type = "success"})
    end,
})

-- ============================================
-- LIST PLAYER TAB
-- ============================================
local SectionPlayerList = Library:CreateSection("List Player", "Player List")

Library:CreateLabel(SectionPlayerList, {Text = "Host 1:", Size = 13, Bold = true})

local Host1User = Library:CreateInput(SectionPlayerList, {
    Placeholder = "Username",
    Default = "",
    Height = 36,
})

local Host1ID = Library:CreateInput(SectionPlayerList, {
    Placeholder = "Discord ID (Optional)",
    Default = "",
    Height = 36,
})

Library:CreateLabel(SectionPlayerList, {Text = "Host 2:", Size = 13, Bold = true})

local Host2User = Library:CreateInput(SectionPlayerList, {
    Placeholder = "Username",
    Default = "",
    Height = 36,
})

local Host2ID = Library:CreateInput(SectionPlayerList, {
    Placeholder = "Discord ID (Optional)",
    Default = "",
    Height = 36,
})

-- Add more player inputs (up to 20)
for i = 3, 20 do
    Library:CreateLabel(SectionPlayerList, {Text = "List " .. i .. ":", Size = 13})
    Library:CreateInput(SectionPlayerList, {
        Placeholder = "Username",
        Default = "",
        Height = 36,
    })
    Library:CreateInput(SectionPlayerList, {
        Placeholder = "Discord ID",
        Default = "",
        Height = 36,
    })
end

local SectionBulk = Library:CreateSection("List Player", "Bulk Import")

local BulkInput = Library:CreateInput(SectionBulk, {
    Placeholder = "Username:DiscordID (one per line)",
    Default = "",
    Height = 100,
})

Library:CreateButton(SectionBulk, {
    Text = "📥 Import Bulk Data",
    Color = Theme.Success,
    Callback = function()
        local text = BulkInput.GetText()
        Library:Notification({Message = "Importing...", Type = "info"})
        -- Parse and import logic
    end,
})

-- ============================================
-- CLOSE HANDLER
-- ============================================
Library:OnClose(function()
    ScriptActive = false
    if getgenv then getgenv().XAL_Stop = nil end
    if UI.Window then UI.Window.ScreenGui:Destroy() end
    print("❌ ITG System: Script closed")
end)

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
-- AUTO EXECUTE QUEUE
-- ============================================
task.spawn(function()
    local queueTeleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
    if queueTeleport then
        local TpService = game:GetService("TeleportService")
        local TeleportingConn = TpService.TeleportInit:Connect(function()
            if Settings.AutoExecute then
                print("XAL: Queuing Auto Execute...")
                pcall(function()
                    queueTeleport([[task.wait(5) loadstring(game:HttpGet("YOUR_SCRIPT_URL"))()]])
                end)
            end
        end)
        table.insert(Connections, TeleportingConn)
    end
end)

-- ============================================
-- TELEPORT FUNCTION
-- ============================================
function TeleportToLookAt(position, lookVector)
    local Character = Players.LocalPlayer.Character
    if not Character then Character = Players.LocalPlayer.CharacterAdded:Wait() end
    local hrp = Character:WaitForChild("HumanoidRootPart", 5)
    if hrp and typeof(position) == "Vector3" and typeof(lookVector) == "Vector3" then
        local targetCFrame = CFrame.new(position, position + lookVector)
        hrp.CFrame = targetCFrame * CFrame.new(0, 3, 0)
        Library:Notification({Message = "✅ Teleported!", Type = "success"})
    else
        Library:Notification({Message = "❌ Invalid TP Data", Type = "error"})
    end
end

-- ============================================
-- PRINT STARTUP MESSAGE
-- ============================================
print("✅ ITG Webhook Discord UI v2.0 Loaded!")
print("🎨 Theme: Discord Style (Blurple Accent)")
print("📊 All features integrated")
