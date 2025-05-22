-- Continuous Mining Script for UO
function oreProcessin()
    local itemIdSmallOrePile = {0x19B9, 0x19B8, 0x19BA, 0x19B7}
    
    local itemList1 = Items.FindByFilter({})
    for index, item1 in ipairs(itemList1) do
        if item1 ~= nil then
            if item1.RootContainer ~= Player.Serial then
                goto continue
            end
            
            if item1.Graphic == itemIdSmallOrePile[1]
            or item1.Graphic == itemIdSmallOrePile[2] 
            or item1.Graphic == itemIdSmallOrePile[3] then

                Messages.Overhead("Large pile found...", Player.Serial)

                local itemList2 = Items.FindByFilter({})
                for index, item2 in ipairs(itemList2) do
                    if item2 ~= nil then
                        if item2.RootContainer ~= Player.Serial then
                            goto continue
                        end

                        if item1.Hue ~= item2.Hue then
                            goto continue
                        end
                
                        if item2.Graphic == itemIdSmallOrePile[4] then
                            Player.UseObject(item1.Serial)
                            if Targeting.WaitForTarget(1000) then
                                Messages.Overhead("Combining...", Player.Serial)
                                Targeting.Target(item2.Serial)
                                Pause(750)
                                break
                            end
                        end

                        ::continue::
                    end
                end
            end

            ::continue::
        end
    end
end

function Main()
    -- Finding Pickaxe - check multiple equipment layers
    local axe = nil
    -- Check common equipment layers (1=right hand, 2=left hand)
    for _, layer in ipairs({1, 2}) do
        local checkAxe = Items.FindByLayer(layer)
        if checkAxe and string.find(string.lower(checkAxe.Name or ""), "pickaxe") then
            axe = checkAxe
            break
        end
    end

    local equipaxe = Items.FindByName('Pickaxe')
    

    -- Equip Pickaxe if needed
    if axe == nil and equipaxe ~= nil then
        Player.Equip(equipaxe.Serial)
        Pause(1000)  -- Wait for equip to complete
        
        -- Check multiple layers again after equipping
        for _, layer in ipairs({1, 2}) do
            local checkAxe = Items.FindByLayer(layer)
            if checkAxe and string.find(string.lower(checkAxe.Name or ""), "pickaxe") then
                axe = checkAxe
                break
            end
        end
    end
        -- Make sure we have a pickaxe before continuing
        if axe == nil then
            Player.Say("I need to equip the Pickaxe")
            return
        end
        
        Journal.Clear()
        
        -- Main mining loop - no skill level check
        while true do
            -- Check weight before continuing
            if Player.Weight > 500 then
                Player.Say("This ore is getting heavy...")
                return  -- Exit script to handle banking
            end
            
            -- Use the pickaxe
            Player.UseObject(axe.Serial)
            
            -- Target a mining spot
            if Targeting.WaitForTarget(1000) then
                Targeting.TargetLast()
            end
            
            -- Wait for mining to complete
            Pause(1500)  -- Mining typically takes longer than 1500ms
            
            -- Check for journal messages
            if Journal.Contains('There is no metal here to mine.') then
                Player.Say("No more ore! Move to new spot!")
                Journal.Clear()
            end
            
            -- Check weight, and process ore if over 390
            if Player.Weight >= 390 then
                oreProcessin()
            end
    
            -- Check for equipment issues
            if Journal.Contains('Error in function') then
                Player.Say("Having equipment issues, trying to re-equip")
                if equipaxe ~= nil then
                    Player.Equip(equipaxe.Serial)
                    Pause(1000)
                    
                    -- Check multiple layers again after re-equipping
                    axe = nil
                    for _, layer in ipairs({1, 2}) do
                        local checkAxe = Items.FindByLayer(layer)
                        if checkAxe and string.find(string.lower(checkAxe.Name or ""), "Pickaxe") then
                            axe = checkAxe
                            break
                        end
                    end
                    
                    if axe == nil then
                        Player.Say("Failed to equip pickaxe properly")
                        return
                    end
                else
                    Player.Say("Cannot find Pickaxe in backpack")
                    return
                end
                Journal.Clear()
            end
        end
    end
    
    Main()