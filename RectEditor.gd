@tool
extends Node2D

@export var size = Vector2.ONE * 100.0 : set = set_size

func set_size(value):
	size = value
	queue_redraw()
	
func _draw():
	if !Engine.is_editor_hint(): return
	draw_rect(Rect2(-size / 2.0, size), Color.BLUE_VIOLET, false, 2.0)
