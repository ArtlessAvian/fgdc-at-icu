extends SGFixedNode2D

const x_bound = 500 * 65565  # |x| can't go > x_bound
const max_spacing = 500 * 65565

# func _network_process(input: Dictionary) -> void:
# 	in_bounds()
# 	min_distance()
# 	max_distance()

# 	for area in get_tree().get_nodes_in_group("hitboxes"):
# 		area.sync_to_physics_engine()
# 	for area in get_tree().get_nodes_in_group("hurtboxes"):
# 		area.sync_to_physics_engine()
	
# 	for area in get_tree().get_nodes_in_group("hurtboxes"):
# 		var hurtboxes : Hurtboxes = area
# 		hurtboxes.collide_hitboxes()

# func in_bounds():
# 	var p1: SGFixedNode2D = get_node("Fighter1")
# 	var p2: SGFixedNode2D = get_node("Fighter2")

# 	if p1.fixed_position.x > x_bound - 0 / 2:
# 		p1.fixed_position.x = x_bound - 0 / 2
# 	if -p1.fixed_position.x > x_bound - 0 / 2:
# 		p1.fixed_position.x = -(x_bound - 0 / 2)

# 	if p2.fixed_position.x > x_bound - 0 / 2:
# 		p2.fixed_position.x = x_bound - 0 / 2
# 	if -p2.fixed_position.x > x_bound - 0 / 2:
# 		p2.fixed_position.x = -(x_bound - 0 / 2)

# func min_distance():
# 	var p1: SGFixedNode2D = get_node("Fighter1")
# 	var p2: SGFixedNode2D = get_node("Fighter2")

# 	var fighter_height = p1.fighter_height
# 	var fighter_spacing = p1.fighter_spacing

# 	if abs(p1.fixed_position.y - p2.fixed_position.y) < fighter_height:
# 		var diff = p1.fixed_position.x - p2.fixed_position.x
# 		var average = (p1.fixed_position.x + p2.fixed_position.x) >> 1

# 		if abs(diff) < fighter_spacing:
# 			average = clamp(
# 				average, -x_bound + fighter_spacing / 2, x_bound - fighter_spacing / 2
# 			)

# 			p1.fixed_position.x = average + fighter_spacing / 2 * sign(diff)
# 			p2.fixed_position.x = average + fighter_spacing / 2 * sign(-diff)

# func max_distance():
# 	var p1: SGFixedNode2D = get_node("Fighter1")
# 	var p2: SGFixedNode2D = get_node("Fighter2")

# 	var diff = p1.fixed_position.x - p2.fixed_position.x

# 	if abs(diff) > max_spacing:
# 		# unmove the players.
# 		p1.fixed_position.x -= p1.vel.x
# 		p2.fixed_position.x -= p2.vel.x
# 		# TODO: do some wack algebra stuff. might need floating point though, so maybe not so worth it.

# # func _network_spawn(data: Dictionary):
# # 	get_node("Fighter1").set_network_master(data.p1_master)
# # 	get_node("Fighter2").set_network_master(data.p2_master)
