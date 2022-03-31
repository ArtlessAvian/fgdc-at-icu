extends Resource
class_name Moveset

export(int) var air_actions = 5

export(Resource) var walk
export(Resource) var crouch
export(Resource) var jump

export(Resource) var light
export(Resource) var heavy
export(Resource) var c_light
export(Resource) var c_heavy
export(Resource) var j_light
export(Resource) var j_heavy

# Things that don't make sense to override, but why the heck not.

var hitstun: Resource = load("res://Fighters/GenericStates/HitstunState.gd").new()
var blockstun: Resource = load("res://Fighters/GenericStates/BlockstunState.gd").new()

# export(Resource) var hitstun

export(Array, String) var blocking_state_names = ["walk", "crouch", "jump", "blockstun"]
export(Array, String) var attacking_state_names = [
	"light", "heavy", "c_light", "c_heavy", "j_light", "j_heavy"
]

# Lazy loaded
# var _blocking_states = []
# var _attacking_states = []
#


func can_state_block(state):
	# Lazy load
	# if _blocking_states.empty():
	# for key in blocking_state_names:
	# _blocking_states.append(get(key))

	# return state in _blocking_states

	for name in blocking_state_names:
		if get(name) == state:
			return true
	return false
