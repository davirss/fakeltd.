extends Node2D

# Variables to manage time
var time_elapsed: float = 0.0
var timer_running: bool = true  # Controls whether the timer is active

# Reference to the label for displaying time
@onready var time_label: Label = $Label  # Adjust the path if needed

func _process(delta: float) -> void:
	if timer_running:
		# Increment elapsed time by delta (time between frames)
		time_elapsed += delta
		
		# Update the label with the formatted time
		update_time_display()

# Function to update the time display in MM:SS:MS format
func update_time_display():
	var minutes = int(time_elapsed / 60)
	var seconds = int(time_elapsed) % 60
	var milliseconds = int(time_elapsed * 100) % 100
	
	# Display as MM:SS:MS
	time_label.text = "Time: %02d:%02d.%02d" % [minutes, seconds, milliseconds]

# Function to reset the timer
func reset_timer():
	time_elapsed = 0.0
	update_time_display()

# Function to stop the timer
func stop_timer():
	timer_running = false

# Function to start the timer
func start_timer():
	timer_running = true

# Optional: toggle the timer state
func toggle_timer():
	timer_running = not timer_running
