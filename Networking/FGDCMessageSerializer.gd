extends "res://addons/godot-rollback-netcode/MessageSerializer.gd"

var game_path = "/root/Crude/Game/"
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
		bitpacking += (all_input[path]["just_stick_x"] + 1) << 3
		bitpacking += (all_input[path]["stick_y"] + 1) << 5
		bitpacking += (all_input[path]["just_stick_y"] + 1) << 7
		bitpacking += int(all_input[path]["light"]) << 9
		bitpacking += int(all_input[path]["just_light"]) << 10
		bitpacking += int(all_input[path]["heavy"]) << 11
		bitpacking += int(all_input[path]["just_heavy"]) << 12

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
		just_stick_x = ((bitpacking >> 3) & 0b11) - 1,
		stick_y = ((bitpacking >> 5) & 0b11) - 1,
		just_stick_y = ((bitpacking >> 7) & 0b11) - 1,
		light = bool((bitpacking >> 9) & 0b1),
		just_light = bool((bitpacking >> 10) & 0b1),
		heavy = bool((bitpacking >> 11) & 0b1),
		just_heavy = bool((bitpacking >> 12) & 0b1)
	}

	all_input[game_path + player] = input_frame

	print(all_input)

	return all_input
