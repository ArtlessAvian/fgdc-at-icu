extends Resource
class_name ThrowData
tool

export(bool) var is_air = false

const tech_window = 7
export(bool) var techable = true

# Includes tech window
export(int) var throw_length = 30

export(int) var damage = 1

export(int) var release_time = 20
export(int) var release_position_x = 150  # pixels relative to thrower
export(int) var release_position_y = 0  # pixels
export(int) var release_vel_x = 10  # pixels per frame
export(int) var release_vel_y = 10  # pixels per frame.
