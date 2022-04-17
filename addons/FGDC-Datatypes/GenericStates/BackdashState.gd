extends "../State.gd"

export(int) var speed = 7 * 65536
export(int) var length = 15


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if f.air_actions <= 0:
		return false

	if f.state in [moveset.jump, moveset.j_light, moveset.j_heavy]:
		if f.get_node("InputHistory").detect_motion([4, 5, 4], f.fixed_scale.x < 0, 8):
			f.air_actions -= 1
			return true
		if f.get_node("InputHistory").detect_motion([7, 5, 4], f.fixed_scale.x < 0, 8):
			f.air_actions -= 1
			return true

	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	var attack = transition_into_attack(f, moveset, input)
	if attack != null:
		return attack

	var jump = transition_into_double_jump(f, moveset, input)
	if jump != null:
		return jump

	if f.state_time > length:
		return moveset.jump

	return null


func run(f: Fighter, input: Dictionary) -> void:
	f.vel.y = f.fighter_gravity
	f.vel.x = -speed * sign(f.fixed_scale.x)


func animation(f: Fighter) -> String:
	return "Airdash"
