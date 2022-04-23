extends HitData
class_name AttackData
tool

export(String) var animation_name = "Walk"
export(int) var recovery = 10

# not gameplay thing so no need to save
# var warning: bool = false


func write_hitbox_positions(time, hitboxes):
	for child in hitboxes.get_children():
		child.disabled = true

	var hitdata: HitData = get_hitdata(time)

	# activate hitboxes and such. Store hitdata within the hitbox for use when a Fighter gets hit.
	hitboxes.set_hit_data(hitdata)
	if hitdata != null:
		# print("got time for an interview?")
		for i in range(hitdata.active_hitboxes):
			var child = hitboxes.get_child(i)
			child.disabled = false

		# TODO: Counterhit boxes? or maybe just do manually in aniplayer.
		# Since those don't have much extra data attached to them.

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
