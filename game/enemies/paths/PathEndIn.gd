class_name PathEndIn
extends EnemyPath

#### Metodos
func at_end_of_path() -> String:
	return "stop"

func _on_Enemy_destroyed() -> void:
	spawn_enemy()

func spawn_enemy() -> void:
	if enemies_spawned < enemy_number:
		create_random_enemy()
