class_name Level, "res://assets/backgrounds/level_2.png"
extends Node

#### Variables Export
export var debuggeable := false
export var debug_panel: PackedScene
export var scroll_speed := 200.0
export var send_waves := true
export var time_to_start_waves := 3.0

#### Variables Onready
onready var parallax_bg := $BackGrounds/ParallaxBackground
onready var parallax_border := $BackGrounds/ParallaxBorder
onready var hud_layer := $HUD

#### Metodos
func _ready() -> void:
	create_timer()
	if debuggeable:
		hud_layer.add_child(debug_panel.instance())

func create_timer() -> void:
	var send_waves_timer := Timer.new()
	send_waves_timer.one_shot = true
	send_waves_timer.wait_time = time_to_start_waves
# warning-ignore:return_value_discarded
	send_waves_timer.connect("timeout", self, "_on_send_waves_timer_timeout")
	add_child(send_waves_timer)
	send_waves_timer.start()

func _on_send_waves_timer_timeout() -> void:
	for child in get_children():
		if "WavesLevel" in child.name:
			child.set_send_waves(send_waves)
			child.start_waves()

func _process(delta: float):
	parallax_bg.scroll_offset += Vector2.DOWN * scroll_speed * delta
	parallax_border.scroll_offset += Vector2.DOWN * scroll_speed * delta
	$HUD/Label.text ="%s" % (OS.get_ticks_msec() * 0.001)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

