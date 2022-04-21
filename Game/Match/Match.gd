extends SGFixedNode2D

# TODO: Temp initialization
onready var game_figher1 = $Game/Fighter1
onready var game_figher2 = $Game/Fighter2
onready var player1_score = 0
onready var player2_score = 0

const game_path = "res://Game/Game.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	print("Score: " + String(player1_score) + " - " + String(player2_score))

	# TODO: Game can be reloaded twice in one frame. Don't know if that is bad or not.
	if game_figher1 != null && game_figher2 != null:
		if game_figher1.health == 0:
			player2_score += 1
			reload_game()
		if game_figher2.health == 0:
			player1_score += 1
			reload_game()


# Restarts a match round.
func reload_game():
	game_figher1 = null
	game_figher2 = null
	var old_game = $Game
	self.remove_child(old_game)
	# TODO: remove scene immediately or something idk what is happening but it almost works 
	old_game.queue_free()

	var new_game = load(game_path).instance()
	self.add_child(new_game)
	game_figher1 = $Game/Fighter1
	game_figher2 = $Game/Fighter2
	# TODO: Make sure values set in crude_connection on fighters remain the same in new scene
	game_figher2.controlled_by = "c0"


	
# TODO: Find fighters, set in _ready()
#		Reload Game scene after one Fighter dies
