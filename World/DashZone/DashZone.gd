extends StaticBody2D

@export var gameplay_events: GameplayEvents
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	gameplay_events.connect("dash_started", _on_GameplayEvents_dash_started)
	gameplay_events.connect("dash_ended", _on_GameplayEvents_dash_end)


func _on_GameplayEvents_dash_started() -> void:
	collision_shape.set_deferred("disabled", true)


func _on_GameplayEvents_dash_end() -> void:
	collision_shape.set_deferred("disabled", false)
