extends SGArea2D
class_name Hurtboxes

# Information here is only useful within a frame, so no need to save.
var hit_flag = false
var hitstun = 20

# Save this
var hurty = {}  # please name this something better soon.


func collide_hitboxes():
	hit_flag = false

	var my_hitboxes: SGArea2D = $"../Hitboxes"

	for hitboxes in self.get_overlapping_areas():
		if hitboxes == my_hitboxes:
			continue

		if hitboxes is Hitboxes:
			var pair = hitboxes.attack_number * 100 + hitboxes.multihit
			print(pair)
			var key = hitboxes.get_parent().is_p2  # todo make not garbo
			if (not key in hurty) or pair != hurty[key]:
				hurty[key] = pair
				self.hit_flag = true

				# print("accepted ", SyncManager.current_tick)
			else:
				# print("rejected ", SyncManager.current_tick)
				pass


func _save_state() -> Dictionary:
	return {
		hit_flag = hit_flag,
		hurty = hurty.duplicate(true),
	}


func _load_state(save: Dictionary) -> void:
	hit_flag = save.hit_flag
	hurty = save.hurty.duplicate(true)
