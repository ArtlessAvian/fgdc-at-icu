extends "../State.gd"

export(int) var damage = 1
export(int) var length = 8


func transition(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if f.state_time > length:
		return moveset.walk
	return null


func run(f: Fighter, input: Dictionary) -> void:
	pass


func animation(f: Fighter) -> String:
	return "Light"


func attack_level() -> int:
	return 0
