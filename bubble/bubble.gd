class_name Bubble extends BubbleDefinitions

@export var bubble_state: BubbleDefinitions.BubbleState

@onready var collision_shape = COLLISION_SHAPE


var _distributions: Dictionary = {
	BubbleDefinitions.BubbleState.WHATSAPP: 	0.25,
	BubbleDefinitions.BubbleState.FACEBOOK: 	0.25,
	BubbleDefinitions.BubbleState.INSTAGRAM:	0.50,
}

var _time_to_convert_milliseconds: float = 5000
var _ttc_variable_margin_percent: float = 0.3


func _calculate_distribution_ranges() -> void:
	_distributions[BubbleDefinitions.BubbleState.FACEBOOK] += \
		_distributions[BubbleDefinitions.BubbleState.WHATSAPP]
	_distributions[BubbleDefinitions.BubbleState.INSTAGRAM] += \
		_distributions[BubbleDefinitions.BubbleState.FACEBOOK]


func _calculate_variable_time_to_convert() -> void:
	_time_to_convert_milliseconds = randf_range(
		_time_to_convert_milliseconds * (1 - _ttc_variable_margin_percent),
		_time_to_convert_milliseconds * (1 + _ttc_variable_margin_percent),
	)


func _update_debug_color() -> void:
	match bubble_state:
		BubbleDefinitions.BubbleState.NEUTRAL:
			collision_shape.debug_color = Color.ALICE_BLUE
		BubbleDefinitions.BubbleState.WHATSAPP:
			collision_shape.debug_color = Color.LAWN_GREEN
		BubbleDefinitions.BubbleState.FACEBOOK:
			collision_shape.debug_color = Color.NAVY_BLUE
		BubbleDefinitions.BubbleState.INSTAGRAM:
			collision_shape.debug_color = Color.DEEP_PINK


func _update_bubble_state_as_per_distribution() -> void:
	var next_bubble_state_picker: float = randf()
	var bubble_states: Array[BubbleDefinitions.BubbleState] = [
		BubbleDefinitions.BubbleState.WHATSAPP,
		BubbleDefinitions.BubbleState.FACEBOOK,
		BubbleDefinitions.BubbleState.INSTAGRAM,
	]
	
	for next_bubble_state in bubble_states:
		if (next_bubble_state_picker <= _distributions[next_bubble_state]):
			bubble_state = next_bubble_state
			break
	
	_update_debug_color()


func _ready() -> void:
	seed(1)
	randomize()
	_calculate_distribution_ranges()
	_calculate_variable_time_to_convert()
	_update_debug_color()


var _elapsed_time_milliseconds: float = 0.0
func _process(delta_seconds: float) -> void:
	_elapsed_time_milliseconds += (delta_seconds * 1000)
	
	var time_to_act: float
	match (bubble_state):
		BubbleDefinitions.BubbleState.NEUTRAL:
			time_to_act = _time_to_convert_milliseconds
		BubbleDefinitions.BubbleState.WHATSAPP:
			time_to_act = _time_to_convert_milliseconds / 3
		BubbleDefinitions.BubbleState.FACEBOOK:
			time_to_act = _time_to_convert_milliseconds / 3
		BubbleDefinitions.BubbleState.INSTAGRAM:
			time_to_act = _time_to_convert_milliseconds / 3
	
	if (_elapsed_time_milliseconds >= time_to_act):
		_elapsed_time_milliseconds = 0.0
		_update_bubble_state_as_per_distribution()


func _input(event: InputEvent) -> void:
	if event is InputEventMouse and event.is_pressed():
		var mouse_click_position: Vector2 = event.position
		var collision_rect: Rect2 = collision_shape.shape.get_rect()
		collision_rect.position = self.position - (collision_rect.size / 2)
		print("Has rect: ", collision_rect.has_point(mouse_click_position))
		if collision_rect.has_point(mouse_click_position):
			print("Has point")
			# Emit signal of selected bubble
			Global.bubble_clicked.emit(bubble_state, self)
