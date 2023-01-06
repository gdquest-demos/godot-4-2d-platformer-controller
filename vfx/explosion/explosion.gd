extends Node2D

signal finished

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	var animations: Array = sprite.frames.get_animation_names()
	sprite.play(animations.pick_random())
	await sprite.animation_finished
	emit_signal("finished")
	queue_free()
