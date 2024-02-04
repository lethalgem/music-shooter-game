class_name TrackManager extends Node

@export var FRONT_TRACK_STREAM_PLAYER: AudioStreamPlayer
@export var BACKING_TRACK_STREAM_PLAYER: AudioStreamPlayer

signal shoot

var released: bool = true


func _ready():
	BACKING_TRACK_STREAM_PLAYER.play()


func _unhandled_input(event):
	if Input.is_action_just_pressed("shoot"):
		print("pressed")
		if released:
			var current_playback_position = BACKING_TRACK_STREAM_PLAYER.get_playback_position()
			FRONT_TRACK_STREAM_PLAYER.play(current_playback_position)
			BACKING_TRACK_STREAM_PLAYER.stop()
			shoot.emit()
			released = false
	elif Input.is_action_just_released("shoot"):
		print("released")
		if !released:
			var current_playback_position = FRONT_TRACK_STREAM_PLAYER.get_playback_position()
			BACKING_TRACK_STREAM_PLAYER.play(current_playback_position)
			FRONT_TRACK_STREAM_PLAYER.stop()
			released = true
