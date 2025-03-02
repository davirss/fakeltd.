extends Node2D

@export var object_to_spawn: PackedScene  # Assign in Inspector
@export var slime_bubble: PackedScene  # Assign in Inspector
@onready var timer: Timer = $Timer  # Ensure a Timer is in the scene
@onready var spawn_area: Area2D = $SpawnZone  # Assign your Area2D node
@onready var spawn_zone = $SpawnZone/CollisionShape2D
@onready var score_label = $Container/MarginContainer/VBoxContainer/HBoxContainer/TotalBubblesLabel
@onready var level_label = $Container/MarginContainer/VBoxContainer/HBoxContainer/LevelLabel

var current_level = 1
var current_bubbles_level = current_level * 50
var current_bubbles = 0

var pop_radius = 1
var pop_strength = 1
var bubble_spawn_time = 0.5

func _ready():
	Global.bubble_popped.connect(_bubble_popped)
	timer.timeout.connect(spawn_object)
	timer.start()

func _process(delta: float) -> void:
	score_label.text = str(current_bubbles, "/", current_bubbles_level)
	level_label.text = str("LEVEL ", current_level)

func spawn_object():
	if current_level == 1:
		if object_to_spawn:
			var spawn_position = get_random_point_in_area()
			var new_object = object_to_spawn.instantiate()
			new_object.bubble_hp = randi_range(1, current_level)
			new_object.position = spawn_position
			add_child(new_object)
	elif current_level >= 2:
		if randi_range(0, 1):
			if object_to_spawn:
				var spawn_position = get_random_point_in_area()
				var new_object = object_to_spawn.instantiate()
				new_object.bubble_hp = randi_range(1, current_level)
				new_object.position = spawn_position
				add_child(new_object)
		else:
			var spawn_position = get_random_point_in_area()
			var new_object = slime_bubble.instantiate()
			#new_object.bubble_hp = randi_range(1, current_level)
			new_object.position = spawn_position
			add_child(new_object)
	
func _bubble_popped():
	current_bubbles += 1
	if (current_bubbles > current_bubbles_level):
		current_level += 1
		current_bubbles_level = current_level * 50

func get_random_point_in_area() -> Vector2:
	var rect = spawn_zone.shape.get_rect()
	var min_x = rect.position.x
	var min_y = rect.position.y
	var max_x = min_x + rect.size.x
	var max_y = min_y + rect.size.y
	return Vector2(randi_range(50, 1230), 750)


func _on_minus_button_pressed() -> void:
	if Global.pop_strength > 1:
		Global.pop_strength -= 1
	_update_label()


func _on_button_plus_pressed() -> void:
	Global.pop_strength += 1
	
	_update_label()

func _update_label():
	var label = $Container/MarginContainer/VBoxContainer/HBoxContainer3/StrengthLabel
	label.text = str(Global.pop_strength)


func _on_pop_radius_slider_value_changed(value: float) -> void:
	print(value)
	var popper = $Popper
	popper.scale = Vector2(value/10, value/10)


func _on_spawn_time_slider_value_changed(value: float) -> void:
	bubble_spawn_time = 0.5 - (value / 100 * 2) 
	$Timer.wait_time = bubble_spawn_time
