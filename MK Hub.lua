local player = game.Players.LocalPlayer
local lootFolder = workspace:WaitForChild("Loot")
local harvestFolder = workspace:WaitForChild("harvest")

local UIS = game:GetService("UserInputService")
local camera = workspace.CurrentCamera

local autoLoot = false
local autoBerry = false
local sirenLock = false
local catLock = false

-- ======================
-- REMOVE PROMPT COOLDOWN
-- ======================

local function fixPrompt(prompt)
    if prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0
        prompt.MaxActivationDistance = 25
        prompt.RequiresLineOfSight = false
    end
end

for _,v in pairs(workspace:GetDescendants()) do
    fixPrompt(v)
end

workspace.DescendantAdded:Connect(fixPrompt)

-- ======================
-- GUI
-- ======================

local gui = Instance.new("ScreenGui")
gui.Name = "AutoFarmGUI"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,250,0,380)
frame.Position = UDim2.new(0,20,0.5,-190)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = gui
frame.Active = true

Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke",frame)
stroke.Color = Color3.fromRGB(90,90,90)
stroke.Thickness = 1

-- ======================
-- BUTTON CREATOR
-- ======================

local function createButton(text,posY,color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1,-20,0,40)
    button.Position = UDim2.new(0,10,0,posY)
    button.BackgroundColor3 = color or Color3.fromRGB(60,60,60)
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.Text = text
    button.Parent = frame

    Instance.new("UICorner",button).CornerRadius = UDim.new(0,10)
    local stroke = Instance.new("UIStroke",button)
    stroke.Color = Color3.fromRGB(100,100,100)
    stroke.Thickness = 1

    -- TEXT FIT
    button.TextScaled = true
    button.TextWrapped = true

    return button
end

-- ======================
-- BUTTONS
-- ======================

local lootButton = createButton("Auto Loot: OFF",10)
local berryButton = createButton("Auto Berry: OFF",60)

local tpButton = createButton("Teleport to Siren Head Lighthouse",110)
local shopButton = createButton("Teleport to Shop",160)

local sirenBtn = createButton("Lock Siren Camera: OFF",210)
local catBtn = createButton("Lock Cartoon Cat Camera: OFF",260)

local destroyButton = createButton("Destroy Script",310,Color3.fromRGB(170,40,40))

-- ======================
-- CREDIT
-- ======================

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1,0,0,16)
credit.Position = UDim2.new(0,0,1,-18)
credit.BackgroundTransparency = 1
credit.Text = "Script was made by: MKdoyu34"
credit.TextColor3 = Color3.fromRGB(150,150,150)
credit.Font = Enum.Font.Gotham
credit.TextSize = 10
credit.Parent = frame

-- ======================
-- DRAG
-- ======================

local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        dragInput = input

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

-- ======================
-- PROMPT TRIGGER
-- ======================

local function triggerPrompt(obj)
    for _,v in pairs(obj:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            fireproximityprompt(v)
        end
    end
end

-- ======================
-- AUTO LOOT
-- ======================

task.spawn(function()
    while true do
        if autoLoot then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")

                for _,crate in pairs(lootFolder:GetChildren()) do
                    if not autoLoot then break end
                    if crate.Name == "Crate" and hrp then
                        hrp.CFrame = CFrame.new(crate:GetPivot().Position + Vector3.new(0,3,0))
                        task.wait(0.25)
                        triggerPrompt(crate)
                    end
                end
            end
        end
        task.wait(0.2)
    end
end)

-- ======================
-- AUTO BERRY
-- ======================

task.spawn(function()
    while true do
        if autoBerry then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")

                local nearest, dist = nil, math.huge
                for _,b in pairs(harvestFolder:GetChildren()) do
                    if b.Name == "berry" and hrp then
                        local d = (hrp.Position - b:GetPivot().Position).Magnitude
                        if d < dist then
                            dist = d
                            nearest = b
                        end
                    end
                end

                if nearest and hrp then
                    hrp.CFrame = CFrame.new(nearest:GetPivot().Position + Vector3.new(0,3,0))
                    local t = tick()

                    while nearest.Parent and autoBerry do
                        triggerPrompt(nearest)
                        task.wait(0.08)
                        if tick() - t > 2 then break end
                    end
                end
            end
        end
        task.wait(0.2)
    end
end)

-- ======================
-- CAMERA LOCKS
-- ======================

local function getSiren()
    local m = workspace:WaitForChild("scps"):WaitForChild("real_siren")
    return m:FindFirstChild("HumanoidRootPart") or m:FindFirstChild("Head")
end

local function getCat()
    local m = workspace:WaitForChild("scps"):WaitForChild("real_cartoon_cat")
    return m:FindFirstChild("HumanoidRootPart") or m:FindFirstChild("Head")
end

task.spawn(function()
    while true do
        if sirenLock then
            local s = getSiren()
            if s then
                camera.CFrame = CFrame.new(camera.CFrame.Position, s.Position)
            end
        end

        if catLock then
            local c = getCat()
            if c then
                camera.CFrame = CFrame.new(camera.CFrame.Position, c.Position)
            end
        end

        task.wait(0.03)
    end
end)

-- ======================
-- BUTTON FUNCTIONS
-- ======================

lootButton.MouseButton1Click:Connect(function()
    autoLoot = not autoLoot
    lootButton.Text = autoLoot and "Auto Loot: ON" or "Auto Loot: OFF"
end)

berryButton.MouseButton1Click:Connect(function()
    autoBerry = not autoBerry
    berryButton.Text = autoBerry and "Auto Berry: ON" or "Auto Berry: OFF"
end)

tpButton.MouseButton1Click:Connect(function()
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local target = workspace.Towers.Tower.Lever:FindFirstChild("Metal1")
        if hrp and target then
            hrp.CFrame = target.CFrame + Vector3.new(0,3,0)
        end
    end
end)

shopButton.MouseButton1Click:Connect(function()
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local target = workspace:WaitForChild("shop"):FindFirstChild("Torso")
        if hrp and target then
            hrp.CFrame = target.CFrame + Vector3.new(0,3,0)
        end
    end
end)

sirenBtn.MouseButton1Click:Connect(function()
    sirenLock = not sirenLock
    sirenBtn.Text = sirenLock and "Lock Siren Camera: ON" or "Lock Siren Camera: OFF"
end)

catBtn.MouseButton1Click:Connect(function()
    catLock = not catLock
    catBtn.Text = catLock and "Lock Camera to Cartoon Cat : ON" or "Lock Camera to Cartoon Cat Camera: OFF"
end)

destroyButton.MouseButton1Click:Connect(function()
    autoLoot = false
    autoBerry = false
    sirenLock = false
    catLock = false
    gui:Destroy()
end)
