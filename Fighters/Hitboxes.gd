extends SGArea2D
class_name Hitboxes

signal on_hit(who)

# Has no logic, only holds onto information
# Hurtboxes will do the logic.

var _tick = 0 # only access if you're hurtboxes
 
# Called by animation players. Or by bored people.
func tick_me():
	_tick += 1

func _save_state() -> Dictionary:
	return {
		tick = _tick,
	}

func _load_state(save: Dictionary) -> void:
	_tick = save.tick
	