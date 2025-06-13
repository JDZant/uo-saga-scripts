-- CONFIG
floorBag = 1130329349       -- Ground bag (outer)
itemToSteal = 1113633163    -- Specific item being stolen and returned
backpack = 1113633156       -- Your backpack

-- Function to determine the result of the steal attempt from the journal.
-- This acts as the value we will 'switch' on.
function getStealAttemptResult()
    if Journal.Contains('You successfully steal the item.') then
        return "success"
    elseif Journal.Contains('You fail to steal the item.') then
        return "failure"
    end
    return "unknown"
end

-- This table maps results to functions that handle them, emulating a 'switch-case' structure.
-- This is the implementation of the 'switch' block.
local stealResultHandlers = {
    -- case 'failure'
    ['failure'] = function(resultValue) -- resultValue will be 'failure'
        Messages.Print("Steal attempt failed.", 55, Player.Serial)
        Pause(1500)
        Messages.Print("Wait for timer to reset...", 55, Player.Serial)
        Pause(6500)
        Journal.Clear()
    end,
    -- case 'success'
    ['success'] = function(resultValue) -- resultValue will be 'success'
        Messages.Print("Success! Moving stolen bag back.", 55, Player.Serial)
        Pause(1500)
        Player.PickUp(itemToSteal)
        Player.DropInContainer(floorBag)
        Messages.Print("Wait for timer reset.", 55, Player.Serial)
        Pause(6500)
    end,
    -- 'default' case
    ['unknown'] = function(resultValue) -- resultValue will be 'unknown'
        Messages.Print("Unknown steal result (" .. resultValue .. "). Continuing loop.", 55, Player.Serial)
        Pause(1000)
    end
}

while true do
    Messages.Print("Starting steal loop...", 55, Player.Serial)
    Pause(1000)
    
    Messages.Print("Attempting to steal item: " .. itemToSteal, 55, Player.Serial)
    Pause(500)
    Journal.Clear()
    Skills.Use("Stealing")
    Targeting.WaitForTarget(1000)
    Targeting.Target(itemToSteal)
    Pause(4000) -- Wait a few seconds for the journal to update with the result.
    
    -- Here is the switch-case logic in action.
    -- 1. Get the value to switch on.
    local result = getStealAttemptResult()
    
    -- 2. Find the correct 'case' (handler function) from our table. Use the 'unknown' handler as the default.
    local handler = stealResultHandlers[result] or stealResultHandlers['unknown']
    
    -- 3. Execute the handler, passing the result value to it as requested.
    handler(result)
    
    Messages.Print("Picking up bag to reset decay timer...", 55, Player.Serial)
    Player.PickUp(floorBag)
    Pause(1000)
    Player.DropOnGround()
    Messages.Print("Bag dropped. Loop restarting.", 55, Player.Serial)
    Pause(1000)
end