class_name BubbleDefinitions extends CharacterBody2D

enum BubbleState {
	NEUTRAL,
	WHATSAPP,
	FACEBOOK,
	INSTAGRAM,
}

@onready var MOUSE_COLLISION_SHAPE: CollisionShape2D = $View/MouseClickCollisionShape
@onready var BUBBLE_SPRITE: Sprite2D = $View/BubbleSprite
@onready var BODY_COLLISION_SHAPE: CollisionShape2D = $BodyCollisionShape


const BUBBLE_SPRITE_WHITE = preload("res://Resources/bubbles sprites/bubble-1-white.png")
const BUBBLE_SPRITE_WHITE_ALT = preload("res://Resources/bubbles sprites/bubble-2-white.png")
const BUBBLE_SPRITE_BLUE = preload("res://Resources/bubbles sprites/bubble-1-blue.png")
const BUBBLE_SPRITE_BLUE_ALT = preload("res://Resources/bubbles sprites/bubble-2-blue.png")
const BUBBLE_SPRITE_GREEN = preload("res://Resources/bubbles sprites/bubble-1-green.png")
const BUBBLE_SPRITE_GREEN_ALT = preload("res://Resources/bubbles sprites/bubble-2-green.png")
const BUBBLE_SPRITE_PINK = preload("res://Resources/bubbles sprites/bubble-1-pink.png")
const BUBBLE_SPRITE_PINK_ALT = preload("res://Resources/bubbles sprites/bubble-2-pink.png")
