class_name GUI
extends Control

const interceptor_on_texture_path:Texture = preload("res://assets/ui/hud/icons/player_yellow_on.png")
const bomber_on_texture_path:Texture = preload("res://assets/ui/hud/icons/player_red_on.png")
const stealth_on_texture_path:Texture = preload("res://assets/ui/hud/icons/player_blue_on.png")
const interceptor_off_texture_path:Texture = preload("res://assets/ui/hud/icons/player_yellow_off.png")
const bomber_off_texture_path:Texture = preload("res://assets/ui/hud/icons/player_red_off.png")
const stealth_off_texture_path:Texture = preload("res://assets/ui/hud/icons/player_blue_off.png")

onready var level_field := $LeftMenu/MarginLeftContainer/InformationSection/LevelContainer/NumLevelLabel
onready var time_field := $LeftMenu/MarginLeftContainer/InformationSection/TimeContainer/NumTimeLabel
onready var points_field := $LeftMenu/MarginLeftContainer/InformationSection/PointsContainer/NumPointsLabel
onready var scrap_field := $LeftMenu/MarginLeftContainer/InformationSection/ScrapContainer/NumScrapLabel

onready var player_container := $RightMenu/MarginRightContainer/InformationSection/PlayerContainer
onready var hitpoints_texture := $RightMenu/MarginRightContainer/InformationSection/HPContainer/TextureRect
onready var ultimate_bar := $RightMenu/MarginRightContainer/InformationSection/UltimateContainer/UltimateProgress
onready var drone_bar := $RightMenu/MarginRightContainer/InformationSection/DroneContainer/DroneProgress


func _ready() -> void:
	change_hitpoints(3)
	player_container.get_node("Stealth").texture = stealth_on_texture_path
	player_container.get_node("Bomber").texture = bomber_on_texture_path
	player_container.get_node("Interceptor").texture = interceptor_on_texture_path
	GlobalData.connect("send_update_gui_time", self, "_update_gui_time")


func _update_gui_time() -> void:
	time_field.text = "%02d : %02d" % [GlobalData.get_level_time()["minu"], GlobalData.get_level_time()["sec"]]


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
	if "Interceptor" in ship:
		player_container.get_node("Interceptor").texture = interceptor_off_texture_path
	elif "Stealth" in ship:
		player_container.get_node("Stealth").texture = stealth_off_texture_path
	elif "Bomber" in ship:
		player_container.get_node("Bomber").texture = bomber_off_texture_path


func change_hitpoints(value: int) -> void:
	hitpoints_texture.texture.set_frame(2)

