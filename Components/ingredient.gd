extends Node2D

class_name Ingredient

@onready var ingredient_sprite: TextureRect = $IngredientSprite
@onready var required_amount_label: Label = $RequiredAmountLabel
@onready var frame: Sprite2D = $Frame

var is_necessary : bool = false

func _ready() -> void:
	frame.visible = false

func set_necessary(amount_available, amount_necessary):
	if amount_available >= amount_necessary:
		frame.modulate = Color(0,0.9,0.6)
	else:
		frame.modulate = Color(1,0.3,0.5)
	frame.visible = true
#	ingredient_sprite.modulate = Color(0, 1, 1)
	required_amount_label.text = str(amount_available, "/", amount_necessary)
	print(name, ": ", amount_available, " / ", amount_necessary)

func reset_necessity():
	frame.visible = false
#	ingredient_sprite.modulate = Color(1,1,1)
	required_amount_label.text = ""
