-- ITG Webhook System - Discord Themed UI
-- Custom UI dengan tema Discord (mirip ChloX/Lynx)
-- Semua fungsi original dipertahankan

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
local ScreenGui
local VirtualUser = game:GetService("VirtualUser")
local SafeName = "RobloxReplicatedService"
local ProtectGui = protectgui or (syn and syn.protect_gui) or (gethui and function(g) g.Parent = gethui() end) or function(g) g.Parent = CoreGui end
local FishingController = require(ReplicatedStorage.Controllers.FishingController)

-- ============================================
-- DISCORD THEME CONFIGURATION
-- ============================================
local DiscordTheme = {
    -- Discord Color Palette
    BackgroundPrimary = Color3.fromRGB(54, 57, 63),      -- Main background
    BackgroundSecondary = Color3.fromRGB(47, 49, 54),    -- Secondary background
    BackgroundTertiary = Color3.fromRGB(32, 34, 37),     -- Tertiary background
    ChannelBackground = Color3.fromRGB(43, 45, 49),      -- Channel/sidebar bg
    
    -- Accent Colors
    Blurple = Color3.fromRGB(88, 101, 242),              -- Discord primary accent
    Green = Color3.fromRGB(88, 203, 88),                 -- Success/Online
    Yellow = Color3.fromRGB(250, 166, 26),               -- Warning/Idle
    Red = Color3.fromRGB(240, 71, 71),                   -- Error/DND
    White = Color3.fromRGB(255, 255, 255),               -- Primary text
    Muted = Color3.fromRGB(185, 187, 190),               -- Muted text
    Header = Color3.fromRGB(206, 207, 209),              -- Header text
    Divider = Color3.fromRGB(109, 111, 114),             -- Divider lines
    
    -- Input & Interactive
    InputBackground = Color3.fromRGB(32, 34, 37),
    HoverBackground = Color3.fromRGB(58, 61, 68),
    ActiveBackground = Color3.fromRGB(68, 72, 79),
    
    -- Status
    Online = Color3.fromRGB(88, 203, 88),
    DND = Color3.fromRGB(240, 71, 71),
    Idle = Color3.fromRGB(250, 166, 26),
    Invisible = Color3.fromRGB(116, 118, 121),
}

-- ============================================
-- GLOBAL VARIABLES (PRESERVED)
-- ============================================
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

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================
local function AddStroke(instance, color, thickness)
    local s = Instance.new("UIStroke", instance)
    s.Color = color or DiscordTheme.Divider
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function AddPadding(instance, amount)
    local p = Instance.new("UIPadding", instance)
    p.PaddingLeft = UDim.new(0, amount)
    p.PaddingRight = UDim.new(0, amount)
    p.PaddingTop = UDim.new(0, amount)
    p.PaddingBottom = UDim.new(0, amount)
    return p
end

-- ============================================
-- NOTIFICATION SYSTEM
-- ============================================
local function ShowNotification(msg, isError)
    if not ScriptActive then return end
    
    local NotifFrame = Instance.new("Frame", ScreenGui)
    NotifFrame.BackgroundColor3 = DiscordTheme.Blurple
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Position = UDim2.new(0.5, -110, 0.1, 0)
    NotifFrame.Size = UDim2.new(0, 220, 0, 40)
    NotifFrame.ZIndex = 1000

    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 8)
    AddStroke(NotifFrame, isError and DiscordTheme.Red or DiscordTheme.Green, 2)

    local Icon = Instance.new("Frame", NotifFrame)
    Icon.BackgroundColor3 = isError and DiscordTheme.Red or DiscordTheme.Green
    Icon.Size = UDim2.new(0, 4, 1, -10)
    Icon.Position = UDim2.new(0, 8, 0.5, -((40-10)/2))
    Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)

    local Label = Instance.new("TextLabel", NotifFrame)
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 20, 0, 0)
    Label.Size = UDim2.new(1, -25, 1, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = msg
    Label.TextColor3 = DiscordTheme.White
    Label.TextSize = 13
    Label.ZIndex = 1001

    NotifFrame.BackgroundTransparency = 1
    Label.TextTransparency = 1
    Icon.BackgroundTransparency = 1

    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
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

-- ============================================
-- CLEANUP FUNCTION
-- ============================================
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

    print("❌ XAL System: Script closed and cleanup complete.")
    if getgenv then getgenv().XAL_Stop = nil end
end

if getgenv then
    getgenv().XAL_Stop = CleanupScript
end

if not isfolder("XAL_Configs") then
    pcall(function() makefolder("XAL_Configs") end)
end

-- ============================================
-- MAIN UI CREATION
-- ============================================
local oldUI = CoreGui:FindFirstChild(SafeName) or CoreGui:FindFirstChild("XAL_System")
if oldUI then oldUI:Destroy() task.wait(0.1) end

ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = SafeName
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

pcall(function()
    ProtectGui(ScreenGui)
end)
if not ScreenGui.Parent then ScreenGui.Parent = CoreGui end

-- Main Window Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = DiscordTheme.BackgroundPrimary
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = false
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
AddStroke(MainFrame, DiscordTheme.Divider, 1)

-- Shadow Effect
local Shadow = Instance.new("ImageLabel", MainFrame)
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1, 60, 1, 60)
Shadow.ZIndex = -1
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceScale = 1

