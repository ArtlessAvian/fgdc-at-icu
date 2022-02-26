extends "../State.gd"

export(int) var speed


func transition(f: Fighter, moveset: Moveset) -> State:
	if Input.is_action_pressed("ui_up"):
		if Input.is_action_pressed("ui_left") != Input.is_action_pressed("ui_right"):
			if Input.is_action_pressed("ui_left") and f.vel.x > -5 * 65536:
				f.vel.x = -5 * 65536
			if Input.is_action_pressed("ui_right") and f.vel.x < 5 * 65536:
				f.vel.x = 5 * 65536

		f.vel.y -= 12 * 65536
		f.air_actions = moveset.air_actions
		f.apply_gravity = true

		return moveset.jump
	return self


func run(f: Fighter) -> void:
	f.vel.x = 0
	if Input.is_action_pressed("ui_left"):
		f.vel.x -= 5 * 65536
	if Input.is_action_pressed("ui_right"):
		f.vel.x += 5 * 65536


func animation(f: Fighter) -> String:
	return "Walk" if f.vel.x != 0 else "Idle"
