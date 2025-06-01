while Skills.GetValue('Stealth') < 100 do
    -- Ne pas se cacher si déjà caché
    if not Player.IsHidden then
        Skills.Use('Hiding')
        Pause(10200)
    end

    if Player.IsHidden and Skills.GetValue('Hiding') >= 80 then
        Skills.Use('Stealth')
        Pause(10200)
    end
end

-- Une fois que Stealth a atteint 120, augmenter Hiding à 100
while Skills.GetValue('Hiding') < 100 do
    Skills.Use('Hiding')
    Pause(10200)
end