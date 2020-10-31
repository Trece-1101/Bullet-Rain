extends Node
signal send_update_gui_time(minu, sec)
signal send_update_gui_points(points)
signal send_update_gui_hitpoints(hitpoints)
signal send_update_gui_drone_and_ultimate(a_second)

var points := 0
var ultimate_cooldown := 8 setget ,get_ultimate_cooldown
var drone_cooldown := 5 setget ,get_drone_cooldown

var level_time := {"minu": 0, "sec": 0} setget ,get_level_time
var level_timer: Timer
var start_time := 0.0
var current_time := 0.0

var player_ships := {
	"interceptor": preload("res://game/player/PlayerInterceptor.tscn"),
	"bomber": preload("res://game/player/PlayerBomber.tscn"),
	"stealth": preload("res://game/player/PlayerStealth.tscn")
}

onready var ship_order := [
	player_ships.interceptor, 
	player_ships.stealth,
	player_ships.bomber, "interceptor", "stealth", "bomber"] setget set_ship_order,get_ship_order

func set_ship_order(values: Array) -> void:
	for i in range(values.size()):
		if "Interceptor" in values[i]:
			ship_order[i] = player_ships.interceptor
			ship_order[i + 3] = "interceptor"
		elif "Bomber" in values[i]:
			ship_order[i] = player_ships.bomber
			ship_order[i + 3] = "bomber"
		elif "Stealth" in values[i]:
			ship_order[i] = player_ships.stealth
			ship_order[i + 3] = "stealth"


func get_ship_order() -> Array:
	return ship_order

func get_level_time() -> Dictionary:
	return level_time

func get_ultimate_cooldown() -> int:
	return ultimate_cooldown

func get_drone_cooldown() -> int:
	return drone_cooldown


func _ready() -> void:
	level_timer = Timer.new()
	level_timer.wait_time = 1.0
	level_timer.one_shot = false
	level_timer.autostart = false
	level_timer.name = "LevelTimer"
	level_timer.connect("timeout", self,  "_process_time")
	add_child(level_timer)
	level_timer.start()


func _process(_delta: float) -> void:
	pass

func update_gui() -> void:
	pass

func add_points(value: int) -> void:
	points += value
	emit_signal("send_update_gui_points", points)
	emit_signal("send_update_gui_drone_and_ultimate", 1)

func substract_hitpoints(value: int) -> void:
	emit_signal("send_update_gui_hitpoints", value)

func _process_time() -> void:
	if get_tree().paused:
		return
	
	level_time.sec += 1
	if level_time.sec == 60:
		level_time.minu += 1
		level_time.sec = 0
	
	emit_signal("send_update_gui_time", level_time.minu, level_time.sec)
	emit_signal("send_update_gui_drone_and_ultimate", 1)
