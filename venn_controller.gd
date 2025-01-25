extends Node2D

var right = false
var left = false
var bot = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_right_venn_mouse_entered() -> void:
	right = true
	print("left, right, bot:", left, right, bot)

func _on_right_venn_mouse_exited() -> void:
	right = false
	print("left, right, bot:", left, right, bot)

func _on_left_venn_mouse_entered() -> void:
	left = true
	print("left, right, bot:", left, right, bot)

func _on_left_venn_mouse_exited() -> void:
	left = false
	print("left, right, bot:", left, right, bot)

func _on_bottom_venn_mouse_entered() -> void:
	bot = true
	print("left, right, bot:", left, right, bot)

func _on_bottom_venn_mouse_exited() -> void:
	bot = false
	print("left, right, bot:", left, right, bot)
