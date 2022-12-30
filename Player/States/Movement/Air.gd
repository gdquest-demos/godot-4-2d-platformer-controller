extends PlayerState

# Called when the node enters the scene tree for the first time.
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
	
	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	if player.is_on_ceiling():
		player.reset_y_speed()

	if player.is_on_floor():
		_state_machine.transition_to("Movement/Ground")
	
	_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	
	if "jumped" in msg:
		if "velocity_x" in msg:
			player.reset_speed()
			player.set_velocity(Vector2.UP * player.velocity.y + Vector2.RIGHT * msg.velocity_x)
		player.jump(-player.jump_speed)
		
		skin.play_animation("Jump")
		skin.connect("animation_finished", _on_Skin_animation_finished)
	else:
		skin.play_animation("Fall")
		_coyote_timer.start()

	if "from_dash" in msg:
		if player.velocity.y < 0 and player.velocity.y < -player.jump_cut_speed:
			player.jump(player.jump_cut_speed)


func exit() -> void:
	_parent.exit()
	
	if skin.is_connected("animation_finished", _on_Skin_animation_finished):
		skin.disconnect("animation_finished", _on_Skin_animation_finished)

	_jump_released = false
	_coyote_timer.stop()


func _on_Skin_animation_finished(anim_name: String) -> void:
	skin.play_animation("Fall")
