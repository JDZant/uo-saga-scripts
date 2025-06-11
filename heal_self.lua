local bandage = Items.FindByType(0x0E21)
if bandage then
    Player.UseObject(bandage.Serial)
    Targeting.WaitForTarget(2000)
    Targeting.TargetSelf()
    return true
end