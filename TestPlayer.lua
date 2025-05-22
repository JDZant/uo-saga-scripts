-- TestPlayer.lua
    -- The line below is for external linters; it doesn't define Player in-game.
    -- Player = Player or {} 

    print("Test Script: Starting test...")

    if Player then
        print("Test Script: Player object exists. Type: " .. type(Player))

        if Player.Serial then
            print("Test Script: Player.Serial exists. Value: " .. tostring(Player.Serial))

            -- Check if HeadMsg exists before calling
            if Player.HeadMsg then
                Player.HeadMsg("Player.HeadMsg IS available. Serial: " .. Player.Serial, Player.Serial, 188)
                print("Test Script: Player.HeadMsg was called.")
            else
                print("Test Script: Player.HeadMsg IS NIL (not available).")
                -- Try Player.Say as an alternative
                if Player.Say then
                    Player.Say("Player.HeadMsg is nil, but Player.Say works! Serial: " .. Player.Serial)
                    print("Test Script: Player.Say was called as an alternative.")
                else
                    print("Test Script: Player.Say IS ALSO NIL.")
                end
            end
        else
            print("Test Script: Player.Serial IS NIL.")
            if type(Player) == "table" and Player.Say then
                Player.Say("Player object exists, but Player.Serial is nil.")
            end
        end
    else
        -- This case should be very unusual if the script is run normally in-game.
        -- We can't use Player.HeadMsg if Player is nil, so we try a raw print.
        print("CRITICAL TEST SCRIPT: Player object itself IS NIL.")
        -- As a fallback, try to use a global function that might indicate if the scripting environment is up.
        Pause(100) 
        print("Test Script: Pause function was callable (Player was nil).")
    end

    -- Dummy Main function if your environment requires it, 
    -- but the core test logic is in the global scope to run immediately.
    function Main()
        print("TestPlayer.lua Main() called.")
    end

    Main() 