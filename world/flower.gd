class_name Flower extends Node3D

@export var pollen: int = 10
@export var particles: GPUParticles3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		body.set_flower(self)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		body.set_flower(null)

func empty_pollen() -> void:
	particles.emitting = false
	pollen = 0
