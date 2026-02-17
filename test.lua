local success, Chloex = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/NikeeTXC/adbae/refs/heads/main/UI/MainUi.lua"))()
end)

-- [[ load Window ]]
local Window = Chloex:Window({
    Title   = "NateiraHub | Freemium | ",                --- title
    Footer  = "V0.0.0.4",                   --- in right after title
    Image   = "84946340265305",           ---- rbxassetid (texture)
    Color   = Color3.fromRGB(255, 255, 255), --- colour text/ui
    Theme   = 84946340265305,                  ---- background for theme ui (rbxassetid)
    Version = 1,                           --- version config set as default 1 if u remake / rewrite / big update and change name name in your hub change it to 2 and config will reset
})

--- [[ Notify ]]
if Window then
    Nt("Window loaded!")
end

local Tabs = {
    Info = Window:AddTab({ Name = "Info", Icon = "player" }),
    Player = Window:AddTab({ Name = "Player", Icon = "user" }), 
    Main = Window:AddTab({ Name = "Main", Icon = "gamepad" }),
    Auto = Window:AddTab({ Name = "Auto", Icon = "loop" }),
    Shop = Window:AddTab({ Name = "Shop", Icon = "shop" }),
    Teleport = Window:AddTab({ Name = "Teleport", Icon = "compas" }),
    Event = Window:AddTab({ Name = "Event", Icon = "gps" }),
    Quest = Window:AddTab({ Name = "Quest", Icon = "scroll" }),
    Settings = Window:AddTab({ Name = "Settings", Icon = "settings" }),
    Webhook = Window:AddTab({ Name = "Webhook", Icon = "discord" }),
}

v1 = Tabs.Info:AddSection("Discord", true)

v1:AddParagraph({
    Title = "Join Our Discord",
    Content = "Join Us!",
    Icon = "discord",
    ButtonText = "Copy Discord Link",
    ButtonCallback = function()
        local link = "https://discord.gg/7UjpVQwDhF"
        if setclipboard then
            setclipboard(link)
            Nt("Successfully Copied!")
        end
    end
})

x1 = Tabs.Player:AddSection("Player")

local P = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
_G.InfiniteJump = false

x1:AddToggle({
    Title = "Infinite Jump",
    Content = "Makes you jump without limits",
    Default = false,
    Callback = function(state)
        _G.InfiniteJump = state
    end
})

UIS.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local h = P.Character and P.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local Player = game:GetService("Players").LocalPlayer

x1:AddToggle({
    Title = "Noclip",
    Content = "Walk through walls",
    Default = false,
    Callback = function(state)
        _G.Noclip = state
        if state then
            task.spawn(function()
                while _G.Noclip do
                    task.wait(0.1)
                    local character = Player.Character
                    if character then
                        for _, part in pairs(character:GetDescendants()) do
                            if part:IsA("BasePart") and part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        end
    end
})

local P, SG = game.Players.LocalPlayer, game.StarterGui
local frozen, last

local function msg(t,c)
	pcall(function()
		SG:SetCore("ChatMakeSystemMessage",{
			Text="[FREEZE] "..t,
			Color=c or Color3.fromRGB(150,255,150),
			Font=Enum.Font.SourceSansBold,
			FontSize=Enum.FontSize.Size24
		})
	end)
end

local function setFreeze(s)
	local c = P.Character or P.CharacterAdded:Wait()
	local h = c:FindFirstChildOfClass("Humanoid")
	local r = c:FindFirstChild("HumanoidRootPart")
	if not h or not r then return end

	if s then
		last = r.CFrame
		h.WalkSpeed,h.JumpPower,h.AutoRotate,h.PlatformStand = 0,0,false,true
		for _,t in ipairs(h:GetPlayingAnimationTracks()) do t:Stop(0) end
		local a = h:FindFirstChildOfClass("Animator")
		if a then a:Destroy() end
		r.Anchored = true
		msg("Freeze character",Color3.fromRGB(100,200,255))
	else
		h.WalkSpeed,h.JumpPower,h.AutoRotate,h.PlatformStand = 16,50,true,false
		if not h:FindFirstChildOfClass("Animator") then Instance.new("Animator",h) end
		r.Anchored = false
		if last then r.CFrame = last end
		msg("Character released",Color3.fromRGB(255,150,150))
	end
end

x1:AddToggle({
	Title = "Freeze Character",
	Default = false,
	Callback=function(s)
		frozen = s
		setFreeze(s)
	end
})

P.CharacterAdded:Connect(function(c)
	if frozen then task.wait(.5); setFreeze(true) end
end)

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

_G.DisableAnimation = false
local animConn

local function getHumanoid()
    return (Player.Character or Player.CharacterAdded:Wait()):WaitForChild("Humanoid")
end

local function stopAllAnimations()
    local humanoid = getHumanoid()
    local animator = humanoid:FindFirstChildOfClass("Animator")

    if animator then
        -- stop animasi yang lagi jalan
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            track:Stop()
        end

        -- DISABLE animasi baru
        if animConn then animConn:Disconnect() end
        animConn = animator.AnimationPlayed:Connect(function(track)
            track:Stop()
        end)
    end
end

local function enableAnimation()
    if animConn then
        animConn:Disconnect()
        animConn = nil
    end
end

x1:AddToggle({
    Title = "Disable Animation",
    Default = false,
    Callback = function(state)
        _G.DisableAnimation = state

        if state then
            stopAllAnimations()
        else
            enableAnimation()
        end
    end
})

-- auto apply saat respawn
Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if _G.DisableAnimation then
        stopAllAnimations()
    end
end)

---------

_G.LocalPlayer = game:GetService("Players").LocalPlayer
_G.RunService = game:GetService("RunService")
_G.UserInputService = game:GetService("UserInputService")

_G.walkOnWaterConnection = nil
_G.isWalkOnWater = false
_G.waterPlatform = nil

x1:AddToggle({
	Title = "Walk on Water",
	Default = false,
	Callback = function(state)
		if state then
			_G.isWalkOnWater = true

			if not _G.waterPlatform then
				_G.waterPlatform = Instance.new("Part")
				_G.waterPlatform.Name = "WaterPlatform"
				_G.waterPlatform.Anchored = true
				_G.waterPlatform.CanCollide = true
				_G.waterPlatform.Transparency = 1
				_G.waterPlatform.Size = Vector3.new(15, 1, 15)
				_G.waterPlatform.Parent = workspace
			end

			if _G.walkOnWaterConnection then
				_G.walkOnWaterConnection:Disconnect()
			end

			_G.walkOnWaterConnection = _G.RunService.RenderStepped:Connect(function()
				if not _G.isWalkOnWater then return end

				_G.character = _G.LocalPlayer.Character
				if not _G.character then return end

				_G.hrp = _G.character:FindFirstChild("HumanoidRootPart")
				if not _G.hrp then return end

				_G.rayParams = RaycastParams.new()
				_G.rayParams.FilterDescendantsInstances = { workspace.Terrain }
				_G.rayParams.FilterType = Enum.RaycastFilterType.Include
				_G.rayParams.IgnoreWater = false

				_G.result = workspace:Raycast(
					_G.hrp.Position + Vector3.new(0,5,0),
					Vector3.new(0,-500,0),
					_G.rayParams
				)

				if _G.result and _G.result.Material == Enum.Material.Water then
					_G.waterY = _G.result.Position.Y

					_G.waterPlatform.Position = Vector3.new(
						_G.hrp.Position.X,
						_G.waterY,
						_G.hrp.Position.Z
					)

					if _G.hrp.Position.Y < _G.waterY + 2 then
						if not _G.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
							_G.hrp.CFrame = CFrame.new(
								_G.hrp.Position.X,
								_G.waterY + 3.2,
								_G.hrp.Position.Z
							)
						end
					end
				else
					_G.waterPlatform.Position = Vector3.new(
						_G.hrp.Position.X,
						-500,
						_G.hrp.Position.Z
					)
				end
			end)

		else
			_G.isWalkOnWater = false

			if _G.walkOnWaterConnection then
				_G.walkOnWaterConnection:Disconnect()
				_G.walkOnWaterConnection = nil
			end

			if _G.waterPlatform then
				_G.waterPlatform:Destroy()
				_G.waterPlatform = nil
			end
		end
	end
})

x3 = Tabs.Main:AddSection("Fishing")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local net = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local Remotes = {
    RequestStart = net:WaitForChild("RF/RequestFishingMinigameStarted"),
    Charge       = net:WaitForChild("RF/ChargeFishingRod"),
    Complete     = net:WaitForChild("RF/CatchFishCompleted"),
    AutoFish     = net:WaitForChild("RF/UpdateAutoFishingState")
}

local state = {
    running = false,
    completeDelay = 0.35
}

-- cast delay
_G.CastDelay = 0.0000001

local FishingController = require(
    ReplicatedStorage
        :WaitForChild("Controllers")
        :WaitForChild("FishingController")
)

local oldCharge = FishingController.RequestChargeFishingRod
FishingController.RequestChargeFishingRod = function(...)
    if state.running then return end
    return oldCharge(...)
end

local loopThread

local function doFishing()
    task.wait(_G.CastDelay)

    pcall(function()
        Remotes.RequestStart:InvokeServer(-139.6, 0.996)
    end)

    local startTick = tick()
    while tick() - startTick < state.completeDelay do
        pcall(function()
            Remotes.Charge:InvokeServer(tick())
        end)
        task.wait()
    end

    pcall(function()
        Remotes.Complete:InvokeServer()
    end)
end

local function start()
    if loopThread then return end
    state.running = true

    loopThread = task.spawn(function()
        while state.running do
            doFishing()
            task.wait()
        end
    end)
end

local function stop()
    state.running = false
    if loopThread then
        task.cancel(loopThread)
        loopThread = nil
    end
end

x3:AddToggle({
    Title = "Instant Fishing",
    Default = false,
    Callback = function(v)
        state.running = v

        pcall(function()
            Remotes.AutoFish:InvokeServer(v)
        end)

        if v then
            start()
        else
            stop()
        end
    end
})

x3:AddInput({
    Title = "Complete Delay (Seconds)",
    Default = tostring(state.completeDelay),
    Callback = function(v)
        local n = tonumber(v)
        if n and n > 0 then
            state.completeDelay = n
        end
    end
})


x3 = Tabs.Main:AddSection("Item")

_G.Radar = false

RS = game:GetService("ReplicatedStorage")
net = RS:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

function radarOn()
    net:WaitForChild("RF/UpdateFishingRadar"):InvokeServer(true)
end

