class_name Bubble extends BubbleDefinitions

@export var bubble_state: BubbleDefinitions.BubbleState
@export var bubble_speed = 100

@onready var mouse_collision_shape = MOUSE_COLLISION_SHAPE
@onready var body_collision_shape = BODY_COLLISION_SHAPE


var floating_target: Marker2D


var _distributions: Dictionary = {
	BubbleDefinitions.BubbleState.WHATSAPP: 	0.05,
	BubbleDefinitions.BubbleState.FACEBOOK: 	0.05,
	BubbleDefinitions.BubbleState.INSTAGRAM:	0.90,
}

var _time_to_convert_milliseconds: float = 5000
var _ttc_variable_margin_percent: float = 0.3


var _variable_size_difference: float


func _calculate_variable_size_difference() -> void:
	_variable_size_difference = randf_range(1.025, 1.3)


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
			mouse_collision_shape.debug_color = Color.ALICE_BLUE
		BubbleDefinitions.BubbleState.WHATSAPP:
			mouse_collision_shape.debug_color = Color.LAWN_GREEN
		BubbleDefinitions.BubbleState.FACEBOOK:
			mouse_collision_shape.debug_color = Color.NAVY_BLUE
		BubbleDefinitions.BubbleState.INSTAGRAM:
			mouse_collision_shape.debug_color = Color.DEEP_PINK


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


func _prepare_to_grow() -> void:
	mouse_collision_shape.scale = Vector2(0.0, 0.0)
	body_collision_shape.scale = Vector2(0.0, 0.0)


func _ready() -> void:
	seed(1)
	randomize()
	_calculate_variable_size_difference()
	_calculate_distribution_ranges()
	_calculate_variable_time_to_convert()
	_update_debug_color()
	_prepare_to_grow()


func _ease_out_elastic(number: float) -> float:
	if number == 0:
		return 0
	elif number == 1:
		return 1
	else:
		return (
			pow(2, -10 * number) * sin(((number * 10) - 0.75) * ((2 * PI) / 3))
		) + 1


var _elapsed_time_milliseconds: float = 0.0
func _process(delta_seconds: float) -> void:
	_elapsed_time_milliseconds += (delta_seconds * 1000)
	
	var time_to_act: float
	match (bubble_state):
		BubbleDefinitions.BubbleState.NEUTRAL:
			time_to_act = _time_to_convert_milliseconds
			
			var real_growth: float = _elapsed_time_milliseconds / time_to_act
			var visual_growth: float = _ease_out_elastic(real_growth)
			mouse_collision_shape.scale = Vector2(
				visual_growth * _variable_size_difference,
				visual_growth * _variable_size_difference
			)
			body_collision_shape.scale = Vector2(real_growth, real_growth)
			
		BubbleDefinitions.BubbleState.WHATSAPP:
			time_to_act = _time_to_convert_milliseconds / 3
		BubbleDefinitions.BubbleState.FACEBOOK:
			time_to_act = _time_to_convert_milliseconds / 3
		BubbleDefinitions.BubbleState.INSTAGRAM:
			time_to_act = _time_to_convert_milliseconds / 3
	
	if (_elapsed_time_milliseconds >= time_to_act):
		_elapsed_time_milliseconds = 0.0
		_update_bubble_state_as_per_distribution()
	
	var direction = (floating_target.position - position).normalized()
	# Calculate velocity based on direction and speed
	velocity = direction * bubble_speed
	# Move and check for collisions
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouse and event.is_pressed():
		if _is_currently_hovered:
			# Emit signal of selected bubble
			Global.bubble_clicked.emit(bubble_state, self)


var _is_currently_hovered: bool = false
func _on_body_mouse_entered() -> void:
	_is_currently_hovered = true


func _on_body_mouse_exited() -> void:
	_is_currently_hovered = false
