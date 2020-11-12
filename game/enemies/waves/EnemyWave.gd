class_name EnemyWave, "res://assets/enemies/extras/sea_waves_2.png"
extends Node

#### Señales
signal send_next_wave()

#### Variables export
export var send := true setget ,get_send
export(Array, PackedScene) var beamer
export var flocker: PackedScene

#### Variables
var total_paths := 0
var send_signal := 0

func get_send() -> bool:
	return send

#### Metodos
func create_paths() -> void:
	print(name)
	if beamer.size() > 0:
		for beam in beamer:
			var new_beamer:EnemyBeamer = beam.instance()
			new_beamer.connect("end_life", self, "_next_wave")
			add_child(new_beamer)
		return
		
	var x_pos := 400
	if flocker != null:
		var level_node = get_node("../../")
		var flocker_container = level_node.floaker_container
		var flocker_array = level_node.flockers
		for _i in range(26):
			var new_flocker:EnemyFloaker = flocker.instance()
			new_flocker.global_position = Vector2(x_pos, 150.0)
			x_pos += 25
			flocker_container.add_child(new_flocker)
			flocker_array.push_back(new_flocker)
		
		for f in flocker_container.get_children():
			f.set_floakers(flocker_array)
		
	for path in get_children():
		path.connect("full_path_dead", self, "_on_full_path_dead")
		total_paths += 1
		path.create_path()

func _on_full_path_dead() -> void:
	total_paths -= 1
	if total_paths == 0:
		emit_signal("send_next_wave")

func _next_wave() -> void:
	send_signal += 1
	if send_signal > 1:
		return
	emit_signal("send_next_wave")
