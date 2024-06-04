extends Node2D

var active_category : Node2D

func set_active_category(category):
	active_category = category

func pass_ingredients(ingredients):
	for child in active_category.get_children():
		if child is Dish:
			child.check_ingredients(ingredients)

func select_dishes_with_ingredient(ingredient : Ingredient):
	for category_handler in get_children():
		if category_handler is CategoryHandler:
			category_handler.select_dishes_with_ingredient(ingredient)
#	active_category.select_dishes_with_ingredient(ingredient)
