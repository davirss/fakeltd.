extends Node2D

var right = false
var left = false
var top = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("Select"):
		_send_signal()

func _on_left_mouse_entered() -> void:
	left = true
	right = false
	top = false
	$Left.modulate = Color.BLACK

func _on_left_mouse_exited() -> void:
	left = true
	right = false
	top = false
	$Left.modulate = Color.WHITE

func _on_right_mouse_entered() -> void:
	left = false
	right = true
	top = false
	$Right.modulate = Color.BLACK

func _on_right_mouse_exited() -> void:
	left = false
	right = false
	top = false
	$Right.modulate = Color.WHITE

func _on_bottom_mouse_entered() -> void:
	left = false
	right = false
	top = true
	$Top.modulate = Color.BLACK

func _on_bottom_mouse_exited() -> void:
	left = false
	right = false
	top = false
	$Top.modulate = Color.WHITE

func _on_left_right_intersect_mouse_entered() -> void:
	left = true
	right = true
	top = false
	$LeftRightIntersect.modulate = Color.BLACK

func _on_left_right_intersect_mouse_exited() -> void:
	left = false
	right = false
	top = false
	$LeftRightIntersect.modulate = Color.WHITE

func _on_left_bot_intersect_mouse_entered() -> void:
	left = true
	right = false
	top = true
	$LeftTopIntersect.modulate = Color.BLACK

func _on_left_bot_intersect_mouse_exited() -> void:
	left = false
	right = false
	top = false
	$LeftTopIntersect.modulate = Color.WHITE

func _on_right_bot_intersect_mouse_entered() -> void:
	left = false
	right = true
	top = true
	$RightTopIntersect.modulate = Color.BLACK

func _on_right_bot_intersect_mouse_exited() -> void:
	left = false
	right = false
	top = false
	$RightTopIntersect.modulate = Color.WHITE

func _on_center_mouse_entered() -> void:
	left = true
	right = true
	top = true
	$Center.modulate = Color.BLACK

func _on_center_mouse_exited() -> void:
	left = false
	right = false
	top = false
	$Center.modulate = Color.WHITE

func _send_signal():
	if (left || top || right):
		print("Sending signal", left, top, right)
		Global.on_venn_pressed.emit(left, top, right)
