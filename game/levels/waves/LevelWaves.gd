extends Node

#### Variables
var current_wave := 0
var total_waves := 0
var send_waves := true

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
