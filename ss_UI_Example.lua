-- ============================================
-- ITG Webhook - UI Implementation Example
-- Menggunakan ITG_UI_Library.lua
-- ============================================

-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/NikeeTXC/adbae/refs/heads/main/ITG_UI_Library.lua"))()

-- Create Window
Library:CreateWindow({
    Title = "ITG Webhook",
    Width = 700,
    Height = 500,
})

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

Library:CreateLabel(SectionStats, {Text = "Uptime: 00h 00m 00s", Size = 14, Bold = true})
Library:CreateDivider(SectionStats)

Library:CreateToggle(SectionStats, {
    Text = "Secret Fish Caught",
    Default = false,
    Callback = function(state) 
        Settings.SecretEnabled = state 
        Library:Notification({Message = "Secret " .. (state and "Enabled" or "Disabled"), Type = "success"})
    end,
})

Library:CreateToggle(SectionStats, {
    Text = "Ruby Gemstone",
    Default = false,
    Callback = function(state) 
        Settings.RubyEnabled = state 
    end,
})

Library:CreateToggle(SectionStats, {
    Text = "Evolved Enchant Stone",
    Default = false,
    Callback = function(state) 
        Settings.EvolvedEnabled = state 
    end,
})

Library:CreateToggle(SectionStats, {
    Text = "Mutation Crystalized",
    Default = false,
    Callback = function(state) 
        Settings.MutationCrystalized = state 
    end,
})

Library:CreateToggle(SectionStats, {
    Text = "Cave Crystal",
    Default = false,
    Callback = function(state) 
        Settings.CaveCrystalEnabled = state 
    end,
})

local SectionServer = Library:CreateSection("Server Info", "Server Settings")

local ServerInput = Library:CreateInput(SectionServer, {
    Placeholder = "Server Title",
    Default = "XALSCENT",
    Callback = function(text) 
        ServerTitle = text 
    end,
})

Library:CreateButton(SectionServer, {
    Text = "📊 Send Stats to Webhook",
    Color = Library.Theme.Accent,
    Callback = function()
        -- Send stats function here
        Library:Notification({Message = "Sending stats...", Type = "info"})
    end,
})

-- ============================================
-- FHISING TAB
-- ============================================
local SectionAuto = Library:CreateSection("Fhising", "Automation")

Library:CreateToggle(SectionAuto, {
    Text = "Auto Click Fishing",
    Default = false,
    Callback = function(state)
        AutoShakeEnabled = state
        -- Start/stop auto click logic
    end,
})

