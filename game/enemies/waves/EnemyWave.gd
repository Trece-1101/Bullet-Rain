class_name EnemyWave, "res://assets/enemies/extras/sea_waves_2.png"
extends Node

#### Señales
signal send_next_wave()

export var send := true setget ,get_send

#### Variables
var total_paths := 0

func get_send() -> bool:
	return send

#### Metodos
func create_paths() -> void:
	for path in get_children():
		path.connect("full_path_dead", self, "_on_full_path_dead")
		total_paths += 1
		path.create_path()


func _on_full_path_dead() -> void:
	total_paths -= 1
	if total_paths == 0:
		emit_signal("send_next_wave")
