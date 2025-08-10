extends Button
class_name CardNode

var card_model: CardModel
signal card_clicked(card)

var atk_label: Label
var def_label: Label
var cost_label: Label
var effect_label: Label

func _init():
	# Establecer el estilo del botón
	custom_minimum_size = Vector2(120, 160)
	flat = true
	var style = StyleBoxFlat.new()
	style.border_width_all = 2
	style.border_color = Color.BLACK
	add_theme_stylebox_override("normal", style)
	add_theme_stylebox_override("hover", style)
	add_theme_stylebox_override("pressed", style)

	# Crear y configurar los nodos de la UI
	atk_label = Label.new()
	add_child(atk_label)
	atk_label.position = Vector2(4, 4)

	cost_label = Label.new()
	add_child(cost_label)
	cost_label.anchor_left = 1
	cost_label.anchor_right = 1
	cost_label.offset_left = -40
	cost_label.offset_right = -4
	cost_label.offset_top = 4
	cost_label.offset_bottom = 24
	cost_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

	def_label = Label.new()
	add_child(def_label)
	def_label.anchor_left = 0.5
	def_label.anchor_right = 0.5
	def_label.offset_left = -20
	def_label.offset_right = 20
	def_label.offset_top = 4
	def_label.offset_bottom = 24
	def_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	effect_label = Label.new()
	add_child(effect_label)
	effect_label.anchor_left = 0
	effect_label.anchor_right = 1
	effect_label.anchor_top = 1
	effect_label.anchor_bottom = 1
	effect_label.offset_left = 4
	effect_label.offset_right = -4
	effect_label.offset_top = -40
	effect_label.offset_bottom = -4
	effect_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	effect_label.autowrap = true

func _ready():
	# El código en _ready() debe ser el mínimo necesario.
	text = ""
	_update_display()

func set_card(card):
	card_model = card
	_update_display()

func _update_display():
	if card_model == null:
		atk_label.text = ""
		def_label.text = ""
		cost_label.text = ""
		effect_label.text = ""
		return
	cost_label.text = str(card_model.cost)
	atk_label.text = str(card_model.atk)
	def_label.text = str(card_model.def)
	if card_model.effects.size() > 0:
		var eff = card_model.effects[0].get("effect", "")
		effect_label.text = str(eff)
	else:
		effect_label.text = ""

func _pressed():
	emit_signal("card_clicked", card_model)
