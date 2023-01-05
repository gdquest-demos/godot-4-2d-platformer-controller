extends Area2D

@export var gameplay_events: GameplayEvents

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _sprite: Sprite2D = $Sprite2D
@onready var _timer: Timer = $Timer


func _ready() -> void:
	gameplay_events.connect("dash_enabled", _on_GameplayEvents_dash_enabled)
	_timer.connect("timeout", _on_Timer_timeout)


func _set_active(value: bool) -> void:
	_collision_shape.set_deferred("disabled", not value)
	_sprite.visible = value


func collect() -> void:
	_set_active(false)


func _on_Timer_timeout() -> void:
	_set_active(true)


func _on_GameplayEvents_dash_enabled() -> void:
	_timer.start()
