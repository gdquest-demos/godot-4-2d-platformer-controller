@tool
extends ColorRect

func _ready():
	connect("resized", _on_resized)

func _set_ratio():
	var ratio = Vector2.ONE
	material.set_shader_parameter("height", size.y);
	material.set_shader_parameter("ratio", size.x / size.y);

func _on_resized():
	_set_ratio()
