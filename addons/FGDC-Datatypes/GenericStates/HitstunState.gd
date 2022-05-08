extends "../State.gd"


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	if f.state_time > f.state_dict.hitstun:
		f.combo_count = 0
		if f.grounded:
			return moveset.walk
	return null


func run(f: Fighter, input: Dictionary) -> void:
	# visual stuff, i can use floats here lmao
	var character = f.find_node("Character")
	character.modulate.b = 1 - 1.0 / (f.state_time / 10.0 + 1)
	character.modulate.g = 1 - 1.0 / (f.state_time / 10.0 + 1)


func animation(f: Fighter) -> String:
	return "Hitstun"

func get_landing_transition(f: Fighter, moveset: Moveset) -> State:
	return null
	