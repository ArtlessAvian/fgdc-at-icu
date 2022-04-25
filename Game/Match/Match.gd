extends SGFixedNode2D

# TODO: Temp initialization
onready var player1_score = 0
onready var player2_score = 0

#const game_scene = preload("res://Game/Game.tscn") # TODO: Trying new loading
export(PackedScene) var game_scene = load("res://Game/Game.tscn")

var last_tick_died = 0

# func _ready():
# 	add_to_group("network_sync")
# 	pass
# # TODO: Testing hack. Improve by actually spawning the game scene
# $Game.set_meta('spawn_signal_name', 'Game')


func spawn_game():
	# TODO: Spawn in of game is being rollbacked
	#		Rollback of initial Game spawn is more likely to occur the more rollback frames there are.
	#		SyncManager remembers when Game didn't exist, then rollbacks to that point.
	#		There are a few frames in the beginning of the game when Game doesn't exist.
	#  		Rollback doesn't happen on subsequent spawnings.
	#	 	Wait some more time after starting SyncManager?
	# TODO: SpawnManager._load_state() being called, causing Game to be despawned
	#		Being passed a dictionary called "state", which it is reading spawned objects from
	# 		Being called in series passing through SyncManager._physics_process, Step 1 (???)

	SyncManager.spawn("Game", self, game_scene, {}, false)

	# TODO: Again, initialization variables
	# $Game/Fighter2.controlled_by = "c0"


func despawn_game():
	if $Game != null:
		SyncManager.despawn($Game)


# Called when one player dies. Resets the round by respawning the Game scene.
func round_reset(f: Fighter):
	# print("TODO: Testing: " + self.name + " " + String(self.is_in_group(("network_sync"))))
	# print("Processing")

	# TODO: Game can be reloaded twice in one frame. Don't know if that is bad or not.
	# print("I am called")
	# TODO: Also check for p1 dying
	# if game_figher1 != null && game_figher2 != null && !is_instance_valid(gonnadelete):
	# 	if game_figher1.health == 0:
	# 		game_figher1.health = -1
	# 		game_figher1 = null
	# 		game_figher2 = null
	# 		player2_score += 1
	# 		print("P1 ded")
	# 		# reload_game()

	# Prevent multiple callings in same tick

	if f.is_p2:
		print("P2 ded on tick ", SyncManager.current_tick)

		if SyncManager.current_tick != last_tick_died:
			last_tick_died = SyncManager.current_tick
			player1_score += 1
		# TODO: SyncManager.stop() To prevent syncmanager from getting mad that Game has been deleted. Besides, we don't need rollback between Games anyways.
		despawn_game()  # TODO: Generalize; Game name in hierarchy is not "Game"
		# TODO: copy over data for despawned fighters; data dict
		spawn_game()

		print("Score: " + String(player1_score) + " - " + String(player2_score))
