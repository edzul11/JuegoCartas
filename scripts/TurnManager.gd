extends Node
class_name TurnManager

var phases = ["DRAW", "MAIN", "BATTLE", "END"]
var current_phase_index: int = 0
var current_player_index: int = 0
var game

func _init(_game):
	game = _game

func start_turn():
	current_phase_index = 0
	var player = game.players[current_player_index]
	player.max_energy = min(player.max_energy + 1, 10)
	player.energy = player.max_energy
	player.draw(1)
	game.update_ui()

func next_phase():
	if current_phase_index < phases.size() - 1:
		current_phase_index += 1
	game.update_ui()

func end_turn():
	current_phase_index = 0
	current_player_index = (current_player_index + 1) % game.players.size()
	start_turn()

func get_phase() -> String:
	return phases[current_phase_index]
