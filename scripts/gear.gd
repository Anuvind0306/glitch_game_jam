extends AnimatedSprite2D

@onready var light: PointLight2D = $PointLight2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if autoLoad.gears.has(self.name):
		self.queue_free()
	flicker()
	
func flicker():
	light.texture_scale = light.texture_scale * 0.99
	await get_tree().create_timer(0.25).timeout
	light.texture_scale = light.texture_scale * 1.01
	await get_tree().create_timer(0.25).timeout
	flicker()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		audio.play(0)
		play("collected")
		autoLoad.collected_gears = autoLoad.collected_gears + 1
		autoLoad.gears.append(self.name)
		await animation_finished
		queue_free()
