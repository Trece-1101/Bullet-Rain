class_name Level, "res://assets/backgrounds/level_2.png"
extends Node

#### Señales
signal get_new_player
signal wait_new_player(time)

#### Constantes
const overlay_game_over := preload("res://game/ui/overlays/GameOver.tscn")

#### Variables Export
export var debuggeable := false
export var debug_panel: PackedScene
export var scroll_speed := 200.0
export var send_waves := true
export var send_player_ship := true
export var time_to_start_waves := 3.0
export var time_to_spawn_player := 2.5
export var level_name := "NombreNivel"
export var next_level := "res://game/levels/GameLevelOne.tscn"
export(
	String,
	"dummy",
	"level_one",
	"level_two",
	"level_three",
	"level_four",
	"level_five",
	"level_six",
	"level_seven") var music = "dummy"


#### Variables Onready
onready var parallax_bg := $BackGrounds/ParallaxBackground
onready var parallax_border := $BackGrounds/ParallaxBorder
onready var hud_layer := $HUD
onready var gui := $HUD/GUI
onready var overlay_layer := $Overlays
onready var ult_bar := $HUD/GUI/RightMenu/MarginRightContainer/InformationSection/UltimateContainer/UltimateProgress
onready var drone_bar := $HUD/GUI/RightMenu/MarginRightContainer/InformationSection/DroneContainer/DroneProgress
onready var player_timer: Timer
onready var floaker_container := $FlockerContainer

#### Variables
var ship_order := [] setget set_ship_order
var current_ship_index := 0
var player_can_ultimatear := false
var player_can_dronear := false
var flockers := []

func set_ship_order(value: Array) -> void:
	ship_order = value

#### Metodos
func _ready() -> void:
	GlobalData.reset_level_time()
	add_to_group("game_level")
	set_ship_order(GlobalData.get_ship_order().slice(0, 2)) 
	gui.set_usable_ship_order(GlobalData.get_ship_order().slice(3, 5))
	gui.set_level_name(level_name)
	ult_bar.connect("full_value", self, "_on_UltimateProgress_full_value")
	drone_bar.connect("full_value", self, "_on_DroneProgress_full_value")
	
	if send_player_ship:
		create_player_timer()
		player_timer.start()
	
	GlobalMusic.play_music(music)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	create_timer()
	if debuggeable and OS.is_debug_build():
		hud_layer.add_child(debug_panel.instance())

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and OS.is_debug_build():
		get_tree().quit()

func _process(delta: float):
	parallax_bg.scroll_offset += Vector2.DOWN * scroll_speed * delta
	parallax_border.scroll_offset += Vector2.DOWN * scroll_speed * delta


func create_player_timer() -> void:
	player_timer = Timer.new()
	player_timer.name = "player_timer"
	player_timer.connect("timeout", self, "_on_player_timer_timeout")
	player_timer.one_shot = true
	player_timer.autostart = false
	player_timer.wait_time = time_to_spawn_player
	add_child(player_timer)

func player_destroyed() -> void:
	emit_signal("wait_new_player", time_to_spawn_player)
	current_ship_index += 1
	if current_ship_index >= ship_order.size():
		var new_game_over := overlay_game_over.instance()
		yield(get_tree().create_timer(1.0),"timeout")
		overlay_layer.add_child(new_game_over)
	else:
		player_timer.start()

func _on_player_timer_timeout() -> void:
	create_player()

func create_player() -> void:
	var new_player:Player = ship_order[current_ship_index].instance()
	new_player.connect("destroy", self, "player_destroyed")
	new_player.connect("use_ultimate", self, "_reset_ultimate_cooldown")
	new_player.connect("use_drone", self, "_reset_drone_cooldown")
	new_player.set_allow_drones(player_can_dronear)
	new_player.set_can_ultimatear(player_can_ultimatear)
	gui.change_usable_ship(new_player.name)
	gui.change_hitpoints(new_player.get_hitpoints())
	add_child(new_player)
	GlobalData.global_player_alive = true
	emit_signal("get_new_player")

func create_timer() -> void:
	var send_waves_timer := Timer.new()
	send_waves_timer.one_shot = true
	send_waves_timer.wait_time = time_to_start_waves
	send_waves_timer.connect("timeout", self, "_on_send_waves_timer_timeout")
	add_child(send_waves_timer)
	send_waves_timer.start()

func _on_send_waves_timer_timeout() -> void:
	for child in get_children():
		if child.is_in_group("waves_level"):
			child.set_send_waves(send_waves)
			child.start_waves()

func _on_UltimateProgress_full_value() -> void:
	player_can_ultimatear = true
	if get_player() != null:
		get_player().set_can_ultimatear(true)

func _on_DroneProgress_full_value() -> void:
	player_can_dronear = true
	if get_player() != null:
		get_player().set_allow_drones(true)

func _reset_ultimate_cooldown() -> void:
	player_can_ultimatear = false
	gui.reset_ultimate_cooldown()

func _reset_drone_cooldown() -> void:
	player_can_dronear = false
	gui.reset_drone_cooldown()

func get_player() -> Player:
	for child in get_children():
		if child is Player:
			return child
	
	return null

func _next_level() -> void:
	yield(get_tree().create_timer(4.0),"timeout")
	GlobalData.set_level_to_load(next_level)
	get_tree().change_scene("res://game/ui/menus/Hangar.tscn")
