print("MK Hub Successfully loaded!")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MK Hub",
   LoadingTitle = "Loading MK Hub",
   LoadingSubtitle = "By: MKdoyu34",
   ConfigurationSaving = {Enabled = true}
})

local FarmTab = Window:CreateTab("AutoFarms", nil)

local AutoLoot = false
local player = game.Players.LocalPlayer

FarmTab:CreateToggle({
   Name = "Auto Loot",
   CurrentValue = false,
   Callback = function(Value)
      AutoLoot = Value
      if Value then
         print("Auto Loot: ON")
      else
         print("Auto Loot: OFF")
      end
   end,
})

task.spawn(function()
   while true do
      task.wait(0.1)

      if AutoLoot then
         local character = player.Character
         local hrp = character and character:FindFirstChild("HumanoidRootPart")

         if hrp then
            local foundPrompt = false

            for _, prompt in pairs(workspace.Loot:GetDescendants()) do
               if not AutoLoot then break end

               if prompt:IsA("ProximityPrompt") then
                  foundPrompt = true
                  prompt.HoldDuration = 0

                  local parent = prompt.Parent
                  if parent and parent:IsA("BasePart") then
                     hrp.CFrame = parent.CFrame + Vector3.new(0, 3, 0)
                     fireproximityprompt(prompt)
                  end
               end
            end

            if AutoLoot and not foundPrompt then
               hrp.CFrame = CFrame.new(250, 250, 600)
            end
         end
      end
   end
end)

local AutoBerry = false

FarmTab:CreateToggle({
   Name = "Auto Berry",
   CurrentValue = false,
   Callback = function(Value)
      AutoBerry = Value
      
      if Value then
         print("Auto Berry: ON")
      else
         print("Auto Berry: OFF")
      end
   end,
})

task.spawn(function()
   while true do
      task.wait(0.1)

      if AutoBerry then
         local character = player.Character
         local hrp = character and character:FindFirstChild("HumanoidRootPart")

         if hrp then
            local nearestPart = nil
            local shortestDistance = math.huge

            for _, obj in pairs(workspace.harvest:GetChildren()) do
               if not AutoBerry then break end

               if obj:IsA("BasePart") and obj.Name == "Part" then
                  local distance = (hrp.Position - obj.Position).Magnitude

                  if distance < shortestDistance then
                     shortestDistance = distance
                     nearestPart = obj
                  end
               end
            end

            if nearestPart then
               hrp.CFrame = nearestPart.CFrame

               local prompt = nearestPart:FindFirstChildWhichIsA("ProximityPrompt", true)
               if prompt then
                  prompt.HoldDuration = 0
                  fireproximityprompt(prompt, 0)
               end
            end
         end
      end
   end
end)

local TeleportTab = Window:CreateTab("Teleports", nil)

TeleportTab:CreateButton({
    Name = "Teleport to Siren Head Lighthouse",
    Callback = function()
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        local target = workspace:FindFirstChild("Towers")
                      and workspace.Towers:FindFirstChild("Tower")
                      and workspace.Towers.Tower:FindFirstChild("Lever")
                      and workspace.Towers.Tower.Lever:FindFirstChild("Metal1")

        if hrp and target and target:IsA("BasePart") then
            hrp.CFrame = target.CFrame + Vector3.new(0, 3, 0)
            print("Teleported to Metal1!")
        else
            warn("Metal1 not found!")
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Military Base Lighthouse",
    Callback = function()
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        local towers = workspace:FindFirstChild("Towers")
        local secondTower = towers and towers:GetChildren()[2]
        local target = secondTower and secondTower:FindFirstChild("Lever") 
                       and secondTower.Lever:FindFirstChild("Metal1")

        if hrp and target and target:IsA("BasePart") then
            hrp.CFrame = target.CFrame + Vector3.new(0, 3, 0)
            print("Teleported to Military Base Lighthouse!")
        else
            warn("Military Base Lighthouse not found!")
        end
    end,
})
