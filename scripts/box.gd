extends RigidBody2D
class_name Box
@onready var bubble: AnimatedSprite2D = $bubble


func is_floating():
	gravity_scale = -0.1
	bubble.play("default")
	bubble.visible = true
	await get_tree().create_timer(5).timeout
	bubble.play("pop")
	await bubble.animation_finished
	bubble.visible = false
	gravity_scale = 1
	
