extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var particles = $GPUParticles2D

var active = false : set = _set_active

func _set_active(value : bool):
	var t = create_tween()
	t.tween_property(sprite, "scale", Vector2(1.2,0.8), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	t.tween_property(sprite, "scale", Vector2(0.8,1.2), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	t.tween_property(sprite, "scale", Vector2.ONE, 0.15)
	if value: 
		particles.emitting = true
		sprite.play("wind")
	else: sprite.play("default")
