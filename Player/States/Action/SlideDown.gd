extends PlayerState


func physics_process(delta: float) -> void:
	var input_direction: Vector2 = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	
	player.move_y(player.acceleration, 1, player.slide_speed, delta)
	skin.play_animation("SlideDown")
	skin.set_direction(wall_detector.get_direction())
		
	if Input.is_action_just_pressed("jump"):
		_state_machine.transition_to("Movement/Air", { jumped = true, direction = wall_detector.get_direction() })
		return
	
	if not (wall_detector.is_against_wall() and sign(input_direction.x) == wall_detector.get_direction() and player.velocity.y > 0):
		_state_machine.transition_to("Movement/Air")
		return
	
	if Input.is_action_just_pressed("dash") and player.can_dash:
		player.set_can_dash(false)
		_state_machine.transition_to("Action/Dash", { direction = input_direction.normalized() })


func enter(msg := {}) -> void:
	player.set_can_dash(true)
	gameplay_events.emit_signal("dash_enabled")
