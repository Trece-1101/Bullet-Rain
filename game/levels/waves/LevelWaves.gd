extends Node

#### Variables
var current_wave := 0
var total_waves := 0

func _ready() -> void:
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
