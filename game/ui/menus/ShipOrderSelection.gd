extends Control

#### Variables export
export var default_texture: Texture

#### Variables
var ship_selected_imgages := []
var ship_containers := []
var selected_ships := []
var ships_order := []

#### Variables Onready
onready var order_containers := [$OrderOneContainer, $OrderTwoContainer, $OrderThreeContainer]

#### Metodos
func _ready() -> void:
	GlobalMusic.play_music_obj(GlobalMusic.musics.hangar)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	for container in order_containers:
		ship_containers.append(container.get_node("ImgContainer").get_node("ShipIconContainer"))
		ship_selected_imgages.append(container.get_node("ImgContainer").get_node("ShipSelected"))
		connect_buttons(container)
	
	for box in ship_selected_imgages:
		box.texture = default_texture

func connect_buttons(order_container: VBoxContainer) -> void:
	var this_icon_container = order_container.get_node("ImgContainer").get_node("ShipIconContainer")
	for icon_button in this_icon_container.get_children():
		if icon_button is TextureButton:
			icon_button.connect("pressed", self, "_on_icon_pressed", [icon_button, order_container, this_icon_container])

func _on_icon_pressed(this_button: TextureButton, this_order_container: VBoxContainer, this_icon_container: VBoxContainer) -> void:
	var ship_selected := this_order_container.get_node("ImgContainer").get_node("ShipSelected")
	ship_selected.texture = this_button.texture_normal
	selected_ships.append(this_button.name)
	ships_order.append(this_order_container.name)
	manage_buttons(this_button, this_icon_container)
	if selected_ships.size() == 3:
		$Continue.disabled = false

func manage_buttons(this_button: TextureButton, this_icon_container: VBoxContainer) -> void:
	for ship_container in ship_containers:
		for other_button in ship_container.get_children():
			if ship_container == this_icon_container:
				other_button.disabled = true
			else:
				if other_button.name == this_button.name:
					other_button.disabled = true

func _on_Reset_pressed() -> void:
	$Continue.disabled = true
	selected_ships = []
	ships_order = []
	for ship_container in ship_containers:
		for icon in ship_container.get_children():
			icon.disabled = false
	
	for box in ship_selected_imgages:
		box.texture = default_texture


func order_ships() -> Array:
	var ordered_list := ["", "", ""]
	for i in range(ordered_list.size()):
		if "One" in ships_order[i]:
			ordered_list[0] = selected_ships[i]
		elif "Two" in ships_order[i]:
			ordered_list[1] = selected_ships[i]
		elif "Three" in ships_order[i]:
			ordered_list[2] = selected_ships[i]
	
	return ordered_list


func _on_Continue_pressed() -> void:
	GlobalData.set_ship_order(order_ships())
	get_tree().change_scene(GlobalData.get_level_to_load())
