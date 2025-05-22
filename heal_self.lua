-- Bandage ID
local BANDAGE_ID = '1098813581'

-- Use bandage and target self
function UseBandage()
    local bandage = Items.FindByType(0x0E21)
    if bandage then
        Player.UseObject(bandage.Serial)
        Targeting.WaitForTarget(2000)
        Targeting.TargetSelf()
    else
        Player.Say("No bandages found!")
    end
end

UseBandage()