extends Node

@export var total_bubles  = 100
@export var current_bubbles = 100

@export var column_number = 10
@export var row_number = 20

var current_active_bubbles = 0

var groupa_popped_bubbles = 0
var groupb_popped_bubbles = 0
var groupc_popped_bubbles = 0

var bubble_spawn_cooldown = 1
var bubble_spawn_countdown = 0

var bubble_change_cooldown = 5
var bubble_change_countdown = bubble_change_cooldown

var selected_group = Groups.ONE

@export var placeholder: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Every X amount of time, notify all bubbles to change.
	# Check if the number of bubbles match the total_bubbles
	# If it doesn't match, it means that one or more bubbles were popped.
	# If not, schedule spawn.
	_start_round()

func _start_round() -> void:
	## Spawn the total_bubbles
	_spawn_bubbles()

func _spawn_bubbles() -> void:
	var current_column = 0
	var current_line = 0
	for i in total_bubles:
		var new_bubble = placeholder.instantiate()
		
		new_bubble.position.x = current_column * 20
		new_bubble.position.y = current_line * 32
		$Field.add_child(new_bubble)
		
		current_column += 1
		if (current_column == column_number):
			current_line += 1
			current_column = 0

func _on_wrong_bubble_popped() -> void:
	total_bubles -= 1
	current_bubbles -= 1
	pass

func _on_correct_bubble_popped(targetGroup) -> void:
	if (targetGroup != selected_group):
		_on_wrong_bubble_popped()
		return

	if targetGroup == Groups.ONE:
		groupa_popped_bubbles += 1
	elif targetGroup == Groups.TWO:
		groupb_popped_bubbles += 1
	else:
		groupc_popped_bubbles += 1
		
	bubble_spawn_countdown = bubble_spawn_cooldown
	current_bubbles -= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_on_correct_bubble_popped(Groups.ONE)

	if current_bubbles < total_bubles && bubble_spawn_countdown <= 0:
		current_bubbles += 1
		# Spawn new bubble
		var new_bubble = placeholder.instantiate()
		new_bubble.position = $Field/Marker2D.position
		$Field.add_child(new_bubble)

	bubble_change_countdown -= delta
	if bubble_change_countdown <= 0:
		Global.switch_bubbles.emit()
		bubble_change_countdown = bubble_change_cooldown

	if (bubble_spawn_countdown >= 0):
		bubble_spawn_countdown -= delta
		print(bubble_spawn_countdown)

enum Groups { ONE, TWO, THREE}
