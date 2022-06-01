extends State

var recovery = 18


func enter(f: Fighter) -> void:
	f.vel.x = 0
	.enter(f)

func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	if f.state_time >= recovery:
		return moveset.walk
		
	return null

func animation(f: Fighter) -> String:
	return "Prejump"

func get_landing_transition(f: Fighter, moveset: Moveset) -> State:
	return null
