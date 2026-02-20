-- NikeeHUB Fish It - Hirimi UI Overlay
-- Gunakan ini untuk load fish-ittttt.lua + Hirimi UI Overlay
-- Script asli tetap berfungsi 100%, ini hanya tambahan UI overlay

-- ============ LOAD ORIGINAL SCRIPT FIRST ============

-- Load original script from GitHub (CHANGE THIS URL TO YOURS!)
local originalScriptURL = "https://raw.githubusercontent.com/NikeeTXC/adbae/refs/heads/main/fish-ittttt.lua"
local originalScriptCode = nil

local success, result = pcall(function()
    return game:HttpGet(originalScriptURL)
end)

if success then
    originalScriptCode = result
    print("✅ Original script downloaded from GitHub!")
else
    print("⚠️ Failed to load original script: " .. tostring(result))
end

if originalScriptCode then
    print("✅ Loading original fish-ittttt.lua...")
    loadstring(originalScriptCode)()
    task.wait(2) -- Wait for original UI to load
    print("✅ Original script loaded!")
else
    print("⚠️ Original script not found! You can still use this overlay.")
end

-- ============ HIRIMI UI OVERLAY ============

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer

-- Load Hirimi Library from GitHub
local Loader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Memories0912/UI-Loader/refs/heads/main/Source.lua"))()

-- Create Overlay UI
local HirimiLib = Loader:MakeGui({
    Name = "Fish It Overlay",
    Description = "Quick Access - Original Script Loaded",
    Size = UDim2.new(0, 400, 0, 350)
})

local HirimiGui = CoreGui:FindFirstChild("HirimiGui")

-- ============ DATA ============

local FishingAreas = {
    ["Pirate Cove"] = {Pos = Vector3.new(3479.794, 4.192, 3451.693), Look = Vector3.new(0.578, -0.396, -0.713)},
    ["Ancient Jungle"] = {Pos = Vector3.new(1535.639, 3.159, -193.352), Look = Vector3.new(0.505, 0.000, 0.863)},
    ["Coral Reef"] = {Pos = Vector3.new(-3207.538, 6.087, 2011.079), Look = Vector3.new(0.973, 0.000, 0.229)},
    ["Crater Island"] = {Pos = Vector3.new(1058.976, 2.330, 5032.878), Look = Vector3.new(-0.789, 0.000, 0.615)},
    ["Fisherman Island"] = {Pos = Vector3.new(74.030, 9.530, 2705.230), Look = Vector3.new(0.000, 0.000, -1.000)},
    ["Kohana"] = {Pos = Vector3.new(-668.732, 3.000, 681.580), Look = Vector3.new(0.889, 0.000, 0.458)},
    ["Lost Isle"] = {Pos = Vector3.new(-3804.105, 2.344, -904.653), Look = Vector3.new(-0.901, 0.000, 0.433)},
    ["Tropical Island"] = {Pos = Vector3.new(-2162.920, 2.825, 3638.445), Look = Vector3.new(0.381, 0.000, 0.925)},
    ["Volcano"] = {Pos = Vector3.new(-552.797, 21.174, 186.940), Look = Vector3.new(-0.251, -0.534, -0.808)},
    ["Leviathan Den"] = {Pos = Vector3.new(3431.640, -287.726, 3529.052), Look = Vector3.new(-0.176, 0.444, -0.879)},
}

local SelectedArea = "Pirate Cove"

-- ============ TABS ============

local QuickTab = HirimiLib:CreateTab({Name = "Quick", Icon = "rbxassetid://10709790644"})
local TeleportTab = HirimiLib:CreateTab({Name = "Teleport", Icon = "rbxassetid://10709768939"})
local InfoTab = HirimiLib:CreateTab({Name = "Info", Icon = "rbxassetid://10709798174"})

-- ============ QUICK TAB ============

local QuickSection = QuickTab:AddSection("⚡ Quick Actions")

QuickTab:AddButton({
    Title = "Hide Original UI",
    Content = "Toggle original script UI",
    Icon = "rbxassetid://10709791523",
    Callback = function()
        -- Try to hide original UI
        local originalUI = CoreGui:FindFirstChild("RobloxReplicatedService") or CoreGui:FindFirstChild("NikeeHUB_Script")
        if originalUI then
            originalUI.Visible = not originalUI.Visible
            Loader:MakeNotify({
                Title = "Overlay",
                Content = originalUI.Visible and "Original UI Shown!" or "Original UI Hidden!",
                Time = 0.5,
                Delay = 2
            })
        else
            Loader:MakeNotify({
                Title = "Overlay",
                Content = "Original UI not found!",
                Time = 0.5,
                Delay = 2
            })
        end
    end
})

