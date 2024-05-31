extends Node2D

class_name AmountChanger

@onready var label: Label = $Label
@onready var inventory: Inventory = $"../../../Inventory"
@onready var button_reset: Button = $ButtonReset

var ingredient_image : Sprite2D
var ingredient_name : String
var amount : int = 0

func _ready() -> void:
	ingredient_name = get_parent().name
	ingredient_image = get_parent()


func _process(delta: float) -> void:
	if amount > 0:
		button_reset.disabled = false
		
	set_image_opacity()


func _on_button_add_pressed() -> void:
	if amount < 1000:
		amount += 1
		update_label()
		update_inventory(1)


func _on_button_subtract_pressed() -> void:
	if amount > 0:
		amount -= 1
		update_label()
		update_inventory(-1)


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
	if amount == 0 and ingredient_image.self_modulate.a != Globals.modulate_disabled:
		ingredient_image.self_modulate.a = Globals.modulate_disabled
	elif amount > 0 and ingredient_image.self_modulate.a != 1.0:
		ingredient_image.self_modulate.a = 1.0
		
