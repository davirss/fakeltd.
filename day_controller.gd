extends Node


var starting_day = 0
var current_day = 0
var max_days = 7

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		advance_day()

func advance_day() -> void:
	if (starting_day < max_days):
		print("Going to next day..")
		starting_day += 1
	else:
		print("Finish the run..")
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
