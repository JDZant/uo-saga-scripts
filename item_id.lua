while true do
    local items = Items.FindByFilter({
        name = "Unidentified",
        hues = {0}
    })

    for i, item in ipairs(items) do
        if item.RootContainer == Player.Serial then
        Skills.Use('Item Identification')
        Targeting.WaitForTarget(500)
        Targeting.Target(item.Serial)
        Pause(1000)
        end
    end
end