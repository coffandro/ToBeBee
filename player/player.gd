extends CharacterBody3D


@export_group("Movement")
@export var move_speed := 8.0
@export var acceleration := 20.0
@export var rotation_speed := 12.0
@export var jump_impulse := 2.0
@export var max_jump := 12.0

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 8.0

var _last_movement_direction := Vector3.BACK
var _gravity := -30.0

@onready var _mesh: Node3D = $MeshPivot

func _physics_process(delta: float) -> void:
	var raw_input := Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	var move_direction := transform.basis.z * raw_input.y + transform.basis.x * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()

	var y_velocity := velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	velocity.y = y_velocity + _gravity * delta

	if Input.is_action_pressed("jump"):
		velocity.y = min(velocity.y + jump_impulse, max_jump)

	move_and_slide()

	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_mesh.global_rotation.y = lerp_angle(_mesh.rotation.y, target_angle, rotation_speed * delta)

	#if is_starting_jump:
		#_mesh.jump()
	#elif not is_on_floor() and velocity.y < 0:
		#_mesh.fall()
	#elif is_on_floor():
		#var ground_speed := velocity.length()
		#if ground_speed > 0.0:
		#	_mesh.move()
		#else:
		#	_mesh.idle()
