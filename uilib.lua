local NobGG = {}

-- Library Variables (brought from Pepsi lib)
local library = {
	Version = "0.36",
	WorkspaceName = "NobGG Lib",
	flags = {},
	signals = {},
	objects = {},
	elements = {},
	globals = {},
	subs = {},
	colored = {},
	configuration = {
		hideKeybind = Enum.KeyCode.RightShift,
		smoothDragging = false,
		easingStyle = Enum.EasingStyle.Quart,
		easingDirection = Enum.EasingDirection.Out
	},
	colors = {
		main = Color3.fromRGB(130, 100, 220), -- Replaced with NobGG purple
		background = Color3.fromRGB(30, 31, 36), -- NobGG window background
		outerBorder = Color3.fromRGB(15, 15, 15),
		innerBorder = Color3.fromRGB(73, 63, 73),
		topGradient = Color3.fromRGB(35, 35, 35),
		bottomGradient = Color3.fromRGB(29, 29, 29),
		sectionBackground = Color3.fromRGB(35, 34, 34),
		section = Color3.fromRGB(176, 175, 176),
		otherElementText = Color3.fromRGB(129, 127, 129),
		elementText = Color3.fromRGB(147, 145, 147),
		elementBorder = Color3.fromRGB(20, 20, 20),
		selectedOption = Color3.fromRGB(55, 55, 55),
		unselectedOption = Color3.fromRGB(40, 40, 40),
		hoveredOptionTop = Color3.fromRGB(65, 65, 65),
		unhoveredOptionTop = Color3.fromRGB(50, 50, 50),
		hoveredOptionBottom = Color3.fromRGB(45, 45, 45),
		unhoveredOptionBottom = Color3.fromRGB(35, 35, 35),
		tabText = Color3.fromRGB(185, 185, 185)
	},
	gui_parent = (function()
		local x, c = pcall(function()
			return game:GetService("CoreGui")
		end)
		if x and c then
			return c
		end
		x, c = pcall(function()
			return (game:IsLoaded() or (game.Loaded:Wait() or 1)) and game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
		end)
		if x and c then
			return c
		end
		x, c = pcall(function()
			return game:GetService("StarterGui")
		end)
		if x and c then
			return c
		end
		return error("Seriously bad engine. Can't find a place to store the GUI. Robust code can't help this much incompetence.")
	end)()
}

-- Import essential services
local textService = game:GetService("TextService")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local playersService = game:GetService("Players")
local LP = playersService.LocalPlayer
local Mouse = LP and LP:GetMouse()

-- Define color variables for NobGG design
local colorNavbarBackground = Color3.fromRGB(23, 24, 28)
local colorTextPrimary = Color3.fromRGB(220, 220, 225) -- For logo, active tab, user info
local colorTextSecondary = Color3.fromRGB(140, 140, 145) -- For inactive tabs
local colorAccentPurple = Color3.fromRGB(130, 100, 220) -- For active tab indicator
local colorWindowBackground = Color3.fromRGB(30, 31, 36) -- For future content windows

-- Helper functions from Pepsi lib
local function darkenColor(clr, intensity)
	if not intensity or (intensity == 1) then
		return clr
	end
	if clr and ((typeof(clr) == "Color3") or (type(clr) == "table")) then
		return Color3.new(clr.R / intensity, clr.G / intensity, clr.B / intensity)
	end
end

local function wait_check(...)
	if __runscript then
		return wait(...)
	else
		wait()
		return false
	end
end

local colored = {}
local isDraggingSomething = false

-- Make objects draggable
local function makeDraggable(topBarObject, object)
	local dragging = nil
	local dragInput = nil
	local dragStart = nil
	local startPosition = nil
	
	local function update(input)
		local delta = input.Position - dragStart
		if not isDraggingSomething and library.configuration.smoothDragging then
			tweenService:Create(object, TweenInfo.new(0.25, library.configuration.easingStyle, library.configuration.easingDirection), {
				Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
			}):Play()
		elseif not isDraggingSomething and not library.configuration.smoothDragging then
			object.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
		end
	end
	
	topBarObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPosition = object.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	topBarObject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	
	userInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

