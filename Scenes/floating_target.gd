extends Marker2D


var _floating_target_initial_position: Vector2
var _ft_variable_margin_percent: float = 0.05
var _ft_elapsed_time: float = 0.0
var _ft_orbital_speed: float = 1.6
var _ft_distance_from_center: int = 240


func _ready() -> void:
	_floating_target_initial_position = position


func _process(delta: float) -> void:
	_ft_elapsed_time += delta
	
	var angle := _ft_orbital_speed * _ft_elapsed_time
	var rotation := Vector2(sin(angle), cos(angle))
	position = rotation * _ft_distance_from_center
	position += _floating_target_initial_position
