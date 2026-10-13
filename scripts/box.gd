extends RigidBody2D
class_name Box
@onready var bubble: Sprite2D = $bubble


func is_floating():
	gravity_scale = -0.1
	bubble.visible = true
	await get_tree().create_timer(5).timeout
	bubble.visible = false
	gravity_scale = 1
	
