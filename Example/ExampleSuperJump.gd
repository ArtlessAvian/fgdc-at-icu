extends State

export(int) var impulse = 15


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if not f.grounded:
		return false

	if f.state in [moveset.walk, moveset.crouch]:
		var success = false
		if f.get_node("InputHistory").detect_charge_up(10, 1):
			success = true

		if success:
			f.vel.y = impulse * 65536
			f.grounded = false
			return true

	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	var attack = transition_into_attack(f, moveset, input)
	if attack != null:
		return attack

	var double_jump = transition_into_double_jump(f, moveset, input)
	if double_jump != null:
		return double_jump

	return null


func enter(f: Fighter) -> void:
	f.air_actions = f.moveset.air_actions
	f.state_dict.let_go = false


func run(f: Fighter, input: Dictionary) -> void:
	if not f.state_dict.let_go and input.stick_y <= 0:
		f.state_dict.let_go = true


func animation(f: Fighter) -> String:
	return "Jump"
