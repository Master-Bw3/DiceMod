DiceAbility = {}


SMODS.DrawStep({
    key = "dice_ability", 
    order = 10, 
    func = function (self)
        if (self.diceAbility) then
            self.diceAbility.sprite:draw_shader('dissolve', nil, nil, nil, self.children.center)

            for i, v in ipairs(self.diceAbility.dice) do
                v.sprite:draw_shader('dissolve', nil, nil, nil, self.children.center, 0, 0, 0, 0)
            end

        end
    end,
    conditions = { vortex = false, facing = 'front' },
})

DiceAbility.PLACEMENT_MAP = {
    [1] = {1},
    [2] = {0, 2},
    [3] = {0, 1, 2}
}

function DiceAbility.add_to_card(card, ability)
    card.diceAbility = {
        slot_count = ability.slot_count,
        sprite = Sprite(card.T.x, card.T.y, card.T.w / 2, card.T.h, G.ASSET_ATLAS[ability.atlas], ability.pos),
        dice = {},
        conditions_met = ability.conditions_met,
        apply_ability = ability.apply_ability
    } 
    card.diceAbility.sprite:set_role({major = card, role_type = 'Minor', draw_major = card})
 
    return card
end

--- Abilities ---


DiceAbility.CHIPS = {
    name = "Chips",
    pos = { x = 0, y = 0 },
    atlas = "dicy_DiceAbilities",
    slot_count = 3,
    conditions_met = function(self)
        return self.dice and (#self.dice == self.slot_count)
    end,
    apply_ability = function(self, ret) 
        if not ret.playing_card.chips then ret.playing_card.chips = 0 end
        for i, die in ipairs(self.dice) do
            ret.playing_card.chips = ret.playing_card.chips + die.value
        end
    end
}

DiceAbility.ILLUMINATE = {
    name = "Illuminate",
    pos = { x = 1, y = 0 },
    atlas = "dicy_DiceAbilities",
    slot_count = 1,
    conditions_met = function(self)
        return self.dice and (#self.dice == self.slot_count)
    end,
    apply_ability = function(self, ret) 
        if not G.GAME.current_round.extra_dice then G.GAME.current_round.extra_dice = {} end
        table.insert(G.GAME.current_round.extra_dice, self.dice[1].value)
        table.insert(G.GAME.current_round.extra_dice, self.dice[1].value)
    end
}