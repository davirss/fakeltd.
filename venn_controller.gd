extends Node2D

var right = false
var left = false
var bot = false

func _on_left_mouse_entered() -> void:
	$Left.modulate = Color.BLACK

func _on_left_mouse_exited() -> void:
	$Left.modulate = Color.WHITE

func _on_right_mouse_entered() -> void:
	$Right.modulate = Color.BLACK

func _on_right_mouse_exited() -> void:
	$Right.modulate = Color.WHITE

func _on_bottom_mouse_entered() -> void:
	$Bottom.modulate = Color.BLACK

func _on_bottom_mouse_exited() -> void:
	$Bottom.modulate = Color.WHITE

func _on_left_right_intersect_mouse_entered() -> void:
	$LeftRightIntersect.modulate = Color.BLACK

func _on_left_right_intersect_mouse_exited() -> void:
	$LeftRightIntersect.modulate = Color.WHITE

func _on_left_bot_intersect_mouse_entered() -> void:
	$LeftBotIntersect.modulate = Color.BLACK

func _on_left_bot_intersect_mouse_exited() -> void:
	$LeftBotIntersect.modulate = Color.WHITE

func _on_right_bot_intersect_mouse_entered() -> void:
	$RightBotIntersect.modulate = Color.BLACK

func _on_right_bot_intersect_mouse_exited() -> void:
	$RightBotIntersect.modulate = Color.WHITE

func _on_center_mouse_entered() -> void:
	$Center.modulate = Color.BLACK

func _on_center_mouse_exited() -> void:
	$Center.modulate = Color.WHITE
