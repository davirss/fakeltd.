extends Node2D

var right = false
var left = false
var bot = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("Select"):
		_send_signal()

func _on_left_mouse_entered() -> void:
	left = true
	right = false
	bot = false
	$Left.modulate = Color.BLACK

func _on_left_mouse_exited() -> void:
	left = true
	right = false
	bot = false
	$Left.modulate = Color.WHITE

func _on_right_mouse_entered() -> void:
	left = false
	right = true
	bot = false
	$Right.modulate = Color.BLACK

func _on_right_mouse_exited() -> void:
	left = false
	right = false
	bot = false
	$Right.modulate = Color.WHITE

func _on_bottom_mouse_entered() -> void:
	left = true
	right = false
	bot = false
	$Bottom.modulate = Color.BLACK

func _on_bottom_mouse_exited() -> void:
	left = true
	right = false
	bot = false
	$Bottom.modulate = Color.WHITE

func _on_left_right_intersect_mouse_entered() -> void:
	left = true
	right = true
	bot = false
	$LeftRightIntersect.modulate = Color.BLACK

func _on_left_right_intersect_mouse_exited() -> void:
	left = false
	right = false
	bot = false
	$LeftRightIntersect.modulate = Color.WHITE

func _on_left_bot_intersect_mouse_entered() -> void:
	left = true
	right = false
	bot = true
	$LeftBotIntersect.modulate = Color.BLACK

func _on_left_bot_intersect_mouse_exited() -> void:
	left = false
	right = false
	bot = false
	$LeftBotIntersect.modulate = Color.WHITE

func _on_right_bot_intersect_mouse_entered() -> void:
	left = false
	right = true
	bot = true
	$RightBotIntersect.modulate = Color.BLACK

func _on_right_bot_intersect_mouse_exited() -> void:
	left = false
	right = false
	bot = false
	$RightBotIntersect.modulate = Color.WHITE

func _on_center_mouse_entered() -> void:
	left = true
	right = true
	bot = true
	$Center.modulate = Color.BLACK

func _on_center_mouse_exited() -> void:
	left = false
	right = false
	bot = false
	$Center.modulate = Color.WHITE

func _send_signal():
	print("Sending signal", left, bot, right)
	Global.on_venn_pressed.emit(left, bot, right)
