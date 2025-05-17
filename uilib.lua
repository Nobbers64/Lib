-- Replace the line below with your actual loadstring call to lib.lua
local NobGG = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nobbers64/Lib/refs/heads/main/uilib.lua"))()

-- Create the main UI with Navbar
-- You can pass custom user info if needed:
-- local MyNobGG_UI = NobGG:CreateNobGG({
--     Username = "CustomUser",
--     UID = "UID: 007",
--     Role = "Admin",
--     LibName = "MyLib"
-- })
local NobGGInterface = NobGG:CreateNobGG() -- Uses default demo data

-- Create tabs in the Navbar
local VisualsTab = NobGGInterface:CreateTab("Visuals")
local CombatTab = NobGGInterface:CreateTab("Combat")
local UtilityTab = NobGGInterface:CreateTab("Utility")
local SettingsTab = NobGGInterface:CreateTab("Settings")

-- Add elements to a tab's content window (conceptual for now, as ElementHandler is basic)
-- The TextLabel will be parented to the VisualsTab's associated content window.
if VisualsTab and VisualsTab.TextLabel then
    VisualsTab:TextLabel("ESP Settings will go here.")
    -- Example of adding more elements if ElementHandler was fully fleshed out for the new design:
    -- VisualsTab:Toggle("Enable Box ESP", function(state) print("Box ESP:", state) end)
    -- VisualsTab:Slider("Render Distance", 0, 1000, function(val) print("Distance:", val) end)
end

if CombatTab and CombatTab.TextLabel then
    CombatTab:TextLabel("Aimbot and Triggerbot settings.")
end

if UtilityTab and UtilityTab.TextLabel then
    UtilityTab:TextLabel("Miscellaneous utilities.")
end

if SettingsTab and SettingsTab.TextLabel then
    SettingsTab:TextLabel("UI Configuration and other settings.")
end


print("NobGG UI Navbar Example Loaded.")
-- Note: The actual content windows and detailed element styling
-- (like square toggles, specific slider looks from the screenshot)
-- will need further implementation in lib.lua's ElementHandler.
-- This example primarily demonstrates Navbar and Tab creation.
