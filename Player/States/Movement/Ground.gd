extends PlayerState

@onready var _dash_cooldown_timer: Timer = $DashCooldownTimer


func physics_process(delta: float) -> void:
	if player.direction:
		skin.set_direction(player.direction)
		skin.play_animation("Run", _parent.input_direction.x)
		wall_detector.set_direction(player.direction)
		dust.set_emitting(true)
	else:
		skin.play_animation("Idle")
		dust.set_emitting(false)

	if not player.is_on_floor():
		_state_machine.transition_to("Movement/Air")
	elif Input.is_action_just_pressed("jump"):
		_state_machine.transition_to("Movement/Air", { jumped = true })
	elif Input.is_action_just_pressed("dash") and _dash_cooldown_timer.is_stopped():
		player.set_can_dash(false)
		_state_machine.transition_to("Action/Dash", { direction = _parent.input_direction.normalized() })
	else:
		_parent.physics_process(delta)


func enter(msg := {}) -> void:
	player.set_snap()
	player.set_can_dash(true)
	
	gameplay_events.emit_signal("dash_enabled")
	
	if "from_dash" in msg:
		_dash_cooldown_timer.start()


func exit():
	dust.set_emitting(false)
