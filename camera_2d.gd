extends Camera2D

var shake_intensity = 0.0
var shake_decay = 0.9  # How fast the shake reduces each frame

func _process(delta):
	if shake_intensity > 0:
		offset = Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		shake_intensity *= shake_decay  # Reduce shake over time
	else:
		offset = Vector2.ZERO

func start_shake(intensity: float):
	shake_intensity = intensity
