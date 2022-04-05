extends "../State.gd"

export(int) var damage = 1
export(String) var animation_name
export(bool) var crouching = false
export(String, "light", "heavy") var button = "light"

export(int) var attack_level = 0

# func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
# if f.state in [moveset.walk, moveset.crouch]:
# 	if input.get(button):
# 		if input.stick_y < 0 == crouching:
# 			return true

# if f.state in [moveset.light, moveset.heavy, moveset.c_light, moveset.c_heavy]:
# 	if input.get(button):
# 		if input.stick_y < 0 == crouching:
# 			return true

# return false


func transition(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	# FAILSAFES.
	if animation_name == null:
		printerr("Move has no animation!")
		return moveset.walk

	if f.get_node("AnimationPlayer").get_animation(animation_name) == null:
		printerr("Animation does not exist!")
		return moveset.walk

	# End Failsafes.
	var attack = transition_into_attack(f, moveset, input)
	if attack != null:
		return attack

	if f.state_time > f.get_node("AnimationPlayer").get_animation(animation_name).length:
		if not f.grounded:
			return moveset.jump
		if input.stick_y < 0:
			return moveset.crouch
		return moveset.walk
	return null


func run(f: Fighter, input: Dictionary) -> void:
	# Controlled mostly by the animation player, but custom code here is fine too.
	# f.get_node("Hitboxes/SGCollisionShape2D").disabled = not f.state_time in [5, 6, 7]

	if f.grounded:
		f.vel.x = 0
	# f.vel.x -= sign(f.vel.x) * (65536 >> 2)  # crude "friction"

	pass


func animation(f: Fighter) -> String:
	return animation_name


func attack_level() -> int:
	return attack_level
