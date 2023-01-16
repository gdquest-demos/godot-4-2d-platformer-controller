extends PlayerState

var _direction := Vector2.ZERO

@onready var _timer: Timer = $Timer


func _ready() -> void:
	super._ready()
	_timer.connect("timeout", _on_Timer_timeout)


func physics_process(delta: float) -> void:
	if player.velocity.y < 0.0:
		player.apply_gravity(delta)


func enter(msg := {}) -> void:
	if msg.direction == Vector2.ZERO:
		_direction = Vector2.RIGHT * skin.get_facing_direction()
	else:
		_direction = msg.direction
	player.set_velocity(Vector2.LEFT * player.jump_speed * sign(_direction.x) + Vector2.UP * player.jump_speed * sign(_direction.y))
	player.set_direction(_direction.x)
	gameplay_events.emit_signal("dash_started")
	
	skin.set_direction(_direction.x)
	skin.play_animation("Dash")
	skin.set_rainbow_intensity(1.0)
	
	dash_zone_detector.connect("area_entered", _on_DashZoneDetector_area_entered)
	wall_detector.set_direction(_direction.x)
	
	_timer.start()
	_set_dash_effect(true)


func exit() -> void:
	gameplay_events.emit_signal("dash_ended")
	dash_zone_detector.disconnect("area_entered", _on_DashZoneDetector_area_entered)
	_timer.stop()
	_set_dash_effect(false)


func _set_dash_effect(value: bool) -> void:
	var direction: Array = [1.0, 0.0]
	var tween: Tween = create_tween()
	if value:
		tween.tween_method(player.skin.set_rainbow_intensity, 0.0, 1.0, 0.1)
	else:
		tween.tween_method(player.skin.set_rainbow_intensity, 1.0, 0.0, 0.25).set_delay(0.1)
	magic_trail.set_active(value)


func _on_Timer_timeout() -> void:
	if player.is_on_floor():
		_state_machine.transition_to("Movement/Ground", { from_dash = true })
	else:
		_state_machine.transition_to("Movement/Air", { from_dash = true })


func _on_DashZoneDetector_area_entered(area: Area2D) -> void:
	_state_machine.transition_to("Action/Dash/Continuous", { direction = _direction })
