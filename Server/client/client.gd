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

var players = []
var logs = []

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

func _on_player_connected(id: int):
	print("New user connected : " + str(id))

func _on_player_disconnected(id: int):
	print("User %d has disconnected"%[id])
	#players = players.filter(func(player): return player["id"] != id)
	var player = self.players.filter(func(player): return player["id"] == id).front()
	player_leave_server.rpc(player)
	self.players = self.players.filter(func(player): return player["id"] != id)
	var new_log = { "id" : id, "pseudo" : player["pseudo"] , "message" : "discconnected from the server" , "time" :Time.get_unix_time_from_system()}
	self.logs.append(new_log)
	log_server.rpc(new_log)
			
@rpc("any_peer") 
func send_info(player):
	player_join_server.rpc({ "id" : multiplayer.get_remote_sender_id(), "pseudo" : player["pseudo"]})
	var new_log = { "id" : multiplayer.get_remote_sender_id(), "pseudo" : player["pseudo"] , "message" : "join the server","time" : player["time"]}
	log_server.rpc(new_log)
	self.players.append({ "id" : multiplayer.get_remote_sender_id(), "pseudo" : player["pseudo"]})
	self.logs.append(new_log)
	print("user send player info ", multiplayer.get_remote_sender_id())
	send_list_players.rpc_id( multiplayer.get_remote_sender_id(),players,logs,NetworkChat.messages)
	

@rpc("authority")
func log_server(log):
	self.logs.append(log)
	print("server send a new log",log)


@rpc("authority")
func send_list_players(players,logs,messages):
	print("server send list of players to all players",players,logs,messages)
	
@rpc("authority")
func player_join_server(player):
	print("server send a new connected player",player)

@rpc("authority")
func player_leave_server(player):
	print("server send a new disconnected player",player)
	

@rpc("any_peer")
func send_message(message,player):
	print("A message recived from the server",player,message)

