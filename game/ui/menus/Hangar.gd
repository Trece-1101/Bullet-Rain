extends Control

export var interceptor_texture: Texture
export var bomber_texture: Texture
export var stealth_texture: Texture

var textures := []
var ships_names := ["interceptor", "bomber", "stealth"]
var texture_index = 0
var ships_stats := {}
var stats_costs := {}
var scrap_total := 0
var current_ship_name := ""
var current_ship_stats := {"dmg": 0, "rate": 0}

onready var ship_sprite := $BorderContainer/MarginContainer/ShipSprite
onready var scrap_total_label := $ScrapContainer/ScrapTotal
onready var buy_msg := $OnBuyMsg
onready var cost_label := $CostLabel
onready var dmg_texture := $DmgLevel
onready var rate_texture := $RateLevel
onready var on_buy_timer := $OnBuyTimer
onready var dmg_buy_button := $DmgBuy
onready var rate_buy_button := $RateBuy
onready var prev_ship := $Prev
onready var next_ship := $Next

func _ready() -> void:
	_set_scrap_label()
	stats_costs = GlobalData.get_stats_costs()
	buy_msg.visible = false
	cost_label.visible = false
	textures = [interceptor_texture, bomber_texture, stealth_texture]
	ship_sprite.texture = textures[texture_index]
	_set_ship_stats()

func _set_scrap_label() -> void:
	scrap_total = GlobalData.get_scrap()
	scrap_total_label.text = "{v}".format({"v": scrap_total})

func _set_ship_stats() -> void:
	ships_stats = GlobalData.get_ship_stats()
	current_ship_name = ships_names[texture_index]
	for s in ships_stats:
		if current_ship_name == s:
			_set_level_textures(s)

func _set_level_textures(s: String) -> void:
	current_ship_stats.dmg = ships_stats[s]["dmg_level"]
	current_ship_stats.rate = ships_stats[s]["rate_level"]
	dmg_texture.texture.current_frame = current_ship_stats.dmg + 1
	rate_texture.texture.current_frame = current_ship_stats.rate + 1
	if current_ship_stats.dmg == 4:
		dmg_buy_button.disabled = true
	else:
		dmg_buy_button.disabled = false
	
	if current_ship_stats.rate == 4:
		rate_buy_button.disabled = true
	else:
		rate_buy_button.disabled = false

func _get_cost(stat: String) -> int:
	var new_cost: int = stats_costs[stat][current_ship_name][current_ship_stats[stat] + 1]
	cost_label.text = "Costo\nChatarra\n{c}".format({"c": new_cost})
	return new_cost

func _on_Prev_pressed() -> void:
	change_texture(-1)

func _on_Next_pressed() -> void:
	change_texture(1)

func change_texture(value: int) -> void:
	texture_index += value
	if texture_index < 0:
		texture_index = textures.size() - 1
	elif texture_index == textures.size():
		texture_index = 0
	
	ship_sprite.texture = textures[texture_index]
	_set_ship_stats()


func _on_DmgBuy_mouse_entered() -> void:
	if dmg_buy_button.disabled:
		return
	_get_cost("dmg")
	cost_label.visible = true


func _on_RateBuy_mouse_entered() -> void:
	if rate_buy_button.disabled:
		return
	_get_cost("rate")
	cost_label.visible = true


func _on_DmgBuy_mouse_exited() -> void:
	cost_label.visible = false


func _on_RateBuy_mouse_exited() -> void:
	cost_label.visible = false


func _on_RateBuy_pressed() -> void:
	next_ship.disabled = true
	prev_ship.disabled = true
	var value := _get_cost("rate")
	_check_scrap(value, "rate_level")


func _on_DmgBuy_pressed() -> void:
	next_ship.disabled = true
	prev_ship.disabled = true
	var value := _get_cost("dmg")
	_check_scrap(value, "dmg_level")

func _check_scrap(value: int, stat: String) -> void:
	dmg_buy_button.disabled = true
	rate_buy_button.disabled = true
	buy_msg.visible = true
	cost_label.visible = false
	if value > scrap_total:
		buy_msg.text = "Chatarra insuficiente para comprar"
	else:
		buy_msg.text = "Nivel adquirido!"
		GlobalData.substract_scrap(value, ships_names[texture_index], stat)
		_set_scrap_label()
		_set_ship_stats()
	
	on_buy_timer.start()


func _on_OnBuyTimer_timeout() -> void:
	buy_msg.visible = false
	next_ship.disabled = false
	prev_ship.disabled = false
