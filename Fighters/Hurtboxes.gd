extends SGArea2D
class_name Hurtboxes
tool

# Information here is only useful within a frame, so no need to save.
var hit_flag = false
var hitstun = 20
var blockstun = 8
var hit_hitdata 		# HitData of attack Figher got hit by.

# Save this
var attacks_hit_by = {} # Stores which attacks this Hurtbox has gotten hit by. Prevents being hit multiple times by same attack.


func _ready():
	for uncast in get_children():
		var child: SGCollisionShape2D = uncast
		var shape: SGRectangleShape2D = child.shape
		child.shape = child.shape.duplicate(true)

	add_to_group("hurtboxes")
	add_to_group("network_sync")


# no reason to toggle, just once at the start!
func toggle_player():
	collision_mask ^= 0b11


const color_disabled = Color8(127, 127, 127, 127)


func _process(delta):
	for uncast in get_children():
		var child: SGCollisionShape2D = uncast
		# child.visible = not child.disabled
		if child.disabled:
			child.self_modulate = color_disabled
		else:
			child.self_modulate = Color.white


func collide_hitboxes():
	hit_flag = false
	for hitboxes in self.get_overlapping_areas():
		if hitboxes is Hitboxes:
			var pair = hitboxes.attack_number * 100 + hitboxes.multihit
			var key = hitboxes.get_parent().name  # todo make not garbo
			if (not key in attacks_hit_by) or pair != attacks_hit_by[key]:
				hit_hitdata = hitboxes.get_hit_data()

				attacks_hit_by[key] = pair
				self.hit_flag = true
				hitboxes.emit_signal("on_hit")

				break  # only one thing can hit you at one time.

				# print("accepted ", SyncManager.current_tick)
			else:
				# print("rejected ", SyncManager.current_tick)
				pass


func _save_state() -> Dictionary:
	return {
		# hit_flag = hit_flag,
		attacks_hit_by_save = attacks_hit_by.duplicate(true),
	}


func _load_state(save: Dictionary) -> void:
	hit_flag = false
	attacks_hit_by = save.attacks_hit_by_save.duplicate(true)

	sync_to_physics_engine()
