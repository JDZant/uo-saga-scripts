-- CONFIG
floorBag = 1125242506       -- Ground bag (outer)
itemToSteal = 1125257678    -- Specific item being stolen and returned
backpack = 1113633156       -- Your backpack

while true do
    Messages.Overhead(floorBag, itemToSteal, backpack)
    Messages.Overhead("Starting loop...", 55, Player.Serial)
    Pause(1000)
    Messages.Overhead("Attempting to steal item.", 11, Player.Serial)
    Pause(500)
    Journal.Clear()
    Skills.Use("Stealing")
    Targeting.WaitForTarget(1000)
    Targeting.Target(itemToSteal)
    Pause(1000)
    
    if Journal.Contains('You fail to steal the item.') then
        Messages.Overhead("Steal attempt failed.", 44, Player.Serial)
        Pause(1500)
        Messages.Overhead("Wait for timer to reset...", 55, Player.Serial)
        Pause(6500)
        Journal.Clear()
    end
    if Journal.Contains("You successfully steal the item.") then
        Messages.Overhead("Success! Moving stolen bag back.", 68, Player.Serial)
        Pause(1500)
        Player.PickUp(itemToSteal)
        Player.DropInContainer(floorBag)
        Messages.Overhead("Wait for timer reset.", 55, Player.Serial)
        Pause(6500)
    end
    
    Messages.Overhead("Picking up bag...", 88, Player.Serial)
    Player.PickUp(floorBag)
    Pause(1000)
    Player.DropOnGround()
    Messages.Overhead("Bag dropped. Item decay cancelled.", 68, Player.Serial)
    Pause(1000)
    
end