extends Node
class_name Hand

var cards: Array = []

func add_card(card: CardModel) -> bool:
	if cards.size() >= 7:
		return false
	cards.append(card)
	return true

func remove_card(card: CardModel):
	cards.erase(card)
