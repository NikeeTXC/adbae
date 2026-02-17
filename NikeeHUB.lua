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
local ProtectGui = protectgui or (syn and syn.protect_gui) or (gethui and function(g) g.Parent = gethui() end) or function(g) g.Parent = CoreGui end
local FishingController = require(ReplicatedStorage.Controllers.FishingController)

-- Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Variables
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

-- Helper Functions
local function ShowNotification(msg, isError)
    if not ScriptActive then return end
    Fluent:Notify({
        Title = isError and "Error" or "Info",
        Content = msg,
        Duration = 3,
        Image = isError and "rbxassetid://6031288087" or "rbxassetid://6031071759"
    })
end

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

local FishingAreas = {
    ["Leviathan Den"] = {Pos = Vector3.new(3431.640, -287.726, 3529.052), Look = Vector3.new(-0.176, 0.444, -0.879)},
    ["Crystal Depths"] = {Pos = Vector3.new(5820.647, -907.482, 15425.794), Look = Vector3.new(0.131, -0.666, 0.735)},
    ["Pirate Cove"] = {Pos = Vector3.new(3479.794, 4.192, 3451.693), Look = Vector3.new(0.578, -0.396, -0.713)},
    ["Pirate Tresure"] = {Pos = Vector3.new(3305.745, -302.160, 3028.795), Look = Vector3.new(-0.331, -0.396, -0.856)},
    ["Maze Door Room"] = {Pos = Vector3.new(3446.691, -287.845, 3402.136), Look = Vector3.new(0.324, -0.396, 0.859)},
    ["Ancient Jungle"] = {Pos = Vector3.new(1535.639, 3.159, -193.352), Look = Vector3.new(0.505, 0.000, 0.863)},
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
    print("XAL: Anti-AFK Active")
end)

-- Auto Execute on Teleport
task.spawn(function()
    local queueTeleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
    if queueTeleport then
        local TpService = game:GetService("TeleportService")
        TpService.TeleportInit:Connect(function()
            if Settings.AutoExecute then
                print("XAL: Queuing Auto Execute...")
                pcall(function()
                    queueTeleport([[
                        task.wait(5)
                        local paths = {"XAL CLOUD/FishIt/47.lua", "47.lua", "FishIt/47.lua"}
                        local scriptCode = nil
                        for _, p in ipairs(paths) do
                            local s, c = pcall(function() return readfile(p) end)
                            if s and c then scriptCode = c; break end
                        end
                        if scriptCode then loadstring(scriptCode)() end
                    ]])
                end)
            end
        end)
    end
end)

-- Create Fluent Window
local Window = Fluent:CreateWindow({
    Title = "ITG Webhook",
    SubTitle = "Fish It Script",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Controller = "PeekBoo",
    Theme = "Dark"
})

-- Create Tabs
local Tabs = {
    ServerInfo = Window:AddTab({ Title = "Server Info", Icon = "server", IconColor = Color3.fromRGB(255, 255, 255) }),
    Fhising = Window:AddTab({ Title = "Fhising", Icon = "fishing", IconColor = Color3.fromRGB(255, 255, 255) }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "globe", IconColor = Color3.fromRGB(255, 255, 255) }),
    Notification = Window:AddTab({ Title = "Notification", Icon = "bell", IconColor = Color3.fromRGB(255, 255, 255) }),
    AdminBoost = Window:AddTab({ Title = "Admin Boost", Icon = "user", IconColor = Color3.fromRGB(255, 255, 255) }),
    ListPlayer = Window:AddTab({ Title = "List Player", Icon = "users", IconColor = Color3.fromRGB(255, 255, 255) }),
    Setting = Window:AddTab({ Title = "Setting", Icon = "settings", IconColor = Color3.fromRGB(255, 255, 255) }),
    SaveConfig = Window:AddTab({ Title = "Save Config", Icon = "save", IconColor = Color3.fromRGB(255, 255, 255) })
}

-- Server Info Tab
local ServerInfoSection = Tabs.ServerInfo:AddSection("Session Statistics")

local StatsLabels = {}
local statOrder = {"Secret", "Ruby", "Evolved", "Crystalized", "CaveCrystal", "TotalSent"}
local statNames = {
    Secret = "Secret Fish",
    Ruby = "Ruby Gemstone", 
    Evolved = "Evolved Enchant",
    Crystalized = "Mutation Crystal",
    CaveCrystal = "Cave Crystal",
    TotalSent = "Total Webhooks"
}

