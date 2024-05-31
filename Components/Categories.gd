extends Node2D

@onready var curries: TextureRect = $"Curries&Stews"
@onready var salads: TextureRect = $Salads
@onready var desserts: TextureRect = $"Desserts&Drinks"

func _ready() -> void:
	pick_category(curries)
	
	
func pick_category(category):
	match category:
		curries:
			curries.modulate.a = 1.0
			salads.modulate.a = 0.5
			desserts.modulate.a = 0.5
		salads:
			curries.modulate.a = 0.5
			salads.modulate.a = 1.0
			desserts.modulate.a = 0.5
		desserts:
			curries.modulate.a = 0.5
			salads.modulate.a = 0.5
			desserts.modulate.a = 1.0


func _on_curries_stews_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		pick_category(curries)


func _on_desserts_drinks_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		pick_category(desserts)


func _on_salads_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		pick_category(salads)
