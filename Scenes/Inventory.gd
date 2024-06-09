extends Node2D

class_name Inventory

# ------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------

@onready var ingredient_amount: Label = $"../IngredientAmount"
@onready var ingredient_selection: CanvasLayer = $"../IngredientSelection"
@onready var category_handler: CategoryHandler = $"../CategoryHandler"

var total_amount : int = 0

var selected_ingredient : Ingredient = null
var selected_dish : Dish = null

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
	_update_total_amount()


func update():
	_update_total_amount()
	category_handler.pass_ingredients(ingredients)


## Adds given amount of ingredient in ingredients dictionary
## Updates total amount and passes ingredients dictionary to dish results
func add_ingredient(ingredient, amount):
	for ingredient_key in ingredients:
		if ingredient_key == ingredient:
			ingredients[ingredient_key] += amount
	update()


## Sets the amount of given ingredient to zero
func reset_ingredient_amount(ingredient : Ingredient):
	for ingredient_key in ingredients:
		if ingredient_key == ingredient.name:
			ingredients[ingredient_key] = 0
	update()


## Sets selected_ingredient to given ingredient
## Sets selected_ingredient to null if it was given ingredient before 
func select_ingredient(ingredient : Ingredient):
	if selected_ingredient != ingredient:
		selected_ingredient = ingredient
	else:
		deselect_ingredient(ingredient)
	select_dishes_containing_ingredient()


func deselect_ingredient(ingredient : Ingredient):
	selected_ingredient = null


## Resets possibly required-framed ingredients 
## Gets ingredients required in dish and checks if enough are available
func select_ingredients_required(required_ingredients):
	for n in required_ingredients:
		for available_ingredients in ingredient_selection.get_children():
			if available_ingredients.name == n and available_ingredients is Ingredient:
				var _amount_available = _get_amount(available_ingredients)
				var _amount_necessary = required_ingredients[n]
				(available_ingredients.set_required(_amount_available, 
													 _amount_necessary))


## Removes required-frames from all ingredients
func deselect_ingredients_required():
	for ingredient in ingredient_selection.get_children():
		if ingredient is Ingredient:
			ingredient.remove_required_frame()


## Calls function in dish_results to select dishes containing the selected ingredient
func select_dishes_containing_ingredient():
	category_handler.select_all_contains_ingredient(selected_ingredient)


## Turns off all ingredient selected-frames
func turn_off_all_ingredient_selected_frames():
	for ingredient in ingredient_selection.get_children():
		if ingredient is Ingredient:
			ingredient.set_selected_frame(false)
	selected_ingredient = null


# ------------------------------------------------------------------
# Private Functions
# ------------------------------------------------------------------

## Gets ingredient and returns its available amount
func _get_amount(ingredient) -> int:
	for i in ingredients:
		if i == ingredient.name:
			return ingredients[i]
	return 0


## Calculates total amount and updates the label
func _update_total_amount():
	var amount = 0
	for ingredient_key in ingredients:
		amount += ingredients[ingredient_key]
	total_amount = amount
	
	ingredient_amount.text = "Total Ingredients: " + str(total_amount)

