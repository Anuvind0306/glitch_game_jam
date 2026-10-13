extends Node2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	modulate = Color.BLACK
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color.WHITE,1)
