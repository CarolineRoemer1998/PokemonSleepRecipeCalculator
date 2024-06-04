extends Node2D

class_name Inventory

@onready var ingredient_amount: Label = $"../IngredientAmount"
@onready var dish_results: Node2D = $"../DishResults"
@onready var ingredient_selection: CanvasLayer = $"../IngredientSelection"

var total_amount : int = 0

var selected_ingredient : Ingredient

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


func _ready() -> void:
	update_amount_label()


func update_amount_of(ingredient, amount): 
	add_to_ingredient(ingredient, amount)
	
	calculate_total_amount()
	update_amount_label()
	dish_results.pass_ingredients(ingredients)


func add_to_ingredient(ingredient, amount):
	for ingredient_key in ingredients:
		if ingredient_key == ingredient:
			ingredients[ingredient_key] += amount


func calculate_total_amount():
	var amount = 0
	for ingredient_key in ingredients:
		amount += ingredients[ingredient_key]
	total_amount = amount


func update_amount_label():
	ingredient_amount.text = "Total Ingredients: " + str(total_amount)



func reset_ingredient_amount(ingredient_name : String):
	for ingredient_key in ingredients:
		if ingredient_key == ingredient_name:
			ingredients[ingredient_key] = 0
	calculate_total_amount()
	update_amount_label()
	dish_results.pass_ingredients(ingredients)
	


func set_necessary_ingredients(necessary):
	reset_ingredient_necessity()
	for n in necessary:
		for available in ingredient_selection.get_children():
			if available.name == n and available is Ingredient:
				available.set_necessary(get_amount(available), necessary[n])

func reset_ingredient_necessity():
	for ingredient in ingredient_selection.get_children():
		if ingredient is Ingredient:
			ingredient.reset_necessity()

func get_amount(ingredient):
	for i in ingredients:
		if i == ingredient.name:
			return ingredients[i]

func select_dishes_with_ingredient(ingredient : Ingredient):
#	turn_off_all_ingredient_frames()
	if selected_ingredient != ingredient:
		selected_ingredient = ingredient
	else:
		selected_ingredient = null
	dish_results.select_dishes_with_ingredient(ingredient)
	
func update_dishes_with_ingredient():
	if selected_ingredient != null:
		dish_results.select_dishes_with_ingredient(selected_ingredient)
	
func turn_off_all_ingredient_frames():
	for ingredient in ingredient_selection.get_children():
		if ingredient is Ingredient:
			ingredient.toggle_dotted_frame(false)
	if selected_ingredient != null:
		selected_ingredient.toggle_dotted_frame(true)
