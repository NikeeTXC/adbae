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
local SafeName = "RobloxReplicatedService"
local ProtectGui = protectgui or (syn and syn.protect_gui) or (gethui and function(g) g.Parent = gethui() end) or function(g) g.Parent = CoreGui end
local FishingController = require(ReplicatedStorage.Controllers.FishingController)

-- Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

task.spawn(function()
    while ScriptActive do
        task.wait(5)
        local success, err = pcall(function()
            local core = game:GetService("CoreGui")
            if core:FindFirstChild("DarkDetex") or core:FindFirstChild("RemoteSpy") or core:FindFirstChild("TurtleSpy") then

            end
        end)
    end
end)

if getgenv and getgenv().XAL_Stop then
    pcall(getgenv().XAL_Stop)
end

local function CleanupScript()
    ScriptActive = false
    for _, v in pairs(Connections) do
        pcall(function() v:Disconnect() end)
    end
    Connections = {}

    if TextChatService then
        TextChatService.OnIncomingMessage = nil
    end

    print("❌ XAL System: Script closed and cleanup complete.")
    if getgenv then getgenv().XAL_Stop = nil end
end

if getgenv then
    getgenv().XAL_Stop = CleanupScript
end

if not isfolder("XAL_Configs") then
    pcall(function() makefolder("XAL_Configs") end)
end

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

local function TeleportToLookAt(position, lookVector)
    local Character = Players.LocalPlayer.Character
    if not Character then Character = Players.LocalPlayer.CharacterAdded:Wait() end
    local hrp = Character:WaitForChild("HumanoidRootPart", 5)

    if hrp and typeof(position) == "Vector3" and typeof(lookVector) == "Vector3" then
        local targetCFrame = CFrame.new(position, position + lookVector)
        hrp.CFrame = targetCFrame * CFrame.new(0, 3, 0)
        Fluent:Notify({
            Title = "Teleport",
            Content = "Teleported successfully!",
            Duration = 3,
            Image = "rbxassetid://6031071759"
        })
    else
        Fluent:Notify({
            Title = "Error",
            Content = "Invalid TP Data",
            Duration = 3,
            Image = "rbxassetid://6031288087"
        })
    end
end

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
    print("XAL: Anti-AFK Active")
end)

task.spawn(function()
    local success, err = pcall(function()
        local queueTeleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)

        if queueTeleport then
            local TpService = game:GetService("TeleportService")
            local TeleportingConn = TpService.TeleportInit:Connect(function()
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

                            if scriptCode then
                                loadstring(scriptCode)()
                            else
                                warn("XAL AutoExecute: Could not find script file to execute!")
                            end
                        ]])
                    end)
                end
            end)
            table.insert(Connections, TeleportingConn)
        end
    end)
    if not success then warn("XAL: AutoExecute Not Supported: " .. tostring(err)) end
end)

local TagList = {}
local TagUIElements = {}

local SessionStart = tick()
local SessionStats = {
    Secret = 0,
    Ruby = 0,
    Evolved = 0,
    Crystalized = 0,
    CaveCrystal = 0,
    TotalSent = 0
}

local ShowNotification
function ShowNotification(msg, isError)
    if not ScriptActive then return end
    Fluent:Notify({
        Title = isError and "Error" else "Info",
        Content = msg,
        Duration = 3,
        Image = isError and "rbxassetid://6031288087" or "rbxassetid://6031071759"
    })
end

local TagData = {}
local function UpdateTagData()
    if #TagList == 0 then
        for i = 1, 20 do TagList[i] = {"", ""} end
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

UpdateTagData()

