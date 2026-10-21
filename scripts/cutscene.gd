extends Node2D
@onready var label: RichTextLabel = $Label
var last_character_count = 0
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	modulate = Color.BLACK
	tween.tween_property(self,"modulate",Color.WHITE,1)
	tween.tween_interval(1)
	tween.tween_property(label,"visible_characters",8,0.5)
	tween.tween_interval(1)
	tween.tween_property(label,"visible_characters",52,2.75)
	tween.tween_interval(0.5)
	tween.tween_property(label,"visible_characters",86,2.125)
	tween.tween_interval(0.5)
	tween.tween_property(label,"visible_characters",97,0.6875)
	tween.tween_interval(0.5)
	tween.tween_property(label,"visible_characters",115,1.125)
	tween.tween_interval(0.5)
	tween.tween_property(label,"visible_characters",125,0.5625)
	tween.tween_interval(2)
	tween.tween_property(self,"modulate",Color.BLACK,1)
	await get_tree().create_timer(16.25).timeout
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _process(delta: float) -> void:
	if label.visible_characters > last_character_count:
		last_character_count = label.visible_characters
		audio.pitch_scale = randf_range(0.8,1.2)
		audio.play(0)
