-- Configuration
local MAX_WEIGHT_DIFF = 10
local MAX_WEIGHT = 306
local ITEM_ID_WOODEN_LOGS = 0x1BDD -- For log identification
local STUMP_GRAPHICS = {0x0CCA, 0x0CCB, 0x0CCC, 0x0CCD, 0x0CCE, 0x0CCF, 0x0CD0, 0x0CD1, 0x0CD2, 0x0CD3, 0x0CD4, 0x0CD5, 0x0CD6, 0x0CD7, 0x0CD8, 0x0CD9, 0x0CDA, 0x0CDB, 0x0CDC, 0x0CDD, 0x0CDE, 0x0CDF, 0x0CE0, 0x0CE1, 0x0CE2, 0x0CE3, 0x0CE4, 0x0CE5, 0x0CE6, 0x0CE7, 0x0CE8, 0x0CE9, 0x0CEA, 0x0CEB, 0x0CEC, 0x0CED, 0x0CEE, 0x0CEF, 0x0CF0, 0x0CF1, 0x0CF2, 0x0CF3, 0x0CF4, 0x0CF5, 0x0CF6, 0x0CF7, 0x0CF8, 0x0CF9, 0x0CFA, 0x0CFB, 0x0CFC, 0x0CFD, 0x0CFE, 0x0CFF}

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
        Player.Say("No hatchet found.")
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
        Player.Say("Chopping boards!")
        Player.UseObject(hatchet.Serial)
        if Targeting.WaitForTarget(1000) then
            Targeting.Target(log.Serial)
            Pause(1000)
        else
            Player.Say("Failed to target log for boards.")
        end
    elseif not hatchet then
        Player.Say("No hatchet to make boards.")
    elseif not log then
        Player.Say("No logs to make boards.")
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
    Player.Say("Chopping tree...")
    local treeIsEmpty = false
    while not treeIsEmpty and Player.Weight <= Player.MaxWeight - MAX_WEIGHT_DIFF do
        Player.UseObject(hatchetSerial)
        Pause(1500)
        Targeting.TargetLast()
        Pause(2000)
        treeIsEmpty = CheckTreeStatus()
    end
    if Player.Weight > Player.MaxWeight - MAX_WEIGHT_DIFF then
        Player.Say("Overweight!")
        return true
    end
    return false
end

function ScanForTrees(range)
    Player.Say("Scanning for stumps...")
    local filter = {onground=true, rangemax=range or 10, graphics=STUMP_GRAPHICS}
    local trees = Items.FindByFilter(filter)
    return trees or {}
end

function Main()
    Journal.Clear()
    local trees = ScanForTrees(10)
    print(trees)
    local needNewTree = true

    while true do
        local hatchet = GetHatchet()  -- Get hatchet at the beginning of each loop
        if not hatchet then
            Player.Say("Could not find/equip a hatchet. Stopping.")
            return
        end

        if Player.Weight > MAX_WEIGHT - MAX_WEIGHT_DIFF then
            CreateBoards(hatchet)
            if Player.Weight > MAX_WEIGHT - MAX_WEIGHT_DIFF then
                Player.Say("To heavy")
                return
            end
            needNewTree = true
        end

        Player.UseObject(hatchet.Serial)

        if Targeting.WaitForTarget(1000) then
            if needNewTree then
                Player.Say("Select a tree")
                needNewTree = false
                Pause(2000)
            else
                Targeting.TargetLast()
            end
        else
            Player.Say("Targeting failed, trying again...")
            Pause(1000)
            goto continue_loop
        end

        Pause(2000)

        if CheckTreeStatus() then
            Player.Say("Need a new tree!")
            needNewTree = true
            Journal.Clear()
        end

        ::continue_loop::
        Pause(500)
    end
end

Main()