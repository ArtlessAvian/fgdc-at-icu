extends Resource
class_name HitData
tool

# if you want to be tricky, if bit 0 is 1, you need to block low
# if bit 1 is 1, you need to block high
# and you can't block both at the same time >:)
export(String, "MID", "LOW", "HIGH", "UNBLOCKABLE") var guard = 0

export(int) var startup = 4
export(int) var active = 2

export(int) var hitstun = 12
export(int) var blockstun = 12
export(int) var hitstop = 5

export(int) var damage = 1

# center x, centery y, width, height
export(Array, int) var hitbox_placement

# desgustang linked list approach
export(Resource) var followup = null


func get_hitdata(time: int):
	if time < startup:
		return null
	if time < startup + active:
		return self
	if followup != null:
		return followup.get_hitdata(time - startup - active)
	return null