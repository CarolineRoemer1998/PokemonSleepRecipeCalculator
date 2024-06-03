extends Node

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var dish_name: Label = $"../DishName"
@onready var dish_sprite: TextureRect = $"../DishSprite"
@onready var dish: Node2D = $".."

var category : Category
var magnified : bool = false

func _ready() -> void:
	dish_name.text = get_parent().name
	dish_name.visible = false
	dish_sprite.modulate = Color.WHITE
	category = get_parent().get_parent()

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

func toggle_selected(selecting : bool):
	if selecting:
		category.has_selected_dish = true
		animation_player.play("selected")
		
		dish_name.visible = true
		
		dish_sprite.modulate = Color(0.42, 1, 0.68)
		dish_sprite.scale = Globals.selected_dish_scale
		dish_sprite.set_position(Globals.selected_dish_position)
		magnified = true
	elif !selecting:
		dish_sprite.modulate = Color.WHITE

func passive_deselect():
	animation_player.play_backwards("magnify")
	dish_sprite.scale = Globals.deselected_dish_scale
	dish_sprite.position = Globals.deselected_dish_position
	magnified = false
	dish.selected = false
		
	dish_sprite.modulate = Color.WHITE
	dish_name.visible = false
	category.has_selected_dish = false
