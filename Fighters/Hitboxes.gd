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
	print("tick!!")


func _save_state() -> Dictionary:
	var disabled_children = {}
	for child in get_children():
		disabled_children[child.name] = child.disabled

	return {
		attack_number = attack_number,
		multihit = multihit,
		disabled_children = disabled_children
	}


func _load_state(save: Dictionary) -> void:
	attack_number = save.attack_number
	multihit = save.multihit

	for name in save.disabled_children:
		get_node(name).disabled = save.disabled_children[name]

	sync_to_physics_engine()
