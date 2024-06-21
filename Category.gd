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
	
func pass_ingredients(ingredients):
	for dish in get_children():
		if dish is Dish:
			dish.set_is_cookable(ingredients)

func select_all_contains_ingredient(ingredient : Ingredient):
	deselect_all_dishes()
	for dish in get_children():
		if dish is Dish:
			for i in dish.required_ingredients:
				if ingredient == null or i != ingredient.name:
					if dish.animation_handler.magnified:
						dish.animation_handler.demagnify()
					dish.set_not_contains_ingredient()
				elif i == ingredient.name:
					dish.set_contains_ingredient(ingredient)
					break

func deselect_all_dishes():
	for dish in get_children():
		if dish is Dish and dish.selected:
			dish.deselect()

func deselect_all_contains_ingredient():
	for dish in get_children():
		if dish is Dish and dish.frame_contains_ingredient.visible:
			dish.set_not_contains_ingredient()

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
