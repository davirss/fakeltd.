extends Panel

var riple_time = 0
var mat: ShaderMaterial
var mouse_pos: Vector2
var counter = 0
var pan_size = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	mat = self.material
func _process(delta):
	riple_time += delta
	mat.set_shader_parameter("RTIME", riple_time)
	pan_size += delta

func _on_Panel_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			pan_size = 0
		else:
			mat.set_shader_parameter("drop" + str(counter), Color(mouse_pos.x, mouse_pos.y, pan_size, riple_time))
			counter += 1
			counter = counter%7
	if event is InputEventMouseMotion:
		mouse_pos = event.position/self.rect_size
		
