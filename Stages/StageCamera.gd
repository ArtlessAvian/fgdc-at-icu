extends Camera

# var game_camera
# func _ready():

# export var path_one: NodePath = ""
# export var path_two: NodePath = ""

# # Called when the node enters the scene tree for the first time.
# func _ready():
# 	pass  # Replace with function body.

# func _physics_process(_delta):
# 	var fighter_one = get_node(path_one)
# 	var fighter_two = get_node(path_two)

# 	# average x
# 	self.translation.x = fighter_one.translation.x
# 	self.translation.x += fighter_two.translation.x
# 	self.translation.x /= 2

# 	# max y
# 	self.translation.y = max(fighter_one.translation.y, fighter_two.translation.y)

# 	# clamp
# 	self.translation.x = clamp(self.translation.x, -6, 6)
# 	self.translation.y = max(2.5, self.translation.y)