-- Create the main UI structure
function NobGG:CreateNobGG(config)
    config = config or {}
    local username = config.Username or "MinikAyicuhV5"
    local uid = config.UID or "UID: 123456"
    local role = config.Role or "Owner"
    local libName = config.LibName or "nob.gg"

    -- Create the main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NobGG_MainGui"
    ScreenGui.Parent = library.gui_parent
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- Main Navbar Frame
    local NavbarFrame = Instance.new("Frame")
    NavbarFrame.Name = "Navbar"
    NavbarFrame.Parent = ScreenGui
    NavbarFrame.BackgroundColor3 = colorNavbarBackground
    NavbarFrame.Size = UDim2.new(0.6, 0, 0, 50)
    NavbarFrame.Position = UDim2.new(0.5, 0, 0, 10)
    NavbarFrame.BorderSizePixel = 0
    NavbarFrame.AnchorPoint = Vector2.new(0.5, 0)
    
    -- Make navbar rounded
    local NavbarCorner = Instance.new("UICorner")
    NavbarCorner.CornerRadius = UDim.new(0, 12)
    NavbarCorner.Parent = NavbarFrame

    local NavbarPadding = Instance.new("UIPadding")
    NavbarPadding.Parent = NavbarFrame
    NavbarPadding.PaddingLeft = UDim.new(0, 15)
    NavbarPadding.PaddingRight = UDim.new(0, 15)

    -- NobGG Logo
    local LogoLabel = Instance.new("TextLabel")
    LogoLabel.Name = "LogoLabel"
    LogoLabel.Parent = NavbarFrame
    LogoLabel.Size = UDim2.new(0, 80, 1, 0)
    LogoLabel.Position = UDim2.new(0, 0, 0, 0)
    LogoLabel.Font = Enum.Font.GothamSemibold
    LogoLabel.Text = libName
    LogoLabel.TextColor3 = colorTextPrimary
    LogoLabel.TextSize = 18.000
    LogoLabel.TextXAlignment = Enum.TextXAlignment.Left
    LogoLabel.BackgroundTransparency = 1

    -- Tabs Container
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Parent = NavbarFrame
    TabsContainer.Size = UDim2.new(0.5, -120, 1, 0)
    TabsContainer.Position = UDim2.new(0.5, -TabsContainer.AbsoluteSize.X / 2, 0, 0)
    TabsContainer.BackgroundTransparency = 1
    
    local TabsListLayout = Instance.new("UIListLayout")
    TabsListLayout.Parent = TabsContainer
    TabsListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabsListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TabsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsListLayout.Padding = UDim.new(0, 15)

    -- User Info
    local UserInfoFrame = Instance.new("Frame")
    UserInfoFrame.Name = "UserInfoFrame"
    UserInfoFrame.Parent = NavbarFrame
    UserInfoFrame.Size = UDim2.new(0, 170, 1, 0)
    UserInfoFrame.Position = UDim2.new(1, -170 - 15, 0, 0)
    UserInfoFrame.BackgroundTransparency = 1

    local UserInfoListLayout = Instance.new("UIListLayout")
    UserInfoListLayout.Parent = UserInfoFrame
    UserInfoListLayout.FillDirection = Enum.FillDirection.Horizontal
    UserInfoListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UserInfoListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UserInfoListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UserInfoListLayout.Padding = UDim.new(0, 10)
    
    -- User Profile Picture
    local UserProfileImage = Instance.new("ImageLabel")
    UserProfileImage.Name = "UserProfileImage"
    UserProfileImage.Parent = UserInfoFrame
    UserProfileImage.Size = UDim2.new(0, 36, 0, 36)
    UserProfileImage.BackgroundColor3 = colorTextSecondary
    UserProfileImage.Image = "rbxassetid://1800000000"
    local imgCorner = Instance.new("UICorner")
    imgCorner.CornerRadius = UDim.new(1,0)
    imgCorner.Parent = UserProfileImage

    local UserTextInfoFrame = Instance.new("Frame")
    UserTextInfoFrame.Name = "UserTextInfoFrame"
    UserTextInfoFrame.Parent = UserInfoFrame
    UserTextInfoFrame.BackgroundTransparency = 1
    UserTextInfoFrame.Size = UDim2.new(0, 120, 0, 40)
    
    local userTextLayout = Instance.new("UIListLayout")
    userTextLayout.Parent = UserTextInfoFrame
    userTextLayout.FillDirection = Enum.FillDirection.Vertical
    userTextLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    userTextLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    userTextLayout.Padding = UDim.new(0,0)

    local UsernameLabel = Instance.new("TextLabel")
    UsernameLabel.Name = "UsernameLabel"
    UsernameLabel.Parent = UserTextInfoFrame
    UsernameLabel.Font = Enum.Font.GothamSemibold
    UsernameLabel.Text = username
    UsernameLabel.TextColor3 = colorTextPrimary
    UsernameLabel.TextSize = 14.000
    UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    UsernameLabel.BackgroundTransparency = 1
    UsernameLabel.Size = UDim2.new(1,0,0,18)

    local UserRoleLabel = Instance.new("TextLabel")
    UserRoleLabel.Name = "UserRoleLabel"
    UserRoleLabel.Parent = UserTextInfoFrame
    UserRoleLabel.Font = Enum.Font.Gotham
    UserRoleLabel.Text = role
    UserRoleLabel.TextColor3 = colorTextSecondary
    UserRoleLabel.TextSize = 12.000
    UserRoleLabel.TextXAlignment = Enum.TextXAlignment.Left
    UserRoleLabel.BackgroundTransparency = 1
    UserRoleLabel.Size = UDim2.new(1,0,0,16)
    
    -- Make Navbar draggable
    makeDraggable(NavbarFrame, NavbarFrame)
    
    -- Container for Pepsi's UI Windows
    local ContentWindowsContainer = Instance.new("Frame")
    ContentWindowsContainer.Name = "ContentWindowsContainer"
    ContentWindowsContainer.Parent = ScreenGui
    ContentWindowsContainer.Size = UDim2.new(1, 0, 1, -NavbarFrame.Size.Y.Offset - 20)
    ContentWindowsContainer.Position = UDim2.new(0, 0, 0, NavbarFrame.Size.Y.Offset + 20)
    ContentWindowsContainer.BackgroundTransparency = 1
    ContentWindowsContainer.ClipsDescendants = true
    
    local activeTabs = {}
    local allWindows = {}

    -- Navbar Tab Handler
    local NavbarHandler = {}
    
    function NavbarHandler:CreateTab(tabNameString)
        tabNameString = tabNameString or "Tab"

        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabNameString .. "TabButton"
        tabButton.Parent = TabsContainer
        tabButton.Size = UDim2.new(0, 80, 0, 30)
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.Text = tabNameString
        tabButton.TextColor3 = colorTextSecondary
        tabButton.TextSize = 14.000
        tabButton.BackgroundTransparency = 1
        tabButton.AutoButtonColor = false

        local activeIndicator = Instance.new("Frame")
        activeIndicator.Name = "ActiveIndicator"
        activeIndicator.Parent = tabButton
        activeIndicator.BackgroundColor3 = colorAccentPurple
        activeIndicator.BorderSizePixel = 0
        activeIndicator.Size = UDim2.new(1, 0, 0, 3)
        activeIndicator.Position = UDim2.new(0, 0, 1, -3)
        activeIndicator.Visible = false
        
        -- Create Pepsi-style window
        local mainWindow = Instance.new("Frame")
        mainWindow.Name = tabNameString .. "Window"
        mainWindow.Parent = ContentWindowsContainer
        mainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
        mainWindow.BackgroundColor3 = library.colors.background
        mainWindow.BorderColor3 = library.colors.outerBorder
        mainWindow.Position = UDim2.fromScale(0.5, 0.5)
        mainWindow.Size = UDim2.fromOffset(500, 325)
        mainWindow.Visible = false
        
        -- Apply main border
        local mainBorder = Instance.new("Frame")
        mainBorder.Name = "mainBorder"
        mainBorder.Parent = mainWindow
        mainBorder.AnchorPoint = Vector2.new(0.5, 0.5)
        mainBorder.BackgroundColor3 = library.colors.background
        mainBorder.BorderColor3 = library.colors.innerBorder
        mainBorder.BorderMode = Enum.BorderMode.Inset
        mainBorder.Position = UDim2.fromScale(0.5, 0.5)
        mainBorder.Size = UDim2.fromScale(1, 1)
        
        -- Inner main frame
        local innerMain = Instance.new("Frame")
        innerMain.Name = "innerMain"
        innerMain.Parent = mainWindow
        innerMain.AnchorPoint = Vector2.new(0.5, 0.5)
        innerMain.BackgroundColor3 = library.colors.background
        innerMain.BorderColor3 = library.colors.outerBorder
        innerMain.Position = UDim2.fromScale(0.5, 0.5)
        innerMain.Size = UDim2.new(1, -14, 1, -14)
        
        -- Inner main border
        local innerMainBorder = Instance.new("Frame")
        innerMainBorder.Name = "innerMainBorder"
        innerMainBorder.Parent = innerMain
        innerMainBorder.AnchorPoint = Vector2.new(0.5, 0.5)
        innerMainBorder.BackgroundColor3 = library.colors.background
        innerMainBorder.BorderColor3 = library.colors.innerBorder
        innerMainBorder.BorderMode = Enum.BorderMode.Inset
        innerMainBorder.Position = UDim2.fromScale(0.5, 0.5)
        innerMainBorder.Size = UDim2.fromScale(1, 1)
        
        -- Content holder
        local innerMainHolder = Instance.new("Frame")
        innerMainHolder.Name = "innerMainHolder"
        innerMainHolder.Parent = innerMain
        innerMainHolder.BackgroundColor3 = Color3.new(1, 1, 1)
        innerMainHolder.BackgroundTransparency = 1
        innerMainHolder.Position = UDim2:fromOffset(25)
        innerMainHolder.Size = UDim2.new(1, 0, 1, -25)
        
        -- Header bar with title
        local tabsHolder = Instance.new("ImageLabel")
        tabsHolder.Name = "tabsHolder"
        tabsHolder.Parent = innerMain
        tabsHolder.BackgroundColor3 = library.colors.topGradient
        tabsHolder.BorderSizePixel = 0
        tabsHolder.Position = UDim2.fromOffset(1, 1)
        tabsHolder.Size = UDim2.new(1, -2, 0, 23)
        tabsHolder.Image = "rbxassetid://2454009026"
        tabsHolder.ImageColor3 = library.colors.bottomGradient
        
        -- Window title
        local windowTitle = Instance.new("TextLabel")
        windowTitle.Name = "windowTitle"
        windowTitle.Parent = tabsHolder
        windowTitle.BackgroundColor3 = Color3.new(1, 1, 1)
        windowTitle.BackgroundTransparency = 1
        windowTitle.Position = UDim2.fromOffset(7, 0)
        windowTitle.Size = UDim2.new(1, -14, 1, 0)
        windowTitle.Font = Enum.Font.Code
        windowTitle.Text = tabNameString
        windowTitle.TextColor3 = library.colors.main
        windowTitle.TextSize = 14
        windowTitle.TextStrokeColor3 = library.colors.outerBorder
        windowTitle.TextStrokeTransparency = 0.75
        windowTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Make the window draggable
        makeDraggable(tabsHolder, mainWindow)
        
        -- Register tab in active tabs collection
        table.insert(activeTabs, {
            button = tabButton,
            indicator = activeIndicator,
            window = mainWindow,
            active = false,
            sections = {
                left = {},
                right = {}
            }
        })
        
        table.insert(allWindows, mainWindow)
        
        -- If this is the first tab, activate it
        if #activeTabs == 1 then
            activeTabs[1].active = true
            tabButton.TextColor3 = colorTextPrimary
            activeIndicator.Visible = true
            mainWindow.Visible = true
        end
        
        -- Handle tab clicking
        tabButton.MouseButton1Click:Connect(function()
            -- Deactivate all tabs first
            for _, data in ipairs(activeTabs) do
                data.active = false
                data.button.TextColor3 = colorTextSecondary
                data.indicator.Visible = false
                data.window.Visible = false
            end
            
            -- Find and activate this tab
            local tabData = nil
            for _, data in ipairs(activeTabs) do
                if data.button == tabButton then
                    tabData = data
                    break
                end
            end
            
            -- Activate this tab
            if tabData then
                tabData.active = true
                tabData.button.TextColor3 = colorTextPrimary
                tabData.indicator.Visible = true
                tabData.window.Visible = true
            end
        end)
        
        -- Create the Section creation interface
        local tabFunctions = {}
        
        function tabFunctions:CreateSection(options)
            options = options or {}
            local sectionName = options.Name or "Unnamed Section"
            local holderSide = options.Side or "left"
            
            -- Create the section visuals
            local newSection = Instance.new("Frame")
            local newSectionBorder = Instance.new("Frame")
            local insideBorderHider = Instance.new("Frame")
            local outsideBorderHider = Instance.new("Frame")
            local sectionHolder = Instance.new("Frame")
            local sectionList = Instance.new("UIListLayout")
            local sectionPadding = Instance.new("UIPadding")
            local sectionHeadline = Instance.new("TextLabel")
            
            newSection.Name = sectionName:gsub(" ", "") .. "Section"
            newSection.Parent = holderSide == "right" and innerMainHolder or innerMainHolder
            newSection.BackgroundColor3 = library.colors.sectionBackground
            newSection.BorderColor3 = library.colors.outerBorder
            newSection.Size = UDim2.new(0.5, -20, 0, 20) -- Initial height
            newSection.Visible = true
            
            if holderSide == "right" then
                newSection.Position = UDim2.new(0.5, 10, 0, 0)
            else
                newSection.Position = UDim2.new(0, 0, 0, 0)
            end
            
            newSectionBorder.Name = "newSectionBorder"
            newSectionBorder.Parent = newSection
            newSectionBorder.BackgroundColor3 = library.colors.sectionBackground
            newSectionBorder.BorderColor3 = library.colors.innerBorder
            newSectionBorder.BorderMode = Enum.BorderMode.Inset
            newSectionBorder.Size = UDim2.fromScale(1, 1)
            
            sectionHolder.Name = "sectionHolder"
            sectionHolder.Parent = newSection
            sectionHolder.BackgroundColor3 = Color3.new(1, 1, 1)
            sectionHolder.BackgroundTransparency = 1
            sectionHolder.Size = UDim2.fromScale(1, 1)
            
            sectionList.Name = "sectionList"
            sectionList.Parent = sectionHolder
            sectionList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            sectionList.SortOrder = Enum.SortOrder.LayoutOrder
            sectionList.Padding = UDim.new(0, 1)
            
            sectionPadding.Name = "sectionPadding"
            sectionPadding.Parent = sectionHolder
            sectionPadding.PaddingTop = UDim.new(0, 9)
            
            sectionHeadline.Name = "sectionHeadline"
            sectionHeadline.Parent = newSection
            sectionHeadline.BackgroundColor3 = Color3.new(1, 1, 1)
            sectionHeadline.BackgroundTransparency = 1
            sectionHeadline.Position = UDim2.fromOffset(18, -8)
            sectionHeadline.ZIndex = 2
            sectionHeadline.Font = Enum.Font.Code
            sectionHeadline.LineHeight = 1.15
            sectionHeadline.Text = sectionName
            sectionHeadline.TextColor3 = library.colors.section
            sectionHeadline.TextSize = 14
            -- Adjust the size based on text
            sectionHeadline.Size = UDim2.fromOffset(textService:GetTextSize(sectionName, 14, Enum.Font.Code, Vector2.new(1000, 1000)).X + 4, 12)
            
            insideBorderHider.Name = "insideBorderHider"
            insideBorderHider.Parent = newSection
            insideBorderHider.BackgroundColor3 = library.colors.sectionBackground
            insideBorderHider.BorderSizePixel = 0
            insideBorderHider.Position = UDim2.fromOffset(15)
            insideBorderHider.Size = UDim2.fromOffset(sectionHeadline.AbsoluteSize.X + 3, 1)
            
            outsideBorderHider.Name = "outsideBorderHider"
            outsideBorderHider.Parent = newSection
            outsideBorderHider.BackgroundColor3 = library.colors.background
            outsideBorderHider.BorderSizePixel = 0
            outsideBorderHider.Position = UDim2.fromOffset(15, -1)
            outsideBorderHider.Size = UDim2.fromOffset(sectionHeadline.AbsoluteSize.X + 3, 1)
            
            -- Add elements to the registery
            local sectionRegistry = {
                holderSide = holderSide,
                section = newSection,
                sectionHolder = sectionHolder,
            }
            
            -- Add to the tab's sections
            table.insert(activeTabs[#activeTabs].sections[holderSide], sectionRegistry)
            
            -- Function to update section size
            local function updateSectionSize()
                newSection.Size = UDim2.new(0.5, -20, 0, 15 + sectionList.AbsoluteContentSize.Y)
                
                -- Reposition all sections in this side
                local currentPosition = 0
                for i, sec in ipairs(activeTabs[#activeTabs].sections[holderSide]) do
                    sec.section.Position = UDim2.new(holderSide == "right" and 0.5 or 0, holderSide == "right" and 10 or 0, 0, currentPosition)
                    currentPosition = currentPosition + sec.section.Size.Y.Offset + 20
                end
            end
            
            -- Section Functions
            local sectionFunctions = {}
            
            -- Add Toggle
            function sectionFunctions:AddToggle(options)
                options = options or {}
                local toggleName = options.Name or "Unnamed Toggle"
                local default = options.Default or false
                local callback = options.Callback or function() end
                
                local newToggle = Instance.new("Frame")
                local toggle = Instance.new("ImageLabel")
                local toggleInner = Instance.new("ImageLabel")
                local toggleButton = Instance.new("TextButton")
                local toggleHeadline = Instance.new("TextLabel")
                
                newToggle.Name = toggleName:gsub(" ", "") .. "Toggle"
                newToggle.Parent = sectionHolder
                newToggle.BackgroundColor3 = Color3.new(1, 1, 1)
                newToggle.BackgroundTransparency = 1
                newToggle.Size = UDim2.new(1, 0, 0, 19)
                
                toggle.Name = "toggle"
                toggle.Parent = newToggle
                toggle.Active = true
                toggle.BackgroundColor3 = library.colors.topGradient
                toggle.BorderColor3 = library.colors.elementBorder
                toggle.Position = UDim2.fromScale(0.0308237672, 0.165842205)
                toggle.Selectable = true
                toggle.Size = UDim2.fromOffset(12, 12)
                toggle.Image = "rbxassetid://2454009026"
                toggle.ImageColor3 = library.colors.bottomGradient
                
                toggleInner.Name = "toggleInner"
                toggleInner.Parent = toggle
                toggleInner.Active = true
                toggleInner.AnchorPoint = Vector2.new(0.5, 0.5)
                toggleInner.BackgroundColor3 = library.colors.topGradient
                toggleInner.BorderColor3 = library.colors.elementBorder
                toggleInner.Position = UDim2.fromScale(0.5, 0.5)
                toggleInner.Selectable = true
                toggleInner.Size = UDim2.new(1, -4, 1, -4)
                toggleInner.Image = "rbxassetid://2454009026"
                toggleInner.ImageColor3 = library.colors.bottomGradient
                
                toggleButton.Name = "toggleButton"
                toggleButton.Parent = newToggle
                toggleButton.BackgroundColor3 = Color3.new(1, 1, 1)
                toggleButton.BackgroundTransparency = 1
                toggleButton.Size = UDim2.fromScale(1, 1)
                toggleButton.ZIndex = 5
                toggleButton.Font = Enum.Font.SourceSans
                toggleButton.Text = ""
                toggleButton.TextColor3 = Color3.new()
                toggleButton.TextSize = 14
                toggleButton.TextTransparency = 1
                
                toggleHeadline.Name = "toggleHeadline"
                toggleHeadline.Parent = newToggle
                toggleHeadline.BackgroundColor3 = Color3.new(1, 1, 1)
                toggleHeadline.BackgroundTransparency = 1
                toggleHeadline.Position = UDim2.fromScale(0.123, 0.165842161)
                toggleHeadline.Size = UDim2.fromOffset(170, 11)
                toggleHeadline.Font = Enum.Font.Code
                toggleHeadline.Text = toggleName
                toggleHeadline.TextColor3 = library.colors.elementText
                toggleHeadline.TextSize = 14
                toggleHeadline.TextXAlignment = Enum.TextXAlignment.Left
                
                -- Toggle functionality
                local toggled = default
                
                local function updateToggle()
                    if toggled then
                        toggleInner.BackgroundColor3 = library.colors.main
                    else
                        toggleInner.BackgroundColor3 = library.colors.topGradient
                    end
                end
                
                toggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    updateToggle()
                    callback(toggled)
                end)
                
                -- Initialize
                updateToggle()
                updateSectionSize()
                
                return {
                    Instance = newToggle,
                    Set = function(self, value)
                        toggled = value
                        updateToggle()
                        return toggled
                    end,
                    Get = function()
                        return toggled
                    end
                }
            end
            
            -- Add Slider
            function sectionFunctions:AddSlider(options)
                options = options or {}
                local sliderName = options.Name or "Unnamed Slider"
                local minValue = options.Min or 0
                local maxValue = options.Max or 100
                local defaultValue = options.Default or minValue
                local callback = options.Callback or function() end
                
                -- Slider Components
                local newSlider = Instance.new("Frame")
                local slider = Instance.new("ImageLabel")
                local sliderInner = Instance.new("ImageLabel")
                local sliderColored = Instance.new("ImageLabel")
                local sliderHeadline = Instance.new("TextLabel")
                local sliderValue = Instance.new("TextLabel")
                
                -- Set up basic properties
                newSlider.Name = sliderName:gsub(" ", "") .. "Slider"
                newSlider.Parent = sectionHolder
                newSlider.BackgroundColor3 = Color3.new(1, 1, 1)
                newSlider.BackgroundTransparency = 1
                newSlider.Size = UDim2.new(1, 0, 0, 42)
                
                slider.Name = "slider"
                slider.Parent = newSlider
                slider.Active = true
                slider.BackgroundColor3 = library.colors.topGradient
                slider.BorderColor3 = library.colors.elementBorder
                slider.Position = UDim2.fromScale(0.031, 0.48)
                slider.Selectable = true
                slider.Size = UDim2.fromOffset(206, 18)
                slider.Image = "rbxassetid://2454009026"
                slider.ImageColor3 = library.colors.bottomGradient
                
                sliderInner.Name = "sliderInner"
                sliderInner.Parent = slider
                sliderInner.Active = true
                sliderInner.AnchorPoint = Vector2.new(0.5, 0.5)
                sliderInner.BackgroundColor3 = library.colors.topGradient
                sliderInner.BorderColor3 = library.colors.elementBorder
                sliderInner.Position = UDim2.fromScale(0.5, 0.5)
                sliderInner.Selectable = true
                sliderInner.Size = UDim2.new(1, -4, 1, -4)
                sliderInner.Image = "rbxassetid://2454009026"
                sliderInner.ImageColor3 = library.colors.bottomGradient
                
                sliderColored.Name = "sliderColored"
                sliderColored.Parent = sliderInner
                sliderColored.Active = true
                sliderColored.BackgroundColor3 = darkenColor(library.colors.main, 1.5)
                sliderColored.BorderSizePixel = 0
                sliderColored.Selectable = true
                sliderColored.Size = UDim2.fromScale(((defaultValue or minValue) - minValue) / (maxValue - minValue), 1)
                sliderColored.Image = "rbxassetid://2454009026"
                sliderColored.ImageColor3 = darkenColor(library.colors.main, 2.5)
                
                sliderHeadline.Name = "sliderHeadline"
                sliderHeadline.Parent = newSlider
                sliderHeadline.Active = true
                sliderHeadline.BackgroundColor3 = Color3.new(1, 1, 1)
                sliderHeadline.BackgroundTransparency = 1
                sliderHeadline.Position = UDim2.new(0.031)
                sliderHeadline.Selectable = true
                sliderHeadline.Size = UDim2.fromOffset(160, 20)
                sliderHeadline.ZIndex = 5
                sliderHeadline.Font = Enum.Font.Code
                sliderHeadline.LineHeight = 1.15
                sliderHeadline.Text = sliderName
                sliderHeadline.TextColor3 = library.colors.elementText
                sliderHeadline.TextSize = 14
                sliderHeadline.TextXAlignment = Enum.TextXAlignment.Left
                
                sliderValue = Instance.new("TextLabel")
                sliderValue.Name = "sliderValue"
                sliderValue.Parent = newSlider
                sliderValue.Active = true
                sliderValue.BackgroundColor3 = Color3.new(1, 1, 1)
                sliderValue.BackgroundTransparency = 1
                sliderValue.Position = UDim2.new(0.85, 0, 0, 0)
                sliderValue.Selectable = true
                sliderValue.Size = UDim2.fromOffset(40, 20)
                sliderValue.ZIndex = 5
                sliderValue.Font = Enum.Font.Code
                sliderValue.LineHeight = 1.15
                sliderValue.Text = tostring(defaultValue)
                sliderValue.TextColor3 = library.colors.elementText
                sliderValue.TextSize = 14
                sliderValue.TextXAlignment = Enum.TextXAlignment.Right
                
                -- Slider dragging functionality
                local dragging = false
                
                local function updateSlider(input)
                    local sizeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                    sliderColored.Size = UDim2.fromScale(sizeX, 1)
                    local value = math.floor((minValue + ((maxValue - minValue) * sizeX)) * 100) / 100
                    sliderValue.Text = tostring(value)
                    callback(value)
                end
                
                slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        updateSlider(input)
                    end
                end)
                
                slider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                userInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                -- Initialize
                updateSectionSize()
                
                return {
                    Instance = newSlider,
                    Set = function(self, value)
                        value = math.clamp(value, minValue, maxValue)
                        sliderColored.Size = UDim2.fromScale((value - minValue) / (maxValue - minValue), 1)
                        sliderValue.Text = tostring(value)
                        callback(value)
                        return value
                    end,
                    Get = function()
                        return tonumber(sliderValue.Text)
                    end
                }
            end
            
            -- Add Button
            function sectionFunctions:AddButton(options)
                options = options or {}
                local buttonName = options.Name or "Unnamed Button"
                local callback = options.Callback or function() end
                
                -- Button components
                local newButton = Instance.new("Frame")
                local button = Instance.new("ImageLabel")
                local buttonInner = Instance.new("ImageLabel")
                local buttonLabel = Instance.new("TextLabel")
                local buttonButton = Instance.new("TextButton")
                
                newButton.Name = buttonName:gsub(" ", "") .. "Button"
                newButton.Parent = sectionHolder
                newButton.BackgroundColor3 = Color3.new(1, 1, 1)
                newButton.BackgroundTransparency = 1
                newButton.Size = UDim2.new(1, 0, 0, 33)
                
                button.Name = "button"
                button.Parent = newButton
                button.Active = true
                button.BackgroundColor3 = library.colors.topGradient
                button.BorderColor3 = library.colors.elementBorder
                button.Position = UDim2.fromScale(0.031, 0.48)
                button.Selectable = true
                button.Size = UDim2.fromOffset(206, 20)
                button.Image = "rbxassetid://2454009026"
                button.ImageColor3 = library.colors.bottomGradient
                
                buttonInner.Name = "buttonInner"
                buttonInner.Parent = button
                buttonInner.Active = true
                buttonInner.AnchorPoint = Vector2.new(0.5, 0.5)
                buttonInner.BackgroundColor3 = library.colors.topGradient
                buttonInner.BorderColor3 = library.colors.elementBorder
                buttonInner.Position = UDim2.fromScale(0.5, 0.5)
                buttonInner.Selectable = true
                buttonInner.Size = UDim2.new(1, -4, 1, -4)
                buttonInner.Image = "rbxassetid://2454009026"
                buttonInner.ImageColor3 = library.colors.bottomGradient
                
                buttonLabel.Name = "buttonLabel"
                buttonLabel.Parent = buttonInner
                buttonLabel.Active = true
                buttonLabel.BackgroundColor3 = Color3.new(1, 1, 1)
                buttonLabel.BackgroundTransparency = 1
                buttonLabel.Size = UDim2.fromScale(1, 1)
                buttonLabel.Font = Enum.Font.Code
                buttonLabel.LineHeight = 1.15
                buttonLabel.Text = buttonName
                buttonLabel.TextColor3 = library.colors.elementText
                buttonLabel.TextSize = 14
                
                buttonButton.Name = "buttonButton"
                buttonButton.Parent = buttonInner
                buttonButton.BackgroundColor3 = Color3.new(1, 1, 1)
                buttonButton.BackgroundTransparency = 1
                buttonButton.Size = UDim2.fromScale(1, 1)
                buttonButton.ZIndex = 5
                buttonButton.Font = Enum.Font.SourceSans
                buttonButton.Text = ""
                buttonButton.TextColor3 = Color3.new()
                buttonButton.TextSize = 14
                buttonButton.TextTransparency = 1
                
                -- Button functionality
                buttonButton.MouseButton1Click:Connect(function()
                    callback()
                end)
                
                -- Initialize
                updateSectionSize()
                
                return {
                    Instance = newButton,
                    Press = function()
                        callback()
                    end
                }
            end
            
            -- Add other UI elements as needed
            -- ...
            
            return sectionFunctions
        end
        
        -- Return the tab interface
        return tabFunctions
    end
    
    -- Make the WindowHandler accessible
    return NavbarHandler
end

-- Return the library
return NobGG
