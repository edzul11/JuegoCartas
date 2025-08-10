extends Node
class_name Game

var card_definitions: Dictionary = {}
var players: Array = []
var board: Board
var turn_manager: TurnManager
var game_over: bool = false

# UI nodes
var phase_label
var energy_label
var hp_label_player
var hp_label_ai
var winner_label
var hand_container
var board_monsters_player_container
var board_spells_player_container
var board_monsters_ai_container
var board_spells_ai_container
var next_button
var end_button

func _ready():
	load_cards()
	setup_game()
	build_ui()
	turn_manager.start_turn()
	refresh_all()

func load_cards():
	var file = FileAccess.open("res://data/cards.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	for d in data:
		card_definitions[d.id] = d

func create_card(id: String) -> CardModel:
	var data = card_definitions[id]
	var card
	if data.type == "monster":
		card = MonsterCardModel.new()
	else:
		card = SpellCardModel.new()
	card.from_dict(data.duplicate())
	return card

func load_deck(path: String) -> Array:
	var file = FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	return data

func setup_game():
	board = Board.new()
	var deck_player = load_deck("res://data/deck_player.json")
	var deck_ai = load_deck("res://data/deck_ai.json")
	var player = Player.new(self, deck_player, board, 0)
	var ai = AIPlayer.new(self, deck_ai, board, 1)
	players = [player, ai]
	turn_manager = TurnManager.new(self)

func build_ui():
	var ui = Control.new()
	ui.custom_minimum_size = Vector2(800, 600)
	add_child(ui)
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	ui.add_child(vbox)
	phase_label = Label.new()
	vbox.add_child(phase_label)
	energy_label = Label.new()
	vbox.add_child(energy_label)
	var hp_box = HBoxContainer.new()
	vbox.add_child(hp_box)
	hp_label_player = Label.new()
	hp_box.add_child(hp_label_player)
	hp_label_ai = Label.new()
	hp_box.add_child(hp_label_ai)
	winner_label = Label.new()
	vbox.add_child(winner_label)
	var board_box = VBoxContainer.new()
	board_box.custom_minimum_size = Vector2(720, 360)
	board_box.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(board_box)
	board_monsters_ai_container = HBoxContainer.new()
	board_monsters_ai_container.alignment = BoxContainer.ALIGNMENT_CENTER
	board_monsters_ai_container.custom_minimum_size = Vector2(720, 160)
	board_box.add_child(board_monsters_ai_container)
	board_spells_ai_container = HBoxContainer.new()
	board_spells_ai_container.alignment = BoxContainer.ALIGNMENT_CENTER
	board_spells_ai_container.custom_minimum_size = Vector2(720, 160)
	board_box.add_child(board_spells_ai_container)
	board_spells_player_container = HBoxContainer.new()
	board_spells_player_container.alignment = BoxContainer.ALIGNMENT_CENTER
	board_spells_player_container.custom_minimum_size = Vector2(720, 160)
	board_box.add_child(board_spells_player_container)
	board_monsters_player_container = HBoxContainer.new()
	board_monsters_player_container.alignment = BoxContainer.ALIGNMENT_CENTER
	board_monsters_player_container.custom_minimum_size = Vector2(720, 160)
	board_box.add_child(board_monsters_player_container)
	hand_container = HBoxContainer.new()
	hand_container.alignment = BoxContainer.ALIGNMENT_CENTER
	hand_container.custom_minimum_size = Vector2(720, 160)
	vbox.add_child(hand_container)
	var buttons = HBoxContainer.new()
	vbox.add_child(buttons)
	next_button = Button.new()
	next_button.text = "Siguiente Fase"
	buttons.add_child(next_button)
	next_button.pressed.connect(_on_next_phase)
	end_button = Button.new()
	end_button.text = "Fin Turno"
	buttons.add_child(end_button)
	end_button.pressed.connect(_on_end_turn)

func refresh_all():
	update_ui()
	refresh_hand()
	refresh_board()

func update_ui():
	phase_label.text = "Fase: %s" % turn_manager.get_phase()
	var current = players[turn_manager.current_player_index]
	energy_label.text = "Energia: %d/%d" % [current.energy, current.max_energy]
	hp_label_player.text = "HP Jugador: %d" % players[0].hp
	hp_label_ai.text = "HP IA: %d" % players[1].hp

func refresh_hand():
	for c in hand_container.get_children():
		c.queue_free()
	for card in players[0].hand.cards:
		var node = CardNode.new()
		node.set_card(card)
		node.card_clicked.connect(_on_hand_card_clicked)
		node.disabled = game_over
		hand_container.add_child(node)

func refresh_board():
	for c in board_monsters_ai_container.get_children(): c.queue_free()
	for c in board_spells_ai_container.get_children(): c.queue_free()
	for c in board_spells_player_container.get_children(): c.queue_free()
	for c in board_monsters_player_container.get_children(): c.queue_free()
	for i in range(3):
		board_monsters_ai_container.add_child(_create_slot_display(board.get_monster_slot(1, i)))
		board_spells_ai_container.add_child(_create_slot_display(board.get_spell_slot(1, i)))
		board_spells_player_container.add_child(_create_slot_display(board.get_spell_slot(0, i)))
		board_monsters_player_container.add_child(_create_slot_display(board.get_monster_slot(0, i)))

func check_game_over():
	if game_over:
		return
	for i in range(players.size()):
		if players[i].hp <= 0:
			end_game(1 - i)
			break

func end_game(winner_index: int):
	game_over = true
	var text: String
	if winner_index == 0:
		text = "Jugador gana!"
	else:
		text = "IA gana!"
	winner_label.text = "Juego terminado: %s" % text
	if next_button:
		next_button.disabled = true
	if end_button:
		end_button.disabled = true
	refresh_all()

func _create_slot_display(slot: Slot) -> Control:
	if slot.card:
		var node = CardNode.new()
		node.set_card(slot.card)
		node.disabled = true
		return node
	var p = Panel.new()
	p.custom_minimum_size = Vector2(120, 160)
	var style := StyleBoxFlat.new()
	style.border_width_all = 2
	style.border_color = Color.DARK_GRAY
	p.add_theme_stylebox_override("panel", style)
	return p

func _on_hand_card_clicked(card: CardModel):
	if game_over:
		return
	var player = players[0]
	var slot = board.get_free_slot(0, card.type)
	if slot and card.cost <= player.energy:
		player.play_card(card, slot, players[1])
		refresh_all()

func _on_next_phase():
	if game_over:
		return
	turn_manager.next_phase()
	if turn_manager.get_phase() == "BATTLE" and turn_manager.current_player_index == 0:
		players[0].perform_battle_phase(self)
		check_game_over()
	refresh_all()

func _on_end_turn():
	if game_over:
		return
	turn_manager.current_phase_index = turn_manager.phases.size() - 1
	turn_manager.end_turn()
	refresh_all()
	if turn_manager.current_player_index == 1:
		ai_turn()

func ai_turn():
	if game_over:
		return
	var ai = players[1]
	turn_manager.current_phase_index = 1
	update_ui()
	ai.perform_main_phase(self)
	refresh_board()
	if game_over:
		return
	turn_manager.current_phase_index = 2
	update_ui()
	ai.perform_battle_phase(self)
	refresh_board()
	if game_over:
		return
	turn_manager.current_phase_index = 3
	update_ui()
	turn_manager.end_turn()
	refresh_all()
