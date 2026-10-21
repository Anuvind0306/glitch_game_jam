extends AnimatedSprite2D
@onready var label: RichTextLabel = $Label
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
var icon = preload("uid://fxscpvtq10sa")
func _ready() -> void:
	label.text = "[img]res://assets/gear_icon.png[/img]" +"x"+ str(autoLoad.delivered_gears) + "/3"
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		label.visible = true
		if autoLoad.collected_gears > 0:
			await get_tree().create_timer(0.5).timeout
			audio.play(0)
			autoLoad.delivered_gears = autoLoad.delivered_gears + autoLoad.collected_gears
			autoLoad.collected_gears = 0
			label.text = "[img]res://assets/gear_icon.png[/img]" +"x"+ str(autoLoad.delivered_gears) + "/3"
		if autoLoad.delivered_gears ==3:
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_file("res://scenes/end_scene.tscn")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		label.visible = false
