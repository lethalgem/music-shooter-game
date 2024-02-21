class_name Player extends CharacterBody3D

@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25
@export var MOUSE_SENSITIVITY: float = 0.5
@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var CAMERA_CONTROLLER: Camera3D
@export var ANIMATIONPLAYER: AnimationPlayer
@export var CROUCH_SHAPECAST: Node3D
@export var WEAPON_HOLDER: Node3D
@export var WEAPON_SWAY_AMOUNT: float = 5
@export var WEAPON_TILT_AMOUNT: float = 1
@export var INVERT_WEAPON_SWAY: bool = false
@export var CAM_TILT_AMOUNT: float = 1

var _mouse_input: bool = false
var mouse_input: Vector2
var _mouse_rotation: Vector3
var _rotation_input: float
var _tilt_input: float
var _player_rotation: Vector3
var _camera_rotation: Vector3
var _current_rotation: float
var previous_vel: float = 0.0

var gravity = 12.0
var def_weapon_holder_pos: Vector3


func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()


func _ready():
	Global.player = self

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# add crouch check shapecast collision exception for CharacterBody3D node
	CROUCH_SHAPECAST.add_exception($".")

	def_weapon_holder_pos = WEAPON_HOLDER.position


func _unhandled_input(event):
	_mouse_input = (
		event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if _mouse_input:
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY
		mouse_input = event.relative


func _update_camera(delta):
	# Rotate camera using euler rotation
	_current_rotation = _rotation_input
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta

	_player_rotation = Vector3(0.0, _mouse_rotation.y, 0.0)
	_camera_rotation = Vector3(_mouse_rotation.x, 0.0, 0.0)

	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	CAMERA_CONTROLLER.rotation.z = 0.0

	global_transform.basis = Basis.from_euler(_player_rotation)

	_rotation_input = 0.0
	_tilt_input = 0.0


func _physics_process(delta):
	Global.debug.add_property("Velocity", "%.2f" % velocity.length(), 2)

	_update_camera(delta)

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	cam_tilt(input_dir.x, delta)
	weapon_tilt(input_dir.x, delta)
	weapon_sway(delta)
	weapon_bob(velocity.length(), delta)


func update_gravity(delta):
	velocity.y -= gravity * delta


func update_input(speed: float, acceleration: float, deceleration: float):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)


func update_velocity():
	move_and_slide()


func cam_tilt(input_x, delta):
	if CAMERA_CONTROLLER:
		CAMERA_CONTROLLER.rotation.z = lerp(
			CAMERA_CONTROLLER.rotation.z, -input_x * CAM_TILT_AMOUNT, 10 * delta
		)


func weapon_tilt(input_x, delta):
	if WEAPON_HOLDER:
		WEAPON_HOLDER.rotation.x = lerp(
			WEAPON_HOLDER.rotation.x, -input_x * WEAPON_TILT_AMOUNT * 10, 10 * delta
		)


func weapon_sway(delta):
	mouse_input = lerp(mouse_input, Vector2.ZERO, 10 * delta)
	WEAPON_HOLDER.rotation.z = lerp(
		WEAPON_HOLDER.rotation.z,
		mouse_input.y * WEAPON_TILT_AMOUNT * (-1 if INVERT_WEAPON_SWAY else 1),
		10 * delta
	)

	WEAPON_HOLDER.rotation.y = lerp(
		WEAPON_HOLDER.rotation.y,
		mouse_input.x * WEAPON_TILT_AMOUNT * (-1 if INVERT_WEAPON_SWAY else 1),
		10 * delta
	)


func weapon_bob(vel: float, delta):
	if WEAPON_HOLDER:
		var bob_amount: float = 0.01

		# Smooth the velocity change
		var smoothed_vel: float = lerp(previous_vel, vel, 0.01)
		previous_vel = smoothed_vel

		# Scale the bob frequency based on smoothed velocity
		var velocity_scaling: float = 0.002  # Adjust this scaling factor based on your game's visual preferences
		var bob_freq: float = abs(smoothed_vel) * velocity_scaling

		# Apply weapon bobs
		WEAPON_HOLDER.position.y = lerp(
			WEAPON_HOLDER.position.y,
			def_weapon_holder_pos.y + sin(Time.get_ticks_msec() * bob_freq) * bob_amount,
			10 * delta
		)
		WEAPON_HOLDER.position.x = lerp(
			WEAPON_HOLDER.position.x,
			def_weapon_holder_pos.x + sin(Time.get_ticks_msec() * bob_freq * 0.05) * bob_amount,
			10 * delta
		)
