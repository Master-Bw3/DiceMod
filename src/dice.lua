Dice = {}

function Dice.width()
    return G.CARD_W / 2
end


Dice.NAMES = {
    "One", "Two", "Three", "Four", "Five", "Six"
}

local i = 1
while i <= 6 do
    G.P_CENTERS["d_"..string.lower(Dice.NAMES[i])] = {
        order = i - 1,
        unlocked = true,
        start_alerted = true,
        available = true,
        discovered = true,
        pos = { x = i - 1, y = 0 },
        set = "Dice",
        config = {},
        atlas = "dicy_Dice",
        name = Dice.NAMES[i],
        key = "d_"..string.lower(Dice.NAMES[i]),
        dice_value = i
    }
    i = i + 1
end


G.FUNCS.use_die = function(e, mute, nosave)
    e.config.ref_table:use_die()
end

G.FUNCS.can_use_die = function(e, mute, nosave)
    if e.config.ref_table:can_use_die() then 
        e.config.colour = G.C.RED
        e.config.button = 'use_die'
    else
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
    end
end

function Die(value)

    local center = G.P_CENTERS["d_"..string.lower(Dice.NAMES[value])]

    local card = Card(DICEMOD.dice_tray.T.x, DICEMOD.dice_tray.T.y, Dice.width(), Dice.width(), G.P_CARDS.empty, center)

    card.highlight = function(self, is_higlighted)
        Card.highlight(self, is_higlighted)

        self.children.use_button = UIBox {
            definition = { n = G.UIT.C, config = { align = "cm" }, nodes = {

                { n = G.UIT.C, config = { ref_table = card, align = "cm", padding = 0.1, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_die', func = 'can_use_die' }, nodes = {
                    { n = G.UIT.T, config = { text = localize('b_use'), colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true } }
                } }
            } },

            config = { align = "bm",
                offset = { x = 0, y = 0 },
                parent = self }
        }
    end

    card.can_use_die = function(self)
        if #G.hand.highlighted == 1 then
            local card = G.hand.highlighted[1]
            if (card.diceAbility) then
                return #card.diceAbility.dice < card.diceAbility.slot_count
            end
        end
        
        return false
    end


    card.use_die = function(self)
        self:start_dissolve()

        local card = G.hand.highlighted[1]


        local sprite = Sprite(
            card.T.x,
            card.T.y, 
            Dice.width(), 
            Dice.width(), 
            G.ASSET_ATLAS["dicy_DiceOnCards"], 
            {x = self.config.center.dice_value - 1, y = DiceAbility.PLACEMENT_MAP[card.diceAbility.slot_count][#card.diceAbility.dice + 1]}
            )

        sprite:set_role({major = card, role_type = 'Minor', draw_major = card})

        table.insert(card.diceAbility.dice, {value = self.config.center.dice_value, sprite = sprite})
    end


    return card
end
