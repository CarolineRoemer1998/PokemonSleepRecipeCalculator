extends Node2D

class_name Ingredient

# ------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------

@onready var ingredient_sprite: TextureRect = $IngredientSprite
@onready var required_amount_label: Label = $RequiredAmountLabel
@onready var required_frame: Sprite2D = $RequiredFrame
@onready var selected_frame: Sprite2D = $SelectedFrame
@onready var amount_changer: AmountChanger = $AmountChanger
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var removedAmountLabel : PackedScene

var inventory : Inventory

# ------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------

func _ready() -> void:
	inventory = get_tree().get_first_node_in_group("inventory")
	required_frame.visible = false
	selected_frame.visible = false
	selected_frame.modulate = Globals.color_neutral


## Sets required-frame and label with amount and required amount for dish
## Frame is green if enough of the ingredients are available, red if not
func set_required(amount_in_stock, amount_required):
	if amount_in_stock >= amount_required:
		required_frame.modulate = Globals.color_green
	else:
		required_frame.modulate = Globals.color_red
	required_frame.visible = true
	required_amount_label.text = str(amount_in_stock, "/", amount_required)


## Removes required-frame and label
func remove_required_frame():
	required_frame.visible = false
	required_amount_label.text = ""


## Sets selected-frame's visibility to given boolean value
func set_selected_frame(value : bool):
	selected_frame.visible = value


func play_remove_amount_animation(amount : String):
	var amount_remover = removedAmountLabel.instantiate()
	amount_remover.amount = amount
	add_child(amount_remover)
	amount_remover.remove_amount()
	animation_player.play("remove_animation")
	

# ------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------

## When ingredient sprite is clicked, it is selected
## Dishes containing that ingredient are selected
func _on_ingredient_sprite_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		var last_selected = inventory.selected_ingredient
		inventory.selected_dish = null
		inventory.turn_off_all_ingredient_selected_frames()
		
		if last_selected == self:
			inventory.select_ingredient(null)
		else:
			inventory.select_ingredient(self)
			
		set_selected_frame(last_selected != self)
		inventory.update()
		inventory.cooking_pot.set_visibility()
		


