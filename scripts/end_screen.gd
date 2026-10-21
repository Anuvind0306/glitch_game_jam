extends Node2D
@onready var label: Label = $Label
@onready var scene: AnimatedSprite2D = $AnimatedSprite2D
@onready var exit_button: Button = $HBoxContainer/exit_button

func _ready() -> void:
	scene.visible = false
	modulate = Color.BLACK
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color.WHITE,3)
	await  tween.finished
	scene.visible = true
	scene.play("opening")
	await scene.animation_finished
	scene.play("loop")
	await get_tree().create_timer(0.5).timeout
	while label.modulate.a <1:
		label.modulate.a = move_toward(label.modulate.a,1.0,0.2)
		await get_tree().create_timer(0.5).timeout
	while exit_button.modulate.a <1:
		exit_button.modulate.a = move_toward(exit_button.modulate.a,1.0,0.5)
		await get_tree().create_timer(0.5).timeout
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_exit_button_pressed() -> void:
	get_tree().quit()
