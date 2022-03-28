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

	# visual stuff, i can use floats here lmao
	var sprite: Sprite = f.get_node("Sprite")
	sprite.self_modulate.b = 1 - 1.0 / (f.state_time / 3.0 + 1)
	sprite.self_modulate.g = 1 - 1.0 / (f.state_time / 3.0 + 1)


func animation(f: Fighter) -> String:
	return "Hitstun"
