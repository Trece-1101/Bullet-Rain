extends Node
signal send_update_gui_time

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
	player_ships.bomber, "interceptor", "stealth", "bomber"] setget ,get_ship_order


func get_ship_order() -> Array:
	return ship_order

func get_level_time() -> Dictionary:
	return level_time

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


func _process_time() -> void:
	if get_tree().paused:
		return
	
	level_time.sec += 1
	if level_time.sec == 60:
		level_time.minu += 1
		level_time.sec = 0
	
	emit_signal("send_update_gui_time")
