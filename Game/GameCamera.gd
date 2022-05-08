extends Camera2D

export var path_one: NodePath = ""
export var path_two: NodePath = ""

var target_x = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func look_at_average(fighter_one, fighter_two):
	target_x = fighter_one.position.x
	target_x += fighter_two.position.x
	target_x /= 2


func fit_onto_screen(fighter, margin):
	target_x += (
		sign(fighter.position.x - target_x)
		* (abs(fighter.position.x - target_x) - margin)
	)


func _process(_delta):
	var fighter_one = get_node_or_null(path_one)
	var fighter_two = get_node_or_null(path_two)

	if fighter_one == null or fighter_two == null:
		return

	if abs(fighter_one.position.x - target_x) > 200:
		print("f1 oob")
		if abs(fighter_one.position.x - fighter_two.position.x) > 400:
			print("averaging")
			look_at_average(fighter_one, fighter_two)
		else:
			print("fitting")
			fit_onto_screen(fighter_one, 200)

	if abs(fighter_two.position.x - target_x) > 200:
		print("f2 oob")
		if abs(fighter_one.position.x - fighter_two.position.x) > 400:
			print("averaging")
			look_at_average(fighter_one, fighter_two)
		else:
			print("fitting")
			fit_onto_screen(fighter_two, 200)
	# print(target_x)

	self.position.x = clamp(target_x, -500, 500)

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

	self.force_update_scroll()
