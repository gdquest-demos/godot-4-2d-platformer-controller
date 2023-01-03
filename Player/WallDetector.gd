extends Marker2D
class_name WallDetector

@onready var _ray_cast_top: RayCast2D = $RayCastTop
@onready var _ray_cast_bottom: RayCast2D = $RayCastBottom


func set_direction(value: float) -> void:
	if value != 0:
		scale.x = sign(value)


func get_direction() -> float:
	return sign(scale.x)


func set_enabled(value: bool) -> void:
	_ray_cast_top.enabled = value
	_ray_cast_bottom.enabled = value


func is_against_wall() -> bool:
	_ray_cast_top.force_raycast_update()
	_ray_cast_bottom.force_raycast_update()
	return _ray_cast_top.is_colliding() or _ray_cast_bottom.is_colliding()
