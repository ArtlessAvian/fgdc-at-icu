extends "../State.gd"

export(int) var knockdown_timer = 30


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if f.grounded and f.get_node("Hurtboxes").hit_hitdata.knockdown:
		return true
	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if f.state_dict.knockdown_timer <= 0 and f.grounded:
		f.invincible = false
		return moveset.walk

	return null


func enter(f: Fighter) -> void:
	f.invincible = true
	f.grounded = false

	f.vel.y = 15 << 16  # hardcoded for now. this should go elsewhere!!

	f.state_dict.knockdown_timer = 30  # same here? unless we make it consistent


func run(f: Fighter, input: Dictionary) -> void:
	if f.fixed_position_y >= 0 and f.vel.y <= 0:
		if f.vel.y > -10 << 16:
			f.state_dict.knockdown_timer -= 1
			f.vel.y = 0
			f.vel.x = 0
			f.grounded = true
		else:
			f.vel.y = (-f.vel.y * 3) >> 2
			f.vel.x = f.vel.x >> 1


func animation(f: Fighter) -> String:
	return "Knockdown"


func can_land_cancel() -> bool:
	return false


func attack_level():
	return 8765309
