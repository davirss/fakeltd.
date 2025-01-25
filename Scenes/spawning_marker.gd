extends Marker2D


var floating_target: Marker2D


var _sp_variable_margin_percent: float = 0.05
var _sp_elapsed_time: float = 0.0
var _sp_orbital_speed: float = 0.8
var _sp_distance_from_floating_target: int = 120


func _process(delta: float) -> void:
	_sp_elapsed_time += delta
	
	var angle := _sp_orbital_speed * _sp_elapsed_time
	var rotation := Vector2(cos(angle), sin(angle))
	position = rotation * randf_range(
		_sp_distance_from_floating_target * (1 - _sp_variable_margin_percent),
		_sp_distance_from_floating_target * (1 + _sp_variable_margin_percent)
	)
	position += floating_target.position
