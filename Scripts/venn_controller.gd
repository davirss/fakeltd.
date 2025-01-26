extends VennControllerDefinitions


var right = false
var left = false
var top = false
var selected = false

@onready var _left_piece = LEFT_PIECE
@onready var _left_right_piece = LEFT_RIGHT_PIECE
@onready var _right_piece = RIGHT_PIECE
@onready var _right_top_piece = RIGHT_TOP_PIECE
@onready var _top_piece = TOP_PIECE
@onready var _top_left_piece = LEFT_TOP_PIECE
@onready var _center_piece = CENTER_PIECE


func _ready():
	_fade_all()


func _process(delta: float) -> void:
	if !selected && (Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("Select")):
		_send_signal(left, top, right)


func _fade_none() -> void:
	if selected:
		return
	
	_left_piece.modulate = Color.WHITE
	_left_right_piece.modulate = Color.WHITE
	_right_piece.modulate = Color.WHITE
	_right_top_piece.modulate = Color.WHITE
	_top_piece.modulate = Color.WHITE
	_top_left_piece.modulate = Color.WHITE
	_center_piece.modulate = Color.WHITE


func _fade_all() -> void:
	if selected:
		return
	
	_left_piece.modulate = Color(1.0, 1.0, 1.0, 0.25)
	_left_right_piece.modulate = Color(1.0, 1.0, 1.0, 0.25)
	_right_piece.modulate = Color(1.0, 1.0, 1.0, 0.25)
	_right_top_piece.modulate = Color(1.0, 1.0, 1.0, 0.25)
	_top_piece.modulate = Color(1.0, 1.0, 1.0, 0.25)
	_top_left_piece.modulate = Color(1.0, 1.0, 1.0, 0.25)
	_center_piece.modulate = Color(1.0, 1.0, 1.0, 0.25)


func _fade_all_except(pieces: Array[Area2D]) -> void:
	if selected:
		return
	
	_fade_all()
	
	for piece in pieces:
		piece.modulate = Color.WHITE


func _on_left_mouse_entered() -> void:
	left = true
	right = false
	top = false
	_fade_all_except([_left_piece])


func _on_left_mouse_exited() -> void:
	left = true
	right = false
	top = false
	_fade_all()


func _on_right_mouse_entered() -> void:
	left = false
	right = true
	top = false
	_fade_all_except([_right_piece])


func _on_right_mouse_exited() -> void:
	left = false
	right = false
	top = false
	_fade_all()


func _on_bottom_mouse_entered() -> void:
	left = false
	right = false
	top = true
	_fade_all_except([_top_piece])


func _on_bottom_mouse_exited() -> void:
	left = false
	right = false
	top = false
	_fade_all()


func _on_left_right_intersect_mouse_entered() -> void:
	left = true
	right = true
	top = false
	_fade_all_except([_left_piece, _left_right_piece, _right_piece])


func _on_left_right_intersect_mouse_exited() -> void:
	left = false
	right = false
	top = false
	_fade_all()


func _on_left_bot_intersect_mouse_entered() -> void:
	left = true
	right = false
	top = true
	_fade_all_except([_top_piece, _top_left_piece, _left_piece])


func _on_left_bot_intersect_mouse_exited() -> void:
	left = false
	right = false
	top = false
	_fade_all()


func _on_right_bot_intersect_mouse_entered() -> void:
	left = false
	right = true
	top = true
	_fade_all_except([_right_piece, _right_top_piece, _top_piece])


func _on_right_bot_intersect_mouse_exited() -> void:
	left = false
	right = false
	top = false
	_fade_all()


func _on_center_mouse_entered() -> void:
	left = true
	right = true
	top = true
	_fade_none()


func _on_center_mouse_exited() -> void:
	left = false
	right = false
	top = false
	_fade_all()


func _send_signal(left, top, right):
	if (left || top || right):
		print("Sending signal", left, top, right)
		Global.on_venn_pressed.emit(left, top, right)
		left = false
		right = false
		top = false
