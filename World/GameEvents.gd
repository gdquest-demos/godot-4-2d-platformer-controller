extends CanvasLayer

@export var player_path: NodePath

@onready var player: Player = get_node(player_path)
@onready var transition: Transition = $Transition


func _ready() -> void:
	await owner.ready
	player.connect("died", _on_Player_died)
	

func _on_Player_died() -> void:
	transition.fade_out()
	await transition.transition_finished
	player.reset_position()
	transition.fade_in()
	await transition.transition_finished
	player.initialize()