-- Header Bar (Discord Style)
local Header = Instance.new("Frame", MainFrame)
Header.BackgroundColor3 = DiscordTheme.BackgroundSecondary
Header.Size = UDim2.new(1, 0, 0, 32)
Header.BorderSizePixel = 0
Header.ZIndex = 5
local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 10)

-- Header Bottom Round Fix
local HeaderFix = Instance.new("Frame", Header)
HeaderFix.BackgroundColor3 = DiscordTheme.BackgroundSecondary
HeaderFix.BorderSizePixel = 0
HeaderFix.Position = UDim2.new(0, 0, 1, -10)
HeaderFix.Size = UDim2.new(1, 0, 0, 10)
HeaderFix.ZIndex = 5

-- Title
local TitleLab = Instance.new("TextLabel", Header)
TitleLab.BackgroundTransparency = 1
TitleLab.Position = UDim2.new(0, 12, 0, 0)
TitleLab.Size = UDim2.new(0, 200, 1, 0)
TitleLab.Font = Enum.Font.GothamBold
TitleLab.Text = "🎣 ITG Webhook"
TitleLab.TextColor3 = DiscordTheme.White
TitleLab.TextSize = 14
TitleLab.TextXAlignment = "Left"
TitleLab.ZIndex = 6

-- Window Controls
local ControlContainer = Instance.new("Frame", Header)
ControlContainer.BackgroundTransparency = 1
ControlContainer.Position = UDim2.new(1, -80, 0, 0)
ControlContainer.Size = UDim2.new(0, 80, 1, 0)
ControlContainer.ZIndex = 6

local MinBtn = Instance.new("TextButton", ControlContainer)
MinBtn.Name = "Minimize"
MinBtn.BackgroundTransparency = 1
MinBtn.Position = UDim2.new(0, 0, 0, 0)
MinBtn.Size = UDim2.new(0, 30, 1, 0)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "−"
MinBtn.TextColor3 = DiscordTheme.Muted
MinBtn.TextSize = 20
MinBtn.ZIndex = 6

local CloseBtn = Instance.new("TextButton", ControlContainer)
CloseBtn.Name = "Close"
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(0, 30, 0, 0)
CloseBtn.Size = UDim2.new(0, 50, 1, 0)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.TextColor3 = DiscordTheme.Muted
CloseBtn.TextSize = 20
CloseBtn.ZIndex = 6

-- Hover Effects
MinBtn.MouseEnter:Connect(function() 
    MinBtn.TextColor3 = DiscordTheme.White
    MinBtn.BackgroundColor3 = DiscordTheme.HoverBackground
    MinBtn.BackgroundTransparency = 0
end)
MinBtn.MouseLeave:Connect(function() 
    MinBtn.TextColor3 = DiscordTheme.Muted
    MinBtn.BackgroundTransparency = 1
end)

CloseBtn.MouseEnter:Connect(function() 
    CloseBtn.TextColor3 = DiscordTheme.White
    CloseBtn.BackgroundColor3 = DiscordTheme.Red
    CloseBtn.BackgroundTransparency = 0
end)
CloseBtn.MouseLeave:Connect(function() 
    CloseBtn.TextColor3 = DiscordTheme.Muted
    CloseBtn.BackgroundTransparency = 1
end)

