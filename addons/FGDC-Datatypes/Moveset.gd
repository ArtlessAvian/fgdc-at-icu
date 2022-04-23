extends Resource
class_name Moveset
tool

export(int) var air_actions = 3

export(Resource) var walk
export(Resource) var crouch
export(Resource) var jump
export(Resource) var knockdown = load(prefix + "GenericStates/KnockdownState.gd").new()
# export(Resource) var airdash

export(Resource) var light
export(Resource) var heavy
export(Resource) var c_light
export(Resource) var c_heavy
export(Resource) var j_light
export(Resource) var j_heavy

export(Array, Resource) var attacks = []
export(Array, Resource) var movement = []

# Things that don't make sense to override, but why the heck not.

const prefix = "res://addons/FGDC-Datatypes/"
var hitstun: Resource = load(prefix + "GenericStates/HitstunState.gd").new()
var blockstun: Resource = load(prefix + "GenericStates/BlockstunState.gd").new()

var lazy_all_states: Array = []


func all_states():
	if lazy_all_states.empty():
		lazy_all_states.append_array(attacks)
		lazy_all_states.append(j_heavy)
		lazy_all_states.append(j_light)
		lazy_all_states.append(c_heavy)
		lazy_all_states.append(heavy)
		lazy_all_states.append(c_light)
		lazy_all_states.append(light)
		#lazy_all_states.append(knockdown)
		lazy_all_states.append_array(movement)
	return lazy_all_states
