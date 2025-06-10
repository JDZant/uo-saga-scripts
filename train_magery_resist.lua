-- Training Magery
-- Casting Invisibility, Mana Drain, and Mana Vampire
-- Edited by Jaseowns
-- Server: UO Sagas

-- Helper function for meditation
function Meditate()
    while Player.Mana < Player.MaxMana do
        Journal.Clear()
        Skills.Use('Meditation')
        Pause(700)
        if Journal.Contains('You cannot focus your concentration') then
            Pause(10000)
            Meditate()
        elseif Journal.Contains('You must wait a few moments to use another skill') then
            Pause(1000)
            Meditate()
        elseif Journal.Contains('You stop meditation') then
            Pause(1000)
            Meditate()
        elseif Journal.Contains('You are at peace') then
            Pause(1000)
            return
        end
    end
end

function healSelf()
    while Player.Hits < Player.HitsMax do
        if(Player.Mana < 20) then 
            Meditate()
        end
        Spells.Cast('GreaterHeal')
        if Targeting.WaitForTarget(5000) then
            Targeting.Target(Player.Serial)
            Pause(800)
        end
    end
end


while Skills.GetValue('Magery') < 100 do
    Pause(50)
    if Player.Mana == 0 or Journal.Contains('insufficient mana') then
        Meditate()
    end

    if Player.Hits < 40 then
        healSelf()
    else
        currentMagery = Skills.GetValue('Magery')
        if currentMagery >= 70 then
            if Player.Hits > 35 then
                Spells.Cast('ManaVampire')
            end
        elseif currentMagery >= 62 then
            Spells.Cast('ManaDrain')
        elseif currentMagery >= 50 then
            Spells.Cast('ManaDrain')
        elseif currentMagery >= 40 then
            Spells.Cast('Fireball')
        elseif currentMagery < 40 then
            Spells.Cast('Cure')
        end

        if Targeting.WaitForTarget(5000) then
            Targeting.Target(Player.Serial)
            Pause(800)
        end
    end
end