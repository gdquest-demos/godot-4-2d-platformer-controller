extends Line2D

# point in global space
var p_g : PackedVector2Array = []
var resolution = 10
@export var time_curve : Curve 
@onready var particles = $GPUParticles2D

var _is_active = null : set = set_active

func set_active(value):
	if _is_active == value: return
	_is_active = value
	particles.emitting = _is_active
	var t = create_tween()
	if _is_active:
		set_process(true)
		_reset_points()
		t.tween_property(self, "modulate:a", 1.0, 0.1)
	else:
		t.tween_property(self, "modulate:a", 0.0, 0.5).set_delay(0.2)
		await t.finished
		set_process(false)
func _ready():
	set_active(false)
	_reset_points()

func _reset_points():
	points = []
	p_g = []
	for i in resolution:
		p_g.append(global_position)
		add_point(Vector2.ZERO)
		
func _process(delta):
	var local_p : PackedVector2Array = []
	for i in resolution:
		p_g[i] = lerp(p_g[i], global_position, time_curve.sample(remap(i, 0, resolution, 1.0, 0.0)))
		local_p.append(to_local(p_g[i]))
	points = local_p

