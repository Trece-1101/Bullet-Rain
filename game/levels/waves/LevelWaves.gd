class_name LevelWaves, "res://assets/enemies/extras/sea-waves.png"
extends Node

#### Constantes
const overlay_warning := preload("res://game/ui/overlays/Warning.tscn")


#### Variables export
export var big_boss: PackedScene
export var time_for_spawn_boss := 4.0
export(
	String,
	"dummy",
	"level_one_to_boss",
	"level_two_to_boss",
	"level_three_to_boss") var big_boss_music_transition = "dummy"

export var start_from_wave := 0

#### Variables
var current_wave := 0
var total_waves := 0
var send_waves := true


#### Metodos
func _ready() -> void:
	if start_from_wave > 0:
		current_wave = start_from_wave
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
		var new_warning := overlay_warning.instance()
		get_parent().overlay_layer.add_child(new_warning)
		GlobalMusic.music_transition(big_boss_music_transition)
		yield(get_tree().create_timer(time_for_spawn_boss),"timeout")
		var new_boss := big_boss.instance()
		add_child(new_boss)


func set_send_waves(value: bool) -> void:
	send_waves = value
