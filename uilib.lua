local NobGG = {}

function NobGG:CreateNobGG(config)
    config = config or {}
    local username = config.Username or "MinikAyicuhV5"
    local uid = config.UID or "UID: 123456"
    local role = config.Role or "Owner"
    local libName = config.LibName or "nob.gg"

    -- New Color Palette (approximated from screenshot)
    local colorNavbarBackground = Color3.fromRGB(23, 24, 28)
    local colorTextPrimary = Color3.fromRGB(220, 220, 225) -- For logo, active tab, user info
    local colorTextSecondary = Color3.fromRGB(140, 140, 145) -- For inactive tabs
    local colorAccentPurple = Color3.fromRGB(130, 100, 220) -- For active tab indicator
    local colorWindowBackground = Color3.fromRGB(30, 31, 36) -- For future content windows
    local colorGlobalBackground = Color3.fromRGB(40, 40, 45) -- General screen background if needed

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NobGG_MainGui"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false -- Keep UI persistent

    -- Main Navbar Frame
    local NavbarFrame = Instance.new("Frame")
    NavbarFrame.Name = "Navbar"
    NavbarFrame.Parent = ScreenGui
    NavbarFrame.BackgroundColor3 = colorNavbarBackground
    NavbarFrame.Size = UDim2.new(1, 0, 0, 60) -- Full width, 60px height
    NavbarFrame.Position = UDim2.new(0, 0, 0, 0)
    NavbarFrame.BorderSizePixel = 0

    local NavbarPadding = Instance.new("UIPadding")
    NavbarPadding.Parent = NavbarFrame
    NavbarPadding.PaddingLeft = UDim.new(0, 20)
    NavbarPadding.PaddingRight = UDim.new(0, 20)

    -- Nob.gg Logo (Left)
    local LogoLabel = Instance.new("TextLabel")
    LogoLabel.Name = "LogoLabel"
    LogoLabel.Parent = NavbarFrame
    LogoLabel.Size = UDim2.new(0, 100, 1, 0)
    LogoLabel.Position = UDim2.new(0, 0, 0, 0)
    LogoLabel.Font = Enum.Font.GothamSemibold
    LogoLabel.Text = libName
    LogoLabel.TextColor3 = colorTextPrimary
    LogoLabel.TextSize = 20.000
    LogoLabel.TextXAlignment = Enum.TextXAlignment.Left
    LogoLabel.BackgroundTransparency = 1

    -- Tabs Container (Middle)
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Parent = NavbarFrame
    TabsContainer.Size = UDim2.new(0.5, -240, 1, 0) -- Adjust width: 0.5 of parent, subtract space for logo and user info
    TabsContainer.Position = UDim2.new(0.5, - (TabsContainer.AbsoluteSize.X / 2), 0, 0) -- Centered
    TabsContainer.BackgroundTransparency = 1
    
    local TabsListLayout = Instance.new("UIListLayout")
    TabsListLayout.Parent = TabsContainer
    TabsListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabsListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TabsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsListLayout.Padding = UDim.new(0, 15)

    -- User Info (Right)
    local UserInfoFrame = Instance.new("Frame")
    UserInfoFrame.Name = "UserInfoFrame"
    UserInfoFrame.Parent = NavbarFrame
    UserInfoFrame.Size = UDim2.new(0, 200, 1, 0) -- Fixed width for user info
    UserInfoFrame.Position = UDim2.new(1, -200 - 20, 0, 0) -- Positioned to the right (minus its own width and navbar padding)
    UserInfoFrame.BackgroundTransparency = 1

    local UserInfoListLayout = Instance.new("UIListLayout")
    UserInfoListLayout.Parent = UserInfoFrame
    UserInfoListLayout.FillDirection = Enum.FillDirection.Horizontal
    UserInfoListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UserInfoListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UserInfoListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UserInfoListLayout.Padding = UDim.new(0, 10)
    
    -- User Profile Picture (Placeholder)
    local UserProfileImage = Instance.new("ImageLabel")
    UserProfileImage.Name = "UserProfileImage"
    UserProfileImage.Parent = UserInfoFrame
    UserProfileImage.Size = UDim2.new(0, 36, 0, 36)
    UserProfileImage.BackgroundColor3 = colorTextSecondary
    UserProfileImage.Image = "rbxassetid://1800000000" -- Placeholder, replace with actual or remove
    local imgCorner = Instance.new("UICorner")
    imgCorner.CornerRadius = UDim.new(1,0) -- Make it circular
    imgCorner.Parent = UserProfileImage

    local UserTextInfoFrame = Instance.new("Frame")
    UserTextInfoFrame.Name = "UserTextInfoFrame"
    UserTextInfoFrame.Parent = UserInfoFrame
    UserTextInfoFrame.BackgroundTransparency = 1
    UserTextInfoFrame.Size = UDim2.new(0, 120, 0, 40) -- Adjust size as needed
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
    UsernameLabel.Text = username -- ".. (" .. uid .. ")"
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
    
    -- Content Area for future windows
    local ContentWindowsContainer = Instance.new("Frame")
    ContentWindowsContainer.Name = "ContentWindowsContainer"
    ContentWindowsContainer.Parent = ScreenGui
    ContentWindowsContainer.Size = UDim2.new(1, 0, 1, -NavbarFrame.Size.Y.Offset) -- Full width, height below navbar
    ContentWindowsContainer.Position = UDim2.new(0, 0, 0, NavbarFrame.Size.Y.Offset)
    ContentWindowsContainer.BackgroundTransparency = 1 -- Make it transparent for now
    ContentWindowsContainer.ClipsDescendants = true

    -- Draggable Navbar
    local UserInputService = game:GetService("UserInputService")
    local Camera = workspace:WaitForChild("Camera")
    local DragMousePosition
    local FramePosition
    local Draggable = false

    NavbarFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            -- Check if the input is not on an interactive element like a button within the navbar
            local onButton = false
            for _, descendant in ipairs(NavbarFrame:GetDescendants()) do
                if descendant:IsA("GuiButton") and descendant.AbsolutePosition.X <= input.Position.X and input.Position.X <= descendant.AbsolutePosition.X + descendant.AbsoluteSize.X and descendant.AbsolutePosition.Y <= input.Position.Y and input.Position.Y <= descendant.AbsolutePosition.Y + descendant.AbsoluteSize.Y then
                    onButton = true
                    break
                end
            end
            if not onButton then
                 Draggable = true
                 -- For dragging the whole UI, we might need a main draggable frame if ScreenGui itself is not draggable
                 -- For now, let's assume we want to drag the Navbar itself if it were a floating window.
                 -- Since it's a top bar, dragging isn't typical. If the whole UI is meant to be a draggable window,
                 -- then ScreenGui needs a main child frame that holds Navbar and ContentWindowsContainer.
                 -- For simplicity, this drag logic is here but might need adjustment based on overall UI structure.
                 -- If the entire UI is a single draggable window, ScreenGui should have one main Frame child.
                 -- Let's assume for now the user might want to make the whole UI draggable later.
                 -- We'll make the ScreenGui draggable by moving its main content.
                 -- To do this, we need a single top-level frame in ScreenGui.
                 -- Let's create one.

                 -- This drag logic is more suited for a movable window, not a fixed top navbar.
                 -- I'll comment it out for now as a fixed navbar doesn't usually drag.
                 -- If the entire UI becomes a draggable window, this needs to be re-evaluated.
            end
        end
    end)
    -- UserInputService.InputChanged:Connect(function(input)
    --     if Draggable == true and ScreenGui.Parent == game.CoreGui then -- Check if it's a draggable window
    --         local NewPosition = FramePosition + ((Vector2.new(input.Position.X, input.Position.Y) - DragMousePosition) / Camera.ViewportSize)
    --         -- ScreenGui.AbsolutePosition needs to be managed carefully, or a main child frame's position.
    --         -- Example: MainHoldingFrame.Position = UDim2.new(NewPosition.X, 0, NewPosition.Y, 0)
    --     end
    -- end)
    -- UserInputService.InputEnded:Connect(function(input)
    --     if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    --         Draggable = false
    --     end
    -- end)

    local activeTabs = {}
    local allContentWindows = {}

    local NavbarHandler = {}
    function NavbarHandler:CreateTab(tabNameString)
        tabNameString = tabNameString or "Tab"

        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabNameString .. "TabButton"
        tabButton.Parent = TabsContainer
        tabButton.Size = UDim2.new(0, 80, 0, 30) -- Adjust size as needed
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
        activeIndicator.Size = UDim2.new(1, 0, 0, 3) -- Full width, 3px height
        activeIndicator.Position = UDim2.new(0, 0, 1, -3) -- At the bottom
        activeIndicator.Visible = false
        
        -- Placeholder for the content window this tab will open
        local contentWindow = Instance.new("Frame")
        contentWindow.Name = tabNameString .. "Window"
        contentWindow.Parent = ContentWindowsContainer
        contentWindow.Size = UDim2.new(1,0,1,0)
        contentWindow.BackgroundColor3 = colorWindowBackground -- Or transparent if cards have their own bg
        contentWindow.BackgroundTransparency = 0.1 -- Slight visibility for demo
        contentWindow.Visible = false
        contentWindow.BorderSizePixel = 0
        -- Add UIListLayout or UIPadding to contentWindow if needed for elements
        local tempListLabel = Instance.new("TextLabel") -- Demo content
        tempListLabel.Parent = contentWindow
        tempListLabel.Text = tabNameString .. " Content Area"
        tempListLabel.TextColor3 = colorTextPrimary
        tempListLabel.TextSize = 20
        tempListLabel.Size = UDim2.new(1,0,0,50)
        tempListLabel.BackgroundTransparency = 1

        table.insert(allContentWindows, contentWindow)
        table.insert(activeTabs, {button = tabButton, indicator = activeIndicator, window = contentWindow})

        if #activeTabs == 1 then -- Activate the first tab by default
            tabButton.TextColor3 = colorTextPrimary
            activeIndicator.Visible = true
            contentWindow.Visible = true
        end

        tabButton.MouseButton1Click:Connect(function()
            for _, tabData in ipairs(activeTabs) do
                tabData.button.TextColor3 = colorTextSecondary
                tabData.indicator.Visible = false
                tabData.window.Visible = false
            end
            tabButton.TextColor3 = colorTextPrimary
            activeIndicator.Visible = true
            contentWindow.Visible = true
            -- Future: Call a function to populate/show the actual window content
        end)
        
        local ElementHandler = {}
        -- Define ElementHandler functions here. They will add elements to 'contentWindow'
        -- For now, this is a simplified version.
        function ElementHandler:TextLabel(labelText)
            labelText = labelText or "Sample Label"
            local txtLabel = Instance.new("TextLabel")
            txtLabel.Name = "ElementTextLabel"
            txtLabel.Parent = contentWindow -- Parent to this tab's window
            txtLabel.Text = labelText
            txtLabel.TextColor3 = colorTextPrimary
            txtLabel.TextSize = 16
            txtLabel.BackgroundTransparency = 1
            txtLabel.Size = UDim2.new(0.9,0,0,30) -- Example size
            txtLabel.Position = UDim2.new(0.05,0,0.1,0) -- Example position
            -- Add UIListLayout to contentWindow for better element management
            return txtLabel
        end
        
        -- Add other ElementHandler functions (Toggle, Slider, etc.) similarly,
        -- ensuring they parent elements to 'contentWindow' and are styled according to the new design.
        -- This part will require significant updates based on the screenshot for each element type.
        -- For now, only TextLabel is partially implemented as a demo.

        return ElementHandler
    end

    return NavbarHandler
end

return NobGG
