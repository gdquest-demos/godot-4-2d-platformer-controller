extends PlayerState

# To do: improve this dash using similar formulas for the jump and gravity in Player.gd
var _direction := Vector2.ZERO
var _dash_timer : SceneTreeTimer = null

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
	_dash_timer = get_tree().create_timer(player.dash_duration)
	_dash_timer.connect("timeout", _on_dash_timeout)
	player.skin.set_rainbow_intensity(1.0)
	_set_dash_effect(true)
	
func exit():
	if _dash_timer: 
		_dash_timer.disconnect("timeout", _on_dash_timeout)
		_set_dash_effect(false)
	
func _on_dash_timeout() -> void:
	_state_machine.transition_to("Movement/Air", { from_dash = true })
	_set_dash_effect(false)

func _set_dash_effect(state : bool):
	var direction = [1.0, 0.0]
	var t = create_tween()
	if state:
		t.tween_method(player.skin.set_rainbow_intensity, 0.0, 1.0, 0.1)
	else:
		t.tween_method(player.skin.set_rainbow_intensity, 1.0, 0.0, 0.25).set_delay(0.1)
	player.emit_signal("dashing_update", state)
