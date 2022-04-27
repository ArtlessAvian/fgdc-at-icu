extends Camera2D

export var path_one: NodePath = ""
export var path_two: NodePath = ""

var temp_min = 0
var temp_max = 0
var temp_min_y = 0
var temp_max_y = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func _process(_delta):
	var fighter_one = get_node(path_one)
	var fighter_two = get_node(path_two)

	# average x
	self.position.x = fighter_one.position.x
	self.position.x += fighter_two.position.x
	self.position.x /= 2

	self.position.x = clamp(self.position.x, -500, 500)

	# zoom on distance
	# var diff_x = max(abs(fighter_one.position.x - position.x), abs(fighter_two.position.x - position.x))
	# var diff_y = fighter_one.position.y - fighter_two.position.y

	# var zoom_factor = 0.5
	# if abs(diff_x) < 150:
	# 	zoom_factor = 0.5 * diff_x/150

	# max y
	self.position.y = min(fighter_one.position.y, fighter_two.position.y)

	# clamp
	self.position.y = min(-250, self.position.y)

	# self.zoom = Vector2.ONE * zoom_factor

	temp_min = min(temp_min, self.position.x)
	temp_max = max(temp_max, self.position.x)
	temp_min_y = min(temp_min_y, self.position.y)
	temp_max_y = min(temp_max_y, self.position.y)

	self.force_update_scroll()
