extends Control

@onready var adress = $Container/adress
@onready var port = $Container/port
@onready var nickname = $Container/nickname
@onready var error = $Container/error

signal data_moved
# Called when the node enters the scene tree for the first time.
func _ready():
	Client.connect("join_fail",_on_client_join_fail)
	Client.connect("join_success",join_success)

func _on_button_pressed():
	if adress.text != "" and port.text != "" and nickname.text != "" :
		Client.join_server(adress.text,int(port.text),nickname.text,65555)
	else :
		error.text = "Tous les champs sont obligatoires"

func _on_client_join_fail():
	error.text = "Soory Something went wrong !!! try again"
	adress.text = ""
	port.text = ""
	nickname.text = ""
	
func join_success():
	get_tree().change_scene_to_file("res://MainTest.tscn")
	