for _, statKey in ipairs(statOrder) do
    StatsLabels[statKey] = ServerInfoSection:AddLabel(statNames[statKey] .. ": 0")
end

local ServerTitleVar = "XALSCENT"
ServerInfoSection:AddInput("ServerTitleInput", {Text = "Server Title", Default = ServerTitleVar, Callback = function(v) ServerTitleVar = v end})

ServerInfoSection:AddButton("Send Stats to Admin Webhook", function()
    if not ScriptActive then return end
    if Current_Webhook_Admin == "" then ShowNotification("Admin Webhook Empty!", true) return end
    ShowNotification("Sending Stats...", false)

    local diff = tick() - SessionStart
    local h = math.floor(diff / 3600)
    local m = math.floor((diff % 3600) / 60)
    local s = math.floor(diff % 60)
    local timeStr = string.format("%02dh %02dm %02ds", h, m, s)

    local contentStr = "📊 SERVER: " .. ServerTitleVar .. "\n"
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
                ["footer"] = { ["text"] = "ITG Webhook", ["icon_url"] = "https://i.imgur.com/sblcM31.jpeg" }
            }}
        }
        httpRequest({ Url = Current_Webhook_Admin, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode(embed) })
    end)
end)

-- Uptime display update
task.spawn(function()
    while ScriptActive do
        task.wait(1)
        local diff = tick() - SessionStart
        local h = math.floor(diff / 3600)
        local m = math.floor((diff % 3600) / 60)
        local s = math.floor(diff % 60)
        -- Update a label if we had one
    end
end)

-- Fhising Tab
local FhisingSection = Tabs.Fhising:AddSection("Fishing Automation")

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

local DetectorStuckEnabled = false
local StuckThreshold = 15
local LastFishCount = 0
local StuckTimer = 0
local SavedCFrame = nil

FhisingSection:AddToggle("DetectorStuck", {Text = "Detector Stuck (15s)", Default = false, Callback = function(state)
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
                    end
                else
                    LastFishCount = currentFish
                    StuckTimer = 0
                end
            end
        end)
    end
end}})

local AutoShakeEnabled = false
FhisingSection:AddToggle("AutoShake", {Text = "Auto Click Fishing", Default = false, Callback = function(val)
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
end}})

local AutoSellEnabled = false
local SellValue = 600

FhisingSection:AddToggle("AutoSell", {Text = "Auto Sell (10m / 600 Items)", Default = false, Callback = function(state)
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
end}})

local WeatherList = { "Wind", "Cloudy", "Storm" }
local SimpleWeatherEnabled = false

FhisingSection:AddToggle("AutoWeather", {Text = "Enable Auto Buy Weather", Default = false, Callback = function(state)
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
end}})

local TotemList = {"Luck Totem", "Mutation Totem", "Shiny Totem"}
local SelectedTotem = "Luck Totem"
local TotemMap = {["Luck Totem"]=1, ["Mutation Totem"]=2, ["Shiny Totem"]=3}

FhisingSection:AddDropdown("SelectTotem", {Text = "Select Totem", Values = TotemList, Default = "Luck Totem", Callback = function(v) SelectedTotem = v end})

FhisingSection:AddToggle("AutoTotem", {Text = "Enable Auto Spawn Totem", Default = false, Callback = function(state)
    if state then
        local RE_Spawn = GetRemote("RE/SpawnTotem")
        local RE_Equip = GetRemote("RE/EquipToolFromHotbar")
        if not RE_Spawn then ShowNotification("Remote Totem Missing!", true) return end
        task.spawn(function()
            while ScriptActive do
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
                    ShowNotification("Totem UUID Not Found!", true)
                    task.wait(5)
                end
            end
        end)
    end
end}})

-- Teleport Tab
local TeleportSection = Tabs.Teleport:AddSection("Teleport to Fishing Areas")

local sortedAreas = {}
for name, _ in pairs(FishingAreas) do table.insert(sortedAreas, name) end
table.sort(sortedAreas)

for _, name in ipairs(sortedAreas) do
    local data = FishingAreas[name]
    TeleportSection:AddButton(name, function()
        TeleportToLookAt(data.Pos, data.Look)
    end)
end

-- Notification Tab
local NotificationSection = Tabs.Notification:AddSection("Webhook Notifications")

