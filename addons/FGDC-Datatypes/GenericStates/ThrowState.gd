extends "../State.gd"

# note that this is the throwing state.
# also do not use for command grabs


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


func run(f: Fighter, input: Dictionary) -> void:
	pass


func animation(f: Fighter) -> String:
	return "Walk"


func attack_level() -> int:
	return 10
