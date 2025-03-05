DiceAbility = {}

SMODS.DrawStep({
    key = "dice_ability", 
    order = -11, 
    func = function (self)
        if (self.diceAbility) then

            self.diceAbility.sprite:draw_shader('dissolve', nil, nil, nil, self.children.center, 0, 0, -0.35*self.T.w, 0);
        end
    end,
    conditions = { vortex = false, facing = 'front' },
})

DiceAbility.ONE = {
    name = "One",
    pos = { x = 0, y = 0 },
    atlas = "dicy_DiceAbilities",

}

function DiceAbility.add_to_card(card, abilty)
    card.diceAbility = abilty;
    card.diceAbility.sprite = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[abilty.atlas], abilty.pos)
    card.diceAbility.sprite:set_role({major = card, role_type = 'Glued', draw_major = card})

    return card
end