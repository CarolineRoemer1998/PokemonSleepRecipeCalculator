extends Node2D

class_name Dish

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_handler: Node = $AnimationHandler
@onready var dish_sprite: TextureRect = $DishSprite
@onready var dotted_frame: Sprite2D = $DottedFrame
@onready var frame: Sprite2D = $Frame

@export var required_ingredients = {}

var sparkle = preload("res://Styles/Particles/sparkle_particle.tscn")
var inventory : Inventory
var category : Category
var dishes_in_category = []

var unique_ingredient_count = 0
var available_unique_ingredients = 0

var is_cookable : bool = false
var selected : bool = false


func _ready():
	set_init_variables()
	check_ingredients(inventory.ingredients)


func set_init_variables():
	inventory = get_tree().get_first_node_in_group("inventory")
	unique_ingredient_count = required_ingredients.size()
	dish_sprite.modulate = Color.WHITE
	category = get_parent()
	for dish in category.get_children():
		if dish is Dish:
			dishes_in_category.append(dish)


func check_ingredients(ingredients):
	if ingredients is Dictionary:
		for ingredient in ingredients:
			for req_ingredient in required_ingredients:
				if ingredient == req_ingredient and ingredients[ingredient] >= required_ingredients[req_ingredient]:
					available_unique_ingredients += 1
					
	set_is_cookable(available_unique_ingredients >= unique_ingredient_count)
	available_unique_ingredients = 0
	if selected:
		inventory.set_necessary_ingredients(required_ingredients)


func set_is_cookable(value):
	is_cookable = value
	if is_cookable:
		if modulate.a != 1.0:
			var new_sparkle = sparkle.instantiate()
			add_child(new_sparkle)
		dotted_frame.modulate = Color(0, 0.9, 0.6, 0.3)
		modulate.a = 1.0
	else:
		modulate.a = Globals.modulate_disabled
		dotted_frame.modulate = Color(1,0.3,0.5)


func toggle_selected(value : bool):
	for child in dishes_in_category:
		if child == self and child.selected:
			inventory.reset_ingredient_necessity()
		if child is Dish and child != self and child.selected:
			child.animation_handler.passive_deselect()
			child.selected = false
		animation_handler.toggle_selected(value)
		
	selected = value
	dotted_frame.visible = value
	
	if value == true:
		inventory.set_necessary_ingredients(required_ingredients)


func set_frame_visibility(value : bool):
	if is_cookable:
		frame.modulate = Globals.color_available
	else:
		frame.modulate = Globals.color_unavailable
	frame.visible = value
	if value == true:
		category.get_parent().deselect_all_dishes()
	elif inventory.selected_ingredient == null:
		inventory.turn_off_all_ingredient_frames()
	