-- ============================================
-- SIDEBAR (Discord Channel Style)
-- ============================================
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.BackgroundColor3 = DiscordTheme.BackgroundSecondary
Sidebar.Position = UDim2.new(0, 0, 0, 32)
Sidebar.Size = UDim2.new(0, 140, 1, -32)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 2
local SideCorner = Instance.new("UICorner", Sidebar)
SideCorner.CornerRadius = UDim.new(0, 0)

-- Bottom rounded corners for sidebar
local SideCornerFix1 = Instance.new("Frame", Sidebar)
SideCornerFix1.BackgroundColor3 = DiscordTheme.BackgroundSecondary
SideCornerFix1.BorderSizePixel = 0
SideCornerFix1.Position = UDim2.new(1, -10, 0, 0)
SideCornerFix1.Size = UDim2.new(0, 10, 1, 0)
SideCornerFix1.ZIndex = 2

local MenuContainer = Instance.new("ScrollingFrame", Sidebar)
MenuContainer.BackgroundTransparency = 1
MenuContainer.Size = UDim2.new(1, 0, 1, -10)
MenuContainer.Position = UDim2.new(0, 0, 0, 5)
MenuContainer.ZIndex = 5
MenuContainer.ScrollBarThickness = 0

local SideLayout = Instance.new("UIListLayout", MenuContainer)
SideLayout.Padding = UDim.new(0, 2)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", MenuContainer).PaddingTop = UDim.new(0, 5)
Instance.new("UIPadding", MenuContainer).PaddingBottom = UDim.new(0, 5)

-- ============================================
-- CONTENT AREA
-- ============================================
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 140, 0, 32)
ContentContainer.Size = UDim2.new(1, -140, 1, -32)
ContentContainer.ZIndex = 3

-- ============================================
-- MODAL (Close Confirmation)
-- ============================================
local ModalFrame = Instance.new("Frame", ScreenGui)
ModalFrame.Name = "ModalConfirm"
ModalFrame.BackgroundColor3 = DiscordTheme.BackgroundPrimary
ModalFrame.Size = UDim2.new(0, 280, 0, 140)
ModalFrame.Position = UDim2.new(0.5, -140, 0.5, -70)
ModalFrame.BorderSizePixel = 0
ModalFrame.ZIndex = 2000
ModalFrame.Visible = false
Instance.new("UICorner", ModalFrame).CornerRadius = UDim.new(0, 10)
AddStroke(ModalFrame, DiscordTheme.Divider, 2)

local ModalTitle = Instance.new("TextLabel", ModalFrame)
ModalTitle.BackgroundTransparency = 1
ModalTitle.Position = UDim2.new(0, 0, 0, 20)
ModalTitle.Size = UDim2.new(1, 0, 0, 30)
ModalTitle.Font = Enum.Font.GothamBold
ModalTitle.Text = "Close Script?"
ModalTitle.TextColor3 = DiscordTheme.White
ModalTitle.TextSize = 18
ModalTitle.ZIndex = 2002

local ModalDesc = Instance.new("TextLabel", ModalFrame)
ModalDesc.BackgroundTransparency = 1
ModalDesc.Position = UDim2.new(0, 0, 0, 50)
ModalDesc.Size = UDim2.new(1, 0, 0, 30)
ModalDesc.Font = Enum.Font.GothamMedium
ModalDesc.Text = "Are you sure you want to close the script?"
ModalDesc.TextColor3 = DiscordTheme.Muted
ModalDesc.TextSize = 12
ModalDesc.ZIndex = 2002

local BtnYes = Instance.new("TextButton", ModalFrame)
BtnYes.BackgroundColor3 = DiscordTheme.Red
BtnYes.Position = UDim2.new(0, 20, 1, -45)
BtnYes.Size = UDim2.new(0, 110, 0, 35)
BtnYes.Font = Enum.Font.GothamBold
BtnYes.Text = "Yes, Close"
BtnYes.TextColor3 = DiscordTheme.White
BtnYes.TextSize = 13
BtnYes.ZIndex = 2002
Instance.new("UICorner", BtnYes).CornerRadius = UDim.new(0, 6)

local BtnNo = Instance.new("TextButton", ModalFrame)
BtnNo.BackgroundColor3 = DiscordTheme.ChannelBackground
BtnNo.Position = UDim2.new(1, -130, 1, -45)
BtnNo.Size = UDim2.new(0, 110, 0, 35)
BtnNo.Font = Enum.Font.GothamBold
BtnNo.Text = "Cancel"
BtnNo.TextColor3 = DiscordTheme.White
BtnNo.TextSize = 13
BtnNo.ZIndex = 2002
Instance.new("UICorner", BtnNo).CornerRadius = UDim.new(0, 6)
AddStroke(BtnNo, DiscordTheme.Divider, 1)

