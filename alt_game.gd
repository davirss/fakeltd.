extends Node2D

@export var object_to_spawn: PackedScene  # Assign in Inspector
@export var slime_bubble: PackedScene  # Assign in Inspector
@onready var timer: Timer = $Timer  # Ensure a Timer is in the scene
@onready var spawn_area: Area2D = $SpawnZone  # Assign your Area2D node
@onready var spawn_zone = $SpawnZone/CollisionShape2D
@onready var score_label = $"Debug controls"/MarginContainer/VBoxContainer/HBoxContainer/TotalBubblesLabel
@onready var level_label = $"Debug controls"/MarginContainer/VBoxContainer/HBoxContainer/LevelLabel
@onready var spawn_chcker = $SpawnChecker
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
	#for i in range(10):
		#var final_position: Vector2
		##while true:
		#final_position = get_random_point_inside()
			##if _can_spawn_bubble(final_position):
				##break
		#var new_object = object_to_spawn.instantiate()
		#new_object.bubble_hp = randi_range(1, current_level)
		## Check if there is a bubble in the same position, generate new position if so.
		#new_object.position = final_position
		#new_object.add_to_group("bubble")
		#add_child(new_object)
		#await get_tree().create_timer(1).timeout

func can_spawn_without_collision(spawn_position: Vector2, spawn_radius: float, existing_circles: Array) -> bool:
	for obj in existing_circles:
		if not obj.has_node("CollisionShape2D"):
			continue

		var other_radius = obj.get_node("CollisionShape2D").shape.radius
		var other_position = obj.global_position

		var total_radius = spawn_radius + other_radius
		var distance = spawn_position.distance_to(other_position)

		if distance < total_radius:
			print("Will collide")
			return false  # Collision would happen
	print("Wont collide")
	return true  # Safe to spawn

func _process(delta: float) -> void:
	score_label.text = str(current_bubbles, "/", current_bubbles_level)
	level_label.text = str("LEVEL ", current_level)

func get_random_point_inside():
	var shape = spawn_zone.shape
	if shape is RectangleShape2D:
		var extents = shape.extents
		var random_x = randf_range(-extents.x, extents.x)
		var random_y = randf_range(-extents.y, extents.y)
		return spawn_zone.global_position + Vector2(random_x, random_y)
	return Vector2.ZERO

func spawn_object():
	var spawn_position = get_random_point_inside()
	$BubbleSpawner.position = spawn_position
	if not can_spawn_without_collision(spawn_position, 62.0, get_tree().get_nodes_in_group("bubble")):
		return

	if current_level == 1:
		if object_to_spawn:
			spawn_default_bubble(spawn_position)
	elif current_level >= 2:
		if randi_range(0, 1):
			if object_to_spawn:
				spawn_default_bubble(spawn_position)
		else:
			spawn_default_slime(spawn_position)
	
func spawn_default_bubble(spawn_position: Vector2):
	var new_object = object_to_spawn.instantiate()
	new_object.bubble_hp = randi_range(1, current_level)
	new_object.position = spawn_position
	new_object.add_to_group("bubble")
	new_object.is_evil = randi() % 4 == 0
	$BubbleField.add_child(new_object)
	
func spawn_default_slime(spawn_position: Vector2):
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
	var label = $"Debug controls/MarginContainer/VBoxContainer/HBoxContainer3/StrengthLabel"
	label.text = str(Global.pop_strength)


func _on_pop_radius_slider_value_changed(value: float) -> void:
	var popper = $Popper
	popper.scale = Vector2(value/10, value/10)


func _on_spawn_time_slider_value_changed(value: float) -> void:
	bubble_spawn_time = 0.5 - (value / 100 * 2) 
	$Timer.wait_time = bubble_spawn_time


func _on_dead_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("bubble"):
		body.explode()
