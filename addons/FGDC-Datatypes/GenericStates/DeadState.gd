extends "../State.gd"


# Dead if no health.
func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if f.health == 0 and f.state != self:
		return true

	return false


# Can't transition out of Dead state. Must reload Game/Match scene.
func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	return null


func enter(f: Fighter):
	f.vel.y = 15 << 16
	f.vel.x = -int(sign(f.fixed_scale.x)) * 10 << 16
	f.grounded = false
	f.state_dict.knockdown_timer = -8765309


func run(f: Fighter, input: Dictionary) -> void:
	# super omega hack.
	# just pretend to be the knockdown state.
	f.moveset.knockdown.run(f, input)


# TODO: Dead animation
func animation(f: Fighter) -> String:
	return "Knockdown"


func can_land_cancel() -> bool:
	return false
