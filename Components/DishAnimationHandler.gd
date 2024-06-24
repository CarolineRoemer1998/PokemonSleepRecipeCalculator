extends Node

# ------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var dish_name: Label = $"../DishNameFrame/DishName"
@onready var dish_sprite: TextureRect = $"../DishSprite"
@onready var dish: Dish = $".."
@onready var frame_selected: Sprite2D = $"../FrameSelected"
@onready var dish_name_frame: Button = $"../DishNameFrame"


var category : Category
var magnified : bool = false
var inventory : Inventory
var mouse_hovering : bool = false

# ------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------

func _ready() -> void:
	dish_name.text = get_parent().name
	dish_name_frame.visible = false
	
	dish_sprite.modulate = Color.WHITE
	category = get_parent().get_parent()
	inventory = get_tree().get_first_node_in_group("inventory")
	dish_name_frame.size.x = dish_name.size.x + 10
	dish_name_frame.global_position.y = dish.global_position.y+40
	dish_name_frame.global_position.x = dish.global_position.x - (dish_name_frame.size.x/2)


func demagnify():
	if magnified:
		animation_player.play_backwards("magnify")		
		dish_name_frame.visible = false
		magnified = false
	

# ------------------------------------------------------------------
# Signals & Private Functions
# ------------------------------------------------------------------

func _set_name_frame_size():
	dish_name_frame.size.x = dish_name.size.x + 10
	dish_name_frame.global_position.y = dish.global_position.y+40
	dish_name_frame.global_position.x = dish.global_position.x - (dish_name_frame.size.x/2)

func _on_dish_sprite_mouse_entered() -> void:
	if !dish.selected:
		animation_player.play("magnify")
		magnified = true
		if inventory.selected_dish == null:
			_set_name_frame_size()
			dish_name_frame.visible = true
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
			_set_name_frame_size()
			dish_name_frame.visible = true
			dish.select(dish.check_if_cookable(inventory.ingredients))
		else:
			magnified = true
		animation_player.play("selected")
