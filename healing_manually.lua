-- Use bandage and target self
local bandageInProgress = false

-- Function to check if healing is in progress
function IsHealingInProgress()
    return bandageInProgress
end

function UseBandage()
    if bandageInProgress then
        Player.Say("Bandage already in progress")
        return false
    end
    
    local bandage = Items.FindByType(0x0E21)
    if bandage then
        Player.Say("Using bandage")
        Player.UseObject(bandage.Serial)
        Targeting.WaitForTarget(2000)
        Targeting.TargetSelf()
        
        -- Check for healing messages
        if Journal.Contains("You begin applying the bandages.") then
            Player.Say("Healing started")
            bandageInProgress = true
        end
        
        if Journal.Contains("You finish applying the bandages.") then
            Player.Say("Healing completed")  
            bandageInProgress = false
            Journal.Clear()
        end
        
        return true
    end
    
    print("No bandages found!")
    return false
end

-- Example usage
if(not IsHealingInProgress()) then
    UseBandage()
end

