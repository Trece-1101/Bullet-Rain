class_name PathGroup
extends PathEndOut

var my_path_segment := 1.0
var my_return := "stop"

func _ready() -> void:
	if self.enemy_number <= 1:
		self.enemy_number = 2
	
	if not self.allow_enemy_shoot:
		my_return = "stop and shoot"
	
	create_segment()

func create_segment() -> void:
	pass

func at_end_of_path() -> String:
	return my_return

func check_new_end_of_path() -> void:
	self.end_of_path -= my_path_segment


func check_other_errors() -> Dictionary:
	var errors := {"value": false, "error": ""}
	if self.enemy_number <= 1:
		errors.value = true
		errors.error = "No tiene sentido el numero de enemigos"
	
	return errors
