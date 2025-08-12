-- Buy System Detector
-- Script untuk mendeteksi dan memantau sistem pembelian dalam game
-- Berdasarkan analisis location_detector_new.lua

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Create GUI
local CoreGui = game:GetService("CoreGui")
local screen = Instance.new("ScreenGui")
screen.Name = "BuySystemDetector"
screen.Parent = CoreGui

-- Main frame
local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 450, 0, 400)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Make frame draggable
local dragging = false
local dragStart = nil
local startPos = nil

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "🛒 Buy System Detector & Monitor"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16

-- Scroll frame for content
local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1, -20, 1, -80)
scrollFrame.Position = UDim2.new(0, 10, 0, 35)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 8

-- Info label
local infoLabel = Instance.new("TextLabel", scrollFrame)
infoLabel.Size = UDim2.new(1, 0, 0, 350)
infoLabel.Position = UDim2.new(0, 0, 0, 0)
infoLabel.Text = "Memindai sistem pembelian...\nMendeteksi NPC dan RemoteEvents..."
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 12
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top

-- Copy button
local copyBtn = Instance.new("TextButton", frame)
copyBtn.Size = UDim2.new(0, 100, 0, 30)
copyBtn.Position = UDim2.new(0, 10, 1, -40)
copyBtn.Text = "Copy Info"
copyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Font = Enum.Font.SourceSans
copyBtn.TextSize = 14
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)

-- Refresh button
local refreshBtn = Instance.new("TextButton", frame)
refreshBtn.Size = UDim2.new(0, 100, 0, 30)
refreshBtn.Position = UDim2.new(0, 120, 1, -40)
refreshBtn.Text = "Refresh"
refreshBtn.BackgroundColor3 = Color3.fromRGB(70, 150, 70)
refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshBtn.Font = Enum.Font.SourceSans
refreshBtn.TextSize = 14
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 6)

-- Monitor button
local monitorBtn = Instance.new("TextButton", frame)
monitorBtn.Size = UDim2.new(0, 100, 0, 30)
monitorBtn.Position = UDim2.new(0, 230, 1, -40)
monitorBtn.Text = "Monitor"
monitorBtn.BackgroundColor3 = Color3.fromRGB(150, 70, 150)
monitorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
monitorBtn.Font = Enum.Font.SourceSans
monitorBtn.TextSize = 14
Instance.new("UICorner", monitorBtn).CornerRadius = UDim.new(0, 6)

-- Close button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 80, 0, 30)
closeBtn.Position = UDim2.new(0, 340, 1, -40)
closeBtn.Text = "Close"
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 70, 70)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSans
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Variables untuk data detection
local detectedData = ""
local isMonitoring = false
local connections = {}

-- Known shop locations dari main.lua
local knownShops = {
    ["🛒 Shop (Alex)"] = {position = "CFrame.new(-28.43, 4.50, 2891.28)", npc = "Alex"},
    ["🛒 Shop (Joe)"] = {position = "CFrame.new(112.01, 4.75, 2877.32)", npc = "Joe"},
    ["🛒 Shop (Seth)"] = {position = "CFrame.new(72.02, 4.58, 2885.28)", npc = "Seth"},
    ["🎣 Rod Shop (Marc)"] = {position = "CFrame.new(454, 150, 229)", npc = "Marc"}
}

