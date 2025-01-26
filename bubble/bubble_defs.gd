class_name BubbleDefinitions extends CharacterBody2D

enum BubbleState {
	NEUTRAL,
	WHATSAPP,
	FACEBOOK,
	INSTAGRAM,
}

@onready var MOUSE_COLLISION_SHAPE: CollisionShape2D = $View/MouseClickCollisionShape
@onready var BUBBLE_SPRITE: AnimatedSprite2D = $View/BubbleSprite
@onready var BUBBLE_SHADE: Sprite2D = $View/BubbleShade
@onready var BODY_COLLISION_SHAPE: CollisionShape2D = $BodyCollisionShape


const BUBBLE_SPRITE_WHITE = preload("res://Resources/bubbles sprites/bubble-1-white.png")
const BUBBLE_SPRITE_WHITE_ALT = preload("res://Resources/bubbles sprites/bubble-2-white.png")
const BUBBLE_SPRITE_BLUE = preload("res://Resources/bubbles sprites/bubble-1-blue.png")
const BUBBLE_SPRITE_BLUE_ALT = preload("res://Resources/bubbles sprites/bubble-2-blue.png")
const BUBBLE_SPRITE_GREEN = preload("res://Resources/bubbles sprites/bubble-1-green.png")
const BUBBLE_SPRITE_GREEN_ALT = preload("res://Resources/bubbles sprites/bubble-2-green.png")
const BUBBLE_SPRITE_PINK = preload("res://Resources/bubbles sprites/bubble-1-pink.png")
const BUBBLE_SPRITE_PINK_ALT = preload("res://Resources/bubbles sprites/bubble-2-pink.png")

const BUBBLE_SPRITE_ANIM_IDLE_WHITE = "idle_white"
const BUBBLE_SPRITE_ANIM_IDLE_WHITE_ALT = "idle_white_alt"
const BUBBLE_SPRITE_ANIM_IDLE_BLUE = "idle_blue"
const BUBBLE_SPRITE_ANIM_IDLE_BLUE_ALT = "idle_blue_alt"
const BUBBLE_SPRITE_ANIM_IDLE_GREEN = "idle_green"
const BUBBLE_SPRITE_ANIM_IDLE_GREEN_ALT = "idle_green_alt"
const BUBBLE_SPRITE_ANIM_IDLE_PINK = "idle_pink"
const BUBBLE_SPRITE_ANIM_IDLE_PINK_ALT = "idle_pink_alt"

const BUBBLE_SPRITE_ANIM_POP_KEYWORD = "pop"
const BUBBLE_SPRITE_ANIM_POP_WHITE = "pop_white"
const BUBBLE_SPRITE_ANIM_POP_BLUE = "pop_blue"
const BUBBLE_SPRITE_ANIM_POP_GREEN = "pop_green"
const BUBBLE_SPRITE_ANIM_POP_PINK = "pop_pink"
