class_name MuzzleFlash extends OmniLight3D

@export var track_manager: TrackManager
@export var max_flash: float = 9
@export var flash_duration: float = 0.1


func _ready():
	track_manager.connect("shoot", flash)


func flash():
	var flash_tween = create_tween()
	flash_tween.tween_property(self, "light_energy", max_flash, flash_duration)
	await flash_tween.finished
	light_energy = 0
