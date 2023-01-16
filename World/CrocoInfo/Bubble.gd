extends MarginContainer

var _current_target  : Node2D = null
@onready var label = $MarginContainer/Label

var active = false
var _half_size = Vector2.ONE

func _ready():
	hide()
	set_process(false)
	_set_font_size()

func open(target : Node2D):
	active = true
	_current_target = target
	set_process(true)
	show()
	
func write(line : String):
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.1).from(Vector2.ONE * 0.9).set_trans(Tween.TRANS_BACK)
	label.text = line
	# Need to reset size so main container shrinks back?
	size = Vector2.ZERO
	
func close():
	active = false
	set_process(false)
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 0.6, 0.1).from(Vector2.ONE).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	await tween.finished
	if !active: hide()

func _process(_delta):
	position = _current_target.get_global_transform_with_canvas().origin - (_half_size)

func _on_resized():
	_set_font_size()
	_half_size = size / 2
	pivot_offset = _half_size
	
func _set_font_size():
	if !label: return
	var viewport_size = get_viewport_rect().size
	var min_size = min(viewport_size.x, viewport_size.y)
	label.set("theme_override_font_sizes/font_size", min_size * 0.035)
