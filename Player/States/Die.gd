extends PlayerState


func enter(msg := {}) -> void:
	player.reset_speed()
	skin.play_animation("Die")
	skin.connect("animation_finished", _on_PlayerSkin_animation_finished)


func exit() -> void:
	skin.disconnect("animation_finished", _on_PlayerSkin_animation_finished)


func _on_PlayerSkin_animation_finished(anim_name: String) -> void:
	GameplayEvents.emit_signal("player_died")
	skin.hide()
	vfx.spawn_explosion()
