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
	
func pick_category(category):
	get_parent().set_active_category(category)
	inventory.dish_results.pass_ingredients(inventory.ingredients)
	deselect_dishes(category)
	
	match category:
		curries:
			curries.modulate.a = 1.0
			show_children(curries)
			salads.modulate.a = Globals.modulate_disabled
			hide_children(salads)
			desserts.modulate.a = Globals.modulate_disabled
			hide_children(desserts)
		salads:
			curries.modulate.a = Globals.modulate_disabled
			hide_children(curries)
			salads.modulate.a = 1.0
			show_children(salads)
			desserts.modulate.a = Globals.modulate_disabled
			hide_children(desserts)
		desserts:
			curries.modulate.a = Globals.modulate_disabled
			hide_children(curries)
			salads.modulate.a = Globals.modulate_disabled
			hide_children(salads)
			desserts.modulate.a = 1.0
			show_children(desserts)
			
	active_category = category


func deselect_dishes(category):
	if active_category != category:
		inventory.remove_ingredient_required_frame()
		for dish in active_category.get_children():
			if dish is Dish:
				dish.animation_handler.passive_deselect()

func pass_ingredients(ingredients):
	for category in get_children():
		if category is Category:
			for dish in category.get_children():
				if dish is Dish:
					dish.check_ingredients(ingredients)

func deselect_all_dishes():
	for category in get_children():
		if category is Category:
			for dish in category.get_children():
				if dish is Dish:
					dish.toggle_selected(false)

func select_dishes_with_ingredient(ingredient : Ingredient):
	for category in get_children():
		if category is Category:
			category.select_dishes_with_ingredient(ingredient)

func deselect_all_dishes_with_ingredient():
	for category in get_children():
		if category is Category:
			category.deselect_dishes_with_ingredient()

func hide_children(category):
	for child in category.get_children():
		if child is Dish:
			child.visible = false

func show_children(category):
	for child in category.get_children():
		if child is Dish:
			child.visible = true


# ------------------------------------------------------------------
# Signals
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
