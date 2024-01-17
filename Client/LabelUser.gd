class_name LabelUser extends Label

var id: int
var pseudo: String



func _ready():
	$".".text = pseudo + " " + "(" + str(id) + ")"



