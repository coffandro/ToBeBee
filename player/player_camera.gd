extends Node3D

@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
@export_range(0.0, 1.0) var rot_speed = 1.5
@export_range(0.0, 1.0) var rot_lerp = 0.5
@export var tilt_limit = deg_to_rad(55)
@export var target: Node3D

var _camera_input_direction := Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	):
		_camera_input_direction = event.screen_relative * mouse_sensitivity * Vector2(-1, 0)

func _physics_process(delta: float) -> void:
	var raw_input := Input.get_vector("rotate_right", "rotate_left", "rotate_up", "rotate_down")
	
	if raw_input != Vector2.ZERO:
		_camera_input_direction = raw_input
	
	rotation.x -= _camera_input_direction.y * rot_speed * delta
	rotation.x = clampf(rotation.x, -tilt_limit, tilt_limit)
	rotation.y += _camera_input_direction.x * rot_speed * delta
	
	_camera_input_direction = Vector2.ZERO
	
	rotation.x = fmod(rotation.x, PI*2)
	rotation.y = fmod(rotation.y, PI*2)
	
	var move_input := Input.get_vector("move_left", "move_right", "move_down", "move_up")
	
	if _camera_input_direction == Vector2.ZERO && move_input == Vector2.ZERO:
		rotation.x = lerp_angle(rotation.x, target.rotation.x, rot_lerp * delta)
		rotation.y = lerp_angle(rotation.y, target.rotation.y, rot_lerp * delta)
