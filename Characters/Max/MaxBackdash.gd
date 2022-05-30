extends State

export(int) var vel = 5 << 16


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if not f.grounded:
		return false

	# point in same direction
	if input.stick_x * f.fixed_scale.x >= 0:
		return false

	if f.state in [moveset.walk, moveset.crouch]:
		if f.get_node("InputHistory").button_pressed("dash", 10):
			return true
		if f.get_node("InputHistory").detect_motion([4, 5, 4], f.fixed_scale.x < 0, 8):
			return true
		if f.get_node("InputHistory").detect_motion([1, 5, 4], f.fixed_scale.x < 0, 8):
			return true
		if f.get_node("InputHistory").detect_motion([4, 5, 1], f.fixed_scale.x < 0, 8):
			return true
		if f.get_node("InputHistory").detect_motion([1, 5, 1], f.fixed_scale.x < 0, 8):
			return true

	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	if f.state_time >= 18:
		return moveset.walk

	return null


func run(f: Fighter, input: Dictionary) -> void:
	f.vel.x = -vel * int(sign(f.fixed_scale.x))
	f.invincible = f.state_time < 7


func animation(f: Fighter) -> String:
	return "Backdash"
