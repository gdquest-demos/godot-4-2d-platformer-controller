extends PlayerState

# To do: improve this dash using similar formulas for the jump and gravity in Player.gd
var _direction := Vector2.ZERO


func physics_process(delta: float) -> void:
	if player.velocity.y < 0:
		player.apply_gravity(delta)


func enter(msg: Dictionary = {}) -> void:
	if msg.direction == Vector2.ZERO:
		_direction = Vector2.RIGHT * skin.get_facing_direction()
	else:
		_direction = msg.direction
	player.set_velocity(Vector2.LEFT * player.jump_speed * sign(_direction.x) + Vector2.UP * player.jump_speed * sign(_direction.y))
	player.set_direction(_direction.x)
	skin.set_direction(_direction.x)
	wall_detector.set_direction(_direction.x)
	
	skin.play_animation("Dash", 2)
	skin.connect("animation_finished", _on_PlayerSkin_animation_finished)


func exit() -> void:
	skin.disconnect("animation_finished", _on_PlayerSkin_animation_finished)


func _on_PlayerSkin_animation_finished(anim_name: String) -> void:
	_state_machine.transition_to("Movement/Air", { from_dash = true })
