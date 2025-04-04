extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


var object_to_spawn = preload("res://bubbles/slime/slime_bubble.tscn")
@onready var audio = $AudioStreamPlayer2D
@onready var pop_sound = preload("res://Resources/Sounds/Pop Sound Effects.ogg")
@onready var damage_sound = preload("res://Resources/Sounds/Pop Sound Effects -6.ogg")

@onready var bubble_physics = BubblePhysics.new(self)
var bubble_behavior

var time_elapsed = 0.0
@onready var amplitude = randf_range(0.5, 0.6)  # Maximum movement range
@onready var frequency = randf_range(2.0, 2.5)  # How fast it wiggles (higher = faster)
@onready var velocity_multiplier = 50.0  # Controls speed of movement
@onready var max_fall = randf_range(-50.0, -55.0)
@onready var bubble_hp_label = $BubbleHP

var bubble_hp = 2
var freeze_time = 0
var force_left = false
var force_right = false
var is_evil = false
var gravity_on = false

func _ready() -> void:
	bubble_behavior = await BubbleBehavior.new(self, is_evil)
	bubble_physics.toggle_gravity(gravity_on)

func _process(delta: float) -> void:
	bubble_hp_label.text = str(bubble_hp)

func _physics_process(delta: float) -> void:
	if not force_left && not force_right:
		bubble_physics._physics_process(self, delta)

	if force_left:
		velocity += Vector2(-1, -1)
		await get_tree().create_timer(0.2).timeout

	if force_right:
		velocity += Vector2(1, 1)
		await get_tree().create_timer(0.2).timeout
	
	gravity_on = true
	bubble_physics.toggle_gravity(gravity_on)		
	
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
	new_object.toggle_gravity(false)
	new_object2.toggle_gravity(false)
	add_sibling(new_object)
	add_sibling(new_object2)

func toggle_gravity(gravity: bool):
	gravity_on = gravity

func _frame_freeze(timeScale, duration):
	freeze_time = 0.1

func explode():
	await bubble_behavior.explode(self)

	
	
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
