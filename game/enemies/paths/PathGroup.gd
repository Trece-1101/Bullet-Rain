class_name PathGroup
extends PathEndOut

var my_path_segment := 1.0
var my_return := "stop"

func _ready() -> void:
	if not self.allow_enemy_shoot:
		my_return = "stop and shoot"
	
	my_path_segment = 1.0 / self.enemy_number

func at_end_of_path() -> String:
	return my_return

func check_new_end_of_path() -> void:
	self.end_of_path -= my_path_segment
