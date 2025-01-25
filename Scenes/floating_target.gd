extends Marker2D


var _it_margin_px: int = 300
var _it_variable_margin_percent: float = 0.1

var _it_initial_position: Vector2


func _ready() -> void:
	_it_initial_position = position


func _process(delta: float) -> void:
	var inner_translation = Vector2(
		randf_range(
			_it_initial_position.x * (1 - _it_variable_margin_percent),
			_it_initial_position.x * (1 + _it_variable_margin_percent)
		),
		randf_range(
			_it_initial_position.y * (1 - _it_variable_margin_percent),
			_it_initial_position.y * (1 + _it_variable_margin_percent)
		),
	)
	
	var distance: Vector2 = (inner_translation - position).normalized()
	position += distance
	
	if position.x < _it_initial_position.x - _it_margin_px:
		position.x = _it_initial_position.x - _it_margin_px
	elif position.x > _it_initial_position.x + _it_margin_px:
		position.x = _it_initial_position.x + _it_margin_px
	
	if position.y < _it_initial_position.y - _it_margin_px:
		position.y = _it_initial_position.y - _it_margin_px
	elif position.y > _it_initial_position.y + _it_margin_px:
		position.y = _it_initial_position.y + _it_margin_px
