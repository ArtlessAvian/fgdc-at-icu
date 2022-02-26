extends "../State.gd"

export(int) var speed


func transition(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if input.stick_y > 0:
		if input.stick_x < 0 and f.vel.x > -5 * 65536:
			f.vel.x = -5 * 65536
		if input.stick_x > 0 and f.vel.x < 5 * 65536:
			f.vel.x = 5 * 65536

		f.vel.y += 12 * 65536
		f.air_actions = moveset.air_actions
		f.apply_gravity = true

		return moveset.jump
	return null


func run(f: Fighter, input: Dictionary) -> void:
	if input.stick_x == 0:
		f.vel.x = 0
	if input.stick_x < 0:
		f.vel.x = -5 * 65536
	if input.stick_x > 0:
		f.vel.x = 5 * 65536


func animation(f: Fighter) -> String:
	return "Walk" if f.vel.x != 0 else "Idle"
