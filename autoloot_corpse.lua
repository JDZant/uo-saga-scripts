-- Configuration
local ITEMS_TO_LOOT = {
    {name = "Gold", id = 0x0EED},
    {name = "Bandages", id = 0x0E21},
    -- {name = "Lockpicks", id = 0x0F0E}
}
local SEARCH_RANGE = 12 -- How far to look for corpses
local GUMP_TIMEOUT = 2000 -- Milliseconds to wait for a gump
local ACTION_DELAY = 600 -- Milliseconds to pause between actions
local MAX_INTERACTION_DISTANCE = 2 -- Maximum distance to interact with a corpse

-- Function to find the nearest corpse
function FindNearestCorpse()
    Messages.Print("Looking for corpses...")
    local corpseFilter = {
        name = "Corpse"
        -- Not applying range or sort initially to see all results
    }
    local allFoundCorpses = Items.FindByFilter(corpseFilter)
    local nearestCorpse = nil
    local smallestDistance = -1

    if allFoundCorpses ~= nil and #allFoundCorpses > 0 then
        Messages.Print("Found " .. #allFoundCorpses .. " object(s) named 'Corpse':")
        for i, corpse in ipairs(allFoundCorpses) do
            local dist = corpse.Distance
            if dist == nil then 
                dist = "unknown (nil)"
            end
            Messages.Print("  - Corpse [" .. i .. "]: Serial = " .. corpse.Serial .. ", Reported Distance = " .. dist)
            
            -- Attempt to find the truly nearest one
            if corpse.Distance ~= nil then -- Make sure distance is a valid number
                if nearestCorpse == nil or corpse.Distance < smallestDistance then
                    smallestDistance = corpse.Distance
                    nearestCorpse = corpse
                end
            end
        end

        if nearestCorpse ~= nil then
            Messages.Print("Selected nearest corpse: " .. nearestCorpse.Serial .. " at actual distance " .. smallestDistance)
            return nearestCorpse
        else
            Messages.Print("Could not determine a nearest corpse with a valid distance.")
            return nil
        end
    else
        Messages.Print("No objects named 'Corpse' found at all.")
        return nil
    end
end

-- Function to loot items from an opened container (corpse)
function LootContainer(containerSerial)
    Messages.Print("Looting container: " .. containerSerial)
    local itemsLootedThisContainer = 0

    for _, itemToLoot in ipairs(ITEMS_TO_LOOT) do
        -- Find items of the specified type within the container
        -- The -1 for color means any color.
        -- The containerSerial restricts search to this container.
        local itemsInContainer = Items.FindByType(itemToLoot.id, -1, containerSerial)

        if itemsInContainer ~= nil then
            for _, item in ipairs(itemsInContainer) do
                Messages.Print("Found " .. itemToLoot.name .. " (Serial: " .. item.Serial .. "). Attempting to pick up.")
                Player.PickUp(item.Serial)
                Pause(ACTION_DELAY / 2) -- Brief pause after pickup
                Player.DropInBackpack()
                Pause(ACTION_DELAY / 2) -- Brief pause after drop
                itemsLootedThisContainer = itemsLootedThisContainer + 1
                Messages.Print("Looted " .. itemToLoot.name .. " into backpack.")
                -- If we are looting stacks (like gold), we might need to pick up multiple times
                -- For now, this picks up one item object (which could be a stack)
            end
        end
    end

    if itemsLootedThisContainer > 0 then
        Messages.Print("Finished looting " .. itemsLootedThisContainer .. " item(s)/stack(s) from container " .. containerSerial)
    else
        Messages.Print("No items from the loot list found in container " .. containerSerial)
    end
end

-- Main function
function Main()
    Messages.Print("Autoloot script started.")
    Journal.Clear() -- Clear journal at the start of a cycle
    local corpse = FindNearestCorpse()

    if corpse ~= nil and corpse.Serial ~= nil then
        Messages.Print("Checking corpse " .. corpse.Serial .. " at distance: " .. corpse.Distance)
        if corpse.Distance > MAX_INTERACTION_DISTANCE then
            Messages.Print("Corpse is too far away (" .. corpse.Distance .. " tiles). Please move closer to loot.")
        else
            Messages.Print("Corpse is in range. Assuming it is open or will open automatically. Proceeding to loot.")
            LootContainer(corpse.Serial) -- Directly attempt to loot the container
        end
    else
        Messages.Print("No corpse found to loot.")
    end
    Messages.Print("Autoloot script finished one cycle.")
end

-- Run the main function
Main()

-- To make it continuous, you could wrap Main() in a loop:
-- while true do
--   Main()
--   Pause(2000) -- Pause between cycles
-- end 