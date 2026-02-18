-- NikeeHUB FishIt - SpeedHub UI Version
-- Menggunakan SpeedHubUI Library
-- 2 File: SpeedHubUI.lua (library) + file ini (main script)
-- Usage: loadstring(readfile("fish-ittttt-speedhub.lua"))()

-- Load SpeedHubUI Library
local SpeedHubUI = loadstring(readfile("SpeedHubUI.lua"))()
if not SpeedHubUI then
    warn("SpeedHubUI library not found! Please ensure SpeedHubUI.lua exists.")
    return
end

-- Services
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

-- Variables
local ScriptActive = true
local Connections = {}
local ScreenGui
local VirtualUser = game:GetService("VirtualUser")
local FishingController = require(ReplicatedStorage.Controllers.FishingController)

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
    if ScreenGui then ScreenGui:Destroy() end
    print("❌ NikeeHUB System: Script closed and cleanup complete.")
    if getgenv then getgenv().Byu_Stop = nil end
end

if getgenv then
    getgenv().Byu_Stop = CleanupScript
end

-- Create folders
if not isfolder("Nikee_Configs") then
    pcall(function() makefolder("Nikee_Configs") end)
end

-- Theme & Colors (from SpeedHubUI)
local Theme = SpeedHubUI.Themes
local AccentColor = SpeedHubUI.Color

-- Global Variables
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

-- Fishing Areas
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

-- Anti-AFK
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

-- AutoExecute queue
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

-- Tag System
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

-- ShowNotification using SpeedHubUI
function ShowNotification(msg, isError)
    SpeedHubUI:ShowNotification(msg, isError)
end

local function UpdateTagData()
    if #TagList == 0 then
        for i = 1, 20 do TagList[i] = {"", ""} end
    end
end
UpdateTagData()

-- Teleport function
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

-- Get Remote function
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

-- Create UI Window
ScreenGui = SpeedHubUI:CreateWindow({
    Title = "NikeeHUB",
    Footer = "FishIt",
    Color = AccentColor
})

-- Create Pages
local Page_SessionStats = ScreenGui:AddPage("SessionStats")
local Page_Fhising = ScreenGui:AddPage("Fhising")
local Page_Teleport = ScreenGui:AddPage("Teleport")
local Page_Webhook = ScreenGui:AddPage("Webhook")
local Page_AdminBoost = ScreenGui:AddPage("AdminBoost")
local Page_Tag = ScreenGui:AddPage("TagDiscord")
local Page_Setting = ScreenGui:AddPage("Setting")
local Page_Save = ScreenGui:AddPage("SaveConfig")

-- Create Tabs
ScreenGui.AddTab("Server Info", Page_SessionStats, true)
ScreenGui.AddTab("Fhising", Page_Fhising)
ScreenGui.AddTab("Teleport", Page_Teleport)
ScreenGui.AddTab("Notification", Page_Webhook)
ScreenGui.AddTab("Admin Boost", Page_AdminBoost)
ScreenGui.AddTab("List Player", Page_Tag)
ScreenGui.AddTab("Setting", Page_Setting)
ScreenGui.AddTab("Save Config", Page_Save)

-- ========== SERVER INFO TAB ==========
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
            ["username"] = "NikeeHUB Stats",
            ["avatar_url"] = "https://i.imgur.com/CWWGnhO.jpeg",
            ["embeds"] = {{
                ["title"] = "Session Report",
                ["description"] = "```\n" .. contentStr .. "\n```",
                ["color"] = 5763719,
                ["footer"] = { ["text"] = "NikeeHUB Webhook", ["icon_url"] = "https://i.imgur.com/CWWGnhO.jpeg" }
            }}
        }
        pcall(function() httpRequest({ Url = Current_Webhook_Admin, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode(embed) }) end)
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

-- ========== FHISING TAB ==========
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
                if (tick() - LastSellTime) >= 600 then
                    pcall(function() RF_Sell:InvokeServer() end)
                    LastSellTime = tick()
                end
                local Replion = require(ReplicatedStorage.Packages.Replion).Client:WaitReplion("Data", 1)
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
end, nil)

local WeatherList = { "Wind", "Cloudy", "Storm" }
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
                    ShowNotification("Totem UUID Not Found!", true)
                    task.wait(5)
                end
            end
        end)
    end
end, nil)

-- ========== TELEPORT TAB ==========
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

-- ========== NOTIFICATION TAB ==========
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

-- ========== ADMIN BOOST TAB ==========
ScreenGui.CreateToggle(Page_AdminBoost, "Deteksi Player Asing", "ForeignDetection", function(v) Settings.ForeignDetection = v end, function() return Current_Webhook_Admin ~= "" end)
ScreenGui.CreateToggle(Page_AdminBoost, "Hide Player Name (Spoiler)", "SpoilerName", function(v) Settings.SpoilerName = v end, nil)
ScreenGui.CreateToggle(Page_AdminBoost, "Lag Detector (Ping > 500ms)", "PingMonitor", function(v) Settings.PingMonitor = v end, function() return Current_Webhook_Admin ~= "" end)
ScreenGui.CreateToggle(Page_AdminBoost, "Player Leave Server", "LeaveEnabled", function(v) Settings.LeaveEnabled = v end, function() return Current_Webhook_Leave ~= "" end)
ScreenGui.CreateToggle(Page_AdminBoost, "Player Not On Server (30 minutes)", "PlayerNonPSAuto", function(v) Settings.PlayerNonPSAuto = v end, function() return Current_Webhook_List ~= "" end)

