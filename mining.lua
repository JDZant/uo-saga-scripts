local toolGraphic = 0x0E86 -- Tool identifier
local action = true -- Variable to control execution
Journal.Clear()

-- Error messages to watch for in the journal
local errorMessages = {
    "There is no metal here to mine.",
    "That is too far away.",
    "You can't mine that.",
    "You can't mine there",
    "Target cannot be seen."
}

-- Function to check if a stop message is present in the journal
function checkJournal()
    for _, msg in ipairs(errorMessages) do
        if Journal.Contains(msg) then
            return true, msg -- Returns true and the found message
        end
    end
    return false, nil
end

-- Function to check and equip a tool if necessary
function ensureTool()
    local toolEquiped = Items.FindByLayer(1) -- Check if a tool is equipped in the hand (layer 1)
    
    -- If no tool is equipped, search for a tool in the bag
    if not toolEquiped then
        local toolInBag = Items.FindByType(toolGraphic)

        if toolInBag then
            -- If a tool is found in the bag, equip it
            Player.Equip(toolInBag.Serial)
            Messages.Overhead("New Tool equipped", 14, Player.Serial)
            Pause(1000)
            return true
        else
            -- No tool found, display a message and stop the script
            Messages.Overhead("No tool", 38, Player.Serial)
            return false
        end
    end
    return true
end

-- Main function
function main()
    -- Continuous check, as long as no error is found
    while action do
        -- Check if a tool is available and equipped
        if not ensureTool() then
            action = false
            break
        end

        local toolEquiped = Items.FindByLayer(1) -- Check if the tool is still equipped in the hand

        -- Execute the main action: use the tool and target the last target
        if toolEquiped then
            Player.UseObject(toolEquiped.Serial)
            Pause(1000) -- Wait a second between actions
            Targeting.TargetLast()
        end

        -- Check the journal for specific messages
        local hasError, foundMessage = checkJournal()
        if hasError then
            -- If the error message is "There is no metal here to mine", display a specific message
            if foundMessage == "There is no metal here to mine." then
                Messages.Overhead("No ore", 73, Player.Serial)
            end
            -- debug
            -- Messages.Overhead(foundMessage, 38, Player.Serial)
            action = false
            break
        end

        -- Clear the journal after each check to avoid duplicates
        Journal.Clear()

        -- Wait a second before the next iteration
        -- Pause(200)
    end
end


while action do
    main()
    -- Pause(200) -- Wait a second between iterations of the main loop
end