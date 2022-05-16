extends SGArea2D
class_name Hitboxes
tool

signal on_contact(blocked)  # blocked: bool

# Has no logic, only holds onto information
# Hurtboxes will do the logic.

var attack_number = 0  # only access if you're hurtboxes
var multihit = 0
var facing = 0  # -1 for left, 0 for "compare parents", 1 for right


func _ready():
	if not Engine.editor_hint:
		for uncast in get_children():
			var child: SGCollisionShape2D = uncast
			var shape: SGRectangleShape2D = child.shape
			child.shape = child.shape.duplicate(true)

	add_to_group("hitboxes")
	add_to_group("network_sync")


func set_player(is_p2, is_projectile = false):
	collision_layer = 0b01
	if is_p2:
		collision_layer ^= 0b11
	if is_projectile:
		collision_layer |= 0b0100
		if is_p2:
			collision_layer ^= 0b1100


func _process(delta):
	for uncast in get_children():
		var child = uncast
		if not Engine.editor_hint:
			child.visible = not child.disabled
			child.modulate = Color.red
		else:
			if child.disabled:
				child.modulate = Color.gray
			else:
				child.modulate = Color.red

		child.position.x = child.fixed_position.x / (1 << 16)
		child.position.y = child.fixed_position.y / (1 << 16)


# Called by animation players. Or by bored people.
func new_attack():
	attack_number += 1
	multihit = 0


export(Resource) var hit_data


# Allows Hurtboxes to see what attack they got hit with by calling get_hit_data()
func set_hit_data(new_hit_data: HitData):
	hit_data = new_hit_data


func get_hit_data() -> HitData:
	return hit_data


func _save_state() -> Dictionary:
#	var disabled_children = {}
#	for child in get_children():
#		disabled_children[child.name] = child.disabled

	# var save =
	return {
		attack_number = attack_number,
		multihit = multihit,
		#		disabled_children = disabled_children
	}

	# if not get_parent().is_p2:
	# print(SyncManager.current_tick, " save ", save)

	# return save


func _load_state(save: Dictionary) -> void:
	attack_number = save.attack_number
	multihit = save.multihit

#	for name in save.disabled_children:
#		get_node(name).disabled = save.disabled_children[name]

	sync_to_physics_engine()

	# if not get_parent().is_p2:
	# print(SyncManager.current_tick, " load ", save)
