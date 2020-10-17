tool
extends Node

export var make_paths_invisible := false setget set_make_paths_invisible

#### Variables
var current_wave := 0
var total_waves := 0
var send_waves := true

func set_make_paths_invisible(value: bool) -> void:
	if value:
		if Engine.editor_hint:
			for wave in get_children():
				for path in wave.get_children():
					print(path.name)
					path.set_make_invisible(true)

#### Metodos
func _ready() -> void:
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
		print("Larga ese Boss maquinola")


func set_send_waves(value: bool) -> void:
	send_waves = value