NotificationSection:AddToggle("SecretEnabled", {Text = "Secret Fish Caught", Default = false, Callback = function(v) Settings.SecretEnabled = v end})
NotificationSection:AddToggle("RubyEnabled", {Text = "Ruby Gemstone", Default = false, Callback = function(v) Settings.RubyEnabled = v end})
NotificationSection:AddToggle("CaveCrystalEnabled", {Text = "Notif Cave Crystal", Default = false, Callback = function(v) Settings.CaveCrystalEnabled = v end})
NotificationSection:AddToggle("EvolvedEnabled", {Text = "Evolved Enchant Stone", Default = false, Callback = function(v) Settings.EvolvedEnabled = v end})
NotificationSection:AddToggle("MutationCrystalized", {Text = "Mutation Crystalized (Legendary)", Default = false, Callback = function(v) Settings.MutationCrystalized = v end})

-- Webhook URLs Section
local WebhookSection = Tabs.Notification:AddSection("Webhook URLs")

WebhookSection:AddInput("FishWebhook", {Text = "Fish Webhook URL", Placeholder = "Paste webhook URL here...", Callback = function(text) Current_Webhook_Fish = text end})
WebhookSection:AddInput("LeaveWebhook", {Text = "Leave Webhook URL", Placeholder = "Paste webhook URL here...", Callback = function(text) Current_Webhook_Leave = text end})
WebhookSection:AddInput("ListWebhook", {Text = "Player List Webhook URL", Placeholder = "Paste webhook URL here...", Callback = function(text) Current_Webhook_List = text end})
WebhookSection:AddInput("AdminWebhook", {Text = "Admin Webhook URL", Placeholder = "Paste webhook URL here...", Callback = function(text) Current_Webhook_Admin = text end})

local function TestWebhook(url, name)
    if not ScriptActive then return end
    if url == "" then ShowNotification("URL Empty!", true) return end
    ShowNotification("Sending Test...", false)
    task.spawn(function()
        local p = { content = "✅ **TEST:** " .. name .. " Connected!", username = "ITG", avatar_url = "https://i.imgur.com/sblcM31.jpeg" }
        local success, response = pcall(function()
            return httpRequest({ Url = url, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode(p) })
        end)
        if success and response then
            local status = response.StatusCode or "Unknown"
            if status and (status < 200 or status >= 300) then
                ShowNotification("Failed: " .. status, true)
            else
                ShowNotification("Success: " .. status, false)
            end
        else
            ShowNotification("Request Error!", true)
        end
    end)
end

WebhookSection:AddButton("Test All Connections", function()
    local c = 0
    if Current_Webhook_Fish ~= "" then TestWebhook(Current_Webhook_Fish, "Fish"); c=c+1 end
    if Current_Webhook_Leave ~= "" then TestWebhook(Current_Webhook_Leave, "Leave"); c=c+1 end
    if Current_Webhook_List ~= "" then TestWebhook(Current_Webhook_List, "List"); c=c+1 end
    if Current_Webhook_Admin ~= "" then TestWebhook(Current_Webhook_Admin, "Admin"); c=c+1 end
    if c == 0 then ShowNotification("No webhooks to test!", true) end
end)

-- Admin Boost Tab
local AdminBoostSection = Tabs.AdminBoost:AddSection("Admin Boost Settings")

AdminBoostSection:AddInput("AdminID1", {Text = "Host 1 Discord ID", Placeholder = "Discord User ID", Callback = function(v) AdminID_1 = v end})
AdminBoostSection:AddInput("AdminID2", {Text = "Host 2 Discord ID", Placeholder = "Discord User ID", Callback = function(v) AdminID_2 = v end})
AdminBoostSection:AddToggle("ForeignDetection", {Text = "Deteksi Player Asing", Default = false, Callback = function(v) Settings.ForeignDetection = v end})
AdminBoostSection:AddToggle("SpoilerName", {Text = "Hide Player Name (Spoiler)", Default = true, Callback = function(v) Settings.SpoilerName = v end})
AdminBoostSection:AddToggle("PingMonitor", {Text = "Lag Detector (Ping > 500ms)", Default = false, Callback = function(v) Settings.PingMonitor = v end})
AdminBoostSection:AddToggle("LeaveEnabled", {Text = "Player Leave Server", Default = false, Callback = function(v) Settings.LeaveEnabled = v end})
AdminBoostSection:AddToggle("PlayerNonPSAuto", {Text = "Player Not On Server (30 min)", Default = false, Callback = function(v) Settings.PlayerNonPSAuto = v end})

