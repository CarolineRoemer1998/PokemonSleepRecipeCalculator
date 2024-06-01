extends Node2D

class_name Dish

@export var required_ingredients = {}


var inventory : Inventory

var unique_ingredient_count = 0
var available_unique_ingredients = 0
var is_cookable : bool = false

var sparkle = preload("res://Styles/Particles/sparkle_particle.tscn")

func _ready():
	set_unique_ingredient_count()
	inventory = get_tree().get_first_node_in_group("inventory")
	check_ingredients(inventory.ingredients)

func check_ingredients(ingredients):
	if ingredients is Dictionary:
		for ingredient in ingredients:
			for req_ingredient in required_ingredients:
				if ingredient == req_ingredient and ingredients[ingredient] >= required_ingredients[req_ingredient]:
					available_unique_ingredients += 1
					
	set_is_cookable(available_unique_ingredients >= unique_ingredient_count)
	available_unique_ingredients = 0
					
func set_unique_ingredient_count():
	unique_ingredient_count = required_ingredients.size()
	
func set_is_cookable(value):
	is_cookable = value
	if is_cookable:
		if modulate.a != 1.0:
			var new_sparkle = sparkle.instantiate()
			add_child(new_sparkle)

		modulate.a = 1.0
	else:
		modulate.a = Globals.modulate_disabled


func magnify():
	var t = 0.0
	var magnified_scale = scale * 1.5
	while t < 1:
		t += get_physics_process_delta_time() * 0.1
		scale = scale.lerp(magnified_scale, t)

func demagnify():
	var t = 0.0
	var demagnified_scale = scale / 150 * 100
	while t < 1:
		t += get_physics_process_delta_time() * 0.1
		scale = scale.lerp(demagnified_scale, t)


func _on_dish_sprite_mouse_entered() -> void:
	magnify()


func _on_dish_sprite_mouse_exited() -> void:
	demagnify()
