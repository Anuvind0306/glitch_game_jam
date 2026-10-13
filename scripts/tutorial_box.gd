extends RichTextLabel
@export_multiline() var string:String
@export var area_size:Vector2
@onready var area: CollisionShape2D = $Area2D/CollisionShape2D
func _ready() -> void:
	pass
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		text = string
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		self.queue_free()