-- Ping Monitor
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
                            ["username"] = "ITG Security",
                            ["avatar_url"] = "https://i.imgur.com/sblcM31.jpeg",
                            ["content"] = "⚠️ **HIGH PING DETECTED!**",
                            ["embeds"] = {{
                                ["title"] = "Server Lag Alert",
                                ["description"] = "```\nCurrent Ping: " .. math.floor(ping) .. " ms\n```",
                                ["color"] = 16776960,
                                ["footer"] = { ["text"] = "ITG Webhook", ["icon_url"] = "https://i.imgur.com/sblcM31.jpeg" }
                            }}
                        }
                        pcall(function() httpRequest({ Url = Current_Webhook_Admin, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode(embed) }) end)
                    end)
                end
            end
        end
    end
end)

-- Player Not On Server Check
local function CheckAndSendNonPS(isManual)
    if not ScriptActive then return end
    if Current_Webhook_List == "" then
        if isManual then ShowNotification("Webhook Missing!", true) end
        return
    end
    if isManual then ShowNotification("Checking Players...", false) end

    local current = {}
    for _, p in ipairs(Players:GetPlayers()) do current[string.lower(p.Name)] = true end
    local missingNames = {}; local missingTags = {}
    for i = 1, 20 do
        local name = TagList[i][1]; local discId = TagList[i][2]
        if name ~= "" and not current[string.lower(name)] then
            table.insert(missingNames, name)
            if discId and discId ~= "" then table.insert(missingTags, "<@" .. discId .. ">") end
        end
    end

    if not isManual and #missingNames == 0 then return end

    local txt = "Missing Players (" .. #missingNames .. "):\n\n"
    if #missingNames == 0 then txt = "All tagged players are in the server!" else for i, v in ipairs(missingNames) do txt = txt .. i .. ". " .. v .. "\n" end end

    local contentMsg = ""
    if #missingTags > 0 then contentMsg = " **Peringatan:** " .. table.concat(missingTags, " ") .. " belum masuk server!" end

    task.spawn(function()
        local p = { ["username"] = "ITG", ["avatar_url"] = "https://i.imgur.com/sblcM31.jpeg", ["content"] = contentMsg, ["embeds"] = {{ ["title"] = "Player Not On Server", ["description"] = "```\n" .. txt .. "\n```", ["color"] = 16733440, ["footer"] = { ["text"] = "ITG Webhook", ["icon_url"] = "https://i.imgur.com/sblcM31.jpeg" } }} }
        httpRequest({ Url = Current_Webhook_List, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode(p) })
    end)
end

AdminBoostSection:AddButton("Player On Server", function()
    if not ScriptActive then return end
    if Current_Webhook_List == "" then ShowNotification("Webhook Missing!", true) return end
    ShowNotification("Sending List...", false)
    local all = Players:GetPlayers(); local str = "Current Players (" .. #all .. "):\n\n"
    for i, p in ipairs(all) do str = str .. i .. ". " .. p.DisplayName .. " (@" .. p.Name .. ")\n" end
    task.spawn(function()
        local p = { ["username"] = "ITG", ["avatar_url"] = "https://i.imgur.com/sblcM31.jpeg", ["embeds"] = {{ ["title"] = "Manual Player List", ["description"] = "```\n" .. str .. "\n```", ["color"] = 5763719, ["footer"] = { ["text"] = "ITG Webhook", ["icon_url"] = "https://i.imgur.com/sblcM31.jpeg" } }} }
        httpRequest({ Url = Current_Webhook_List, Method = "POST", Headers = {["Content-Type"]="application/json"}, Body = HttpService:JSONEncode(p) })
    end)
end)

AdminBoostSection:AddButton("Player NOT On Server", function()
    if Current_Webhook_List == "" then ShowNotification("Webhook Player List Empty!", true) return end
    CheckAndSendNonPS(true)
end)

task.spawn(function()
    while ScriptActive do
        task.wait(1800)
        if Settings.PlayerNonPSAuto and ScriptActive then
            CheckAndSendNonPS(false)
        end
    end
end)

-- List Player Tab
local ListPlayerSection = Tabs.ListPlayer:AddSection("Player Tag List")

ListPlayerSection:AddInput("BulkImport", {Text = "Bulk Import (User:DiscordID per line)", Placeholder = "Username:DiscordID\nUsername:DiscordID", MultiLine = true})

