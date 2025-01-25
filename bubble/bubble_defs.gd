class_name BubbleDefinitions extends CharacterBody2D

enum BubbleState {
	NEUTRAL,
	WHATSAPP,
	FACEBOOK,
	INSTAGRAM,
}

@onready var COLLISION_SHAPE: CollisionShape2D = $Body/BubbleCollisionShape
