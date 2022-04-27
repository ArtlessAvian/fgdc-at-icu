extends Spatial

export(NodePath) var game_camera_path

# recall that the game's x bounds is 2000 pixels wide.
export(float) var world_scale = 100
export(float) var base_fov = 70


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


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
