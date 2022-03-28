extends "res://addons/godot-rollback-netcode/MessageSerializer.gd"


func serialize_input(input: Dictionary) -> PoolByteArray:
	var temp = var2bytes(input)
	# print(input, temp.size())
	return temp
