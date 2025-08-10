extends Node
class_name Player

var game
var index: int = 0
var deck: Array = []
var hand: Hand = Hand.new()
var board: Board
var hp: int = 20
var max_energy: int = 0
var energy: int = 0

func _init(_game, _deck: Array, _board: Board, _index: int):
	game = _game
	deck = _deck
	board = _board
	index = _index

func draw(n: int = 1):
	for i in range(n):
		if deck.is_empty():
			break
		var id = deck.pop_front()
		var card = game.create_card(id)
		hand.add_card(card)

func play_card(card: CardModel, slot: Slot, opponent) -> bool:
	if card.cost > energy:
		return false
	if not slot.is_empty():
		return false
	energy -= card.cost
	hand.remove_card(card)
	slot.card = card
	card.trigger("on_play", {"player": self, "opponent": opponent, "slot": slot, "self": card})
	if card.type == "spell":
		slot.card = null
	return true

func take_damage(amount: int):
	hp -= amount
	game.check_game_over()

func perform_battle_phase(game):
	for i in range(3):
		var slot = board.get_monster_slot(index, i)
		var card = slot.card
		if card:
			var opp_slot = board.get_monster_slot(1 - index, i)
			if opp_slot.card:
				card.attack(opp_slot.card, game.players[1 - index])
				if opp_slot.card.def <= 0:
					opp_slot.card = null
			else:
				game.players[1 - index].take_damage(card.atk)
