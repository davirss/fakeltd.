extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var required_check = false
func _physics_process(delta: float) -> void:
	if required_check:
		required_check = false
		var touch_position = get_viewport().get_mouse_position()
		global_position = touch_position
		await get_tree().physics_frame
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body != null && !body.is_queued_for_deletion():
				body.damage(Global.pop_strength)
				await get_tree().create_timer(0.03).timeout
		if (bodies.size() > 0):
			$"../Camera2D".start_shake(1.5)

var can_press = true

func _input(event):
	if event.is_pressed():
		required_check = true


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#global_position = get_global_mouse_position()

#func _input(event: InputEvent) -> void:
#
	#if event is InputEventMouse and event.is_pressed() || event is InputEventScreenTouch or event is InputEventScreenDrag:
		#var touch_position = event.position
		#print("Touch position: ", touch_position)
		#global_position = touch_position
		#var bodies = get_overlapping_bodies()
		#for body in bodies:
			#if body != null && !body.is_queued_for_deletion():
				#body.damage(Global.pop_strength)
				#await get_tree().create_timer(0.03).timeout
