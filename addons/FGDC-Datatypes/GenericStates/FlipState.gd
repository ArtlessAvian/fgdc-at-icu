extends "../State.gd"

const length = 20


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	if f.state_time > length:
		f.invincible = false
		return moveset.jump
	return null


func run(f: Fighter, input: Dictionary) -> void:
	f.invincible = true
	var character = f.find_node("Character")
	character.modulate = Color.skyblue.linear_interpolate(
		Color.white, f.state_time / 2.0 / f.state_dict.hitstun
	)


func exit(f: Fighter) -> void:
	f.invincible = false


func animation(f: Fighter) -> String:
	return "Flip"
