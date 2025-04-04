extends RefCounted

class_name BubbleBehavior
var is_evil = false

var animation_player

func _init(bubble: Node, is_evil: bool) -> void:
	bubble.scale = Vector2(0, 0)
	animation_player = bubble.get_node("AnimationPlayer")
	var evil_node = bubble.get_node_or_null("Evil")
	if evil_node:
		evil_node.visible = is_evil
	bubble.scale = Vector2(0, 0)
	animation_player.play("spawn")
	await animation_player.animation_finished
	animation_player.play("RESET")
	

func pop(bubble: Node):
	pass # Override
	
func on_click(bubble: Node):
	pass # Override

func explode(bubble: Node):
	var animated_sprite = bubble.get_node("AnimatedSprite2D")
	animated_sprite.play("poppin")
	await animated_sprite.animation_finished
	bubble.queue_free()