-- Create Fluent Window
local Window = Fluent:CreateWindow({
    Title = "ITG Webhook",
    SubTitle = "Fish It Script",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Controller = "PeekBoo",
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
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

-- Server Info Tab (Session Stats)
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

-- Fhising Tab
local FhisingSection = Tabs.Fhising:AddSection("Fishing Automation")

local DetectorStuckEnabled = false
local StuckThreshold = 15
local LastFishCount = 0
local StuckTimer = 0
local SavedCFrame = nil

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

FhisingSection:AddToggle("DetectorStuck", {Text = "Detector Stuck (15s)", Default = false}):OnChanged(function(state)
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
end)

local AutoShakeEnabled = false
FhisingSection:AddToggle("AutoShake", {Text = "Auto Click Fishing", Default = false}):OnChanged(function(val)
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
end)

local AutoSellEnabled = false
local SellMethod = "Count"
local SellValue = 600

FhisingSection:AddToggle("AutoSell", {Text = "Auto Sell (10m / 600 Items)", Default = false}):OnChanged(function(state)
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
end)

local WeatherList = { "Wind", "Cloudy", "Storm" }
local SimpleWeatherEnabled = false

FhisingSection:AddToggle("AutoWeather", {Text = "Enable Auto Buy Weather", Default = false}):OnChanged(function(state)
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
end)

local TotemList = {"Luck Totem", "Mutation Totem", "Shiny Totem"}
local SelectedTotem = "Luck Totem"
local TotemMap = {["Luck Totem"]=1, ["Mutation Totem"]=2, ["Shiny Totem"]=3}
local AutoTotemEnabled = false

FhisingSection:AddDropdown("SelectTotem", {Text = "Select Totem", Values = TotemList, Default = "Luck Totem"}):OnChanged(function(v)
    SelectedTotem = v
end)

FhisingSection:AddToggle("AutoTotem", {Text = "Enable Auto Spawn Totem", Default = false}):OnChanged(function(state)
    AutoTotemEnabled = state
    if state then
        local RE_Spawn = GetRemote("RE/SpawnTotem")
        local RE_Equip = GetRemote("RE/EquipToolFromHotbar")
        if not RE_Spawn then ShowNotification("Remote Totem Missing!", true) AutoTotemEnabled = false return end

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
                    ShowNotification("Totem UUID Not Found!", true)
                    task.wait(5)
                end
            end
        end)
    end
end)

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

NotificationSection:AddToggle("SecretEnabled", {Text = "Secret Fish Caught", Default = false}):OnChanged(function(v)
    Settings.SecretEnabled = v
end)

NotificationSection:AddToggle("RubyEnabled", {Text = "Ruby Gemstone", Default = false}):OnChanged(function(v)
    Settings.RubyEnabled = v
end)

NotificationSection:AddToggle("CaveCrystalEnabled", {Text = "Notif Cave Crystal", Default = false}):OnChanged(function(v)
    Settings.CaveCrystalEnabled = v
end)

NotificationSection:AddToggle("EvolvedEnabled", {Text = "Evolved Enchant Stone", Default = false}):OnChanged(function(v)
    Settings.EvolvedEnabled = v
end)

NotificationSection:AddToggle("MutationCrystalized", {Text = "Mutation Crystalized (Legendary)", Default = false}):OnChanged(function(v)
    Settings.MutationCrystalized = v
end)

-- Webhook URLs Section
local WebhookSection = Tabs.Notification:AddSection("Webhook URLs")

local FishInput = WebhookSection:AddInput("FishWebhook", {Text = "Fish Webhook URL", Placeholder = "Paste webhook URL here...", Numeric = false, Finished = false})
FishInput:OnChanged(function(text)
    Current_Webhook_Fish = text
end)

local LeaveInput = WebhookSection:AddInput("LeaveWebhook", {Text = "Leave Webhook URL", Placeholder = "Paste webhook URL here...", Numeric = false, Finished = false})
LeaveInput:OnChanged(function(text)
    Current_Webhook_Leave = text
end)

local ListInput = WebhookSection:AddInput("ListWebhook", {Text = "List Webhook URL", Placeholder = "Paste webhook URL here...", Numeric = false, Finished = false})
ListInput:OnChanged(function(text)
    Current_Webhook_List = text
end)

local AdminInput = WebhookSection:AddInput("AdminWebhook", {Text = "Admin Webhook URL", Placeholder = "Paste webhook URL here...", Numeric = false, Finished = false})
AdminInput:OnChanged(function(text)
    Current_Webhook_Admin = text
end)

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
            local body = response.Body or "No Body"

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

AdminBoostSection:AddInput("AdminID1", {Text = "Admin ID 1", Placeholder = "Discord User ID", Numeric = true, Finished = false}):OnChanged(function(v)
    AdminID_1 = v
end)

AdminBoostSection:AddInput("AdminID2", {Text = "Admin ID 2", Placeholder = "Discord User ID", Numeric = true, Finished = false}):OnChanged(function(v)
    AdminID_2 = v
end)

-- List Player Tab
local ListPlayerSection = Tabs.ListPlayer:AddSection("Player Tag List")

local BulkInput = ListPlayerSection:AddInput("BulkImport", {Text = "Bulk Import (User:DiscordID per line)", Placeholder = "Username:DiscordID\nUsername:DiscordID", MultiLine = true})

ListPlayerSection:AddButton("Import Bulk Data", function()
    local text = BulkInput.Value
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
        BulkInput:SetValue("")
        ShowNotification("Imported " .. addedCount .. " Players!")
    else
        ShowNotification("No Data Found!", true)
    end
end)

for i = 1, 20 do
    local rowData = TagList[i]
    local labelText = "List " .. i .. ":"
    if i == 1 then labelText = "Host 1:" end
    if i == 2 then labelText = "Host 2:" end

    local UserInput = ListPlayerSection:AddInput("User" .. i, {Text = labelText, Placeholder = "Username", Default = rowData[1] or ""})
    local IDInput = ListPlayerSection:AddInput("ID" .. i, {Text = "Discord ID", Placeholder = "Discord ID (Optional)", Default = rowData[2] or ""})

    TagUIElements[i] = {User = UserInput, ID = IDInput}

    UserInput:OnChanged(function(v)
        TagList[i][1] = v
    end)

    IDInput:OnChanged(function(v)
        TagList[i][2] = v
    end)
end

-- Setting Tab
local SettingSection = Tabs.Setting:AddSection("Script Settings")

local WalkOnWaterEnabled = false
local WaterPlatform = nil
local WalkConnection = nil

SettingSection:AddToggle("WalkOnWater", {Text = "Walk On Water", Default = false}):OnChanged(function(state)
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
end)

SettingSection:AddToggle("DisablePopups", {Text = "Remove Fish Notification Pop-up", Default = false}):OnChanged(function(state)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local SmallNotification = PlayerGui:FindFirstChild("Small Notification")

    if not SmallNotification then
        SmallNotification = PlayerGui:WaitForChild("Small Notification", 5)
    end

    if state then
        if SmallNotification then
             local DisableNotificationConnection = RunService.RenderStepped:Connect(function()
                 if not ScriptActive then
                     if DisableNotificationConnection then DisableNotificationConnection:Disconnect() end
                     return
                 end
                 SmallNotification.Enabled = false
             end)
             ShowNotification("Pop-up Blocked", false)
        end
    else
        if SmallNotification then SmallNotification.Enabled = true end
        ShowNotification("Pop-up Enabled", false)
    end
end)

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

SettingSection:AddToggle("NoAnimation", {Text = "No Animation", Default = false}):OnChanged(function(state)
    isNoAnimationActive = state
    if state then
        DisableAnimations()
        ShowNotification("No Animation ON", false)
    else
        EnableAnimations()
        ShowNotification("No Animation OFF", false)
    end
end)

local VFXControllerModule = require(ReplicatedStorage.Controllers.VFXController)
local originalVFXHandle = VFXControllerModule.Handle
local isVFXDisabled = false

SettingSection:AddToggle("RemoveVFX", {Text = "Remove Skin Effect", Default = false}):OnChanged(function(state)
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
end)

-- Save Config Tab
local SaveConfigSection = Tabs.SaveConfig:AddSection("Configuration Management")

local SaveInput = SaveConfigSection:AddInput("ConfigName", {Text = "Config Name", Placeholder = "Enter config name...", Numeric = false, Finished = false})

SaveConfigSection:AddButton("Save Config", function()
    local name = SaveInput.Value
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
        warn("ITG SAVE ERROR (JSON):", encodedData)
        return
    end

    local success, err = pcall(function()
        if not isfolder("XAL_Configs") then makefolder("XAL_Configs") end
        writefile("XAL_Configs/" .. name .. ".json", encodedData)
    end)

    if success then
        ShowNotification("Config Saved!", false)
    else
        ShowNotification("Write Error: " .. tostring(err), true)
        warn("ITG SAVE ERROR (WRITE):", err)
    end
end)

local LoadDropdown = SaveConfigSection:AddDropdown("LoadConfig", {Text = "Load Config", Values = {}})

local function RefreshConfigList()
    local files = {}
    local success, allFiles = pcall(function() return listfiles("XAL_Configs") end)
    if success and allFiles then
        for _, file in pairs(allFiles) do
            local name = file:match("([^/\\]+)$") or file
            name = name:gsub("%.json$", "")
            if name ~= "autoload" then
                table.insert(files, name)
            end
        end
    end
    LoadDropdown:SetValues(files)
end

RefreshConfigList()

LoadDropdown:OnChanged(function(v)
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

                FishInput:SetValue(Current_Webhook_Fish)
                LeaveInput:SetValue(Current_Webhook_Leave)
                ListInput:SetValue(Current_Webhook_List)
                AdminInput:SetValue(Current_Webhook_Admin)
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

            ShowNotification("Config Loaded!", false)
        else
            ShowNotification("JSON Error!", true)
        end
    end
end)

SaveConfigSection:AddButton("Delete Config", function()
    local selected = LoadDropdown.Value
    if not selected or selected == "" then ShowNotification("Select a config!", true) return end
    delfile("XAL_Configs/" .. selected .. ".json")
    ShowNotification("Deleted!", false)
    RefreshConfigList()
end)

local AutoLoadToggle = SaveConfigSection:AddToggle("AutoLoad", {Text = "Enable Auto Load", Default = false})

local function SaveAutoLoadPref(configName, enabled)
    local data = { config = configName, enabled = enabled }
    writefile("XAL_Configs/autoload.json", HttpService:JSONEncode(data))
end

local function GetAutoLoadPref()
    if isfile("XAL_Configs/autoload.json") then
        local s, c = pcall(function() return readfile("XAL_Configs/autoload.json") end)
        if s then
            local s2, d = pcall(function() return HttpService:JSONDecode(c) end)
            if s2 and d then return d end
        end
    end
    return nil
end

AutoLoadToggle:OnChanged(function(state)
    local selected = LoadDropdown.Value
    if not selected or selected == "" then 
        ShowNotification("Select a config first!", true) 
        AutoLoadToggle:SetValue(false)
        return 
    end

    SaveAutoLoadPref(selected, state)
    ShowNotification(state and "Autoload Set: " .. selected or "Autoload Disabled", false)
end)

-- Auto-load config on start
task.spawn(function()
    task.wait(2)
    local pref = GetAutoLoadPref()
    if pref and pref.enabled and pref.config then
        local success, content = pcall(function() return readfile("XAL_Configs/" .. pref.config .. ".json") end)
        if success then
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
                end
                if data.Settings then
                    for k, v in pairs(data.Settings) do
                        if Settings[k] ~= nil then
                            Settings[k] = v
                        end
                    end
                end
                Fluent:Notify({
                    Title = "Auto Load",
                    Content = "Config loaded: " .. pref.config,
                    Duration = 3
                })
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

-- Show window
Window:SelectTab(1)

print("ITG: Script Loaded Successfully!")
