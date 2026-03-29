--===[OFFICIAL MK HUB]===---
--//Do not execute any MK Hub Clones this is the official MK Hub\\--
--Siren Head: LEGACY Script--

print("MK Hub Successfully Executed!")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MK Hub",
   Icon = 0,
   LoadingTitle = "Loading MK Hub...",
   LoadingSubtitle = "by MKdoyu34",
   ShowText = "Rayfield",
   Theme = "Default",

   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MK Hub",
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

-----==AutoFarms==-----

local FarmTab = Window:CreateTab("Farm", nil)

local autoLoot = false
local autoBerry = false

local function triggerPrompt(obj)
    for _,v in pairs(obj:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            fireproximityprompt(v)
        end
    end
end

FarmTab:CreateToggle({
    Name = "Auto Loot",
    CurrentValue = false,
    Callback = function(Value)
        autoLoot = Value

        if autoLoot then
            task.spawn(function()
                local player = game.Players.LocalPlayer
                local char = player.Character or player.CharacterAdded:Wait()
                local root = char:WaitForChild("HumanoidRootPart")

                while autoLoot do
                    task.wait(0.1)

                    for _, crate in pairs(workspace.Loot:GetChildren()) do
                        if not autoLoot then break end
                        if crate.Name == "Crate" then
                            local pos = crate:GetPivot().Position
                            root.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
                            task.wait(0.15)
                            triggerPrompt(crate)
                        end
                    end

                    task.wait(0.2)
                end
            end)
        end
    end
})

FarmTab:CreateToggle({
    Name = "Auto Berry",
    CurrentValue = false,
    Callback = function(Value)
        autoBerry = Value

        if autoBerry then
            task.spawn(function()
                local player = game.Players.LocalPlayer
                local char = player.Character or player.CharacterAdded:Wait()
                local root = char:WaitForChild("HumanoidRootPart")

                while autoBerry do
                    task.wait(0.1)

                    local nearestBerry = nil
                    local minDist = math.huge

                    for _, berry in pairs(workspace.harvest:GetChildren()) do
                        if berry.Name == "berry" or berry.Name == "Part" then
                            local pos = berry:GetPivot().Position
                            local dist = (root.Position - pos).Magnitude
                            if dist < minDist then
                                minDist = dist
                                nearestBerry = berry
                            end
                        end
                    end

                    if nearestBerry then
                        local pos = nearestBerry:GetPivot().Position
                        root.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
                        local startTime = tick()

                        while nearestBerry.Parent and autoBerry do
                            triggerPrompt(nearestBerry)
                            task.wait(0.05)
                            if tick() - startTime > 3 then
                                break
                            end
                        end
                    else
                        task.wait(0.3)
                    end
                end
            end)
        end
    end
})

local player = game.Players.LocalPlayer

local autoSirenNPC = false
local autoCartoonNPC = false
local autoSirenPlayer = false
local autoCartoonPlayer = false

local sirenRadius = 65
local sirenHeight = 25
local cartoonRadius = 20
local cartoonHeight = 10
local orbitSpeed = 2.5

local function getHRP(model)
    if model and model:FindFirstChild("HumanoidRootPart") then
        return model.HumanoidRootPart
    end
end

local function orbitAround(hrp, radius, height)
    local char = player.Character
    if not char then return end

    local myHRP = char:FindFirstChild("HumanoidRootPart")
    if not myHRP or not hrp then return end

    local t = tick() * orbitSpeed
    local x = math.cos(t) * radius
    local z = math.sin(t) * radius

    local targetPos = hrp.Position
    local newPos = targetPos + Vector3.new(x, height, z)

    myHRP.CFrame = CFrame.new(newPos, targetPos)
end

local function getSirenNPC()
    return workspace:FindFirstChild("scps") and workspace.scps:FindFirstChild("real_siren")
end

local function getCartoonNPC()
    return workspace:FindFirstChild("scps") and workspace.scps:FindFirstChild("real_cartoon_cat")
end

local function getSirenPlayer()
    return workspace:FindFirstChild("scps") and workspace.scps:FindFirstChild("siren")
end

local function getCartoonPlayer()
    return workspace:FindFirstChild("scps") and workspace.scps:FindFirstChild("cartoon_cat")
end

FarmTab:CreateToggle({
    Name = "Auto Farm Siren Head (NPC)",
    CurrentValue = false,
    Callback = function(state)
        autoSirenNPC = state
        if state then
            task.spawn(function()
                while autoSirenNPC do
                    task.wait()
                    local hrp = getHRP(getSirenNPC())
                    if hrp then
                        orbitAround(hrp, sirenRadius, sirenHeight)
                    end
                end
            end)
        end
    end
})

FarmTab:CreateToggle({
    Name = "Auto Farm Cartoon Cat (NPC)",
    CurrentValue = false,
    Callback = function(state)
        autoCartoonNPC = state
        if state then
            task.spawn(function()
                while autoCartoonNPC do
                    task.wait()
                    local hrp = getHRP(getCartoonNPC())
                    if hrp then
                        orbitAround(hrp, cartoonRadius, cartoonHeight)
                    end
                end
            end)
        end
    end
})

FarmTab:CreateToggle({
    Name = "Auto Farm Siren Head (PLAYER)",
    CurrentValue = false,
    Callback = function(state)
        autoSirenPlayer = state
        if state then
            task.spawn(function()
                while autoSirenPlayer do
                    task.wait()
                    local hrp = getHRP(getSirenPlayer())
                    if hrp then
                        orbitAround(hrp, sirenRadius, sirenHeight)
                    end
                end
            end)
        end
    end
})

FarmTab:CreateToggle({
    Name = "Auto Farm Cartoon Cat (PLAYER)",
    CurrentValue = false,
    Callback = function(state)
        autoCartoonPlayer = state
        if state then
            task.spawn(function()
                while autoCartoonPlayer do
                    task.wait()
                    local hrp = getHRP(getCartoonPlayer())
                    if hrp then
                        orbitAround(hrp, cartoonRadius, cartoonHeight)
                    end
                end
            end)
        end
    end
})

-----==Teleports==-----

local TeleportsTab = Window:CreateTab("Teleports", nil)

TeleportsTab:CreateButton({
    Name = "Teleport to Shop",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")

        local shopTorso = workspace:WaitForChild("shop"):FindFirstChild("Torso")
        if shopTorso and shopTorso:IsA("BasePart") then
            root.CFrame = shopTorso.CFrame + Vector3.new(0, 3, 0)
        end
    end
})

TeleportsTab:CreateButton({
    Name = "Teleport to Siren Head Lighthouse",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")

        local targetPart = workspace:WaitForChild("Towers")
            :WaitForChild("Tower")
            :WaitForChild("Lever")
            :FindFirstChild("Metal1")

        if targetPart and targetPart:IsA("BasePart") then
            root.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
})

TeleportsTab:CreateButton({
    Name = "Teleport to Military Base Lighthouse",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")

        local tower = workspace:WaitForChild("Towers"):GetChildren()[2]
        if tower then
            local lever = tower:FindFirstChild("Lever")
            if lever then
                local metal1 = lever:FindFirstChild("Metal1")
                if metal1 and metal1:IsA("BasePart") then
                    root.CFrame = metal1.CFrame + Vector3.new(0, 3, 0)
                end
            end
        end
    end
})

TeleportsTab:CreateButton({
    Name = "Teleport to Barn",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")

        local barnParts = workspace:WaitForChild("barn"):GetChildren()
        local targetPart = barnParts[78]

        if targetPart and targetPart:IsA("BasePart") then
            root.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
})

-----==Camera Locks==-----

local CameraLocksTab = Window:CreateTab("Camera Locks", nil)

local LockSirenNPC = false

CameraLocksTab:CreateToggle({
    Name = "Lock Camera to Siren Head (NPC)",
    CurrentValue = false,
    Callback = function(Value)
        LockSirenNPC = Value

        if LockSirenNPC then
            task.spawn(function()
                local cam = workspace.CurrentCamera
                while LockSirenNPC do
                    task.wait()
                    local target = workspace:FindFirstChild("scps")
                        and workspace.scps:FindFirstChild("real_siren")
                        and workspace.scps.real_siren:FindFirstChild("HumanoidRootPart")

                    if target then
                        cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
                    end
                end
            end)
        end
    end
})

local LockCartoonNPC = false

CameraLocksTab:CreateToggle({
    Name = "Lock Camera to Cartoon Cat (NPC)",
    CurrentValue = false,
    Callback = function(Value)
        LockCartoonNPC = Value

        if LockCartoonNPC then
            task.spawn(function()
                local cam = workspace.CurrentCamera
                while LockCartoonNPC do
                    task.wait()
                    local target = workspace:FindFirstChild("scps")
                        and workspace.scps:FindFirstChild("real_cartoon_cat")
                        and workspace.scps.real_cartoon_cat:FindFirstChild("HumanoidRootPart")

                    if target then
                        cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
                    end
                end
            end)
        end
    end
})

local LockSirenPlayer = false

CameraLocksTab:CreateToggle({
    Name = "Lock Camera to Siren Head (PLAYER)",
    CurrentValue = false,
    Callback = function(Value)
        LockSirenPlayer = Value

        if LockSirenPlayer then
            task.spawn(function()
                local cam = workspace.CurrentCamera
                while LockSirenPlayer do
                    task.wait()
                    local target = workspace:FindFirstChild("scps")
                        and workspace.scps:FindFirstChild("siren")
                        and workspace.scps.siren:FindFirstChild("HumanoidRootPart")

                    if target then
                        cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
                    end
                end
            end)
        end
    end
})

local LockCartoonPlayer = false

CameraLocksTab:CreateToggle({
    Name = "Lock Camera to Cartoon Cat (PLAYER)",
    CurrentValue = false,
    Callback = function(Value)
        LockCartoonPlayer = Value

        if LockCartoonPlayer then
            task.spawn(function()
                local cam = workspace.CurrentCamera
                while LockCartoonPlayer do
                    task.wait()
                    local target = workspace:FindFirstChild("scps")
                        and workspace.scps:FindFirstChild("cartoon_cat")
                        and workspace.scps.cartoon_cat:FindFirstChild("HumanoidRootPart")

                    if target then
                        cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
                    end
                end
            end)
        end
    end
})

-----==Gun Mods==-----

local GunModsTab = Window:CreateTab("Gun Mods", nil)

GunModsTab:CreateLabel("Rapid Fire won't work for Glock 17, Deagle, Remington 870, Scout and AWP.")

local player = game.Players.LocalPlayer

local MAX_AMMO = 2147483647

local infAmmoConnections = {}
local rapidFireEnabled = false
local recoilConnections = {}

local function clearTable(tbl)
    for _, c in ipairs(tbl) do
        if c then
            c:Disconnect()
        end
    end
    table.clear(tbl)
end

local function applyInfAmmo(tool)
    if not tool:IsA("Tool") then return end

    for _, v in ipairs(tool:GetDescendants()) do
        if v:IsA("IntValue") or v:IsA("NumberValue") then
            local name = v.Name:lower()

            if name:find("ammo") or name:find("clip") or name:find("mag") then
                v.Value = MAX_AMMO

                local conn = v:GetPropertyChangedSignal("Value"):Connect(function()
                    if v.Value < MAX_AMMO then
                        v.Value = MAX_AMMO
                    end
                end)

                table.insert(infAmmoConnections, conn)
            end
        end
    end
end

GunModsTab:CreateToggle({
    Name = "Infinite Ammo",
    CurrentValue = false,
    Callback = function(state)
        clearTable(infAmmoConnections)

        if state then
            for _, t in ipairs(player.Backpack:GetChildren()) do
                applyInfAmmo(t)
            end

            for _, t in ipairs(player.Character:GetChildren()) do
                applyInfAmmo(t)
            end

            table.insert(infAmmoConnections, player.Backpack.ChildAdded:Connect(applyInfAmmo))
            table.insert(infAmmoConnections, player.Character.ChildAdded:Connect(applyInfAmmo))
        end
    end,
})

local function applyRapidFire(tool)
    if not tool:IsA("Tool") then return end

    for _, v in ipairs(tool:GetDescendants()) do
        if v:IsA("IntValue") or v:IsA("NumberValue") then
            local name = v.Name:lower()

            if name:find("firerate") or name:find("delay") then
                v.Value = 0
            end

            if name:find("rpm") then
                v.Value = 1000000
            end
        end
    end
end

GunModsTab:CreateToggle({
    Name = "Rapid Fire",
    CurrentValue = false,
    Callback = function(state)
        rapidFireEnabled = state

        if state then
            for _, t in ipairs(player.Backpack:GetChildren()) do
                applyRapidFire(t)
            end

            for _, t in ipairs(player.Character:GetChildren()) do
                applyRapidFire(t)
            end

            player.Backpack.ChildAdded:Connect(function(tool)
                if rapidFireEnabled then
                    applyRapidFire(tool)
                end
            end)

            player.Character.ChildAdded:Connect(function(tool)
                if rapidFireEnabled then
                    applyRapidFire(tool)
                end
            end)
        end
    end,
})

local function applyNoRecoil(tool)
    if not tool:IsA("Tool") then return end

    for _, v in ipairs(tool:GetDescendants()) do
        if v:IsA("NumberValue") or v:IsA("IntValue") then
            local name = v.Name:lower()
            if name:find("recoil") or name:find("kick") then
                v.Value = 0

                local conn = v:GetPropertyChangedSignal("Value"):Connect(function()
                    if v.Value ~= 0 then
                        v.Value = 0
                    end
                end)

                table.insert(recoilConnections, conn)
            end
        end
    end
end

local function clearRecoilConnections()
    for _, c in ipairs(recoilConnections) do
        if c then c:Disconnect() end
    end
    table.clear(recoilConnections)
end

GunModsTab:CreateToggle({
    Name = "No Recoil",
    CurrentValue = false,
    Callback = function(state)
        clearRecoilConnections()

        if state then
            for _, t in ipairs(player.Backpack:GetChildren()) do
                applyNoRecoil(t)
            end

            for _, t in ipairs(player.Character:GetChildren()) do
                applyNoRecoil(t)
            end

            table.insert(recoilConnections, player.Backpack.ChildAdded:Connect(applyNoRecoil))
            table.insert(recoilConnections, player.Character.ChildAdded:Connect(applyNoRecoil))
        end
    end,
})

local noFlash = false
local flashConnections = {}

local function clearFlashConnections()
    for _, c in pairs(flashConnections) do
        c:Disconnect()
    end
    table.clear(flashConnections)
end

local function removeFlashFromGun(gun)
    local muzzle = gun:FindFirstChild("Muzzle", true)
    if not muzzle then return end

    local function destroyFlash(v)
        if v:IsA("ParticleEmitter") 
        or v:IsA("PointLight") 
        or v:IsA("SpotLight") then
            v:Destroy()
        end
    end

    for _, v in pairs(muzzle:GetDescendants()) do
        destroyFlash(v)
    end

    table.insert(flashConnections, muzzle.DescendantAdded:Connect(function(v)
        if noFlash then
            destroyFlash(v)
        end
    end))
end

GunModsTab:CreateToggle({
    Name = "Remove Gun Flash",
    CurrentValue = false,
    Callback = function(Value)
        noFlash = Value
        clearFlashConnections()

        if not noFlash then return end

        local vm = workspace:FindFirstChild("viewmodels")
        if not vm then return end

        for _, gun in pairs(vm:GetChildren()) do
            removeFlashFromGun(gun)
        end

        table.insert(flashConnections, vm.ChildAdded:Connect(function(gun)
            if noFlash then
                removeFlashFromGun(gun)
            end
        end))
    end
})

-----==ESP==-----

local ESPTab = Window:CreateTab("ESP", nil)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local PlayerESP = false
local SirenPlayerESP = false
local CartoonPlayerESP = false
local LongHorsePlayerESP = false

local NPCSirenESP = false
local NPCCartoonESP = false

local TracerESP = false
local BoxESP = false
local HealthESP = false

local ESPCache = {}

local function CreateESP(id)
    local box = Drawing.new("Square")
    local tracer = Drawing.new("Line")
    local text = Drawing.new("Text")

    box.Color = Color3.fromRGB(0,255,0)
    box.Thickness = 1
    box.Filled = false

    tracer.Color = Color3.fromRGB(0,255,0)
    tracer.Thickness = 1

    text.Color = Color3.fromRGB(0,255,0)
    text.Size = 13
    text.Center = true
    text.Outline = true

    ESPCache[id] = {box = box, tracer = tracer, text = text}
end

local function ResetESP(esp)
    esp.box.Visible = false
    esp.tracer.Visible = false
    esp.text.Visible = false
end

local function ClearAllESP()
    for id, esp in pairs(ESPCache) do
        if esp.box then esp.box:Remove() end
        if esp.tracer then esp.tracer:Remove() end
        if esp.text then esp.text:Remove() end
        ESPCache[id] = nil
    end
end

RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        local id = "PLAYER_"..plr.UserId

        if not ESPCache[id] then
            CreateESP(id)
        end

        local esp = ESPCache[id]
        ResetESP(esp)

        local char = plr.Character
        if not char then continue end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")

        if not hrp or not hum or hum.Health <= 0 then continue end

        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if pos.Z <= 0 then continue end

        local size = math.clamp(300 / pos.Z, 15, 100)

        local nameLower = char.Name:lower()
        local isSiren = nameLower:find("siren")
        local isCartoon = nameLower:find("cartoon")
        local isLongHorse = nameLower:find("long")

        if isSiren and not SirenPlayerESP then continue end
        if isCartoon and not CartoonPlayerESP then continue end
        if isLongHorse and not LongHorsePlayerESP then continue end
        if not isSiren and not isCartoon and not isLongHorse and not PlayerESP then continue end

        if BoxESP and onScreen then
            esp.box.Size = Vector2.new(size, size)
            esp.box.Position = Vector2.new(pos.X - size/2, pos.Y - size/2)
            esp.box.Visible = true
        end

        if TracerESP then
            esp.tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            esp.tracer.To = Vector2.new(pos.X, pos.Y)
            esp.tracer.Visible = true
        end

        local label
        if isSiren then
            label = "Siren Head (PLAYER) ("..plr.Name..")"
        elseif isCartoon then
            label = "Cartoon Cat (PLAYER) ("..plr.Name..")"
        elseif isLongHorse then
            label = "Long Horse (PLAYER) ("..plr.Name..")"
        else
            label = "Player ("..plr.Name..")"
        end

        if HealthESP then
            label = label.." ["..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth).."]"
        end

        local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
        label = label.." ("..math.floor(distance)..")"

        esp.text.Text = label
        esp.text.Position = Vector2.new(pos.X, pos.Y - size/2 - 15)
        esp.text.Visible = true
    end

    for _, obj in ipairs(workspace.scps:GetChildren()) do
        if obj:IsA("Model") then
            local nameLower = obj.Name:lower()

            local isSiren = nameLower:find("siren")
            local isCartoon = nameLower:find("cartoon")

            if isSiren and not NPCSirenESP then continue end
            if isCartoon and not NPCCartoonESP then continue end
            if not isSiren and not isCartoon then continue end

            local id = "NPC_" .. obj:GetDebugId()

            if not ESPCache[id] then
                CreateESP(id)
            end

            local esp = ESPCache[id]
            ResetESP(esp)

            local hrp = obj:FindFirstChild("HumanoidRootPart")
            local hum = obj:FindFirstChild("Humanoid")

            if not hrp or not hum or hum.Health <= 0 then continue end

            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if pos.Z <= 0 then continue end

            local size = math.clamp(300 / pos.Z, 15, 100)

            if BoxESP and onScreen then
                esp.box.Size = Vector2.new(size, size)
                esp.box.Position = Vector2.new(pos.X - size/2, pos.Y - size/2)
                esp.box.Visible = true
            end

            if TracerESP then
                esp.tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                esp.tracer.To = Vector2.new(pos.X, pos.Y)
                esp.tracer.Visible = true
            end

            local label
            if isSiren then
                label = "Siren Head (NPC)"
            elseif isCartoon then
                label = "Cartoon Cat (NPC)"
            end

            if HealthESP then
                label = label.." ["..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth).."]"
            end

            local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
            label = label.." ("..math.floor(distance)..")"

            esp.text.Text = label
            esp.text.Position = Vector2.new(pos.X, pos.Y - size/2 - 15)
            esp.text.Visible = true
        end
    end
end)

ESPTab:CreateToggle({Name="Player ESP",Callback=function(v)PlayerESP=v end})
ESPTab:CreateToggle({Name="ESP Siren Head (PLAYER)",Callback=function(v)SirenPlayerESP=v end})
ESPTab:CreateToggle({Name="ESP Cartoon Cat (PLAYER)",Callback=function(v)CartoonPlayerESP=v end})
ESPTab:CreateToggle({Name="ESP Long Horse (PLAYER)",Callback=function(v)LongHorsePlayerESP=v end})

ESPTab:CreateToggle({Name="ESP Siren Head (NPC)",Callback=function(v)NPCSirenESP=v end})
ESPTab:CreateToggle({Name="ESP Cartoon Cat (NPC)",Callback=function(v)NPCCartoonESP=v end})

ESPTab:CreateToggle({Name="Tracer (Middle)",Callback=function(v)TracerESP=v end})
ESPTab:CreateToggle({Name="Box ESP",Callback=function(v)BoxESP=v end})
ESPTab:CreateToggle({Name="Health ESP",Callback=function(v)HealthESP=v end})

ESPTab:CreateButton({
    Name = "Remove Junk ESP",
    Callback = function()
        ClearAllESP()
    end
})
