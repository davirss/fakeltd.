extends Node2D

@export var total_bubbles  = 1
@export var current_bubbles = 0

@export var column_number = 10
@export var row_number = 20

var current_active_bubbles = 0

var groupa_popped_bubbles = 0
var groupb_popped_bubbles = 0
var groupc_popped_bubbles = 0

var bubble_spawn_cooldown = 10
var bubble_spawn_countdown: float = 0

var bubble_change_cooldown = 2
var bubble_change_countdown = bubble_change_cooldown

var selected_group
var round_started = false

@export var placeholder: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Every X amount of time, notify all bubbles to change.
	# Check if the number of bubbles match the total_bubbles
	# If it doesn't match, it means that one or more bubbles were popped.
	# If not, schedule spawn.
	Global.bubble_clicked.connect(_on_bubble_clicked)
	Global.on_venn_pressed.connect(_on_ven_pressed)

func _on_ven_pressed(left, top, right) -> void:
	$VennController.selected = true
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
	
	$AnimationPlayer.play("ven_animation")
	await $AnimationPlayer.animation_finished
	_start_round()

func _start_round() -> void:
	print("Start")
	round_started = true
	## Spawn the total_bubbles
	_spawn_bubbles()

func _spawn_bubbles() -> void:
	print("spawning")
	var current_column = 0
	var current_line = 0
	for i in total_bubbles:
		var new_bubble = placeholder.instantiate()

		new_bubble.center = $Field/Marker2D.position
		new_bubble.position.x = current_column * 20
		new_bubble.position.y = current_line * 32
		$Field.add_child(new_bubble)

		current_column += 1
		if (current_column == column_number):
			current_line += 1
			current_column = 0
		current_bubbles += 1

func _on_wrong_bubble_popped() -> void:
	current_bubbles += 1
	
	var new_bubble = placeholder.instantiate()
	new_bubble.center = $Field/Marker2D.position
	new_bubble.position.x = randi_range(column_number / 2, column_number / 2 - 1) * 20
	new_bubble.position.y = randi_range(row_number / 2, row_number / 2 - 1) * 32
	$Field.add_child(new_bubble)
	
	var new_bubble_2 = placeholder.instantiate()
	new_bubble_2.center = $Field/Marker2D.position
	new_bubble_2.position.x = randi_range(column_number / 2, column_number / 2 - 1) * 20
	new_bubble_2.position.y = randi_range(row_number / 2, row_number / 2 - 1) * 32
	$Field.add_child(new_bubble_2)

func _on_bubble_clicked(state: BubbleDefinitions.BubbleState, bubble: Bubble) -> void:
	if (!selected_group.has(state)):
		print("Wrong bubble")
		_on_wrong_bubble_popped()
		bubble.queue_free()
		return

	if state == BubbleDefinitions.BubbleState.WHATSAPP:
		groupa_popped_bubbles += 1
	elif BubbleDefinitions.BubbleState.INSTAGRAM:
		groupb_popped_bubbles += 1
	elif BubbleDefinitions.BubbleState.FACEBOOK:
		groupc_popped_bubbles += 1

	current_bubbles -= 1
	bubble.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if round_started && !get_tree().has_group("bubble"):
		round_started = false
		$AnimationPlayer.play_backwards("ven_animation")
		await $AnimationPlayer.animation_finished
		$VennController.selected = false

	if round_started:
		_check_buble_spawn_countdown()
		if (bubble_spawn_countdown >= 0):
			bubble_spawn_countdown -= delta
			print(str(bubble_spawn_countdown))

func _check_buble_spawn_countdown(): 
	print(bubble_spawn_countdown)
	if bubble_spawn_countdown <= 0:
		bubble_spawn_countdown = bubble_spawn_cooldown
		#current_bubbles += 1
		# Spawn new bubble
		var new_bubble = placeholder.instantiate()
		new_bubble.center = $Field/Marker2D.position
		new_bubble.position.x = randi_range(column_number / 2, column_number / 2 - 1) * 20
		new_bubble.position.y = randi_range(row_number / 2, row_number / 2 - 1) * 32
		$Field.add_child(new_bubble)
