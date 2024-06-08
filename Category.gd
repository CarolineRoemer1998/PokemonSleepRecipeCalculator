extends Node2D

class_name Category

# ------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var category_name: Label = $CategoryName

var inventory : Inventory
var has_selected_dish : bool

# ------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------

func _ready() -> void:
	category_name.text = name
	has_selected_dish = false
	inventory = get_tree().get_first_node_in_group("inventory")

func select_dishes_with_ingredient(ingredient : Ingredient):
	deselect_all_dishes()
	for dish in get_children():
#		print(dish.name)
		if dish is Dish:
			for i in dish.required_ingredients:
				if ingredient == null or i != ingredient.name:
					if dish.animation_handler.magnified:
						dish.animation_handler.demagnify()
					dish.turn_off_dish_contains_ingredient_frame()
#					dish.set_frame_contains_ingredient_visibility(false)
				elif i == ingredient.name:
					dish.turn_on_dish_contains_ingredient_frame(ingredient)
#					dish.set_frame_contains_ingredient_visibility(true)
					break
					

func deselect_all_dishes():
	for dish in get_children():
		if dish is Dish:
			dish.turn_off_dish_selected_frame()

func deselect_dishes_with_ingredient():
	for dish in get_children():
		if dish is Dish:
			dish.turn_off_dish_contains_ingredient_frame()

# ------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------

func _on_category_sprite_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		get_parent().pick_category(self)


func _on_category_sprite_mouse_entered() -> void:
	animation_player.play("magnify")


func _on_category_sprite_mouse_exited() -> void:
	animation_player.play_backwards("magnify")
