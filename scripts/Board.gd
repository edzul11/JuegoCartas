extends Node
class_name Board

var monster_slots: Array = []
var spell_slots: Array = []

func _init():
	# Two players: index 0 player, 1 AI
	monster_slots = [[], []]
	spell_slots = [[], []]
	for i in range(3):
		monster_slots[0].append(Slot.new("monster"))
		monster_slots[1].append(Slot.new("monster"))
		spell_slots[0].append(Slot.new("spell"))
		spell_slots[1].append(Slot.new("spell"))

func get_monster_slot(player_index: int, column: int) -> Slot:
	return monster_slots[player_index][column]

func get_spell_slot(player_index: int, column: int) -> Slot:
	return spell_slots[player_index][column]

func get_free_slot(player_index: int, type: String) -> Slot:
	var arr: Array
	if type == "monster":
		arr = monster_slots[player_index]
	else:
		arr = spell_slots[player_index]
	for s in arr:
		if s.is_empty():
			return s
	return null
