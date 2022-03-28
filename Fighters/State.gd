extends Resource
class_name State

var land_cancels = true


func transition(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	return null


func run(f: Fighter, input: Dictionary) -> void:
	return


func animation(f: Fighter) -> String:
	return "Idle"


func transition_into_attack(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if input.light and self.attack_level() < moveset.light.attack_level():
		f.get_node("Hitboxes").new_attack()
		return moveset.light
	return null


func transition_into_air_attack(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if input.light and self.attack_level() < moveset.light.attack_level():
		f.get_node("Hitboxes").new_attack()
		return moveset.light
	return null


func attack_level() -> int:
	return -1
