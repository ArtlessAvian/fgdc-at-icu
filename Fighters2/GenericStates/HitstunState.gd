extends "../State.gd"


func transition(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if f.state_time > f.state_dict.hitstun:
		return moveset.walk
	return null


func run(f: Fighter, input: Dictionary) -> void:
	# i am aware of the sign function but it seems to be a float.
	var signn = 1
	if f.fixed_scale.x < 0:
		signn = -1
	f.fixed_position.x -= signn * (65536 * 5) >> (f.state_time >> 3)

func animation(f: Fighter) -> String:
	return "Hitstun"
