class_name TrackManager extends Node

@export var FRONT_TRACK_STREAM_PLAYER: AudioStreamPlayer
@export var BACKING_TRACK_STREAM_PLAYER: AudioStreamPlayer

signal shoot

var released: bool = true
var shoot_times: Array[int] = []


func _ready():
	var interval = 236000 / 2240
	for i in range(1, 2240):
		shoot_times.append((interval * i) / 10)
	print(shoot_times)
	BACKING_TRACK_STREAM_PLAYER.play()


func _process(delta):
	var current_song_millis: int
	if released:
		current_song_millis = int(BACKING_TRACK_STREAM_PLAYER.get_playback_position() * 1000) / 10
	else:
		current_song_millis = int(FRONT_TRACK_STREAM_PLAYER.get_playback_position() * 1000) / 10

	print(current_song_millis)
	if shoot_times.has(current_song_millis) and !released:
		shoot.emit()


func _unhandled_input(event):
	if Input.is_action_just_pressed("shoot"):
		print("pressed")
		if released:
			var current_playback_position = BACKING_TRACK_STREAM_PLAYER.get_playback_position()
			FRONT_TRACK_STREAM_PLAYER.play(current_playback_position)
			BACKING_TRACK_STREAM_PLAYER.stop()
			released = false
	elif Input.is_action_just_released("shoot"):
		print("released")
		if !released:
			var current_playback_position = FRONT_TRACK_STREAM_PLAYER.get_playback_position()
			BACKING_TRACK_STREAM_PLAYER.play(current_playback_position)
			FRONT_TRACK_STREAM_PLAYER.stop()
			released = true
