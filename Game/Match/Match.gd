extends SGFixedNode2D

onready var p1_score = 0
onready var p2_score = 0

var dead_timer = -1  # -1 if in game, non-negative if someone is dead

export(PackedScene) var game_scene = load("res://Game/Game.tscn")

# Set in crude_connection for each connection type. Each possible key should have corresponding property to set in Game._network_spawn().
var game_params = {}


func set_game_params(params: Dictionary) -> void:
	game_params = params


func _network_postprocess(input: Dictionary) -> void:
	if not self.has_node("Game"):
		spawn_game()

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


func round_reset() -> void:
	# no else if in case of double ko which is funny.
	if is_dead($Game/Fighter1):
		p2_score += 1
	if is_dead($Game/Fighter2):
		p1_score += 1

	print("Score: " + String(p1_score) + " - " + String(p2_score))
	despawn_game()
	spawn_game()


func spawn_game() -> void:
	SyncManager.spawn("Game", self, game_scene, game_params, false)
	dead_timer = -1


func despawn_game() -> void:
	if $Game != null:
		for child in $Game/Spawned.get_children():
			SyncManager.despawn(child)
		SyncManager.despawn($Game)


func is_dead(f: Fighter) -> bool:
	return f.health == 0


func _save_state() -> Dictionary:
	return {p1_score = p1_score, p2_score = p2_score, dead_timer = dead_timer}


func _load_state(save: Dictionary) -> void:
	p1_score = save.p1_score
	p2_score = save.p2_score
	dead_timer = save.dead_timer
