extends "../State.gd"


func transition(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if f.state_time > f.state_dict.hitstun:
		return moveset.walk
	return null


func run(f: Fighter, input: Dictionary) -> void:
	f.fixed_position.x -= sign(f.fixed_scale.x) * (65536 * 5) >> (f.state_time >> 3)

func animation(f: Fighter) -> String:
	return "Hitstun"
