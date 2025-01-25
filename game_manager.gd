extends Node

var total_bubles  = 100
var current_active_bubbles = 0

var groupa_bubbles = 0
var groupa_popped_bubbles = 0

var groupb_bubbles = 0
var groupb_popped_bubbles = 0

var groupc_bubbles = 0
var groupc_popped_bubbles = 0

var list
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check if the number of bubbles match the total_bubbles
	# If it doesn't match, it means that one or more bubbles were popped.
	# If not, schedule spawn.
	pass # Replace with function body.
	
func _start_round() -> void:
	## Spawn the total_bubbles
	pass

func _on_wrong_bubble_popped() -> void:
	total_bubles -= 1
	pass

func _on_correct_bubble_popped(targetGroup) -> void:
	if targetGroup == Groups.ONE:
		groupa_popped_bubbles += 1
	elif targetGroup == Groups.TWO:
		groupb_popped_bubbles += 1
	else:
		groupc_popped_bubbles += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

enum Groups { ONE, TWO, THREE}
