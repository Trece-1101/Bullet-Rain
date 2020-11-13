extends Node

#### Señales
signal send_update_gui_time(minu, sec)
signal send_update_gui_points(points)
signal send_update_gui_scrap(scrap)
signal send_update_gui_hitpoints(hitpoints)
signal send_update_gui_drone_and_ultimate(a_second)


#### Variables
var points := 0 setget ,get_points
var scrap := 0 setget ,get_scrap

#TODO: cooldowns
var ultimate_cooldown := 10 setget ,get_ultimate_cooldown
var drone_cooldown := 120 setget ,get_drone_cooldown
var original_ultimate_cooldown
var original_drone_cooldwon

var level_time := {"minu": 0, "sec": 0} setget ,get_level_time
var level_timer: Timer
var start_time := 0.0
var current_time := 0.0

var level_to_load := "res://game/levels/GameLevelOne.tscn" setget set_level_to_load

var player_ships := {
	"interceptor": preload("res://game/player/PlayerInterceptor.tscn"),
	"bomber": preload("res://game/player/PlayerBomber.tscn"),
	"stealth": preload("res://game/player/PlayerStealth.tscn")
	}

var ships_stats := {
	"interceptor": {"dmg_level": 0, "rate_level": 0},
	"bomber": {"dmg_level": 0, "rate_level": 0},
	"stealth": {"dmg_level": 0, "rate_level": 0}
	} setget ,get_ship_stats

var stats_cost := {
	"dmg": {
		"interceptor": {
			1: 1170, 2: 1463, 3: 2340, 4: 5616},
		"bomber": {
			1: 1050, 2: 1300, 3: 2017, 4: 5000},
		"stealth": {
			1: 900, 2: 1125, 3: 1800, 4: 4320}
		},
	"rate": {
		"interceptor": {
			1: 900, 2: 1125, 3: 1800, 4: 4320},
		"bomber": {
			1: 1050, 2: 1300, 3: 2017, 4: 5000},
		"stealth": {
			1: 1170, 2: 1463, 3: 2340, 4: 5616},
		}
	} setget ,get_stats_costs

#### Variables Onready
onready var ship_order := [
	player_ships.interceptor,
	player_ships.stealth,
	player_ships.bomber, "interceptor", "stealth", "bomber"] setget set_ship_order,get_ship_order


#### Setter y Getters
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

func get_ship_stats() -> Dictionary:
	return ships_stats

func get_stats_by_name(ship_name: String) -> Dictionary:
	var ss := {}
	if "Interceptor" in ship_name:
		ss = ships_stats.interceptor
	elif "Bomber" in ship_name:
		ss = ships_stats.bomber
	elif "Stealth" in ship_name:
		ss = ships_stats.stealth
	return ss

func get_stats_costs() -> Dictionary:
	return stats_cost

func get_level_time() -> Dictionary:
	return level_time

func get_ultimate_cooldown() -> int:
	return ultimate_cooldown

func get_drone_cooldown() -> int:
	return drone_cooldown

func set_level_to_load(value: String) -> void:
	level_to_load = value

func get_level_to_load() -> String:
	return level_to_load

func get_scrap() -> int:
	return scrap

func get_points() -> int:
	return points

#### Metodos
func _ready() -> void:
	original_drone_cooldwon = drone_cooldown
	original_ultimate_cooldown = ultimate_cooldown
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

func add_scrap(value: int) -> void:
	scrap += value
	emit_signal("send_update_gui_scrap", scrap)

func substract_scrap(value: int, ship: String, stat: String) -> void:
	scrap -= value
	ships_stats[ship][stat] += 1

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

func reset_level_time() -> void:
	drone_cooldown = original_drone_cooldwon
	ultimate_cooldown = original_ultimate_cooldown
	level_time.minu = 0
	level_time.sec = 0

func reset_player_data() -> void:
	points = 0
	scrap = 0
	level_time.minu = 0
	level_time.sec = 0
	start_time = 0.0
	current_time = 0.0
	ships_stats.interceptor.dmg_level = 0
	ships_stats.interceptor.rate_level = 0
	ships_stats.bomber.dmg_level = 0
	ships_stats.bomber.rate_level = 0
	ships_stats.stealth.dmg_level = 0
	ships_stats.stealth.rate_level = 0


