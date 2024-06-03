extends Node2D

class_name Dish

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var required_ingredients = {}

var sparkle = preload("res://Styles/Particles/sparkle_particle.tscn")
var inventory : Inventory

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


func check_ingredients(ingredients):
	if ingredients is Dictionary:
		for ingredient in ingredients:
			for req_ingredient in required_ingredients:
				if ingredient == req_ingredient and ingredients[ingredient] >= required_ingredients[req_ingredient]:
					available_unique_ingredients += 1
					
	set_is_cookable(available_unique_ingredients >= unique_ingredient_count)
	available_unique_ingredients = 0


func set_is_cookable(value):
	is_cookable = value
	if is_cookable:
		if modulate.a != 1.0:
			var new_sparkle = sparkle.instantiate()
			add_child(new_sparkle)

		modulate.a = 1.0
	else:
		modulate.a = Globals.modulate_disabled

