--[[
    SKIDZTEAM FARM GUI - FIXED TABS + EGG SELECTOR
    Features: Auto Farm Wheel, Auto Launch VM, Auto Egg (with egg selection list)
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Remotes
local Knit = ReplicatedStorage:FindFirstChild("Library") and ReplicatedStorage.Library:FindFirstChild("Knit")
local TrainingService = Knit and Knit.Services:FindFirstChild("TrainingService")
local ThrowService = Knit and Knit.Services:FindFirstChild("ThrowService")
local EggsService = Knit and Knit.Services:FindFirstChild("EggsService")

local TrainRemote = TrainingService and TrainingService.RE:FindFirstChild("Train")
local ThrowRemote = ThrowService and ThrowService.RE:FindFirstChild("Throw")
local EggRemote = EggsService and EggsService.RE:FindFirstChild("HatchEgg")

-- Egg list (provided by user)
local EGG_LIST = {
    "Basic Egg", "Bee Egg", "Dragon Egg", "Cactus Egg", "Desert Egg",
    "Pyramid Egg", "Timeless Egg", "Void Egg", "Carrot Egg", "Turkey Egg",
    "Prickly Egg", "Atlantis Egg", "Kraken Egg", "500K Egg", "Season 1 Egg",
    "Abyss Egg", "Space Egg", "Alien Egg"
}

-- GUI Elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FarmGUI"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 550, 0, 520)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

-- Glow Border
local glowBorder = Instance.new("Frame")
glowBorder.Size = UDim2.new(1, 4, 1, 4)
glowBorder.Position = UDim2.new(0, -2, 0, -2)
glowBorder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
glowBorder.BackgroundTransparency = 0.5
glowBorder.BorderSizePixel = 0
glowBorder.Parent = mainFrame
local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 18)
glowCorner.Parent = glowBorder

local glowGradient = Instance.new("UIGradient")
glowGradient.Rotation = 45
glowGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 0, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 150, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 150))
})
glowGradient.Parent = glowBorder

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
titleBar.BackgroundTransparency = 0.15
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 16)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -100, 1, 0)
titleText.Position = UDim2.new(0, 20, 0, 0)
titleText.Text = "SKIDZTEAM"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local subText = Instance.new("TextLabel")
subText.Size = UDim2.new(1, -100, 1, 0)
subText.Position = UDim2.new(0, 20, 0, 22)
subText.Text = "FARM EDITION"
subText.TextColor3 = Color3.fromRGB(150, 100, 255)
subText.BackgroundTransparency = 1
subText.Font = Enum.Font.Gotham
subText.TextSize = 10
subText.TextXAlignment = Enum.TextXAlignment.Left
subText.Parent = titleBar

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
minimizeBtn.Position = UDim2.new(1, -80, 0, 5)
minimizeBtn.Text = "─"
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
minimizeBtn.BackgroundTransparency = 0.3
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 20
minimizeBtn.Parent = titleBar
local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimizeBtn

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 35)
closeBtn.BackgroundTransparency = 0.3
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = titleBar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Content Container
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -40, 1, -65)
contentContainer.Position = UDim2.new(0, 20, 0, 55)
contentContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
contentContainer.BackgroundTransparency = 0.2
contentContainer.BorderSizePixel = 0
contentContainer.Parent = mainFrame
local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 12)
contentCorner.Parent = contentContainer

-- Tabs Frame
local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(1, 0, 0, 40)
tabsFrame.BackgroundTransparency = 1
tabsFrame.Parent = contentContainer

-- Tab buttons
local tabButtons = {}
local currentTab = 1
local farmPanel = nil
local mainPanel = nil

local function CreateTabButton(name, position)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 1, -10)
    btn.Position = UDim2.new(0, position, 0, 5)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = tabsFrame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    return btn
end

-- Create panels
farmPanel = Instance.new("ScrollingFrame")
farmPanel.Name = "FarmPanel"
farmPanel.Size = UDim2.new(1, -20, 1, -55)
farmPanel.Position = UDim2.new(0, 10, 0, 50)
farmPanel.BackgroundTransparency = 1
farmPanel.BorderSizePixel = 0
farmPanel.CanvasSize = UDim2.new(0, 0, 0, 600)
farmPanel.ScrollBarThickness = 4
farmPanel.ScrollBarImageColor3 = Color3.fromRGB(100, 80, 150)
farmPanel.Parent = contentContainer

