extends "../State.gd"

export(int) var knockdown_timer = 30

const klonk = preload("res://Sounds/keyboard_drop.wav")


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	#if f.grounded and f.get_node("Hurtboxes").hit_hitdata.knockdown and f.vel.y <= 0:
	#	return true
	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	# Burst activation
	if input.heavy and input.light and f.can_burst():
		f.invincible = false
		f.combo_count = 0
		return moveset.burst

	if f.state_dict.knockdown_timer <= 0 and f.grounded:
		f.invincible = false
		f.combo_count = 0
		print("for designers, knockdown ended frame ", f.state_time)

		# jump out of knockdown to not get grabbed to death
		var jump = transition_into_jump(f, moveset, input)
		return jump if jump != null else moveset.walk

	return null


func enter(f: Fighter) -> void:
	f.invincible = true
	f.grounded = false

	# if f.vel.y <= 0:
	# f.vel.y = 15 << 16

	f.state_dict.knockdown_timer = 30  # same here? unless we make it consistent

	SyncManager.play_sound(
		str(f.get_path()) + ":knockdown",
		klonk,
		{position = f.position, pitch_scale = 1, volume_db = 5, bus = "SFX"}
	)


func run(f: Fighter, input: Dictionary) -> void:
	if f.grounded:
		f.state_dict.knockdown_timer -= 1

	# TODO: bandaid fix
	var character = f.find_node("Character")
	character.modulate = Color.white


func exit(f: Fighter) -> void:
	f.invincible = false


func animation(f: Fighter) -> String:
	return "Knockdown" if f.state_dict.knockdown_timer == 30 else "Wakeup"


func do_landing(f: Fighter, moveset: Moveset) -> void:
	if f.vel.y > -10 << 16:
		f.fixed_position.y = 0
		f.vel.x = 0
		f.vel.y = 0
		f.grounded = true
	else:
		# limit bouncing
		if f.vel.y < -15 << 16:
			f.vel.y = -15 << 16

		f.fixed_position.y = 0
		f.vel.x = f.vel.x >> 1
		f.vel.y = (-f.vel.y * 3) >> 2


func get_landing_transition(f: Fighter, moveset: Moveset) -> State:
	return null


func attack_level():
	return 8765309
