extends State
class_name PlayerState

var player: Player
var skin: PlayerSkin


func _ready() -> void:
	super._ready()
	await owner.ready
	
	player = owner
	skin = player.skin
