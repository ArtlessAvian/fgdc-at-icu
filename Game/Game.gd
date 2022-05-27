extends SGFixedNode2D

# Game is responsible for managing inter-fighter interactions.
# It does not know how to reset itself. (See Match).

const x_bound = 1000 << 16  # |x| can't go > x_bound
const max_spacing = 1000 << 16

# We save these so we don't use the players' velocities.
var last_average: int = 0
var last_diff: int = 0

const game_length = 90 * 60  # in frames. remember to add a countdown
var time_in_frames = game_length


func _ready():
	add_to_group("network_sync")
	time_in_frames = game_length


func _network_process(input: Dictionary) -> void:
	assert(has_node("Fighter1"), "Game not setup! (Fighter1 does not exist)")

	time_in_frames -= 1
	if time_in_frames == 0:
		do_timeout()

	correct_positions()
	collide_hitboxes()


func do_timeout():
	# Explode
	$Camera2D/HugeExplosion.play("explode")

	# put both players in a big ass knockdown
	var p1: SGFixedNode2D = get_node("Fighter1")
	var p2: SGFixedNode2D = get_node("Fighter2")
	p1.vel.y = 30 << 16
	p2.vel.y = 30 << 16
	p1.change_to_state(p1.moveset.knockdown)
	p2.change_to_state(p2.moveset.knockdown)

	# kill the loser(s)
	var p1_winning = compare_winningness(p1, p2)
	if p1_winning >= 0:
		p2.health = 0
		p2.change_to_state(p2.moveset.dead)
	if p1_winning <= 0:
		p1.health = 0
		p1.change_to_state(p1.moveset.dead)


func correct_positions():
	var p1: SGFixedNode2D = get_node("Fighter1")
	var p2: SGFixedNode2D = get_node("Fighter2")

	in_bounds(p1, p2)
	in_bounds(p2, p1)

	handle_corners(p1, p2)

	# these two probably don't activate at the same time.
	min_distance(p1, p2)
	max_distance(p1, p2)


	# nothing bad happens if the players are put oob again, buttt
	in_bounds(p1, p2)
	in_bounds(p2, p1)

	# hey doesn't this cause a very slight p1 advantage lmao
	last_average = (p1.fixed_position.x + p2.fixed_position.x) >> 1
	last_diff = (p1.fixed_position.x - p2.fixed_position.x)


func collide_hitboxes():
	for area in get_tree().get_nodes_in_group("hitboxes"):
		area.sync_to_physics_engine()
	for area in get_tree().get_nodes_in_group("hurtboxes"):
		area.sync_to_physics_engine()
	for area in get_tree().get_nodes_in_group("throwboxes"):
		area.sync_to_physics_engine()

	for area in get_tree().get_nodes_in_group("hurtboxes"):
		var hurtboxes: Hurtboxes = area
		hurtboxes.collide_hitboxes()  # and throwboxes


func in_bounds(p: Fighter, other: Fighter):
	if p.fixed_position.x > x_bound - 0 / 2:
		p.fixed_position.x = x_bound - 0 / 2
		if not other.cornered:
			p.cornered = true
	if -p.fixed_position.x > x_bound - 0 / 2:
		p.fixed_position.x = -(x_bound - 0 / 2)
		if not other.cornered:
			p.cornered = true


func min_distance(p1: Fighter, p2: Fighter):
	if p1.state.ignore_collision() or p2.state.ignore_collision():
		return

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
		
	#print(diff, average)


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

func handle_corners(p1: Fighter, p2: Fighter):
	if p1.cornered and not p2.cornered and p1.fixed_position_x == p2.fixed_position_x:
		p2.fixed_position_x = p1.fixed_position_x - 1*sign(p1.fixed_position_x)
	if p2.cornered and not p1.cornered and p1.fixed_position_x == p2.fixed_position_x:
		p1.fixed_position_x = p2.fixed_position_x - 1*sign(p2.fixed_position_x)

# think Comparator<Fighter>. We are comparing the "winningness".
# So, returns [negative / zero / positive] if [p1 losing / tie / p1 winning]
func compare_winningness(p1, p2) -> int:
	return p1.health - p2.health


func _process(_delta):
	var p1: SGFixedNode2D = get_node_or_null("Fighter1")
	var p2: SGFixedNode2D = get_node_or_null("Fighter2")

	if p1 == null or p2 == null:
		return

	var min_x = min(p1.fixed_position.x, p2.fixed_position.x) / (1 << 16)
	var max_x = max(p1.fixed_position.x, p2.fixed_position.x) / (1 << 16)
	var average_x = clamp((min_x + max_x) / 2, -500, 500)

	$LeftWall.position.x = average_x - max_spacing / (1 << 17)
	$LeftWall.position.x = max($LeftWall.position.x, -x_bound / (1 << 16))
	$RightWall.position.x = average_x + max_spacing / (1 << 17)
	$RightWall.position.x = min($RightWall.position.x, x_bound / (1 << 16))

	var l_dist = min_x - $LeftWall.position.x
	var r_dist = $RightWall.position.x - max_x
	$LeftWall.modulate.a = smoothstep(1, 0, l_dist / 100)
	$RightWall.modulate.a = smoothstep(1, 0, r_dist / 100)


func _save_state() -> Dictionary:
	return {last_average = last_average, last_diff = last_diff, time_in_frames = time_in_frames}


func _load_state(save: Dictionary) -> void:
	last_average = save.last_average
	last_diff = save.last_diff
	time_in_frames = save.time_in_frames
