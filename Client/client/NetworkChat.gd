
extends Node

signal join_success
signal join_fail
signal list_player_changed(players)
signal list_logs_changed(logs)
signal log_added(log)
signal new_message(message)

signal player_added(pid,pseudo)
signal player_removed(pinfo)
signal disconnected(cause_value)
signal kicked(pid,reason)

var messages = {}

func _ready():
	pass
	
func verify():
	if multiplayer. multiplayer_peer != null:
		print ("A connection already exists") 
	else :
		print ("No Connection between client and server")


@rpc("any_peer")
func send_message(message):
	print("A message sended from client to server",message)
	

func send_message_input(message):
	send_message.rpc_id(1,message)




@rpc("authority")
func brodcat_message(message):
	print("A message brodcat from the server to me",message)
	new_message.emit(message)



