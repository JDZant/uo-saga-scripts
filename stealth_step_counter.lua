-- Created by: Coolskin gpt
-- Function to detect if the position has changed and count the number of changes
local maxStep = 10   -- Number of steps before the warning
local autoStealth = true -- If enabled, use Stealth at the end of the countdown
local previousX, previousY = Player.X, Player.Y
local positionChangeCount = 0

local function activateStealthAndCheck()
    Journal.Clear()
    Skills.Use('Stealth')
    Pause(500)
    while not Journal.Contains("You begin to move quietly.") do
        Messages.Overhead("wait stealh", 44, Player.Serial)
        Pause(1000)
        Skills.Use('Stealth')  -- Try again to use Stealth if the message isn't found
    end
    Messages.Overhead("Stealth activated!", 64, Player.Serial)
    -- If the message is found, continue with the script
    Messages.Overhead("Stealth successfully activated!", 34, Player.Serial)
    Journal.Clear()  
end

-- Function to track position changes
local function trackPositionChanges()
    -- Compare the current position with the previous position
    if Player.X ~= previousX or Player.Y ~= previousY then
        -- If the position has changed, increment the counter
        positionChangeCount = positionChangeCount + 1
        -- Update the previous position to the new one
        previousX = Player.X
        previousY = Player.Y

        maxStep = maxStep - 1

        -- Display the remaining steps
        Messages.Overhead("Remaining steps: " .. maxStep, 34, Player.Serial)

        -- Check if maxStep has reached 0
        if maxStep <= 0 then
            Messages.Overhead("Attention: maxStep reached 0!", 34, Player.Serial)
            
            -- If autoStealth is enabled, use 'Stealth' and check the message
            if autoStealth then
                activateStealthAndCheck()
            end

            -- Reset maxStep to 10 after using Stealth (or according to your preference)
            maxStep = 10
        end
    end
end
while true do
    trackPositionChanges()
end