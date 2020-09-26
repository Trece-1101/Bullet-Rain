tool
class_name PathGroupIn
extends PathGroup


func _ready() -> void:
	self.start_inside_screen = true

func create_segment() -> void:
	self.my_path_segment = 1.0 / (self.enemy_number - 1)
