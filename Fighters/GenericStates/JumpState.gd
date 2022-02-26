extends "../State.gd"

export(int) var speed


func transition(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if input.just_stick_y > 0:
		if f.air_actions > 0:
			if input.stick_x == 0:
				f.vel.x = 0
			if input.stick_x < 0 and f.vel.x > -5 * 65536:
				f.vel.x = -5 * 65536
			if input.stick_x > 0 and f.vel.x < 5 * 65536:
				f.vel.x = 5 * 65536

			f.vel.y = 6 * 65536
			f.air_actions -= 1
			return self

	return null


func run(f: Fighter, input: Dictionary) -> void:
	pass


func animation(f: Fighter) -> String:
	return "Jump"
