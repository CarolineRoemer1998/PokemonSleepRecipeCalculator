extends Label

@onready var animation_player_remove_amount: AnimationPlayer = $AnimationPlayerRemoveAmount
@onready var timer: Timer = $Timer

var amount : String = ""

func remove_amount():
	text = amount
	if text != "":
		animation_player_remove_amount.play("remove_amount")
		timer.start()

func destroy_self():
	queue_free()


func _on_timer_timeout() -> void:
	destroy_self()
