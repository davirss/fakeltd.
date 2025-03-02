extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


var object_to_spawn = preload("res://alt/slime/slime_bubble.tscn")
@onready var audio = $AudioStreamPlayer2D

var time_elapsed = 0.0
@onready var amplitude = randf_range(0.5, 0.6)  # Maximum movement range
@onready var frequency = randf_range(2.0, 2.5)  # How fast it wiggles (higher = faster)
@onready var velocity_multiplier = 50.0  # Controls speed of movement
@onready var max_fall = randf_range(-50.0, -55.0)
@onready var bubble_hp_label = $BubbleHP
@onready var pop_sound = preload("res://Resources/Sounds/Pop Sound Effects.ogg")
@onready var damage_sound = preload("res://Resources/Sounds/Pop Sound Effects -6.ogg")

var bubble_hp = 2
var freeze_time = 0
var force_left = false
var force_right = false

var spawn_animation_duration = 0.4
#func _ready() -> void:
	#input_event.connect(_on_character_input_event)

func _process(delta: float) -> void:
	bubble_hp_label.text = str(bubble_hp)

func _physics_process(delta: float) -> void:
	time_elapsed += delta
	# Add the gravity.
	
	if spawn_animation_duration <= 0:
		force_left = false
		force_right = false

	if force_left && spawn_animation_duration >= 0:
		velocity = Vector2(-100.0, 100.0)
		spawn_animation_duration -= delta
	elif force_right && spawn_animation_duration >= 0:
		velocity = Vector2(100, 100)
		spawn_animation_duration -= delta
	else:
		if freeze_time <= 0:
			if (velocity.y > max_fall && !force_left && !force_right):
				velocity -= get_gravity()  * delta
				velocity.y = clamp(velocity.y, 0, max_fall)
			
			if force_left:
				await get_tree().physics_frame
				await get_tree().create_timer(0.4).timeout
				force_left = false
			elif (force_right):
				await get_tree().create_timer(0.4).timeout
				force_right = false
			
			var sin_value = sin(time_elapsed * frequency) * amplitude * velocity_multiplier
			velocity.x = sin_value
		else:
			velocity.y = 0
			velocity.x = 0
			freeze_time -= delta

	move_and_slide()
	
func damage(amount: int):
	bubble_hp -= 1
	bubble_hp_label.visible = false
	Global.bubble_popped.emit()
	audio.stream = pop_sound
	audio.play()
	$AnimatedSprite2D.play("poppin")
	await $AnimatedSprite2D.animation_finished
	queue_free()
	if bubble_hp > 0:
		_spawn_children(bubble_hp)

func _spawn_children(bubble_hp):
	var spawn_position = position
	var new_object = object_to_spawn.instantiate()
	var new_object2 = object_to_spawn.instantiate()
	new_object.bubble_hp = bubble_hp
	new_object.position = spawn_position
	new_object.force_left = true
	new_object2.bubble_hp = bubble_hp
	new_object2.position = spawn_position
	new_object2.force_right = true
	add_sibling(new_object)
	add_sibling(new_object2)

func _frame_freeze(timeScale, duration):
	freeze_time = 0.1

	
	
#
#func _on_character_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event is InputEventMouse and event.is_pressed():
		#bubble_hp -= 1
		#if (bubble_hp == 0):
			#Global.bubble_popped.emit()
			#audio.stream = load("res://Resources/Sounds/Pop Sound Effects.ogg")
			#audio.play()
			#$AnimatedSprite2D.play("poppin")
			#await $AnimatedSprite2D.animation_finished
			#queue_free()
