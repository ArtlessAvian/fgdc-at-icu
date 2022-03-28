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

	# Tried reordering everything below here. it worked before, but it doesn't seem to work anymore.
	self.visible = false
	yield(get_tree().create_timer(1), "timeout")

	if get_tree().is_network_server():
		SyncManager.start()
		yield(get_tree().create_timer(0.1), "timeout")
		SyncManager.spawn(
			"Game", get_tree().root, game_scene, {p1_master = 1, p2_master = peer_id}
		)
