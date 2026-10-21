extends Button
@onready var audio: AudioStreamPlayer2D = $"../../../AudioStreamPlayer2D"



func _on_pressed() -> void:
	audio.play(0)
	await  audio.finished
	get_tree().change_scene_to_file("res://scenes/cutscene.tscn")
