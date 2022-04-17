extends HitData
class_name AttackData
tool

export(String) var animation_name = "Walk"
export(int) var recovery = 10


func write_hitbox_positions(time, hitboxes):
	for child in hitboxes.get_children():
		child.disabled = true

	var hitdata: HitData = get_hitdata(time)

	# activate hitboxes and such
	if hitdata != null:
		# print("got time for an interview?")
		for i in range(len(hitdata.hitbox_placement) / 4):
			var child = hitboxes.get_child(i)
			child.fixed_position.x = hitdata.hitbox_placement[i * 4 + 0]
			child.fixed_position.y = hitdata.hitbox_placement[i * 4 + 1]
			child.shape.extents.x = hitdata.hitbox_placement[i * 4 + 2]
			child.shape.extents.y = hitdata.hitbox_placement[i * 4 + 3]
			child.disabled = false

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