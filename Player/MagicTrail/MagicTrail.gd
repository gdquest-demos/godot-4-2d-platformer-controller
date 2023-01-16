extends Line2D
class_name MagicTrail

const POINTS_COUNT := 10

@export var time_curve: Curve

var is_active := false : set = set_active
var _points_global: PackedVector2Array = []

@onready var _particles = $GPUParticles2D


func _ready() -> void:
	set_active(false)
	_reset_points()


func _process(delta: float) -> void:
	var points_local := []
	for i in POINTS_COUNT:
		_points_global[i] = lerp(_points_global[i], global_position, time_curve.sample(remap(i, 0, POINTS_COUNT, 1.0, 0.0)))
		points_local.append(to_local(_points_global[i]))
	points = points_local


func set_active(value: bool) -> void:
	if is_active == value:
		return
	
	is_active = value
	_particles.emitting = is_active
	
	var tween = create_tween()
	if is_active:
		tween.tween_property(self, "modulate:a", 1.0, 0.1)
	else:
		tween.tween_property(self, "modulate:a", 0.0, 0.5)
		await tween.finished
		if not is_active:
			_reset_points()


func _reset_points() -> void:
	points = []
	_points_global = []
	for i in POINTS_COUNT:
		_points_global.append(global_position)
		add_point(Vector2.ZERO)
