extends State
class_name PlayerState

var player: Player
var vfx: VFX
var skin: PlayerSkin
var dash_zone_detector: Area2D
var wall_detector: WallDetector
var magic_trail: MagicTrail
var dust: GPUParticles2D


func _ready() -> void:
	super._ready()
	await owner.ready
	
	player = owner
	vfx = player.vfx
	skin = player.skin
	dash_zone_detector = player.dash_zone_detector
	wall_detector = player.wall_detector
	magic_trail = player.magic_trail
	dust = player.dust
