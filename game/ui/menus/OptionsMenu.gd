extends Control

onready var resolutions := {
	"960 x 540": Vector2(960, 540),
	"1280 x 720": Vector2(1280, 720),
	"1366 x 768": Vector2(1366, 768),
	"1600 x 900": Vector2(1600, 900),
	"1920 x 1080": Vector2(1920, 1080)
	}

onready var res_button := $Control/OptionButton
onready var full_button := $Control/VBoxContainer/FullScreen

onready var indexes := {
	"master": AudioServer.get_bus_index("Master"),
	"music": AudioServer.get_bus_index("Music"),
	"sfx": AudioServer.get_bus_index("SFX")
}

onready var labels :={
	"Master": $Control/ValueGeneral,
	"Music": $Control/ValueMusic,
	"SFX": $Control/ValueSFX
}

onready var vol_diff := {
	"Master": 0.0,
	"Music": 0.0,
	"SFX": 0.0
}


var selected_resolution_index = 0

func _ready() -> void:
	GlobalMusic.play_music("credits")
	update_volume_label("Master")
	update_volume_label("Music")
	update_volume_label("SFX")
	
	res_button.flat = true
	for res in resolutions.keys():
		res_button.add_item(res)
	
	full_button.set_pressed(OS.window_fullscreen)
	
	var text_windows_size = String(OS.window_size.x) + " x "  + String(OS.window_size.y)
	
	for i in range(res_button.get_item_count()):
		if text_windows_size == res_button.get_item_text(i):
			res_button.select(i)
			selected_resolution_index = i


func _on_FullScreen_toggled(button_pressed: bool) -> void:
	OS.window_fullscreen = button_pressed


func _on_OptionButton_item_selected(index: int) -> void:
	var new_resolution:Vector2 = resolutions[res_button.get_item_text(index)]
	OS.window_size = new_resolution
	center_screen()

func center_screen() -> void:
	var screen_size := OS.get_screen_size()
	var res := OS.window_size 
	OS.set_window_position(screen_size * 0.5 - res * 0.5)

func update_volume_label(bus: String) -> void:
	var volume := AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus))
#	vol_diff[bus] = 0.0 - AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus))
	var label_text = "%01d" % (volume + 50)
	labels[bus].text = label_text

func change_volume(bus: String, up: bool) -> void:
	var old_volume := AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus))
	if up:
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index(bus),
			old_volume + 1
			)
	else:
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index(bus),
			old_volume - 1
			)
	update_volume_label(bus)


func _on_PlusGeneral_pressed() -> void:
	change_volume("Master", true)

func _on_MinusGeneral_pressed() -> void:
	change_volume("Master", false)

func _on_PlusMusic_button_up() -> void:
	change_volume("Music", true)

func _on_MinusMusic_pressed() -> void:
	change_volume("Music", false)

func _on_PlusSFX_button_up() -> void:
	change_volume("SFX", true)
	$SFXTest.play()

func _on_MinusSFX_button_down() -> void:
	change_volume("SFX", false)
	$SFXTest.play()
