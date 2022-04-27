extends SGArea2D
class_name Hurtboxes
tool

# Information here is only useful within a frame, so no need to save.
var hit_hitdata  # HitData of attack Figher got hit by.
var hit_hitboxes = null  # (You can't save this one even if you tried. (I also tried saving the path.))

# Save this
var attacks_hit_by = {}  # Stores which attacks this Hurtbox has gotten hit by. Prevents being hit multiple times by same attack.


func _ready():
	if not Engine.editor_hint:
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
	self.hit_hitdata = null
	self.hit_hitboxes = null

	for hitboxes in self.get_overlapping_areas():
		if hitboxes is Hitboxes:
			var pair = hitboxes.attack_number * 100 + hitboxes.multihit
			var key = hitboxes.get_path()  # todo make not garbo

			if (not key in attacks_hit_by) or pair != attacks_hit_by[key]:
				self.hit_hitdata = hitboxes.get_hit_data()
				self.hit_hitboxes = hitboxes
				break  # only one thing can hit you at one time.
	pass


# call me if you got hit!
func register_contact(blocked: bool):
	var pair = hit_hitboxes.attack_number * 100 + hit_hitboxes.multihit
	var key = hit_hitboxes.get_path()  # todo make not garbo
	self.attacks_hit_by[key] = pair
	hit_hitboxes.emit_signal("on_contact", blocked)


func _save_state() -> Dictionary:
	return {
		attacks_hit_by_save = attacks_hit_by.duplicate(true),
		# hit_hitdata = hit_hitdata
	}


func _load_state(save: Dictionary) -> void:
	attacks_hit_by = save.attacks_hit_by_save.duplicate(true)
	# hit_hitdata = save.hit_hitdata

	sync_to_physics_engine()
