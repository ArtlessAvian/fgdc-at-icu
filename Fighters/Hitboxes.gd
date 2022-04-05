extends SGArea2D
class_name Hitboxes
tool

signal on_hit(who)

# Has no logic, only holds onto information
# Hurtboxes will do the logic.

var attack_number = 0  # only access if you're hurtboxes
var multihit = 0


func _ready():
	for uncast in get_children():
		var child: SGCollisionShape2D = uncast
		var shape: SGRectangleShape2D = child.shape
		child.shape = child.shape.duplicate(true)


func _process(delta):
	for uncast in get_children():
		var child: SGCollisionShape2D = uncast
		if not Engine.editor_hint:
			child.visible = not child.disabled
			child.self_modulate = Color.red
		else:
			if child.disabled:
				child.self_modulate = Color.gray
			else:
				child.self_modulate = Color.red


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

	# var save =
	return {
		attack_number = attack_number,
		multihit = multihit,
		disabled_children = disabled_children
	}

	# if not get_parent().is_p2:
	# print(SyncManager.current_tick, " save ", save)

	# return save


func _load_state(save: Dictionary) -> void:
	attack_number = save.attack_number
	multihit = save.multihit

	for name in save.disabled_children:
		get_node(name).disabled = save.disabled_children[name]

	sync_to_physics_engine()

	# if not get_parent().is_p2:
	# print(SyncManager.current_tick, " load ", save)
