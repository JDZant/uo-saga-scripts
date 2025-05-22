-- TestTargeting.lua
Player = Player or {}
Targeting = Targeting or {}

function Main()
    local targetedObjectsInfo = {}
    Player.Say("Starting target collection script.")

    while true do
        Player.Say("Select a tree/object, or target yourself to finish.")
        
        if Targeting.WaitForTarget(60000) then -- 60 second timeout
            local targetInfo = Targeting.GetTarget()

            if targetInfo and targetInfo.Serial then
                if targetInfo.Serial == Player.Serial then
                    Player.Say("Targeting self. Collection complete.")
                    break
                else
                    local entry = {
                        Serial = targetInfo.Serial,
                        Graphic = targetInfo.Graphic,
                        X = targetInfo.X,
                        Y = targetInfo.Y,
                        Z = targetInfo.Z
                    }
                    table.insert(targetedObjectsInfo, entry)
                    Player.Say(string.format("Target acquired: Serial 0x%X", targetInfo.Serial))
                    Targeting.ClearLast() -- Clear the target so it's fresh for next prompt
                end
            else
                Player.Say("Failed to get target information. Please try again.")
            end
        else
            Player.Say("Targeting timed out. Collection stopped.")
            break
        end
        Pause(200) -- Brief pause to allow game client to catch up
    end

    print("--- Collected Target Information ---")
    if #targetedObjectsInfo == 0 then
        print("No targets were selected.")
    else
        for i, info in ipairs(targetedObjectsInfo) do
            print(string.format("Target %d: Serial=0x%X, Graphic=0x%X, X=%d, Y=%d, Z=%d",
                i, info.Serial, info.Graphic, info.X, info.Y, info.Z))
        end
    end
    print("--- End of List ---")

    if Targeting.WaitForTarget(2000) then
        Targeting.TargetLast()
    end

    local treeGraphics = {
        0x0CCA, 0x0CCB, 0x0CCC, 0x0CCD, 0x0CCE, 0x0CCF, 0x0CD0, 0x0CD1, 0x0CD2, 0x0CD3, 0x0CD4, 0x0CD5, 0x0CD6, 0x0CD7, 0x0CD8, 0x0CD9, 0x0CDA, 0x0CDB, 0x0CDC, 0x0CDD, 0x0CDE, 0x0CDF, 0x0CE0, 0x0CE1, 0x0CE2, 0x0CE3, 0x0CE4, 0x0CE5, 0x0CE6, 0x0CE7, 0x0CE8, 0x0CE9, 0x0CEA, 0x0CEB, 0x0CEC, 0x0CED, 0x0CEE, 0x0CEF, 0x0CF0, 0x0CF1, 0x0CF2, 0x0CF3, 0x0CF4, 0x0CF5, 0x0CF6, 0x0CF7, 0x0CF8, 0x0CF9, 0x0CFA, 0x0CFB, 0x0CFC, 0x0CFD, 0x0CFE, 0x0CFF
        -- ... add all tree graphic IDs you want to search for
    }
    local filter = {onground=true, rangemax=10, graphics=treeGraphics}
    local trees = Items.FindByFilter(filter)
    for i, tree in ipairs(trees) do
        print(string.format("Tree %d: Serial=0x%X, X=%d, Y=%d, Z=%d", i, tree.Serial, tree.X, tree.Y, tree.Z))
    end
end

Main() 