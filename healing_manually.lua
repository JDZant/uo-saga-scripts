if _G.bandageInProgress == nil then
    _G.bandageInProgress = false
end

-- Function to check if healing is in progress.
function IsHealingInProgress()
    if _G.bandageInProgress then
        if Journal.Contains("You finish applying the bandages.") then
            Messages.Print("System: Healing previously in progress now detected as finished.")
            _G.bandageInProgress = false
            Journal.Clear()
        elseif Journal.Contains("Your healing attempt has failed.") then
            Messages.Print("System: Healing previously inprogress now detected as failed.")
            _G.bandageInProgress = false
            Journal.Clear()
        end
    end
    return _G.bandageInProgress
end

-- Function to use a bandage on self
function UseBandage()
    local bandage = Items.FindByType(0x0E21) -- Item ID for bandages
    if bandage then
        Messages.Print("Attempting to use bandage on self...")
        Journal.Clear()
        
        Player.UseObject(bandage.Serial)
        Targeting.WaitForTarget(2000)
        Targeting.TargetSelf()
        Pause(300) 

        if Journal.Contains("You begin applying the bandages.") then
            Messages.Print("Healing started successfully.")
            _G.bandageInProgress = true -- Set the flag as healing has begun
            return true
        elseif Journal.Contains("You are already healing someone.") then
            Messages.Print("Game reports: You are already healing someone. Flag synced.")
            _G.bandageInProgress = true
            return false
        elseif Journal.Contains("You must wait to perform another action.") then
             Messages.Print("Game reports: Must wait to perform another action.")
             return false
        else
            Messages.Print("Failed to start healing (no confirmation message, or other issue).")
            return false
        end
    else
        Messages.Print("No bandages found in your backpack!")
        return false
    end
end

if IsHealingInProgress() then
    Messages.Print("Bandage already in progress.")
else
    UseBandage()
end

