extends Line2D
class_name MagicTrail

@export var time_curve: Curve 

# point in global space
var p_g: PackedVector2Array = []
var resolution := 10
var _is_active = null : set = set_active

@onready var particles = $GPUParticles2D


func _ready() -> void:
	set_active(false)
	_reset_points()

func _process(delta: float) -> void:
	var local_p : PackedVector2Array = []
	for i in resolution:
		p_g[i] = lerp(p_g[i], global_position, time_curve.sample(remap(i, 0, resolution, 1.0, 0.0)))
		local_p.append(to_local(p_g[i]))
	points = local_p


func set_active(value) -> void:
	if _is_active == value: 
		return
	
	_is_active = value
	particles.emitting = _is_active
	
	var t = create_tween()
	if _is_active:
		t.tween_property(self, "modulate:a", 1.0, 0.1)
	else:
		t.tween_property(self, "modulate:a", 0.0, 0.5)
		await t.finished
		if !_is_active:
			_reset_points()

func _reset_points() -> void:
	points = []
	p_g = []
	for i in resolution:
		p_g.append(global_position)
		add_point(Vector2.ZERO)
