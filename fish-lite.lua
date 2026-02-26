-- ============================================
-- NikeeHUB FISHING - LITE VERSION
-- Bypass BAC-10288 + Instant Fishing + UI Lengkap
-- Standalone (tidak perlu load file lain)
-- ============================================
-- Untuk Velocity Executor
-- ============================================

print("============================================")
print("NikeeHUB FISHING - LITE")
print("BAC-10288 Bypass Active")
print("============================================")

-- ============================================
-- BYPASS LAYER 1: STARTUP DELAY
-- ============================================
task.wait(math.random(10, 15))

-- ============================================
-- BYPASS LAYER 2: CLEAN TRACES
-- ============================================
pcall(function()
    local CoreGui = game:GetService("CoreGui")
    for _, child in pairs(CoreGui:GetChildren()) do
        if child.Name:find("Nikee") or child.Name:find("RobloxReplicated") or child.Name:find("Dark") or child.Name:find("Spy") then
            pcall(function() child:Destroy() end)
        end
    end
end)

-- ============================================
-- MAIN SCRIPT VARIABLES
-- ============================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local ScriptActive = true
local Connections = {}
local ScreenGui
local VirtualUser = game:GetService("VirtualUser")
local SafeName = "RobloxReplicatedService"
local ProtectGui = protectgui or (syn and syn.protect_gui) or (gethui and function(g) g.Parent = gethui() end) or function(g) g.Parent = CoreGui end

-- ============================================
-- BYPASS LAYER 3: SECURE FIRESERVER
-- ============================================
local SecureFireServer = {CallCount = 0, LastCall = 0, MinDelay = 0.5}

function SecureFireServer:Call(remote, ...)
    local now = tick()
    if now - self.LastCall < self.MinDelay then
        task.wait(self.MinDelay - (now - self.LastCall) + math.random() * 0.3)
    end
    self.LastCall = tick()
    return pcall(function()
        if remote then remote:FireServer(...) end
    end)
end

function SecureFireServer:Invoke(remote, ...)
    local now = tick()
    if now - self.LastCall < self.MinDelay then
        task.wait(self.MinDelay - (now - self.LastCall) + math.random() * 0.3)
    end
    self.LastCall = tick()
    return pcall(function()
        if remote then return remote:InvokeServer(...) end
    end)
end

print("[BYPASS] Secure FireServer: ACTIVE")

-- ============================================
-- THEME
-- ============================================
local Theme = {
    Background = Color3.fromRGB(20, 22, 28),
    Header = Color3.fromRGB(25, 28, 35),
    Sidebar = Color3.fromRGB(18, 20, 25),
    Content = Color3.fromRGB(22, 24, 30),
    Accent = Color3.fromRGB(0, 139, 139),
    AccentHover = Color3.fromRGB(0, 160, 160),
    TextPrimary = Color3.fromRGB(240, 240, 240),
    TextSecondary = Color3.fromRGB(160, 165, 175),
    Border = Color3.fromRGB(45, 50, 60),
    Input = Color3.fromRGB(15, 16, 20),
    Success = Color3.fromRGB(75, 185, 115),
    Error = Color3.fromRGB(235, 85, 85)
}

-- ============================================
-- SETTINGS
-- ============================================
local Settings = {
    InstantFishingEnabled = false,
    InstantFishingCompleteDelay = 0.7,
    InstantFishingCastDelay = 0.1,
    InstantFishingClaimAmount = 3,
    AutoEquipRodEnabled = false,
    AutoSellEnabled = false,
    AutoSellThreshold = 600,
    AutoTotemEnabled = false,
    SelectedTotem = "Luck Totem",
    WalkOnWaterEnabled = false,
    AutoClickFishingEnabled = false,
    DetectorStuckEnabled = false,
    StuckThreshold = 15,
}

-- ============================================
-- GET REMOTE FUNCTION
-- ============================================
local RPath = {"Packages", "_Index", "sleitnick_net@0.2.0", "net"}
local function GetRemote(name)
    local curr = ReplicatedStorage
    for _, child in ipairs(RPath) do
        curr = curr:WaitForChild(child, 1)
        if not curr then return nil end
    end
    return curr:FindFirstChild(name)
end

