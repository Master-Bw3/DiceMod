DiceAbility = {}

SMODS.DrawStep({
    key = "dice_ability", 
    order = -11, 
    func = function (self)
        if (self.diceAbility) then

            self.diceAbility.sprite:draw_shader('dissolve', nil, nil, nil, self.children.center, 0, 0, -0.35*self.T.w, 0)

            for i, v in ipairs(self.diceAbility.dice) do
                v.sprite:draw_shader('dissolve', nil, nil, nil, self.children.center, -0.4, 0, -0.55*self.T.w, 0.3 + (i-1)*0.5)
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

function DiceAbility.add_to_card(card, abilty)
    card.diceAbility = abilty;
    card.diceAbility.sprite = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[abilty.atlas], abilty.pos)
    card.diceAbility.sprite:set_role({major = card, role_type = 'Minor', draw_major = card})
    card.diceAbility.dice = {}


    return card
end