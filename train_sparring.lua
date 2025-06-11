local target = 1648799
local bandage = 1124101655

function GetButcherKnife()
    local knife = nil
    -- Check for equipped knife in right and left hand
    for _, layer in ipairs({1, 2}) do
        local checkKnife = Items.FindByName('Butcher Knife')
        if checkKnife and string.find(string.lower(checkKnife.Name or ""), "butcher knife") then
            knife = checkKnife
            break
        end
    end

    -- If no knife is equipped, find one in backpack and equip it
    if not knife then
        local equipKnife = Items.FindByName('Butcher Knife')
        if equipKnife then
            Player.Equip(equipKnife.Serial)
            Pause(1000) -- Wait for equip animation
            -- Re-check for equipped knife
            for _, layer in ipairs({1, 2}) do
                local checkKnife = Items.FindByLayer(layer)
                if checkKnife and string.find(string.lower(checkKnife.Name or ""), "butcher knife") then
                    knife = checkKnife
                    break
                end
            end
        end
    end

    if not knife then
        Player.Say("No butcher knife found.")
        return nil
    end
    return knife
end

while true do
    local knife = GetButcherKnife()
    if knife then
        Player.Attack(target)
        Pause(500)
    else
        break
    end
    Player.UseObject(bandage)
    Targeting.WaitForTarget(1000)
    Targeting.Target(target)
    Pause(10000)
end
