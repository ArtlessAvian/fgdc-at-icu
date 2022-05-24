extends "../State.gd"

const prejump_frames = 3


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	# var attack = transition_into_attack(f, moveset, input)
	# if attack != null:
	# 	return attack

	if f.state_time >= prejump_frames:
		if input.stick_x == 0:
			f.vel.x = 0
		# snail, polluting my code base.
		elif (
			input.stick_x < 0
			and (
				f.vel.x > -moveset.jump.horizontal_speed
				or moveset.jump.horizontal_speed < 0
			)
		):
			f.vel.x = -moveset.jump.horizontal_speed
		elif (
			input.stick_x > 0
			and (
				f.vel.x < moveset.jump.horizontal_speed
				or moveset.jump.horizontal_speed < 0
			)
		):
			f.vel.x = moveset.jump.horizontal_speed

		f.vel.y = moveset.jump.impulse
		f.air_actions = moveset.air_actions
		f.grounded = false

		return moveset.jump

	return null


func run(f: Fighter, input: Dictionary) -> void:
	f.vel.x = 0


# TODO: Proper prejump animation
func animation(f: Fighter) -> String:
	if (f.get_node("AnimationPlayer") as AnimationPlayer).has_animation("Prejump"):
		return "Prejump"
	return "Crouch"


func can_block() -> bool:
	return true
