extends Node

# ------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var dish_name: Label = $"../DishName"
@onready var dish_sprite: TextureRect = $"../DishSprite"
@onready var dish: Dish = $".."
@onready var frame_selected: Sprite2D = $"../FrameSelected"


var category : Category
var magnified : bool = false
var inventory : Inventory
var mouse_hovering : bool = false

# ------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------

func _ready() -> void:
	dish_name.text = get_parent().name
	dish_name.visible = false
	dish_sprite.modulate = Color.WHITE
	category = get_parent().get_parent()
	inventory = get_tree().get_first_node_in_group("inventory")


func demagnify():
	if magnified:
		animation_player.play_backwards("magnify")		
		dish_name.visible = false
		magnified = false
	

# ------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------

func _on_dish_sprite_mouse_entered() -> void:
	if !dish.selected:
		animation_player.play("magnify")
		magnified = true
		if inventory.selected_dish == null:
			dish_name.visible = true
	mouse_hovering = true
		

func _on_dish_sprite_mouse_exited() -> void:
	if !dish.selected:
		demagnify()
	mouse_hovering = false

func _on_dish_sprite_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		if inventory.selected_dish == dish:
			inventory.selected_dish = null
		else:
			inventory.selected_dish = dish
		
		inventory.cooking_pot.set_visibility()
			
		category.deselect_all_dishes()
		
		if inventory.selected_dish != null:
			inventory.turn_off_all_ingredient_selected_frames()
			inventory.select_dishes_containing_ingredient()
			dish_name.visible = true
			dish.select(dish.check_if_cookable(inventory.ingredients))
		else:
			magnified = true
		animation_player.play("selected")
