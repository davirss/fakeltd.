extends VBoxContainer

# User Info
@export var current_followers: int: 
	set(value):
		# TODO: Format values to only 3 digits
		current_followers = value
		# TODO: Extract icons.
		$HBoxContainer/CurrentFollowers.text = "👤" + str(current_followers) + "k"


@export var daily_new: float:
	set(value):
		daily_new = value
		$HBoxContainer/DailyNew.text = "+" + str(value) + "/day"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
