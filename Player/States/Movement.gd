extends PlayerState


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dash"):
		_state_machine.transition_to("Action/Dash")


func physics_process(delta: float) -> void:
	player.set_direction(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	
	if player.direction != 0:
		player.move(player.acceleration, player.direction, player.max_speed, delta)
	
	if player.is_on_floor() and player.direction == 0:
		player.decelerate(player.deceleration, delta)
	
	player.apply_gravity(delta)
