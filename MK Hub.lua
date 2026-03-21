--//Official MK Hub\\--

print "MK Hub Loaded!"

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "MK Hub",
    LoadingTitle = "MK Hub",
    LoadingSubtitle = "by MKdoyu34",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "MKHub"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = false
    },
    KeySystem = false
})

local FarmTab = Window:CreateTab("AutoFarms", nil)

local TeleportsTab = Window:CreateTab("Teleports", nil)

local CameraTab = Window:CreateTab("Camera Locks", nil)

local GunTab = Window:CreateTab("Gun Mods", nil)

local PlayerTab = Window:CreateTab("Player Modifier", nil)

-----==AutoFarms==-----

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local AutoLootToggle = FarmTab:CreateToggle({
    Name = "Auto Loot",
    CurrentValue = false,
    Flag = "AutoLootToggle",
    Callback = function(Value)
        if Value then
            getgenv().AutoLoot = true
            print("Auto Loot ON")
            task.spawn(function()
                while getgenv().AutoLoot do
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local hrp = char.HumanoidRootPart
                        for _,v in pairs(workspace.Loot:GetChildren()) do
                            if v.Name == "Crate" then
                                local part = v:FindFirstChildWhichIsA("BasePart")
                                if part then
                                    hrp.CFrame = part.CFrame + Vector3.new(0,3,0)
                                    task.wait(0.2)
                                    for _,p in pairs(v:GetDescendants()) do
                                        if p:IsA("ProximityPrompt") then
                                            fireproximityprompt(p,1)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.3)
                end
            end)
        else
            getgenv().AutoLoot = false
            print("Auto Loot OFF")
        end
    end
})

local AutoBerryToggle = FarmTab:CreateToggle({
    Name = "Auto Berry",
    CurrentValue = false,
    Flag = "AutoBerryToggle",
    Callback = function(Value)
        if Value then
            getgenv().AutoBerry = true
            print("Auto Berry ON")
            task.spawn(function()
                while getgenv().AutoBerry do
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local hrp = char.HumanoidRootPart
                        for _,v in pairs(workspace.harvest:GetChildren()) do
                            if v.Name == "berry" then
                                local part = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
                                if part then
                                    hrp.CFrame = part.CFrame + Vector3.new(0,3,0)
                                    task.wait(0.2)
                                    for _,p in pairs(v:GetDescendants()) do
                                        if p:IsA("ProximityPrompt") then
                                            fireproximityprompt(p,1)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.3)
                end
            end)
        else
            getgenv().AutoBerry = false
            print("Auto Berry OFF")
        end
    end
})

local TeleportShopButton = TeleportsTab:CreateButton({
    Name = "Teleport to Shop",
    Callback = function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

-----==Teleports==-----

        local shop = workspace:WaitForChild("Shop")
        local torso = shop:WaitForChild("Torso")

        hrp.CFrame = torso.CFrame + Vector3.new(0,3,0)
    end
})

-----==Camera Locks==-----

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local CameraTab = Window:CreateTab("Camera Locks", nil)

local SirenConnection
local CatConnection

local function HardLock(targetHRP)
    local cam = workspace.CurrentCamera
    cam.CameraType = Enum.CameraType.Scriptable
    cam.CFrame = CFrame.lookAt(cam.CFrame.Position, targetHRP.Position)
end

local LockSirenToggle = CameraTab:CreateToggle({
    Name = "Lock Camera to Siren Head (NPC)",
    CurrentValue = false,
    Flag = "LockSiren",
    Callback = function(Value)
        if Value then
            print("Siren Lock ON")
            SirenConnection = RunService.RenderStepped:Connect(function()
                local siren = workspace:WaitForChild("scps"):WaitForChild("real_siren")
                local hrp = siren:FindFirstChild("HumanoidRootPart", true)
                if hrp then
                    HardLock(hrp)
                end
            end)
        else
            print("Siren Lock OFF")
            if SirenConnection then
                SirenConnection:Disconnect()
                SirenConnection = nil
            end
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        end
    end
})

local LockCatToggle = CameraTab:CreateToggle({
    Name = "Lock Camera to Cartoon Cat (NPC)",
    CurrentValue = false,
    Flag = "LockCat",
    Callback = function(Value)
        if Value then
            print("Cartoon Cat Lock ON")
            CatConnection = RunService.RenderStepped:Connect(function()
                local cat = workspace:WaitForChild("scps"):WaitForChild("real_cartoon_cat")
                local hrp = cat:FindFirstChild("HumanoidRootPart", true)
                if hrp then
                    HardLock(hrp)
                end
            end)
        else
            print("Cartoon Cat Lock OFF")
            if CatConnection then
                CatConnection:Disconnect()
                CatConnection = nil
            end
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        end
    end
})

-----==Gun Mods==-----

