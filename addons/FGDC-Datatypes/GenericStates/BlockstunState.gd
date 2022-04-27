extends "../State.gd"


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if f.state_time > f.state_dict.blockstun:
		return moveset.walk
	return null


# func enter(f: Fighter):
# 	if not f.state_dict.has("knockback"):
# 		f.state_dict.knockb


func run(f: Fighter, input: Dictionary) -> void:
	f.vel.x = 0

	# i am aware of the sign function but it seems to be a float.
	# var signn = 1
	# if f.fixed_scale.x < 0:
	# 	signn = -1
	# f.vel.x = -signn * (65536 * f.state_dict.knockback)

	# visual stuff, i can use floats here lmao
	var sprite: Sprite = f.find_node("Sprite")
	sprite.self_modulate.b = 1 - 1.0 / (f.state_time / 3.0 + 1)
	sprite.self_modulate.g = 1 - 1.0 / (f.state_time / 3.0 + 1)


func animation(f: Fighter) -> String:
	return "Blockstun"


func can_block() -> bool:
	return true
