extends MarginContainer

# Post Info
var text: String:
	set(value):
		text = value
		$VBoxContainer/RichTextLabel.text = str(value)

var messages: int:
	set(value):
		messages = value
		$VBoxContainer/HBoxContainer/Comments.text = str(value)

var likes: int:
	set(value):
		likes = value
		$VBoxContainer/HBoxContainer/Likes.text = str(value)

var reshares: int:
	set(value):
		reshares = value
		$VBoxContainer/HBoxContainer/Share.text = str(value)
