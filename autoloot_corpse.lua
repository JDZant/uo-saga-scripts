--========= AutoLoot Corpse ========--
-- Author: Deuce
-- Description: Finds and loots nearby corpses
-- Usage: Run the script
-- Dependencies: None
--======================================--

-- Configuration
local LOOT_BAG_SERIAL = 1149201932 -- << SET YOUR LOOT BAG SERIAL ID HERE, or leave nil to use backpack
local ITEMS_TO_LOOT = BuildLootList()
local SEARCH_RANGE = 12 -- How far to look for corpses
local GUMP_TIMEOUT = 2000 -- Milliseconds to wait for a gump
local ACTION_DELAY = 600 -- Milliseconds to pause between actions
local MAX_INTERACTION_DISTANCE = 2 -- Maximum distance to interact with a corpse

-- Item Types Database
local ItemTypes = {
    Shields = {
        { ItemType = 0x1b72, Name = "BronzeShields" },
        { ItemType = 0x1b73, Name = "Buckler" },
        { ItemType = 0x1b7b, Name = "MetalShield" },
        { ItemType = 0x1b74, Name = "Metal Kite Shield" },
        { ItemType = 0x1b79, Name = "Tear Kite Shield" },
        { ItemType = 0x1b7a, Name = "WoodenShield" },
        { ItemType = 0x1b76, Name = "HeaterShield" }
    },
    BoneArmor = {
        { ItemType = 0x1451, Name = "Bone Helmet" },
        { ItemType = 0x144f, Name = "Bone Armor" },
        { ItemType = 0x1452, Name = "Bone Leggings" },
        { ItemType = 0x144e, Name = "Bone Arms" },
        { ItemType = 0x1450, Name = "Bone Gloves" }
    },
    Platemail = {
        { ItemType = 0x1408, Name = "Close Helmet" },
        { ItemType = 0x1410, Name = "Platemail Arms" },
        { ItemType = 0x1411, Name = "Platemail Legs" },
        { ItemType = 0x1412, Name = "Plate Helm" },
        { ItemType = 0x1413, Name = "Plate Gorget" },
        { ItemType = 0x1414, Name = "Platemail Gloves" },
        { ItemType = 0x1415, Name = "Plate Chest" },
        { ItemType = 0x140a, Name = "Helmet" },
        { ItemType = 0x140c, Name = "Bascinet" },
        { ItemType = 0x140e, Name = "Norse Helm" }
    },
    Chainmail = {
        { ItemType = 0x13bb, Name = "Chainmail Coif" },
        { ItemType = 0x13be, Name = "Chainmail Leggins" },
        { ItemType = 0x13bf, Name = "Chainmail Tunic" }
    },
    Ringmail = {
        { ItemType = 0x13ee, Name = "Ringmail Sleeves" },
        { ItemType = 0x13eb, Name = "Ringmail Gloves" },
        { ItemType = 0x13ec, Name = "Ringmail Tunic" },
        { ItemType = 0x13f0, Name = "Ringmail Leggins" }
    },
    Studded = {
        { ItemType = 0x13da, Name = "Studded Leggings" },
        { ItemType = 0x13db, Name = "Studded Tunic" },
        { ItemType = 0x13d5, Name = "Studded Gloves" },
        { ItemType = 0x13d6, Name = "Studded Gorget" },
        { ItemType = 0x13dc, Name = "Studded Sleeves" }
    },
    Leather = {
        { ItemType = 0x13c6, Name = "Leather Gloves" },
        { ItemType = 0x13cd, Name = "Leather Sleeves" },
        { ItemType = 0x13cc, Name = "Leather Tunic" },
        { ItemType = 0x13cb, Name = "Leather Pants" },
        { ItemType = 0x13c7, Name = "Leather Gorget" },
        { ItemType = 0x1db9, Name = "Leather Cap" }
    },
    FemaleArmor = {
        { ItemType = 0x1c04, Name = "Female Plate" },
        { ItemType = 0x1c0c, Name = "Female Studded Bustier" },
        { ItemType = 0x1c02, Name = "Female Studded Armor" },
        { ItemType = 0x1c00, Name = "Female Leather Shorts" },
        { ItemType = 0x1c08, Name = "Female Leather Skirt" },
        { ItemType = 0x1c06, Name = "Female Leather Armor" },
        { ItemType = 0x1c0a, Name = "Female Leather Bustier" }
    },
    Fencing = {
        { ItemType = 0x0f62, Name = "Spear" },
        { ItemType = 0x1403, Name = "Short Spear" },
        { ItemType = 0x0e87, Name = "Pitchfork" },
        { ItemType = 0x1405, Name = "Warfork" },
        { ItemType = 0x1401, Name = "Kryss" },
        { ItemType = 0x0f52, Name = "Dagger" }
    },
    Macing = {
        { ItemType = 0x13b0, Name = "War axe" },
        { ItemType = 0x0df0, Name = "Black Staff" },
        { ItemType = 0x1439, Name = "War Hammer" },
        { ItemType = 0x1407, Name = "War Mace" },
        { ItemType = 0x0e89, Name = "Quarter Staff" },
        { ItemType = 0x143d, Name = "Hammer Pick" },
        { ItemType = 0x13b4, Name = "Club" },
        { ItemType = 0x0e81, Name = "Shepherds Crook" },
        { ItemType = 0x13f8, Name = "Gnarled Staff" },
        { ItemType = 0x0f5c, Name = "Mace" },
        { ItemType = 0x143b, Name = "Maul" }
    },
    Swords = {
        { ItemType = 0x13b9, Name = "Viking Sword" },
        { ItemType = 0x0f61, Name = "Longsword" },
        { ItemType = 0x1441, Name = "Cutlass" },
        { ItemType = 0x13b6, Name = "Scimitar" },
        { ItemType = 0x0ec4, Name = "Skinning Knife" },
        { ItemType = 0x13f6, Name = "Butcher Knife" },
        { ItemType = 0x0f5e, Name = "Broadsword" },
        { ItemType = 0x13ff, Name = "Katana" },
        { ItemType = 0x0ec3, Name = "Cleaver" }
    },
    Axes = {
        { ItemType = 0x0f43, Name = "Hatchet" },
        { ItemType = 0x0f45, Name = "Executioner's Axe" },
        { ItemType = 0x0f4d, Name = "Bardiche" },
        { ItemType = 0x0f4b, Name = "Double Axe" },
        { ItemType = 0x143e, Name = "Halberd" },
        { ItemType = 0x13fb, Name = "Large Battle Axe" },
        { ItemType = 0x1443, Name = "Two Handed Axe" },
        { ItemType = 0x0f47, Name = "Battle Axe" },
        { ItemType = 0x0f49, Name = "Axe" },
        { ItemType = 0x0e85, Name = "Pickaxe" },
        { ItemType = 0x0e86, Name = "Pickaxe" }
    },
    Bows = {
        { ItemType = 0x13fd, Name = "HeavyXbow" },
        { ItemType = 0x0f50, Name = "Xbow" },
        { ItemType = 0x13b2, Name = "bow" }
    },
    Reagents = {
        { ItemType = 0x0f7a, Name = "Black Pearl" },
        { ItemType = 0x0f7b, Name = "Blood Moss" },
        { ItemType = 0x0f86, Name = "Mandrake Root" },
        { ItemType = 0x0f84, Name = "Garlic" },
        { ItemType = 0x0f85, Name = "Ginseng" },
        { ItemType = 0x0f88, Name = "Nightshade" },
        { ItemType = 0x0f8d, Name = "Spider's Silk" },
        { ItemType = 0x0f8c, Name = "Sulphurous Ash" }
    },
    Supplies = {
        { ItemType = 0x0e21, Name = "Bandage" }
    }
}

