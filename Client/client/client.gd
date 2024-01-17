
extends Node

signal join_success
signal join_fail
signal list_player_changed(players)
signal list_logs_changed(logs)
signal list_messages_changed(messages)
signal log_added(log)


signal player_added(pid,pseudo)
signal player_removed(pinfo)
signal disconnected
signal kicked(pid,reason)
var player_info = {}
var players = []
var logs = []

func _ready():
 multiplayer.multiplayer_peer = null
 


func join_server(ip, port, pseudo, client_port):
 if multiplayer. multiplayer_peer != null:
  print ("A connection already exists") 
  return
 var peer = ENetMultiplayerPeer.new() 
 
 var error = peer.create_client(ip, port) 

 if (error != OK):
  print ("Failed to create client")
  Client.emit_signal("join_fail")
  end_connection()
  return
 player_info["pseudo"] = pseudo
 player_info["time"] = Time.get_unix_time_from_system()
 print("Client created")

 multiplayer.multiplayer_peer = peer
 get_multiplayer().connected_to_server.connect(_on_connected_to_server)
 get_multiplayer().connection_failed.connect(_on_connection_failed) 
 get_multiplayer().server_disconnected.connect(_on_disconnected_from_server)
 set_multiplayer_authority(1)
 Client.emit_signal("join_success")
 Client.connect("disconnected",_on_disconnected)

 

func end_connection():
 multiplayer.multiplayer_peer= null
 player_info.pseudo = ""
 player_info.id = 0

func _on_connection_failed():
 print("connection faild to the server")
	
func _on_connected_to_server():
 print("connected to the server")
 NetworkClock.fetch_time()
 send_info.rpc_id(1,player_info)
 
 

func _on_disconnected_from_server():
 print("User has disconnected from the server")


@rpc("any_peer") 
func send_info(player):
 print("user send player info", multiplayer.get_unique_id())



@rpc("authority")
func send_list_players(players,logs,messages):
 self.players = players
 print("List of servers sent by the server",players)
 Client.emit_signal("list_player_changed",players)
 Client.emit_signal("list_logs_changed",logs)
 Client.emit_signal("list_messages_changed",messages)


@rpc("authority")
func log_server(log):
 print(log)
 self.logs.append(log)
 print("wow")
 print("server send a new log",log)
 Client.emit_signal("log_added",log)




@rpc("authority")
func player_join_server(player):
 print(player)
 self.players.append(player)
 print("server send a new connected player",player)
 Client.emit_signal("player_added",player)

@rpc("authority")
func player_leave_server(player):
 self.players = self.players.filter(func (pl) : return pl["id"] != player["id"])
 print("server send a new disconnected player",player)
 Client.emit_signal("player_removed",player)

func _on_join_success():
 print("wow")


func _on_disconnected():
 end_connection()
 get_tree().change_scene_to_file("res://ConnectServer.tscn")
