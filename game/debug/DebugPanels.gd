extends Node

#### Variables Onready
onready var debug_1 = $DebugPanel1
onready var debug_2 = $DebugPanel2
onready var debug_3 = $DebugPanel3
onready var debug_4 = $DebugPanel4
onready var player: Player

#### Variables
var bullets_container: Node 
var bullets_count := 0

func _ready() -> void:
	var parent := get_parent()
	while not "Level" in parent.name:
		parent = parent.get_parent()
	
	bullets_container = parent.get_node("BulletsContainer")

	for child in parent.get_children():
		if child is Player:
			player = child
			break

func _process(delta: float) -> void:
	bullets_count = bullets_container.get_child_count()
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
	
	debug_4.text = "  Balas: {balas}".format({"balas": bullets_count})
