-- Fish It Mod Menu ALL-IN-ONE (UI + Auto Fish System)

-- ===== KAVO UI =====
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local window = library.CreateLib("Fish It Mod Menu", "DarkTheme")
local tab = window:NewTab("Main")
local section = tab:NewSection("Auto Fish")

-- ===== AUTO FISH VARIABLES =====
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer

-- Buat RemoteEvent jika belum ada
local event = RS:FindFirstChild("StartAutoFish")
if not event then
    event = Instance.new("RemoteEvent")
    event.Name = "StartAutoFish"
    event.Parent = RS
end

_G.autoFish = false

-- ===== KAVO UI TOGGLES =====
section:NewToggle("Auto Catch (1 detik)", "Mancing otomatis cepat", function(bool)
    _G.autoFish = bool
    event:FireServer(_G.autoFish)
end)

section:NewButton("Super Fast 0.1s", "Ultra cepat", function()
    _G.autoFish = true
    event:FireServer(_G.autoFish)
end)

section:NewToggle("Stop Auto Fish", "Matikan semua", function()
    _G.autoFish = false
    event:FireServer(_G.autoFish)
end)

-- ===== SERVER LOGIC (LOCAL SIMULATION) =====
-- Jika dijalankan di LocalScript, kita hanya bisa simulasi tanpa server,
-- jadi kita buat client auto fish
spawn(function()
    while true do
        task.wait(0.1)
        if _G.autoFish then
            pcall(function()
                -- Fire server event untuk update fish
                if event then
                    event:FireServer(20) -- default 20 fish per pull
                end
            end)
        end
    end
end)

-- ===== PLAYER GUI BUTTON (optional, bisa gabung Kavo UI) =====
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        local gui = Instance.new("ScreenGui")
        gui.Name = "AutoFishMenu"
        gui.ResetOnSpawn = false
        gui.Parent = player:WaitForChild("PlayerGui")

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 200, 0, 60)
        button.Position = UDim2.new(0, 20, 0.8, 0)
        button.Text = "AUTO FISH"
        button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        button.Parent = gui

        local localScript = Instance.new("LocalScript")
        localScript.Parent = button
        localScript.Source = [[
            local RS = game:GetService("ReplicatedStorage")
            local event = RS:WaitForChild("StartAutoFish")
            local button = script.Parent
            local active = false

            button.MouseButton1Click:Connect(function()
                active = not active
                if active then
                    button.Text = "AUTO FISH: ON"
                    button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                else
                    button.Text = "AUTO FISH: OFF"
                    button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
                end
                event:FireServer(active)
            end)
        ]]
    end)
end)