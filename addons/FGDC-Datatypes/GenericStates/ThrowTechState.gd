extends "../State.gd"


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	if f.state_time >= 10:
		f.invincible = false
		return moveset.walk if f.grounded else moveset.jump
	return null


func run(f: Fighter, input: Dictionary) -> void:
	f.vel.x = (10 << 16) * -int(sign(f.fixed_scale.x))
	f.invincible = true

	# TODO: Remove bandaid fix
	var character = f.find_node("Character")
	character.modulate = Color.purple


func animation(f: Fighter) -> String:
	return "Hitstun"


func attack_level() -> int:
	return 8765309
