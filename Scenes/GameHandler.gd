extends Node2D

func _process(delta: float) -> void:
	check_quit()
	

func check_quit():
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
