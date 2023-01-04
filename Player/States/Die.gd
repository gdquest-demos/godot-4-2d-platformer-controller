extends PlayerState


func enter(msg: Dictionary = {}) -> void:
	player.reset_speed()
	skin.play_animation("Die")
	skin.connect("animation_finished", _on_PlayerSkin_animation_finished)


func exit() -> void:
	skin.disconnect("animation_finished", _on_PlayerSkin_animation_finished)


func _on_PlayerSkin_animation_finished(anim_name: String) -> void:
	player.emit_signal("died")
