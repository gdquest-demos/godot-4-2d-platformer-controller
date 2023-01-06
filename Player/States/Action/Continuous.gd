extends PlayerState


func physics_process(delta: float) -> void:
	if player.is_on_floor() or player.is_on_wall() or player.is_on_ceiling():
		_state_machine.transition_to("Die")


func enter(msg: Dictionary = {}) -> void:
	gameplay_events.emit_signal("dash_started")
	player.set_velocity(Vector2.LEFT * player.jump_speed * sign(msg.direction.x) + Vector2.UP * player.jump_speed * sign(msg.direction.y))
	dash_zone_detector.connect("area_exited", _on_DashZoneDetector_area_exited)


func exit() -> void:
	gameplay_events.emit_signal("dash_ended")
	dash_zone_detector.disconnect("area_exited", _on_DashZoneDetector_area_exited)
	player.can_dash = true


func _on_DashZoneDetector_area_exited(area: Area2D) -> void:
	if player.is_on_floor():
		_state_machine.transition_to("Movement/Ground", { from_dash = true })
	else:
		_state_machine.transition_to("Movement/Air", { from_dash = true })
