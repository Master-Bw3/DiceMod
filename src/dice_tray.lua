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

    return cardarea
end

