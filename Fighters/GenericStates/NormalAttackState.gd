extends "../State.gd"

export(Resource) var attack_data = null

export(int) var attack_level = 0

# func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool16:
# 	if f.state in [moveset.walk, moveset.crouch]:
# 		if input.get(button):
# 			if input.stick_y < 0 == crouching:
# 				return true

# 	if f.state in [moveset.light, moveset.heavy, moveset.c_light, moveset.c_heavy]:
# 		if input.get(button):
# 			if input.stick_y < 0 == crouching:
# 				return true

# 	return false


func ensure_not_null():
	if attack_data == null:
		attack_data = load("res://addons/FGDC-Datatypes/AttackData.gd").new()
		printerr("oh no, the " + resource_path + ", its broken")


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	# FAILSAFES.
	ensure_not_null()

	if f.get_node("AnimationPlayer").get_animation(attack_data.animation_name) == null:
		printerr("Animation does not exist!")
		return moveset.walk

	# End Failsafes.
	var attack = transition_into_attack(f, moveset, input)
	if attack != null:
		return attack

	if f.state_time > attack_data.startup + attack_data.active + attack_data.recovery:
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

	ensure_not_null()
	attack_data.do_hitboxy_stuff(f.state_time, f.get_node("Hitboxes"))
	# print(f.state_time)

	pass


func animation(f: Fighter) -> String:
	ensure_not_null()
	return attack_data.animation_name


func attack_level() -> int:
	return attack_level
