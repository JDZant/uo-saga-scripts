local GOLD_COIN_ID = 0x0EED

local corpse = Items.FindByFilter({
    name = "Corpse",
    serial = {0x00000000}
})

if(corpse ~= nil) then
    Messages.Print('found corpse')
    Player.Say("Corpse found!")
    Player.UseObject(corpse.Serial)
    Gumps.WaitForGump(0, 1000)
    
    -- Find gold in the corpse
    local gold = Items.FindByType(GOLD_COIN_ID)
    if gold ~= nil then
        Player.PickUp(gold.Serial)
        Player.DropInBackpack()
    end
end

