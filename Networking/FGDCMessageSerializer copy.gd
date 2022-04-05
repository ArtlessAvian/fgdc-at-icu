# 		var bitpacking = 0
# 		bitpacking += 0 if path == game_path + fighter_1 else 1

# 		bitpacking += (all_input[path]["stick_x"] + 1) << 1
# 		bitpacking += (all_input[path]["stick_y"] + 1) << 3
# 		bitpacking += int(all_input[path]["light"]) << 5
# 		bitpacking += int(all_input[path]["heavy"]) << 6

# 	var input_frame = {
# 		stick_x = ((bitpacking >> 1) & 0b11) - 1,
# 		stick_y = ((bitpacking >> 3) & 0b11) - 1,
# 		light = bool((bitpacking >> 5) & 0b1),
# 		heavy = bool((bitpacking >> 6) & 0b1),
# 	}