-- ========== LIST PLAYER TAB ==========
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

-- ========== SETTING TAB ==========
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

-- ========== SAVE CONFIG TAB ==========
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
    local validKeys = {
        "SecretEnabled", "RubyEnabled", "MutationCrystalized", "CaveCrystalEnabled",
        "LeaveEnabled", "PlayerNonPSAuto", "ForeignDetection", "SpoilerName",
        "PingMonitor", "AutoExecute", "NoAnimation", "RemoveVFX", "DisablePopups",
        "EvolvedEnabled"
    }
    local cleanSettings = {}
    for _, key in ipairs(validKeys) do
        if Settings[key] ~= nil then
            cleanSettings[key] = Settings[key]
        end
    end
    local cleanPlayers = {}
    for i = 1, 20 do
        if TagList[i] and type(TagList[i]) == "table" then
            cleanPlayers[i] = {tostring(TagList[i][1] or ""), tostring(TagList[i][2] or "")}
        else
            cleanPlayers[i] = {"", ""}
        end
    end
    local cleanWebhooks = {
        Fish = tostring(Current_Webhook_Fish or ""),
        Leave = tostring(Current_Webhook_Leave or ""),
        List = tostring(Current_Webhook_List or ""),
        Admin = tostring(Current_Webhook_Admin or "")
    }
    local saveData = {
        Webhooks = cleanWebhooks,
        Players = cleanPlayers,
        Settings = cleanSettings
    }
    local jsonSuccess, encodedData = pcall(function() return HttpService:JSONEncode(saveData) end)
    if not jsonSuccess then
        ShowNotification("Encoding Error: " .. tostring(encodedData), true)
        warn("NikeeHUB SAVE ERROR (JSON):", encodedData)
        return
    end
    local success, err = pcall(function()
        if not isfolder("Nikee_Configs") then makefolder("Nikee_Configs") end
        writefile("Nikee_Configs/" .. name .. ".json", encodedData)
    end)
    if success then
        ShowNotification("Config Saved!", false)
        RefreshConfigList()
    else
        ShowNotification("Write Error: " .. tostring(err), true)
        warn("NikeeHUB SAVE ERROR (WRITE):", err)
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

-- ========== WEBHOOK & CHAT MONITORING ==========
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
    if UI_StatsLabels["TotalSent"] then UI_StatsLabels["TotalSent"].Text = tostring(SessionStats.TotalSent) end
    if UI_StatsLabels["Secret"] then UI_StatsLabels["Secret"].Text = tostring(SessionStats.Secret) end
    if UI_StatsLabels["Ruby"] then UI_StatsLabels["Ruby"].Text = tostring(SessionStats.Ruby) end
    if UI_StatsLabels["Evolved"] then UI_StatsLabels["Evolved"].Text = tostring(SessionStats.Evolved) end
    if UI_StatsLabels["Crystalized"] then UI_StatsLabels["Crystalized"].Text = tostring(SessionStats.Crystalized) end
    if UI_StatsLabels["CaveCrystal"] then UI_StatsLabels["CaveCrystal"].Text = tostring(SessionStats.CaveCrystal) end
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
    pcall(function() httpRequest({ Url = TargetURL, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode(embedData) }) end)
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
                if string.find(check, v) then isAllowed = true break end
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
                local embed = {
                    ["username"] = "NikeeHUB",
                    ["avatar_url"] = "https://i.imgur.com/CWWGnhO.jpeg",
                    ["content"] = adminTags ~= "" and "⚠️ " .. adminTags or "",
                    ["embeds"] = {{
                        ["title"] = "Foreign Player Detected",
                        ["description"] = "```\nPlayer: " .. p.Name .. "\nDisplay: " .. p.DisplayName .. "\n```",
                        ["color"] = 16711680,
                        ["footer"] = { ["text"] = "NikeeHUB Webhook" }
                    }}
                }
                pcall(function() httpRequest({ Url = Current_Webhook_Admin, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode(embed) }) end)
            end)
        end
    end
end))

-- High ping monitor
local LastPingAlert = 0
task.spawn(function()
    while ScriptActive do
        task.wait(5)
        if Settings.PingMonitor and ScriptActive then
            local success, ping = pcall(function() return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() end)
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
                        pcall(function() httpRequest({ Url = Current_Webhook_Admin, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode(embed) }) end)
                    end)
                end
            end
        end
    end
end)

-- Auto check non-PS players
task.spawn(function()
    while ScriptActive do
        task.wait(1800)
        if Settings.PlayerNonPSAuto and ScriptActive then
            -- Check and send non-PS players logic
        end
    end
end)

-- Cave crystal watcher
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

print("✅ NikeeHUB System Session v1.0 (SpeedHub UI) Loaded!")

-- Autoload config
task.delay(1, function()
    local autoPref = nil
    if isfile("Nikee_Configs/autoload.json") then
        local s, c = pcall(function() return readfile("Nikee_Configs/autoload.json") end)
        if s then
            local s2, d = pcall(function() return HttpService:JSONDecode(c) end)
            if s2 and d then autoPref = d end
        end
    end
    if autoPref and autoPref.enabled and autoPref.config then
        print("🔄 Autoloading Config: " .. autoPref.config)
        LoadConfig(autoPref.config)
    end
end)
