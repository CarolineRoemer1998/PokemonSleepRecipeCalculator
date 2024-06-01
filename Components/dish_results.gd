extends Node2D

var active_category : TextureRect

func _process(delta: float) -> void:
	pass

func set_active_category(category):
	active_category = category

func pass_ingredients(ingredients):
	for child in active_category.get_children():
		if child is Dish:
			child.check_ingredients(ingredients)

