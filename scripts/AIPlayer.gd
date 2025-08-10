extends "res://scripts/Player.gd"
class_name AIPlayer

func perform_main_phase(game):
	for card in hand.cards.duplicate():
		if card.cost <= energy:
			var slot = board.get_free_slot(index, card.type)
			if slot:
				play_card(card, slot, game.players[0])

func perform_battle_phase(game):
	for i in range(3):
		var slot = board.get_monster_slot(index, i)
		var card = slot.card
		if card:
			var opp_slot = board.get_monster_slot(1 - index, i)
			if opp_slot.card:
				card.attack(opp_slot.card, game.players[0])
				if opp_slot.card.def <= 0:
					opp_slot.card = null
			else:
				game.players[0].take_damage(card.atk)
