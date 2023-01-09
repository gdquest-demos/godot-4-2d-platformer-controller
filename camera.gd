extends Camera2D

@export var target :  Node2D
@export var path :  Path2D
@export var influence_max_distance = 80.0
@export var rect_limit : Node2D

var _closest_points : Vector2

@export var _min_tiles_count : int = 10
var _tiles_size = 16
@onready var _min_size_ratio = _min_tiles_count * _tiles_size

func _ready():
	global_position = target.global_position
	get_viewport().connect("size_changed", check_ratio)
	check_ratio()
	
	if rect_limit:
		var half_size = rect_limit.size / 2.0
		var limit_offset = global_position - rect_limit.global_position
		limit_left = -half_size.x - limit_offset.x
		limit_right = half_size.x - limit_offset.x
		limit_top = -half_size.y - limit_offset.y
		limit_bottom = half_size.y - limit_offset.y
	
	
func _process(delta):
	_closest_points = path.curve.get_closest_point(target.global_position)
	var dist_to_closest_point = clamp(target.global_position.distance_to(_closest_points), 0.0, influence_max_distance)
	var influence = remap(dist_to_closest_point, 0.0, influence_max_distance, 1.0, 0.0)
	global_position = lerp(target.global_position, _closest_points, influence)

func check_ratio():
	var viewport_size = get_viewport_rect().size
	var min_length = min(viewport_size.x, viewport_size.y)
	zoom = Vector2.ONE * round(min_length / _min_size_ratio)
