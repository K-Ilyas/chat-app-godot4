class_name LabelLogs extends Label

var id: int
var pseudo: String
var message : String
var time : String



func _ready():
	$".".text = "[" + time + "]"+ " User " + pseudo + " " + "(" + str(id) + ")" +" " + message
	


