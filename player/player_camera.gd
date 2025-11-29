extends Camera3D

@export var target: Node3D
@export var speed = 5.0

var target_node : Node

func _physics_process(delta):
	if target_node:
		var target_position = target_node.global_transform.origin
		global_transform.origin = global_transform.origin.lerp(target_position, speed * delta)
