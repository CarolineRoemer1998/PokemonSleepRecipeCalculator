extends Node2D

class_name Inventory

@onready var ingredient_amount: Label = $"../IngredientAmount"
@onready var dish_results: Node2D = $"../DishResults"

var total_amount : int = 0

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

