extends RefCounted

class_name BubblePhysics

var time_elapsed = randf_range(0.0, 1.0)
var amplitude = randf_range(0.5, 0.6)  # Maximum movement range
var frequency = randf_range(2.0, 2.5)  # How fast it wiggles (higher = faster)
var velocity_multiplier = 50.0  # Controls speed of movement
var max_fall = randf_range(-50.0, -55.0)
var gravity_on = false
var freeze_time = 0

# New parameters for smooth collision response
var repulsion_strength := 100.0  # How strong bubbles push each other
var repulsion_radius := 100.0  # Max range for repulsion effect

var spawn_repulsion_strength := 200.0
var spawn_repulsion_radius := 60.0
	
var velocity := Vector2.ZERO
var acceleration := Vector2.ZERO


func _init(bubble: Node):
	amplitude = randf_range(0.5, 0.6)  # Maximum movement range
	frequency = randf_range(2.0, 2.5)  # How fast it wiggles (higher = faster)
	velocity_multiplier = 50.0  # Controls speed of movement
	max_fall = randf_range(-50.0, -55.0)
	gravity_on = false

func _physics_process(bubble: CharacterBody2D, delta: float) -> void:
	if not gravity_on:
		velocity = Vector2.ZERO
		acceleration = Vector2.ZERO
		bubble.velocity = velocity
		return

	time_elapsed += delta

	if freeze_time <= 0.0:
		# Gravity
		acceleration.y = 400

		# Sin-wave wobble
		var target_x_velocity = sin(time_elapsed * frequency) * amplitude * velocity_multiplier
		acceleration.x = 0.0

		# Integrate velocity
		velocity.y += acceleration.y * delta
		velocity.y = clamp(velocity.y, 0.0, max_fall)
		velocity.x = lerp(velocity.x, target_x_velocity, 0.1)

		# Apply gentle repulsion from nearby bubbles
		apply_repulsion(bubble, delta)
	else:
		velocity = Vector2.ZERO
		acceleration = Vector2.ZERO
		freeze_time -= delta

	# Apply final velocity
	bubble.velocity = velocity
	bubble.move_and_slide()

func apply_spawn_repulsion(bubble: CharacterBody2D):
	for other in bubble.get_parent().get_children():
		if other == self or not (other is CharacterBody2D):
			continue

		var direction = other.global_position - bubble.global_position
		var distance = direction.length()

		if distance < spawn_repulsion_radius and distance > 0:
			var force = (direction.normalized() * spawn_repulsion_strength) / distance
			if "velocity" in other:
				other.velocity += force


func apply_repulsion(bubble: CharacterBody2D, delta: float):
	for other in bubble.get_parent().get_children():
		if other == bubble or not (other is CharacterBody2D):
			continue

		var direction = bubble.global_position - other.global_position
		var distance = direction.length()

		if distance < repulsion_radius and distance > 0:
			var repulsion_force = (direction.normalized() * repulsion_strength * delta) / distance
			velocity += repulsion_force

func freeze():
	freeze_time = 0.1

func toggle_gravity(gravity: bool):
	gravity_on = gravity
