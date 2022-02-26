extends "../State.gd"


func transition(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if f.state_time > f.hitstun:
		return moveset.walk
	return null


func run(f: Fighter, input: Dictionary) -> void:
	pass

# func animation(f: Fighter) -> String:
# return "Idle"
