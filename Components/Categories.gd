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
			show_children(curries)
			salads.modulate.a = 0.5
			hide_children(salads)
			desserts.modulate.a = 0.5
			hide_children(desserts)
		salads:
			curries.modulate.a = 0.5
			hide_children(curries)
			salads.modulate.a = 1.0
			show_children(salads)
			desserts.modulate.a = 0.5
			hide_children(desserts)
		desserts:
			curries.modulate.a = 0.5
			hide_children(curries)
			salads.modulate.a = 0.5
			hide_children(salads)
			desserts.modulate.a = 1.0
			show_children(desserts)


func _on_curries_stews_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		pick_category(curries)


func _on_desserts_drinks_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		pick_category(desserts)


func _on_salads_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		pick_category(salads)


func hide_children(category):
	for child in category.get_children():
		child.visible = false
		

func show_children(category):
	for child in category.get_children():
		child.visible = true
