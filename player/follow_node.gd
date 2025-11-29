extends Node3D

@export var lerp_speed = 3.0
@export var target: Node3D
@export var offset := Vector3.ZERO
@export var pos_min := -Vector3.ONE
@export var pos_max := Vector3.ONE

func _physics_process(delta):
	if !target:
		return
	
	var target_xform = target.global_transform.translated_local(offset)
	global_transform = global_transform.interpolate_with(target_xform, lerp_speed * delta)
	
	global_position = global_position.clamp(
		target.global_position + pos_min,
		target.global_position + pos_max,
	)
	
	if global_transform.origin != target.global_transform.origin:
		look_at(target.global_transform.origin, target.transform.basis.y)
