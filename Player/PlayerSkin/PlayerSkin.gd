extends Node2D
class_name PlayerSkin

signal animation_finished(anim_name)
signal attack_started
signal attack_ended

@onready var _sprite_container: Marker2D = $SpriteContainer
@onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	_animation_player.connect("animation_finished", _on_animation_finished)


func set_direction(x_input: float) -> void:
	if x_input != 0:
		_sprite_container.scale.x = sign(x_input)


func get_facing_direction() -> int:
	return sign(_sprite_container.scale.x)


func play_animation(animation_name: String, animation_speed: float = 1.0, from_position: Vector2 = Vector2.ZERO) -> void:
	if from_position != Vector2.ZERO:
		position = from_position
	_animation_player.play(animation_name, -1, animation_speed)


func set_animation_speed(speed: float) -> void:
	play_animation(_animation_player.current_animation, speed)


func _on_animation_finished(anim_name: String) -> void:
	emit_signal("animation_finished", anim_name)
