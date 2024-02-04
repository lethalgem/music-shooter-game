class_name MuzzleFlash extends Node3D

@export var track_manager: TrackManager
@export var max_flash: float = 9
@export var flash_duration: float = 0.05
@export var muzzle_flash_light: OmniLight3D
@export var max_flash_size: Vector3 = Vector3(1, 1, 1)


func _ready():
	track_manager.connect("shoot", flash)


func flash():
	var flash_tween = create_tween().parallel()
	flash_tween.tween_property(muzzle_flash_light, "light_energy", max_flash, flash_duration)
	flash_tween.tween_property(self, "scale", max_flash_size, flash_duration)
	await flash_tween.finished
	muzzle_flash_light.light_energy = 0
	scale = Vector3.ZERO
