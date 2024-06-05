extends Node2D

class_name Inventory

# ------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------

@onready var ingredient_amount: Label = $"../IngredientAmount"
@onready var dish_results: Node2D = $"../DishResults"
@onready var ingredient_selection: CanvasLayer = $"../IngredientSelection"

var total_amount : int = 0

var selected_ingredient : Ingredient = null

var ingredients = {
	"BeanSausage": 0,
	"FancyApple":  0,
	"FancyEgg" : 0,
	"PureOil" : 0,
	"FieryHerb" : 0,
	"GreengrassSoybeans" : 0,
	"Honey" : 0,
	"SlowpokeTail" : 0,
	"GreengrassCorn" : 0,
	"LargeLeek" : 0,
	"MoomooMilk" : 0,
	"SnoozyTomato" : 0,
	"TastyMushroom" : 0,
	"SoothingCacao" : 0,
	"SoftPotato" : 0,
	"WarmingGinger" : 0
}

# ------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------

func _ready() -> void:
	update_total_amount()


func update():
	update_total_amount()
	dish_results.pass_ingredients(ingredients)


## Adds given amount of ingredient in ingredients dictionary
## Updates total amount and passes ingredients dictionary to dish results
func add_ingredient(ingredient, amount):
	for ingredient_key in ingredients:
		if ingredient_key == ingredient:
			ingredients[ingredient_key] += amount
	update()

## Calculates total amount and updates the label
func update_total_amount():
	var amount = 0
	for ingredient_key in ingredients:
		amount += ingredients[ingredient_key]
	total_amount = amount
	
	ingredient_amount.text = "Total Ingredients: " + str(total_amount)


## Sets the amount of given ingredient to zero
func reset_ingredient_amount(ingredient : Ingredient):
	for ingredient_key in ingredients:
		if ingredient_key == ingredient.name:
			ingredients[ingredient_key] = 0
	update()


## Resets possibly required-framed ingredients 
## Gets ingredients required in dish and checks if enough are available
func set_necessary_ingredients(necessary_ingredients):
	remove_ingredient_required_frame()
	for n in necessary_ingredients:
		for available_ingredients in ingredient_selection.get_children():
			if available_ingredients.name == n and available_ingredients is Ingredient:
				var _amount_available = get_amount(available_ingredients)
				var _amount_necessary = necessary_ingredients[n]
				(available_ingredients.set_necessary(_amount_available, 
													 _amount_necessary))


## Removes required-frames from all ingredients
func remove_ingredient_required_frame():
	for ingredient in ingredient_selection.get_children():
		if ingredient is Ingredient:
			ingredient.remove_required_frame()


## Gets ingredient and returns its available amount
func get_amount(ingredient) -> int:
	for i in ingredients:
		if i == ingredient.name:
			return ingredients[i]
	return 0


## Sets selected_ingredient to given ingredient
## Sets selected_ingredient to null if it was given ingredient before 
func select_dishes_with_ingredient(ingredient : Ingredient):
	if selected_ingredient != ingredient:
		selected_ingredient = ingredient
	else:
		selected_ingredient = null
	update_dishes_with_ingredient()


## Calls function in dish_results to select dishes containing the selected ingredient
func update_dishes_with_ingredient():
	dish_results.select_dishes_with_ingredient(selected_ingredient)


## Turns off all ingredient selected-frames
func turn_off_all_ingredient_selected_frames():
	for ingredient in ingredient_selection.get_children():
		if ingredient is Ingredient:
			ingredient.set_selected_frame(false)

