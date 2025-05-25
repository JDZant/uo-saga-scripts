-- Bandage ID
local BANDAGE_ID = '1098813581'

-- Use bandage and target self
function UseBandage()
    local bandage = Items.FindByType(0x0E21)
    if bandage then
        Player.UseObject(bandage.Serial)
        Targeting.WaitForTarget(2000)
        Targeting.TargetSelf()
        return true
    end
end

-- Main healing loop
while true do
    local currentHP = Player.Hits
    local maxHP = Player.HitsMax
    
    -- If health is below max, try to heal
    if currentHP < maxHP then
        if UseBandage() then
            -- Wait for healing to complete (adjust time as needed)
            Pause(10000)
        end
    end
    
    -- Small delay to prevent excessive CPU usage
    Pause(1000)
end