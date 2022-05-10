extends "../State.gd"

export(int) var impulse = 24 * 65536
export(int) var double_jump_impulse = 16 * 65536
export(int) var horizontal_speed = 10 * 65536

const prejump_frames = 3


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	var attack = transition_into_attack(f, moveset, input)
	if attack != null:
		return attack

	if f.state_time >= prejump_frames:
		if input.stick_x == 0:
			f.vel.x = 0
		elif input.stick_x < 0 and f.vel.x > -moveset.jump.horizontal_speed:
			f.vel.x = -moveset.jump.horizontal_speed
		elif input.stick_x > 0 and f.vel.x < moveset.jump.horizontal_speed:
			f.vel.x = moveset.jump.horizontal_speed

		f.vel.y = moveset.jump.impulse
		f.air_actions = moveset.air_actions
		f.grounded = false

		return moveset.jump

	return null


func run(f: Fighter, input: Dictionary) -> void:
	pass


# TODO: Proper prejump animation
func animation(f: Fighter) -> String:
	if (f.get_node("AnimationPlayer") as AnimationPlayer).has_animation("Prejump"):
		return "Prejump"
	return "Crouch"


func can_block() -> bool:
	return true
