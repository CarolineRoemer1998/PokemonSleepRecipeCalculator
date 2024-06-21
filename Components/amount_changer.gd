extends Node2D

class_name AmountChanger

# ------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------

@onready var label: Label = $Label
@onready var inventory: Inventory = $"../../../Inventory"
@onready var button_reset: Button = $ButtonReset
@onready var ingredient_sprite: TextureRect = $"../IngredientSprite"

var ingredient_name : String
var ingredient : Ingredient
var amount : int = 0

# ------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------

func _ready() -> void:
	ingredient_name = get_parent().name
	ingredient = get_parent()
	set_image_opacity()

func add(amount_to_add):
	if amount < 1000-amount_to_add:
		amount += amount_to_add
	elif amount >= 1000-amount_to_add:
		amount_to_add = 999-amount
		amount += amount_to_add
	update(amount_to_add)
	button_reset.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func subtract(amount_to_subtract):
	if amount >= amount_to_subtract:
		amount -= amount_to_subtract
	elif amount < amount_to_subtract:
		amount_to_subtract = amount
		amount = 0
	update(-amount_to_subtract)
	

func update(difference : int):
	label.text = str(amount)
	inventory.add_ingredient(ingredient_name, difference)
	if inventory.selected_dish == null:
		inventory.select_dishes_containing_ingredient()
	set_image_opacity()
	disable_reset_button_if_zero()
	inventory.cooking_pot.set_visibility()

func set_image_opacity():
	if amount == 0 and ingredient_sprite.self_modulate.a != Globals.modulate_disabled:
		ingredient_sprite.self_modulate.a = Globals.modulate_disabled
		button_reset.disabled = true
	elif amount > 0 and ingredient_sprite.self_modulate.a != Globals.modulate_enabled:
		ingredient_sprite.self_modulate.a = Globals.modulate_enabled
		button_reset.disabled = false

func disable_reset_button_if_zero():
	if amount == 0:
			button_reset.disabled = true
			button_reset.mouse_default_cursor_shape = Control.CURSOR_ARROW

# ------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------

func _on_button_add_pressed() -> void:
	add(1)

func _on_button_add_5_pressed() -> void:
	add(5)

func _on_button_subtract_pressed() -> void:
	subtract(1)

func _on_button_subtract_5_pressed() -> void:
	subtract(5)

func _on_button_reset_pressed() -> void:
	amount = 0
	inventory.reset_ingredient_amount(ingredient)
	update(0)

