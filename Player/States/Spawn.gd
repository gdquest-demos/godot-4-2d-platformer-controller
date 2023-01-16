extends PlayerState


func enter(msg := {}) -> void:
	vfx.spawn_explosion()
	await vfx.explosion_finished
	
	skin.show()
	skin.play_animation("Spawn")
	skin.connect("animation_finished", _on_PlayerSkin_animation_finished)


func exit() -> void:
	skin.disconnect("animation_finished", _on_PlayerSkin_animation_finished)


func _on_PlayerSkin_animation_finished(anim_name: String) -> void:
	_state_machine.transition_to("Movement/Air")
