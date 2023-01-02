extends PlayerState


func physics_process(delta: float) -> void:
	player.set_direction(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	
	if player.direction != 0:
		player.move(player.acceleration, player.direction, player.max_speed, delta)
	
	if player.is_on_floor() and player.direction == 0:
		player.decelerate(player.deceleration, delta)
	
	player.apply_gravity(delta)

	var input_direction: Vector2 = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	
	if Input.is_action_just_pressed("dash"):
		_state_machine.transition_to("Action/Dash", { direction = input_direction })
	elif wall_detector.is_against_wall() and Input.is_action_just_pressed("grab"):
		_state_machine.transition_to("Action/Climb")