-- ============================================
-- SHOW NOTIFICATION
-- ============================================
function ShowNotification(msg, isError)
    if not ScriptActive then return end
    local NotifFrame = Instance.new("Frame", ScreenGui)
    NotifFrame.BackgroundColor3 = Theme.Background
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Position = UDim2.new(0.5, -110, 0.1, 0)
    NotifFrame.Size = UDim2.new(0, 220, 0, 40)
    NotifFrame.ZIndex = 200

    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", NotifFrame)
    stroke.Color = isError and Theme.Error or Theme.Accent
    stroke.Thickness = 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Icon = Instance.new("Frame", NotifFrame)
    Icon.BackgroundColor3 = isError and Theme.Error or Theme.Accent
    Icon.Size = UDim2.new(0, 4, 1, -10)
    Icon.Position = UDim2.new(0, 8, 0.5, -((40-10)/2))
    Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)

    local Label = Instance.new("TextLabel", NotifFrame)
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 20, 0, 0)
    Label.Size = UDim2.new(1, -25, 1, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = msg
    Label.TextColor3 = Theme.TextPrimary
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

-- ============================================
-- INSTANT FISHING
-- ============================================
local IF = {Remotes = {Charge = nil, Request = nil, Cancel = nil, Claim = nil}, Initialized = false, Enabled = false}

local function IF_Init()
    if IF.Initialized then return true end
    local s, r = pcall(function()
        local np = ReplicatedStorage:WaitForChild("Packages", 5):WaitForChild("_Index", 5):WaitForChild("sleitnick_net@0.2.0", 5):WaitForChild("net", 5)
        if np then
            IF.Remotes.Charge = np:WaitForChild("RF/F<2Lm7M<A<?G< Dk", 3)
            IF.Remotes.Request = np:WaitForChild("RF/U9BOkE{x7G>BC5\"pt:5cGg(B6vw7k", 3)
            IF.Remotes.Cancel = np:WaitForChild("RF/F5?=k>M<A<?G<vCw{EA", 3)
            IF.Remotes.Claim = np:WaitForChild("RF/F5E=nwpF6vEFE::{k5", 3)
            IF.Initialized = IF.Remotes.Charge and IF.Remotes.Request and IF.Remotes.Cancel and IF.Remotes.Claim
            return IF.Initialized
        end
        return false
    end)
    return s and r
end

local function IF_FishingLoop()
    while IF.Enabled and ScriptActive do
        SecureFireServer:Invoke(IF.Remotes.Cancel)
        SecureFireServer:Invoke(IF.Remotes.Charge)
        SecureFireServer:Invoke(IF.Remotes.Request, -1.233184814453125, 0.0017426679483021346, tick())
        task.wait(Settings.InstantFishingCompleteDelay + math.random(2, 5) / 10)
        for i = 1, (Settings.InstantFishingClaimAmount or 3) do
            task.spawn(function() SecureFireServer:Invoke(IF.Remotes.Claim) end)
        end
        task.wait(Settings.InstantFishingCastDelay + math.random(1, 3) / 10)
    end
end

function IF_Start()
    if not IF_Init() then
        ShowNotification("Fishing Remotes Missing!", true)
        Settings.InstantFishingEnabled = false
        return
    end
    IF.Enabled = true
    task.spawn(IF_FishingLoop)
end

function IF_Stop()
    IF.Enabled = false
end

task.spawn(function()
    while ScriptActive do
        if Settings.InstantFishingEnabled and not IF.Enabled then
            IF_Start()
            repeat task.wait(0.1) until not Settings.InstantFishingEnabled or not ScriptActive
        end
        task.wait(0.1)
    end
end)

-- ============================================
-- AUTO EQUIP ROD
-- ============================================
task.spawn(function()
    local lastEquipTime = 0
    local equipCooldown = 0.5

    while ScriptActive do
        if Settings.AutoEquipRodEnabled then
            local currentChar = Players.LocalPlayer.Character
            if currentChar then
                local humanoid = currentChar:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local equippedTool = humanoid:FindFirstChildOfClass("Tool")
                    local shouldEquipRod = false

                    if not equippedTool then
                        shouldEquipRod = true
                    else
                        local toolName = equippedTool.Name:lower()
                        if not toolName:find("rod") and not toolName:find("fishing") then
                            shouldEquipRod = true
                        end
                    end

                    if shouldEquipRod and (tick() - lastEquipTime) > equipCooldown then
                        local EquipRemote = GetRemote("RE/HEFCv&vB:yHHBuD{h2@")
                        if EquipRemote then
                            SecureFireServer:Call(EquipRemote, 1)
                            lastEquipTime = tick()
                        end
                    end
                end
            end
        end
        task.wait(0.05)
    end
end)

-- ============================================
-- CREATE UI
-- ============================================
local oldUI = CoreGui:FindFirstChild(SafeName)
if oldUI then oldUI:Destroy() task.wait(0.1) end

ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = SafeName
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ProtectGui(ScreenGui) end)
if not ScreenGui.Parent then ScreenGui.Parent = CoreGui end

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -140)
MainFrame.Size = UDim2.new(0, 480, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Theme.Border
mainStroke.Thickness = 1

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.BackgroundColor3 = Theme.Header
Header.Size = UDim2.new(1, 0, 0, 36)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local TitleLab = Instance.new("TextLabel", Header)
TitleLab.BackgroundTransparency = 1
TitleLab.Position = UDim2.new(0, 15, 0, 0)
TitleLab.Size = UDim2.new(0, 200, 1, 0)
TitleLab.Font = Enum.Font.GothamBold
TitleLab.Text = "NikeeHUB - Lite"
TitleLab.TextColor3 = Theme.Accent
TitleLab.TextSize = 14
TitleLab.TextXAlignment = "Left"

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Theme.TextSecondary
CloseBtn.TextSize = 22
CloseBtn.MouseButton1Click:Connect(function()
    ScriptActive = false
    if ScreenGui then ScreenGui:Destroy() end
end)

-- Sidebar
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.Position = UDim2.new(0, 0, 0, 36)
Sidebar.Size = UDim2.new(0, 110, 1, -36)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

-- Content Container
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 120, 0, 42)
ContentContainer.Size = UDim2.new(1, -120, 1, -48)

