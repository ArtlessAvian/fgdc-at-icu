extends "res://addons/godot-rollback-netcode/MessageSerializer.gd"

var game_path = "/root/Crude/Match/Game/"
const fighter_1 = "Fighter1"
const fighter_2 = "Fighter2"


func serialize_input(all_input: Dictionary) -> PoolByteArray:
	var buffer = StreamPeerBuffer.new()
	buffer.resize(16)

	buffer.put_u32(all_input["$"])

	for path in all_input:
		if path == "$":
			continue

		var bitpacking = 0
		bitpacking += 0 if path == game_path + fighter_1 else 1

		bitpacking += (all_input[path]["stick_x"] + 1) << 1
		bitpacking += (all_input[path]["stick_y"] + 1) << 3
		bitpacking += int(all_input[path]["light"]) << 5
		bitpacking += int(all_input[path]["heavy"]) << 6
		bitpacking += int(all_input[path]["dash"]) << 7

		buffer.put_u16(bitpacking)

	buffer.resize(buffer.get_position())
	return buffer.data_array


func unserialize_input(serialized: PoolByteArray) -> Dictionary:
	var buffer = StreamPeerBuffer.new()
	buffer.put_data(serialized)
	buffer.seek(0)

	var all_input := {}

	all_input["$"] = buffer.get_u32()
	var bitpacking = buffer.get_u16()
	var player = fighter_2 if (bitpacking & 0b1) else fighter_1

	var input_frame = {
		stick_x = ((bitpacking >> 1) & 0b11) - 1,
		stick_y = ((bitpacking >> 3) & 0b11) - 1,
		light = bool((bitpacking >> 5) & 0b1),
		heavy = bool((bitpacking >> 6) & 0b1),
		dash = bool((bitpacking >> 7) & 0b1)
	}

	all_input[game_path + player] = input_frame

	# print(all_input)

	return all_input