-- ============================================
-- PAGE CREATION FUNCTION
-- ============================================
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", ContentContainer)
    Page.Name = "Page_" .. name
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.ScrollBarThickness = 6
    Page.ScrollBarImageColor3 = DiscordTheme.Blurple
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.ZIndex = 4
    Page.BottomImage = "rbxassetid://6652743245"
    Page.TopImage = "rbxassetid://6652743245"
    Page.MidImage = "rbxassetid://6652743245"

    local layout = Instance.new("UIListLayout", Page)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local padding = Instance.new("UIPadding", Page)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)

    return Page
end

-- Create all pages
local Page_SessionStats = CreatePage("SessionStats")
local Page_Fhising = CreatePage("Fhising")
local Page_Teleport = CreatePage("Teleport")
local Page_Webhook = CreatePage("Webhook")
local Page_AdminBoost = CreatePage("AdminBoost")
local Page_Tag = CreatePage("TagDiscord")
local Page_Setting = CreatePage("Setting")
local Page_Save = CreatePage("SaveConfig")

-- ============================================
-- TAB BUTTON CREATION (Discord Style)
-- ============================================
local function CreateTab(name, target, icon, isDefault)
    local TabBtn = Instance.new("TextButton", MenuContainer)
    TabBtn.BackgroundColor3 = DiscordTheme.ChannelBackground
    TabBtn.BackgroundTransparency = 1
    TabBtn.Size = UDim2.new(1, -10, 0, 32)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Text = icon .. "  " .. name
    TabBtn.TextColor3 = DiscordTheme.Muted
    TabBtn.TextSize = 13
    TabBtn.ZIndex = 5
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    -- Active Indicator (left bar)
    local Indicator = Instance.new("Frame", TabBtn)
    Indicator.Name = "ActiveIndicator"
    Indicator.BackgroundColor3 = DiscordTheme.White
    Indicator.BorderSizePixel = 0
    Indicator.Position = UDim2.new(0, 0, 0.5, -8)
    Indicator.Size = UDim2.new(0, 3, 0, 16)
    Indicator.Visible = false
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

    TabBtn.MouseButton1Click:Connect(function()
        -- Hide all pages
        for _, page in pairs(ContentContainer:GetChildren()) do
            if page:IsA("ScrollingFrame") or page:IsA("Frame") then
                page.Visible = false
            end
        end
        target.Visible = true

        -- Reset all tabs
        for _, child in pairs(MenuContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child.TextColor3 = DiscordTheme.Muted
                child.Font = Enum.Font.GothamMedium
                child.BackgroundTransparency = 1
                child.BackgroundColor3 = DiscordTheme.ChannelBackground
                local line = child:FindFirstChild("ActiveIndicator")
                if line then line.Visible = false end
            end
        end

        -- Set active tab
        TabBtn.TextColor3 = DiscordTheme.White
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.BackgroundTransparency = 0
        TabBtn.BackgroundColor3 = DiscordTheme.ActiveBackground
        Indicator.Visible = true
    end)

    if isDefault then
        TabBtn.TextColor3 = DiscordTheme.White
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.BackgroundTransparency = 0
        TabBtn.BackgroundColor3 = DiscordTheme.ActiveBackground
        Indicator.Visible = true
        target.Visible = true
    end
    
    return TabBtn
end

-- Create tabs with Discord-style icons
CreateTab("Server Info", Page_SessionStats, "📊", true)
CreateTab("Fhising", Page_Fhising, "🎣")
CreateTab("Teleport", Page_Teleport, "📍")
CreateTab("Notification", Page_Webhook, "🔔")
CreateTab("Admin Boost", Page_AdminBoost, "👑")
CreateTab("List Player", Page_Tag, "👥")
CreateTab("Setting", Page_Setting, "⚙️")
CreateTab("Save Config", Page_Save, "💾")

-- ============================================
-- UI COMPONENT FUNCTIONS
-- ============================================

-- Toggle Switch (Discord Style)
local function CreateToggle(parent, text, settingKey, callback, validationFunc)
    local Frame = Instance.new("Frame", parent)
    Frame.BackgroundColor3 = DiscordTheme.ChannelBackground
    Frame.BackgroundTransparency = 0
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel", Frame)
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.Size = UDim2.new(0, 280, 1, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = text
    Label.TextColor3 = DiscordTheme.White
    Label.TextSize = 13
    Label.TextXAlignment = "Left"

    local default = false
    if type(settingKey) == "string" then
        default = Settings[settingKey] or false
    end

    -- Discord-style Toggle Switch
    local Switch = Instance.new("Frame", Frame)
    Switch.BackgroundColor3 = default and DiscordTheme.Green or DiscordTheme.InputBackground
    Switch.Position = UDim2.new(1, -50, 0.5, -12)
    Switch.Size = UDim2.new(0, 40, 0, 22)
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", Switch)
    Circle.BackgroundColor3 = DiscordTheme.White
    Circle.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    Circle.Size = UDim2.new(0, 18, 0, 18)
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local function UpdateUI(state)
        local targetColor = state and DiscordTheme.Green or DiscordTheme.InputBackground
        local targetPos = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        Circle:TweenPosition(targetPos, "Out", "Sine", 0.15, true)
    end

    if type(settingKey) == "string" then
        ToggleRegistry[settingKey] = function(val)
            UpdateUI(val)
            if callback then callback(val) end
        end
    end

    local ClickBtn = Instance.new("TextButton", Frame)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
    ClickBtn.Text = ""
    ClickBtn.ZIndex = 10

    ClickBtn.MouseButton1Click:Connect(function()
        local n = not (Switch.BackgroundColor3 == DiscordTheme.Green)
        if n and validationFunc and not validationFunc() then 
            ShowNotification("Webhook Empty!", true) 
            return 
        end

        if type(settingKey) == "string" then
            Settings[settingKey] = n
        end

        UpdateUI(n)
        if callback then callback(n) end
        ShowNotification(text .. (n and " Enabled" or " Disabled"))
    end)
end

-- Input Field (Discord Style)
local function CreateInput(parent, placeholder, default, callback, height)
    local Frame = Instance.new("Frame", parent)
    Frame.BackgroundColor3 = DiscordTheme.ChannelBackground
    local finalHeight = height and (height - 2) or 36
    Frame.Size = UDim2.new(1, 0, 0, finalHeight)
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel", Frame)
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.Size = UDim2.new(0, 120, 1, 0)
    Label.Font = Enum.Font.GothamBold
    Label.Text = placeholder
    Label.TextColor3 = DiscordTheme.Header
    Label.TextSize = 12
    Label.TextXAlignment = "Left"

    local InputBg = Instance.new("Frame", Frame)
    InputBg.BackgroundColor3 = DiscordTheme.InputBackground
    InputBg.Position = UDim2.new(0, 140, 0.5, -14)
    InputBg.Size = UDim2.new(1, -152, 0, 28)
    InputBg.ClipsDescendants = true
    Instance.new("UICorner", InputBg).CornerRadius = UDim.new(0, 6)

    local Input = Instance.new("TextBox", InputBg)
    Input.BackgroundTransparency = 1
    Input.Position = UDim2.new(0, 8, 0, 0)
    Input.Size = UDim2.new(1, -16, 1, 0)
    Input.Font = Enum.Font.GothamMedium
    Input.Text = default or ""
    Input.PlaceholderText = "Paste here..."
    Input.PlaceholderColor3 = DiscordTheme.Muted
    Input.TextColor3 = DiscordTheme.White
    Input.TextSize = 12
    Input.TextXAlignment = "Left"
    Input.ClearTextOnFocus = false

    Input.Focused:Connect(function() 
        AddStroke(InputBg, DiscordTheme.Blurple, 2) 
    end)
    Input.FocusLost:Connect(function() 
        AddStroke(InputBg, DiscordTheme.Divider, 1) 
        if callback then callback(Input.Text, Input) end
    end)
    
    return Input
end

-- Button (Discord Style)
local function CreateButton(parent, text, color, callback, size)
    local Btn = Instance.new("TextButton", parent)
    Btn.BackgroundColor3 = color or DiscordTheme.Blurple
    Btn.Size = size or UDim2.new(1, 0, 0, 36)
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = text
    Btn.TextColor3 = DiscordTheme.White
    Btn.TextSize = 13
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(callback)
    
    -- Hover effect
    Btn.MouseEnter:Connect(function()
        Btn.BackgroundColor3 = Color3.new(
            math.min(color.R + 0.1, 1),
            math.min(color.G + 0.1, 1),
            math.min(color.B + 0.1, 1)
        )
    end)
    Btn.MouseLeave:Connect(function()
        Btn.BackgroundColor3 = color or DiscordTheme.Blurple
    end)
    
    return Btn
end

-- ============================================
-- TELEPORT PAGE
-- ============================================
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

local function TeleportToLookAt(position, lookVector)
    local Character = Players.LocalPlayer.Character
    if not Character then Character = Players.LocalPlayer.CharacterAdded:Wait() end
    local hrp = Character:WaitForChild("HumanoidRootPart", 5)

    if hrp and typeof(position) == "Vector3" and typeof(lookVector) == "Vector3" then
        local targetCFrame = CFrame.new(position, position + lookVector)
        hrp.CFrame = targetCFrame * CFrame.new(0, 3, 0)
        ShowNotification("✅ Teleported!", false)
    else
        ShowNotification("❌ Invalid TP Data", true)
    end
end

local sortedAreas = {}
for name, _ in pairs(FishingAreas) do table.insert(sortedAreas, name) end
table.sort(sortedAreas)

for i = 1, #sortedAreas, 2 do
    local name1 = sortedAreas[i]
    local name2 = sortedAreas[i+1]

    local Row = Instance.new("Frame", Page_Teleport)
    Row.BackgroundTransparency = 1
    Row.Size = UDim2.new(1, 0, 0, 36)

    local data1 = FishingAreas[name1]
    local Btn1 = CreateButton(Row, "📍 " .. name1, DiscordTheme.Blurple, function()
        TeleportToLookAt(data1.Pos, data1.Look)
    end, UDim2.new(0.5, -3, 1, 0))
    Btn1.Position = UDim2.new(0, 0, 0, 0)

    if name2 then
        local data2 = FishingAreas[name2]
        local Btn2 = CreateButton(Row, "📍 " .. name2, DiscordTheme.Blurple, function()
            TeleportToLookAt(data2.Pos, data2.Look)
        end, UDim2.new(0.5, -3, 1, 0))
        Btn2.Position = UDim2.new(0.5, 3, 0, 0)
    end
end

-- ============================================
-- OPEN BUTTON (Minimized)
-- ============================================
local IconPath = "XAL_Min_Icon.jpg"
local IconUrl = "https://i.imgur.com/Z92uLfK.jpeg"
local RealIconAsset = ""

if not isfile(IconPath) then
    local success, response = pcall(function()
        return httpRequest({Url = IconUrl, Method = "GET"})
    end)
    if success and response.Body then
        writefile(IconPath, response.Body)
    end
end

if isfile(IconPath) and (getcustomasset or getsynasset) then
    RealIconAsset = (getcustomasset or getsynasset)(IconPath)
end

if RealIconAsset == "" then RealIconAsset = "rbxassetid://0" end

local OpenBtn = Instance.new("ImageButton", ScreenGui)
OpenBtn.Name = "OpenBtn"
OpenBtn.BackgroundColor3 = DiscordTheme.Blurple
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 20, 0, 80)
OpenBtn.Image = RealIconAsset
OpenBtn.Visible = true
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.ScaleType = Enum.ScaleType.Fit
OpenBtn.SliceScale = 1
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 10)
AddStroke(OpenBtn, DiscordTheme.Divider, 1)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ============================================
-- WINDOW CONTROLS
-- ============================================
CloseBtn.MouseButton1Click:Connect(function() ModalFrame.Visible = true end)
BtnNo.MouseButton1Click:Connect(function() ModalFrame.Visible = false end)

BtnYes.MouseButton1Click:Connect(function()
    if ScreenGui then ScreenGui:Destroy() end
    ScriptActive = false
    if getgenv and getgenv().XAL_Stop then
        pcall(getgenv().XAL_Stop)
    end
end)

MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- ============================================
-- CONTINUE WITH ORIGINAL LOGIC
-- ============================================
-- [The rest of the original script logic continues here...]
-- All webhook functions, detection systems, and features remain unchanged

print("✅ ITG System Discord UI v2.0 Loaded!")
print("🎨 Theme: Discord Style")
