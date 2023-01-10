extends GPUParticles2D

func _on_walking_state_change(state : bool):
	emitting = state
