extends "res://scripts/CardModel.gd"
class_name MonsterCardModel

func attack(target, opponent):
	trigger("on_attack", {"self": self, "target": target, "opponent": opponent})
	if target:
		target.receive_damage(atk, opponent)
	else:
		opponent.take_damage(atk)

func receive_damage(amount: int, opponent):
	def -= amount
	trigger("on_receive_attack", {"self": self, "amount": amount, "opponent": opponent})
	if def <= 0:
		trigger("on_destroy", {"self": self, "opponent": opponent})
		return true
	return false
