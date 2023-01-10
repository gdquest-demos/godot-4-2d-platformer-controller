extends Node2D
class_name PlayerSkin

signal animation_finished(anim_name)

@onready var _sprite_container: Marker2D = $SpriteContainer
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _animated_sprite: AnimatedSprite2D = $SpriteContainer/AnimatedSprite2D


func _ready() -> void:
	_animation_player.connect("animation_finished", _on_animation_finished)


func set_animation_speed(speed: float) -> void:
	play_animation(_animation_player.current_animation, speed)


func set_rainbow_intensity(value):
	_animated_sprite.material.set_shader_parameter("intensity", value)


func set_direction(x_input: float) -> void:
	if x_input != 0:
		_sprite_container.scale.x = sign(x_input)


func get_facing_direction() -> int:
	return sign(_sprite_container.scale.x)


func play_animation(animation_name: String, animation_speed: float = 1.0, from_position: Vector2 = Vector2.ZERO) -> void:
	if from_position != Vector2.ZERO:
		position = from_position
	_animation_player.play(animation_name, -1, animation_speed)


func _on_animation_finished(anim_name: String) -> void:
	emit_signal("animation_finished", anim_name)

func _on_touched_ground():
	var t = create_tween()
	t.tween_property(_animated_sprite, "scale", Vector2(1.1,0.9), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	t.tween_property(_animated_sprite, "scale", Vector2(0.9,1.1), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	t.tween_property(_animated_sprite, "scale", Vector2.ONE, 0.15)
	

func _on_jumped():
	var t = create_tween()
	t.tween_property(_animated_sprite, "scale", Vector2(1.2,0.8), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	t.tween_property(_animated_sprite, "scale", Vector2(0.8,1.2), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	t.tween_property(_animated_sprite, "scale", Vector2.ONE, 0.15)
	
