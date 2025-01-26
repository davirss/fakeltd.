class_name Bubble extends BubbleDefinitions

@export var bubble_state: BubbleDefinitions.BubbleState
@export var bubble_speed = 100

@onready var _mouse_collision_shape = MOUSE_COLLISION_SHAPE
@onready var _body_collision_shape = BODY_COLLISION_SHAPE
@onready var _bubble_sprite = BUBBLE_SPRITE


var floating_target: Marker2D
var distributions: Dictionary
var initial_bubbles_amount: int


var _min_time_to_swap_milliseconds: float = 333.33333333333337
var _max_time_to_swap_milliseconds: float = 2000
var _time_to_convert_milliseconds: float = 2000
var _ttc_variable_margin_percent: float = 0.1

var _fixed_size_difference: float
var _variable_size_difference: float

func _calculate_variable_size_difference() -> void:
	_fixed_size_difference = randf_range(0.025, 0.3)
	_variable_size_difference = randf_range(1.025, 1.125)


func _calculate_distribution_ranges() -> void:
	distributions[BubbleDefinitions.BubbleState.FACEBOOK] += \
		distributions[BubbleDefinitions.BubbleState.WHATSAPP]
	distributions[BubbleDefinitions.BubbleState.INSTAGRAM] += \
		distributions[BubbleDefinitions.BubbleState.FACEBOOK]


func _calculate_variable_time_to_convert() -> void:
	_time_to_convert_milliseconds = randf_range(
		_time_to_convert_milliseconds * (1 - _ttc_variable_margin_percent),
		_time_to_convert_milliseconds * (1 + _ttc_variable_margin_percent),
	)


func _update_sprite(previous_bubble_state: BubbleDefinitions.BubbleState) -> void:
	if (previous_bubble_state == bubble_state):
		return
	
	match bubble_state:
		BubbleDefinitions.BubbleState.NEUTRAL:
			if randf() >= 0.5:
				_bubble_sprite.texture = BUBBLE_SPRITE_WHITE
				_mouse_collision_shape.debug_color = Color.ALICE_BLUE
			else:
				_bubble_sprite.texture = BUBBLE_SPRITE_WHITE_ALT
				_mouse_collision_shape.debug_color = Color.ALICE_BLUE
		BubbleDefinitions.BubbleState.WHATSAPP:
			if randf() >= 0.5:
				_bubble_sprite.texture = BUBBLE_SPRITE_GREEN
				_mouse_collision_shape.debug_color = Color.LAWN_GREEN
			else:
				_bubble_sprite.texture = BUBBLE_SPRITE_GREEN_ALT
				_mouse_collision_shape.debug_color = Color.PALE_GREEN
		BubbleDefinitions.BubbleState.FACEBOOK:
			if randf() >= 0.5:
				_bubble_sprite.texture = BUBBLE_SPRITE_BLUE
				_mouse_collision_shape.debug_color = Color.NAVY_BLUE
			else:
				_bubble_sprite.texture = BUBBLE_SPRITE_BLUE_ALT
				_mouse_collision_shape.debug_color = Color.ROYAL_BLUE
		BubbleDefinitions.BubbleState.INSTAGRAM:
			if randf() >= 0.5:
				_bubble_sprite.texture = BUBBLE_SPRITE_PINK
				_mouse_collision_shape.debug_color = Color.DEEP_PINK
			else:
				_bubble_sprite.texture = BUBBLE_SPRITE_PINK_ALT
				_mouse_collision_shape.debug_color = Color.HOT_PINK


func _update_bubble_state_as_per_distribution() -> void:
	var previous_bubble_state: BubbleDefinitions.BubbleState = bubble_state
	var bubble_states: Array[BubbleDefinitions.BubbleState] = [
		BubbleDefinitions.BubbleState.WHATSAPP,
		BubbleDefinitions.BubbleState.FACEBOOK,
		BubbleDefinitions.BubbleState.INSTAGRAM,
	]
	
	var next_bubble_state_picker: float = randf()
	var next_bubble_state: BubbleDefinitions.BubbleState
	
	for bubble_state in bubble_states:
		if (next_bubble_state_picker < distributions[bubble_state]):
			next_bubble_state = bubble_state
			break
	
	if next_bubble_state == previous_bubble_state:
		_update_bubble_state_as_per_distribution()
		return
	else:
		bubble_state = next_bubble_state
	
	_update_sprite(previous_bubble_state)


func _prepare_to_grow() -> void:
	_mouse_collision_shape.scale = Vector2(0.0, 0.0)
	_body_collision_shape.scale = Vector2(0.0, 0.0)


func _ready() -> void:
	seed(1)
	randomize()
	_calculate_variable_size_difference()
	_calculate_distribution_ranges()
	_calculate_variable_time_to_convert()
	_update_sprite(bubble_state)
	_prepare_to_grow()


func _animate_size_update_for_neutral_state(time_to_update_milliseconds: float) -> void:
	var physics_growth: float = min(
		1.0, _elapsed_time_milliseconds / (time_to_update_milliseconds * 0.4)
	)
	physics_growth += _fixed_size_difference
	
	var clickable_growth := _ease_out_elastic(physics_growth) * _variable_size_difference
	clickable_growth += _fixed_size_difference
	
	var visual_growth: float = clickable_growth * 0.2
	
	_mouse_collision_shape.scale = Vector2(clickable_growth, clickable_growth)
	_bubble_sprite.scale = Vector2(visual_growth, visual_growth)
	_body_collision_shape.scale = Vector2(physics_growth, physics_growth)


func _calculate_time_to_update_for_non_neutral_state() -> float:
	var min_target := _min_time_to_swap_milliseconds
	var max_target := _max_time_to_swap_milliseconds
	
	var currrent_bubbles_amount := get_tree().get_nodes_in_group("bubble").size()
	var percentage := currrent_bubbles_amount * 1.0 / initial_bubbles_amount
	var calculated := min_target + (max_target - min_target) * percentage
	
	return calculated


func _ease_out_elastic(number: float) -> float:
	if number == 0:
		return 0
	elif number == 1:
		return 1
	else:
		return (
			pow(2, -10 * number) * sin(((number * 10) - 0.75) * ((2 * PI) / 3))
		) + 1


func _ease_in_circular(number: float) -> float:
	return 1 - sqrt(1 - pow(number, 2))


var _elapsed_time_milliseconds: float = 0.0
func _process(delta_seconds: float) -> void:
	_elapsed_time_milliseconds += (delta_seconds * 1000)
	
	var time_to_update_milliseconds: float
	match (bubble_state):
		BubbleDefinitions.BubbleState.NEUTRAL:
			time_to_update_milliseconds = _time_to_convert_milliseconds
			_animate_size_update_for_neutral_state(time_to_update_milliseconds)
		BubbleDefinitions.BubbleState.WHATSAPP:
			time_to_update_milliseconds = _calculate_time_to_update_for_non_neutral_state()
		BubbleDefinitions.BubbleState.FACEBOOK:
			time_to_update_milliseconds = _calculate_time_to_update_for_non_neutral_state()
		BubbleDefinitions.BubbleState.INSTAGRAM:
			time_to_update_milliseconds = _calculate_time_to_update_for_non_neutral_state()
	
	if (_elapsed_time_milliseconds >= time_to_update_milliseconds):
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
