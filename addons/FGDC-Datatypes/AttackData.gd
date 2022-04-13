extends Resource
class_name AttackData

export(String) var animation_name = "sLight"

export(String, "MID", "LOW", "HIGH") var guard = 0

export(int) var startup = 4
export(int) var active = 2
export(int) var recovery = 10

export(int) var hitstun = 12
export(int) var blockstun = 12
export(int) var hitstop = 5

export(int) var damage = 1


func do_hitboxy_stuff(time: int, hitboxes: Hitboxes):
	for child in hitboxes.get_children():
		child.disabled = true

	if time >= startup and time < startup + active:
		for child in hitboxes.get_children():
			child.disabled = false
