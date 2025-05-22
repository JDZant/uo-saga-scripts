-- Bandage ID
local BANDAGE_ID = '1098813581'

-- Use bandage and target self
function UseBandage()
    local bandage = Items.FindByType(0x0E21)
    if bandage then
        Player.UseObject(bandage.Serial)
        if Targeting.WaitForTarget(2000) then
            Targeting.TargetSelf()
            Player.Say("Bandaging...")
        else
            Player.Say("Failed to get target cursor!")
        end
    else
        Player.Say("No bandages found!")
    end
end

UseBandage()