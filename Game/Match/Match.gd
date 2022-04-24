extends SGFixedNode2D

# TODO: Temp initialization
onready var player1_score = 0
onready var player2_score = 0

const game_scene = preload("res://Game/Game.tscn")


func _ready():
	pass
	# # TODO: Testing hack. Improve by actually spawning the game scene
	# $Game.set_meta('spawn_signal_name', 'Game')


func spawn_game():
	# TODO: Spawn in of game is being rollbacked
	SyncManager.spawn(
		"Game",
		self,
		game_scene
	)

	# TODO: Again, initialization variables
	# $Game/Fighter2.controlled_by = "c0"


# Called when one player dies. Resets the round by respawning the Game scene.
func round_reset(is_p2: bool):
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
	if is_p2:
		# New fighters being created, health is 0
		# print(String(game_figher1.get_instance_id()))
		# print(String(game_figher2.get_instance_id()))

		# game_figher2.health = -1
		print("P2 ded ")# + String(game_figher2.get_instance_id()))
		# game_figher1 = null
		# game_figher2 = null
		player1_score += 1
		# reload_game()
		# TODO: SyncManager.stop() To prevent syncmanager from getting mad that Game has been deleted. Besides, we don't need rollback between Games anyways.
		print("Dancing in the moonlight") #TODO: Testing despawn point
		print(self.get_path())
		SyncManager.despawn($Game) # TODO: Generalize; Game name in hierarchy is not "Game"
		# TODO: copy over data for despawned fighters; data dict
		SyncManager.spawn(
			"Game",
			self,
			game_scene
		)
		# game_figher1 = $Game/Fighter1
		# game_figher2 = $Game/Fighter2
		# game_figher2.controlled_by = "c0"
		# TODO: spawning the right way
		# SyncManager.despawn($Game)


# # Restarts a match round.
# func reload_game():
# 	game_figher1 = null
# 	game_figher2 = null
# 	var old_game = $Game
# 	self.remove_child(old_game)
# 	# TODO: remove scene immediately or something idk what is happening but it almost works 
# 	# Rollback frames are causing game to "remember" previous state when one player health is 0 and being hit by the other player.
# 	# When loading new scene, need to "drop" or "forget" previous rollback stashed frames to not revert to state where other player died.
# 	gonnadelete = old_game
# 	old_game.queue_free()
# 	print("queued free")


# 	var new_game = load(game_path).instance()
# 	self.add_child(new_game)
# 	game_figher1 = $Game/Fighter1
# 	game_figher2 = $Game/Fighter2
# 	print("New figher2: " + String(game_figher2.get_instance_id()))
# 	# TODO: Make sure values set in crude_connection on fighters remain the same in new scene
# 	game_figher2.controlled_by = "c0"
# 	print("Score: " + String(player1_score) + " - " + String(player2_score))


	
# TODO: Find fighters, set in _ready()
#		Reload Game scene after one Fighter dies
