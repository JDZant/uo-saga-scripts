local target = 1648799
local bandage = 1124101655

function GetKnife()
    Messages.Print('Getting butcher knife')
    return Items.FindByName('Butcher Knife')
end

function EquipKnife(knife)
    Messages.Print('Equipping knife')
    Player.Equip(knife.Serial)
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

function CheckForKnife()
    Messages.Print('Checking for knife')
    local knife = nil
    -- Check for equipped knife in right and left hand
    for _, layer in ipairs({1, 2}) do
        local checkKnife = Items.FindByLayer(layer)
        if checkKnife and string.find(string.lower(checkKnife.Name or ""), "butcher knife") then
            knife = checkKnife
            break
        end
    end

    -- If no knife is equipped, get one and equip it
    if not knife then
        knife = GetKnife()
        if knife then
            EquipKnife(knife)
        end
    end

    return knife
end

function Main()
    Messages.Print('Starting main loop')
    while true do
        local knife = CheckForKnife()
        if knife then
            AttackTarget()
        end
        HealTarget()
    end
end

Main()

