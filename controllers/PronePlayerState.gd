class_name PronePlayerState extends PlayerMovementState

@export var SPEED: float = 1.5
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25
@export_range(1, 6, 0.1) var PRONE_SPEED: float = 2.5

@onready var CROUCH_SHAPECAST: ShapeCast3D = %ShapeCast3D

var RELEASED: bool = false

func enter(previous_state) -> void:
	ANIMATION.speed_scale = 1.0
	#if previous_state.name != "SlidingPlayerState":
		#ANIMATION.play("Crouching", -1.0, PRONE_SPEED)
	if previous_state.name == "IdlePlayerState":
		#pass
		#ANIMATION.current_animation = "Proning"
		ANIMATION.play("Proning", -1.0, PRONE_SPEED)


func exit() -> void:
	pass

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()

	if Input.is_action_just_pressed("prone"):
		unprone()
	#elif Input.is_action_pressed("crouch") == false and RELEASED == false:  # When not holding crouch, set crouch_released to true. Then trigger unprone.
		#RELEASED = true
		#unprone()


func unprone():
	ANIMATION.play("Proning",-1.0,-PRONE_SPEED*1.4,true)
	if ANIMATION.is_playing():
		await ANIMATION.animation_finished
	transition.emit("IdlePlayerState")
	#if CROUCH_SHAPECAST.is_colliding() == false and Input.is_action_pressed("crouch") == false:
		#ANIMATION.play("Crouching", -1.0, -PRONE_SPEED * 1.5, true)
		#if ANIMATION.is_playing():
			#await ANIMATION.animation_finished
		#transition.emit("IdlePlayerState")
	#elif CROUCH_SHAPECAST.is_colliding() == true:
		#await get_tree().create_timer(0.1).timeout
		#unprone()
