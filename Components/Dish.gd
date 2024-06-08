extends Node2D

class_name Dish

# ------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_handler: Node = $AnimationHandler
@onready var dish_sprite: TextureRect = $DishSprite
@onready var frame_selected: Sprite2D = $FrameSelected
@onready var frame_contains_ingredient: Sprite2D = $FrameContainsIngredient
@onready var dish_name: Label = $DishName


@export var required_ingredients = {}

var sparkle = preload("res://Styles/Particles/sparkle_particle.tscn")
var inventory : Inventory
var category : Category
var dishes_in_category = []

var unique_ingredient_count = 0
var available_unique_ingredients = 0

var is_cookable : bool = false
var selected : bool = false

# ------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------

func _ready():
	set_init_variables()
	set_is_cookable(inventory.ingredients)


func set_init_variables():
	inventory = get_tree().get_first_node_in_group("inventory")
	unique_ingredient_count = required_ingredients.size()
	dish_sprite.modulate = Color.WHITE
	category = get_parent()
	for dish in category.get_children():
		if dish is Dish:
			dishes_in_category.append(dish)

## Checks if dish is cookable
## If dish is selected, gives required ingredients to inventory 
## to set required-frames for ingredients
func check_if_cookable(ingredients) -> bool:
	available_unique_ingredients = 0
	
	if ingredients is Dictionary:
		for ingredient in ingredients:
			for req_ingredient in required_ingredients:
				if ingredient == req_ingredient and ingredients[ingredient] >= required_ingredients[req_ingredient]:
					available_unique_ingredients += 1
	
	if selected:
		inventory.set_necessary_ingredients(required_ingredients)
		
	return available_unique_ingredients >= unique_ingredient_count


func set_is_cookable(ingredients):
	is_cookable = check_if_cookable(ingredients)
	if is_cookable:
		if modulate.a != 1.0:
			var new_sparkle = sparkle.instantiate()
			add_child(new_sparkle)
		frame_selected.modulate = Globals.color_available
		frame_contains_ingredient.modulate = Globals.color_available
		modulate.a = 1.0
	else:
		modulate.a = Globals.modulate_disabled
		frame_selected.modulate = Globals.color_unavailable
		frame_contains_ingredient.modulate = Globals.color_unavailable


func toggle_selected(value : bool):
	selected = value
	inventory.selected_ingredient = null
	inventory.turn_off_all_ingredient_selected_frames()
	inventory.update_dishes_with_ingredient()
	frame_selected.visible = value
	
	if value == true:
		inventory.set_necessary_ingredients(required_ingredients)


func set_frame_contains_ingredient_visibility(value : bool):
	if is_cookable:
		frame_contains_ingredient.modulate = Globals.color_available
	else:
		frame_contains_ingredient.modulate = Globals.color_unavailable
	frame_contains_ingredient.visible = value
	

func turn_off_dish_selected_frame():
	if selected:
		animation_player.play_backwards("magnify")
	selected = false
	frame_selected.visible = false
	dish_name.visible = false
	inventory.remove_ingredient_required_frame()

func turn_on_dish_selected_frame(cookable : bool):
	if cookable:
		frame_selected.modulate = Globals.color_available
	else:
		frame_selected.modulate = Globals.color_unavailable
	selected = true
	frame_selected.visible = true
	inventory.set_necessary_ingredients(required_ingredients)

func turn_off_dish_contains_ingredient_frame():
	frame_contains_ingredient.visible = false

func turn_on_dish_contains_ingredient_frame(selected_ingredient : Ingredient):
	set_is_cookable(inventory.ingredients)
	for ingredient in required_ingredients:
		if ingredient == selected_ingredient.name:
			frame_contains_ingredient.visible = true