ListPlayerSection:AddButton("Import Bulk Data", function()
    local BulkInput = Window:GetElement("BulkImport")
    local text = BulkInput and BulkInput.Value or ""
    local addedCount = 0
    local currentIndex = 3

    while currentIndex <= 20 and TagList[currentIndex][1] ~= "" do currentIndex = currentIndex + 1 end
    if currentIndex > 20 then ShowNotification("List Player Full!", true) return end

    local maxImport = 18
    local processed = 0

    for line in text:gmatch("[^\r\n]+") do
        if currentIndex > 20 or processed >= maxImport then break end
        local split = string.split(line, ":")
        local user = split[1] or ""
        local id = split[2] or ""
        user = user:match("^%s*(.-)%s*$")
        id = id:match("^%s*(.-)%s*$")
        if user ~= "" then
            TagList[currentIndex] = {user, id}
            currentIndex = currentIndex + 1
            addedCount = addedCount + 1
            processed = processed + 1
        end
    end
    if addedCount > 0 then
        if BulkInput then BulkInput:SetValue("") end
        ShowNotification("Imported " .. addedCount .. " Players!")
    else
        ShowNotification("No Data Found!", true)
    end
end)

for i = 1, 20 do
    local labelText = "List " .. i .. ":"
    if i == 1 then labelText = "Host 1:" end
    if i == 2 then labelText = "Host 2:" end

    ListPlayerSection:AddInput("User" .. i, {Text = labelText, Placeholder = "Username", Default = TagList[i][1], Callback = function(v) TagList[i][1] = v end})
    ListPlayerSection:AddInput("ID" .. i, {Text = "Discord ID", Placeholder = "Discord ID (Optional)", Default = TagList[i][2], Callback = function(v) TagList[i][2] = v end})
end

-- Setting Tab
local SettingSection = Tabs.Setting:AddSection("Script Settings")

local WalkOnWaterEnabled = false
local WaterPlatform = nil
local WalkConnection = nil

SettingSection:AddToggle("WalkOnWater", {Text = "Walk On Water", Default = false, Callback = function(state)
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
            if not ScriptActive then return end
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
end}})

SettingSection:AddToggle("DisablePopups", {Text = "Remove Fish Notification Pop-up", Default = false, Callback = function(state)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local SmallNotification = PlayerGui:FindFirstChild("Small Notification")
    if not SmallNotification then SmallNotification = PlayerGui:WaitForChild("Small Notification", 5) end
    if state then
        if SmallNotification then
            local conn = RunService.RenderStepped:Connect(function()
                if not ScriptActive then conn:Disconnect() return end
                SmallNotification.Enabled = false
            end)
            ShowNotification("Pop-up Blocked", false)
        end
    else
        if SmallNotification then SmallNotification.Enabled = true end
        ShowNotification("Pop-up Enabled", false)
    end
end}})

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

SettingSection:AddToggle("NoAnimation", {Text = "No Animation", Default = false, Callback = function(state)
    isNoAnimationActive = state
    if state then
        DisableAnimations()
        ShowNotification("No Animation ON", false)
    else
        EnableAnimations()
        ShowNotification("No Animation OFF", false)
    end
end}})

local VFXControllerModule = require(ReplicatedStorage.Controllers.VFXController)
local originalVFXHandle = VFXControllerModule.Handle

SettingSection:AddToggle("RemoveVFX", {Text = "Remove Skin Effect", Default = false, Callback = function(state)
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
end}})

SettingSection:AddToggle("AutoExecute", {Text = "Auto Execute on Server Hop", Default = false, Callback = function(v) Settings.AutoExecute = v end})

-- Save Config Tab
local SaveConfigSection = Tabs.SaveConfig:AddSection("Configuration Management")

SaveConfigSection:AddInput("ConfigName", {Text = "Config Name", Placeholder = "Enter config name..."})

SaveConfigSection:AddButton("Save Config", function()
    local ConfigInput = Window:GetElement("ConfigName")
    local name = ConfigInput and ConfigInput.Value or ""
    if name == "" then ShowNotification("Name cannot be empty!", true) return end

    local validKeys = {
        "SecretEnabled", "RubyEnabled", "MutationCrystalized", "CaveCrystalEnabled",
        "LeaveEnabled", "PlayerNonPSAuto", "ForeignDetection", "SpoilerName",
        "PingMonitor", "AutoExecute", "NoAnimation", "RemoveVFX", "DisablePopups",
        "EvolvedEnabled"
    }

    local cleanSettings = {}
    for _, key in ipairs(validKeys) do
        if Settings[key] ~= nil then cleanSettings[key] = Settings[key] end
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

    local saveData = {Webhooks = cleanWebhooks, Players = cleanPlayers, Settings = cleanSettings}
    local jsonSuccess, encodedData = pcall(function() return HttpService:JSONEncode(saveData) end)
    if not jsonSuccess then
        ShowNotification("Encoding Error: " .. tostring(encodedData), true)
        return
    end

    local success, err = pcall(function()
        if not isfolder("XAL_Configs") then makefolder("XAL_Configs") end
        writefile("XAL_Configs/" .. name .. ".json", encodedData)
    end)

    if success then
        ShowNotification("Config Saved!", false)
        RefreshConfigList()
    else
        ShowNotification("Write Error: " .. tostring(err), true)
    end
end})

