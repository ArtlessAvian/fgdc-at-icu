extends "../State.gd"


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if f.state_time >= f.state_dict["throwdata"].release_time:
		f.vel.x = (f.state_dict["throwdata"].release_vel_x << 16) * -int(sign(f.fixed_scale.x))
		f.vel.y = f.state_dict["throwdata"].release_vel_y << 16

		f.grounded = false
		f.invincible = false
		return moveset.jump

	return null


func run(f: Fighter, input: Dictionary) -> void:
	f.invincible = true


func animation(f: Fighter) -> String:
	return "Hitstun"


func attack_level() -> int:
	return 10
