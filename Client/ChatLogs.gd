class_name ChatLogs extends Panel

var label_logs_instance = preload("res://LabelLogs.tscn")
@onready var chat_logs = $ScrollContainer/VBoxContainer

## [LabelUser] nodes will have their id
## as their name

func _ready():

	Client.connect("log_added",log_added)
	Client.connect("list_logs_changed",list_logs_changed)

	
func add_message(id: int, pseudo: String,message : String,time :String):
	var label_log = label_logs_instance.instantiate()
	
	label_log.modulate = Color(40, 40, 40, 1.0)
	label_log.id = id
	label_log.pseudo = pseudo
	label_log.name = str(id)
	label_log.message = message
	label_log.time = time
	chat_logs.add_child(label_log)





func list_logs_changed(logs):
	for childer in chat_logs.get_children():
		childer.queue_free()
	for lg in logs :
		var date = Time.get_datetime_dict_from_unix_time(lg["time"])
		var formated_date = str( date["day"] )+"-" + str(  date["month"] )+"-"+str( date["year"])+ " " +str(  date["hour"]) +":"+ str( date["minute"])+":"+str( date["second"])
		add_message(lg["id"],lg["pseudo"],lg["message"], formated_date)


func log_added(lg):
	var date = Time.get_datetime_dict_from_unix_time(lg["time"])
	var formated_date = str( date["day"] )+"-" + str(  date["month"] )+"-"+str( date["year"])+ " " +str(  date["hour"]) +":"+ str( date["minute"])+":"+str( date["second"])
	add_message(lg["id"],lg["pseudo"] , lg["message"],formated_date)


