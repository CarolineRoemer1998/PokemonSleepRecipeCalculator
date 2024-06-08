extends Node2D

class_name CategoryHandler

# ------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------

@onready var curries: Node2D = $"Curries & Stews"
@onready var salads: Node2D = $"Salads"
@onready var desserts: Node2D = $"Desserts & Drinks"

var inventory : Inventory
var active_category : Category

# ------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------

func _ready() -> void:
	inventory = get_tree().get_first_node_in_group("inventory")
	active_category = curries
	pick_category(curries)

## Makes dishes from clicked_category visible and hides others
## Removes ingredient required frames, deselects any dishes, 
## sets new active_category and passes it the available ingredients
func pick_category(clicked_category):
	if active_category != clicked_category:
		active_category = clicked_category
		inventory.selected_dish = null
		inventory.selected_ingredient = null
		inventory.remove_ingredient_required_frame()
		deselect_dishes(clicked_category)
#		pass_ingredients(inventory.ingredients)
	
	match clicked_category:
		curries:
			curries.modulate.a = 1.0
			_show_children(curries)
			salads.modulate.a = Globals.modulate_disabled
			_hide_children(salads)
			desserts.modulate.a = Globals.modulate_disabled
			_hide_children(desserts)
		salads:
			curries.modulate.a = Globals.modulate_disabled
			_hide_children(curries)
			salads.modulate.a = 1.0
			_show_children(salads)
			desserts.modulate.a = Globals.modulate_disabled
			_hide_children(desserts)
		desserts:
			curries.modulate.a = Globals.modulate_disabled
			_hide_children(curries)
			salads.modulate.a = Globals.modulate_disabled
			_hide_children(salads)
			desserts.modulate.a = 1.0
			_show_children(desserts)


func deselect_dishes(category):
	for dish in active_category.get_children():
		if dish is Dish:
			dish.turn_off_dish_selected_frame()


func pass_ingredients(ingredients):
	for category in get_children():
		if category is Category:
			for dish in category.get_children():
				if dish is Dish:
					dish.set_is_cookable(ingredients)


func deselect_all_dishes():
	for category in get_children():
		if category is Category:
			category.deselect_all_dishes()


func select_dishes_with_ingredient(ingredient : Ingredient):
	if ingredient == null:
		deselect_all_dishes_with_ingredient()
	for category in get_children():
		if category is Category:
			category.select_dishes_with_ingredient(ingredient)

func deselect_all_dishes_with_ingredient():
	for category in get_children():
		if category is Category:
			category.deselect_dishes_with_ingredient()


# ------------------------------------------------------------------
# Signals & private functions
# ------------------------------------------------------------------

func _on_curries_stews_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		pick_category(curries)


func _on_desserts_drinks_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		pick_category(desserts)


func _on_salads_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		pick_category(salads)


func _hide_children(category):
	for child in category.get_children():
		if child is Dish:
			child.visible = false


func _show_children(category):
	for child in category.get_children():
		if child is Dish:
			child.visible = true

