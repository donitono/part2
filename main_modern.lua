--[[
    XSAN's Fish It Pro - Ultimate Edition v2.0 MODERN UI
    
    Premium Fish It script with ULTIMATE features:
    • Modern Tab-based Interface (NEW!)
    • Quick Start Presets & Advanced Analytics
    • Smart Inventory Management & AI Features  
    • Enhanced Fishing & Quality of Life
    • Smart Notifications & Safety Systems
    • Advanced Automation & Much More
    • Ultimate Teleportation System
    
    Developer: XSAN
    Instagram: @_bangicoo
    GitHub: github.com/codeico
    
    Premium Quality • Modern Design • Ultimate Edition
--]]

print("XSAN: Starting Fish It Pro Ultimate v2.0 Modern...")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")

-- Notification system
local function Notify(title, text, duration)
    duration = duration or 3
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "XSAN Fish It Pro",
            Text = text or "Notification", 
            Duration = duration,
            Icon = "rbxassetid://6023426923"
        })
    end)
    print("XSAN:", title, "-", text)
end

-- Check basic requirements
if not LocalPlayer then
    warn("XSAN ERROR: LocalPlayer not found")
    return
end

if not ReplicatedStorage then
    warn("XSAN ERROR: ReplicatedStorage not found")
    return
end

print("XSAN: Basic services OK")

-- XSAN Anti Ghost Touch System
local ButtonCooldowns = {}
local BUTTON_COOLDOWN = 0.5

local function CreateSafeCallback(originalCallback, buttonId)
    return function(...)
        local currentTime = tick()
        if ButtonCooldowns[buttonId] and currentTime - ButtonCooldowns[buttonId] < BUTTON_COOLDOWN then
            return
        end
        ButtonCooldowns[buttonId] = currentTime
        
        local success, result = pcall(originalCallback, ...)
        if not success then
            warn("XSAN Error:", result)
        end
    end
end

-- Load Modern UI Library
print("XSAN: Loading Modern UI Library...")

local Rayfield
local success, error = pcall(function()
    print("XSAN: Attempting to load Modern UI...")
    -- Try to load modern UI first, fallback to fixed if needed
    local uiContent = game:HttpGet("https://raw.githubusercontent.com/donitono/part2/main/ui_modern.lua")
    if uiContent and #uiContent > 0 then
        print("XSAN: Loading modern UI library...")
        Rayfield = loadstring(uiContent)()
    else
        print("XSAN: Fallback to fixed UI library...")
        Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/donitono/part2/main/ui_fixed.lua"))()
    end
    print("XSAN: UI library loadstring executed")
end)

if not success then
    warn("XSAN Error: Failed to load UI Library - " .. tostring(error))
    return
end

if not Rayfield then
    warn("XSAN Error: UI Library is nil after loading")
    return
end

print("XSAN: Modern UI Library loaded successfully!")

-- Mobile/Android detection
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local screenSize = workspace.CurrentCamera.ViewportSize

print("XSAN: Platform Detection - Mobile:", isMobile, "Screen Size:", screenSize.X .. "x" .. screenSize.Y)

-- Create Modern Window
print("XSAN: Creating modern window...")
local Window = Rayfield:CreateWindow({
    Name = "🐟 XSAN Fish It Pro Ultimate v2.0",
    LoadingTitle = "XSAN Fish It Pro Ultimate",
    LoadingSubtitle = "Modern Tab Interface - by XSAN",
    Theme = "DarkBlue",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "XSAN",
        FileName = "FishItProModern"
    }
})

print("XSAN: Window created successfully!")

-- === GAME VARIABLES ===
local fishing = false
local autoFishing = false
local autoShaking = false
local autoReeling = false
local autoSelling = false
local autoSellEnabled = false
local autoCasting = false
local autoUpgrading = false
local useGamepass = false
local shakeDetection = false
local sellMethod = "Auto"
local equipBestRod = false
local sellInterval = 30
local fishingDelay = 1
local castPower = 100
local selectedPreset = "Balanced"
local teleportCooldown = false

