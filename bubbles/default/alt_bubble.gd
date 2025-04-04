extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var bubble_hp_label = $BubbleHP
@onready var audio = $AudioStreamPlayer2D
var is_evil = false
var bubble_hp = 1
@onready var bubblePhysics = BubblePhysics.new(self)
var bubbleBehavior: BubbleBehavior

@onready var pop_sound = preload("res://Resources/Sounds/Pop Sound Effects -4.ogg")
@onready var damage_sound = preload("res://Resources/Sounds/Pop Sound Effects -4.ogg")

func _ready() -> void:
	bubblePhysics.toggle_gravity(false)
	bubbleBehavior = await BubbleBehavior.new(self, is_evil)
	await get_tree().create_timer(1).timeout
	bubblePhysics.toggle_gravity(true)

func _process(delta: float) -> void:
	bubble_hp_label.text = str(bubble_hp)

func _physics_process(delta: float) -> void:
	bubblePhysics._physics_process(self, delta)
	
func damage(amount: int):
	bubble_hp -= amount
	if (bubble_hp <= 0):
		bubble_hp_label.visible = false
		Global.bubble_popped.emit()
		audio.stream = pop_sound
		audio.play()
		$AnimatedSprite2D.play("poppin")
		await $AnimatedSprite2D.animation_finished
		queue_free()
	else:
		bubblePhysics.freeze()
		$AnimationPlayer.play("clicked")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("RESET")
		audio.stream = damage_sound
		audio.play()

func explode():
	await bubbleBehavior.explode(self)


	
	
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
