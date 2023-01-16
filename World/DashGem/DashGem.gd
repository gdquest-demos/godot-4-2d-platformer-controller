extends Area2D

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _sprite: AnimatedSprite2D = $Sprite2D
@onready var _timer: Timer = $Timer


func _ready() -> void:
	GameplayEvents.connect("dash_enabled", _on_GameplayEvents_dash_enabled)
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
