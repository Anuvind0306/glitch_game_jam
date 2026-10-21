extends Node2D
@onready var sprite: AnimatedSprite2D = $Sprite2D
var is_active:bool = false
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	sprite.play("disabled")

	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and is_active == false:
		autoLoad.last_checkpoint = autoLoad.current_checkpoint
		autoLoad.current_checkpoint = self
		if autoLoad.last_checkpoint != null:
			autoLoad.last_checkpoint.disable()
		autoLoad.respawn = Vector2(position.x+16,position.y)
		audio.play(0)
		is_active = true
		sprite.play("trigger")
		await sprite.animation_finished
		sprite.play("activated")

func disable():
	is_active = false
	sprite.play("disabled")
