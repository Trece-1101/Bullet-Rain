class_name GUI
extends Control

#### Constantes
const interceptor_on_texture_path:Texture = preload("res://assets/ui/hud/icons/player_yellow_on.png")
const bomber_on_texture_path:Texture = preload("res://assets/ui/hud/icons/player_red_on.png")
const stealth_on_texture_path:Texture = preload("res://assets/ui/hud/icons/player_blue_on.png")
const interceptor_off_texture_path:Texture = preload("res://assets/ui/hud/icons/player_yellow_off.png")
const bomber_off_texture_path:Texture = preload("res://assets/ui/hud/icons/player_red_off.png")
const stealth_off_texture_path:Texture = preload("res://assets/ui/hud/icons/player_blue_off.png")

#### Variables
var ships_stats := {}

#### Variables onready
onready var level_field := $LeftMenu/MarginLeftContainer/InformationSection/LevelContainer/NumLevelLabel
onready var time_field := $LeftMenu/MarginLeftContainer/InformationSection/TimeContainer/NumTimeLabel
onready var points_field := $LeftMenu/MarginLeftContainer/InformationSection/PointsContainer/NumPointsLabel
onready var scrap_field := $LeftMenu/MarginLeftContainer/InformationSection/ScrapContainer/NumScrapLabel

onready var player_container := $RightMenu/MarginRightContainer/InformationSection/PlayerContainer
onready var hitpoints_texture := $RightMenu/MarginRightContainer/InformationSection/HPContainer/TextureRect
onready var ultimate_bar := $RightMenu/MarginRightContainer/InformationSection/UltimateContainer/UltimateProgress
onready var drone_bar := $RightMenu/MarginRightContainer/InformationSection/DroneContainer/DroneProgress
onready var dmg_level_texture := $RightMenu/MarginRightContainer/InformationSection/DmgContainer/TextureRect
onready var rate_level_texture := $RightMenu/MarginRightContainer/InformationSection/RateContainer/TextureRect

onready var animation := $AnimationPlayer

func _ready() -> void:
	player_container.get_node("Stealth").texture = stealth_on_texture_path
	player_container.get_node("Bomber").texture = bomber_on_texture_path
	player_container.get_node("Interceptor").texture = interceptor_on_texture_path
	GlobalData.connect("send_update_gui_time", self, "_update_gui_time")
	GlobalData.connect("send_update_gui_points", self, "_update_gui_points")
	GlobalData.connect("send_update_gui_scrap", self, "_update_gui_scrap")
	GlobalData.connect("send_update_gui_hitpoints", self, "change_hitpoints")
	GlobalData.connect("send_update_gui_drone_and_ultimate", self, "update_drone_ultimate")
	reset_drone_cooldown()
	reset_ultimate_cooldown()
	ultimate_bar.set_maximus_decimus_meridius(GlobalData.ultimate_cooldown)
	drone_bar.set_maximus_decimus_meridius(GlobalData.drone_cooldown)
	_update_on_start()

func _update_on_start() -> void:
	_update_gui_points(GlobalData.get_points())
	_update_gui_scrap(GlobalData.get_scrap())

func _update_gui_time(minu: int, sec: int) -> void:
	time_field.text = "%02d : %02d" % [minu, sec]

func _update_gui_points(value: int) -> void:
	points_field.text = "{v}".format({"v": value})

func _update_gui_scrap(value: int) -> void:
	scrap_field.text = "{v}".format({"v": value})

func update_drone_ultimate(value: int) -> void:
	ultimate_bar.update_value(value)
	drone_bar.update_value(value)

func change_hitpoints(value: int) -> void:
	hitpoints_texture.texture.current_frame = value

func set_level_name(value: String) -> void:
	level_field.text = value

func set_usable_ship_order(ship_order: Array) -> void:
	for i in range(ship_order.size()):
		match ship_order[i]:
			"interceptor":
				player_container.move_child(player_container.get_node("Interceptor"), i)
			"bomber":
				player_container.move_child(player_container.get_node("Bomber"), i)
			"stealth":
				player_container.move_child(player_container.get_node("Stealth"), i)

func change_usable_ship(ship: String) -> void:
	var current_ship_name := ""
	if "Interceptor" in ship:
		player_container.get_node("Interceptor").texture = interceptor_off_texture_path
		current_ship_name = "interceptor"
	elif "Stealth" in ship:
		player_container.get_node("Stealth").texture = stealth_off_texture_path
		current_ship_name = "stealth"
	elif "Bomber" in ship:
		player_container.get_node("Bomber").texture = bomber_off_texture_path
		current_ship_name = "bomber"
	
	_set_ship_stats(current_ship_name)

func reset_drone_cooldown() -> void:
	drone_bar.reset()

func reset_ultimate_cooldown() -> void:
	ultimate_bar.reset()

func shake() -> void:
	animation.play("small_shake_one")

func _set_ship_stats(current_ship_name) -> void:
	ships_stats = GlobalData.get_ship_stats()
	for s in ships_stats:
		if current_ship_name == s:
			_set_level_textures(s)

func _set_level_textures(s: String) -> void:
	var current_ship_dmg = ships_stats[s]["dmg_level"]
	var current_ship_rate = ships_stats[s]["rate_level"]
	dmg_level_texture.texture.current_frame = current_ship_dmg + 1
	rate_level_texture.texture.current_frame = current_ship_rate + 1
