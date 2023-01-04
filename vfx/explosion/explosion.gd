extends Node2D

@onready var sprite = $AnimatedSprite2D

func _ready():
	var animations : Array = sprite.frames.get_animation_names()
	sprite.play(animations.pick_random())
	await sprite.animation_finished
	queue_free()
