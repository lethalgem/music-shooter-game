class_name TrackManager extends Node

@export var FRONT_TRACK_STREAM_PLAYER: AudioStreamPlayer
@export var BACKING_TRACK_STREAM_PLAYER: AudioStreamPlayer
@export var MINIMUM_TEMPO: float = 0.35
@export var MAXIMUM_TEMPO: float = 1.2

var tempo: float = MINIMUM_TEMPO


func _ready():
	BACKING_TRACK_STREAM_PLAYER.play()


func _process(delta):
	Global.debug.add_property("Tempo", "%.2f" % tempo, 2)
	# velocity can be between 0 and 7.0 right now
	var velocity = Global.player.velocity.length()
	var rate_of_tempo
	if velocity == 7:
		rate_of_tempo = .15
	else:
		rate_of_tempo = 1.2 / velocity
	if velocity == 0:
		tempo = (velocity + 1) * 0.35
	else:
		tempo = (velocity + 1) * rate_of_tempo
	#tempo = 0.12143 * velocity + 0.35
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
