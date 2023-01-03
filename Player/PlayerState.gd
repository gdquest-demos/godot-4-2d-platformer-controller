extends State
class_name PlayerState

var player: Player
var skin: PlayerSkin
var wall_detector: WallDetector
var magic_trail: MagicTrail


func _ready() -> void:
	super._ready()
	await owner.ready
	
	player = owner
	skin = player.skin
	wall_detector = player.wall_detector
	magic_trail = player.magic_trail
