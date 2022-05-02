extends "../State.gd"

# also do not use for command grabs, hitgrabs

export(Resource) var throw_data


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if input.light and input.heavy:
		if f.state in [moveset.walk, moveset.crouch]:
			return true

		if f.state_time < 3 and f.state in moveset.all_normals():
			return true

	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if f.state_time > 10:
		return moveset.walk

	return null


func enter(f: Fighter) -> void:
	pass


func run(f: Fighter, input: Dictionary) -> void:
	f.get_node("Throwboxes").set_throw_data(throw_data)


func animation(f: Fighter) -> String:
	return "Throw"


func attack_level() -> int:
	return 10