local LoadDropdown = SaveConfigSection:AddDropdown("LoadConfig", {Text = "Load Config", Values = {}})

local function RefreshConfigList()
    local files = {}
    local success, allFiles = pcall(function() return listfiles("XAL_Configs") end)
    if success and allFiles then
        for _, file in pairs(allFiles) do
            local name = file:match("([^/\\]+)$") or file
            name = name:gsub("%.json$", "")
            if name ~= "autoload" then table.insert(files, name) end
        end
    end
    if LoadDropdown then LoadDropdown:SetValues(files) end
end

RefreshConfigList()

if LoadDropdown then
    LoadDropdown:SetCallback(function(v)
        if v and v ~= "" then
            local success, content = pcall(function() return readfile("XAL_Configs/" .. v .. ".json") end)
            if not success then ShowNotification("Read Failed!", true) return end
            local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(content) end)
            if decodeSuccess and data then
                if data.Webhooks then
                    Current_Webhook_Fish = data.Webhooks.Fish or ""
                    Current_Webhook_Leave = data.Webhooks.Leave or ""
                    Current_Webhook_List = data.Webhooks.List or ""
                    Current_Webhook_Admin = data.Webhooks.Admin or ""
                    -- Update inputs
                    local fishIn = Window:GetElement("FishWebhook")
                    local leaveIn = Window:GetElement("LeaveWebhook")
                    local listIn = Window:GetElement("ListWebhook")
                    local adminIn = Window:GetElement("AdminWebhook")
                    if fishIn then fishIn:SetValue(Current_Webhook_Fish) end
                    if leaveIn then leaveIn:SetValue(Current_Webhook_Leave) end
                    if listIn then listIn:SetValue(Current_Webhook_List) end
                    if adminIn then adminIn:SetValue(Current_Webhook_Admin) end
                end
                if data.Players then
                    TagList = data.Players
                    for i = 1, 20 do
                        if not TagList[i] or type(TagList[i]) ~= "table" then TagList[i] = {"", ""} end
                    end
                end
                if data.Settings then
                    for k, val in pairs(data.Settings) do
                        if Settings[k] ~= nil then Settings[k] = val end
                    end
                end
                ShowNotification("Config Loaded!", false)
            else
                ShowNotification("JSON Error!", true)
            end
        end
    end)
end

SaveConfigSection:AddButton("Delete Config", function()
    local LoadDropdown2 = Window:GetElement("LoadConfig")
    local selected = LoadDropdown2 and LoadDropdown2.Value or ""
    if not selected or selected == "" then ShowNotification("Select a config!", true) return end
    delfile("XAL_Configs/" .. selected .. ".json")
    ShowNotification("Deleted!", false)
    RefreshConfigList()
end})

local AutoLoadToggle = SaveConfigSection:AddToggle("AutoLoad", {Text = "Enable Auto Load", Default = false, Callback = function(state)
    local LoadDropdown3 = Window:GetElement("LoadConfig")
    local selected = LoadDropdown3 and LoadDropdown3.Value or ""
    if not selected or selected == "" then
        ShowNotification("Select a config first!", true)
        if AutoLoadToggle then AutoLoadToggle:SetValue(false) end
        return
    end
    local data = { config = selected, enabled = state }
    writefile("XAL_Configs/autoload.json", HttpService:JSONEncode(data))
    ShowNotification(state and "Autoload Set: " .. selected or "Autoload Disabled", false)
end})

