extends Node


func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(31415, 1)
	get_tree().network_peer = peer

	var game_scene: PackedScene = load("res://Game/Game.tscn")
	var game_instance = game_scene.instance()

	game_instance.get_node("Fighter1").set_network_master(
		get_tree().get_network_unique_id()
	)

	self.visible = false
	yield(get_tree().create_timer(0.1), "timeout")
	get_tree().root.add_child(game_instance)

	SyncManager.start()
