extends GameManagerDefinitions

@export var initial_bubbles_amount  = 50

var _ft_variable_margin_percent = 0.1

var groupa_popped_bubbles = 0
var groupb_popped_bubbles = 0
var groupc_popped_bubbles = 0

var bubble_spawn_cooldown = 1
var bubble_spawn_countdown = 0

var bubble_change_cooldown = 2
var bubble_change_countdown = bubble_change_cooldown

var selected_group = BubbleDefinitions.BubbleState.INSTAGRAM

var audio = AudioStreamPlayer.new()
@export var placeholder: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SPAWNING_MARKER.floating_target = FLOATING_TARGET
	
	# Every X amount of time, notify all bubbles to change.
	# Check if the number of bubbles match the initial_bubbles_amount
	# If it doesn't match, it means that one or more bubbles were popped.
	# If not, schedule spawn.
	Global.bubble_clicked.connect(_on_bubble_clicked)
	_start_round()


func _start_round() -> void:
	## Spawn the initial_bubbles_amount
	_spawn_initial_bubbles()


func _spawn_initial_bubbles() -> void:
	for i in initial_bubbles_amount:
		_spawn_new_bubble()


func _on_wrong_bubble_popped() -> void:
	_spawn_new_bubble()
	_spawn_new_bubble()


func _on_bubble_clicked(state: BubbleDefinitions.BubbleState, bubble: Bubble) -> void:
	if (state != selected_group):
		_on_wrong_bubble_popped()
		bubble.queue_free()
		audio.stream = load("res://Resources/Sounds/Pop Sound Effects -2.ogg")
		add_child(audio)
		audio.play()
		return
	else:
		audio.stream = load("res://Resources/Sounds/Pop Sound Effects -3.ogg")
		add_child(audio)
		audio.play()
		return
	
	if state == BubbleDefinitions.BubbleState.WHATSAPP:
		groupa_popped_bubbles += 1
	elif BubbleDefinitions.BubbleState.INSTAGRAM:
		groupb_popped_bubbles += 1
	elif BubbleDefinitions.BubbleState.FACEBOOK:
		groupc_popped_bubbles += 1
	else:
		_on_wrong_bubble_popped()
		return
	
	bubble.queue_free()


func _spawn_new_bubble() -> void:
	# Spawn new bubble
	var new_bubble = placeholder.instantiate()
	new_bubble.floating_target = FLOATING_TARGET
	new_bubble.position.x = randi_range(
		SPAWNING_MARKER.position.x * (1 - _ft_variable_margin_percent),
		SPAWNING_MARKER.position.x * (1 + _ft_variable_margin_percent),
	)
	new_bubble.position.y = randi_range(
		SPAWNING_MARKER.position.y * (1 - _ft_variable_margin_percent),
		SPAWNING_MARKER.position.y * (1 + _ft_variable_margin_percent),
	)
	FIELD.add_child(new_bubble)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bubble_spawn_countdown <= 0:
		bubble_spawn_countdown = bubble_change_cooldown
		_spawn_new_bubble()
	
	bubble_change_countdown -= delta
	if bubble_change_countdown <= 0:
		bubble_change_countdown = bubble_change_cooldown
	
	if (bubble_spawn_countdown >= 0):
		bubble_spawn_countdown -= delta
		print(bubble_spawn_countdown)
