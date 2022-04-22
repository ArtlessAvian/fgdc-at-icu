extends SGFixedNode2D

const x_bound = 1000 * 65565  # |x| can't go > x_bound
const max_spacing = 1000 * 65565

# We save these so we don't use the players' velocities.
var last_average: int = 0
var last_diff: int = 0


# func _ready():
# 	add_to_group("network_group")
# 	print("My ready is called")


func _network_spawn(data: Dictionary):
	add_to_group("network_group")
	print("My ready is called")
	print("Put me in coach") #TODO: Testing prints


func _network_process(input: Dictionary) -> void:
	print(input)
	correct_positions()
	collide_hitboxes()


func correct_positions():
	var p1: SGFixedNode2D = get_node("Fighter1")
	var p2: SGFixedNode2D = get_node("Fighter2")

	in_bounds(p1)
	in_bounds(p2)

	# these two probably don't activate at the same time.
	min_distance(p1, p2)
	max_distance(p1, p2)

	# nothing bad happens if the players are put oob again, buttt
	# in_bounds(p1)
	# in_bounds(p2)

	# hey doesn't this cause a very slight p1 advantage lmao
	last_average = (p1.fixed_position.x + p2.fixed_position.x) >> 1
	last_diff = (p1.fixed_position.x - p2.fixed_position.x)


func collide_hitboxes():
	for area in get_tree().get_nodes_in_group("hitboxes"):
		area.sync_to_physics_engine()
	for area in get_tree().get_nodes_in_group("hurtboxes"):
		area.sync_to_physics_engine()

	for area in get_tree().get_nodes_in_group("hurtboxes"):
		var hurtboxes: Hurtboxes = area
		hurtboxes.collide_hitboxes()


func in_bounds(p: Fighter):
	if p.fixed_position.x > x_bound - 0 / 2:
		p.fixed_position.x = x_bound - 0 / 2
	if -p.fixed_position.x > x_bound - 0 / 2:
		p.fixed_position.x = -(x_bound - 0 / 2)


func min_distance(p1: Fighter, p2: Fighter):
	# temporary, each fighter has their own height and width
	var fighter_spacing = (p1.fighter_spacing + p2.fighter_spacing) * 65536 >> 1

	if p1.fixed_position.y - p2.fixed_position.y > p2.fighter_height * 65536:
		return
	if p2.fixed_position.y - p1.fixed_position.y > p1.fighter_height * 65536:
		return
	# both fighters are within range to interact.

	var diff = p1.fixed_position.x - p2.fixed_position.x
	var average = (p1.fixed_position.x + p2.fixed_position.x) >> 1

	if abs(diff) < fighter_spacing:
		average = clamp(
			average, -x_bound + (fighter_spacing >> 1), x_bound - (fighter_spacing >> 1)
		)

		p1.fixed_position.x = average + (fighter_spacing >> 1) * sign(diff)
		p2.fixed_position.x = average + (fighter_spacing >> 1) * sign(-diff)


func max_distance(p1: Fighter, p2: Fighter):
	var diff = p1.fixed_position.x - p2.fixed_position.x

	if abs(diff) > max_spacing:
		var average = (p1.fixed_position.x + p2.fixed_position.x) >> 1

		# TODO: consider replacing with easier solution.
		# 1. Reaverage positions.
		# 2. Place fighters at max distance from the average
		# This lets a player pull the camera. If a player is running away, this is bad for them!
		# Because they corner themselves!

		############################################
		# Some normal algebra: similar triangles!
		# Normally we'd get the ratio (max_spacing - last_diff) / (diff - last_diff)
		# Then we find the new average, and set the spacing to max.

		var remaining_diff = diff - last_diff
		var target_diff = last_diff

		var remaining_average = average - last_average
		var target_average = last_average

		# Instead, we do it numerically. hahahahaha. ha.
		# We find a series of similar triangles that does not exceed the max_spacing,
		# but are closer and closer.

		for i in range(1, 3):
			if abs(target_diff + (remaining_diff >> i)) <= max_spacing:
				target_diff += remaining_diff >> i
				target_average += remaining_average >> i

		# Then we say f*** it and call it good enough.
		p1.fixed_position.x = target_average + (max_spacing >> 1) * sign(diff)
		p2.fixed_position.x = target_average + (max_spacing >> 1) * sign(-diff)


func _save_state() -> Dictionary:
	return {last_average = last_average, last_diff = last_diff}


func _load_state(save: Dictionary) -> void:
	last_average = save.last_average
	last_diff = save.last_diff
