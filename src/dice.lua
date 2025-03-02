Dice = {}

function Dice.width()
    return G.CARD_W / 2
end

Dice.ONE = {
    order = 0,
    unlocked = true,
    start_alerted = true,
    available = true,
    discovered = true,
    name = "One",
    pos = { x = 0, y = 0 },
    set = "Dice",
    config = {},
    key = "one",
    atlas = "dicy_Dice",
}

G.FUNCS.use_die = function(e, mute, nosave)
    print("hey there")
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

function Die(card)
    card.highlight = function(self, is_higlighted)
        Card.highlight(self, is_higlighted)

        self.children.use_button = UIBox {
            definition = { n = G.UIT.C, config = { align = "cr" }, nodes = {

                { n = G.UIT.C, config = { ref_table = card, align = "cr", maxw = 1.25, padding = 0.1, r = 0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_die', func = 'can_use_die' }, nodes = {
                    { n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
                    { n = G.UIT.T, config = { text = localize('b_use'), colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true } }
                } }
            } },

            config = { align = "cr",
                offset = { x = -0.4, y = 0 },
                parent = self }
        }
    end

    card.can_use_die = function(self)
        return true
    end

    return card
end
