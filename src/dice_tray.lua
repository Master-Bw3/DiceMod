function DiceTray(cardarea) 

    cardarea.align_cards = function(self)
        local dice = self.cards
        for k, die in ipairs(dice) do
            if not die.states.drag.is then 
                die.T.r = (G.SETTINGS.reduced_motion and 0 or 1)*0.02*math.sin(2*G.TIMERS.REAL+die.T.x)
                local max_dice = math.max(#dice, self.config.temp_limit)
                die.T.x = self.T.x + (self.T.w-Dice.width())*((k-1)/math.max(max_dice-1, 1) - 0.5*(#dice-max_dice)/math.max(max_dice-1, 1)) + 0.5*(Dice.width() - die.T.h)

                local highlight_height = G.HIGHLIGHT_H / 2
                if not die.highlighted then highlight_height = 0 end
                die.T.y = self.T.y + self.T.h/2 - die.T.h/2 - highlight_height
                die.T.x = die.T.x + die.shadow_parrallax.x/30
            end
        end
        table.sort(dice, function (a, b) return a.T.x + a.T.w/2 < b.T.x + b.T.w/2 end)
    end


    cardarea.move = function(self, dt)
        local desired_y = G.TILE_H - self.T.h + 2.5*((not G.deck_preview and (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.DRAW_TO_HAND)) and 0 or 1)

        self.T.y = 15*G.real_dt*desired_y + (1-15*G.real_dt) * self.T.y
        if math.abs(desired_y - self.T.y) < 0.01 then self.T.y = desired_y end
        if G.STATE == G.STATES.TUTORIAL then 
            G.play= cardarea- (3 + 0.6)
        end
        Moveable.move(self, dt)
        self:align_cards()
    end

    cardarea.load = function(self, values)

        for i, v in ipairs(values) do
            local die = Die(v)
            self:emplace(die)
        end
    end

    cardarea.save = function(self)
        if not self.cards then return end
     
    
        local values = {}
        for i, v in ipairs(self.cards) do
            values[i] = v.config.center.dice_value
        end

        return values
    end


    return cardarea
end

