extends Node


onready var debug_1 = $DebugPanel1
onready var debug_2 = $DebugPanel2
onready var debug_3 = $DebugPanel3
onready var player: Player

func _ready() -> void:
	for child in get_parent().get_children():
		if child is Player:
			player = child
			break

func _process(delta: float) -> void:
	debug_1.text = "  Movimiento: {mov}\n  Cad Disparo: {cad}".format(
		{
			"mov": stepify(player.get_movement(), 0.01),
			"cad": player.get_shoot_rate(),
		}
	)

	debug_2.text = "  FPS: {fps}\n  Delta: {delta}".format(
		{
			"fps": str(Engine.get_frames_per_second()),
			"delta": str(delta),
		}
	)

	debug_3.text = "  Estado: {state}".format({"state": player.get_state()})
