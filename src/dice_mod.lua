assert(SMODS.load_file('src/dice.lua'))()
assert(SMODS.load_file('src/dice_tray.lua'))()
assert(SMODS.load_file('src/dice_ability.lua'))()


if not DICEMOD then DICEMOD = {} end


SMODS.Atlas({
    key = "Dice",
    path = "dice.png",
    px = 31,
    py = 31
}):register()

SMODS.Atlas({
    key = "DiceAbilities",
    path = "dice_abilities.png",
    px = 71,
    py = 95
}):register()



function DICEMOD:set_up_ui()
    self.dice_tray = DiceTray(CardArea(
        0, 0,
        0.95 * (Dice.width()), 4 * (Dice.width()),
        { card_limit = 4, type = 'joker' }
    ))
end

function DICEMOD:set_screen_positions()
    self.dice_tray.T.x = G.TILE_W - self.dice_tray.T.w - 0.2
    self.dice_tray.T.y = G.TILE_H - self.dice_tray.T.h - 4
    self.dice_tray:hard_set_VT()
end

SMODS.Keybind({
    key_pressed = "i",
    action = function(e)
        print("i pressed")
        if (G.STATE == G.STATES.SELECTING_HAND) then
            local dice = Die(Card(DICEMOD.dice_tray.T.x, DICEMOD.dice_tray.T.y, Dice.width(), Dice.width(), G.P_CARDS.empty, Dice.ONE))
            print(dice.ability.consumeable)

            DICEMOD.dice_tray:emplace(dice)
        end
    end
})

SMODS.Keybind({
    key_pressed = "o",
    action = function(e)
        print("o pressed")
        if (G.STATE == G.STATES.SELECTING_HAND) then
            local card = G.hand.cards[1]

            DiceAbility.add_to_card(card, DiceAbility.ONE)
        end
    end
})

SMODS.Keybind({
    key_pressed = "m",
    action = SMODS.restart_game
})
