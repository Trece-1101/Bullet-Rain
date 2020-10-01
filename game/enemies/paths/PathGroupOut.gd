tool
class_name PathGroupOut
extends PathGroup

#### Variables export
export var minimun_path_segment := 0.2

#### Metodos
func _ready() -> void:
	self.start_inside_screen = false

func create_segment() -> void:
	self.my_path_segment = (1.0 - minimun_path_segment)/ (self.enemy_number - 1)
