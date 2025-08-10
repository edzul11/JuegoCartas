extends Node
class_name EffectSystem

static func apply_effect(card, eff: Dictionary, ctx: Dictionary):
	var effect = eff.get("effect")
	var value = eff.get("value", 0)
	match effect:
		"buff_self_atk":
			card.atk += value
		"heal_self_def":
			card.def += value
		"deal_damage_player":
			var target = ctx.get("opponent")
			if target:
				target.take_damage(value)
		"draw_cards":
			var player = ctx.get("player")
			if player:
				player.draw(value)
