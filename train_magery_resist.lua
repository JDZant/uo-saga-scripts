--========= Magery & Resist Trainer ========--
-- Author: aKKa
-- Server: UO Sagas
-- Description: Trains Magery by casting spells on self. Also trains resisting spells.
--              Automatically meditates for mana and heals when low on health.
--==========================================--

local magerySpells = {
    { min = 70, spell = 'EnergyBolt' },
    { min = 50, spell = 'ManaDrain' },
    { min = 40, spell = 'Fireball' },
    { min = 0,  spell = 'Cure' }
}

local meditationMessages = {
    { value = 'You cannot focus your concentration', pause = 10000 },
    { value = 'You must wait a few moments to use another skill', pause = 1000 },
    { value = 'You stop meditation', pause = 100 },
    { value = 'You are at peace', pause = 100 }
}

-- Manages the meditation process to restore mana to full.
-- It handles various system messages until mana is at maximum.
function Meditate()
    while Player.Mana < Player.MaxMana do
        Journal.Clear()
        Skills.Use('Meditation')
        Pause(3000)
        for _, message in ipairs(meditationMessages) do
            if Journal.Contains(message.value) then
                if message.value == 'You are at peace' then
                    return
                else
                    Pause(message.pause)
                    Skills.Use('Meditation')
                end
            end
        end
    end
end

-- Determines which healing spell to use based on missing health.
-- @return {string} 'GreaterHeal' if more than 10 HP is missing, otherwise 'Heal'.
function GetHealingSpellString()
    if Player.HitsMax - Player.Hits <= 20 then
        return 'Heal'
    else
        return 'GreaterHeal'
    end
end

-- Restores the player's health to maximum.
-- It will meditate if mana is low, then cast the appropriate healing spell on the player.
function HealSelf()
    while Player.Hits < Player.HitsMax do
        if(Player.Mana < 20) then 
            Meditate()
        end
        Spells.Cast(GetHealingSpellString())
        if Targeting.WaitForTarget(5000) then
            Targeting.Target(Player.Serial)
            Pause(800)
        end
    end
end

-- Main training loop.
-- Continues until Magery skill reaches 100.
while Skills.GetValue('Magery') or Skills.GetValue('Resist') < 100 do
    Pause(50)
    if Player.Mana <= 20 or Journal.Contains('insufficient mana') then
        Meditate()
    end

    if Player.Hits < 40 then
        HealSelf()
    else
        currentMagery = Skills.GetValue('Magery')
        for _, data in ipairs(magerySpells) do
            if currentMagery >= data.min then
                Spells.Cast(data.spell)
                break
            end
        end

        if Targeting.WaitForTarget(5000) then
            Targeting.Target(Player.Serial)
            Pause(800)
        end
    end
end