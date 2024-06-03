extends Node2D

class_name AmountChanger

@onready var label: Label = $Label
@onready var inventory: Inventory = $"../../../Inventory"
@onready var button_reset: Button = $ButtonReset
@onready var ingredient_sprite: TextureRect = $"../IngredientSprite"


var ingredient_name : String
var amount : int = 0

func _ready() -> void:
	ingredient_name = get_parent().name

func _process(delta: float) -> void:
	if amount > 0:
		button_reset.disabled = false
		
	set_image_opacity()

func add_one():
	if amount < 999:
		amount += 1
		update_label()
		update_inventory(1)

func _on_button_add_pressed() -> void:
	add_one()

func _on_button_subtract_pressed() -> void:
	if amount > 0:
		amount -= 1
		update_label()
		update_inventory(-1)
		disable_reset_button_if_zero()

func update_label():
	label.text = str(amount)

func update_inventory(amount : int):
	inventory.update_amount_of(ingredient_name, amount)

func _on_button_reset_pressed() -> void:
	amount = 0
	button_reset.disabled = true
	update_label()
	inventory.reset_ingredient_amount(ingredient_name)

func set_image_opacity():
	if amount == 0 and ingredient_sprite.self_modulate.a != Globals.modulate_disabled:
		ingredient_sprite.self_modulate.a = Globals.modulate_disabled
	elif amount > 0 and ingredient_sprite.self_modulate.a != 1.0:
		ingredient_sprite.self_modulate.a = 1.0

func _on_button_add_5_pressed() -> void:
	if amount < 995:
		amount += 5
		update_label()
		update_inventory(5)
	elif amount > 995:
		amount += 999-amount
		update_label()
		update_inventory(999-amount)

func _on_button_subtract_5_pressed() -> void:
	if amount > 4:
		amount -= 5
		update_label()
		update_inventory(-5)
		disable_reset_button_if_zero()
	elif amount < 0:
		amount -= amount
		update_label()
		update_inventory(-amount)
		disable_reset_button_if_zero()

func disable_reset_button_if_zero():
	if amount == 0:
			button_reset.disabled = true


func _on_ingredient_sprite_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		add_one()