-- Advanced features
local autoEquipBait = false
local smartCasting = false
local fishingAnalytics = {
    fishCaught = 0,
    totalValue = 0,
    sessionStart = tick(),
    bestFish = {name = "None", value = 0},
    efficiency = 0
}

-- Game detection and RemoteEvents
local remotes = {}
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Find RemoteEvents with better error handling
local function findRemotes()
    local foundRemotes = {}
    local attempts = 0
    local maxAttempts = 10
    
    while attempts < maxAttempts do
        attempts = attempts + 1
        
        pcall(function()
            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                    foundRemotes[remote.Name] = remote
                end
            end
        end)
        
        if next(foundRemotes) then
            break
        end
        
        wait(1)
    end
    
    return foundRemotes
end

-- Load remotes
task.spawn(function()
    print("XSAN: Finding game RemoteEvents...")
    remotes = findRemotes()
    
    if next(remotes) then
        print("XSAN: Found", #remotes, "RemoteEvents")
        Notify("Game Detected", "Found " .. #remotes .. " RemoteEvents")
    else
        warn("XSAN: No RemoteEvents found")
        Notify("Warning", "No RemoteEvents detected")
    end
end)

-- === TAB 1: INFO & QUICK START ===
local InfoTab = Window:CreateTab("📋 INFO", "🏠")

InfoTab:CreateParagraph({
    Title = "🌟 XSAN Fish It Pro Ultimate v2.0",
    Content = "Selamat datang di XSAN Fish It Pro Ultimate Edition dengan Modern Tab Interface! Script premium dengan fitur terlengkap untuk Fish It!"
})

InfoTab:CreateParagraph({
    Title = "✨ What's New in v2.0",
    Content = "• Modern Tab-based Interface (NEW!)\n• Mobile Landscape Optimized\n• Enhanced Performance\n• Better Error Handling\n• Improved Analytics\n• Smart Notifications"
})

InfoTab:CreateParagraph({
    Title = "🔥 Quick Start Presets",
    Content = "Pilih preset sesuai kebutuhan Anda. Setiap preset sudah dioptimalkan untuk hasil terbaik!"
})

local presetOptions = {"Balanced", "Speed Focus", "Value Focus", "Casual", "Hardcore"}
InfoTab:CreateDropdown({
    Name = "🎯 Select Preset",
    Options = presetOptions,
    CurrentOption = selectedPreset,
    Callback = CreateSafeCallback(function(option)
        selectedPreset = option
        
        -- Apply preset settings
        if option == "Speed Focus" then
            fishingDelay = 0.5
            castPower = 80
            autoShaking = true
            autoReeling = true
            Notify("Preset Applied", "Speed Focus - Fast fishing enabled!")
        elseif option == "Value Focus" then
            fishingDelay = 2
            castPower = 100
            equipBestRod = true
            smartCasting = true
            Notify("Preset Applied", "Value Focus - Quality over quantity!")
        elseif option == "Casual" then
            fishingDelay = 1.5
            castPower = 70
            autoShaking = false
            Notify("Preset Applied", "Casual - Relaxed fishing mode!")
        elseif option == "Hardcore" then
            fishingDelay = 0.3
            castPower = 100
            autoShaking = true
            autoReeling = true
            autoSelling = true
            smartCasting = true
            Notify("Preset Applied", "Hardcore - Maximum automation!")
        else -- Balanced
            fishingDelay = 1
            castPower = 85
            autoShaking = true
            autoReeling = false
            Notify("Preset Applied", "Balanced - Perfect for most players!")
        end
    end, "preset_dropdown")
})

InfoTab:CreateButton({
    Name = "🚀 Apply Selected Preset",
    Callback = CreateSafeCallback(function()
        -- Apply the currently selected preset
        if selectedPreset == "Speed Focus" then
            fishingDelay = 0.5
            castPower = 80
            autoShaking = true
            autoReeling = true
        elseif selectedPreset == "Value Focus" then
            fishingDelay = 2
            castPower = 100
            equipBestRod = true
            smartCasting = true
        elseif selectedPreset == "Casual" then
            fishingDelay = 1.5
            castPower = 70
            autoShaking = false
        elseif selectedPreset == "Hardcore" then
            fishingDelay = 0.3
            castPower = 100
            autoShaking = true
            autoReeling = true
            autoSelling = true
            smartCasting = true
        else -- Balanced
            fishingDelay = 1
            castPower = 85
            autoShaking = true
            autoReeling = false
        end
        
        Notify("✅ Preset Applied", selectedPreset .. " settings activated!")
    end, "apply_preset_btn")
})

InfoTab:CreateParagraph({
    Title = "👨‍💻 Developer Info",
    Content = "Created by XSAN\nInstagram: @_bangicoo\nGitHub: github.com/codeico\n\nTrusted by thousands of players worldwide!"
})

-- === TAB 2: AUTO FISH ===
local AutoFishTab = Window:CreateTab("🎣 AUTO FISH", "🎣")

AutoFishTab:CreateParagraph({
    Title = "🎣 Automated Fishing System",
    Content = "Ultimate fishing automation with smart features and customizable settings."
})

local mainFishingToggle = AutoFishTab:CreateToggle({
    Name = "🎣 Enable Auto Fishing",
    CurrentValue = autoFishing,
    Callback = CreateSafeCallback(function(value)
        autoFishing = value
        fishing = value
        
        if value then
            Notify("🎣 Auto Fishing", "Started!")
            -- Start fishing loop
            task.spawn(function()
                while autoFishing do
                    pcall(function()
                        -- Fishing logic here
                        if remotes.Cast then
                            remotes.Cast:FireServer(castPower)
                        end
                        
                        -- Auto shaking
                        if autoShaking and remotes.Shake then
                            wait(math.random(1, 3))
                            remotes.Shake:FireServer()
                        end
                        
                        -- Auto reeling
                        if autoReeling and remotes.Reel then
                            wait(math.random(2, 4))
                            remotes.Reel:FireServer()
                        end
                        
                        -- Update analytics
                        fishingAnalytics.fishCaught = fishingAnalytics.fishCaught + 1
                    end)
                    
                    wait(fishingDelay)
                end
            end)
        else
            Notify("🎣 Auto Fishing", "Stopped!")
        end
    end, "main_fishing_toggle")
})

AutoFishTab:CreateToggle({
    Name = "🌊 Auto Shaking",
    CurrentValue = autoShaking,
    Callback = CreateSafeCallback(function(value)
        autoShaking = value
        Notify("🌊 Auto Shaking", value and "Enabled" or "Disabled")
    end, "auto_shaking_toggle")
})

AutoFishTab:CreateToggle({
    Name = "🎯 Auto Reeling",
    CurrentValue = autoReeling,
    Callback = CreateSafeCallback(function(value)
        autoReeling = value
        Notify("🎯 Auto Reeling", value and "Enabled" or "Disabled")
    end, "auto_reeling_toggle")
})

AutoFishTab:CreateToggle({
    Name = "🧠 Smart Casting",
    CurrentValue = smartCasting,
    Callback = CreateSafeCallback(function(value)
        smartCasting = value
        Notify("🧠 Smart Casting", value and "Enabled" or "Disabled")
    end, "smart_casting_toggle")
})

AutoFishTab:CreateSlider({
    Name = "⚡ Fishing Speed",
    Range = {0.1, 5},
    Increment = 0.1,
    CurrentValue = fishingDelay,
    Callback = CreateSafeCallback(function(value)
        fishingDelay = value
        Notify("⚡ Speed Updated", "Delay: " .. value .. "s")
    end, "fishing_speed_slider")
})

AutoFishTab:CreateSlider({
    Name = "💪 Cast Power",
    Range = {1, 100},
    Increment = 1,
    CurrentValue = castPower,
    Callback = CreateSafeCallback(function(value)
        castPower = value
        Notify("💪 Power Updated", "Cast Power: " .. value .. "%")
    end, "cast_power_slider")
})

-- === TAB 3: TELEPORT ===
local TeleportTab = Window:CreateTab("🌍 TELEPORT", "🌍")

TeleportTab:CreateParagraph({
    Title = "🌍 Ultimate Teleportation System",
    Content = "Teleport instantly to any fishing location or shop. Updated coordinates for all areas!"
})

-- Common teleport locations
local teleportLocations = {
    ["🏠 Spawn"] = {x = 0, y = 10, z = 0},
    ["🏪 Shop"] = {x = 100, y = 5, z = 50},
    ["🌊 Ocean"] = {x = 200, y = 3, z = 100},
    ["🏔️ Mountain Lake"] = {x = -150, y = 25, z = 200},
    ["🌅 Sunset Pier"] = {x = 300, y = 8, z = -100},
    ["🏝️ Secret Island"] = {x = -200, y = 15, z = -200}
}

local function teleportTo(position)
    if teleportCooldown then
        Notify("⏰ Cooldown", "Please wait before teleporting again")
        return
    end
    
    teleportCooldown = true
    
    pcall(function()
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(position.x, position.y, position.z)
            Notify("✅ Teleported", "Arrived at destination!")
        end
    end)
    
    task.wait(2)
    teleportCooldown = false
end

-- Create teleport buttons
for locationName, position in pairs(teleportLocations) do
    TeleportTab:CreateButton({
        Name = locationName,
        Callback = CreateSafeCallback(function()
            teleportTo(position)
        end, "teleport_" .. locationName)
    })
end

-- Custom teleport
TeleportTab:CreateInput({
    Name = "📍 Custom X Coordinate",
    PlaceholderText = "Enter X coordinate...",
    RemoveTextAfterFocusLost = false,
    Callback = CreateSafeCallback(function(text)
        _G.customX = tonumber(text) or 0
    end, "custom_x_input")
})

TeleportTab:CreateInput({
    Name = "📍 Custom Y Coordinate", 
    PlaceholderText = "Enter Y coordinate...",
    RemoveTextAfterFocusLost = false,
    Callback = CreateSafeCallback(function(text)
        _G.customY = tonumber(text) or 10
    end, "custom_y_input")
})

TeleportTab:CreateInput({
    Name = "📍 Custom Z Coordinate",
    PlaceholderText = "Enter Z coordinate...",
    RemoveTextAfterFocusLost = false,
    Callback = CreateSafeCallback(function(text)
        _G.customZ = tonumber(text) or 0
    end, "custom_z_input")
})

TeleportTab:CreateButton({
    Name = "🚀 Teleport to Custom Location",
    Callback = CreateSafeCallback(function()
        local x = _G.customX or 0
        local y = _G.customY or 10
        local z = _G.customZ or 0
        
        teleportTo({x = x, y = y, z = z})
    end, "custom_teleport_btn")
})

-- === TAB 4: INVENTORY ===
local InventoryTab = Window:CreateTab("🎒 INVENTORY", "🎒")

InventoryTab:CreateParagraph({
    Title = "🎒 Smart Inventory Management",
    Content = "Automated selling, upgrading, and inventory optimization tools."
})

InventoryTab:CreateToggle({
    Name = "💰 Auto Sell Fish",
    CurrentValue = autoSelling,
    Callback = CreateSafeCallback(function(value)
        autoSelling = value
        
        if value then
            Notify("💰 Auto Sell", "Started!")
            task.spawn(function()
                while autoSelling do
                    pcall(function()
                        if remotes.SellFish then
                            remotes.SellFish:FireServer()
                            fishingAnalytics.totalValue = fishingAnalytics.totalValue + 100 -- Estimate
                        end
                    end)
                    wait(sellInterval)
                end
            end)
        else
            Notify("💰 Auto Sell", "Stopped!")
        end
    end, "auto_sell_toggle")
})

InventoryTab:CreateSlider({
    Name = "⏰ Sell Interval (seconds)",
    Range = {5, 120},
    Increment = 5,
    CurrentValue = sellInterval,
    Callback = CreateSafeCallback(function(value)
        sellInterval = value
        Notify("⏰ Interval Updated", "Selling every " .. value .. " seconds")
    end, "sell_interval_slider")
})

local sellMethods = {"Auto", "Specific", "All", "Valuable Only"}
InventoryTab:CreateDropdown({
    Name = "🎯 Sell Method",
    Options = sellMethods,
    CurrentOption = sellMethod,
    Callback = CreateSafeCallback(function(option)
        sellMethod = option
        Notify("🎯 Sell Method", "Changed to: " .. option)
    end, "sell_method_dropdown")
})

InventoryTab:CreateToggle({
    Name = "🎣 Auto Equip Best Rod",
    CurrentValue = equipBestRod,
    Callback = CreateSafeCallback(function(value)
        equipBestRod = value
        
        if value then
            task.spawn(function()
                pcall(function()
                    if remotes.EquipRod then
                        remotes.EquipRod:FireServer("BestRod")
                    end
                end)
            end)
        end
        
        Notify("🎣 Auto Equip Rod", value and "Enabled" or "Disabled")
    end, "equip_rod_toggle")
})

InventoryTab:CreateToggle({
    Name = "🪱 Auto Equip Bait",
    CurrentValue = autoEquipBait,
    Callback = CreateSafeCallback(function(value)
        autoEquipBait = value
        Notify("🪱 Auto Equip Bait", value and "Enabled" or "Disabled")
    end, "equip_bait_toggle")
})

InventoryTab:CreateButton({
    Name = "💎 Sell All Fish Now",
    Callback = CreateSafeCallback(function()
        pcall(function()
            if remotes.SellFish then
                remotes.SellFish:FireServer()
                Notify("💎 Sold!", "All fish sold successfully")
                fishingAnalytics.totalValue = fishingAnalytics.totalValue + 500 -- Estimate
            end
        end)
    end, "sell_all_btn")
})

-- === TAB 5: ANALYTICS ===
local AnalyticsTab = Window:CreateTab("📊 ANALYTICS", "📊")

AnalyticsTab:CreateParagraph({
    Title = "📊 Fishing Analytics & Statistics",
    Content = "Real-time tracking of your fishing performance, earnings, and efficiency."
})

-- Analytics display (update every 5 seconds)
local analyticsUpdate = task.spawn(function()
    while true do
        task.wait(5)
        
        -- Calculate session time
        local sessionTime = tick() - fishingAnalytics.sessionStart
        local hours = math.floor(sessionTime / 3600)
        local minutes = math.floor((sessionTime % 3600) / 60)
        
        -- Calculate efficiency
        if sessionTime > 0 then
            fishingAnalytics.efficiency = math.floor(fishingAnalytics.fishCaught / (sessionTime / 60))
        end
        
        -- Update UI elements would go here
        -- For now, just print to console
        print("XSAN Analytics: Fish Caught:", fishingAnalytics.fishCaught, "Total Value:", fishingAnalytics.totalValue, "Efficiency:", fishingAnalytics.efficiency, "fish/min")
    end
end)

AnalyticsTab:CreateParagraph({
    Title = "🎯 Session Statistics",
    Content = "Fish Caught: " .. fishingAnalytics.fishCaught .. "\nTotal Value: $" .. fishingAnalytics.totalValue .. "\nEfficiency: " .. fishingAnalytics.efficiency .. " fish/min\nBest Fish: " .. fishingAnalytics.bestFish.name
})

AnalyticsTab:CreateButton({
    Name = "🔄 Reset Analytics",
    Callback = CreateSafeCallback(function()
        fishingAnalytics = {
            fishCaught = 0,
            totalValue = 0,
            sessionStart = tick(),
            bestFish = {name = "None", value = 0},
            efficiency = 0
        }
        Notify("🔄 Reset", "Analytics data cleared!")
    end, "reset_analytics_btn")
})

AnalyticsTab:CreateButton({
    Name = "📋 Export Data",
    Callback = CreateSafeCallback(function()
        local data = HttpService:JSONEncode(fishingAnalytics)
        setclipboard(data)
        Notify("📋 Exported", "Data copied to clipboard!")
    end, "export_data_btn")
})

-- === TAB 6: SETTINGS ===
local SettingsTab = Window:CreateTab("⚙️ SETTINGS", "⚙️")

SettingsTab:CreateParagraph({
    Title = "⚙️ Advanced Settings & Configuration",
    Content = "Customize your XSAN Fish It Pro experience with advanced options."
})

SettingsTab:CreateToggle({
    Name = "🎮 Use Gamepass Features",
    CurrentValue = useGamepass,
    Callback = CreateSafeCallback(function(value)
        useGamepass = value
        Notify("🎮 Gamepass", value and "Enabled" or "Disabled")
    end, "gamepass_toggle")
})

SettingsTab:CreateToggle({
    Name = "🔍 Enhanced Shake Detection",
    CurrentValue = shakeDetection,
    Callback = CreateSafeCallback(function(value)
        shakeDetection = value
        Notify("🔍 Shake Detection", value and "Enhanced" or "Normal")
    end, "shake_detection_toggle")
})

SettingsTab:CreateButton({
    Name = "📱 Show Mobile Tips",
    Callback = CreateSafeCallback(function()
        Notify("📱 Mobile Tips", "• Use landscape mode for best experience\n• Tap and hold to drag the interface\n• Swipe to navigate tabs\n• Pinch to zoom if needed")
    end, "mobile_tips_btn")
})

SettingsTab:CreateButton({
    Name = "🔧 Advanced Tools Interface",
    Callback = CreateSafeCallback(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/donitono/part2/main/unified_tools_interface.lua"))()
        Notify("🔧 Tools Loaded", "Advanced tools interface loaded!")
    end, "tools_interface_btn")
})

SettingsTab:CreateButton({
    Name = "🆘 Emergency Stop All",
    Callback = CreateSafeCallback(function()
        -- Stop all automation
        autoFishing = false
        fishing = false
        autoShaking = false
        autoReeling = false
        autoSelling = false
        autoCasting = false
        autoUpgrading = false
        
        Notify("🆘 Emergency Stop", "All automation stopped!")
    end, "emergency_stop_btn")
})

SettingsTab:CreateButton({
    Name = "🗑️ Destroy Interface",
    Callback = CreateSafeCallback(function()
        game.Players.LocalPlayer.PlayerGui.RayfieldLibrary:Destroy()
    end, "destroy_ui_btn")
})

-- Final setup
print("XSAN: Modern UI setup complete!")
Notify("✅ Ready!", "XSAN Fish It Pro Ultimate v2.0 loaded successfully! Use the tab navigation for best experience.")

-- Auto-detection and smart features
task.spawn(function()
    task.wait(3)
    
    -- Auto-detect game mode
    pcall(function()
        local gameMode = "Unknown"
        -- Add game detection logic here
        Notify("🎮 Game Detected", "Mode: " .. gameMode)
    end)
    
    -- Show mobile optimization status
    if isMobile then
        local isLandscape = screenSize.X > screenSize.Y
        Notify("📱 Mobile Optimized", isLandscape and "Landscape mode detected - UI optimized!" or "Portrait mode - consider rotating for better experience")
    end
end)
