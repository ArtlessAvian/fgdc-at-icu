extends "../State.gd"

# represents the techable window, and then the throw.


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if f.state_time >= f.state_dict["my_throwdata"].throw_length:
		if f.grounded:
			return moveset.walk
		return moveset.jump

	return null


func run(f: Fighter, input: Dictionary) -> void:
	if not f.grounded:
		f.vel.y = f.fighter_gravity


func animation(f: Fighter) -> String:
	return "DoThrow"


func get_landing_transition(f: Fighter, moveset: Moveset) -> State:
	return null
