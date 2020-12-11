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
	"level_three_to_boss",
	"level_four_to_boss",
	"level_five_to_boss",
	"level_six_to_boss",
	"level_seven_to_boss") var big_boss_music_transition = "dummy"

export var start_from_wave := 0

#### Variables
var current_wave := 0
var total_waves := 0
var send_waves := true


#### Metodos
func _ready() -> void:
	if start_from_wave > 0 and OS.is_debug_build():
		current_wave = start_from_wave
	add_to_group("waves_level")
	yield(owner, "ready")

func start_waves() -> void:
	if send_waves:
		total_waves = get_child_count()
		get_children()[current_wave].create_paths()
		for child in get_children():
			child.connect("send_next_wave", self, "spawn_wave")

func _reveal_wave() -> void:
	if false and OS.is_debug_build():
		var total_enemies := 0
		var total_total_enemies := {}
		for wave in get_children():
			for path in wave.get_children():
				if path.enemies.size() == 0:
					print(path.enemies)
				var enemy = path.enemies[0]
				var enemy_type = enemy._bundled.names[0]
				if not "G4" in enemy_type:
					print("no es de este grupo", wave.name)
				if enemy_type in total_total_enemies.keys():
					total_total_enemies[enemy_type] += (1 * path.get_enemy_number())
				else:
					total_total_enemies[enemy_type] = (1 * path.get_enemy_number())
				total_enemies += path.get_enemy_number()
		print(total_enemies)
		print(total_total_enemies)


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
		new_boss.connect("destroy", get_parent(), "_next_level")
		add_child(new_boss)

func set_send_waves(value: bool) -> void:
	send_waves = value
