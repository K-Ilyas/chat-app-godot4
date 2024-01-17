extends Node

signal server_created
signal join_success
signal join_fail
signal player_list_changed
signal player_removed(pid)
signal disconnected

var server_info = {
	used_port = 35555,
	max_players = 50
}
func _ready():
	create_server()
	
func create_server():
	var net = ENetMultiplayerPeer.new()
	if (net.create_server(server_info.used_port, server_info.max_players) != OK):
		print("Failed to create server")
		return
	print("Server created on port %d"%[server_info.used_port])

	server_created.emit()
	multiplayer.multiplayer_peer = net
	get_multiplayer().peer_connected.connect(_on_player_connected)
	get_multiplayer().peer_disconnected.connect(_on_player_disconnected)
	get_tree().change_scene_to_file("res://PanelUserList.tscn")
	
	
func _on_player_connected(id: int):
	print("New user connected : " + str(id))
	
func _on_player_disconnected(id: int):
	print("User %d has disconnected"%[id])
