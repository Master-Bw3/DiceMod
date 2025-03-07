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

SMODS.Atlas({
    key = "DiceOnCards",
    path = "dice_on_cards.png",
    px = 71,
    py = 95
}):register()

function DICEMOD:set_up_ui()
    self.dice_tray = DiceTray(CardArea(
        0, 0,
        4 * (Dice.width()), 0.95 * (Dice.width()),
        { card_limit = 4, type = 'joker' }
    ))
    -- for saving / loading to work
    G.dice_tray = self.dice_tray
end

local ssp = set_screen_positions
function set_screen_positions()
    ssp()
    if G.STAGE == G.STAGES.RUN then
        G.deck.T.y = G.TILE_H - G.deck.T.h - 1.8
        G.deck.T.x = G.TILE_W - G.deck.T.w

        DICEMOD.dice_tray.T.x = G.TILE_W - DICEMOD.dice_tray.T.w
        DICEMOD.dice_tray.T.y = G.TILE_H - DICEMOD.dice_tray.T.h
        DICEMOD.dice_tray:hard_set_VT()
    end
end


SMODS.Keybind({
    key_pressed = "i",
    action = function(e)
        print("i pressed")
        if (G.STATE == G.STATES.SELECTING_HAND) then
            local dice = Die(math.random(1, 6))
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

            DiceAbility.add_to_card(card, DiceAbility.ILLUMINATE)
        end
    end
})

SMODS.Keybind({
    key_pressed = "m",
    action = SMODS.restart_game
})


local function reroll_dice()
    remove_all(DICEMOD.dice_tray.cards)

    local i = 0
    while (i < DICEMOD.dice_tray.config.card_limit) do
        local die = Die(math.random(1, 6))
        DICEMOD.dice_tray:emplace(die)


        i = i + 1
    end

    if G.GAME.current_round.extra_dice then
        for i, value in ipairs(G.GAME.current_round.extra_dice) do
            local die = Die(value)
            DICEMOD.dice_tray:emplace(die)
        end
        G.GAME.current_round.extra_dice = nil
    end

    for i, card in ipairs(G.hand.cards) do
        if (card.diceAbility) then
            card.diceAbility.dice = {}
        end
    end
end



local fn = Game.update_draw_to_hand
Game.update_draw_to_hand = function(self, dt)
	fn(self, dt)

	if not G.GAME.current_round.rolled_dice then reroll_dice() end
    G.GAME.current_round.rolled_dice = true;
end

local fn2 = Game.update_hand_played
Game.update_hand_played = function(self, dt)
	fn2(self, dt)
    
    G.GAME.current_round.rolled_dice = false;
end

-- local fn1 = new_round
-- new_round = function(e)
-- 	fn1()
	
--     reroll_dice()
-- end

local ec = eval_card
function eval_card(card, context) 
    local ret = ec(card, context)


    if context.cardarea == G.play and context.main_scoring and card.diceAbility and card.diceAbility:conditions_met() then
        print("hey")
        card.diceAbility:apply_ability(ret)
    end

    return ret
end