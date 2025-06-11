--========= Sparring Trainer ========--
-- Author: aKKa
-- Server: UO Sagas
-- Description: Trains combat skills by attacking a sparring partner (target) and healing them with bandages.
--              Automatically equips a butcher knife and manages bandages.
--              Set target serial to heal and attack.
--              Set bandage serial to use for healing.
--              TODO: Add functionality to replace shield and armor when damaged.
--              TODO: Check if target needs healing before calling HealTarget.
--==========================================--

local target = 1648799
local bandage = 1124101655
local layers = {1, 2}

-- Change this to the item you want to use
local itemString = 'Butcher Knife'

function GetItem()
    Messages.Print('Getting item')
    return Items.FindByName(itemString)
end

function EquipItem(item)
    Messages.Print('Equipping item')
    Player.Equip(item.Serial)
    Pause(1000)
end

function AttackTarget()
    Messages.Print('Attacking target')
    Player.Attack(target)
    Pause(500)
end

function HealTarget()
    Messages.Print('Healing target')
    Player.UseObject(bandage)
    Targeting.WaitForTarget(1000)
    Targeting.Target(target)
    Pause(10000)
end

function CheckForItem()
    Messages.Print('Checking for item')
    local item = nil
    -- Check for equipped item in right and left hand
    for _, layer in ipairs(layers) do
        local checkItem = Items.FindByLayer(layer)
        if checkItem and string.find(string.lower(checkItem.Name or ""), itemString) then
            item = checkItem
            break
        end
    end

    -- If no item is equipped, get one and equip it
    if not item then
        item = GetItem()
        if item then
            EquipItem(item)
        end
    end

    return item
end

function Main()
    Messages.Print('Starting main loop')
    while true do
        local item = CheckForItem()
        if item then
            AttackTarget()
        end
        -- TODO: Check if target needs healing before calling HealTarget
        HealTarget()
    end
end

Main()