QuickTab:AddButton({
    Title = "Rejoin Server",
    Content = "Quick rejoin",
    Icon = "rbxassetid://10709790097",
    Callback = function()
        Loader:MakeNotify({
            Title = "Overlay",
            Content = "Rejoining...",
            Time = 0.5,
            Delay = 1
        })
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

QuickTab:AddButton({
    Title = "Copy Join Script",
    Content = "Copy rejoin script to clipboard",
    Icon = "rbxassetid://10709812159",
    Callback = function()
        if setclipboard then
            setclipboard("game:GetService('TeleportService'):Teleport(game.PlaceId, game:GetService('Players').LocalPlayer)")
            Loader:MakeNotify({
                Title = "Overlay",
                Content = "Script copied to clipboard!",
                Time = 0.5,
                Delay = 2
            })
        else
            Loader:MakeNotify({
                Title = "Overlay",
                Content = "Clipboard not supported!",
                Time = 0.5,
                Delay = 2
            })
        end
    end
})

local StatsSection = QuickTab:AddSection("📊 Quick Stats")

local StatsParagraph = QuickTab:AddParagraph({
    Title = "Session Info",
    Content = "Loading..."
})

spawn(function()
    while true do
        wait(5)
        local originalUI = CoreGui:FindFirstChild("RobloxReplicatedService") or CoreGui:FindFirstChild("NikeeHUB_Script")
        StatsParagraph:Set({
            Title = "Session Info",
            Content = string.format(
                "Original Script: %s\nOverlay UI: Active\nExecutor: Velocity",
                originalUI and "Loaded ✓" or "Not Found ✗"
            )
        })
    end
end)

-- ============ TELEPORT TAB ============

local TeleportSection = TeleportTab:AddSection("📍 Quick Teleport")

local AreaOptions = {}
for areaName, _ in pairs(FishingAreas) do
    table.insert(AreaOptions, areaName)
end
table.sort(AreaOptions)

TeleportSection:AddDropdown({
    Title = "Select Area",
    Content = "Choose fishing location",
    Multi = false,
    Options = AreaOptions,
    Default = {"Pirate Cove"},
    Callback = function(Value)
        if type(Value) == "table" then
            SelectedArea = Value[1]
        else
            SelectedArea = Value
        end
    end
})

TeleportSection:AddButton({
    Title = "Teleport Now",
    Content = "Teleport to selected area",
    Icon = "rbxassetid://10709768939",
    Callback = function()
        pcall(function()
            local areaData = FishingAreas[SelectedArea]
            if not areaData then return end
            
            local Character = LocalPlayer.Character
            if not Character then return end
            local HRP = Character:FindFirstChild("HumanoidRootPart")
            if not HRP then return end

            HRP.CFrame = CFrame.new(areaData.Pos, areaData.Pos + areaData.Look) * CFrame.new(0, 3, 0)
            Loader:MakeNotify({
                Title = "Overlay",
                Content = "Teleported to " .. SelectedArea .. "!",
                Time = 0.5,
                Delay = 2
            })
        end)
    end
})

-- Quick teleport buttons
local QuickTPSection = TeleportTab:AddSection("⚡ Quick TP")

for _, areaName in ipairs({"Pirate Cove", "Ancient Jungle", "Coral Reef", "Fisherman Island", "Leviathan Den"}) do
    TeleportSection:AddButton({
        Title = areaName,
        Content = "Quick teleport",
        Icon = "rbxassetid://10709768939",
        Callback = function()
            pcall(function()
                local areaData = FishingAreas[areaName]
                if not areaData then return end
                
                local Character = LocalPlayer.Character
                if not Character then return end
                local HRP = Character:FindFirstChild("HumanoidRootPart")
                if not HRP then return end

                HRP.CFrame = CFrame.new(areaData.Pos, areaData.Pos + areaData.Look) * CFrame.new(0, 3, 0)
                Loader:MakeNotify({
                    Title = "Overlay",
                    Content = "Teleported!",
                    Time = 0.5,
                    Delay = 1
                })
            end)
        end
    })
end

-- ============ INFO TAB ============

local InfoSection = InfoTab:AddSection("ℹ️ Script Information")

InfoTab:AddParagraph({
    Title = "Original Script",
    Content = "fish-ittttt.lua\nVersion: Full Feature\nStatus: Loaded & Active"
})

InfoTab:AddParagraph({
    Title = "Overlay UI",
    Content = "Hirimi Library\nStatus: Active\nPurpose: Quick Access"
})

InfoTab:AddParagraph({
    Title = "Features",
    Content = "✓ Auto Fish\n✓ Webhooks\n✓ Player Detection\n✓ Config System\n✓ 22 Fishing Areas\n✓ 47+ Secret Fish"
})

InfoTab:AddButton({
    Title = "Open Discord",
    Content = "Join support server",
    Icon = "rbxassetid://10709776050",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/yourserver")
            Loader:MakeNotify({
                Title = "Overlay",
                Content = "Discord link copied!",
                Time = 0.5,
                Delay = 2
            })
        end
    end
})

-- ============ MOBILE TOGGLE BUTTON ============

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "FishItOverlayToggle"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 70, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 139, 139)
ToggleButton.Text = "🎣"
ToggleButton.TextSize = 24
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.ZIndex = 1000
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 8)
ToggleButton.Parent = CoreGui

-- Make button draggable
local dragging = false
local dragInput, mousePos, framePos

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = ToggleButton.Position
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        ToggleButton.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

local UI_Visible = true
ToggleButton.MouseButton1Click:Connect(function()
    UI_Visible = not UI_Visible
    if HirimiGui then
        HirimiGui.Visible = UI_Visible
    end
end)

-- ============ NOTIFICATIONS ============

Loader:MakeNotify({
    Title = "NikeeHUB Overlay",
    Content = "Original Script + Hirimi UI Loaded!",
    Time = 1,
    Delay = 5
})

print("✅ NikeeHUB Fish It - Hirimi Overlay Loaded!")
print("🎣 Original script: Active")
print("🎨 Overlay UI: Active")
print("📱 Tap 🎣 button to toggle overlay UI")
