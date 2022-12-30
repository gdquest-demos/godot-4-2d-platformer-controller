extends PlayerState


func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	if player.direction:
		skin.set_direction(player.direction)
		skin.play_animation("Run")
	else:
		skin.play_animation("Idle")

	if not player.is_on_floor():
		_state_machine.transition_to("Movement/Air")
	elif Input.is_action_just_pressed("jump"):
		_state_machine.transition_to("Movement/Air", { jumped = true })

	_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)


func exit() -> void:
	_parent.exit()
