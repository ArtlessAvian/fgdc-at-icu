extends SGFixedNode2D

# Match is responsible for resetting the Game, and keeping track of score.

onready var p1_score = 0
onready var p2_score = 0

var dead_timer = -1  # -1 if in game, non-negative if someone is dead
var game_params = {}


func set_character(scene: PackedScene, is_p2: bool = false, peer_id = 1) -> void:
	print("hello", scene.resource_path, is_p2, peer_id)

	var old = $Game/Fighter1 if not is_p2 else $Game/Fighter2
	var opponent = $Game/Fighter2 if not is_p2 else $Game/Fighter1
	var new = scene.instance()
	new.is_p2 = is_p2

	old.name = "delet me"
	new.name = "Fighter1" if not is_p2 else "Fighter2"

	$Game.add_child_below_node(old, new)
	old.queue_free()

	new.opponent_path = opponent.get_path()
	opponent.opponent_path = new.get_path()
	if not is_p2:
		$Game/Camera2D.path_one = new.get_path()
	else:
		$Game/Camera2D.path_two = new.get_path()

	new.set_network_master(peer_id)


func _network_postprocess(input: Dictionary) -> void:
	if is_dead($Game/Fighter1) or is_dead($Game/Fighter2):
		dead_timer += 1

	if dead_timer >= 0:
		# someone is dead
		if dead_timer < 10 or (dead_timer % 3 <= 1 and dead_timer < 60):
			$Game/Fighter1.hitstop = 1
			$Game/Fighter2.hitstop = 1
		if dead_timer >= 180 and $Game/Fighter1.grounded and $Game/Fighter2.grounded:
			round_reset()
		if dead_timer >= 300:  # allow for beating up dead bodies
			round_reset()


func round_reset():
	# no else if in case of double ko which is funny.
	if is_dead($Game/Fighter1):
		p2_score += 1
	if is_dead($Game/Fighter2):
		p1_score += 1

	print("Score: " + String(p1_score) + " - " + String(p2_score))

	# Reready everything.
	dead_timer = -1
	for child in $Game/Spawned.get_children():
		SyncManager.despawn(child)

	# TODO: UI thing for best of 3
	$Game._ready()
	if p1_score >= 2 or p2_score >= 2:
		p1_score = 0
		p2_score = 0
		self.get_node("..").reset_the_game()
	else:
		print($Game.name)
		print($Game/UILayer.name)
		print($Game/UILayer/UI.name)
		print($Game/UILayer/UI/TestIntro)
		$Game/UILayer/UI/TestIntro.start()
		$Game/Fighter1._ready()
		$Game/Fighter2._ready()


func is_dead(f: Fighter) -> bool:
	return f.health <= 0


func _save_state() -> Dictionary:
	return {p1_score = p1_score, p2_score = p2_score, dead_timer = dead_timer}


func _load_state(save: Dictionary) -> void:
	p1_score = save.p1_score
	p2_score = save.p2_score
	dead_timer = save.dead_timer