mainPanel = Instance.new("ScrollingFrame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(1, -20, 1, -55)
mainPanel.Position = UDim2.new(0, 10, 0, 50)
mainPanel.BackgroundTransparency = 1
mainPanel.BorderSizePixel = 0
mainPanel.CanvasSize = UDim2.new(0, 0, 0, 300)
mainPanel.ScrollBarThickness = 4
mainPanel.ScrollBarImageColor3 = Color3.fromRGB(100, 80, 150)
mainPanel.Parent = contentContainer
mainPanel.Visible = false

-- Tab creation
local farmBtn = CreateTabButton("FARM", 10)
local mainBtn = CreateTabButton("MAIN", 140)
tabButtons = {farmBtn, mainBtn}

farmBtn.MouseButton1Click:Connect(function()
    currentTab = 1
    farmPanel.Visible = true
    mainPanel.Visible = false
    for _, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    end
    farmBtn.BackgroundColor3 = Color3.fromRGB(80, 50, 150)
    farmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

mainBtn.MouseButton1Click:Connect(function()
    currentTab = 2
    farmPanel.Visible = false
    mainPanel.Visible = true
    for _, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    end
    mainBtn.BackgroundColor3 = Color3.fromRGB(80, 50, 150)
    mainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

-- Set initial active tab
farmBtn.BackgroundColor3 = Color3.fromRGB(80, 50, 150)
farmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Helper function: create a toggle with speed slider
local function CreateToggleWithSlider(parent, name, description, yPos, remoteFunc, defaultSpeed)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 110)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 0, 20)
    titleLabel.Position = UDim2.new(0, 15, 0, 8)
    titleLabel.Text = name
    titleLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.7, 0, 0, 15)
    descLabel.Position = UDim2.new(0, 15, 0, 28)
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    descLabel.BackgroundTransparency = 1
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 10
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 60, 0, 30)
    toggleBtn.Position = UDim2.new(1, -75, 0, 5)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 35)
    toggleBtn.BackgroundTransparency = 0.2
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 11
    toggleBtn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = toggleBtn
    
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 100, 0, 20)
    speedLabel.Position = UDim2.new(0, 15, 0, 55)
    speedLabel.Text = "Delay (ms):"
    speedLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextSize = 11
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = frame
    
    local speedValue = Instance.new("TextLabel")
    speedValue.Size = UDim2.new(0, 50, 0, 20)
    speedValue.Position = UDim2.new(1, -130, 0, 55)
    speedValue.Text = tostring(defaultSpeed * 1000) .. " ms"
    speedValue.TextColor3 = Color3.fromRGB(100, 200, 255)
    speedValue.BackgroundTransparency = 1
    speedValue.Font = Enum.Font.Gotham
    speedValue.TextSize = 11
    speedValue.TextXAlignment = Enum.TextXAlignment.Right
    speedValue.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0, 200, 0, 4)
    sliderBg.Position = UDim2.new(0, 15, 0, 80)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 2)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(defaultSpeed, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 80, 200)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 2)
    sliderFillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 12, 0, 12)
    sliderButton.Position = UDim2.new(defaultSpeed, -6, 0, -4)
    sliderButton.BackgroundColor3 = Color3.fromRGB(200, 180, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderBg
    local sliderBtnCorner = Instance.new("UICorner")
    sliderBtnCorner.CornerRadius = UDim.new(0, 6)
    sliderBtnCorner.Parent = sliderButton
    
    local state = false
    local speed = defaultSpeed
    local running = false
    
    local function updateSlider(value)
        speed = math.clamp(value, 0.05, 2)
        sliderFill.Size = UDim2.new(speed, 0, 1, 0)
        sliderButton.Position = UDim2.new(speed, -6, 0, -4)
        speedValue.Text = math.floor(speed * 1000) .. " ms"
    end
    
    local function loop()
        while running and state do
            if remoteFunc then remoteFunc() end
            wait(speed)
        end
    end
    
    local function startLoop()
        if running then return end
        running = true
        spawn(loop)
    end
    
    local function stopLoop()
        running = false
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.TextColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        if state then
            startLoop()
        else
            stopLoop()
        end
    end)
    
    local dragging = false
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X
            local sliderPos = sliderBg.AbsolutePosition.X
            local sliderWidth = sliderBg.AbsoluteSize.X
            local newValue = (mousePos - sliderPos) / sliderWidth
            newValue = math.clamp(newValue, 0.05, 2)
            updateSlider(newValue)
            if state then
                stopLoop()
                startLoop()
            end
        end
    end)
    
    return {frame = frame, toggle = toggleBtn, setEnabled = function(enabled) state = enabled; toggleBtn.Text = enabled and "ON" or "OFF"; if enabled then startLoop() else stopLoop() end end}
