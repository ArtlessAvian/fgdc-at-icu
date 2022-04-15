tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("HitData", "Resource", preload("HitData.gd"), preload("maxHahaYes16x16.png"))
	add_custom_type(
		"AttackData", "HitData", preload("AttackData.gd"), preload("maxHahaYes16x16.png")
	)


func _exit_tree():
	remove_custom_type("AttackData")
	remove_custom_type("HitData")
