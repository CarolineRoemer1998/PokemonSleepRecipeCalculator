extends Node2D

class_name Category

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var category_name: Label = $CategoryName

var has_selected_dish : bool

func _ready() -> void:
	category_name.text = name
	has_selected_dish = false

func select_dishes_with_ingredient(ingredient : Ingredient):
	for dish in get_children():
		if dish is Dish:
			for i in dish.required_ingredients:
				print(i)
				if i == ingredient.name:
					dish.set_frame_visibility(true)
					break
				else:
					dish.set_frame_visibility(false)

func deselect_dishes_with_ingredient():
	for dish in get_children():
		if dish is Dish:
			for i in dish.required_ingredients:
				dish.set_frame_visibility(false)

func _on_category_sprite_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		get_parent().pick_category(self)


func _on_category_sprite_mouse_entered() -> void:
	animation_player.play("magnify")


func _on_category_sprite_mouse_exited() -> void:
	animation_player.play_backwards("magnify")
