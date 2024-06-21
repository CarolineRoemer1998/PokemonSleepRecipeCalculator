extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var inventory: Inventory = $"../Inventory"
@onready var cooking_time: Timer = $CookingTime

@onready var cooking_pot: TextureRect = $CookingPot
@onready var cooking_pot_lid: TextureRect = $CookingPot/CookingPotLid
@onready var cooking_pot_inside: TextureRect = $CookingPot/CookingPotInside
@onready var cooking_pot_label: Label = $CookingPotLabel

var active : bool = false
var hovering : bool = false

func _ready() -> void:
	cooking_pot.modulate.a = Globals.modulate_disabled
	cooking_pot_inside.visible = false

func show_label():
	cooking_pot_label.visible = true

func hide_label():
	cooking_pot_label.visible = false

func set_visibility():
	if inventory.selected_dish != null and inventory.selected_dish.is_cookable:
		active = true
		cooking_pot.modulate.a = Globals.modulate_enabled
		cooking_pot_inside.visible = true
		#cooking_pot.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	else:
		print(cooking_time.time_left)
		if cooking_time.time_left < 0.5:
			cooking_pot.modulate.a = Globals.modulate_disabled
			cooking_pot_inside.visible = false
			if hovering:
				animation_player.play("demagnify")
		cooking_pot.mouse_default_cursor_shape = Control.CURSOR_ARROW
		hide_label()
		active = false
		hovering = false


func _on_cooking_pot_mouse_entered() -> void:
	if active:
		animation_player.play("magnify")
		cooking_pot.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		hovering = true


func _on_cooking_pot_mouse_exited() -> void:
	if active and cooking_time.time_left == 0:
		animation_player.play("demagnify")
	hovering = false


func _on_cooking_pot_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click") and active and cooking_time.time_left == 0.0:
		cooking_pot.mouse_default_cursor_shape = Control.CURSOR_ARROW
		animation_player.play("cook")
		cooking_time.start()
		inventory.remove_ingredients_from_selected_recipe()


func _on_cooking_time_timeout() -> void:
	if !hovering:
		animation_player.play("demagnify")
		if !active:
			cooking_pot.modulate.a = Globals.modulate_disabled
			cooking_pot_inside.visible = false
	if hovering and active:
		cooking_pot.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
