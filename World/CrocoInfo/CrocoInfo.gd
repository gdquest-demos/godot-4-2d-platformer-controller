extends Node2D

@export var lines : PackedStringArray = []
@onready var sprite = $Sprite2D
@onready var bubble = $CanvasLayer/Bubble
@onready var bubble_target = $BubbleTarget

var _is_active = false : set = _set_active
var _current_line = -1
var player = null

func _ready():
	set_process_unhandled_input(_is_active)

func _set_active(value):
	if _is_active == value: return
	_is_active = value
	set_process_unhandled_input(_is_active)
	if _is_active == false && bubble.active: 
		_reset_bubble()
		
func _unhandled_input(event: InputEvent):
	if Input.is_action_just_pressed("move_down"):
		var tween := create_tween()
		tween.tween_property(sprite, "scale", Vector2(1.2,0.8), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(sprite, "scale", Vector2(0.8,1.2), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(sprite, "scale", Vector2.ONE, 0.15)
		
		if _current_line == -1:
			bubble.open(bubble_target)
		if _current_line >= lines.size() - 1:
			_reset_bubble()
			return
		_current_line += 1
		bubble.write(lines[_current_line])
		_look_at_target(player.global_position)

func _look_at_target(pos : Vector2):
	sprite.flip_h = (pos.x - self.global_position.x) < 0

func _reset_bubble():
	_current_line = -1
	bubble.close()

func _on_area_2d_body_entered(body):
	if body is Player:
		player = body
		_set_active(true)

func _on_area_2d_body_exited(body):
	if body is Player:
		player = null
		_set_active(false)
