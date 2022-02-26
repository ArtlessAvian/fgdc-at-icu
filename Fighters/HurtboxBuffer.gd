extends SGArea2D
class_name HurtboxBuffer

# Has no logic, only holds onto a hit.
# Information here is only useful within a frame, so no need to save.

var hit_flag = false
var damage = 0
var knockback = SGFixedVector2.new()