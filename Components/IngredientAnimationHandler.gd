extends Node

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"


func _on_ingredient_sprite_mouse_entered() -> void:
	animation_player.play("magnify")


func _on_ingredient_sprite_mouse_exited() -> void:
	animation_player.play_backwards("magnify")
