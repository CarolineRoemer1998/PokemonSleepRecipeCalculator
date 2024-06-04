extends Node2D

class_name Ingredient

@onready var ingredient_sprite: TextureRect = $IngredientSprite
@onready var required_amount_label: Label = $RequiredAmountLabel
@onready var frame: Sprite2D = $Frame
@onready var dotted_frame: Sprite2D = $DottedFrame

var inventory : Inventory
var is_necessary : bool = false

func _ready() -> void:
	frame.visible = false
	dotted_frame.visible = false
	dotted_frame.modulate = Globals.color_neutral
	inventory = get_tree().get_first_node_in_group("inventory")

func set_necessary(amount_available, amount_necessary):
	if amount_available >= amount_necessary:
		frame.modulate = Color(0,0.9,0.6)
	else:
		frame.modulate = Color(1,0.3,0.5)
	frame.visible = true
	required_amount_label.text = str(amount_available, "/", amount_necessary)

func reset_necessity():
	frame.visible = false
	required_amount_label.text = ""


func _on_ingredient_sprite_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		inventory.select_dishes_with_ingredient(self)
		toggle_dotted_frame(true)

func toggle_dotted_frame(value : bool):
	dotted_frame.visible = value
