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
@onready var dish_name: Label = $DishNameFrame/DishName
@onready var dish_name_frame: Button = $DishNameFrame


@export var required_ingredients = {}

var sparkle = preload("res://Styles/Particles/sparkle_particle.tscn")
var inventory : Inventory
var category : Category
var dishes_in_category = []

var unique_ingredient_count = 0
var available_unique_ingredients = 0

var is_cookable : bool = false
var selected : bool = false
var frame_contains_visible : bool = false

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
	
	return available_unique_ingredients >= unique_ingredient_count


func set_is_cookable(ingredients):
	is_cookable = check_if_cookable(ingredients)
	if selected:
		inventory.select_ingredients_required(required_ingredients)
	if is_cookable:
		_emit_sparkle()
		frame_selected.modulate = Globals.color_green
		frame_contains_ingredient.modulate = Globals.color_green
		modulate.a = Globals.modulate_enabled
	else:
		modulate.a = Globals.modulate_disabled
		frame_selected.modulate = Globals.color_red
		frame_contains_ingredient.modulate = Globals.color_red


func select(cookable : bool):
	if cookable:
		frame_selected.modulate = Globals.color_green
	else:
		frame_selected.modulate = Globals.color_red
	selected = true
	frame_selected.visible = true
	inventory.select_ingredients_required(required_ingredients)

func deselect():
	if selected and not animation_handler.mouse_hovering:
		animation_player.play_backwards("magnify")
	selected = false
	frame_selected.visible = false
	dish_name_frame.visible = false
	inventory.deselect_ingredients_required()

func set_contains_ingredient(selected_ingredient : Ingredient):
	set_is_cookable(inventory.ingredients)
	for ingredient in required_ingredients:
		if ingredient == selected_ingredient.name:
			frame_contains_ingredient.visible = true
			frame_contains_visible = true
			

func set_not_contains_ingredient():
	frame_contains_ingredient.visible = false
	frame_contains_visible = false



# ------------------------------------------------------------------
# Private Functions
# ------------------------------------------------------------------

func _emit_sparkle():
	if modulate.a != Globals.modulate_enabled:
			var new_sparkle = sparkle.instantiate()
			add_child(new_sparkle)