local Page_Fhising = Instance.new("ScrollingFrame", ContentContainer)
Page_Fhising.Name = "Page_Fhising"
Page_Fhising.BackgroundTransparency = 1
Page_Fhising.Size = UDim2.new(1, 0, 1, 0)
Page_Fhising.ScrollBarThickness = 3
Page_Fhising.ScrollBarImageColor3 = Theme.Accent
Page_Fhising.CanvasSize = UDim2.new(0, 0, 0, 0)
Page_Fhising.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout", Page_Fhising)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- ============================================
-- UI HELPER FUNCTIONS
-- ============================================
local function AddStroke(instance, color, thickness)
    local s = Instance.new("UIStroke", instance)
    s.Color = color or Theme.Border
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local ToggleRegistry = {}

local function CreateToggle(parent, text, settingKey, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.BackgroundColor3 = Theme.Content
    Frame.Size = UDim2.new(1, -5, 0, 36)
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    AddStroke(Frame, Theme.Border, 1)

    local Label = Instance.new("TextLabel", Frame)
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(0, 180, 1, 0)
    Label.Font = Enum.Font.GothamBold
    Label.Text = text
    Label.TextColor3 = Theme.TextPrimary
    Label.TextSize = 12
    Label.TextXAlignment = "Left"

    local default = Settings[settingKey] or false

    local Switch = Instance.new("TextButton", Frame)
    Switch.BackgroundColor3 = default and Theme.Success or Theme.Input
    Switch.Position = UDim2.new(1, -45, 0.5, -10)
    Switch.Size = UDim2.new(0, 36, 0, 20)
    Switch.Text = ""
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", Switch)
    Circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Circle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local function UpdateUI(state)
        local targetColor = state and Theme.Success or Theme.Input
        local targetPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        Circle:TweenPosition(targetPos, "Out", "Sine", 0.15, true)
    end

    ToggleRegistry[settingKey] = function(val) UpdateUI(val) end

    Switch.MouseButton1Click:Connect(function()
        local n = not (Switch.BackgroundColor3 == Theme.Success)
        Settings[settingKey] = n
        UpdateUI(n)
        if callback then callback(n) end
        ShowNotification(text .. (n and " Enabled" or " Disabled"))
    end)
end

local function CreateInput(parent, placeholder, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.BackgroundColor3 = Theme.Content
    Frame.Size = UDim2.new(1, -5, 0, 32)
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    AddStroke(Frame, Theme.Border, 1)

    local Label = Instance.new("TextLabel", Frame)
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(0, 140, 1, 0)
    Label.Font = Enum.Font.GothamBold
    Label.Text = placeholder
    Label.TextColor3 = Theme.TextSecondary
    Label.TextSize = 12
    Label.TextXAlignment = "Left"

    local InputBg = Instance.new("Frame", Frame)
    InputBg.BackgroundColor3 = Theme.Input
    InputBg.Position = UDim2.new(0, 150, 0.5, -10)
    InputBg.Size = UDim2.new(1, -160, 0, 20)
    InputBg.ClipsDescendants = true
    Instance.new("UICorner", InputBg).CornerRadius = UDim.new(0, 4)
    AddStroke(InputBg, Theme.Border, 1)

    local Input = Instance.new("TextBox", InputBg)
    Input.BackgroundTransparency = 1
    Input.Position = UDim2.new(0, 5, 0, 0)
    Input.Size = UDim2.new(1, -10, 1, 0)
    Input.Font = Enum.Font.GothamMedium
    Input.Text = default
    Input.TextColor3 = Theme.TextPrimary
    Input.TextSize = 11
    Input.TextXAlignment = "Left"
    Input.ClearTextOnFocus = false

    Input.Focused:Connect(function() AddStroke(InputBg, Theme.Accent, 1) end)
    Input.FocusLost:Connect(function()
        AddStroke(InputBg, Theme.Border, 1)
        local val = tonumber(Input.Text)
        if val then callback(val) end
    end)

    return Input
end

-- ============================================
-- UI SECTIONS
-- ============================================
local lbl = Instance.new("TextLabel", Page_Fhising)
lbl.BackgroundTransparency = 1
lbl.Size = UDim2.new(1, -5, 0, 20)
lbl.Font = Enum.Font.GothamBold
lbl.Text = "⚡ Instant Fishing"
lbl.TextColor3 = Theme.Accent
lbl.TextSize = 12
lbl.TextXAlignment = "Left"

CreateToggle(Page_Fhising, "Enable Instant Fishing", "InstantFishingEnabled", function(state)
    if state then
        if not IF_Init() then
            ShowNotification("Fishing Remotes Missing!", true)
            Settings.InstantFishingEnabled = false
            return
        end
        IF.Enabled = true
        task.spawn(IF_FishingLoop)
    else
        IF.Enabled = false
    end
end)

CreateInput(Page_Fhising, "Complete Delay", Settings.InstantFishingCompleteDelay, function(val)
    Settings.InstantFishingCompleteDelay = val
    ShowNotification("Complete Delay: " .. val)
end)

CreateInput(Page_Fhising, "Cast Delay", Settings.InstantFishingCastDelay, function(val)
    Settings.InstantFishingCastDelay = val
    ShowNotification("Cast Delay: " .. val)
end)

CreateInput(Page_Fhising, "Claim Amount", Settings.InstantFishingClaimAmount, function(val)
    Settings.InstantFishingClaimAmount = math.floor(val)
    ShowNotification("Claim Amount: " .. Settings.InstantFishingClaimAmount)
end)

local lbl2 = Instance.new("TextLabel", Page_Fhising)
lbl2.BackgroundTransparency = 1
lbl2.Size = UDim2.new(1, -5, 0, 20)
lbl2.Font = Enum.Font.GothamBold
lbl2.Text = "🎣 Auto Equip Rod"
lbl2.TextColor3 = Theme.Accent
lbl2.TextSize = 12
lbl2.TextXAlignment = "Left"

CreateToggle(Page_Fhising, "Enable Auto Equip Rod", "AutoEquipRodEnabled", function(state)
    ShowNotification("Auto Equip Rod: " .. (state and "ON" or "OFF"))
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
        for i, v in pairs(getconnections(Players.LocalPlayer.Idled)) do
            v:Disable()
        end
    end)
end)

print("============================================")
print("[✓] NikeeHUB LITE Loaded Successfully!")
print("[✓] BAC-10288 Protection: ACTIVE")
print("[✓] Instant Fishing: READY")
print("[✓] UI: ACTIVE")
print("============================================")
