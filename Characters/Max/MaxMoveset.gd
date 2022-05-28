#extends "res://addons/FGDC-Datatypes/Moveset.gd"
extends Moveset

# Declare member variables here. Examples:
const max_prefix = "res://Characters/Max/"
var dp_recovery: Resource = load(max_prefix + "DPRecovery.gd").new()


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
		lazy_all_attacks.append(burst)
		lazy_all_attacks.append_array(all_normals())
	return lazy_all_attacks


func all_states():
	if lazy_all_states.empty():
		lazy_all_states.append_array(all_attacks())
		lazy_all_states.append_array(movement)
		lazy_all_states.append(walk)
		lazy_all_states.append(crouch)
		lazy_all_states.append(jump)
		lazy_all_states.append(knockdown)
		lazy_all_states.append(flip)
		lazy_all_states.append(dp_recovery)
		# print(lazy_all_states)
		# print(lazy_all_normals)
		# print(lazy_all_attacks)
	return lazy_all_states
