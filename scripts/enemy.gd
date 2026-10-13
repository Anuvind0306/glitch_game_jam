extends CharacterBody2D
class_name Enemy
@onready var audio_controller: Node = $AudioController
@onready var collision: CollisionShape2D = $CollisionShape2D

@onready var bubble: Sprite2D = $bubble
@export var does_wander:bool = false
@export var wander_distance:Vector2
@export var wait_duration:float = 2
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var initial_pos = self.position
@onready var ray: RayCast2D = $RayCast2D
@onready var line: Line2D = $RayCast2D/Line2D
@onready var destination = initial_pos + wander_distance
@export var flip:bool
var status
var player

func _ready() -> void:
	animator.flip_h = flip
	player = get_tree().get_first_node_in_group("player")
	unalert()

func _physics_process(delta: float) -> void:
	if status != "FLOATING":
		bubble.visible = false
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor() and velocity.x != 0:
		audio_controller.play_audio("run")

	if status != "DEAD":
		line.set_point_position(1,ray.target_position)
		var player_pos = player.global_position
		var angle = rad_to_deg(get_angle_to(player_pos))
		var distance_to_player = (player_pos - self.global_position).length()
		var target = player_pos
		if distance_to_player < 150:
			if (animator.flip_h == false and abs(angle)<60) or (animator.flip_h == true and abs(angle)>120):
				ray.enabled = true
				ray.target_position =  target - ray.global_position
			else:
				ray.enabled = false
		else:
			ray.enabled = false
			
		if ray.is_colliding():
			line.set_point_position(1,to_local(ray.get_collision_point()))
			var collider = ray.get_collider()
			if collider is Player and collider.status == "VISIBLE":
				if status != "FLOATING":
					status = "ALERT"
				elif status == "FLOATING":
					alert_and_shoot()
					
			elif status == "ALERT":
				unalert() 
		match status:
			"WANDER":
				self.velocity = (destination- self.position).normalized() * 50
				flip_h()
				animator.play("run")
				if abs(destination.x - self.position.x) < 5:
					status = "IDLE"
					await get_tree().create_timer(wait_duration).timeout
					if destination == initial_pos:
						destination = initial_pos + wander_distance
					else:
						destination = initial_pos
					if status != "ALERT" and status != "FLOATING":
						status = "WANDER"
			"ALERT":
				self.velocity.x=0
				alert_and_shoot()
				unalert()
			"IDLE":
				velocity.x = 0
				animator.play("idle")
			"FLOATING":
				bubble.visible = true
				velocity.x = 0
				velocity.y += (-get_gravity().y-10)*delta
			"FALLING":
				if not is_on_floor():
					velocity += get_gravity() * delta
				else:
					unalert()
	else:
		if is_on_floor():
			collision.queue_free()
			animator.play("death")
			set_physics_process(false)
	move_and_slide()

func flip_h():
	if velocity.x > 0:
		animator.flip_h = false
	elif velocity.x < 0:
		animator.flip_h = true

func is_floating(delta:float):
	status = "FLOATING"
	await get_tree().create_timer(3).timeout
	if status != "DEAD":
		status = "FALLING"

func unalert():
	if does_wander == true:
		status = "WANDER"
	else: 
		status = "IDLE"

func _on_hurtbox_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Box and body.linear_velocity.y > 10:
			status = "DEAD"
	if body is Hazard:
		status = "DEAD"

func alert_and_shoot():
	if animator.animation != "alert" and animator.animation != "shoot":
		audio_controller.play_audio("alert")
		animator.play("alert")
		await animator.animation_finished
		audio_controller.play_audio("shoot")
		animator.play("shoot")
		line.default_color = Color.GRAY
		var collider = ray.get_collider()
		if collider is Player:
			collider.status = "DEAD"
		await get_tree().create_timer(0.04).timeout
		line.default_color = Color(1,1,1,0)
