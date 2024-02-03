class_name TrackManager extends Node

@export var FRONT_TRACK_STREAM_PLAYER: AudioStreamPlayer
@export var BACKING_TRACK_STREAM_PLAYER: AudioStreamPlayer

var tempo: float = 0.0


func _ready():
	BACKING_TRACK_STREAM_PLAYER.play()


func _process(delta):
	tempo = 1.2
	FRONT_TRACK_STREAM_PLAYER.pitch_scale = tempo
	BACKING_TRACK_STREAM_PLAYER.pitch_scale = tempo


func _input(event):
	if Input.is_action_just_pressed("shoot"):
		print("pressed")
		var current_playback_position = BACKING_TRACK_STREAM_PLAYER.get_playback_position()
		FRONT_TRACK_STREAM_PLAYER.play(current_playback_position)
		BACKING_TRACK_STREAM_PLAYER.stop()
		print(FRONT_TRACK_STREAM_PLAYER.get_playback_position())
	elif Input.is_action_just_released("shoot"):
		print("released")
		var current_playback_position = FRONT_TRACK_STREAM_PLAYER.get_playback_position()
		print(current_playback_position)
		BACKING_TRACK_STREAM_PLAYER.play(current_playback_position)
		FRONT_TRACK_STREAM_PLAYER.stop()
		print(BACKING_TRACK_STREAM_PLAYER.get_playback_position())