local InfiniteAmmoToggle = GunTab:CreateToggle({
    Name = "Infinite Ammo",
    CurrentValue = false,
    Flag = "InfiniteAmmo",
    Callback = function(Value)
        if Value then
            getgenv().InfAmmo = true
            print("Infinite Ammo ON")

            local player = game:GetService("Players").LocalPlayer

            local function setupTool(tool)
                local ammoValues = {}
                for _,v in pairs(tool:GetDescendants()) do
                    if v:IsA("NumberValue") and (v.Name:lower():find("ammo") or v.Name:lower():find("clip")) then
                        table.insert(ammoValues, v)
                    end
                end

                task.spawn(function()
                    while getgenv().InfAmmo and tool.Parent do
                        for _,v in pairs(ammoValues) do
                            if v.Value < 999 then
                                v.Value = 999
                            end
                        end
                        task.wait(0.1)
                    end
                end)
            end

            local char = player.Character or player.CharacterAdded:Wait()

            for _,tool in pairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    setupTool(tool)
                end
            end

            char.ChildAdded:Connect(function(tool)
                if tool:IsA("Tool") and getgenv().InfAmmo then
                    setupTool(tool)
                end
            end)

        else
            getgenv().InfAmmo = false
            print("Infinite Ammo OFF")
        end
    end
})

local RapidFireToggle = GunTab:CreateToggle({
    Name = "Rapid Fire",
    CurrentValue = false,
    Flag = "RapidFire",
    Callback = function(Value)
        if Value then
            getgenv().RapidFire = true
            print("Rapid Fire ON")

            local player = game:GetService("Players").LocalPlayer

            local function setupTool(tool)
                for _,v in pairs(tool:GetDescendants()) do
                    if (v:IsA("NumberValue") or v:IsA("IntValue")) and (v.Name:lower():find("fire") or v.Name:lower():find("rate") or v.Name:lower():find("delay") or v.Name:lower():find("cooldown")) then
                        v.Value = 0
                    end
                end
            end

            local char = player.Character or player.CharacterAdded:Wait()

            for _,tool in pairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    setupTool(tool)
                end
            end

            char.ChildAdded:Connect(function(tool)
                if tool:IsA("Tool") and getgenv().RapidFire then
                    setupTool(tool)
                end
            end)

        else
            getgenv().RapidFire = false
            print("Rapid Fire OFF")
        end
    end
})

-----==Player Modifiers==-----

local noclip = false

PlayerTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value)
      noclip = Value
   end
})

game:GetService("RunService").Stepped:Connect(function()
   if noclip then
      for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
         if v:IsA("BasePart") then
            v.CanCollide = false
         end
      end
   end
end)

local speedEnabled = false
local speedValue = 16

PlayerTab:CreateInput({
   Name = "Set WalkSpeed",
   PlaceholderText = "Enter speed...",
   RemoveTextAfterFocusLost = false,
   Flag = "SpeedInput",
   Callback = function(Value)
      local num = tonumber(Value)
      if num then
         speedValue = num
      end
   end
})

PlayerTab:CreateToggle({
   Name = "Enable WalkSpeed",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
      speedEnabled = Value
   end
})

game:GetService("RunService").RenderStepped:Connect(function()
   if speedEnabled then
      local player = game.Players.LocalPlayer
      local char = player.Character
      if char then
         local humanoid = char:FindFirstChildOfClass("Humanoid")
         if humanoid then
            humanoid.WalkSpeed = speedValue
         end
      end
   end
end)

local flying = false
local flySpeed = 50
local bv, bg

PlayerTab:CreateInput({
   Name = "Fly Speed",
   PlaceholderText = "Enter speed...",
   RemoveTextAfterFocusLost = false,
   Flag = "FlySpeedInput",
   Callback = function(Value)
      local num = tonumber(Value)
      if num then
         flySpeed = num
      end
   end
})

PlayerTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      flying = Value

      local player = game.Players.LocalPlayer
      local char = player.Character or player.CharacterAdded:Wait()
      local root = char:WaitForChild("HumanoidRootPart")
      local humanoid = char:FindFirstChildOfClass("Humanoid")

      if flying then
         bv = Instance.new("BodyVelocity")
         bv.MaxForce = Vector3.new(1e9,1e9,1e9)
         bv.Velocity = Vector3.new(0,0,0)
         bv.Parent = root

         bg = Instance.new("BodyGyro")
         bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
         bg.CFrame = workspace.CurrentCamera.CFrame
         bg.Parent = root

         if humanoid then
            humanoid.PlatformStand = true
         end

      else
         if bv then bv:Destroy() end
         if bg then bg:Destroy() end

         if humanoid then
            humanoid.PlatformStand = false
         end
      end
   end
})

game:GetService("RunService").RenderStepped:Connect(function()
   if flying and bv and bg then
      local cam = workspace.CurrentCamera

      bv.Velocity = cam.CFrame.LookVector * flySpeed
      bg.CFrame = cam.CFrame
   end
end)