-- Auto-load config on start
task.spawn(function()
    task.wait(2)
    if isfile("XAL_Configs/autoload.json") then
        local s, c = pcall(function() return readfile("XAL_Configs/autoload.json") end)
        if s then
            local s2, d = pcall(function() return HttpService:JSONDecode(c) end)
            if s2 and d and d.enabled and d.config then
                local success, content = pcall(function() return readfile("XAL_Configs/" .. d.config .. ".json") end)
                if success then
                    local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(content) end)
                    if decodeSuccess and data then
                        if data.Webhooks then
                            Current_Webhook_Fish = data.Webhooks.Fish or ""
                            Current_Webhook_Leave = data.Webhooks.Leave or ""
                            Current_Webhook_List = data.Webhooks.List or ""
                            Current_Webhook_Admin = data.Webhooks.Admin or ""
                        end
                        if data.Players then TagList = data.Players end
                        if data.Settings then
                            for k, v in pairs(data.Settings) do
                                if Settings[k] ~= nil then Settings[k] = v end
                            end
                        end
                        Fluent:Notify({Title = "Auto Load", Content = "Config loaded: " .. d.config, Duration = 3})
                    end
                end
            end
        end
    end
end)

-- Helper function for remote
local RPath = {"Packages", "_Index", "sleitnick_net@0.2.0", "net"}
local function GetRemote(name)
    local curr = ReplicatedStorage
    for _, child in ipairs(RPath) do
        curr = curr:WaitForChild(child, 1)
        if not curr then return nil end
    end
    return curr:FindFirstChild(name)
end

-- Webhook Send Functions
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
        local mutation = nil; local finalItem = f; local lowerFullItem = string.lower(f)
        local allTargets = {}
        for _, v in pairs(SecretList) do table.insert(allTargets, v) end
        for _, v in pairs(StoneList) do table.insert(allTargets, v) end
        table.insert(allTargets, "Evolved Enchant Stone")

        for _, baseName in pairs(allTargets) do
            if string.find(lowerFullItem, string.lower(baseName) .. "$") then
                local s, e = string.find(lowerFullItem, string.lower(baseName) .. "$")
                if s > 1 then
                    local prefixRaw = string.sub(f, 1, s - 1); local checkMut = prefixRaw
                    checkMut = string.gsub(checkMut, "Big%s*", ""); checkMut = string.gsub(checkMut, "Shiny%s*", "")
                    checkMut = string.gsub(checkMut, "Sparkling%s*", ""); checkMut = string.gsub(checkMut, "Giant%s*", "")
                    checkMut = string.gsub(checkMut, "^%s*(.-)%s*$", "%1")
                    if checkMut == "" then mutation = nil; finalItem = f
                    else mutation = checkMut; finalItem = string.gsub(f, prefixRaw, ""); finalItem = string.gsub(finalItem, "^%s*(.-)%s*$", "%1") end
                else mutation = nil; finalItem = f end
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

    local TargetURL = ""; local contentMsg = ""; local realUser = GetUsername(data.Player)
    local discordId = nil
    for i = 1, 20 do if TagList[i][1] ~= "" and string.lower(TagList[i][1]) == string.lower(realUser) then discordId = TagList[i][2]; break end end
    if discordId and discordId ~= "" then
        if category == "LEAVE" then contentMsg = "User Left: <@" .. discordId .. ">" else contentMsg = "GG! <@" .. discordId .. ">" end
    end
    if category == "LEAVE" then TargetURL = Current_Webhook_Leave elseif category == "PLAYERS" then TargetURL = Current_Webhook_List else TargetURL = Current_Webhook_Fish end
    if not TargetURL or TargetURL == "" or string.find(TargetURL, "MASUKKAN_URL") then return end

    local embedTitle = ""; local embedColor = 3447003; local descriptionText = ""
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

    -- Update UI stats
    for key, val in pairs(SessionStats) do
        if StatsLabels[key] then
            StatsLabels[key].Text = statNames[key] .. ": " .. tostring(val)
        end
    end

    local embedData = {
        ["username"] = "ITG",
        ["avatar_url"] = "https://i.imgur.com/sblcM31.jpeg",
        ["content"] = contentMsg,
        ["embeds"] = {{
            ["title"] = embedTitle,
            ["description"] = descriptionText,
            ["color"] = embedColor,
            ["footer"] = { ["text"] = "ITG Webhook", ["icon_url"] = "https://i.imgur.com/sblcM31.jpeg" }
        }}
    }
    pcall(function() httpRequest({ Url = TargetURL, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode(embedData) }) end)
end

