extends "../State.gd"


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	if f.state_time > f.state_dict.blockstun:
		return moveset.walk if input.stick_y >= 0 else moveset.crouch
	return null


# func enter(f: Fighter):
# 	if not f.state_dict.has("knockback"):
# 		f.state_dict.knockb
func enter(f: Fighter) -> void:
	var stick = f.get_node("InputHistory")._stick_history[0]
	if stick == 1 or stick == 2 or stick == 3:
		f.state_dict["Crouching"] = true
	else:
		f.state_dict["Crouching"] = false


func run(f: Fighter, input: Dictionary) -> void:
	# i am aware of the sign function but it seems to be a float.
	# var signn = 1
	# if f.fixed_scale.x < 0:
	# 	signn = -1
	# f.vel.x = -signn * (65536 * f.state_dict.knockback)

	# visual stuff, i can use floats here lmao
	var character = f.find_node("Character")
	character.modulate = Color.yellow.linear_interpolate(
		Color.white, f.state_time / 2.0 / f.state_dict.blockstun
	)


func animation(f: Fighter) -> String:
	if f.state_dict["Crouching"]:
		if f.get_node("AnimationPlayer").has_animation("CrouchingBlockstun"):
			return "CrouchingBlockstun"
		return "Crouch"
	else:
		return "Blockstun"


func can_block() -> bool:
	return true
