extends PlayerState

var input_direction := Vector2.ZERO
var x_input := 0.0

@onready var _climb_cooldown_timer: Timer = $ClimbCooldownTimer


func physics_process(delta: float) -> void:
	x_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	player.set_direction(x_input)
	
	if player.direction != 0:
		player.move(player.acceleration, player.direction, player.max_speed, delta)
	
	if player.is_on_floor() and player.direction == 0:
		player.decelerate(player.deceleration, delta)
	
	player.apply_gravity(delta)

	input_direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	
	if wall_detector.is_against_wall() and Input.is_action_pressed("grab") and _climb_cooldown_timer.is_stopped():
		_state_machine.transition_to("Action/Climb")


func enter(msg: Dictionary = {}) -> void:
	if "from_climb" in msg:
		_climb_cooldown_timer.start()
