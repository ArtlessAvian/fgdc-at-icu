extends Control

# Lifted from the netcode tutorial
onready var host_field = $MarginContainer/GridContainer/HostField
onready var port_field = $MarginContainer/GridContainer/PortField


func _ready():
	get_tree().connect("network_peer_connected", self, "_on_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")


func _on_Server_button_up():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(int(port_field.text), 1)
	get_tree().network_peer = peer


func _on_Client_button_up():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(host_field.text, int(port_field.text))
	get_tree().network_peer = peer


func _on_network_peer_connected(peer_id: int):
	print("success!")
	SyncManager.add_peer(peer_id)

	var game_scene: PackedScene = load("res://Game/Game.tscn")
	var game_instance = game_scene.instance()

	game_instance.get_node("Fighter1").set_network_master(1)
	if peer_id != 1:
		game_instance.get_node("Fighter2").set_network_master(peer_id)
	else:
		game_instance.get_node("Fighter2").set_network_master(
			get_tree().get_network_unique_id()
		)

	# Tried reordering everything below here. it worked before, but it doesn't seem to work anymore.
	self.visible = false
	yield(get_tree().create_timer(1), "timeout")
	get_tree().root.add_child(game_instance)

	if get_tree().is_network_server():
		SyncManager.start()
