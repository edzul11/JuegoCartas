extends "res://scripts/CardModel.gd"
class_name SpellCardModel

func resolve(player, opponent, slot):
	trigger("on_play", {"player": player, "opponent": opponent, "slot": slot, "self": self})