end

-- Egg selector (dropdown with list)
local function CreateEggSelector(parent, yPos)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 180)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 0, 20)
    titleLabel.Position = UDim2.new(0, 15, 0, 8)
    titleLabel.Text = "Auto Egg Hatch"
    titleLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.7, 0, 0, 15)
    descLabel.Position = UDim2.new(0, 15, 0, 28)
    descLabel.Text = "Select an egg from the list"
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    descLabel.BackgroundTransparency = 1
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 10
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 60, 0, 30)
    toggleBtn.Position = UDim2.new(1, -75, 0, 5)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 35)
    toggleBtn.BackgroundTransparency = 0.2
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 11
    toggleBtn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = toggleBtn
    
    -- Selected egg display
    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Size = UDim2.new(0, 200, 0, 25)
    selectedLabel.Position = UDim2.new(0, 15, 0, 55)
    selectedLabel.Text = "Selected: Dragon Egg"
    selectedLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    selectedLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    selectedLabel.BackgroundTransparency = 0.2
    selectedLabel.BorderSizePixel = 0
    selectedLabel.Font = Enum.Font.Gotham
    selectedLabel.TextSize = 11
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedLabel.Parent = frame
    local selCorner = Instance.new("UICorner")
    selCorner.CornerRadius = UDim.new(0, 4)
    selCorner.Parent = selectedLabel
    
    -- Button to open egg list
    local listBtn = Instance.new("TextButton")
    listBtn.Size = UDim2.new(0, 80, 0, 25)
    listBtn.Position = UDim2.new(0, 230, 0, 55)
    listBtn.Text = "Change Egg"
    listBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    listBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 100)
    listBtn.BackgroundTransparency = 0.2
    listBtn.BorderSizePixel = 0
    listBtn.Font = Enum.Font.GothamBold
    listBtn.TextSize = 11
    listBtn.Parent = frame
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 4)
    listCorner.Parent = listBtn
    
    -- Egg list popup
    local popup = Instance.new("Frame")
    popup.Size = UDim2.new(0, 200, 0, 200)
    popup.Position = UDim2.new(0, 230, 0, 85)
    popup.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    popup.BackgroundTransparency = 0.1
    popup.BorderSizePixel = 0
    popup.Visible = false
    popup.Parent = frame
    local popupCorner = Instance.new("UICorner")
    popupCorner.CornerRadius = UDim.new(0, 8)
    popupCorner.Parent = popup
    
    local scrollList = Instance.new("ScrollingFrame")
    scrollList.Size = UDim2.new(1, -10, 1, -10)
    scrollList.Position = UDim2.new(0, 5, 0, 5)
    scrollList.BackgroundTransparency = 1
    scrollList.BorderSizePixel = 0
    scrollList.CanvasSize = UDim2.new(0, 0, 0, #EGG_LIST * 25)
    scrollList.ScrollBarThickness = 4
    scrollList.Parent = popup
    
    local selectedEgg = "Dragon Egg"
    local eggButtons = {}
    
    local function updateSelectedLabel()
        selectedLabel.Text = "Selected: " .. selectedEgg
    end
    
    local y = 0
    for _, egg in ipairs(EGG_LIST) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 22)
        btn.Position = UDim2.new(0, 5, 0, y)
        btn.Text = egg
        btn.TextColor3 = Color3.fromRGB(200, 200, 220)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        btn.Parent = scrollList
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            selectedEgg = egg
            updateSelectedLabel()
            popup.Visible = false
        end)
        
        table.insert(eggButtons, btn)
        y = y + 25
    end
    scrollList.CanvasSize = UDim2.new(0, 0, 0, y)
    
    listBtn.MouseButton1Click:Connect(function()
        popup.Visible = not popup.Visible
    end)
    
    -- Close popup when clicking outside
    local function closePopupOnClick(input)
        if popup.Visible then
            local mousePos = input.Position
            local popupAbsPos = popup.AbsolutePosition
            local popupSize = popup.AbsoluteSize
            if mousePos.X < popupAbsPos.X or mousePos.X > popupAbsPos.X + popupSize.X or
               mousePos.Y < popupAbsPos.Y or mousePos.Y > popupAbsPos.Y + popupSize.Y then
                popup.Visible = false
            end
        end
    end
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            closePopupOnClick(input)
        end
    end)
    
    -- Speed slider for egg hatch
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 100, 0, 20)
    speedLabel.Position = UDim2.new(0, 15, 0, 90)
    speedLabel.Text = "Hatch Delay (ms):"
    speedLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextSize = 11
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = frame
    
    local speedValue = Instance.new("TextLabel")
    speedValue.Size = UDim2.new(0, 50, 0, 20)
    speedValue.Position = UDim2.new(1, -130, 0, 90)
    speedValue.Text = "500 ms"
    speedValue.TextColor3 = Color3.fromRGB(100, 200, 255)
    speedValue.BackgroundTransparency = 1
    speedValue.Font = Enum.Font.Gotham
    speedValue.TextSize = 11
    speedValue.TextXAlignment = Enum.TextXAlignment.Right
    speedValue.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0, 200, 0, 4)
    sliderBg.Position = UDim2.new(0, 15, 0, 115)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 2)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 80, 200)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 2)
    sliderFillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 12, 0, 12)
    sliderButton.Position = UDim2.new(0.5, -6, 0, -4)
    sliderButton.BackgroundColor3 = Color3.fromRGB(200, 180, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderBg
    local sliderBtnCorner = Instance.new("UICorner")
    sliderBtnCorner.CornerRadius = UDim.new(0, 6)
    sliderBtnCorner.Parent = sliderButton
    
    local batchLabel = Instance.new("TextLabel")
    batchLabel.Size = UDim2.new(0, 80, 0, 20)
    batchLabel.Position = UDim2.new(0, 15, 0, 140)
    batchLabel.Text = "Batch Size:"
    batchLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    batchLabel.BackgroundTransparency = 1
    batchLabel.Font = Enum.Font.Gotham
    batchLabel.TextSize = 11
    batchLabel.TextXAlignment = Enum.TextXAlignment.Left
    batchLabel.Parent = frame
    
    local batchBox = Instance.new("TextBox")
    batchBox.Size = UDim2.new(0, 80, 0, 25)
    batchBox.Position = UDim2.new(0, 100, 0, 137)
    batchBox.PlaceholderText = "1"
    batchBox.Text = "1"
    batchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    batchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    batchBox.BackgroundTransparency = 0.2
    batchBox.BorderSizePixel = 0
    batchBox.Font = Enum.Font.Gotham
    batchBox.TextSize = 11
    batchBox.Parent = frame
    local batchCorner = Instance.new("UICorner")
    batchCorner.CornerRadius = UDim.new(0, 4)
    batchCorner.Parent = batchBox
    
    local state = false
    local speed = 0.5
    local batch = 1
    local running = false
    
    local function updateSlider(value)
        speed = math.clamp(value, 0.05, 2)
        sliderFill.Size = UDim2.new(speed, 0, 1, 0)
        sliderButton.Position = UDim2.new(speed, -6, 0, -4)
        speedValue.Text = math.floor(speed * 1000) .. " ms"
    end
    
    local function updateBatch()
        local num = tonumber(batchBox.Text)
        if num and num > 0 then batch = num else batch = 1 end
        batchBox.Text = tostring(batch)
    end
    batchBox:GetPropertyChangedSignal("Text"):Connect(updateBatch)
    
    local function hatchLoop()
        while running and state and EggRemote do
            for i = 1, batch do
                if not running or not state then break end
                EggRemote:FireServer(selectedEgg, "Single")
                wait(0.05)
            end
            wait(speed)
        end
    end
    
    local function startLoop()
        if running then return end
        running = true
        spawn(hatchLoop)
    end
    
    local function stopLoop()
        running = false
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.TextColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        if state then
            startLoop()
        else
            stopLoop()
        end
    end)
    
    local draggingSlider = false
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X
            local sliderPos = sliderBg.AbsolutePosition.X
            local sliderWidth = sliderBg.AbsoluteSize.X
            local newValue = (mousePos - sliderPos) / sliderWidth
            newValue = math.clamp(newValue, 0.05, 2)
            updateSlider(newValue)
            if state then
                stopLoop()
                startLoop()
            end
        end
    end)
    
    return {frame = frame, toggle = toggleBtn}
