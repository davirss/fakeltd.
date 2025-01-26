extends VBoxContainer

var bar_1 = 100
var bar_2 = 100
var bar_3 = 100

var decreaseRatio = 1
var decrease_cooldown = 1
var decrase_countdown = 0

var elapsed = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !elapsed: return

	decrease_first(delta)
	decrease_second(delta)
	decrease_third(delta)
	_check_zeroed_bar()

	print(bar_1)
	$FirstGroup/ProgressBar.value = bar_1
	$SecondGroup/ProgressBar.value = bar_2
	$HBoxContainer3/ProgressBar.value = bar_3

func _check_zeroed_bar():
	if (bar_1 <= 0 || bar_2 <= 0 || bar_3 <= 0):
		Global.influence_over.emit()

func decrease_first(delta):
	bar_1 -= delta
	pass
	
func decrease_third(delta):
	bar_3 -= delta
	pass

func decrease_second(delta):
	bar_2 -= delta
	pass

func increase_first(amount):
	bar_1 += amount
	pass
	
func increase_second(amount):
	bar_3 += amount
	pass

func incrase_third(amount):
	bar_2 += amount
	pass
