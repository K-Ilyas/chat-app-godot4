
extends Node

signal clock_changed(time)
var player_info = {}
var players = []
var latence = 0
var client_clock = 0
var arry_latence = []
var server_clock = 0

func _physics_process(delta):
	client_clock += delta
	NetworkClock.emit_signal("clock_changed",client_clock)
	#print(Time.get_datetime_dict_from_system(client_clock))


@rpc("any_peer")
func FetchServerTime(clientTime):
	var id = multiplayer.get_remote_sender_id()
	print("Clinet send time to the server" + str(clientTime))
	ReturnServerTime.rpc_id(id,Time.get_unix_time_from_system(),clientTime)


@rpc("authority")
func ReturnServerTime(serverTime,clientTime):
	latence = (Time.get_unix_time_from_system() - clientTime)/2
	arry_latence.append(latence)
	server_clock = serverTime
	print("Current Server Time  = " + str(serverTime) + " Latence " + str(latence))
	if len(arry_latence) == 10 :
		arry_latence.sort()
		print("les latence" + str(arry_latence))
		client_clock = server_clock + arry_latence[4]
		print("The Server correct time is " + str(Time.get_datetime_dict_from_system(client_clock)))
func fetch_time():
	for i in range(10):
		FetchServerTime.rpc_id(1,Time.get_unix_time_from_system())
	
	

