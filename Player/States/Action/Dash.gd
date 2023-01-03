extends PlayerState

var _direction := Vector2.ZERO

@onready var _timer: Timer = $Timer


func _ready() -> void:
	super._ready()
	_timer.connect("timeout", _on_Timer_timeout)


func physics_process(delta: float) -> void:
	if player.velocity.y < 0:
		player.apply_gravity(delta)


func enter(msg: Dictionary = {}) -> void:
	if msg.direction == Vector2.ZERO:
		_direction = Vector2.RIGHT * skin.get_facing_direction()
	else:
		_direction = msg.direction
	player.set_velocity(Vector2.LEFT * player.jump_speed * sign(_direction.x) + Vector2.UP * player.jump_speed * sign(_direction.y))
	player.set_direction(_direction.x)
	
	skin.set_direction(_direction.x)
	skin.play_animation("Dash")
	skin.set_rainbow_intensity(1.0)
	
	wall_detector.set_direction(_direction.x)
	
	_timer.start()
	_set_dash_effect(true)


func exit() -> void:
	_timer.stop()
	_set_dash_effect(false)


func _set_dash_effect(value: bool) -> void:
	var direction = [1.0, 0.0]
	var t = create_tween()
	if value:
		t.tween_method(player.skin.set_rainbow_intensity, 0.0, 1.0, 0.1)
	else:
		t.tween_method(player.skin.set_rainbow_intensity, 1.0, 0.0, 0.25).set_delay(0.1)
	magic_trail.set_active(value)


func _on_Timer_timeout() -> void:
	if player.is_on_floor():
		_state_machine.transition_to("Movement/Ground", { from_dash = true })
	else:
		_state_machine.transition_to("Movement/Air", { from_dash = true })