-- Function to build the list of items to loot
function BuildLootList()
    local lootList = {
        {name = "Gold", id = 0x0EED}
    }
    local categories = {
        "Shields", "BoneArmor", "Platemail", "Chainmail", "Ringmail", "Studded", "Leather", "FemaleArmor",
        "Fencing", "Macing", "Swords", "Axes", "Bows", "Reagents", "Supplies"
    }
    for _, categoryName in ipairs(categories) do
        local category = ItemTypes[categoryName]
        if category then
            for _, item in ipairs(category) do
                table.insert(lootList, {name = item.Name, id = item.ItemType})
            end
        end
    end
    return lootList
end

-- Function to find the nearest corpse
function FindNearestCorpse()
    local corpseFilter = {
        name = "Corpse",
        rangemax = SEARCH_RANGE,
        onground = true
    }
    local allFoundCorpses = Items.FindByFilter(corpseFilter)
    local nearestCorpse = nil
    local smallestDistance = -1

    if allFoundCorpses ~= nil and #allFoundCorpses > 0 then
        for i, corpse in ipairs(allFoundCorpses) do
            local dist = corpse.Distance
            if dist == nil then 
                dist = "unknown (nil)"
            end
            
            -- Attempt to find the truly nearest one
            if corpse.Distance ~= nil then -- Make sure distance is a valid number
                if nearestCorpse == nil or corpse.Distance < smallestDistance then
                    smallestDistance = corpse.Distance
                    nearestCorpse = corpse
                end
            end
        end

        if nearestCorpse ~= nil then
            return nearestCorpse
        else
            return nil
        end
    else
        return nil
    end
end

-- Function to loot items from an opened container (corpse)
function LootContainer(containerSerial)
    local itemsLootedThisContainer = 0

    for _, itemToLoot in ipairs(ITEMS_TO_LOOT) do
        local itemFilter = { graphics = { itemToLoot.id } }
        local foundItems = Items.FindByFilter(itemFilter)

        if foundItems ~= nil and #foundItems > 0 then
            for _, item in ipairs(foundItems) do
                if item.RootContainer == containerSerial then
                    Player.PickUp(item.Serial, item.Amount)
                    Pause(ACTION_DELAY / 2)
                    
                    local droppedInBag = false
                    if LOOT_BAG_SERIAL ~= nil then
                        Player.DropInContainer(LOOT_BAG_SERIAL)
                        droppedInBag = true
                    else
                        Player.DropInBackpack()
                    end
                    
                    Pause(ACTION_DELAY / 2)
                    itemsLootedThisContainer = itemsLootedThisContainer + 1
                end
            end
        end
    end
end

-- Main function
function Main()
    Journal.Clear() -- Clear journal at the start of a cycle
    local corpse = FindNearestCorpse()

    if corpse ~= nil and corpse.Serial ~= nil then
        Player.UseObject(corpse.Serial)
        Pause(ACTION_DELAY)
        LootContainer(corpse.Serial)
    end
end

while true do
    Main()
    Pause(1000)
end
