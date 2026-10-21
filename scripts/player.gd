extends CharacterBody2D
class_name Player
@onready var bubble: AnimatedSprite2D = $bubble
@onready var light: PointLight2D = $PointLight2D
@onready var camera: Camera2D = $Camera2D
@onready var audio_controller: Node = $AudioController
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $Label
@onready var ray: RayCast2D = $RayCast2D
@onready var line: Line2D = $RayCast2D/Line2D
@onready var animator: AnimatedSprite2D = $Sprite2D
@onready var float_timer: Timer = $float_timer

@export var speed = 100
@export var jump_velocity = -250.0
var temp_vel
var status = "VISIBLE"
var collected_gears = 0
@onready var reloading:bool = false

func _ready() -> void:
	animator.play("idle")

	flicker()

	#teleport to last checkpoint
	if autoLoad.respawn != null:
		position = autoLoad.respawn

func _physics_process(delta: float) -> void:
	#gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	if status != "DEAD":

		#movement control
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = jump_velocity
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction == -1 and animator.animation != "shoot":
			animator.flip_h = true
		elif direction == 1 and animator.animation != "shoot":
			animator.flip_h = false
		if direction and status != "FLOATING" and animator.animation != "shoot":
			velocity.x = direction * speed
			if is_on_floor():
				audio_controller.play_audio("run")
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

		#other controls
		if Input.is_action_just_pressed("fire") and reloading != true:
			shoot(delta)	
		if Input.is_action_just_pressed("use"):
					if status == "FLOATING":
						float_timer.stop()
						status = "VISIBLE"
						bubble.play("pop")
						await  bubble.animation_finished
						bubble.visible = false
					elif is_on_floor():
						temp_vel = velocity.x/10
						is_floating(delta)
						
		if status == "FLOATING":
					velocity = Vector2(temp_vel,(-get_gravity().y-200)*delta)
		if is_on_floor() and velocity.x != 0:
			animator.play("run")
		elif is_on_floor() and velocity.x == 0 and animator.animation != "shoot":
			animator.play("idle")

	#death
	else:
		bubble.visible = false
		if is_on_floor():
			animator.play("death")
			set_physics_process(false)
			await animator.animation_finished
			get_tree().reload_current_scene()
			return

	move_and_slide()

#functions
func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "grass" and status !="DEAD":
		animator.modulate = Color(0.4,0.4,0.4,1)
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(light,"energy",0.05,0.2)
		tween.tween_property(light,"texture_scale",0.5,0.2)
		status = "HIDDEN"
func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "grass" and status != "DEAD":
		animator.modulate = Color(1,1,1,1)
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(light,"energy",0.2,0.2)
		tween.tween_property(light,"texture_scale",1,0.2)
		if status != "FLOATING":
			status = "VISIBLE"
func reload():
	reloading = true
	label.text = ""
	await get_tree().create_timer(1).timeout
	reloading = false
	label.text = ""
func is_floating(delta:float):
	status = "FLOATING"
	float_timer.start(5)
	bubble.play("default")
	bubble.visible = true
	await float_timer.timeout
	bubble.play("pop")
	await  bubble.animation_finished
	bubble.visible = false
	if status != "DEAD":
		status = "VISIBLE"
func _on_head_hurt_box_body_entered(body: Node2D) -> void:
	if body is Box and body.linear_velocity.y > 10:
		collision.queue_free()
		status = "DEAD"
	if body is Hazard:
		status = "DEAD"
func flicker():
	light.texture_scale = light.texture_scale * 0.99
	await get_tree().create_timer(0.25).timeout
	light.texture_scale = light.texture_scale * 1.01
	await get_tree().create_timer(0.25).timeout
	flicker()
func shoot(delta):
	velocity.x = 0
	var crosshair = get_tree().get_first_node_in_group("crosshair")
	crosshair.play("shot")
	audio_controller.play_audio("shoot")
	animator.play("shoot")
	ray.enabled = true
	ray.target_position = ray.get_local_mouse_position().normalized() * 10000
	ray.force_raycast_update()
	var target = ray.target_position
	if ray.is_colliding():
		target = to_local(ray.get_collision_point())
		var collider = ray.get_collider()
		if collider is Enemy:
			collider.is_floating(delta)
		elif collider is Box:
			collider.is_floating()
	line.set_point_position(1,target)
	line.default_color = Color.GRAY
	await get_tree().create_timer(0.03).timeout
	ray.enabled = false
	reload()
	line.default_color= Color(1,1,1,0)
	await animator.animation_finished
	animator.play("idle")
