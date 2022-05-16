extends SGArea2D
class_name Hurtboxes
tool

# Information here is only useful within a frame, so no need to save.
var hit_hitdata  # HitData of attack Figher got hit by.
var hit_hitboxes = null  # (You can't save this one even if you tried. (I also tried saving the path.))

var throw_throwdata = null
#var throw_throwboxes = null # only the other fighter can throw you.

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


func set_player(is_p2, is_projectile = false):
	collision_mask = 0b10
	if is_p2:
		collision_mask ^= 0b11
	if is_projectile:
		collision_mask <<= 2


const color_disabled = Color8(127, 127, 127, 10)


func _process(delta):
	for uncast in get_children():
		var child: SGCollisionShape2D = uncast
		# child.visible = not child.disabled
		if child.disabled:
			child.modulate = color_disabled
		else:
			child.modulate = Color.white if not Engine.editor_hint else Color.green


func collide_hitboxes():
	self.hit_hitdata = null
	self.hit_hitboxes = null
	self.throw_throwdata = null

	for hitboxes in self.get_overlapping_areas():
		if hitboxes is Hitboxes:
			var pair = hitboxes.attack_number * 100 + hitboxes.multihit
			var key = hitboxes.get_path()  # todo make not garbo

			if (not key in attacks_hit_by) or pair != attacks_hit_by[key]:
				self.hit_hitdata = hitboxes.get_hit_data()
				self.hit_hitboxes = hitboxes
				break  # only one thing can hit you at one time.

	for throwboxes in self.get_overlapping_areas():
		if throwboxes is Throwboxes:
			self.throw_throwdata = throwboxes.get_throw_data()
			break


# call me if you got hit!
func register_contact(blocked: bool):
	var pair = hit_hitboxes.attack_number * 100 + hit_hitboxes.multihit
	var key = hit_hitboxes.get_path()  # todo make not garbo
	self.attacks_hit_by[key] = pair
	hit_hitboxes.emit_signal("on_contact", blocked, hit_hitdata.hitstop)


func _save_state() -> Dictionary:
	return {
		attacks_hit_by_save = attacks_hit_by.duplicate(true),
		# hit_hitdata = hit_hitdata
	}


func _load_state(save: Dictionary) -> void:
	attacks_hit_by = save.attacks_hit_by_save.duplicate(true)
	# hit_hitdata = save.hit_hitdata

	sync_to_physics_engine()
