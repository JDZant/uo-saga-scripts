-- Configuration
local MAX_WEIGHT_DIFF = 10
local MAX_WEIGHT = 390
local ITEM_ID_WOODEN_LOGS = 0x1BDD -- For log identification

function GetHatchet()
    local axe = nil
    for _, layer in ipairs({1, 2}) do
        local checkAxe = Items.FindByLayer(layer)
        if checkAxe and string.find(string.lower(checkAxe.Name or ""), "hatchet") then
            axe = checkAxe
            break
        end
    end
    if not axe then
        local equipaxe = Items.FindByName('Hatchet')
        if equipaxe then
            Player.Equip(equipaxe.Serial)
            Pause(1000)
            for _, layer in ipairs({1, 2}) do
                local checkAxe = Items.FindByLayer(layer)
                if checkAxe and string.find(string.lower(checkAxe.Name or ""), "hatchet") then
                    axe = checkAxe
                    break
                end
            end
        end
    end
    if not axe then
        Messages.Print("No hatchet found.")
        return nil
    end
    return axe
end

function GetLogs()
    local itemList = Items.FindByFilter({})
    for _, item in ipairs(itemList) do
        if item and item.RootContainer == Player.Serial and item.Graphic == ITEM_ID_WOODEN_LOGS then
            return item
        end
    end
    return nil
end

function CreateBoards(hatchet)
    local log = GetLogs()
    if hatchet and log then
        Messages.Print("Chopping boards!")
        Player.UseObject(hatchet.Serial)
        if Targeting.WaitForTarget(1000) then
            Targeting.Target(log.Serial)
            Pause(1000)
        else
            Messages.Print("Failed to target log for boards.")
        end
    elseif not hatchet then
        Messages.Print("No hatchet to make boards.")
    elseif not log then
        Messages.Print("No logs to make boards.")
    end
end

function CheckTreeStatus()
    local noWoodMessages = {
        "There is no wood here to chop.",
        "You cannot see that.",
        "That is too far away.",
        "You can't use an axe on that.",
        "You cannot reach that.",
        "You have worn out your tool!",
        "There's not enough wood here to harvest."
    }
    for _, msg in ipairs(noWoodMessages) do
        if Journal.Contains(msg) then
            Journal.Clear()
            return true
        end
    end
    return false
end

function ChopTree(hatchetSerial)
    Messages.Print("Chopping tree...")
    local treeIsEmpty = false
    while not treeIsEmpty and Player.Weight <= Player.MaxWeight - MAX_WEIGHT_DIFF do
        Player.UseObject(hatchetSerial)
        Pause(1500)
        Targeting.TargetLast()
        Pause(2000)
        treeIsEmpty = CheckTreeStatus()
    end
    if Player.Weight > Player.MaxWeight - MAX_WEIGHT_DIFF then
        Messages.Print("Overweight!")
        return true
    end
    return false
end

function Main()
    Journal.Clear()
    local needNewTree = true

    while true do
        local hatchet = GetHatchet()  -- Get hatchet at the beginning of each loop
        if not hatchet then
            Messages.Print("Could not find/equip a hatchet. Stopping.")
            return
        end

        if Player.Weight > MAX_WEIGHT - MAX_WEIGHT_DIFF then
            Messages.Print("This shit is getting heavy...")
            CreateBoards(hatchet)
            if Player.Weight > MAX_WEIGHT - MAX_WEIGHT_DIFF then
                Messages.Print("Still too heavy, stopping.")
                return
            end
            needNewTree = true
        end

        Player.UseObject(hatchet.Serial)

        if Targeting.WaitForTarget(1000) then
            if needNewTree then
                Messages.Print("Select a tree")
                needNewTree = false
                Pause(2000)
            else
                Targeting.TargetLast()
            end
        else
            Messages.Print("Targeting failed, trying again...")
            Pause(1000)
            goto continue_loop
        end

        Pause(2000)

        if CheckTreeStatus() then
            Messages.Print("Need a new tree!")
            needNewTree = true
            Journal.Clear()
        end

        ::continue_loop::
        Pause(500)
    end
end

Main()