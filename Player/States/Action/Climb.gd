extends PlayerState

@export var climb_speed := 35.0
@export var slide_speed := 50.0

@onready var timer: Timer = $Timer


func _ready() -> void:
	super._ready()
	timer.connect("timeout", _on_Timer_timeout)


func physics_process(delta: float) -> void:
	var y_direction := Input.get_axis("move_up", "move_down")
	
	if !Input.is_action_pressed("grab"):
		_state_machine.transition_to("Movement/Air")
	
	if y_direction != 0:
		if y_direction < 0:
			player.move_y(player.acceleration, y_direction, climb_speed, delta)
			skin.play_animation("ClimbUp")
		else:
			player.move_y(player.acceleration, y_direction, slide_speed, delta)
			skin.play_animation("SlideDown")
	else:
		player.move_y(player.deceleration, 0, 0, delta)
		skin.play_animation("Grab")
	
	if not wall_detector.is_against_wall():
		_state_machine.transition_to("Movement/Air", { climbed = true })


func enter(msg: Dictionary = {}) -> void:
	player.reset_speed()
	skin.play_animation("Grab")

	timer.start()


func exit() -> void:
	timer.stop()


func _on_Timer_timeout() -> void:
	_state_machine.transition_to("Movement/Air")
