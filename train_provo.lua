local firstMob = Mobiles.FindByName('a frenzied ostard').Serial
local secondMob = 3615922

function ProvokeWithNewInstrument()
    Messages.Print('Using new instrument and setting targets...')
    local tambourine = Items.FindByName('Tambourine')
    Spells.Cast('SongOfProvocation')
    Targeting.WaitForTarget(1000)
    -- Target the new instrument
    Targeting.Target(tambourine.Serial)
    Pause(1000)
    TargetFirstMob()
    Pause(1000)
    TargetSecondMob()
end

function TargetFirstMob()
    Targeting.WaitForTarget(1000)
    Targeting.Target(firstMob)
end

function TargetSecondMob()
    Targeting.WaitForTarget(1000)
    Targeting.Target(secondMob)
end

function CheckJournalForAttacking()
    if Journal.Contains('is attacking you!') then
        Player.Say('Guards!')
    end
end

function Main()
    while Skills.GetValue('Provocation') < 100 do
        Journal.Clear()
        Spells.Cast('SongOfProvocation')
        Pause(1000)
        if Journal.Contains('What instrument shall you play') then
            Messages.Print('Using new instrument...')
            ProvokeWithNewInstrument()
        else
            if (Items.FindByName('Tambourine') ~= nil) then
                Messages.Print('Using old instrument...')
                Spells.Cast('SongOfProvocation')
                Pause(1000)
                TargetFirstMob()
                Pause(1000)
                TargetSecondMob()
            end
        end
    end
    Pause(1000)
end

Main()
