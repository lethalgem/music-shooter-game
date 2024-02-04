class_name TrackManager extends Node

@export var FRONT_TRACK_STREAM_PLAYER: AudioStreamPlayer
@export var BACKING_TRACK_STREAM_PLAYER: AudioStreamPlayer
@export var SHOOT_TIMES_SOURCE: String

signal shoot

var released: bool = true
var shoot_times = []
var current_shot_index: int = 0


func _ready():
	load_file()
	BACKING_TRACK_STREAM_PLAYER.play(0)


func load_file():
	var file = FileAccess.open(SHOOT_TIMES_SOURCE, FileAccess.READ)
	shoot_times = str_to_var(file.get_as_text())


func _process(delta):
	var current_song_millis: int
	if released:
		current_song_millis = int(BACKING_TRACK_STREAM_PLAYER.get_playback_position() * 1000)
	else:
		current_song_millis = int(FRONT_TRACK_STREAM_PLAYER.get_playback_position() * 1000)

	if (
		current_shot_index < shoot_times.size()
		and current_song_millis >= shoot_times[current_shot_index]
		and !released
	):
		shoot.emit()
		current_shot_index += 1


func _unhandled_input(event):
	if Input.is_action_just_pressed("shoot"):
		if released:
			var current_playback_position = BACKING_TRACK_STREAM_PLAYER.get_playback_position()
			FRONT_TRACK_STREAM_PLAYER.play(current_playback_position)
			BACKING_TRACK_STREAM_PLAYER.stop()
			released = false
	elif Input.is_action_just_released("shoot"):
		if !released:
			var current_playback_position = FRONT_TRACK_STREAM_PLAYER.get_playback_position()
			BACKING_TRACK_STREAM_PLAYER.play(current_playback_position)
			FRONT_TRACK_STREAM_PLAYER.stop()
			released = true
