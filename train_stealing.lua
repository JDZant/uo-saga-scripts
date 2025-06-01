-- CONFIG
floorBag = 1125490867       -- Ground bag (outer)
itemToSteal = 1125492584    -- Specific item being stolen and returned
backpack = 1113633156       -- Your backpack

while true do
    Messages.Print(floorBag, itemToSteal, backpack)
    Messages.Print("Starting loop...", 55, Player.Serial)
    Pause(1000)
    Messages.Print("Attempting to steal item.", 55, Player.Serial)
    Pause(500)
    Journal.Clear()
    Skills.Use("Stealing")
    Targeting.WaitForTarget(1000)
    Targeting.Target(itemToSteal)
    Pause(1000)
    
    if Journal.Contains('You fail to steal the item.') then
        Messages.Print("Steal attempt failed.", 55, Player.Serial)
        Pause(1500)
        Messages.Print("Wait for timer to reset...", 55, Player.Serial)
        Pause(6500)
        Journal.Clear()
    end
    if Journal.Contains("You successfully steal the item.") then
        Messages.Print("Success! Moving stolen bag back.", 55, Player.Serial)
        Pause(1500)
        Player.PickUp(itemToSteal)
        Player.DropInContainer(floorBag)
        Messages.Print("Wait for timer reset.", 55, Player.Serial)
        Pause(6500)
    end
    
    Messages.Print("Picking up bag...", 55, Player.Serial)
    Player.PickUp(floorBag)
    Pause(1000)
    Player.DropOnGround()
    Messages.Print("Bag dropped. Item decay cancelled.", 55, Player.Serial)
    Pause(1000)
    
end