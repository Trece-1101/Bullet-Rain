extends Node

#### Señales
signal send_next_wave()

#### Variables
var total_paths := 0


func create_paths() -> void:
	for path in get_children():
		path.connect("full_path_dead", self, "_on_full_path_dead")
		total_paths += 1
		path.create_path()


func _on_full_path_dead() -> void:
	total_paths -= 1
	if total_paths == 0:
		emit_signal("send_next_wave")