end

-- Populate Farm Panel
local yFarm = 10

-- Auto Farm Wheel
local function wheelFunc()
    if TrainRemote then TrainRemote:FireServer("1|1") end
end
local wheelToggle = CreateToggleWithSlider(farmPanel, "Auto Farm Wheel", "Spams training remote", yFarm, wheelFunc, 0.3)
yFarm = yFarm + 120

-- Auto Launch VM
local function vmFunc()
    if ThrowRemote then ThrowRemote:FireServer() end
end
local vmToggle = CreateToggleWithSlider(farmPanel, "Auto Launch VM", "Spams throw remote (0.7s default)", yFarm, vmFunc, 0.7)
yFarm = yFarm + 120

-- Auto Egg with selector
local eggSelector = CreateEggSelector(farmPanel, yFarm)
yFarm = yFarm + 190

farmPanel.CanvasSize = UDim2.new(0, 0, 0, yFarm + 20)

-- Main Panel (Credits)
local creditFrame = Instance.new("Frame")
creditFrame.Size = UDim2.new(1, -40, 0, 220)
creditFrame.Position = UDim2.new(0, 20, 0, 20)
creditFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
creditFrame.BackgroundTransparency = 0.2
creditFrame.BorderSizePixel = 0
creditFrame.Parent = mainPanel
local creditCorner = Instance.new("UICorner")
creditCorner.CornerRadius = UDim.new(0, 12)
creditCorner.Parent = creditFrame

