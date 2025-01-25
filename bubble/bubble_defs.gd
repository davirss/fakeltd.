class_name BubbleDefinitions extends CharacterBody2D

enum BubbleState {
	NEUTRAL,
	WHATSAPP,
	FACEBOOK,
	INSTAGRAM,
}

@onready var MOUSE_COLLISION_SHAPE: CollisionShape2D = $View/MouseClickCollisionShape

@onready var BODY_COLLISION_SHAPE: CollisionShape2D = $BodyCollisionShape
