extends Node

# Days manager
var starting_day = 0
var current_day = 0
var max_days = 7

# User Info
var starting_followers = 100
var current_followers = starting_followers
var daily_increase_factor = 0.2
var daily_new = current_followers * daily_increase_factor

# Post Info
var current_reach = 100
var spread_factor = 0.1
var messages = 100 * 0.05
var likes = 100 * 0.25
var shares = 100 * 0.25

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		advance_day()

func advance_day() -> void:
	# TODO: Animate the increase.
	if (starting_day < max_days):
		starting_day += 1
		update_user_statistics()
		update_post_statistics()
		print("Going to next day..", current_followers)
	else:
		print("Fact Checked the run. Your reach was: ", current_reach)
		# TODO: Go to upgrades
		pass

func update_user_statistics():
	daily_new = starting_followers * daily_increase_factor
	current_followers += current_followers + daily_new
	current_reach += current_followers * spread_factor
	$UserInfo.current_followers = current_followers
	$UserInfo.daily_new = daily_new

func update_post_statistics():
	$Post.likes = likes
	$Post.messages = messages
	$Post.reshares = shares
