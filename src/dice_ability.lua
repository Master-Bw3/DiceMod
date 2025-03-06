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

DiceAbility.ONE = {
    name = "One",
    pos = { x = 0, y = 0 },
    atlas = "dicy_DiceAbilities",
    slot_count = 3
}

DiceAbility.PLACEMENT_MAP = {
    [1] = {1},
    [2] = {0, 2},
    [3] = {0, 1, 2}
}

function DiceAbility.add_to_card(card, ability)
    card.diceAbility = {
        slot_count = ability.slot_count,
        sprite = Sprite(card.T.x, card.T.y, card.T.w / 2, card.T.h, G.ASSET_ATLAS[ability.atlas], ability.pos),
        dice = {}
    } 
    card.diceAbility.sprite:set_role({major = card, role_type = 'Minor', draw_major = card})
 
    return card
end