local creditTitle = Instance.new("TextLabel")
creditTitle.Size = UDim2.new(1, -40, 0, 40)
creditTitle.Position = UDim2.new(0, 20, 0, 10)
creditTitle.Text = "CREDITS"
creditTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
creditTitle.BackgroundTransparency = 1
creditTitle.Font = Enum.Font.GothamBold
creditTitle.TextSize = 18
creditTitle.TextXAlignment = Enum.TextXAlignment.Left
creditTitle.Parent = creditFrame

local creditLines = {
    "Script by: SKIDZTEAM",
    "AI Assistant: DeepSeek",
    "GUI Design: Futuristic Premium",
    "Remote Structure: Reverse Engineered",
    "Version: 2.0"
}
local yCredit = 60
for _, line in ipairs(creditLines) do
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -40, 0, 25)
    lbl.Position = UDim2.new(0, 20, 0, yCredit)
    lbl.Text = "• " .. line
    lbl.TextColor3 = Color3.fromRGB(200, 200, 220)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = creditFrame
    yCredit = yCredit + 30
end

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -40, 0, 30)
footer.Position = UDim2.new(0, 20, 0, yCredit + 10)
footer.Text = "Press K to toggle menu"
footer.TextColor3 = Color3.fromRGB(100, 100, 130)
footer.BackgroundTransparency = 1
footer.Font = Enum.Font.Gotham
footer.TextSize = 10
footer.TextXAlignment = Enum.TextXAlignment.Left
footer.Parent = creditFrame

mainPanel.CanvasSize = UDim2.new(0, 0, 0, yCredit + 80)

-- Minimize / Restore
local minimized = false
local minimizedSize = UDim2.new(0, 550, 0, 45)
local expandedSize = UDim2.new(0, 550, 0, 520)
local minTween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = minimizedSize})
local expTween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = expandedSize})

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        minTween:Play()
        minimizeBtn.Text = "□"
        contentContainer.Visible = false
    else
        expTween:Play()
        minimizeBtn.Text = "─"
        contentContainer.Visible = true
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Toggle GUI with K
local guiVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        guiVisible = not guiVisible
        screenGui.Enabled = guiVisible
    end
end)

-- Dragging
local dragging = false
local dragStart = nil
local startPos = nil
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Glow animation
local glowIntensity = 0
local glowIncreasing = true
spawn(function()
    while screenGui and screenGui.Parent do
        if glowIncreasing then
            glowIntensity = glowIntensity + 0.02
            if glowIntensity >= 0.8 then glowIncreasing = false end
        else
            glowIntensity = glowIntensity - 0.02
            if glowIntensity <= 0.2 then glowIncreasing = true end
        end
        glowBorder.BackgroundTransparency = 0.3 - (glowIntensity * 0.2)
        wait(0.05)
    end
end)

local bgGradient = Instance.new("UIGradient")
bgGradient.Rotation = 0
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 8, 12)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 10, 20))
})
bgGradient.Parent = mainFrame

local rotation = 0
spawn(function()
    while screenGui and screenGui.Parent do
        rotation = rotation + 0.5
        if rotation > 360 then rotation = 0 end
        bgGradient.Rotation = rotation
        wait(0.05)
    end
end)

print("SKIDZTEAM Farm GUI Loaded - Press K to toggle")
