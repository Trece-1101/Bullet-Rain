class_name LevelWaves, "res://assets/enemies/extras/sea-waves.png"
extends Node

#### Variables export
export var big_boss: PackedScene
export var time_for_spawn_boss := 4.0
export(String, "level_one_to_boss", "dummy") var big_boss_music_transition = "level_one_to_boss"

#### Variables
var current_wave := 0
var total_waves := 0
var send_waves := true


#### Metodos
func _ready() -> void:
	add_to_group("waves_level")
	yield(owner, "ready")


func start_waves() -> void:
	if send_waves:
		total_waves = get_child_count()
		get_children()[current_wave].create_paths()
		for child in get_children():
			child.connect("send_next_wave", self, "spawn_wave")

func spawn_wave() -> void:
	current_wave += 1
	if current_wave < total_waves:
		get_children()[current_wave].create_paths()
	else:
		GlobalMusic.music_transition(big_boss_music_transition)
		yield(get_tree().create_timer(time_for_spawn_boss),"timeout")
		var new_boss := big_boss.instance()
		add_child(new_boss)


func set_send_waves(value: bool) -> void:
	send_waves = value
