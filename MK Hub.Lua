-- MK Hub

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local playerGui = player:WaitForChild("PlayerGui")

-------------------------------------------------
-- GUI
-------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "MKHub"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,500,0,270)
mainFrame.Position = UDim2.new(0.5,-250,0.5,-135)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.Parent = gui
mainFrame.Active = true
Instance.new("UICorner",mainFrame)

-------------------------------------------------
-- TOP BAR
-------------------------------------------------

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,35)
topBar.BackgroundColor3 = Color3.fromRGB(35,35,35)
topBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "MK Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0,30,0,25)
collapseButton.Position = UDim2.new(1,-35,0,5)
collapseButton.Text = "-"
collapseButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
collapseButton.TextColor3 = Color3.new(1,1,1)
collapseButton.Parent = topBar
Instance.new("UICorner",collapseButton)

-------------------------------------------------
-- SECTIONS
-------------------------------------------------

local autoFarmFrame = Instance.new("Frame")
autoFarmFrame.Size = UDim2.new(0,160,1,-35)
autoFarmFrame.Position = UDim2.new(0,0,0,35)
autoFarmFrame.BackgroundTransparency = 1
autoFarmFrame.Parent = mainFrame

local tpFrame = Instance.new("Frame")
tpFrame.Size = UDim2.new(0,180,1,-35)
tpFrame.Position = UDim2.new(0,160,0,35)
tpFrame.BackgroundTransparency = 1
tpFrame.Parent = mainFrame

local camFrame = Instance.new("Frame")
camFrame.Size = UDim2.new(0,160,1,-35)
camFrame.Position = UDim2.new(0,340,0,35)
camFrame.BackgroundTransparency = 1
camFrame.Parent = mainFrame

-------------------------------------------------
-- BUTTON CREATOR
-------------------------------------------------

local function createButton(text,pos,parent,color)

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-20,0,35)
    b.Position = UDim2.new(0,10,0,pos)
    b.BackgroundColor3 = color or Color3.fromRGB(60,60,60)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.Text = text
    b.Parent = parent
    Instance.new("UICorner",b)

    return b
end

-------------------------------------------------
-- AUTO FARM VARIABLES
-------------------------------------------------

local autoLoot = false
local autoBerry = false
local lastCrate

-------------------------------------------------
-- RANDOM CRATE
-------------------------------------------------

