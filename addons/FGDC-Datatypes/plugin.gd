tool
extends EditorPlugin


func _enter_tree():
	add_custom_type(
		"AttackData", "Resource", preload("AttackData.gd"), preload("maxHahaYes16x16.png")
	)


func _exit_tree():
	remove_custom_type("AttackData")
