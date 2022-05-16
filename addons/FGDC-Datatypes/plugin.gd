tool
extends EditorPlugin

const generic_states = [
	"AirdashState",
	"BackdashState",
	"BurstState",
	"CrouchState",
	"FireballState",
	"PrejumpState",
	"JumpState",
	"KnockdownState",
	"NormalAttackState",
	"ThrowAttemptState",
	"WalkState"
]

# These are **intentionally** oversized.
const max_emote = preload("res://addons/FGDC-Datatypes/Assets/maxHahaYes-32x32.png")
const lippo_emote = preload("res://addons/FGDC-Datatypes/Assets/lippo-32x32.png")


func _enter_tree():
	add_custom_type(
		"HitData", "Resource", preload("res://addons/FGDC-Datatypes/HitData.gd"), max_emote
	)
	add_custom_type(
		"AttackData", "Resource", preload("res://addons/FGDC-Datatypes/AttackData.gd"), max_emote
	)
	add_custom_type(
		"ThrowData", "Resource", preload("res://addons/FGDC-Datatypes/ThrowData.gd"), max_emote
	)

	add_custom_type(
		"State", "Resource", preload("res://addons/FGDC-Datatypes/State.gd"), lippo_emote
	)
	add_custom_type(
		"Moveset", "Resource", preload("res://addons/FGDC-Datatypes/Moveset.gd"), max_emote
	)

	for state in generic_states:
		add_custom_type(
			state,
			"Resource",
			load("res://addons/FGDC-Datatypes/GenericStates/" + state + ".gd"),
			lippo_emote
		)


func _exit_tree():
	remove_custom_type("AttackData")
	remove_custom_type("HitData")

	for state in generic_states:
		remove_custom_type(state)
	remove_custom_type("Moveset")
	remove_custom_type("State")
