extends Resource
class_name Moveset

export(int) var air_actions = 5

export(Resource) var walk
export(Resource) var jump

export(Resource) var light
export(Resource) var heavy
export(Resource) var cr_light
export(Resource) var cr_heavy
export(Resource) var j_light
export(Resource) var j_heavy

var knockback: Resource = load("res://Fighters/GenericStates/KnockbackState.gd").new()
