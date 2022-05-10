extends "../State.gd"

export(int) var speed = 10


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	var attack = transition_into_attack(f, moveset, input)
	if attack != null:
		return attack

	var jump = transition_into_jump(f, moveset, input)
	if jump != null:
		return jump

	if input.stick_y < 0:
		return moveset.crouch

	return null


func enter(f: Fighter) -> void:
	f.state_dict["turnaround"] = -8765309


func run(f: Fighter, input: Dictionary) -> void:
	if input.stick_x == 0:
		f.vel.x = 0
	if input.stick_x < 0:
		f.vel.x = -speed * 65536
	if input.stick_x > 0:
		f.vel.x = speed * 65536

	var diff = f.fixed_position.x - f.get_node(f.opponent_path).fixed_position.x
	if diff > 0 && f.fixed_scale.x > 0:
		f.fixed_scale.x *= -1
		f.state_dict["turnaround"] = f.state_time
	if diff < 0 && f.fixed_scale.x < 0:
		f.fixed_scale.x *= -1
		f.state_dict["turnaround"] = f.state_time

	# TODO: Remove bandaid fix
	var character = f.find_node("Character")
	character.modulate = Color.white


func animation(f: Fighter) -> String:
	if f.vel.x != 0:
		return "Walk"
	if f.state_time < f.state_dict["turnaround"] + 10:
		if (f.get_node("AnimationPlayer") as AnimationPlayer).has_animation("Turnaround"):
			return "Turnaround"
	return "Idle"


func can_block() -> bool:
	return true
