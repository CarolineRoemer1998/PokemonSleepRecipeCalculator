extends Node

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var dish_name: Label = $"../DishName"

func _ready() -> void:
	dish_name.text = get_parent().name
	dish_name.visible = false


func _on_dish_sprite_mouse_entered() -> void:
	animation_player.play("magnify")
	dish_name.visible = true


func _on_dish_sprite_mouse_exited() -> void:
	animation_player.play_backwards("magnify")
	dish_name.visible = false


func _on_dish_sprite_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		animation_player.play_backwards("magnify")
	if Input.is_action_just_released("left_click"):
		animation_player.play("magnify")
