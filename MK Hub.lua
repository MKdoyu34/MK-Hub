local player = game.Players.LocalPlayer
local lootFolder = workspace:WaitForChild("Loot")
local harvestFolder = workspace:WaitForChild("harvest")

local UIS = game:GetService("UserInputService")

local autoLoot = false
local autoBerry = false

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
frame.Size = UDim2.new(0,250,0,320)
frame.Position = UDim2.new(0,20,0.5,-160)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = gui
frame.Active = true

Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke",frame)
stroke.Color = Color3.fromRGB(90,90,90)
stroke.Thickness = 1

-- ======================
-- TOP BAR
-- ======================

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,35)
topBar.BackgroundTransparency = 1
topBar.Parent = frame

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

-- ======================
-- COLLAPSE BUTTON
-- ======================

local collapsed = false

local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0,30,0,25)
collapseButton.Position = UDim2.new(1,-35,0,5)
collapseButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
collapseButton.Text = "-"
collapseButton.TextColor3 = Color3.new(1,1,1)
collapseButton.Font = Enum.Font.GothamBold
collapseButton.TextSize = 18
collapseButton.Parent = topBar

Instance.new("UICorner",collapseButton).CornerRadius = UDim.new(0,8)

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

	return button
end

local lootButton = createButton("Auto Loot: OFF",45)
local berryButton = createButton("Auto Berry: OFF",95)
local tpButton = createButton("TP: Siren Cave Lighthouse",145)
local shopButton = createButton("TP: Shop",195)
local destroyButton = createButton("Destroy Script",245,Color3.fromRGB(170,40,40))

-- ======================
-- CREDIT TEXT
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
-- COLLAPSE FUNCTION
-- ======================

local function setVisible(state)
	lootButton.Visible = state
	berryButton.Visible = state
	tpButton.Visible = state
	shopButton.Visible = state
	destroyButton.Visible = state
	credit.Visible = state
end

collapseButton.MouseButton1Click:Connect(function()
	collapsed = not collapsed

	if collapsed then
		setVisible(false)
		frame.Size = UDim2.new(0,250,0,40)
		collapseButton.Text = "+"
	else
		setVisible(true)
		frame.Size = UDim2.new(0,250,0,320)
		collapseButton.Text = "-"
	end
end)

-- ======================
-- SMOOTH DRAGGING
-- ======================

local dragging = false
local dragInput
local dragStart
local startPos

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
-- TRIGGER PROMPT
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

local function startLoot()
	task.spawn(function()
		while autoLoot do
			local character = player.Character or player.CharacterAdded:Wait()
			local hrp = character:WaitForChild("HumanoidRootPart")

			for _,crate in pairs(lootFolder:GetChildren()) do
				if not autoLoot then break end
				if crate.Name == "Crate" then
					local pos = crate:GetPivot().Position
					hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
					task.wait(0.15)
					triggerPrompt(crate)
				end
			end

			task.wait(0.2)
		end
	end)
end

-- ======================
-- AUTO BERRY
-- ======================

local function startBerry()
	task.spawn(function()
		while autoBerry do
			local character = player.Character or player.CharacterAdded:Wait()
			local hrp = character:WaitForChild("HumanoidRootPart")

			local nearestBerry = nil
			local minDist = math.huge

			for _, berry in pairs(harvestFolder:GetChildren()) do
				if berry.Name == "berry" then
					local pos = berry:GetPivot().Position
					local dist = (hrp.Position - pos).Magnitude

					if dist < minDist then
						minDist = dist
						nearestBerry = berry
					end
				end
			end

			if nearestBerry then
				local pos = nearestBerry:GetPivot().Position
				hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0))

				local start = tick()

				while nearestBerry.Parent and autoBerry do
					triggerPrompt(nearestBerry)
					task.wait(0.05)

					if tick() - start > 3 then
						break
					end
				end
			else
				task.wait(0.3)
			end
		end
	end)
end

-- ======================
-- BUTTONS
-- ======================

lootButton.MouseButton1Click:Connect(function()
	autoLoot = not autoLoot
	lootButton.Text = autoLoot and "Auto Loot: ON" or "Auto Loot: OFF"

	if autoLoot then
		startLoot()
	end
end)

berryButton.MouseButton1Click:Connect(function()
	autoBerry = not autoBerry
	berryButton.Text = autoBerry and "Auto Berry: ON" or "Auto Berry: OFF"

	if autoBerry then
		startBerry()
	end
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

destroyButton.MouseButton1Click:Connect(function()
	autoLoot = false
	autoBerry = false
	gui:Destroy()
end)
