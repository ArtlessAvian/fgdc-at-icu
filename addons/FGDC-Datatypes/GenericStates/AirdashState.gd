extends "../State.gd"

export(int) var speed = 14 * 65536
export(int) var length = 30


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if f.air_actions <= 0:
		return false

	if f.state in [moveset.jump, moveset.j_light, moveset.j_heavy]:
		if input.dash and input.stick_x != -int(sign(f.fixed_scale.x)):
			f.air_actions -= 1
			return true
		if f.get_node("InputHistory").detect_motion([6, 5, 6], f.fixed_scale.x < 0, 8):
			f.air_actions -= 1
			return true
		if f.get_node("InputHistory").detect_motion([9, 5, 6], f.fixed_scale.x < 0, 8):
			f.air_actions -= 1
			return true

	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
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
	f.vel.x = speed * sign(f.fixed_scale.x)


func animation(f: Fighter) -> String:
	return "Airdash"
