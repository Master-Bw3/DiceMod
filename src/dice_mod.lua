assert(SMODS.load_file('src/dice.lua'))()


if not DICEMOD then DICEMOD = {} end


SMODS.Atlas({
    key = "Dice",
    path = "dice.png",
    px = 71,
    py = 95
}):register()

function DICEMOD:set_up_ui()

    self.dice_tray = CardArea(
        0, 0,
        6 * G.CARD_W, 0.95 * G.CARD_H,
        { card_limit = G.GAME.starting_params.hand_size, type = 'hand' }
    )
end

function DICEMOD:set_screen_positions()

    self.dice_tray.T.x = G.TILE_W - self.dice_tray.T.w - 2.85
    self.dice_tray.T.y = G.TILE_H - self.dice_tray.T.h - 5.5
    self.dice_tray:hard_set_VT()
end

SMODS.Keybind({
    key_pressed = "i",
    action = function(e)
        print("i pressed")
        if (G.STATE == G.STATES.SELECTING_HAND) then

            local dice = Card(DICEMOD.dice_tray.T.x, DICEMOD.dice_tray.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, Dice.ONE)

            DICEMOD.dice_tray:emplace(dice)
        end
    end
})
