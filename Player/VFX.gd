extends Node2D
class_name VFX

signal explosion_finished

@export var explosion_scene: PackedScene


func spawn_explosion() -> void:
	var explosion: Node2D = explosion_scene.instantiate()
	get_tree().get_root().call_deferred("add_child", explosion)
	explosion.global_position = global_position
	await explosion.finished
	emit_signal("explosion_finished")
