extends "../State.gd"


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if f.state_time > f.state_dict.hitstun:
		f.combo_count = 0
		return moveset.walk
		
	if f.grounded and f.get_node("Hurtboxes").hit_hitdata.knockdown:
		f.invincible = true
		f.get_node("Hurtboxes").hit_hitdata.knockdown = false
		return moveset.knockdown
	
	return null


func run(f: Fighter, input: Dictionary) -> void:
	# i am aware of the sign function but it seems to be a float.
	var signn = 1
	if f.fixed_scale.x < 0:
		signn = -1
	f.vel.x = -signn * (65536 * 5) >> (f.state_time >> 3)

	# visual stuff, i can use floats here lmao
	var character = f.find_node("Character")
	character.modulate.b = 1 - 1.0 / (f.state_time / 10.0 + 1)
	character.modulate.g = 1 - 1.0 / (f.state_time / 10.0 + 1)


func animation(f: Fighter) -> String:
	return "Hitstun"


func can_land_cancel() -> bool:
	return false