local function CheckAndSend(msg)
    if not ScriptActive then return end
    local cleanMsg = StripTags(msg); local lowerMsg = string.lower(cleanMsg)

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
            for _, v in ipairs(allowed) do if string.find(check, v) then isAllowed = true; break end end
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
                        if data.Mutation and string.find(string.lower(data.Mutation), "gemstone") then SendWebhook(data, "STONE") end
                    else SendWebhook(data, "STONE") end
                    return
                end
            end
            for _, name in pairs(SecretList) do if string.find(string.lower(data.Item), string.lower(name)) then SendWebhook(data, "SECRET") return end end
        end
    end
end

-- Chat listeners
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

-- Player leave/join
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
                    ["username"] = "ITG Security",
                    ["avatar_url"] = "https://i.imgur.com/sblcM31.jpeg",
                    ["content"] = contentStr,
                    ["embeds"] = {{
                        ["title"] = "Player Information",
                        ["description"] = "```\nName: " .. p.DisplayName .. "\nUsername: " .. p.Name .. "\n```",
                        ["color"] = 16711680,
                        ["footer"] = { ["text"] = "ITG Webhook", ["icon_url"] = "https://i.imgur.com/sblcM31.jpeg" }
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

-- Disconnect and Rejoin
local targetPlaceId = game.PlaceId
local targetJobId = game.JobId

local function FastInfiniteRejoin()
    if not ScriptActive then return end
    print("🔄 ITG: Mencoba reconnect setiap 5 detik...")
    while ScriptActive do
        local success, err = pcall(function() TeleportService:TeleportToPlaceInstance(targetPlaceId, targetJobId, game.Players.LocalPlayer) end)
        if success then print("✅ ITG: Perintah reconnect berhasil dikirim!") break else warn("⚠️ ITG: Gagal, mencoba lagi dalam 5 detik...") end
        task.wait(5)
    end
end

local function SendDisconnectWebhook(reason)
    if not ScriptActive then return end
    if Current_Webhook_List == "" then return end
    if tick() - LastDisconnectTime < 30 then
        print("⚠️ ITG: Disconnect Webhook Cooldown Active")
        return
    end
    LastDisconnectTime = tick()
    print("⚠️ ITG: Sending Disconnect Webhook (Reason: " .. tostring(reason) .. ")")

    local adminTags = ""
    local id1 = (TagList[1] and TagList[1][2]) or ""
    local id2 = (TagList[2] and TagList[2][2]) or ""
    if id1 ~= "" then adminTags = adminTags .. "<@" .. id1 .. "> " end
    if id2 ~= "" then adminTags = adminTags .. "<@" .. id2 .. "> " end

    local contentMsg = ""
    if adminTags ~= "" then contentMsg = "**DISCONNECT ALERT:** " .. adminTags end

    local embed = {
        ["username"] = "ITG",
        ["avatar_url"] = "https://i.imgur.com/sblcM31.jpeg",
        ["content"] = contentMsg,
        ["embeds"] = {{
            ["title"] = "LocalPlayer Disconnected",
            ["description"] = "Information\nUser: **" .. Players.LocalPlayer.Name .. "** (@" .. Players.LocalPlayer.DisplayName .. ") has disconnected.\n**Reason:** " .. tostring(reason),
            ["color"] = 16711680,
            ["footer"] = { ["text"] = "ITG Webhook", ["icon_url"] = "https://i.imgur.com/sblcM31.jpeg" }
        }}
    }
    pcall(function()
        httpRequest({
            Url = Current_Webhook_List,
            Method = "POST",
            Headers = {["Content-Type"]="application/json"},
            Body = HttpService:JSONEncode(embed)
        })
    end)
end

table.insert(Connections, GuiService.ErrorMessageChanged:Connect(function(errMsg)
    if not ScriptActive then return end
    if errMsg and errMsg ~= "" then
        SendDisconnectWebhook("Error Message: " .. errMsg)
    end
    task.wait(2); FastInfiniteRejoin()
end))

local promptOverlay = game:GetService("CoreGui"):WaitForChild("RobloxPromptGui", 5)
if promptOverlay then
    promptOverlay = promptOverlay:WaitForChild("promptOverlay", 5)
end

if promptOverlay then
    table.insert(Connections, promptOverlay.ChildAdded:Connect(function(child)
        if not ScriptActive then return end
        if child.Name == "ErrorPrompt" then
            SendDisconnectWebhook("Error Prompt Detected")
            task.wait(2); FastInfiniteRejoin()
        end
    end))
end

game:BindToClose(function()
    SendDisconnectWebhook("Script/Game Closed Gracefully")
    task.wait(1)
end)

-- Cave Crystal Watcher
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

-- Show window
Window:SelectTab(1)

print("ITG: Script Loaded Successfully!")
