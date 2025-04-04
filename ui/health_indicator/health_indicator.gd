@tool
extends Control

@export var max_hearts: int = 10:
	set(value):
		max_hearts = value
		_update_hearts()

@export var current_hearts: int = 7:
	set(value):
		current_hearts = value
		_update_hearts()

@export var columns: int = 5:
	set(value):
		columns = max(1, value)
		if $HeartsGrid:
			$HeartsGrid.columns = columns
			_update_hearts()

@export var full_heart_texture: Texture2D = preload("res://Resources/heart.png")
@export var empty_heart_texture: Texture2D = preload("res://Resources/heart.png")

func _ready():
	$HeartsGrid.columns = columns
	_update_hearts()

func _update_hearts():
	if not is_inside_tree():
		return
	if !full_heart_texture or !empty_heart_texture:
		return

	var grid = $HeartsGrid
	grid.columns = columns

	# Clear existing hearts
	for child in grid.get_children():
		child.queue_free()

	# Add new hearts
	for i in max_hearts:
		var heart = TextureRect.new()
		heart.texture = full_heart_texture if i < current_hearts else empty_heart_texture
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		heart.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		heart.custom_minimum_size = Vector2(62, 62)
		grid.add_child(heart)

	queue_redraw()
