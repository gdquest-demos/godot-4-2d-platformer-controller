extends Area2D
class_name DashZoneDector

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func enable() -> void:
	collision_shape.set_deferred("disabled", false)


func disable() -> void:
	collision_shape.set_deferred("disabled", true)
