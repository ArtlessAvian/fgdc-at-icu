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
export(Resource) var throw

export(Array, Resource) var attacks = []
export(Array, Resource) var movement = []

# Things that don't make sense to override, but why the heck not.

const prefix = "res://addons/FGDC-Datatypes/"
var hitstun: Resource = load(prefix + "GenericStates/HitstunState.gd").new()
var blockstun: Resource = load(prefix + "GenericStates/BlockstunState.gd").new()
var dead: Resource = load(prefix + "GenericStates/DeadState.gd").new()
var do_throw: Resource = load(prefix + "GenericStates/DoThrowState.gd").new()
var get_thrown: Resource = load(prefix + "GenericStates/GetThrownState.gd").new()
var throw_tech: Resource = load(prefix + "GenericStates/ThrowTechState.gd").new()

# Get moveset as array
var lazy_all_normals: Array = []
var lazy_all_attacks: Array = []
var lazy_all_states: Array = []


func all_normals():
	if lazy_all_normals.empty():
		lazy_all_normals.append(j_heavy)
		lazy_all_normals.append(c_heavy)
		lazy_all_normals.append(heavy)
		lazy_all_normals.append(j_light)
		lazy_all_normals.append(c_light)
		lazy_all_normals.append(light)
	return lazy_all_normals


func all_attacks():
	if lazy_all_attacks.empty():
		lazy_all_attacks.append_array(attacks)
		lazy_all_attacks.append(throw)
		lazy_all_attacks.append_array(all_normals())
	return lazy_all_attacks


func all_states():
	if lazy_all_states.empty():
		lazy_all_states.append_array(all_attacks())
		lazy_all_states.append_array(movement)
		lazy_all_states.append(walk)
		lazy_all_states.append(crouch)
		lazy_all_states.append(jump)
		print(lazy_all_states)
		print(lazy_all_normals)
		print(lazy_all_attacks)
	return lazy_all_states
