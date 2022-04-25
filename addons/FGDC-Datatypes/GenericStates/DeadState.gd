extends "../State.gd"

# Dead if no health.
func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if f.health == 0:
		return true

	return false

# Can't transition out of Dead state. Must reload Game/Match scene.
func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	return null


func run(f: Fighter, input: Dictionary) -> void:
	pass


# TODO: Dead animation
# func animation(f: Fighter) -> String:
# 	return "Walk" if f.vel.x != 0 else "Idle"
