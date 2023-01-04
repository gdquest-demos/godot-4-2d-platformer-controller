extends CharacterBody2D
class_name Player

@export var skin_path: NodePath

@export var acceleration := 700
@export var deceleration := 1400
@export var max_gravity := 250
@export var slide_speed := 50.0

@export var jump_distance := 80
@export var jump_height := 50
@export var jump_time_to_peak := 0.37
@export var jump_time_to_descent := 0.3
@export var jump_cut_value := 15

var direction := 0.0 : set = set_direction
var can_dash := true

@onready var skin: PlayerSkin = get_node(skin_path)
@onready var hurt_box: Area2D = $HurtBox
@onready var wall_detector: WallDetector = $WallDetector
@onready var magic_trail: MagicTrail = $MagicTrail

@onready var max_speed: float = jump_distance / (jump_time_to_peak + jump_time_to_descent)
@onready var jump_speed: float = (-2 * jump_height) / jump_time_to_peak
@onready var jump_gravity: float = (2 * jump_height) / pow(jump_time_to_peak, 2)
@onready var fall_gravity: float = (2 * jump_height) / pow(jump_time_to_descent, 2)
@onready var jump_cut_speed: float = fall_gravity / jump_cut_value
@onready var respawn_position: Vector2 = global_position

@onready var _state_machine: StateMachine = $StateMachine


func _ready() -> void:
	hurt_box.connect("body_entered", _on_HurtBox_body_entered)


func _physics_process(_delta: float) -> void:
	move_and_slide()


func set_direction(value: float) -> void:
	direction = value


func reset_position() -> void:
	global_position = respawn_position


func reset_y_speed() -> void:
	velocity.y = 0


func reset_speed() -> void:
	velocity.x = 0
	velocity.y = 0


func jump(jump_speed: float) -> void:
	velocity.y = -jump_speed


func move(acceleration: float, direction: float, max_speed: float, delta: float) -> void:
	velocity.x += acceleration * direction * delta
	velocity.x = clamp(velocity.x, -max_speed, max_speed)


func move_y(acceleration: float, direction: float, max_speed: float, delta: float) -> void:
	if direction != 0:
		velocity.y += acceleration * direction * delta
	else:
		velocity.y = move_toward(velocity.y, 0, acceleration * delta)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)


func decelerate(deceleration: float, delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, deceleration * delta)


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		if velocity.y >= 0:
			velocity.y += fall_gravity * delta
		else:
			velocity.y += jump_gravity * delta
		velocity.y = min(velocity.y, max_gravity)


func _on_HurtBox_body_entered(body: Node2D) -> void:
	_state_machine.transition_to("Die")
