extends Node2D

class_name Category

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var category_name: Label = $CategoryName

var has_selected_dish : bool

func _ready() -> void:
	category_name.text = name
	has_selected_dish = false


func _on_category_sprite_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		get_parent().pick_category(self)


func _on_category_sprite_mouse_entered() -> void:
	animation_player.play("magnify")


func _on_category_sprite_mouse_exited() -> void:
	animation_player.play_backwards("magnify")
