-- ============================================
-- NikeeHUB - FishIt Script (SpeedHub UI Version)
-- Menggunakan SpeedHub UI Library sepenuhnya
-- ============================================

-- Load SpeedHub UI Library
local SpeedHubUI = nil

-- Coba berbagai cara untuk load library
if isfile("SpeedHubUI") then
    SpeedHubUI = loadstring(readfile("SpeedHubUI"))()
elseif isfile("SpeedHubUI.lua") then
    SpeedHubUI = loadstring(readfile("SpeedHubUI.lua"))()
end

if not SpeedHubUI then
    warn("SpeedHubUI library not found!")
    -- Fallback: embed library langsung
    SpeedHubUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/NikeeTXC/adbae/refs/heads/main/SpeedHubUI"))()
end

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
local Window = SpeedHubUI:Window({
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

local ConfigNameInput = nil
local selectedConfig = nil

Section_Save:AddInput({
    Title = "Config Name",
    Content = "Enter a name for your config",
    Default = "",
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

print("✅ NikeeHUB System Session v1.0 Loaded! (SpeedHub UI)")
