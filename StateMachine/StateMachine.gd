extends Node
class_name StateMachine
@icon("StateMachine.svg")

@export var initial_state: NodePath

var is_active: bool = true : set = set_is_active
var state_name: String = ""

@onready var state: State = get_node(initial_state) : set = set_state


func _ready() -> void:
	await owner.ready
	state.enter()


func _unhandled_input(event: InputEvent) -> void:
	state.unhandled_input(event)


func _process(delta: float) -> void:
	state.process(delta)
	

func _physics_process(delta: float) -> void:
	state.physics_process(delta)


func transition_to(target_state_path: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		printerr("The target state '" + target_state_path + "' doesn't exist.")
		return
	
	var target_state: State = get_node(target_state_path)
	state.exit()
	self.state = target_state
	state.enter(msg)


func set_state(value: State) -> void:
	state = value
	state_name = state.name


func set_is_active(value: bool) -> void:
	is_active = value
	set_process_unhandled_input(value)
	set_process(value)
	set_physics_process(value)
	state.is_active = value
