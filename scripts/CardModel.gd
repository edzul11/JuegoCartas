extends Resource
class_name CardModel

var id: String = ""
var name: String = ""
var type: String = "monster"
var cost: int = 0
var atk: int = 0
var def: int = 0
var effects: Array = []

func from_dict(data: Dictionary) -> CardModel:
	id = data.get("id", "")
	name = data.get("name", "")
	type = data.get("type", "monster")
	cost = data.get("cost", 0)
	atk = data.get("atk", 0)
	def = data.get("def", 0)
	effects = data.get("effects", [])
	return self

func trigger(event_name: String, ctx: Dictionary):
	for eff in effects:
		if eff.get("trigger") == event_name:
			EffectSystem.apply_effect(self, eff, ctx)