function radarOff()
    net:WaitForChild("RF/UpdateFishingRadar"):InvokeServer(false)
end

x3:AddToggle({
    Title = "Fishing Radar",
    Default = false,
    Callback = function(state)
        _G.Radar = state

        if state then
            radarOn()
            Lexs("Fishing Radar On.")
        else
            radarOff()
        end
    end
})

x3:AddToggle({
    Title = "Auto Equip Diving Gear",
    Default = false,
    Callback = function(s)
        local net = game.ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
        if s then
            net["RF/EquipOxygenTank"]:InvokeServer(105)
        else
            net["RF/UnequipOxygenTank"]:InvokeServer()
        end
    end
})

_G.AutoOxygen = false

_G.RS = game:GetService("ReplicatedStorage")
_G.Net = _G.RS.Packages._Index["sleitnick_net@0.2.0"].net

x3:AddToggle({
    Title = "Auto Equip Advanced Diving Gear",
    Default = false,
    Callback = function(v)
        _G.AutoOxygen = v
        pcall(function()
            if v then
                _G.Net["RF/EquipOxygenTank"]:InvokeServer(575)
            else
                _G.Net["RF/UnequipOxygenTank"]:InvokeServer()
            end
        end)
    end
})

x4 = Tabs.Auto:AddSection("Auto Favorite")

_G.FavSystem = _G.FavSystem or {}

_G.FavSystem = _G.FavSystem or {}

if not _G.FavSystem.Init then
    RS = game:GetService("ReplicatedStorage")
    net = RS.Packages._Index["sleitnick_net@0.2.0"].net

    _G.FavSystem.REF = net["RE/FavoriteItem"]
    _G.FavSystem.REN = net["RE/ObtainedNewFishNotification"]
    _G.FavSystem.Items = RS:FindFirstChild("Items")
    _G.FavSystem.Conn = nil
    _G.FavSystem.Tiers = {}
    _G.FavSystem.Muts = {}
    _G.FavSystem.Fish = {Common={},Uncommon={},Rare={},Epic={},Legendary={},Mythic={},SECRET={}}
    _G.FavSystem.Init = true
end

if not _G.FavSystem.Loaded then
    if _G.FavSystem.Items and _G.FavSystem.Items:IsA("ModuleScript") then
        ok, data = pcall(require, _G.FavSystem.Items)
        if ok and data then
            map = {[1]="Common",[2]="Uncommon",[3]="Rare",[4]="Epic",[5]="Legendary",[6]="Mythic",[7]="SECRET"}
            for _, d in pairs(data) do
                if type(d)=="table" and d.Data and d.Data.Type=="Fish" then
                    t = map[d.Data.Tier or 1] or "Common"
                    if _G.FavSystem.Fish[t] then
                        table.insert(_G.FavSystem.Fish[t], d.Data.Id)
                    end
                end
            end
            for _, v in pairs(_G.FavSystem.Fish) do table.sort(v) end
            _G.FavSystem.Loaded = true
        end
    end
end

function favFish(id, w, i)
    m = (w and w.VariantId) or (i and i.InventoryItem and i.InventoryItem.Metadata and i.InventoryItem.Metadata.VariantId)

    for _, t in pairs(_G.FavSystem.Tiers) do
        if _G.FavSystem.Fish[t] and table.find(_G.FavSystem.Fish[t], id) then
            u = i and i.InventoryItem and i.InventoryItem.UUID or id
            task.spawn(function() pcall(function() _G.FavSystem.REF:FireServer(u) end) end)
            return
        end
    end

    if m and table.find(_G.FavSystem.Muts, m) then
        u = i and i.InventoryItem and i.InventoryItem.UUID or id
        task.spawn(function() pcall(function() _G.FavSystem.REF:FireServer(u) end) end)
    end
end

rar = {"Common","Uncommon","Rare","Epic","Legendary","Mythic","SECRET"}
muts = {"Shiny","Albino","Sandy","Noob","Moon Fragment","Festive","Disco","1x1x1x1","Bloodmoon","Color Burn","Corrupt","Fairy Dust","Frozen","Galaxy","Gemstone","Ghost","Gold","Holographic","Lightning","Midnight","Radioactive","Stone","Leviathan's Rage"}

x4:AddDropdown({
    Title = "Favorite Rarity",
    Content = "Select the rarity that will be auto favorite.",
    Options = rar,
    Default = {"Legendary","Mythic","SECRET"},
    Multi = true,
    Callback = function(v)
        _G.FavSystem.Tiers = v
    end
})

x4:AddDropdown({
    Title = "Favorite Mutation",
    Content = "Select the mutation that will be auto favorite.",
    Options = muts,
    Default = {},
    Multi = true,
    Callback = function(v)
        _G.FavSystem.Muts = v
    end
})

x4:AddToggle({
    Title = "Auto Favorite Fish",
    Default = false,
    Callback = function(state)
        if state then
            if _G.FavSystem.Conn then _G.FavSystem.Conn:Disconnect() end
            _G.FavSystem.Conn = _G.FavSystem.REN.OnClientEvent:Connect(favFish)
        else
            if _G.FavSystem.Conn then
                _G.FavSystem.Conn:Disconnect()
                _G.FavSystem.Conn = nil
            end
        end
    end
})

x4 = Tabs.Auto:AddSection("Auto Sell")

-- SERVICES & MODULE
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local Data = require(ReplicatedStorage.Packages.Replion)
    .Client:WaitReplion("Data")

-- HITUNG IKAN (REAL)
local function getFishCount()
    local items = Data:GetExpect({ "Inventory", "Items" })
    local count = 0

    for _, v in pairs(items) do
        local itemData = ItemUtility.GetItemDataFromItemType("Items", v.Id)
        if itemData and itemData.Data and itemData.Data.Type == "Fish" then
            count += (v.Amount or 1)
        end
    end

    return count
end

-- PARAGRAPH
local FishParagraph = x4:AddParagraph({
    Title = "Nateira Hub | Fish Counter",
    Content = "Fish in Bag: 0",
    Icon = "bag"
})

-- UPDATE CONTENT
task.spawn(function()
    local last = -1
    while true do
        local count = getFishCount()
        if count ~= last then
            last = count
            --paragrpah
            FishParagraph:SetContent("Fish in Bag: " .. count)
        end
        task.wait(0.5)
    end
end)




local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local SellAllRF =
    ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/SellAllItems"]

local AutoSell = false
local SellAt = 100
local Selling = false

local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local Data = require(ReplicatedStorage.Packages.Replion)
    .Client:WaitReplion("Data")

-- HITUNG JUMLAH IKAN
local function getFishCount()
    local items = Data:GetExpect({ "Inventory", "Items" })
    local count = 0

    for _, v in pairs(items) do
        local itemData = ItemUtility.GetItemDataFromItemType("Items", v.Id)
        if itemData and itemData.Data and itemData.Data.Type == "Fish" then
            count += (v.Amount or 1) -- FIX UTAMA
        end
    end

    return count
end

-- LOOP AUTO SELL
RunService.Heartbeat:Connect(function()
    if not AutoSell or Selling then return end

    local fishCount = getFishCount()
    if fishCount >= SellAt then
        Selling = true

        task.spawn(function()
            pcall(function()
                SellAllRF:InvokeServer()
            end)

            -- tunggu inventory update
            repeat
                task.wait(0.2)
            until getFishCount() < SellAt

            Selling = false
        end)
    end
end)

x4:AddInput({
    Title = "Auto Sell When Fish ≥ ",
    Placeholder = "example: 100",
    Default = tostring(SellAt),
    Callback = function(text)
        local n = tonumber(text)
        if n and n > 0 then
            SellAt = math.floor(n)
        end
    end
})

x4:AddToggle({
    Title = "Auto Sell All Fish",
    Default = false,
    Callback = function(state)
        AutoSell = state
    end
})

-- auto sell minute

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local SellAllRF =
    ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/SellAllItems"]

local AutoSell = false
local SellMinute = 5
local Selling = false
local LastSell = 0

local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local Data = require(ReplicatedStorage.Packages.Replion).Client:WaitReplion("Data")

local function getFishCount()
    local items = Data:GetExpect({ "Inventory", "Items" })
    local count = 0
    for _, v in pairs(items) do
        local itemData = ItemUtility.GetItemDataFromItemType("Items", v.Id)
        if itemData and itemData.Data and itemData.Data.Type == "Fish" then
            count += 1
        end
    end
    return count
end

x4:AddInput({
    Title = "Auto Sell Interval (Minute)",
    Placeholder = "example: 1",
    Default = tostring(SellMinute),
    Callback = function(text)
        local n = tonumber(text)
        if n and n > 0 then
            SellMinute = math.floor(n)
        end
    end
})

x4:AddToggle({
    Title = "Auto Sell All (By Minute)",
    Default = false,
    Callback = function(state)
        AutoSell = state
        if state then
            LastSell = os.clock()
        end
    end
})

x4 = Tabs.Auto:AddSection("Event Pirate")

local autoClaimClassicState, autoClaimClassicThread = false, nil
local RE_ClaimEventReward = nil

pcall(function()
    RE_ClaimEventReward =
        game:GetService("ReplicatedStorage")
        :WaitForChild("Packages", 10)
        :WaitForChild("_Index", 10)
        :WaitForChild("sleitnick_net@0.2.0", 10)
        :WaitForChild("net", 10)
        :WaitForChild("RE/ClaimEventReward", 10)
end)

x4:AddToggle({
    Title = "Auto Claim Pirate Event Rewards",
    Default = false,
    Callback = function(s)
        autoClaimClassicState = s

        if s then
            if not RE_ClaimEventReward then
                RE_ClaimEventReward =
                    game:GetService("ReplicatedStorage")
                    .Packages._Index["sleitnick_net@0.2.0"]
                    .net:FindFirstChild("RE/ClaimEventReward")
            end

            if not RE_ClaimEventReward then
                Nt("Remote Claim Reward tidak ditemukan")
                return
            end

            Nt("Auto Claim Pirate Event: ON")

            if autoClaimClassicThread then
                task.cancel(autoClaimClassicThread)
            end

            autoClaimClassicThread = task.spawn(function()
                while autoClaimClassicState do
                    for i = 1, 15 do
                        if not autoClaimClassicState then break end
                        pcall(function()
                            RE_ClaimEventReward:FireServer(i)
                        end)
                        task.wait(0.1)
                    end
                    task.wait(60)
                end
            end)
        else
            if autoClaimClassicThread then
                task.cancel(autoClaimClassicThread)
                autoClaimClassicThread = nil
            end
        end
    end
})

