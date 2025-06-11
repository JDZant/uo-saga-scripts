local knife = Items.FindByName('Butcher Knife')

function equipKnife()
    Player.Equip(knife.Serial)
    pause(100)
end