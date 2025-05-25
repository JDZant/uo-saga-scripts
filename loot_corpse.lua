 function LootCorpse()
    Player.Say("loot corpse")
    local corpse = Items.FindByType(8197)-- Corpse type ID
    if corpse then
        Player.Say("corpse found")
        Items.Move(corpse.Serial, Player.Backpack.Serial, 0, 0)
        Messages.Overhead("Looting...", 69, Player.Serial)
    end
end 

LootCorpse()