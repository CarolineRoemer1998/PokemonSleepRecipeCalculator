extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cooking_pot_sprite: TextureRect = $CookingPotSprite
@onready var cooking_pot_label: Label = $CookingPotLabel
@onready var inventory: Inventory = $"../Inventory"

var active : bool = false
var hovering : bool = false

func _ready() -> void:
	cooking_pot_sprite.modulate.a = Globals.modulate_disabled

func _on_cooking_pot_sprite_mouse_entered() -> void:
	if active:
		animation_player.play("magnify")
		hovering = true

func _on_cooking_pot_sprite_mouse_exited() -> void:
	if active:
		animation_player.play("demagnify")
		hovering = false

func show_label():
	cooking_pot_label.visible = true

func hide_label():
	cooking_pot_label.visible = false


func _on_cooking_pot_sprite_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click") and active:
		inventory.remove_ingredients_from_selected_recipe()

func set_visibility():
	if inventory.selected_dish != null and inventory.selected_dish.is_cookable:
		active = true
		cooking_pot_sprite.modulate.a = Globals.modulate_enabled
		cooking_pot_sprite.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	else:
		if hovering:
			animation_player.play("demagnify")
		active = false
		hovering = false
		cooking_pot_sprite.modulate.a = Globals.modulate_disabled
		cooking_pot_sprite.mouse_default_cursor_shape = Control.CURSOR_ARROW
		
