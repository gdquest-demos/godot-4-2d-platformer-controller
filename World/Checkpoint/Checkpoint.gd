extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var particles: GPUParticles2D = $GPUParticles2D

var active := false : set = _set_active


func _ready() -> void:
	connect("body_entered", _on_body_entered)


func _set_active(value : bool):
	if active == value: return
	active = value
	var tween := create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.2,0.8), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2(0.8,1.2), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ONE, 0.15)
	if value: 
		particles.emitting = true
		sprite.play("wind")
	else: sprite.play("default")


func _on_body_entered(body: Node2D) -> void:
	_set_active(true)
	body.set_respawn_position(global_position) # To do: use signal (?)
