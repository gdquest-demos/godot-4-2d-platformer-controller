extends PlayerState

@export var speed := 350
var _direction := Vector2.ZERO


func physics_process(delta: float) -> void:
	if player.velocity.y < 0:
		player.velocity.y = move_toward(player.velocity.y, 0, player.deceleration * delta)
	
	player.decelerate(player.deceleration, delta)


func enter(msg: Dictionary = {}) -> void:
	if msg.direction == Vector2.ZERO:
		_direction = Vector2.RIGHT * skin.get_facing_direction()
	else:
		_direction = msg.direction
	player.set_speed(_direction * speed)
	
	skin.play_animation("Dash", 2)
	skin.connect("animation_finished", _on_PlayerSkin_animation_finished)


func exit() -> void:
	skin.disconnect("animation_finished", _on_PlayerSkin_animation_finished)


func _on_PlayerSkin_animation_finished(anim_name: String) -> void:
	_state_machine.transition_to("Movement/Air", { from_dash = true }) # Change this later: remove 'from_dash'
