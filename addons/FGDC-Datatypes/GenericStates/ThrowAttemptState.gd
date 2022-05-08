extends "../State.gd"

# represents the universal throw, plus any whiff animation.
# this state is reused twice for both grounded and air throw

# also do not use for command grabs, hitgrabs

export(Resource) var throw_data
export(Resource) var air_throw_data


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if input.light and input.heavy:
		if f.state in [moveset.walk, moveset.crouch, moveset.jump]:
			return true

		if f.state_time < 5:
			if f.state in moveset.all_normals():
				return true

	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	if f.state_time > 15:
		if f.grounded:
			return moveset.walk
		return moveset.jump

	return null


func enter(f: Fighter) -> void:
	pass


func run(f: Fighter, input: Dictionary) -> void:
	if f.grounded:
		f.get_node("Throwboxes").set_throw_data(throw_data)
		f.vel.x = 0
	else:
		f.get_node("Throwboxes").set_throw_data(air_throw_data)


func animation(f: Fighter) -> String:
	return "Throw"


func attack_level() -> int:
	return 8765309