-- Fungsi untuk mendeteksi sistem pembelian
local function detectBuySystem()
    local results = {}
    local detectionTime = os.date("%X")
    
    table.insert(results, "=== BUY SYSTEM ANALYSIS ===")
    table.insert(results, "Waktu Deteksi: " .. detectionTime)
    table.insert(results, "")
    
    -- 1. Deteksi RemoteEvents untuk pembelian
    table.insert(results, "📡 REMOTE EVENTS ANALYSIS:")
    table.insert(results, "")
    
    local buyRemotes = {}
    if ReplicatedStorage:FindFirstChild("Packages") then
        local packages = ReplicatedStorage.Packages
        if packages:FindFirstChild("_Index") then
            local netFolder = packages._Index:FindFirstChild("sleitnick_net@0.2.0")
            if netFolder and netFolder:FindFirstChild("net") then
                local net = netFolder.net
                
                -- Scan untuk RemoteEvents yang berkaitan dengan pembelian
                for _, remote in pairs(net:GetChildren()) do
                    local name = remote.Name
                    if string.find(string.lower(name), "buy") or 
                       string.find(string.lower(name), "purchase") or
                       string.find(string.lower(name), "shop") or
                       string.find(string.lower(name), "sell") or
                       string.find(string.lower(name), "item") or
                       string.find(string.lower(name), "rod") or
                       string.find(string.lower(name), "bait") then
                        
                        table.insert(buyRemotes, {
                            name = name,
                            type = remote.ClassName,
                            path = "ReplicatedStorage.Packages._Index[\"sleitnick_net@0.2.0\"].net[\"" .. name .. "\"]"
                        })
                    end
                end
            end
        end
    end
    
    if #buyRemotes > 0 then
        table.insert(results, "🔍 RemoteEvents Terdeteksi:")
        for _, remote in pairs(buyRemotes) do
            table.insert(results, "  • " .. remote.name .. " (" .. remote.type .. ")")
            table.insert(results, "    Path: " .. remote.path)
        end
    else
        table.insert(results, "❌ Tidak ada RemoteEvents pembelian yang ditemukan")
    end
    
    table.insert(results, "")
    
    -- 2. Deteksi NPC Shop
    table.insert(results, "🏪 SHOP NPC ANALYSIS:")
    table.insert(results, "")
    
    local npcContainer = ReplicatedStorage:FindFirstChild("NPC")
    if npcContainer then
        table.insert(results, "📦 NPC Container ditemukan: ReplicatedStorage.NPC")
        for _, npc in pairs(npcContainer:GetChildren()) do
            local shopInfo = ""
            for shopName, info in pairs(knownShops) do
                if info.npc == npc.Name then
                    shopInfo = " (🛒 " .. shopName .. ")"
                    break
                end
            end
            table.insert(results, "  • NPC: " .. npc.Name .. shopInfo)
            if npc:FindFirstChild("WorldPivot") then
                table.insert(results, "    Position: " .. tostring(npc.WorldPivot.Position))
            end
        end
    else
        table.insert(results, "❌ NPC Container tidak ditemukan")
    end
    
    table.insert(results, "")
    
    -- 3. Analisis Known Shops
    table.insert(results, "🗺️ KNOWN SHOP LOCATIONS:")
    table.insert(results, "")
    for shopName, info in pairs(knownShops) do
        table.insert(results, "📍 " .. shopName)
        table.insert(results, "  NPC: " .. info.npc)
        table.insert(results, "  Position: " .. info.position)
        table.insert(results, "")
    end
    
    -- 4. Deteksi sistem SellAll
    table.insert(results, "💰 SELL SYSTEM ANALYSIS:")
    table.insert(results, "")
    
    local sellRemote = nil
    if ReplicatedStorage:FindFirstChild("Packages") then
        local packages = ReplicatedStorage.Packages
        if packages:FindFirstChild("_Index") then
            local netFolder = packages._Index:FindFirstChild("sleitnick_net@0.2.0")
            if netFolder and netFolder:FindFirstChild("net") then
                local net = netFolder.net
                sellRemote = net:FindFirstChild("RF/SellAllItems")
            end
        end
    end
    
    if sellRemote then
        table.insert(results, "✅ SellAllItems Remote ditemukan")
        table.insert(results, "  Type: " .. sellRemote.ClassName)
        table.insert(results, "  Usage: sellRemote:InvokeServer()")
    else
        table.insert(results, "❌ SellAllItems Remote tidak ditemukan")
    end
    
    table.insert(results, "")
    
    -- 5. Analisis Auto Sell System
    table.insert(results, "🔄 AUTO SELL SYSTEM:")
    table.insert(results, "")
    table.insert(results, "Dari analisis kode main.lua:")
    table.insert(results, "• Auto Sell Threshold: Variable (5-50 ikan)")
    table.insert(results, "• Target NPC: Alex")
    table.insert(results, "• Metode: Teleport → Sell → Return")
    table.insert(results, "• Trigger: Jumlah ikan tertangkap")
    table.insert(results, "")
    
    -- 6. Player position
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        table.insert(results, "👤 CURRENT PLAYER POSITION:")
        table.insert(results, "Position: " .. string.format("Vector3.new(%.2f, %.2f, %.2f)", pos.X, pos.Y, pos.Z))
        table.insert(results, "CFrame: " .. string.format("CFrame.new(%.2f, %.2f, %.2f)", pos.X, pos.Y, pos.Z))
        
        -- Check if near any shop
        for shopName, info in pairs(knownShops) do
            local shopPos = Vector3.new(tonumber(info.position:match("CFrame%.new%(([%d%.-]+)")) or 0,
                                      tonumber(info.position:match("CFrame%.new%([%d%.-]+,%s*([%d%.-]+)")) or 0,
                                      tonumber(info.position:match("CFrame%.new%([%d%.-]+,%s*[%d%.-]+,%s*([%d%.-]+)")) or 0)
            local distance = (pos - shopPos).Magnitude
            if distance < 50 then
                table.insert(results, "🔍 Near " .. shopName .. " (Distance: " .. string.format("%.2f", distance) .. ")")
            end
        end
    end
    
    table.insert(results, "")
    table.insert(results, "=== IMPLEMENTATION GUIDE ===")
    table.insert(results, "")
    table.insert(results, "Untuk menggunakan sistem pembelian:")
    table.insert(results, "1. Teleport ke NPC shop yang diinginkan")
    table.insert(results, "2. Gunakan RemoteEvent yang sesuai")
    table.insert(results, "3. Untuk auto sell: RF/SellAllItems:InvokeServer()")
    table.insert(results, "")
    table.insert(results, "Contoh teleport ke Alex Shop:")
    table.insert(results, "LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-28.43, 4.50, 2891.28)")
    
    return table.concat(results, "\n")
