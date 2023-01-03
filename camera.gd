extends Camera2D

@export var target :  Node2D
@export var path :  Path2D
@export var influence_max_distance = 80.0

var _closest_points : Vector2

func _ready():
	global_position = target.global_position

func _process(delta):
	_closest_points = path.curve.get_closest_point(target.global_position)
	var dist_to_closest_point = clamp(target.global_position.distance_to(_closest_points), 0.0, influence_max_distance)
	var influence = remap(dist_to_closest_point, 0.0, influence_max_distance, 1.0, 0.0)
	global_position = lerp(target.global_position, _closest_points, influence)
