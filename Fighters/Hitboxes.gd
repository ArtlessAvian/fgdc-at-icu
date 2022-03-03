extends SGArea2D
class_name Hitboxes

signal on_hit(who)

# Has no logic, only holds onto information
# Hurtboxes will do the logic.

var attack_number = 0  # only access if you're hurtboxes
var multihit = 0


# Called by animation players. Or by bored people.
func new_attack():
	attack_number += 1
	multihit = 0


func tick():
	multihit += 1


func _save_state() -> Dictionary:
	return {
		attack_number = attack_number,
		multihit = multihit,
	}


func _load_state(save: Dictionary) -> void:
	attack_number = save.attack_number
	multihit = save.multihit
