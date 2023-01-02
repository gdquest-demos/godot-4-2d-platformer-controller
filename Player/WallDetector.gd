extends Marker2D
class_name WallDetector

@onready var ray_cast_top: RayCast2D = $RayCastTop
@onready var ray_cast_bottom: RayCast2D = $RayCastBottom


func set_direction(value: float) -> void:
	if value != 0:
		scale.x = sign(value)


func get_direction() -> float:
	return sign(scale.x)


func set_enabled(value: bool) -> void:
	ray_cast_top.enabled = value
	ray_cast_bottom.enabled = value


func is_against_wall() -> bool:
	ray_cast_top.force_raycast_update()
	ray_cast_bottom.force_raycast_update()
	return ray_cast_top.is_colliding() or ray_cast_bottom.is_colliding()
