extends Resource
class_name State


func transition(f: Fighter, moveset: Moveset) -> State:
	return self


func run(f: Fighter) -> void:
	return


func animation(f: Fighter) -> String:
	return "Idle"