local function getRandomCrate()

    local folder = workspace:FindFirstChild("Loot")
    if not folder then return end

    local crates = {}

    for _,v in pairs(folder:GetChildren()) do
        if v.Name == "Crate" and v:IsA("BasePart") then
            if v ~= lastCrate then
                table.insert(crates,v)
            end
        end
    end

    if #crates == 0 then return end

    local random = crates[math.random(1,#crates)]
    lastCrate = random

    return random

end

-------------------------------------------------
-- BERRY FINDER
-------------------------------------------------

local function getNearestBerry()

    local char = player.Character
    if not char then return end

    local closest
    local shortest = math.huge

    local folder = workspace:FindFirstChild("Harvest")
    if not folder then return end

    for _,v in pairs(folder:GetChildren()) do
        if v:IsA("BasePart") then

            local dist = (char.HumanoidRootPart.Position - v.Position).Magnitude

            if dist < shortest then
                shortest = dist
                closest = v
            end

        end
    end

    return closest

end

-------------------------------------------------
-- AUTO FARM LOOPS
-------------------------------------------------

task.spawn(function()

    while true do
        task.wait(0.3)

        if autoLoot then

            local crate = getRandomCrate()
            local char = player.Character

            if crate and char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = crate.CFrame + Vector3.new(0,3,0)
                task.wait(0.1)
            end

        end

    end

end)

task.spawn(function()

    while true do
        task.wait(0.3)

        if autoBerry then

            local berry = getNearestBerry()
            local char = player.Character

            if berry and char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = berry.CFrame + Vector3.new(0,3,0)
            end

        end

    end

end)

-------------------------------------------------
-- AUTO FARM BUTTONS
-------------------------------------------------

local lootButton = createButton("Auto Loot: OFF",40,autoFarmFrame)
local berryButton = createButton("Auto Berry: OFF",85,autoFarmFrame)

lootButton.Activated:Connect(function()
autoLoot = not autoLoot
lootButton.Text = "Auto Loot: "..(autoLoot and "ON" or "OFF")
end)

berryButton.Activated:Connect(function()
autoBerry = not autoBerry
berryButton.Text = "Auto Berry: "..(autoBerry and "ON" or "OFF")
end)

-------------------------------------------------
-- TELEPORT BUTTONS
-------------------------------------------------

local shopButton = createButton("Teleport To Shop",40,tpFrame)

shopButton.Activated:Connect(function()

local char = player.Character
local shop = workspace:FindFirstChild("shop")

if char and shop then
local torso = shop:FindFirstChild("Torso")
if torso then
char.HumanoidRootPart.CFrame = torso.CFrame + Vector3.new(0,3,0)
end
end

end)

local sirenButton = createButton("Teleport To SirenHead Lighthouse",85,tpFrame)

sirenButton.Activated:Connect(function()

local char = player.Character
local metal = workspace.Towers.Tower.Lever:FindFirstChild("Metal1")

if char and metal then
char.HumanoidRootPart.CFrame = metal.CFrame + Vector3.new(0,3,0)
end

end)

local militaryButton = createButton("Teleport To Military Base Lighthouse",130,tpFrame)

militaryButton.Activated:Connect(function()

local char = player.Character
local towers = workspace:FindFirstChild("Towers")

if char and towers then
local tower = towers:GetChildren()[2]
if tower then
local metal = tower.Lever:FindFirstChild("Metal1")
if metal then
char.HumanoidRootPart.CFrame = metal.CFrame + Vector3.new(0,3,0)
end
end
end

end)

-------------------------------------------------
-- CAMERA
-------------------------------------------------

local camButton = createButton("Lock Camera To Siren",40,camFrame)

local lock = false
local connection

camButton.Activated:Connect(function()

lock = not lock

if lock then

camButton.Text = "Lock Camera: ON"

connection = RunService.RenderStepped:Connect(function()

local siren = workspace.scps.real_siren:FindFirstChild("HumanoidRootPart",true)

if siren then
camera.CFrame = CFrame.new(camera.CFrame.Position,siren.Position)
end

end)

else

camButton.Text = "Lock Camera: OFF"

if connection then
connection:Disconnect()
end

end

end)

local camButton = createButton("Lock Camera To Cartoon Cat(NPC): OFF",85,camFrame)

local lock = false
local connection

camButton.Activated:Connect(function()

lock = not lock

if lock then

camButton.Text = "Lock Camera To Cartoon Cat(NPC): ON"

connection = RunService.RenderStepped:Connect(function()

local cartoon = workspace.scps.real_cartoon_cat:FindFirstChild("HumanoidRootPart",true)

if siren then
camera.CFrame = CFrame.new(camera.CFrame.Position,cartoon.Position)
end

end)

else

camButton.Text = "Lock Camera To Cartoon Cat(NPC): OFF"

if connection then
connection:Disconnect()
end

end

end)

-------------------------------------------------
-- DESTROY BUTTON
-------------------------------------------------

local destroyButton = createButton("Destroy Script",200,camFrame,Color3.fromRGB(170,40,40))

destroyButton.Activated:Connect(function()
gui:Destroy()
end)

-------------------------------------------------
-- MK TOGGLE BUTTON
-------------------------------------------------

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0,50,0,50)
toggleButton.Position = UDim2.new(0,20,0.5,-25)
toggleButton.Text = "MK"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 18
toggleButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Parent = gui
Instance.new("UICorner",toggleButton)

local visible = true

toggleButton.Activated:Connect(function()
visible = not visible
mainFrame.Visible = visible
end)

-------------------------------------------------
-- DRAG MAIN GUI
-------------------------------------------------

local dragging
local dragInput
local dragStart
local startPos

local function update(input)

local delta = input.Position - dragStart

mainFrame.Position = UDim2.new(
startPos.X.Scale,
startPos.X.Offset + delta.X,
startPos.Y.Scale,
startPos.Y.Offset + delta.Y
)

end

topBar.InputBegan:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch then

dragging = true
dragStart = input.Position
startPos = mainFrame.Position

end

end)

topBar.InputChanged:Connect(function(input)

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
