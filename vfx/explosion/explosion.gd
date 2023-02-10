extends Node2D

signal finished

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sparkes : GPUParticles2D = $Sparkes

func _ready():
	var animations: Array = sprite.sprite_frames.get_animation_names()
	sprite.play(animations.pick_random())
	sparkes.emitting = true
	await sprite.animation_finished
	sprite.queue_free()
	emit_signal("finished")
	await get_tree().create_timer(5.0).timeout
	queue_free()
