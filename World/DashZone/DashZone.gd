@tool
extends StaticBody2D

@export var size := Vector2(100,100) : set = _set_size

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var area_collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var texture : ColorRect = $Texture


func _ready() -> void:
	GameplayEvents.connect("dash_started", _on_GameplayEvents_dash_started)
	GameplayEvents.connect("dash_ended", _on_GameplayEvents_dash_end)
	get_viewport().connect("size_changed", _set_ratio)
	texture.connect("resized", _set_ratio)
	_set_size(size)
	_set_ratio()


func _set_size(value):
	size = value
	if !is_inside_tree(): 
		return
	collision_shape.shape.size = size
	area_collision_shape.shape.size = size
	texture.size = size
	texture.position = -(size/2)
	_set_ratio()


func _set_ratio():
	var screen_size = get_viewport().size
	texture.material.set_shader_parameter("screen_ratio", screen_size.x / screen_size.y)
	texture.material.set_shader_parameter("ratio", size.x / size.y)


func _on_GameplayEvents_dash_started() -> void:
	collision_shape.set_deferred("disabled", true)


func _on_GameplayEvents_dash_end() -> void:
	collision_shape.set_deferred("disabled", false)
