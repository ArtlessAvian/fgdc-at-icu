extends HitData
class_name AttackData
tool

export(String) var animation_name = "Walk"
export(int) var recovery = 10

# not gameplay thing so no need to save
var warning: bool = false


func write_hitbox_positions(time, hitboxes):
	for child in hitboxes.get_children():
		child.disabled = true

	var hitdata: HitData = get_hitdata(time)

	# activate hitboxes and such. Store hitdata within the hitbox for use when a Fighter gets hit.
	hitboxes.set_hit_data(hitdata)
	if hitdata != null:
		# print("got time for an interview?")
		for i in range(len(hitdata.hitbox_placement) / 4):
			var child = hitboxes.get_child(i)
			child.fixed_position.x = hitdata.hitbox_placement[i * 4 + 0] << 16
			child.fixed_position.y = hitdata.hitbox_placement[i * 4 + 1] << 16
			child.shape.extents.x = hitdata.hitbox_placement[i * 4 + 2] << 16
			child.shape.extents.y = hitdata.hitbox_placement[i * 4 + 3] << 16
			child.disabled = false

		if not warning and len(hitdata.hitbox_placement) == 0:
			warning = true
			printerr("warning: " + hitdata.resource_path + "has no hitbox placement!")

		# TEMPORARY
		for child in hitboxes.get_children():
			child.disabled = false

	# linked list bullshit
	if hitdata != null:
		var multi_hit = 0
		var current = self
		while hitdata != current:
			multi_hit += 1
			current = current.followup
		hitboxes.multihit = multi_hit


func animation_length():
	var total = 0
	var current_data = self
	while current_data != null:
		total += startup
		total += active
		current_data = current_data.followup
	return total + recovery
