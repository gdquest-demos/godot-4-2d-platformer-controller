extends State
class_name PlayerState

var player: Player
var gameplay_events: GameplayEvents
var skin: PlayerSkin
var dash_zone_detector: Area2D
var wall_detector: WallDetector
var magic_trail: MagicTrail


func _ready() -> void:
	super._ready()
	await owner.ready
	
	player = owner
	gameplay_events = player.gameplay_events
	skin = player.skin
	dash_zone_detector = player.dash_zone_detector
	wall_detector = player.wall_detector
	magic_trail = player.magic_trail
