extends Control


	# 	var peer = NetworkedMultiplayerENet.new()
	# 	peer.create_server(25565, 1)
	# 	get_tree().network_peer = peer
	# 	set_network_master(get_tree().get_network_unique_id())
	# 	SyncManager.start()
	# pass

	# if not is_p2:
	# 	var peer = NetworkedMultiplayerENet.new()
	# 	peer.create_server(25565, 1)
	# 	get_tree().network_peer = peer
	# 	set_network_master(get_tree().get_network_unique_id())
	# 	SyncManager.start()

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

func _on_network_peer_connected(peer_id : int):
	print("success!")