extends Camera2D

export var path_one: NodePath = ""
export var path_two: NodePath = ""


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

	# zoom on distance
	# var diff_x = fighter_one.position.x - fighter_two.position.x
	# var diff_y = fighter_one.position.y - fighter_two.position.y
	# zoom = Vector2.ONE * 0.3
	# if abs(diff_x) > 300:
	# 	zoom = Vector2.ONE * 0.5
	# if abs(diff_y) > 300 * 9 / 16:
	# 	zoom = Vector2.ONE * 0.5

	# max y
	self.position.y = min(fighter_one.position.y, fighter_two.position.y)

	# clamp
	self.position.x = clamp(self.position.x, -250, 250)
	self.position.y = min(-125, self.position.y)

	self.force_update_scroll()
