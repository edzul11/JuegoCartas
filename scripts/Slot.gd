extends RefCounted
class_name Slot

var type: String
var card: CardModel = null

func _init(_type: String):
	type = _type

func is_empty() -> bool:
	return card == null
