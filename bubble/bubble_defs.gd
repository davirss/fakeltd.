class_name BubbleDefinitions extends Node

enum BubbleState {
	NEUTRAL,
	WHATSAPP,
	FACEBOOK,
	INSTAGRAM,
}

@onready var COLLISION_SHAPE: CollisionShape2D = $Body/BubbleCollisionShape
