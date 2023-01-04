extends ColorRect
class_name Transition

signal transition_finished


func _ready():
	set_ratio()
	connect("resized", set_ratio)
	fade_in()
	
	
func set_ratio():
	var ratio = Vector2(1.0, 1.0)
	var offset = Vector2(0.0, 0.0)
	if size.x > size.y:
		ratio.x = size.x / size.y
		offset.x = (ratio.x - 1.0) / 2.0
	else:
		ratio.y = size.y / size.x
		offset.y = (ratio.y - 1.0) / 2.0
	material.set_shader_parameter("offset", offset)
	material.set_shader_parameter("ratio", ratio)


func fade_in():
	var t = create_tween()
	t.tween_property(material, "shader_parameter/scale", 0.2, 0.2).from(0.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	t.tween_property(material, "shader_parameter/scale", 4.0, 0.5).from(0.15).set_delay(0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	await t.finished
	emit_signal("transition_finished")
	
	
func fade_out():
	var t = create_tween()
	t.set_parallel(true)
	t.tween_property(material, "shader_parameter/rotation", 0.0, 1.5).from(TAU).set_trans(Tween.TRANS_SINE)
	t.tween_property(material, "shader_parameter/scale", 0.0, 1.5).from(4.0).set_trans(Tween.TRANS_SINE)
	await t.finished
	emit_signal("transition_finished")
