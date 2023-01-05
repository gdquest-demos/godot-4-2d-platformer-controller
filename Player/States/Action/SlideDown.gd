extends PlayerState


func physics_process(delta: float) -> void:
	var x_input_direction: float = sign(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	
	player.move_y(player.acceleration, 1, player.slide_speed, delta)
	skin.play_animation("SlideDown")
	skin.set_direction(wall_detector.get_direction())
		
	if Input.is_action_just_pressed("jump"):
		_state_machine.transition_to("Movement/Air", { jumped = true, direction = wall_detector.get_direction() })
		return
	
	if not (wall_detector.is_against_wall() and x_input_direction == wall_detector.get_direction() and player.velocity.y > 0):
		_state_machine.transition_to("Movement/Air")


func enter(msg: Dictionary = {}) -> void:
	player.can_dash = true
