extends "../State.gd"

export(int) var damage = 1
# export(int) var length = 8
export(String) var animation_name


func transition(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	# FAILSAFES.
	if animation_name == null:
		printerr("Move has no animation!")
		return moveset.walk

	if f.get_node("AnimationPlayer").get_animation(animation_name) == null:
		printerr("Animation does not exist!")
		return moveset.walk

	# End Failsafes.

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
	return 0
