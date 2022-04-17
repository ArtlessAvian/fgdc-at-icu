tool
extends EditorPlugin

const prefix = "res://addons/FGDC-Datatypes/"

const generic_states = [
	"AirdashState",
	"CrouchState",
	"FireballState",
	"JumpState",
	"NormalAttackState",
	"WalkState",
]

const haha_yes_emote = preload("Assets/maxHahaYes16x16.png")


func _enter_tree():
	add_custom_type("HitData", "Resource", preload(prefix + "HitData.gd"), haha_yes_emote)
	add_custom_type("AttackData", "HitData", preload(prefix + "AttackData.gd"), haha_yes_emote)

	add_custom_type("State", "Resource", preload(prefix + "State.gd"), haha_yes_emote)
	add_custom_type("Moveset", "Resource", preload(prefix + "Moveset.gd"), haha_yes_emote)
	for state in generic_states:
		add_custom_type(state, "State", load(prefix + "GenericStates/" + state + "State.gd"), haha_yes_emote)


func _exit_tree():
	remove_custom_type("AttackData")
	remove_custom_type("HitData")

	for state in generic_states:
		remove_custom_type(state)
	remove_custom_type("Moveset")
	remove_custom_type("State")
