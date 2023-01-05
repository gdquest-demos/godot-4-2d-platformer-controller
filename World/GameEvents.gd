extends Node

@export var gameplay_events: GameplayEvents
@export var player_path: NodePath

@onready var player: Player = get_node(player_path)
@onready var level_holder : Node = $LevelHolder
@onready var transition: Transition = $UI/Transition

@export var level: PackedScene


func _ready() -> void:
	level_holder.add_child(level.instantiate())
	var spawn_pos = get_tree().get_nodes_in_group("spawn")[0].position
	player.position = spawn_pos

	gameplay_events.connect("player_died", _on_GameplayEvents_player_died)


func _on_GameplayEvents_player_died() -> void:
	transition.fade_out()
	await transition.transition_finished
	player.reset_position()
	transition.fade_in()
	await transition.transition_finished
	player.initialize()
