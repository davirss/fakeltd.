extends GameManagerDefinitions

@export var initial_bubbles_amount  = 20

var _round_started = false
var _selected_group: Array[BubbleDefinitions.BubbleState]
var _selected_distributions: Dictionary


var _ft_variable_margin_percent = 0.1

var groupa_popped_bubbles = 0
var groupb_popped_bubbles = 0
var groupc_popped_bubbles = 0

var bubble_spawn_cooldown = 10
var bubble_spawn_countdown: float = 0

var bubble_change_cooldown = 2
var bubble_change_countdown = bubble_change_cooldown


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
	Global.on_venn_pressed.connect(_on_ven_pressed)


func _on_ven_pressed(left, top, right) -> void:
	$VennController.selected = true
	
	if left && !top && !right:
		_selected_group = [
			BubbleDefinitions.BubbleState.FACEBOOK
		]
		_selected_distributions = {
			BubbleDefinitions.BubbleState.WHATSAPP: 	0.375,
			BubbleDefinitions.BubbleState.FACEBOOK: 	0.25,
			BubbleDefinitions.BubbleState.INSTAGRAM:	0.375,
		}
	elif !left && top && !right:
		_selected_group = [
			BubbleDefinitions.BubbleState.INSTAGRAM
		]
		_selected_distributions = {
			BubbleDefinitions.BubbleState.WHATSAPP: 	0.375,
			BubbleDefinitions.BubbleState.FACEBOOK: 	0.375,
			BubbleDefinitions.BubbleState.INSTAGRAM:	0.25,
		}
	elif !left && !top && right:
		_selected_group = [
			BubbleDefinitions.BubbleState.WHATSAPP
		]
		_selected_distributions = {
			BubbleDefinitions.BubbleState.WHATSAPP: 	0.25,
			BubbleDefinitions.BubbleState.FACEBOOK: 	0.375,
			BubbleDefinitions.BubbleState.INSTAGRAM:	0.375,
		}
	elif left && top && !right:
		_selected_group = [
			BubbleDefinitions.BubbleState.FACEBOOK,
			BubbleDefinitions.BubbleState.INSTAGRAM
		]
		_selected_distributions = {
			BubbleDefinitions.BubbleState.WHATSAPP: 	0.5,
			BubbleDefinitions.BubbleState.FACEBOOK: 	0.25,
			BubbleDefinitions.BubbleState.INSTAGRAM:	0.25,
		}
	elif left && !top && right:
		_selected_group = [
			BubbleDefinitions.BubbleState.FACEBOOK,
			BubbleDefinitions.BubbleState.WHATSAPP
		]
		_selected_distributions = {
			BubbleDefinitions.BubbleState.WHATSAPP: 	0.25,
			BubbleDefinitions.BubbleState.FACEBOOK: 	0.25,
			BubbleDefinitions.BubbleState.INSTAGRAM:	0.5,
		}
	elif !left && top && right:
		_selected_group = [
			BubbleDefinitions.BubbleState.WHATSAPP,
			BubbleDefinitions.BubbleState.INSTAGRAM
		]
		_selected_distributions = {
			BubbleDefinitions.BubbleState.WHATSAPP: 	0.25,
			BubbleDefinitions.BubbleState.FACEBOOK: 	0.5,
			BubbleDefinitions.BubbleState.INSTAGRAM:	0.25,
		}
	elif left && top && right:
		_selected_group = [
			BubbleDefinitions.BubbleState.WHATSAPP,
			BubbleDefinitions.BubbleState.FACEBOOK,
			BubbleDefinitions.BubbleState.INSTAGRAM
		]
		_selected_distributions = {
			BubbleDefinitions.BubbleState.WHATSAPP: 	0.33,
			BubbleDefinitions.BubbleState.FACEBOOK: 	0.33,
			BubbleDefinitions.BubbleState.INSTAGRAM:	0.33,
		}
	else:
		print("Invalid state:", left, top, right)
	
	$AnimationPlayer.play("ven_animation")
	await $AnimationPlayer.animation_finished
	_start_round()

func _start_round() -> void:
	_round_started = true
	## Spawn the initial_bubbles_amount
	_spawn_initial_bubbles()

func _spawn_initial_bubbles() -> void:
	for i in initial_bubbles_amount:
		_spawn_new_bubble(true)


func _on_wrong_bubble_popped() -> void:
	_spawn_new_bubble(true)
	_spawn_new_bubble(true)


func _on_bubble_clicked(state: BubbleDefinitions.BubbleState, bubble: Bubble) -> void:
	if (!_selected_group.has(state)):
		print("Wrong bubble")
		_on_wrong_bubble_popped()
		bubble.queue_free()
		audio.stream = load("res://Resources/Sounds/Pop Sound Effects.ogg")
		add_child(audio)
		audio.play()
		return
	
	audio.stream = load("res://Resources/Sounds/Pop Sound Effects -2.ogg")
	add_child(audio)
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


func _spawn_new_bubble(is_init_or_from_mistake: bool) -> void:
	if not is_init_or_from_mistake:
		var currrent_bubbles_amount := get_tree().get_nodes_in_group("bubble").size()
		if currrent_bubbles_amount == 1:
			return
	
	audio.stream = load("res://Resources/Sounds/Pop Sound Effects -3.ogg")
	add_child(audio)
	audio.play()
	
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
	new_bubble.distributions = _selected_distributions.duplicate(true)
	new_bubble.initial_bubbles_amount = initial_bubbles_amount
	FIELD.add_child(new_bubble)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _round_started && !get_tree().has_group("bubble"):
		_round_started = false
		$AnimationPlayer.play_backwards("ven_animation")
		await $AnimationPlayer.animation_finished
		$VennController.selected = false

	if _round_started:
		_check_buble_spawn_countdown()
		if (bubble_spawn_countdown >= 0):
			bubble_spawn_countdown -= delta


func _check_buble_spawn_countdown(): 
	if bubble_spawn_countdown <= 0:
		bubble_spawn_countdown = bubble_spawn_cooldown
		_spawn_new_bubble(false)
