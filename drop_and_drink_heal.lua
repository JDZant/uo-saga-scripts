--========= Unequip Shield and Drink Heal ========--
-- Author: User
-- Description: Unequips shield, drinks a healing potion, then reequips shield
-- Usage: Call UnEquipShieldAndDrinkHealPotion() to execute the sequence
-- Dependencies: None
--=======================================

function UnEquipShieldAndDrinkHealPotion()
    Journal.Clear()
    
    local shield = Items.FindByLayer(2)
    if shield == nil then
        return false
    end
    
    local potion = Items.FindByType(0x0F0C)
    if potion == nil then
        return false
    end
    
    local shieldSerial = shield.Serial
    
    Player.PickUp(shieldSerial)
    Pause(500)
    
    if Journal.Contains("You cannot pick that up") or Journal.Contains("That is too far away") then
        return false
    end
    
    Player.DropInBackpack()
    Pause(500)
    
    Player.UseObject(potion.Serial)
    Pause(1000)
    
    if Journal.Contains("You cannot use that") then
        return false
    end
    
    Pause(500)
    
    local shieldInBackpack = Items.FindBySerial(shieldSerial)
    if shieldInBackpack ~= nil then
        Player.Equip(shieldSerial)
        Pause(500)
        
        if Journal.Contains("You equip") then
            return true
        else
            return false
        end
    else
        return false
    end
end

UnEquipShieldAndDrinkHealPotion()