extends PlayerState

@onready var _dash_cooldown_timer: Timer = $DashCooldownTimer


func physics_process(delta: float) -> void:
	if player.direction:
		skin.set_direction(player.direction)
		skin.play_animation("Run", _parent.x_input)
		wall_detector.set_direction(player.direction)
	else:
		skin.play_animation("Idle")

	if not player.is_on_floor():
		_state_machine.transition_to("Movement/Air")
		return
	elif Input.is_action_just_pressed("jump"):
		_state_machine.transition_to("Movement/Air", { jumped = true })
		return
	elif Input.is_action_just_pressed("dash") and _dash_cooldown_timer.is_stopped():
		_state_machine.transition_to("Action/Dash", { direction = _parent.input_direction })
		return
		
	_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	_parent.can_dash = true
	if "from_dash" in msg:
		_dash_cooldown_timer.start()
