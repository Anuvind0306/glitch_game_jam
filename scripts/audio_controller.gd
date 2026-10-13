extends Node2D
@onready var run: AudioStreamPlayer2D = $run
@onready var shoot: AudioStreamPlayer2D = $shoot
@onready var alert: AudioStreamPlayer2D = $alert
func play_audio(name:String):
	match name:
		"run":
			if run.playing == false:
				run.pitch_scale = randf_range(0.3,0.4)
				run.play(0)
		"shoot":
			shoot.play(0)
		"alert":
			alert.play(0)
