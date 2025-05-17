local NobGG = {}

function NobGG:CreateNobGG(config)
    config = config or {}
    -- Static demo data as per new request
    local username_val = "Nob"
    local uid_val = "1"
    local role_val = "Admin"
    local libName = config.LibName or "nob.gg"

    -- Color Palette
    local colorNavbarBackground = Color3.fromRGB(23, 24, 28)
    local colorTextPrimary = Color3.fromRGB(220, 220, 225)
    local colorTextSecondary = Color3.fromRGB(140, 140, 145)
    local colorAccentPurple = Color3.fromRGB(130, 100, 220)
    local colorWindowBackground = Color3.fromRGB(30, 31, 36) -- For individual content windows if they need a background
    local colorAdminRed = Color3.fromRGB(255, 70, 70)

    local PlayersService = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local Camera = workspace:WaitForChild("Camera")
    local localPlayer = PlayersService.LocalPlayer

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NobGG_MainGui"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- Main Draggable Frame for the entire UI (non-fullscreen, rounded)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "NobGG_MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = colorNavbarBackground
    MainFrame.Size = UDim2.new(0, 700, 0, 400) -- Example: 700x400 pixels
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -200) -- Centered on screen
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true

    local MainFrameCorner = Instance.new("UICorner")
    MainFrameCorner.CornerRadius = UDim.new(0, 8) -- Rounded corners for the MainFrame
    MainFrameCorner.Parent = MainFrame

    -- Navbar Frame (child of MainFrame, will appear rounded due to MainFrame's clipping)
    local NavbarFrame = Instance.new("Frame")
    NavbarFrame.Name = "Navbar"
    NavbarFrame.Parent = MainFrame
    NavbarFrame.BackgroundColor3 = colorNavbarBackground
    NavbarFrame.Size = UDim2.new(1, 0, 0, 60) -- Full width of MainFrame, 60px height
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
    TabsContainer.Position = UDim2.new(0.5, -(TabsContainer.AbsoluteSize.X / 2) - NavbarPadding.PaddingLeft.Offset / 2 + NavbarPadding.PaddingRight.Offset / 2, 0, 0) -- More accurate centering
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
    UserInfoFrame.Size = UDim2.new(0, 240, 1, 0) -- Adjusted for PFP and new text format
    UserInfoFrame.Position = UDim2.new(1, -240 - NavbarPadding.PaddingRight.Offset, 0, 0) -- Positioned to the right (minus its own width and navbar padding)
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
    -- Attempt to fetch Roblox profile picture for the local player
    local userIdToFetch = localPlayer.UserId
    pcall(function()
        local thumbType = Enum.ThumbnailType.HeadShot
        local thumbSize = Enum.ThumbnailSize.Size48x48
        local content, isReady = PlayersService:GetUserThumbnailAsync(userIdToFetch, thumbType, thumbSize)
        if isReady then
            UserProfileImage.Image = content
        else
            UserProfileImage.Image = "rbxassetid://1800000000" -- Fallback placeholder
        end
    end)

    local imgCorner = Instance.new("UICorner")
    imgCorner.CornerRadius = UDim.new(1,0) -- Make it circular
    imgCorner.Parent = UserProfileImage

    local UserTextInfoFrame = Instance.new("Frame")
    UserTextInfoFrame.Name = "UserTextInfoFrame"
    UserTextInfoFrame.Parent = UserInfoFrame
    UserTextInfoFrame.BackgroundTransparency = 1
    UserTextInfoFrame.Size = UDim2.new(0, 170, 0, 40) -- Adjusted size
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
    -- Format: "Nob (1)" with "Nob" colored red if Admin
    UsernameLabel.RichText = true
    if role_val == "Admin" then
        UsernameLabel.Text = "<font color='#" .. Color3.toHex(colorAdminRed) .. "'>" .. username_val .. "</font>" .. " (" .. uid_val .. ")"
    else
        UsernameLabel.Text = username_val .. " (" .. uid_val .. ")"
    end
    UsernameLabel.TextColor3 = colorTextPrimary -- Default color, RichText will override specific parts
    UsernameLabel.TextSize = 14.000
    UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    UsernameLabel.BackgroundTransparency = 1
    UsernameLabel.Size = UDim2.new(1,0,0,18)

    local UserRoleLabel = Instance.new("TextLabel")
    UserRoleLabel.Name = "UserRoleLabel"
    UserRoleLabel.Parent = UserTextInfoFrame
    UserRoleLabel.Font = Enum.Font.Gotham
    UserRoleLabel.Text = "[" .. string.upper(role_val) .. "]" -- Format: [ADMIN]
    UserRoleLabel.TextColor3 = colorTextSecondary
    UserRoleLabel.TextSize = 12.000
    UserRoleLabel.TextXAlignment = Enum.TextXAlignment.Left
    UserRoleLabel.BackgroundTransparency = 1
    UserRoleLabel.Size = UDim2.new(1,0,0,16)
    
    -- Content Area for windows (Transparent "workspace")
    local ContentWindowsContainer = Instance.new("Frame")
    ContentWindowsContainer.Name = "ContentWindowsContainer"
    ContentWindowsContainer.Parent = MainFrame
    ContentWindowsContainer.Size = UDim2.new(1, 0, 1, -NavbarFrame.Size.Y.Offset) -- Full width, height below navbar
    ContentWindowsContainer.Position = UDim2.new(0, 0, 0, NavbarFrame.Size.Y.Offset)
    ContentWindowsContainer.BackgroundTransparency = 1 -- Fully transparent "workspace"
    ContentWindowsContainer.ClipsDescendants = true

    -- Draggable Navbar (to move MainFrame)
    local DragMousePosition
    local FramePosition_Draggable 
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
                 DragMousePosition = Vector2.new(input.Position.X, input.Position.Y)
                 FramePosition_Draggable = Vector2.new(MainFrame.Position.X.Scale, MainFrame.Position.Y.Scale)
            end
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Draggable == true then 
            local delta = (Vector2.new(input.Position.X, input.Position.Y) - DragMousePosition) / Camera.ViewportSize
            MainFrame.Position = UDim2.new(FramePosition_Draggable.X + delta.X, 0, FramePosition_Draggable.Y + delta.Y, 0)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Draggable = false
        end
    end)

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
        contentWindow.BackgroundColor3 = colorWindowBackground 
        contentWindow.BackgroundTransparency = 1 -- Individual content windows are also transparent by default
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
            txtLabel.Parent = contentWindow 
            txtLabel.Text = labelText
            txtLabel.TextColor3 = colorTextPrimary
            txtLabel.TextSize = 16
            txtLabel.BackgroundTransparency = 1
            txtLabel.Size = UDim2.new(0.9,0,0,30) 
            txtLabel.Position = UDim2.new(0.05,0,0.1,0) 
            -- For proper layout, contentWindow should have a UIListLayout or similar
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
