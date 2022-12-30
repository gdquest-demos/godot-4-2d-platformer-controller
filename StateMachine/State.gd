extends Node
class_name State 
@icon("State.svg")

var is_active: bool = true : set = set_is_active
var _parent: State = null

@warning_ignore(unused_private_class_variable)
@onready var _state_machine: StateMachine = _get_state_machine(self)


func _ready() -> void:
	var parent: Node = get_parent()
	if parent is State:
		_parent = parent


func unhandled_input(_event: InputEvent) -> void:
	return


func process(_delta: float) -> void:
	return


func physics_process(_delta: float) -> void:
	return


func enter(_msg: Dictionary = {}) -> void:
	return


func exit() -> void:
	return


func set_is_active(value: bool) -> void:
	is_active = value
	set_block_signals(!value)


func _get_state_machine(node: Node) -> Node:
	if node != null and node is State:
		return _get_state_machine(node.get_parent())
	return node
