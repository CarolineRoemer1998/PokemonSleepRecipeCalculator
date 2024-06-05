extends Node2D

# ------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------

var active_category : Node2D

# ------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------

func set_active_category(category):
	active_category = category

func pass_ingredients(ingredients):
	for category_handler in get_children():
		if category_handler is CategoryHandler:
			category_handler.pass_ingredients(ingredients)

func select_dishes_with_ingredient(ingredient : Ingredient):
	for category_handler in get_children():
		if category_handler is CategoryHandler:
			category_handler.select_dishes_with_ingredient(ingredient)
