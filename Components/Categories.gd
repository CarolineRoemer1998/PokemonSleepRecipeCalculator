extends Node2D

@onready var curries: Node2D = $"Curries & Stews"
@onready var salads: Node2D = $"Salads"
@onready var desserts: Node2D = $"Desserts & Drinks"

var inventory : Inventory
var active_category : Category

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
		inventory.reset_ingredient_necessity()
		for dish in active_category.get_children():
			if dish is Dish:
				dish.animation_handler.passive_deselect()


func _on_curries_stews_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		pick_category(curries)


func _on_desserts_drinks_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		pick_category(desserts)


func _on_salads_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		pick_category(salads)


func hide_children(category):
	for child in category.get_children():
		if child is Dish:
			child.visible = false
		

func show_children(category):
	for child in category.get_children():
		if child is Dish:
			child.visible = true
