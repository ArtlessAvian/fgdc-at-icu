extends Spatial

export(NodePath) var game_camera_path

# recall that the game's x bounds is 2000 pixels wide.
export(float) var world_scale = 100
export(float) var base_fov = 70
export(String) var fighter1_path = "../../Game/Fighter1"
export(String) var fighter2_path = "../../Game/Fighter2"


# Called when the node enters the scene tree for the first time.
func _ready():
	var f1 = self.get_node(fighter1_path)
	var f2 = self.get_node(fighter2_path)
	f1.connect("countered", self, "_on_Fighter_countered")
	f2.connect("countered", self, "_on_Fighter_countered")


func _process(delta):
	camera_math()


func camera_math():
	var game_camera = get_node(game_camera_path)
	$Camera.translation.x = game_camera.position.x
	$Camera.translation.y = -game_camera.position.y

	# draw the triangle. we have an angle and the opposite, so get the adjacent.
	$Camera.translation.z = (720 / 2) / tan(deg2rad(base_fov / 2))
	$Camera.fov = 2 * rad2deg(atan(get_viewport().size.y / 2 / $Camera.translation.z))

	$Camera.translation /= world_scale


func _on_Fighter_countered():
	print("You got countered lmao")