end

-- Fungsi untuk monitoring real-time
local function startMonitoring()
    if isMonitoring then return end
    isMonitoring = true
    monitorBtn.Text = "Stop Monitor"
    monitorBtn.BackgroundColor3 = Color3.fromRGB(180, 70, 70)
    
    -- Monitor RemoteEvent calls
    local oldNamecall = nil
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if (method == "FireServer" or method == "InvokeServer") and self.Parent then
            local remoteName = self.Name
            local remotePath = self:GetFullName()
            
            -- Check if it's a buy/sell related remote
            if string.find(string.lower(remoteName), "sell") or
               string.find(string.lower(remoteName), "buy") or
               string.find(string.lower(remoteName), "shop") or
               string.find(string.lower(remoteName), "item") then
                
                print("🛒 [BUY DETECTOR] Remote called: " .. remoteName)
                print("   Path: " .. remotePath)
                print("   Method: " .. method)
                print("   Args: " .. tostring(#args) .. " arguments")
                
                -- Update GUI with detection
                local currentText = infoLabel.Text
                local newDetection = "\n🔔 [REAL-TIME] " .. os.date("%X") .. " - " .. remoteName .. " called"
                infoLabel.Text = currentText .. newDetection
                scrollFrame.CanvasSize = UDim2.new(0, 0, 0, infoLabel.TextBounds.Y)
            end
        end
        
        return oldNamecall(self, ...)
    end)
    
    table.insert(connections, oldNamecall)
end

local function stopMonitoring()
    if not isMonitoring then return end
    isMonitoring = false
    monitorBtn.Text = "Monitor"
    monitorBtn.BackgroundColor3 = Color3.fromRGB(150, 70, 150)
    
    -- Cleanup connections
    for _, connection in pairs(connections) do
        if typeof(connection) == "function" then
            -- Restore original function if needed
        end
    end
    connections = {}
end

-- Fungsi untuk update display
local function updateDisplay()
    detectedData = detectBuySystem()
    infoLabel.Text = detectedData
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, infoLabel.TextBounds.Y)
end

-- Button functionality
copyBtn.MouseButton1Click:Connect(function()
    if detectedData ~= "" then
        if setclipboard then
            setclipboard(detectedData)
            copyBtn.Text = "Copied!"
            task.spawn(function()
                task.wait(1)
                copyBtn.Text = "Copy Info"
            end)
        else
            copyBtn.Text = "No clipboard"
            task.spawn(function()
                task.wait(1)
                copyBtn.Text = "Copy Info"
            end)
        end
    end
end)

refreshBtn.MouseButton1Click:Connect(function()
    refreshBtn.Text = "Refreshing..."
    updateDisplay()
    task.spawn(function()
        task.wait(1)
        refreshBtn.Text = "Refresh"
    end)
end)

monitorBtn.MouseButton1Click:Connect(function()
    if isMonitoring then
        stopMonitoring()
    else
        startMonitoring()
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    stopMonitoring()
    screen:Destroy()
    print("Buy System Detector closed")
end)

-- Initial detection
updateDisplay()

print("🛒 Buy System Detector started!")
print("📍 Analyzing shop locations, NPCs, and RemoteEvents...")
print("🔍 Use Monitor button to track real-time buy/sell activities")
