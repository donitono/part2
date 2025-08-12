--[[
    XSAN Fish It Pro - Simple UI Test Version
    Untuk testing apakah masalah ada di UI atau di main script
--]]

print("XSAN: Starting Simple UI Test...")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- Simple notification
local function Notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "XSAN Test",
            Text = text or "Test message",
            Duration = 3
        })
    end)
    print("XSAN:", title, "-", text)
end

-- Test basic services
if not LocalPlayer then
    warn("XSAN ERROR: LocalPlayer not found")
    return
end

print("XSAN: Basic services OK")

-- Try to load UI with extensive error handling
local success, error_msg = pcall(function()
    print("XSAN: Testing UI_Fixed loading...")
    
    -- Load ui_fixed.lua
    local ui_url = "https://raw.githubusercontent.com/donitono/part2/main/ui_fixed.lua"
    local response = game:HttpGet(ui_url)
    
    if not response or #response == 0 then
        error("Empty response from " .. ui_url)
    end
    
    print("XSAN: Got response, length:", #response)
    
    -- Test compilation
    local compiled_func, compile_error = loadstring(response)
    if not compiled_func then
        error("Compilation failed: " .. tostring(compile_error))
    end
    
    print("XSAN: UI compiled successfully")
    
    -- Execute UI
    local Rayfield = compiled_func()
    if not Rayfield then
        error("UI function returned nil")
    end
    
    print("XSAN: Rayfield created, type:", type(Rayfield))
    print("XSAN: Rayfield.CreateWindow exists:", Rayfield.CreateWindow ~= nil)
    
    -- Test window creation
    local Window = Rayfield:CreateWindow({
        Name = "XSAN Test Window",
        LoadingTitle = "Testing UI",
        LoadingSubtitle = "Simple test"
    })
    
    if not Window then
        error("CreateWindow returned nil")
    end
    
    print("XSAN: Window created successfully, type:", type(Window))
    print("XSAN: Window.CreateTab exists:", Window.CreateTab ~= nil)
    
    -- Test tab creation
    local TestTab = Window:CreateTab("Test", "gear")
    if not TestTab then
        error("CreateTab returned nil")
    end
    
    print("XSAN: Tab created successfully!")
    
    -- Add test element
    TestTab:CreateParagraph({
        Title = "UI Test Success!",
        Content = "Jika Anda melihat ini, berarti UI bekerja dengan benar!"
    })
    
    TestTab:CreateButton({
        Name = "Test Button",
        Callback = function()
            Notify("Test", "Button clicked! UI working properly!")
        end
    })
    
    Notify("Success", "UI loaded successfully! Check the window.")
    return true
end)

if not success then
    warn("XSAN UI Test Failed:", error_msg)
    Notify("Error", "UI test failed: " .. tostring(error_msg))
else
    print("XSAN: UI test completed successfully!")
end