Library:CreateToggle(SectionAuto, {
    Text = "Auto Sell (10m / 600 Items)",
    Default = false,
    Callback = function(state)
        AutoSellEnabled = state
        -- Start/stop auto sell logic
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

Library:CreateLabel(SectionTotem, {Text = "Select Totem:", Size = 13})
-- Dropdown would need to be implemented in library

Library:CreateToggle(SectionTotem, {
    Text = "Auto Spawn Totem",
    Default = false,
    Callback = function(state)
        AutoTotemEnabled = state
    end,
})

local SectionDetector = Library:CreateSection("Fhising", "Detector")

Library:CreateToggle(SectionDetector, {
    Text = "Detector Stuck (15s)",
    Default = false,
    Callback = function(state)
        DetectorStuckEnabled = state
    end,
})

-- ============================================
-- TELEPORT TAB
-- ============================================
local SectionTeleportMain = Library:CreateSection("Teleport", "Fishing Locations")

-- Teleport buttons would be created in a grid
Library:CreateButton(SectionTeleportMain, {
    Text = "📍 Leviathan Den",
    Color = Library.Theme.Accent,
    Callback = function()
        TeleportToLookAt(FishingAreas["Leviathan Den"].Pos, FishingAreas["Leviathan Den"].Look)
    end,
})

Library:CreateButton(SectionTeleportMain, {
    Text = "📍 Crystal Depths",
    Color = Library.Theme.Accent,
    Callback = function()
        TeleportToLookAt(FishingAreas["Crystal Depths"].Pos, FishingAreas["Crystal Depths"].Look)
    end,
})

-- Add more teleport buttons as needed...

-- ============================================
-- NOTIFICATION TAB
-- ============================================
local SectionWebhookUrls = Library:CreateSection("Notification", "Webhook URLs")

local FishInput = Library:CreateInput(SectionWebhookUrls, {
    Placeholder = "Fish Caught Webhook",
    Default = Current_Webhook_Fish,
    Callback = function(text) 
        Current_Webhook_Fish = text 
    end,
    Height = 40,
})

local LeaveInput = Library:CreateInput(SectionWebhookUrls, {
    Placeholder = "Player Leave Webhook",
    Default = Current_Webhook_Leave,
    Callback = function(text) 
        Current_Webhook_Leave = text 
    end,
    Height = 40,
})

local ListInput = Library:CreateInput(SectionWebhookUrls, {
    Placeholder = "Player List Webhook",
    Default = Current_Webhook_List,
    Callback = function(text) 
        Current_Webhook_List = text 
    end,
    Height = 40,
})

local AdminInput = Library:CreateInput(SectionWebhookUrls, {
    Placeholder = "Admin Host Webhook",
    Default = Current_Webhook_Admin,
    Callback = function(text) 
        Current_Webhook_Admin = text 
    end,
    Height = 40,
})

Library:CreateButton(SectionWebhookUrls, {
    Text = "🧪 Test All Connections",
    Color = Library.Theme.Success,
    Callback = function()
        -- Test all webhooks
        Library:Notification({Message = "Testing webhooks...", Type = "info"})
    end,
})

-- ============================================
-- ADMIN BOOST TAB
-- ============================================
local SectionAdminDetect = Library:CreateSection("Admin Boost", "Detection")

Library:CreateToggle(SectionAdminDetect, {
    Text = "Deteksi Player Asing",
    Default = false,
    Callback = function(state)
        Settings.ForeignDetection = state
    end,
})

Library:CreateToggle(SectionAdminDetect, {
    Text = "Hide Player Name (Spoiler)",
    Default = true,
    Callback = function(state)
        Settings.SpoilerName = state
    end,
})

Library:CreateToggle(SectionAdminDetect, {
    Text = "Lag Detector (Ping > 500ms)",
    Default = false,
    Callback = function(state)
        Settings.PingMonitor = state
    end,
})

Library:CreateToggle(SectionAdminDetect, {
    Text = "Player Leave Server",
    Default = false,
    Callback = function(state)
        Settings.LeaveEnabled = state
    end,
})

Library:CreateToggle(SectionAdminDetect, {
    Text = "Player Not On Server (30min)",
    Default = false,
    Callback = function(state)
        Settings.PlayerNonPSAuto = state
    end,
})

local SectionAdminActions = Library:CreateSection("Admin Boost", "Actions")

Library:CreateButton(SectionAdminActions, {
    Text = "👥 Player On Server",
    Color = Library.Theme.Accent,
    Callback = function()
        -- Send player list
    end,
})

Library:CreateButton(SectionAdminActions, {
    Text = "❌ Player NOT On Server",
    Color = Library.Theme.Warning,
    Callback = function()
        -- Send missing players
    end,
})

-- ============================================
-- SETTING TAB
-- ============================================
local SectionGameSettings = Library:CreateSection("Setting", "Game Settings")

Library:CreateToggle(SectionGameSettings, {
    Text = "Walk On Water",
    Default = false,
    Callback = function(state)
        WalkOnWaterEnabled = state
    end,
})

Library:CreateToggle(SectionGameSettings, {
    Text = "Remove Fish Notification Pop-up",
    Default = false,
    Callback = function(state)
        Settings.DisablePopups = state
    end,
})

Library:CreateToggle(SectionGameSettings, {
    Text = "No Animation",
    Default = false,
    Callback = function(state)
        Settings.NoAnimation = state
        if state then
            -- Disable animations
        else
            -- Enable animations
        end
    end,
})

Library:CreateToggle(SectionGameSettings, {
    Text = "Remove Skin Effect",
    Default = false,
    Callback = function(state)
        Settings.RemoveVFX = state
    end,
})

Library:CreateToggle(SectionGameSettings, {
    Text = "Auto Execute on Server Hop",
    Default = false,
    Callback = function(state)
        Settings.AutoExecute = state
    end,
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
    Color = Library.Theme.Accent,
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
    Color = Library.Theme.Success,
    Callback = function()
        -- Load config logic
        Library:Notification({Message = "Config loaded", Type = "success"})
    end,
})

Library:CreateButton(SectionSave, {
    Text = "🗑️ Delete Selected",
    Color = Library.Theme.Error,
    Callback = function()
        -- Delete config logic
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

local SectionBulk = Library:CreateSection("List Player", "Bulk Import")

local BulkInput = Library:CreateInput(SectionBulk, {
    Placeholder = "Username:DiscordID (one per line)",
    Default = "",
    Height = 100,
})

Library:CreateButton(SectionBulk, {
    Text = "📥 Import Bulk Data",
    Color = Library.Theme.Success,
    Callback = function()
        local text = BulkInput.GetText()
        -- Parse and import
        Library:Notification({Message = "Importing...", Type = "info"})
    end,
})

-- ============================================
-- CLOSE HANDLER
-- ============================================
Library:OnClose(function()
    -- Cleanup
    if getgenv then
        getgenv().XAL_Stop = nil
    end
    ScriptActive = false
    Library.Window.ScreenGui:Destroy()
end)

print("✅ ITG Webhook UI Loaded Successfully!")
