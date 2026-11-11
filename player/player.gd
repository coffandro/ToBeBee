class_name Player extends CharacterBody3D

@export var _camera: Camera3D
@onready var _mesh: Node3D = $MeshPivot

@export_group("Movement")
@export var move_speed := 8.0
@export var acceleration := 20.0
@export var rotation_speed := 12.0
@export var jump_impulse := 2.0
@export var max_jump := 12.0

var _last_movement_direction := Vector3.BACK
var _gravity := -30.0

@export_group("Collection")
@onready var collect_prompt: Control = $CameraPivot/SpringArm3D/Camera3D/HUD/CollectionPrompt
@export var collect_label: Label

@export_group("Energy")
@export var energy_bar: ProgressBar
@export var max_energy: int = 100
@export var energy_gain: int = 1
@export var energy_loss: int = 1
var energy

var current_flower: Flower = null
var pollen: int = 0

func _ready() -> void:
	collect_prompt.hide()
	energy = max_energy
	energy_bar.max_value = max_energy

func set_flower(flower) -> void:
	current_flower = flower
	if current_flower:
		collect_prompt.show()
	else:
		collect_prompt.hide()

func update_pollen(new_pollen: int) -> void:
	pollen += new_pollen
	collect_label.text = "Collected: " + str(pollen)
	collect_prompt.hide()

func update_energy(energy_mod: int) -> void:
	energy += energy_mod
	energy = clamp(energy, 0, max_energy)
	energy_bar.value = energy

func _physics_process(delta: float) -> void:
	var raw_input := Input.get_vector("move_left", "move_right", "move_down", "move_up")
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	var y_velocity := velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	velocity.y = y_velocity + _gravity * delta
	
	if Input.is_action_pressed("jump"):
		if energy > 0:
			velocity.y = min(velocity.y + jump_impulse, max_jump)
			update_energy(-energy_loss)
	elif is_on_floor():
		update_energy(energy_gain)
	
	move_and_slide()
	
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_mesh.global_rotation.y = lerp_angle(_mesh.rotation.y, target_angle, rotation_speed * delta)
	
	if Input.is_action_just_pressed("collect") and current_flower != null:
		update_pollen(current_flower.pollen)
		current_flower.empty_pollen()
