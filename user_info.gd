extends VBoxContainer

# User Info
@export var current_followers: int:
	set(value):
		current_followers = value
		# TODO: Extract icons.
		# TODO: Format values to only 3 digits
		var formatted_number: String
		if (current_followers >= 8_201_490_228):
			formatted_number = "👤 All 🌍"
		elif (current_followers >= 1_000_000_000):
			formatted_number = "👤 %3.1fB" % [current_followers / 1_000_000_000.0]
		elif (current_followers >= 100_000_000):
			formatted_number = "👤 %3dM" % [current_followers / 1_000_000.0]
		elif (current_followers >= 1_000_000):
			formatted_number = "👤 %3.1fM" % [current_followers / 1_000_000.0]
		elif (current_followers >= 100_000):
			formatted_number = "👤 %3dk" % [current_followers / 1_000.0]
		elif (current_followers >= 1_000):
			formatted_number = "👤 %3.1fk" % [current_followers / 1_000.0]
		else:
			formatted_number = "👤 %d" % [current_followers]
		$HBoxContainer/CurrentFollowers.text = formatted_number


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
