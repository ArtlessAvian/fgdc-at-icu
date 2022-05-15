extends "../State.gd"

export(Resource) var attack_data = null

export(int) var attack_level = 0
export(bool) var jump_cancellable = false


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

	# TODO: Rethink Hitbox, Hurtbox interation.
	# This checks for contact but /not/ hitting.
	if jump_cancellable or f.get_node("Hitboxes").attack_number == f.state_dict.last_attack_contact:
		var jump
		if f.grounded:
			jump = transition_into_jump(f, moveset, input)
		else:
			jump = transition_into_double_jump(f, moveset, input)
		if jump != null:
			return jump

	if f.state_time > attack_data.animation_length():
		if not f.grounded:
			return moveset.jump
		if input.stick_y < 0:
			return moveset.crouch
		return moveset.walk
	return null


func enter(f: Fighter) -> void:
	f.get_node("Hitboxes").new_attack()

	if not f.state_dict.has("last_attack_contact"):
		f.state_dict.last_attack_contact = -1


func run(f: Fighter, input: Dictionary) -> void:
	# Controlled mostly by the animation player, but custom code here is fine too.
	# f.get_node("Hitboxes/SGCollisionShape2D").disabled = not f.state_time in [5, 6, 7]

	if f.grounded:
		f.vel.x = 0
	# f.vel.x -= sign(f.vel.x) * (65536 >> 2)  # crude "friction"

	ensure_not_null()
	attack_data.write_hitbox_positions(f.state_time, f.get_node("Hitboxes"))
	# print(f.state_time)

	pass


func animation(f: Fighter) -> String:
	ensure_not_null()
	return attack_data.animation_name


func attack_level() -> int:
	return attack_level
