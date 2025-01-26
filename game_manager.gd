extends GameManagerDefinitions

@export var initial_bubbles_amount  = 20

var _ft_variable_margin_percent = 0.1

var groupa_popped_bubbles = 0
var groupb_popped_bubbles = 0
var groupc_popped_bubbles = 0

var bubble_spawn_cooldown = 1
var bubble_spawn_countdown: float = 0

var bubble_change_cooldown = 2
var bubble_change_countdown = bubble_change_cooldown

var selected_group
var round_started = false

@onready var audio = $AudioStreamPlayer2D
@export var placeholder: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SPAWNING_MARKER.floating_target = FLOATING_TARGET
	
	# Every X amount of time, notify all bubbles to change.
	# Check if the number of bubbles match the initial_bubbles_amount
	# If it doesn't match, it means that one or more bubbles were popped.
	# If not, schedule spawn.
	Global.bubble_clicked.connect(_on_bubble_clicked)
	Global.on_venn_pressed.connect(_on_ven_pressed)

func _on_ven_pressed(left, top, right) -> void:
	if left && !top && !right:
		selected_group = [BubbleDefinitions.BubbleState.WHATSAPP]
	elif !left && top && !right:
		selected_group = [BubbleDefinitions.BubbleState.FACEBOOK]
	elif !left && !top && right:
		selected_group = [BubbleDefinitions.BubbleState.INSTAGRAM]
	elif left && top && !right:
		selected_group = [BubbleDefinitions.BubbleState.WHATSAPP, BubbleDefinitions.BubbleState.FACEBOOK]
	elif left && !top && right:
		selected_group = [BubbleDefinitions.BubbleState.WHATSAPP, BubbleDefinitions.BubbleState.INSTAGRAM]
	elif !left && top && right:
		selected_group = [BubbleDefinitions.BubbleState.FACEBOOK, BubbleDefinitions.BubbleState.INSTAGRAM]
	elif left && top && right:
		selected_group = [BubbleDefinitions.BubbleState.WHATSAPP, BubbleDefinitions.BubbleState.FACEBOOK, BubbleDefinitions.BubbleState.INSTAGRAM]
	else:
		print("Invalid state:", left, top, right)
	
	_minimize_diagram()
	_start_round()

func _minimize_diagram():
	$VennController.selected = true
	$AnimationPlayer.play("ven_animation")
	await $AnimationPlayer.animation_finished

func _maximize_diagram():
	$AnimationPlayer.play_backwards("ven_animation")
	await $AnimationPlayer.animation_finished
	$VennController.selected = false

func _start_round() -> void:
	round_started = true
	## Spawn the initial_bubbles_amount
	_spawn_initial_bubbles()

func _spawn_initial_bubbles() -> void:
	for i in initial_bubbles_amount:
		_spawn_new_bubble()

func _on_wrong_bubble_popped() -> void:
	_spawn_new_bubble()
	_spawn_new_bubble()

func _on_bubble_clicked(state: BubbleDefinitions.BubbleState, bubble: Bubble) -> void:
	if (!selected_group.has(state)):
		print("Wrong bubble")
		_on_wrong_bubble_popped()
		bubble.queue_free()
		audio.stream = load("res://Resources/Sounds/Pop Sound Effects -2.ogg")
		add_child(audio)
		audio.play()
		return
		
	audio.stream = load("res://Resources/Sounds/Pop Sound Effects -3.ogg")
	audio.play()

	if state == BubbleDefinitions.BubbleState.WHATSAPP:
		groupa_popped_bubbles += 1
	elif BubbleDefinitions.BubbleState.INSTAGRAM:
		groupb_popped_bubbles += 1
	elif BubbleDefinitions.BubbleState.FACEBOOK:
		groupc_popped_bubbles += 1
	else:
		_on_wrong_bubble_popped()
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
	if round_started && !get_tree().has_group("bubble"):
		round_started = false

	if round_started:
		_check_buble_spawn_countdown()
		if (bubble_spawn_countdown >= 0):
			bubble_spawn_countdown -= delta

func _check_buble_spawn_countdown(): 
	if bubble_spawn_countdown <= 0:
		bubble_spawn_countdown = bubble_change_cooldown
		_spawn_new_bubble()

func _game_over():
	round_started = false
	var nodes = get_tree().get_nodes_in_group("bubble");
	for bubble in nodes:
		# TODO: Animate all bubbles bursting
		bubble.queue_free()
	_maximize_diagram()

func _on_area_2d_body_exited(body: Node2D) -> void:
	print("exited")
	print("Body is bubble:", body, body.is_queued_for_deletion())
	if body.is_in_group("bubble") && !body.is_queued_for_deletion():
		_game_over()
