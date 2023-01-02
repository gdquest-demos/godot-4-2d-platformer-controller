extends PlayerState

var _jump_released: bool = false

@onready var _coyote_timer: Timer = $Timer


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		if _coyote_timer.time_left > 0:
			_state_machine.transition_to("Movement/Air", { jumped = true })

	if event.is_action_released("jump"):
		if player.velocity.y < 0 and player.velocity.y < -player.jump_cut_speed and not _jump_released:
			player.jump(player.jump_cut_speed)
			_jump_released = true


func physics_process(delta: float) -> void:
	var x_input_direction: float = sign(Input.get_axis("move_left", "move_right"))

	if player.is_on_ceiling():
		player.reset_y_speed()

	if wall_detector.is_against_wall() and x_input_direction == wall_detector.get_direction() and player.velocity.y > 0:
		player.move_y(player.acceleration, 1, player.slide_speed, delta)
		skin.play_animation("SlideDown")
		
		if Input.is_action_just_pressed("jump"):
			_state_machine.transition_to("Movement/Air", { jumped = true, direction = wall_detector.get_direction() })
			return
	else:
		if Input.is_action_just_pressed("dash"):
			_state_machine.transition_to("Action/Dash", { direction = _parent.input_direction })
			return

	if player.is_on_floor():
		_state_machine.transition_to("Movement/Ground")
		return
	
	player.move(player.acceleration, player.direction, player.max_speed, delta)
	_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	if "jumped" in msg:
		if "direction" in msg:
			player.set_velocity(Vector2(msg.direction * player.jump_speed, player.jump_speed))
		else:
			player.jump(-player.jump_speed)
		skin.play_animation("Jump")
		skin.connect("animation_finished", _on_Skin_animation_finished)
	elif "climbed" in msg:
		if player.velocity.y < 0:
			player.jump(player.jump_cut_speed)
	elif "from_dash":
		skin.play_animation("Fall")
	else:
		skin.play_animation("Fall")
		_coyote_timer.start()


func exit() -> void:
	if skin.is_connected("animation_finished", _on_Skin_animation_finished):
		skin.disconnect("animation_finished", _on_Skin_animation_finished)

	_jump_released = false
	_coyote_timer.stop()


func _on_Skin_animation_finished(anim_name: String) -> void:
	if anim_name == "Jump":
		skin.play_animation("Fall")
