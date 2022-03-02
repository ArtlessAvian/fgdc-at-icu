extends SGArea2D
class_name Hurtboxes

# Has no logic, only holds onto a hit.
# Information here is only useful within a frame, so no need to save.

var hit_flag = false
var hitstun = 20

var hurty = {} # please name this something better soon.

func collide_hitboxes():
	var my_hitboxes: SGArea2D = $"../Hitboxes"
	
	for hitboxes in self.get_overlapping_areas():
		if hitboxes == my_hitboxes:
			continue

		if hitboxes is Hitboxes:
			if (not hitboxes in hurty) or hitboxes._tick != hurty[hitboxes]:
				hurty[hitboxes] = hitboxes._tick
				self.hit_flag = true
				print("oof! ", hitboxes._tick)

func _save_state() -> Dictionary:
	return {
		hurty = hurty.duplicate(),
	}

func _load_state(save: Dictionary) -> void:
	hurty = save.hurty
