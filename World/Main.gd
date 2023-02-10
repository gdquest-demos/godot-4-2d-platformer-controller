extends Node

@onready var player: Player
@onready var level_holder : Node = $LevelHolder
@onready var transition = $UI/Transition

@export var level_scene: PackedScene


func _ready() -> void:
	var level = level_scene.instantiate()
	level_holder.add_child(level)
	var spawn_pos = get_tree().get_nodes_in_group("spawn")[0].position
	player = level.get_node("Player")
	player.position = spawn_pos
	
	GameplayEvents.connect("player_died", _on_GameplayEvents_player_died)


func _on_GameplayEvents_player_died() -> void:
	transition.fade_out()
	await transition.transition_finished
	player.reset_position()
	transition.fade_in()
	await transition.transition_finished
	player.initialize()
