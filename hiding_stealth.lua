while Skills.GetValue('Stealth') < 100 do
    if not Player.IsHidden then
        Skills.Use('Hiding')
        Pause(10200)
    end

    if Player.IsHidden and Skills.GetValue('Hiding') >= 80 then
        Skills.Use('Stealth')
        Pause(10200)
    end
end

while Skills.GetValue('Hiding') < 100 do
    Skills.Use('Hiding')
    Pause(10200)
end