-- =========================
-- Pirate Treasure Chest
-- =========================

local autoClaimTreasureState = false
local autoClaimTreasureThread = nil

local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local START_CFRAME = CFrame.new(3263, 5, 3686)
local STORAGE = workspace:WaitForChild("PirateChestStorage")
local LOOP_DELAY = 1

local triedChests = {}

local function getHRP()
    local char = plr.Character or plr.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function teleport(cf)
    local hrp = getHRP()
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.CFrame = cf + Vector3.new(0, 3, 0)
end

local function getInteractable(obj)
    local p = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
    if p and p.Enabled then return p end
    local c = obj:FindFirstChildWhichIsA("ClickDetector", true)
    return c
end

local function interactOnce(obj)
    local i = getInteractable(obj)
    if not i then return false end
    if i:IsA("ProximityPrompt") then
        fireproximityprompt(i, 1)
    else
        fireclickdetector(i)
    end
    return true
end

local function getRandomChest()
    local valid = {}
    for _, v in ipairs(STORAGE:GetChildren()) do
        if not triedChests[v] and getInteractable(v) then
            table.insert(valid, v)
        end
    end
    if #valid == 0 then return end
    return valid[math.random(#valid)]
end

x4:AddToggle({
    Title = "Auto Claim Treasure Chest",
    Default = false,
    Callback = function(state)
        autoClaimTreasureState = state

        if state then
            Nt("Auto Claim Treasure Chest: ON")
            triedChests = {}

            if autoClaimTreasureThread then
                task.cancel(autoClaimTreasureThread)
            end

            autoClaimTreasureThread = task.spawn(function()
                teleport(START_CFRAME)
                task.wait(0.6)

                while autoClaimTreasureState do
                    local chest = getRandomChest()
                    if not chest then
                        autoClaimTreasureState = false
                        Nt("Semua Treasure Chest sudah di-claim")
                        break
                    end

                    triedChests[chest] = true

                    local part =
                        chest:IsA("Model")
                        and (chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart"))
                        or chest

                    if part then
                        teleport(part.CFrame)
                        task.wait(0.4)
                        interactOnce(chest)
                    end

                    task.wait(LOOP_DELAY)
                end
            end)
        else
            if autoClaimTreasureThread then
                task.cancel(autoClaimTreasureThread)
                autoClaimTreasureThread = nil
            end
        end
    end
})

local RS = game:GetService("ReplicatedStorage")

local Net = RS
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local RE_DialogueEnded = Net:WaitForChild("RE/DialogueEnded")
local RE_PickupItem = Net:WaitForChild("RE/SearchItemPickedUp")
local RE_OpenMaze = Net:WaitForChild("RE/GainAccessToMaze")

-- BUTTON
x4:AddButton({
    Title = "Auto Collect TNT + Open Maze",
    Callback = function()
        task.spawn(function()

            local questArgs = {
                [1] = "Carpenter",
                [2] = 2,
                [3] = 1
            }
            RE_DialogueEnded:FireServer(unpack(questArgs))

            task.wait(1)

            local tntArgs = {
                [1] = "TNT"
            }

            for i = 1, 4 do
                RE_PickupItem:FireServer(unpack(tntArgs))
                task.wait(0.5)
            end

            task.wait(1)

            RE_OpenMaze:FireServer()

        end)
    end
})

x6 = Tabs.Shop:AddSection("Boost Server")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GiftingController = require(
    ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("GiftingController")
)

_G.SelectedGift = "x2 Luck"

x6:AddDropdown({
    Title = "Select Luck Gift",
    Content = "Select the type of luck gift you want to open.",
    Options = {
        "x2 Luck",
        "x4 Luck",
        "x8 Luck"
    },
    Default = "x2 Luck",
    Callback = function(value)
        _G.SelectedGift = value
    end
})


x6:AddButton({
    Title = "Open Gift",
    Callback = function()
        Lexs("Opening gift: "..tostring(_G.SelectedGift))
        pcall(function()
            GiftingController:Open(_G.SelectedGift)
        end)
    end
})

x6 = Tabs.Shop:AddSection("Skin Rod")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GiftingController = require(
    ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("GiftingController")
)

_G.SelectedGift = "Frozen Krampus Scythe"

x6:AddDropdown({
    Title = "Select Gift",
    Content = "Select the skin gift you want to open.",
    Options = {
        "Frozen Krampus Scythe",
        "Gingerbread Katana",
        "Christmas Parasol"
    },
    Default = "Frozen Krampus Scythe",
    Callback = function(value)
        _G.SelectedGift = value
    end
})

x6:AddButton({
    Title = "Open Gift",
    Callback = function()
        Lexs("Opening gift: " .. tostring(_G.SelectedGift))
        pcall(function()
            GiftingController:Open(_G.SelectedGift)
        end)
    end
})

x6 = Tabs.Shop:AddSection("Shop Rod")

local RS = game:GetService("ReplicatedStorage")
local RF = RS.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseFishingRod"]

local R = {
    ["Luck Rod"] = 79,
    ["Carbon Rod"] = 76,
    ["Grass Rod"] = 85,
    ["Demascus Rod"] = 77,
    ["Ice Rod"] = 78,
    ["Lucky Rod"] = 4,
    ["Midnight Rod"] = 80,
    ["Steampunk Rod"] = 6,
    ["Chrome Rod"] = 7,
    ["Astral Rod"] = 5,
    ["Ares Rod"] = 126,
    ["Angler Rod"] = 168,
    ["Bamboo Rod"] = 258
}

local N = {
    "Luck Rod (350 Coins)",
    "Carbon Rod (900 Coins)",
    "Grass Rod (1.5k Coins)",
    "Demascus Rod (3k Coins)",
    "Ice Rod (5k Coins)",
    "Lucky Rod (15k Coins)",
    "Midnight Rod (50k Coins)",
    "Steampunk Rod (215k Coins)",
    "Chrome Rod (437k Coins)",
    "Astral Rod (1M Coins)",
    "Ares Rod (3M Coins)",
    "Angler Rod (8M Coins)",
    "Bamboo Rod (12M Coins)"
}

local M = {
    ["Luck Rod (350 Coins)"] = "Luck Rod",
    ["Carbon Rod (900 Coins)"] = "Carbon Rod",
    ["Grass Rod (1.5k Coins)"] = "Grass Rod",
    ["Demascus Rod (3k Coins)"] = "Demascus Rod",
    ["Ice Rod (5k Coins)"] = "Ice Rod",
    ["Lucky Rod (15k Coins)"] = "Lucky Rod",
    ["Midnight Rod (50k Coins)"] = "Midnight Rod",
    ["Steampunk Rod (215k Coins)"] = "Steampunk Rod",
    ["Chrome Rod (437k Coins)"] = "Chrome Rod",
    ["Astral Rod (1M Coins)"] = "Astral Rod",
    ["Ares Rod (3M Coins)"] = "Ares Rod",
    ["Angler Rod (8M Coins)"] = "Angler Rod",
    ["Bamboo Rod (12M Coins)"] = "Bamboo Rod"
}

local S = N[1]

x6:AddDropdown({
    Title = "Select Rod",
    Content = "Select the fishing rod you want to buy.",
    Options = N,
    Default = S,
    Callback = function(value)
        S = value
    end
})

x6:AddButton({
    Title = "Buy Rod",
    Callback = function()
        local k = M[S]
        if k and R[k] then
            Lexs("Buy rods: " .. k)
            pcall(function()
                RF:InvokeServer(R[k])
            end)
        end
    end
})

x6 = Tabs.Shop:AddSection("Shop Bait")

local RS = game:GetService("ReplicatedStorage")
local RF = RS.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseBait"]

local B = {
    ["Luck Bait"] = 2,
    ["Midnight Bait"] = 3,
    ["Nature Bait"] = 10,
    ["Chroma Bait"] = 6,
    ["Dark Matter Bait"] = 8,
    ["Corrupt Bait"] = 15,
    ["Aether Bait"] = 16,
    ["Floral Bait"] = 20
}

local N = {
    "Luck Bait (1k Coins)",
    "Midnight Bait (3k Coins)",
    "Nature Bait (83.5k Coins)",
    "Chroma Bait (290k Coins)",
    "Dark Matter Bait (630k Coins)",
    "Corrupt Bait (1.15M Coins)",
    "Aether Bait (3.7M Coins)",
    "Floral Bait (4M Coins)"
}

local M = {
    ["Luck Bait (1k Coins)"] = "Luck Bait",
    ["Midnight Bait (3k Coins)"] = "Midnight Bait",
    ["Nature Bait (83.5k Coins)"] = "Nature Bait",
    ["Chroma Bait (290k Coins)"] = "Chroma Bait",
    ["Dark Matter Bait (630k Coins)"] = "Dark Matter Bait",
    ["Corrupt Bait (1.15M Coins)"] = "Corrupt Bait",
    ["Aether Bait (3.7M Coins)"] = "Aether Bait",
    ["Floral Bait (4M Coins)"] = "Floral Bait"
}

local S = N[1]

x6:AddDropdown({
    Title = "Select Bait",
    Content = "Select the bait you want to buy.",
    Options = N,
    Default = S,
    Callback = function(value)
        S = value
    end
})

x6:AddButton({
    Title = "Buy Bait",
    Callback = function()
        local k = M[S]
        if k and B[k] then
            Lexs("Buy bait: " .. k)
            pcall(function()
                RF:InvokeServer(B[k])
            end)
        end
    end
})

x6 = Tabs.Shop:AddSection("Shop Weather")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RFPurchaseWeatherEvent = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseWeatherEvent"]

local weatherKeyMap = {
    ["Wind (10k Coins)"] = "Wind",
    ["Snow (15k Coins)"] = "Snow",
    ["Cloudy (20k Coins)"] = "Cloudy",
    ["Storm (35k Coins)"] = "Storm",
    ["Radiant (50k Coins)"] = "Radiant",
    ["Shark Hunt (300k Coins)"] = "Shark Hunt"
}

local weatherNames = {
    "Wind (10k Coins)",
    "Snow (15k Coins)",
    "Cloudy (20k Coins)",
    "Storm (35k Coins)",
    "Radiant (50k Coins)",
    "Shark Hunt (300k Coins)"
}

local selectedWeathers = {}
local autoBuyEnabled = false
local buyDelay = 540

x6:AddDropdown({
    Title = "Select Weather",
    Content = "Select the weather you want to buy.",
    Options = weatherNames,
    Multi = true,
    Callback = function(values)
        selectedWeathers = values
    end
})

x6:AddInput({
    Title = "Buy Delay (minutes)",
    Content = "Default 9 Minutes (Just Settings 1)",
    Placeholder = "1",
    Callback = function(input)
        local num = tonumber(input)
        if num and num > 0 then
            buyDelay = num * 60
        end
    end
})

local function startAutoBuy()
    task.spawn(function()
        while autoBuyEnabled do
            for _, displayName in ipairs(selectedWeathers) do
                local key = weatherKeyMap[displayName]
                if key then
                    pcall(function()
                        RFPurchaseWeatherEvent:InvokeServer(key)
                    end)
                end
            end
            task.wait(buyDelay)
        end
    end)
end

x6:AddToggle({
    Title = "Auto Buy Weather",
    Default = false,
    Callback = function(state)
        autoBuyEnabled = state
        if state then
            startAutoBuy()
        end
    end
})

x7 = Tabs.Teleport:AddSection("Island & Fishing Spot Teleport")

local IslandLocations = {
    ["Ancient Jungle"] = Vector3.new(1518, 1, -186),
    ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
    ["Crater Island"] = Vector3.new(997, 1, 5012),
    ["Enchant Room"] = Vector3.new(3221, -1303, 1406),
    ["Enchant Room 2"] = Vector3.new(1480, 126, -585),
    ["Esoteric Island"] = Vector3.new(1990, 5, 1398),
    ["Fisherman Island"] = Vector3.new(-64, 3, 2767),
    ["Kohana Volcano"] = Vector3.new(-545.302429, 17.1266193, 118.870537),
    ["Kohana"] = Vector3.new(-603, 3, 719),
    ["Lost Isle"] = Vector3.new(-3643, 1, -1061),
    ["Sacred Temple"] = Vector3.new(1498, -23, -644),
    ["Sysyphus Statue"] = Vector3.new(-3783.26807, -135.073914, -949.946289),
    ["Treasure Room"] = Vector3.new(-3600, -267, -1575),
    ["Tropical Grove"] = Vector3.new(-2091, 6, 3703),
    ["Underground Cellar"] = Vector3.new(2135, -93, -701),
    ["Weather Machine"] = Vector3.new(-1508, 6, 1895),
    ["Ancient Ruin"] = Vector3.new(6051, -541, 4414),
    ["Pirate Cove"] = Vector3.new(3248, 9, 3567),
    ["Crystal Depths"] = Vector3.new(5750, -905, 15381),
}

local SelectedIsland = nil

x7:AddDropdown({
    Title = "Select Island",
    Content = "Select the teleport destination island",
    Options = (function()
        local t = {}
        for k in pairs(IslandLocations) do
            table.insert(t, k)
        end
        table.sort(t)
        return t
    end)(),
    Callback = function(v)
        SelectedIsland = v
    end
})

x7:AddButton({
    Title = "Teleport to Island",
    Callback = function()
        if SelectedIsland and IslandLocations[SelectedIsland]
        and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame =
                CFrame.new(IslandLocations[SelectedIsland])
        end
    end
})

local FishingLocations = {
    ["Levers 1"] = Vector3.new(1475,4,-847),
    ["Levers 2"] = Vector3.new(882,5,-321),
    ["levers 3"] = Vector3.new(1425,6,126),
    ["levers 4"] = Vector3.new(1837,4,-309),
    ["Sysyphus Statue"] = Vector3.new(-3710, -97, -952),
    ["King Jelly Spot (For quest elemental)"] = Vector3.new(1473.60, 3.58, -328.23),
    ["El Shark Gran Maja Spot"] = Vector3.new(1526, 4, -629),
    ["Ancient Lochness"] = Vector3.new(6078, -586, 4629),
    ["Pirate Cove"] = Vector3.new(3552, 67, 3397),
    ["Kohana WaterFall"] = Vector3.new(-603, 15, 526),
    ["Pirate Treasure Room"] = Vector3.new(3331, -297, 3099),
    ["Crystal Depths"] = Vector3.new(5848, -903, 15417),
}

local SelectedFishing = nil

x7:AddDropdown({
    Title = "Select Fishing Spot",
    Content = "Select the fishing spot to teleport",
    Options = (function()
        local t = {}
        for k in pairs(FishingLocations) do
            table.insert(t, k)
        end
        table.sort(t)
        return t
    end)(),
    Callback = function(v)
        SelectedFishing = v
    end
})

x7:AddButton({
    Title = "Teleport to Fishing Spot",
    Callback = function()
        if SelectedFishing and FishingLocations[SelectedFishing]
        and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame =
                CFrame.new(FishingLocations[SelectedFishing])
        end
    end
})

x7 = Tabs.Teleport:AddSection("Teleport Player")

local P = game:GetService("Players")
local LP = P.LocalPlayer
local S
local D

local function L()
    local t = {}
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= LP then
            t[#t + 1] = p.Name
        end
    end
    return t
end

D = x7:AddDropdown({
    Title = "Teleport Target",
    Content = "Select the player you want to teleport",
    Options = L(),
    Callback = function(v)
        S = v
    end
})

x7:AddButton({
    Title = "Teleport to Player",
    Callback = function()
        local T = S and P:FindFirstChild(S)
        if T and T.Character and T.Character:FindFirstChild("HumanoidRootPart")
        and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame =
                T.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
})

x7:AddButton({
    Title = "Refresh Player List",
    Callback = function()
        local n = L()

        if D.SetOptions then
            D:SetOptions(n)
        elseif D.Update then
            D:Update(n)
        elseif D.Refresh then
            D:Refresh(n)
        end

        if n[1] then
            S = n[1]
            if D.Set then
                D:Set(n[1])
            end
        end

        Lexs("Player list successfully refreshed (" .. tostring(#n) .. " Players)")
    end
})

x8 = Tabs.Event:AddSection("Teleport Event")

local P = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")

local currentEvent = "Megalodon Hunt"
local teleporting = false
local lastPosition = nil
local bodyVelocity = nil
local connection = nil
local frozen = false
local done = false

local EventSettings = {
    isTeleporting = false,
    currentLocation = "Megalodon Hunt"
}

teleporting = EventSettings.isTeleporting
currentEvent = EventSettings.currentLocation

local function findEvent(eventName)
    if eventName == "Worm Fish" then
        for _, v in ipairs(workspace:GetChildren()) do
            local model = v:FindFirstChild("Model")
            if model then
                local part = model:GetChildren()[3]
                if part and part:IsA("BasePart") then
                    return part
                end
            end
        end
    else
        for _, v in ipairs(workspace:GetDescendants()) do
            if v.Name == eventName then
                if v:IsA("Model") then
                    return v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart", true)
                elseif v:IsA("BasePart") then
                    return v
                end
            end
        end
    end
    return nil
end

local function freeze(position)
    local character = P.Character
    if not character or character:GetAttribute("Dead") then return end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    if bodyVelocity then
        bodyVelocity:Destroy()
    end

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    bodyVelocity.P = 10000
    bodyVelocity.Parent = humanoidRootPart

    pcall(function()
        humanoidRootPart.CFrame = CFrame.new(position)
    end)

    frozen = true
    done = true
end

local function unfreeze()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    frozen = false
    done = false
end

local function savePosition()
    for _ = 1, 5 do
        local character = P.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            lastPosition = humanoidRootPart.Position
            return true
        end
        task.wait(0.2)
    end
    return false
end

local function teleportToEvent(eventPart)
    if not eventPart then return end
    local position = eventPart.Position
    freeze(Vector3.new(
        position.X + math.random(-10, 10),
        position.Y + 80,
        position.Z + math.random(-10, 10)
    ))
end

local function returnToLastPosition()
    if not lastPosition then return end
    unfreeze()
    local humanoidRootPart = P.Character and P.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(lastPosition)
    end
end

local function stopTeleporting()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    if frozen then
        returnToLastPosition()
    end
end

local function startTeleporting()
    if connection then
        connection:Disconnect()
    end

    if not savePosition() then return end

    connection = RS.Heartbeat:Connect(function()
        if not teleporting then
            if frozen then
                returnToLastPosition()
            end
            return
        end

        local character = P.Character
        if not character or character:GetAttribute("Dead") then
            if frozen then
                unfreeze()
            end
            return
        end

        if done then return end

        local eventPart = nil
        for _ = 1, 3 do
            eventPart = findEvent(currentEvent)
            if eventPart then break end
            task.wait(0.1)
        end

        if eventPart then
            if not frozen then
                teleportToEvent(eventPart)
            end
        elseif frozen then
            returnToLastPosition()
        end
    end)
end

x8:AddDropdown({
    Title = "Hunt Location",
    Options = {
        "Megalodon Hunt",
        "Ghost Shark Hunt",
        "Shark Hunt",
        "Worm Fish"
    },
    Default = currentEvent,
    Callback = function(value)
        currentEvent = value
        EventSettings.currentLocation = value

        if teleporting then
            unfreeze()
            task.wait(0.1)
            startTeleporting()
        end
    end
})

x8:AddToggle({
    Title = "Teleport To Game Event",
    Default = teleporting,
    Callback = function(state)
        teleporting = state
        EventSettings.isTeleporting = state

        if state then
            task.wait(0.5)
            startTeleporting()
        else
            stopTeleporting()
        end
    end
})

P.CharacterAdded:Connect(function()
    task.wait(2)
    if teleporting then
        task.wait(1)
        startTeleporting()
    end
end)

x12 = Tabs.Quest:AddSection("Deep Sea Quest")

local DeepSeaParagraph = x12:AddParagraph({
    Title = "Deep Sea Monitor",
    Content = "Click toggle to start..."
})

local runningDeepSea = false
local deepSeaThread = nil

local TREASURE_ROOM_CF = CFrame.new(-3650.4873, -269.269318, -1652.68323, -0.147814155, 0, -0.989015162, 0, 1, 0, 0.989015162, 0, -0.147814155)
local SISYPHUS_CF = CFrame.new(-3737, -136, -881)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replion = require(ReplicatedStorage.Packages.Replion)
local ClientData = nil

task.spawn(function()
    ClientData = Replion.Client:WaitReplion("Data")
end)

local function GetDeepSeaStatus()
    if not ClientData then 
        return {QuestCompleted = false, QuestActive = false, Progress = nil, HasGhostfinRod = false}
    end
    
    local result = {QuestCompleted = false, QuestActive = false, Progress = nil, HasGhostfinRod = false}
    
    local completedQuests = ClientData:Get({"CompletedQuests"}) or {}
    for _, questName in ipairs(completedQuests) do
        if questName == "Deep Sea Quest" then
            result.QuestCompleted = true
        end
    end
    
    local inventory = ClientData:Get({"Inventory"})
    if inventory and inventory["Fishing Rods"] then
        for _, rod in ipairs(inventory["Fishing Rods"]) do
            if rod.Id == 169 then
                result.HasGhostfinRod = true
                break
            end
        end
    end
    
    if not result.QuestCompleted then
        local questData = ClientData:Get({"Quests", "Mainline", "Deep Sea Quest"})
        if questData then
            result.QuestActive = true
            result.Progress = {
                Q1 = {Progress = 0, Done = false},
                Q2 = {Progress = 0, Done = false},
                Q3 = {Progress = 0, Done = false},
                Q4 = {Progress = 0, Done = false},
                TotalPercent = 0,
                AllDone = false
            }
            
            for objId, objData in pairs(questData.Objectives) do
                local numId = tonumber(objId)
                local progress = objData.Progress or 0
                
                if numId == 1 then
                    result.Progress.Q1.Progress = progress
                    result.Progress.Q1.Done = progress >= 300
                elseif numId == 2 then
                    result.Progress.Q2.Progress = progress
                    result.Progress.Q2.Done = progress >= 3
                elseif numId == 3 then
                    result.Progress.Q3.Progress = progress
                    result.Progress.Q3.Done = progress >= 1
                elseif numId == 4 then
                    result.Progress.Q4.Progress = progress
                    result.Progress.Q4.Done = progress >= 1000000
                end
            end
            
            local completedCount = 0
            local totalObjectives = 4
            if result.Progress.Q1.Done then completedCount = completedCount + 1 end
            if result.Progress.Q2.Done then completedCount = completedCount + 1 end
            if result.Progress.Q3.Done then completedCount = completedCount + 1 end
            if result.Progress.Q4.Done then completedCount = completedCount + 1 end
            
            result.Progress.AllDone = (completedCount == totalObjectives)
            result.Progress.TotalPercent = math.floor((completedCount / totalObjectives) * 100)
        end
    end
    
    return result
end

local function TeleportTo(cf)
    local p = game.Players.LocalPlayer
    local c = p.Character
    local h = c and c:FindFirstChild("HumanoidRootPart")
    if h then
        task.wait(0.1)
        h.CFrame = cf
        task.wait(0.3)
    end
end

local function IsFar(cf, dist)
    local c = game.Players.LocalPlayer.Character
    local h = c and c:FindFirstChild("HumanoidRootPart")
    return not h or (h.Position - cf.Position).Magnitude > dist
end

local function RunDeepSea()
    if deepSeaThread then
        task.cancel(deepSeaThread)
    end
    
    deepSeaThread = task.spawn(function()
        local lastNotif = 0
        
        while runningDeepSea do
            local status = GetDeepSeaStatus()
            
            -- Update paragraph with progress
            if status.QuestActive and status.Progress then
                local progressText = string.format(
                    "Progress: %d%% | R/E: %d/300 | M: %d/3 | S: %d/1 | Coins: %s/1M",
                    status.Progress.TotalPercent,
                    status.Progress.Q1.Progress,
                    status.Progress.Q2.Progress,
                    status.Progress.Q3.Progress,
                    tostring(status.Progress.Q4.Progress)
                )
                pcall(function()
                    DeepSeaParagraph:SetContent(progressText)
                end)
            end
            
            -- Check completion
            if status.QuestCompleted then
                Nt("Deep Sea Quest completed! Ghostfin Rod " .. (status.HasGhostfinRod and "obtained" or "ready to claim"))
                pcall(function()
                    DeepSeaParagraph:SetContent("Quest completed!")
                end)
                runningDeepSea = false
                break
            elseif not status.QuestActive then
                if os.time() - lastNotif > 30 then
                    Nt("Deep Sea: Quest not active. Go to Deep Sea area to start.")
                    lastNotif = os.time()
                end
            elseif status.QuestActive and status.Progress.AllDone then
                Nt("Deep Sea: All objectives done! Return to altar to claim.")
                pcall(function()
                    DeepSeaParagraph:SetContent("Ready to claim! Go to altar.")
                end)
                runningDeepSea = false
                break
            end
            
            -- Teleport logic
            if status.QuestActive and status.Progress then
                local targetCF = nil
                
                if not status.Progress.Q1.Done then
                    targetCF = TREASURE_ROOM_CF
                elseif not status.Progress.Q2.Done or not status.Progress.Q3.Done then
                    targetCF = SISYPHUS_CF
                elseif not status.Progress.Q4.Done then
                    targetCF = SISYPHUS_CF
                end
                
                if targetCF and IsFar(targetCF, 20) then
                    TeleportTo(targetCF)
                    task.wait(1.5)
                end
            end
            
            task.wait(1)
        end
        
        if not runningDeepSea then
            pcall(function()
                DeepSeaParagraph:SetContent("Stopped")
            end)
        end
        
        deepSeaThread = nil
    end)
end

x12:AddToggle({
    Title = "Auto Complete Deep Sea",
    Description = "One-time quest: Farm Ghostfin Rod",
    Default = false,
    Callback = function(s)
        runningDeepSea = s
        
        if s then
            Nt("Deep Sea: Checking quest status...")
            task.wait(0.5)
            local status = GetDeepSeaStatus()
            
            if status.QuestCompleted then
                Nt("Deep Sea Quest already completed!")
                pcall(function()
                    DeepSeaParagraph:SetContent("Quest already completed")
                end)
                runningDeepSea = false
                return
            elseif status.QuestActive and status.Progress and status.Progress.AllDone then
                Nt("Deep Sea: All objectives done! Return to altar.")
                pcall(function()
                    DeepSeaParagraph:SetContent("Ready to claim")
                end)
                runningDeepSea = false
                return
            else
                Nt("Deep Sea: Starting automation...")
                RunDeepSea()
            end
        else
            if deepSeaThread then
                task.cancel(deepSeaThread)
                deepSeaThread = nil
            end
            Nt("Deep Sea: Stopped")
            pcall(function()
                DeepSeaParagraph:SetContent("Stopped")
            end)
        end
    end
})


x12 = Tabs.Quest:AddSection("Element Quest")

local ElementParagraph = x12:AddParagraph({
    Title = "Element Quest Monitor",
    Content = "Click toggle to start..."
})

local runningElement = false
local elementThread = nil

local ALTAR_CF = CFrame.new(1479.587, 128.295, -604.224)
local JUNGLE_CF = CFrame.new(1535.639, 3.159, -193.352, 0.505, -0.000, 0.863, 0.000, 1.000, 0.000, -0.863, 0.000, 0.505)
local TEMPLE_CF = CFrame.new(1461.815, -22.125, -670.234, -0.990, -0.000, 0.143, 0.000, 1.000, 0.000, -0.143, 0.000, -0.990)

local function GetElementQuestStatus()
    if not ClientData then
        return {QuestCompleted = false, QuestActive = false, DeepSeaCompleted = false, HasGhostfinRod = false, Progress = nil, CanStartElement = false}
    end
    
    local result = {QuestCompleted = false, QuestActive = false, DeepSeaCompleted = false, HasGhostfinRod = false, Progress = nil, CanStartElement = false}
    
    local completedQuests = ClientData:Get({"CompletedQuests"}) or {}
    for _, questName in ipairs(completedQuests) do
        if questName == "Deep Sea Quest" then
            result.DeepSeaCompleted = true
        end
        if questName == "Element Quest" then
            result.QuestCompleted = true
        end
    end
    
    local inventory = ClientData:Get({"Inventory"})
    if inventory and inventory["Fishing Rods"] then
        for _, rod in ipairs(inventory["Fishing Rods"]) do
            if rod.Id == 169 then
                result.HasGhostfinRod = true
                break
            end
        end
    end
    
    result.CanStartElement = result.DeepSeaCompleted or result.HasGhostfinRod
    
    if not result.QuestCompleted then
        local questData = ClientData:Get({"Quests", "Mainline", "Element Quest"})
        if questData then
            result.QuestActive = true
            result.Progress = {
                Q1 = {Done = true, Text = "Ghostfin Rod: Done"},
                Q2 = {Progress = 0, Done = false, Text = "Jungle Secret: Not Done"},
                Q3 = {Progress = 0, Done = false, Text = "Temple Secret: Not Done"},
                Q4 = {Progress = 0, Done = false, Text = "Transcended Stones: 0/3"},
                TotalPercent = 0,
                AllDone = false
            }
            
            for objId, objData in pairs(questData.Objectives) do
                local numId = tonumber(objId)
                local progress = objData.Progress or 0
                
                if numId == 2 then
                    result.Progress.Q2.Progress = progress
                    result.Progress.Q2.Done = progress >= 1
                    result.Progress.Q2.Text = result.Progress.Q2.Done and "Jungle Secret: Done" or "Jungle Secret: Not Done"
                elseif numId == 3 then
                    result.Progress.Q3.Progress = progress
                    result.Progress.Q3.Done = progress >= 1
                    result.Progress.Q3.Text = result.Progress.Q3.Done and "Temple Secret: Done" or "Temple Secret: Not Done"
                elseif numId == 4 then
                    result.Progress.Q4.Progress = progress
                    result.Progress.Q4.Done = progress >= 3
                    result.Progress.Q4.Text = string.format("Transcended Stones: %d/3", progress)
                end
            end
            
            result.Progress.Q1.Done = result.CanStartElement
            result.Progress.Q1.Text = result.CanStartElement and "Ghostfin Rod: Done" or "Ghostfin Rod: Not Done"
            
            local completedCount = 0
            if result.Progress.Q1.Done then completedCount = completedCount + 1 end
            if result.Progress.Q2.Done then completedCount = completedCount + 1 end
            if result.Progress.Q3.Done then completedCount = completedCount + 1 end
            if result.Progress.Q4.Done then completedCount = completedCount + 1 end
            
            result.Progress.AllDone = (completedCount == 4)
            result.Progress.TotalPercent = math.floor((completedCount / 4) * 100)
        end
    end
    
    return result
end

local function RunElementQuest()
    if elementThread then
        task.cancel(elementThread)
    end
    
    elementThread = task.spawn(function()
        local lastNotif = 0
        
        while runningElement do
            local status = GetElementQuestStatus()
            
            -- Update paragraph with progress
            if status.QuestActive and status.Progress then
                local progressText = string.format(
                    "Progress: %d%% | Jungle: %s | Temple: %s | Stones: %d/3",
                    status.Progress.TotalPercent,
                    status.Progress.Q2.Done and "Done" or "Not Done",
                    status.Progress.Q3.Done and "Done" or "Not Done",
                    status.Progress.Q4.Progress
                )
                pcall(function()
                    ElementParagraph:SetContent(progressText)
                end)
            end
            
            -- Check completion
            if status.QuestCompleted then
                Nt("Element Quest completed! Element Rod obtained.")
                pcall(function()
                    ElementParagraph:SetContent("Quest completed!")
                end)
                runningElement = false
                break
            elseif not status.CanStartElement then
                if os.time() - lastNotif > 30 then
                    Nt("Element Quest: Need to complete Deep Sea Quest first or have Ghostfin Rod")
                    lastNotif = os.time()
                end
                runningElement = false
                break
            elseif not status.QuestActive then
                if os.time() - lastNotif > 15 then
                    Nt("Element Quest: Going to altar to start quest...")
                    lastNotif = os.time()
                end
                
                if IsFar(ALTAR_CF, 20) then
                    TeleportTo(ALTAR_CF)
                    task.wait(2)
                end
                task.wait(2)
            elseif status.QuestActive and status.Progress.AllDone then
                Nt("Element Quest: All objectives done! Return to altar to claim Element Rod.")
                pcall(function()
                    ElementParagraph:SetContent("Ready to claim! Go to altar.")
                end)
                runningElement = false
                break
            end
            
            -- Teleport logic
            if status.QuestActive and status.Progress then
                local targetCF = nil
                
                if not status.Progress.Q2.Done then
                    targetCF = JUNGLE_CF
                elseif not status.Progress.Q3.Done then
                    targetCF = TEMPLE_CF
                elseif not status.Progress.Q4.Done then
                    targetCF = ALTAR_CF
                end
                
                if targetCF and IsFar(targetCF, 20) then
                    TeleportTo(targetCF)
                    task.wait(1.5)
                end
            end
            
            task.wait(2)
        end
        
        if not runningElement then
            pcall(function()
                ElementParagraph:SetContent("Stopped")
            end)
        end
        
        elementThread = nil
    end)
end

x12:AddToggle({
    Title = "Auto Track Element Quest",
    Description = "Requires: Deep Sea completed OR Ghostfin Rod",
    Default = false,
    Callback = function(s)
        runningElement = s
        
        if s then
            Nt("Element Quest: Checking quest status...")
            task.wait(0.5)
            local status = GetElementQuestStatus()
            
            if status.QuestCompleted then
                Nt("Element Quest already completed!")
                pcall(function()
                    ElementParagraph:SetContent("Quest already completed")
                end)
                runningElement = false
                return
            elseif not status.CanStartElement then
                Nt(string.format("Element Quest: Can't start | Deep Sea: %s | Ghostfin Rod: %s", 
                    status.DeepSeaCompleted and "Done" or "Not Done",
                    status.HasGhostfinRod and "Have" or "Don't Have"))
                pcall(function()
                    ElementParagraph:SetContent("Need Deep Sea Quest or Ghostfin Rod")
                end)
                runningElement = false
                return
            elseif status.QuestActive and status.Progress and status.Progress.AllDone then
                Nt("Element Quest: All objectives done! Return to altar.")
                pcall(function()
                    ElementParagraph:SetContent("Ready to claim")
                end)
                runningElement = false
                return
            else
                Nt("Element Quest: Starting automation...")
                RunElementQuest()
            end
        else
            if elementThread then
                task.cancel(elementThread)
                elementThread = nil
            end
            Nt("Element Quest: Stopped")
            pcall(function()
                ElementParagraph:SetContent("Stopped")
            end)
        end
    end
})

sett = Tabs.Settings:AddSection("Player In Game")

local P = game:GetService("Players").LocalPlayer
local C = P.Character or P.CharacterAdded:Wait()
local O = C:WaitForChild("HumanoidRootPart"):WaitForChild("Overhead")
local H = O.Content.Header
local L = O.LevelContainer.Label

local D = {h = H.Text, l = L.Text, ch = H.Text, cl = L.Text, on = false}

sett:AddInput({
    Title = "Hide Name",
    Placeholder = "Input Name",
    Default = D.h,
    Callback = function(v)
        D.ch = v
        if D.on then H.Text = v end
    end
})

sett:AddInput({
    Title = "Hide Level",
    Placeholder = "Input Level",
    Default = D.l,
    Callback = function(v)
        D.cl = v
        if D.on then L.Text = v end
    end
})

sett:AddToggle({
    Title = "Hide Name & Level (Custom)",
    Default = false,
    Callback = function(v)
        D.on = v
        if v then
            H.Text = D.ch
            L.Text = D.cl
        else
            H.Text = D.h
            L.Text = D.l
        end
    end
})

local P = game:GetService("Players").LocalPlayer
local HN, HL = "Nateira Protection", "Lv. ???"
local S = {on = false, ui = nil}

local function setup(c)
    local o = c:WaitForChild("HumanoidRootPart"):WaitForChild("Overhead")
    local h = o.Content.Header
    local l = o.LevelContainer.Label
    return {h = h, l = l, dh = h.Text, dl = l.Text}
end

S.ui = setup(P.Character or P.CharacterAdded:Wait())

P.CharacterAdded:Connect(function(c)
    task.wait(0.2)
    S.ui = setup(c)
    if S.on then
        S.ui.h.Text = HN
        S.ui.l.Text = HL
    end
end)

sett:AddToggle({
    Title = "Hide Name & Level (Default)",
    Default = false,
    Callback = function(v)
        S.on = v
        if not S.ui then return end
        if v then
            S.ui.h.Text = HN
            S.ui.l.Text = HL
        else
            S.ui.h.Text = S.ui.dh
            S.ui.l.Text = S.ui.dl
        end
    end
})

local P = game:GetService("Players").LocalPlayer
local Z = {P.CameraMaxZoomDistance, P.CameraMinZoomDistance}

sett:AddToggle({
    Title = "Infinite Zoom",
    Default = false,
    Callback=function(s)
        if s then
            P.CameraMaxZoomDistance=math.huge
            P.CameraMinZoomDistance=.5
        else
            P.CameraMaxZoomDistance=Z[1] or 128
            P.CameraMinZoomDistance=Z[2] or .5
        end
    end
})

local P = game:GetService("Players")
local T = game:GetService("TeleportService")
local LP = P.LocalPlayer
local PID = game.PlaceId
local ON = true

local BL = {
    [75974130]=1,[40397833]=1,[187190686]=1,[33372493]=1,[889918695]=1,
    [33679472]=1,[30944240]=1,[25050357]=1,[8462585751]=1,[8811129148]=1,
    [192821024]=1,[4509801805]=1,[124505170]=1,[108397209]=1
}

sett:AddToggle({
    Title = "Anti Staff",
    Default = true,
    Callback=function(s)
        ON=s
    end
})

local function hop()
    task.wait(6)
    local d = game.HttpService:JSONDecode(
        game:HttpGet("https://games.roblox.com/v1/games/"..PID.."/servers/Public?sortOrder=Asc&limit=100")
    ).data
    for _,v in ipairs(d) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            T:TeleportToPlaceInstance(PID, v.id, LP)
            break
        end
    end
end

P.PlayerAdded:Connect(function(plr)
    if ON and plr~=LP and BL[plr.UserId] then
        Nt(plr.Name.." has joined, serverhop in 6 seconds...")
        hop()
    end
end)

task.spawn(function()
    while task.wait(2) do
        if ON then
            for _,plr in ipairs(P:GetPlayers()) do
                if plr~=LP and BL[plr.UserId] then
                    Nt(plr.Name.." has joined, serverhop in 6 seconds...")
                    hop()
                    break
                end
            end
        end
    end
end)

sett = Tabs.Settings:AddSection("Graphic In Game")

local isBoostActive = false
local originalLightingValues = {}

local function ToggleFPSBoost(enabled)
	isBoostActive = enabled
	local Lighting = game:GetService("Lighting")
	local Terrain = workspace:FindFirstChildOfClass("Terrain")

	if enabled then
		if not next(originalLightingValues) then
			originalLightingValues.GlobalShadows = Lighting.GlobalShadows
			originalLightingValues.FogEnd = Lighting.FogEnd
			originalLightingValues.Brightness = Lighting.Brightness
			originalLightingValues.ClockTime = Lighting.ClockTime
			originalLightingValues.Ambient = Lighting.Ambient
			originalLightingValues.OutdoorAmbient = Lighting.OutdoorAmbient
		end

		pcall(function()
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("ParticleEmitter")
				or v:IsA("Trail")
				or v:IsA("Smoke")
				or v:IsA("Fire")
				or v:IsA("Explosion") then
					v.Enabled = false
				elseif v:IsA("Beam") or v:IsA("Light") then
					v.Enabled = false
				elseif v:IsA("Decal") or v:IsA("Texture") then
					v.Transparency = 1
				end
			end
		end)

		pcall(function()
			for _, effect in pairs(Lighting:GetChildren()) do
				if effect:IsA("PostEffect") then
					effect.Enabled = false
				end
			end
			Lighting.GlobalShadows = false
			Lighting.FogEnd = 9e9
			Lighting.Brightness = 3
			Lighting.ClockTime = 14
			Lighting.Ambient = Color3.new(0,0,0)
			Lighting.OutdoorAmbient = Color3.new(0,0,0)
		end)

		if Terrain then
			pcall(function()
				Terrain.WaterWaveSize = 0
				Terrain.WaterWaveSpeed = 0
				Terrain.WaterReflectance = 0
				Terrain.WaterTransparency = 1
				Terrain.Decoration = false
			end)
		end

		pcall(function()
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
			settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
			settings().Rendering.TextureQuality = Enum.TextureQuality.Low
		end)

		if type(setfpscap) == "function" then
			pcall(function() setfpscap(100) end)
		end

		if type(collectgarbage) == "function" then
			collectgarbage("collect")
		end

		Nt("FPS Ultra Boost ON")

	else
		pcall(function()
			if originalLightingValues.GlobalShadows ~= nil then
				Lighting.GlobalShadows = originalLightingValues.GlobalShadows
				Lighting.FogEnd = originalLightingValues.FogEnd
				Lighting.Brightness = originalLightingValues.Brightness
				Lighting.ClockTime = originalLightingValues.ClockTime
				Lighting.Ambient = originalLightingValues.Ambient
				Lighting.OutdoorAmbient = originalLightingValues.OutdoorAmbient
			end

			settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic

			for _, effect in pairs(Lighting:GetChildren()) do
				if effect:IsA("PostEffect") then
					effect.Enabled = true
				end
			end
		end)

		if type(setfpscap) == "function" then
			pcall(function() setfpscap(60) end)
		end
	end
end

sett:AddToggle({
	Title = "FPS Ultra Boost",
	Default = false,
	Callback = function(state)
		ToggleFPSBoost(state)
	end
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local PopupConn
local RemoteConn

sett:AddToggle({
    Title = "Remove Fish Notification Pop-up",
    Default = false,
    Callback = function(state)

        local function getPopup()
            local gui = PlayerGui:FindFirstChild("Small Notification")
            if not gui then return end
            local display = gui:FindFirstChild("Display")
            if not display then return end
            return display:FindFirstChild("NewFrame")
        end

        local RemoteEvent =
            ReplicatedStorage
            :WaitForChild("Packages")
            :WaitForChild("_Index")
            :WaitForChild("sleitnick_net@0.2.0")
            :WaitForChild("net")
            :WaitForChild("RE/ObtainedNewFishNotification")

        if state then
            local frame = getPopup()
            if frame then
                frame.Visible = false
                frame:Destroy()
            end

            PopupConn = PlayerGui.DescendantAdded:Connect(function(v)
                if v.Name == "NewFrame" then
                    task.wait()
                    v.Visible = false
                    v:Destroy()
                end
            end)

            RemoteConn = RemoteEvent.OnClientEvent:Connect(function()
                local f = getPopup()
                if f then
                    f.Visible = false
                    f:Destroy()
                end
            end)
            Nt("Fish Pop-up Disabled")
        else
            if PopupConn then PopupConn:Disconnect() PopupConn = nil end
            if RemoteConn then RemoteConn:Disconnect() RemoteConn = nil end
        end
    end
})

local R = game:GetService("RunService")
local P = game:GetService("Players").LocalPlayer
local G

sett:AddToggle({
    Title = "Disable 3D Rendering",
    Default = false,
    Callback = function(s)
        pcall(function() R:Set3dRenderingEnabled(not s) end)
        if s then
            G = Instance.new("ScreenGui")
            G.IgnoreGuiInset = true
            G.ResetOnSpawn = false
            G.Parent = P.PlayerGui

            Instance.new("Frame", G).Size = UDim2.fromScale(1,1)
            G.Frame.BackgroundColor3 = Color3.new(1,1,1)
            G.Frame.BorderSizePixel = 0
        elseif G then
            G:Destroy()
            G = nil
        end
    end
})

local W = workspace
local L = game:GetService("Lighting")

local S = {on = false, cache = {}}

local VFX = {
    ParticleEmitter = true, Beam = true, Trail = true, Smoke = true,
    Fire = true, Sparkles = true, Explosion = true,
    PointLight = true, SpotLight = true, SurfaceLight = true, Highlight = true
}

local LE = {
    BloomEffect = true, SunRaysEffect = true, ColorCorrectionEffect = true,
    DepthOfFieldEffect = true, Atmosphere = true
}

local function disable()
    for _, o in ipairs(W:GetDescendants()) do
        if VFX[o.ClassName] and o.Enabled == true then
            S.cache[o] = true
            o.Enabled = false
        end
    end

    for _, o in ipairs(L:GetChildren()) do
        if LE[o.ClassName] and o.Enabled ~= nil then
            S.cache[o] = true
            o.Enabled = false
        end
    end
end

local function restore()
    for o in pairs(S.cache) do
        if o and o.Parent and o.Enabled ~= nil then
            o.Enabled = true
        end
    end
    table.clear(S.cache)
end

-- listener cuma sekali (ANTI LEAK)
W.DescendantAdded:Connect(function(o)
    if S.on and VFX[o.ClassName] and o.Enabled ~= nil then
        task.defer(function() o.Enabled = false end)
    end
end)

L.DescendantAdded:Connect(function(o)
    if S.on and LE[o.ClassName] and o.Enabled ~= nil then
        task.defer(function() o.Enabled = false end)
    end
end)

sett:AddToggle({
    Title = "Hide All VFX",
    Default = false,
    Callback = function(state)
        S.on = state
        if state then
            disable()
        else
            restore()
        end
    end
})

local VFX = require(game:GetService("ReplicatedStorage").Controllers.VFXController)

-- simpan fungsi asli (cukup sekali)
local ORI = {
    H = VFX.Handle,
    P = VFX.RenderAtPoint,
    I = VFX.RenderInstance
}

sett:AddToggle({
    Title = "Remove Skin Effect",
    Default = false,
    Callback = function(state)
        if state then
            -- disable VFX
            VFX.Handle = function() end
            VFX.RenderAtPoint = function() end
            VFX.RenderInstance = function() end

            local f = workspace:FindFirstChild("CosmeticFolder")
            if f then
                pcall(f.ClearAllChildren, f)
            end
            Nt("Skin Effect Disabled")
        else
            -- restore VFX
            VFX.Handle = ORI.H
            VFX.RenderAtPoint = ORI.P
            VFX.RenderInstance = ORI.I
        end
    end
})

sett = Tabs.Settings:AddSection("Server")

sett:AddButton({
    Title = "Rejoin",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

TeleportService:Teleport(game.PlaceId, player)

    end
})

Players = game:GetService("Players")
TeleportService = game:GetService("TeleportService")

Player = Players.LocalPlayer
PlaceId = game.PlaceId

sett:AddButton({
	Title = "Server Hop",
	Callback = function()
		TeleportService:Teleport(PlaceId, Player)
	end
})

web = Tabs.Webhook:AddSection("Webhook Discord")

local b = ""
local c = "https://discord.com/api/webhooks/1468908646879592479/fNzpf3CUR018A8LmXM1iOC_jP-3NVdfHGw2wKYbfep2Utj8svRZXVaeefOInSRFfFcin"
local d = false
local e = true
local f = {"Legendary", "Mythic", "SECRET"}
local g = {"SECRET", "TROPHY", "COLLECTIBLE", "DEV"}
local h = game:GetService("HttpService")
local i = game:GetService("ReplicatedStorage")
local j = game:GetService("Players")
local k = j.LocalPlayer
local l = require(i.Shared.ItemUtility)
local m = require(i.Packages.Replion)
local n = {}
local o = {}
local p = {}
local function q(r)
local s = {
[1] = "Common",
[2] = "Uncommon",
[3] = "Rare",
[4] = "Epic",
[5] = "Legendary",
[6] = "Mythic",
[7] = "SECRET"
}
return s[r] or "Common"
end
local function t()
local u = i:FindFirstChild("Items")
if not u then
return 0
end
local v = 0
for w, x in pairs(u:GetDescendants()) do
if x:IsA("ModuleScript") then
local y, z =
pcall(
function()
return require(x)
end
)
if y and z then
local A = z.Data or z
if A and type(A) == "table" and A.Id and A.Name then
v = v + 1
n[A.Id] = A.Name
o[A.Id] = A.Tier or 1
if z.SellPrice then
p[A.Id] = z.SellPrice
elseif A.SellPrice then
p[A.Id] = A.SellPrice
else
p[A.Id] = 0
end
end
end
end
end
return v
end
task.spawn(t)
local B = {}
local C = 0
local D = 0
local E = 0.5
local function F(G)
if not G or type(G) ~= "string" or #G < 1 then
return "Unknown"
end
if #G <= 3 then
return G
end
local H = G:sub(1, 3)
local I = #G - 3
local J = string.rep("*", I)
return H .. J
end
local function K(L)
L = tonumber(L)
if not L then
return "0"
end
L = math.floor(L)
local M = tostring(L):reverse():gsub("%d%d%d", "%1."):reverse()
return M:gsub("^%.", "")
end
local function N()
local y, O =
pcall(
function()
if m and m.Client then
local P = m.Client:WaitReplion("Data", 2)
if P then
local Q = P:Get("Coins")
if Q then
return Q
end
local R = P:Get("Currency")
if R and type(R) == "table" then
return R.Coins or R.Gold or R.Money or 0
end
end
end
local S = k:FindFirstChild("leaderstats")
if S then
local T =
S:FindFirstChild("C$") or S:FindFirstChild("Coins") or S:FindFirstChild("Gold") or
S:FindFirstChild("Money")
if T then
return T.Value
end
end
return 0
end
)
if y then
return O or 0
else
return 0
end
end
local function U(V)
local W = V:upper()
if W == "SECRET" then
return 16711935
end
if W == "MYTHIC" then
return 16753920
end
if W == "LEGENDARY" then
return 16776960
end
if W == "EPIC" then
return 8388736
end
if W == "RARE" then
return 255
end
if W == "UNCOMMON" then
return 65280
end
return 16777215
end
local function X(Y)
local Z = {
["Common"] = "<a:jj:1306049474707329075>",
["Uncommon"] = "<a:jj:1306049474707329075>",
["Rare"] = "<a:jj:1306049474707329075>",
["Epic"] = "<a:jj:1306049474707329075>",
["Legendary"] = "<a:jj:1306049474707329075>",
["Mythic"] = "<a:jj:1306049474707329075>",
["SECRET"] = "<a:jj:1306049474707329075>"
}
return Z[Y] or "🎣"
end
local function _(a0)
if not a0 or a0 == 0 then
return "https://tr.rbxcdn.com/53eb9b170bea9855c45c9356fb33c070/420/420/Image/Png"
end
if B[a0] then
return B[a0]
end
local a1 =
string.format(
"https://thumbnails.roblox.com/v1/assets?assetIds=%d&size=420x420&format=Png&isCircular=false",
a0
)
local y, a2 =
pcall(
function()
return game:HttpGet(a1, true)
end
)
if y then
local a3, A = pcall(h.JSONDecode, h, a2)
if a3 and A and A.data and A.data[1] and A.data[1].imageUrl then
local a4 = A.data[1].imageUrl
B[a0] = a4
return a4
end
end
return "https://tr.rbxcdn.com/53eb9b170bea9855c45c9356fb33c070/420/420/Image/Png"
end
local function a5(a1, a6)
if a1 == "" or not a1:find("https://discord.com/api/webhooks/") then
return false
end
local a7 = tick()
if a7 - C < E then
return false
end
C = a7
local y, a8 =
pcall(
function()
local a9 = {
username = "Nateria Hub | Community",
avatar_url = "https://cdn.discordapp.com/attachments/1441274833165095014/1468610027341484185/Screenshot_20260204_140045_Google.jpg?ex=6984a52b&is=698353ab&hm=eecf37a3897fe636d2b53603253aaae3448a34678943958b099d2d04379b7736",
embeds = {a6}
}
local aa = h:JSONEncode(a9)
local ab
if syn and syn.request then
ab = syn.request
elseif http and http.request then
ab = http.request
elseif request then
ab = request
elseif fluxus and fluxus.request then
ab = fluxus.request
elseif http_request then
ab = http_request
else
return false
end
if not ab then
return false
end
local a2 = ab({Url = a1, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = aa})
if a2 then
local ac = a2.StatusCode or a2.status or a2.Code
if ac then
if ac == 204 or ac == 200 then
return true
else
return false
end
else
if type(a2) == "string" then
return true
end
return false
end
else
return false
end
end
)
if not y then
return false
end
return true
end
local function ad(a1, a6)
if a1 == "" or not a1:find("https://discord.com/api/webhooks/") then
return false
end
local a7 = tick()
if a7 - D < E then
return false
end
D = a7
local y, a8 =
pcall(
function()
local a9 = {
username = "Nateria Hub | Community",
avatar_url = "https://cdn.discordapp.com/attachments/1441274833165095014/1468610027341484185/Screenshot_20260204_140045_Google.jpg?ex=6984a52b&is=698353ab&hm=eecf37a3897fe636d2b53603253aaae3448a34678943958b099d2d04379b7736",
embeds = {a6}
}
local aa = h:JSONEncode(a9)
local ab
if syn and syn.request then
ab = syn.request
elseif http and http.request then
ab = http.request
elseif request then
ab = request
elseif fluxus and fluxus.request then
ab = fluxus.request
elseif http_request then
ab = http_request
else
return false
end
if not ab then
return false
end
local a2 = ab({Url = a1, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = aa})
if a2 then
local ac = a2.StatusCode or a2.status or a2.Code
if ac then
if ac == 204 or ac == 200 then
return true
else
return false
end
else
if type(a2) == "string" then
return true
end
return false
end
else
return false
end
end
)
if not y then
return false
end
return true
end
local function ae(af, ag, z, ah)
if not af then
return
end
local ai = n[af] or "Unknown Fish"
local r = o[af] or 1
local aj = q(r)
local ak
local y, a8 =
pcall(
function()
ak = l:GetItemData(af)
end
)
local al = ai
local am = aj
local an = p[af] or 0
if y and ak then
if ak.Data and ak.Data.Name then
al = ak.Data.Name
end
if ak.SellPrice then
an = ak.SellPrice
end
end
if z and z.InventoryItem and z.InventoryItem.Metadata then
local ao = z.InventoryItem.Metadata.Rarity
if ao and ao ~= "" then
am = ao
end
end
am = string.upper(am)
if am == "SECRET" or am == "7" then
am = "SECRET"
elseif am == "MYTHIC" or am == "6" then
am = "Mythic"
elseif am == "LEGENDARY" or am == "5" then
am = "Legendary"
elseif am == "EPIC" or am == "4" then
am = "Epic"
elseif am == "RARE" or am == "3" then
am = "Rare"
elseif am == "UNCOMMON" or am == "2" then
am = "Uncommon"
else
am = "Common"
end
local ap = ag and ag.Weight or 0
local aq = ag and ag.SellMultiplier or 1
local ar = math.floor(an * aq)
local as = "Normal"
if ag then
if ag.Shiny then
as = "✨ Shiny"
elseif ag.Albino then
as = "⚪"
elseif ag.Golden then
as = "🌟"
elseif ag.Rainbow then
as = "🌈"
elseif ag.Crystal then
as = "💎"
elseif ag.VariantId then
as = "🧬" .. tostring(ag.VariantId)
end
end
local a0 = 0
if y and ak and ak.Data then
if ak.Data.Icon then
a0 = tonumber(string.match(tostring(ak.Data.Icon), "%d+")) or 0
elseif ak.Data.ImageId then
a0 = tonumber(ak.Data.ImageId) or 0
end
end
local at = _(a0)
local Q = N()
local au = k.DisplayName or k.Name
if d and b ~= "" then
local av = false
for w, aw in ipairs(f) do
if string.upper(aw) == string.upper(am) then
av = true
break
end
end
if av then
local ax = X(am)
local ay = {
title = ax .. " Private Catch: " .. al,
color = U(am),
fields = {
{name = "**Rarity**", value = am, inline = true},
{name = "**Weight**", value = string.format("%.2f kg", ap), inline = true},
{name = "**Mutation**", value = as, inline = true},
{name = "**Value**", value = "$" .. K(ar), inline = true},
{name = "**Coins**", value = "$" .. K(Q), inline = true},
{name = "**Player**", value = "||" .. au .. "||", inline = true}
},
thumbnail = {url = at},
footer = {text = "Nateria Hub | Private Log"},
timestamp = DateTime.now():ToIsoDate()
}
a5(b, ay)
end
end
if e and c ~= "" then
local az = false
for w, aw in ipairs(g) do
if string.upper(aw) == string.upper(am) then
az = true
break
end
end
if az then
local aA = F(au)
local ax = X(am)
local aB = {
title = ax .. " Global Catch Alert!",
description = "**Someone just caught a " .. al .. "!**",
color = U(am),
fields = {
{name = "<a:arrow:1306059259615903826> Fish", value = al, inline = true},
{name = "<a:arrow:1306059259615903826> Rarity", value = am, inline = true},
{name = "<a:arrow:1306059259615903826> Weight", value = string.format("%.2f kg", ap), inline = true},
{name = "<a:arrow:1306059259615903826> Mutation", value = as, inline = true},
{name = "<a:arrow:1306059259615903826> Value", value = "$" .. K(ar), inline = true},
{name = "<a:arrow:1306059259615903826> Fisherman", value = aA, inline = true}
},
thumbnail = {url = at},
footer = {text = "Nateria Hub | Global Tracker"},
timestamp = DateTime.now():ToIsoDate()
}
ad(c, aB)
end
end
end

local function convertDropdownTable(fluentTable)
    local array = {}
    if not fluentTable then return array end
    
    for value, isSelected in pairs(fluentTable) do
        if isSelected then
            table.insert(array, value)
        end
    end
    return array
end

local aC = web:AddInput({
    Title = "Private Webhook URL",
    Placeholder = "https://discord.com/api/webhooks/...",
    Callback = function(v)
        if v and v ~= "" then
            b = v
        end
    end
})

local aE = web:AddDropdown({
    Title = "Private Notify Tiers",
    Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "SECRET"},
    Multi = true,
    Value = {"SECRET"},
    Callback = function(selectedTable)
        f = selectedTable
    end
})

local aF = web:AddToggle({
    Title = "Enable Private Webhook",
    Default = false,
    Callback = function(aG)
        d = aG
    end
})

web:AddButton({
    Title = "Test Private Webhook",
    Callback = function()
        if not d or b == "" then
            Nt("Private Webhook Is Not Enabled Or Url Empty.")
            return
        end
        local Q = N()
        local aI = {
            title = "🎣 Test Notification",
            description = "Webhook is working correctly!",
            color = 65535,
            fields = {
                {name = "<a:arrow:1306059259615903826> User", value = k.DisplayName or k.Name, inline = true},
                {name = "<a:arrow:1306059259615903826> Coins", value = "$" .. K(Q), inline = true},
                {name = "<a:arrow:1306059259615903826> Status", value = "Connected", inline = true},
                {
                    name = "<a:arrow:1306059259615903826> Test Tier",
                    value = "All tiers should work now",
                    inline = true
                }
            },
            footer = {text = "Nateria Hub | Test Message"},
            timestamp = DateTime.now():ToIsoDate()
        }
        local y = a5(b, aI)
        if y then
            Nt("Success! Test message sent to your webhook.")
        else
           Nt("Failed! Check Discord Webhook Url.")
        end
    end
})

t()
local function aJ()
local function aK()
local aL = i:FindFirstChild("Packages")
if aL then
local aM = aL:FindFirstChild("_Index")
if aM then
local aN = aM:FindFirstChild("sleitnick_net@0.2.0")
if aN then
local aO = aN:FindFirstChild("net")
if aO then
local aP =
aO:FindFirstChild("RE/ObtainedNewFishNotification") or aO:FindFirstChild("RE/FishCaught") or
aO:FindFirstChild("RE/CatchFish")
if aP then
return aP
end
end
end
local aQ = aM:FindFirstChild("cemstone_net@0.2.1")
if aQ then
local aO = aQ:FindFirstChild("net")
if aO then
local aP =
aO:FindFirstChild("RE/ObtainedNewFishNotification") or aO:FindFirstChild("RE/FishCaught")
if aP then
return aP
end
end
end
end
end
local aR = i:FindFirstChild("Events")
if aR then
local aP =
aR:FindFirstChild("FishCaught") or aR:FindFirstChild("ObtainedNewFish") or
aR:FindFirstChild("CatchFish")
if aP then
return aP
end
end
return nil
end
local aS = aK()
if aS then
if _G.WebhookConnection then
_G.WebhookConnection:Disconnect()
_G.WebhookConnection = nil
end
_G.WebhookConnection =
aS.OnClientEvent:Connect(
function(...)
local aT = {...}
if #aT >= 2 then
local af, ag, z
for aU, aV in ipairs(aT) do
if type(aV) == "table" then
if aV.Weight then
ag = aV
elseif aV.InventoryItem then
z = aV
end
elseif type(aV) == "number" then
af = aV
end
end
if not af then
for w, aV in ipairs(aT) do
if type(aV) == "number" and aV > 0 then
af = aV
break
end
end
end
if af then
pcall(
function()
ae(af, ag or {}, z or {}, true)
end
)
end
end
end
)
end
end
aJ()
task.delay(
3,
function()
aJ()
end
)
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(
function()
task.wait(2)
aJ()
end
)

--// ANTI AFK 
local VIM=game:GetService("VirtualInputManager")
task.spawn(function()
 while true do
  task.wait(math.random(600,700))
  local k={{Enum.KeyCode.LeftShift,Enum.KeyCode.E},{Enum.KeyCode.LeftControl,Enum.KeyCode.F},{Enum.KeyCode.LeftShift,Enum.KeyCode.Q},{Enum.KeyCode.E,Enum.KeyCode.F}}
  local c=k[math.random(#k)]
  pcall(function()
   for _,x in pairs(c)do VIM:SendKeyEvent(true,x,false,nil)end
   task.wait(.1)
   for _,x in pairs(c)do VIM:SendKeyEvent(false,x,false,nil)end
  end)
 end
end)

if Window then
    Nt("Thank For Using Nateira Hub Freemium!")
end


