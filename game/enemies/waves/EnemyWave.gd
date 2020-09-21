extends Node

#### Variables
var total_wave_enemies := 0

func _ready() -> void:
	for path in get_children():
		total_wave_enemies += path.get_enemy_number()
	
	print(total_wave_enemies)
