extends Node

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var dish_name: Label = $"../DishName"
@onready var dish_sprite: TextureRect = $"../DishSprite"
@onready var dish: Node2D = $".."
@onready var dotted_frame: Sprite2D = $"../DottedFrame"

var category : Category
var magnified : bool = false

func _ready() -> void:
	dish_name.text = get_parent().name
	dish_name.visible = false
	dish_sprite.modulate = Color.WHITE
	category = get_parent().get_parent()


func toggle_selected(is_selecting : bool):
	var is_passive = false
	_general_selection(is_selecting, is_passive)

func passive_deselect():
	var is_selecting = false
	var is_passive = true
	_general_selection(is_selecting, is_passive)
	dish_name.visible = false


func _general_selection(selecting : bool, is_passive : bool):
	dish.selected = selecting
	category.has_selected_dish = selecting
	dotted_frame.visible = selecting
	
	if is_passive:
		animation_player.play_backwards("magnify")
		dish_sprite.scale = Globals.deselected_dish_scale
		dish_sprite.position = Globals.deselected_dish_position
		magnified = false
	else:
		if selecting:
			animation_player.play("selected")
			dish_sprite.scale = Globals.selected_dish_scale
			dish_sprite.position = Globals.selected_dish_position
			magnified = true
			dish_name.visible = true

func _on_dish_sprite_mouse_entered() -> void:
	if !dish.selected:
		animation_player.play("magnify")
		magnified = true
		if !category.has_selected_dish:
			dish_name.visible = true

func _on_dish_sprite_mouse_exited() -> void:
	if !dish.selected:
		if magnified:
			animation_player.play_backwards("magnify")
		dish_name.visible = false
		magnified = false

func _on_dish_sprite_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		dish.toggle_selected(!dish.selected)
