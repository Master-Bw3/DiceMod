function DiceTray(cardarea) 

    cardarea.align_cards = function(self)
        local dice = self.cards
        for k, die in ipairs(dice) do
            if not die.states.drag.is then 
                die.T.r = (G.SETTINGS.reduced_motion and 0 or 1)*0.02*math.sin(2*G.TIMERS.REAL+die.T.y)
                local max_dice = math.max(#dice, self.config.temp_limit)
                die.T.y = self.T.y + (self.T.h-Dice.width())*((k-1)/math.max(max_dice-1, 1) - 0.5*(#dice-max_dice)/math.max(max_dice-1, 1)) + 0.5*(Dice.width() - die.T.h)

                local highlight_height = G.HIGHLIGHT_H / 2
                if not die.highlighted then highlight_height = 0 end
                die.T.x = self.T.x + self.T.w/2 - die.T.w/2 - highlight_height
                die.T.y = die.T.y + die.shadow_parrallax.y/30
            end
        end
        table.sort(dice, function (a, b) return a.T.y + a.T.h/2 < b.T.y + b.T.h/2 end)
    end


    cardarea.move = function(self, dt)
        local desired_x =G.TILE_W - DICEMOD.dice_tray.T.w - 0.2 + 2*((not G.deck_preview and (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.DRAW_TO_HAND)) and 0 or 1)
        cardarea.T.x = 15*G.real_dt*desired_x + (1-15*G.real_dt)*cardarea.T.x
        if math.abs(desired_x - cardarea.T.x) < 0.01 then cardarea.T.x = desired_x end
        if G.STATE == G.STATES.TUTORIAL then 
            G.play.T.x = cardarea.T.x - (3 + 0.6)
        end
        Moveable.move(self, dt)
        self:align_cards()
    end

    return cardarea
end

