extends Resource
class_name State


func transition(fighter: Fighter, moveset: Moveset) -> State:
	return self


func run(fighter: Fighter) -> void:
	return


func animation(fighter: Fighter) -> String:
	return "Idle"
