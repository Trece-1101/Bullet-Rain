extends Node

var dir_path = "user://Bullet-Rain-Saves/"

#### Checkers
func check_directory(create: bool) -> bool:
	var dir = Directory.new()
	if not dir.dir_exists(dir_path):
		if create:
			create_directory()
		
		return false
	
	return true

func create_directory() -> void:
	Directory.new().make_dir_recursive(dir_path)

func check_saved_data(slot: String) -> bool:
	var slot_path = slot + ".tres"
	return check_file(dir_path + slot_path)

func check_file(file_path: String) -> bool:
	var dir = Directory.new()
	if not dir.file_exists(file_path):
		return false
	
	return true

#### Creaters
func create_saved_slot(slot_name: String) -> void:
	GlobalData.reset_player_data()
	GlobalData.set_level_to_load("res://game/levels/GameLevelOne.tscn")
	save_game_data(slot_name)

#### Updaters
func update_saved_slot(slot_name: String) -> void:
	if check_saved_data(slot_name):
		save_game_data(slot_name)

#### Savers
func save_game_data(slot_name: String) -> void:
	var new_save := SaveGameData.new()
	
	new_save.saved_points = GlobalData.get_points()
	new_save.saved_scrap = GlobalData.get_scrap()
	new_save.saved_level_to_load = GlobalData.get_level_to_load()
	new_save.saved_ships_stats = GlobalData.get_ship_stats()
	new_save.saved_ship_order = GlobalData.get_ship_order()
	
	var slot_path := slot_name + ".tres"
	GlobalData.set_current_slot(slot_name)
	ResourceSaver.save(dir_path + slot_path, new_save)

#### Loaders
func load_game_data(slot_name: String) -> Dictionary:
	var slot_path = slot_name + ".tres"
	var saved_game_data = load_file(dir_path + slot_path)
	GlobalData.set_current_slot(slot_name)
	
	return {
		"saved_points": saved_game_data.saved_points,
		"saved_scrap": saved_game_data.saved_scrap,
		"saved_level_to_load": saved_game_data.saved_level_to_load,
		"saved_ships_stats": saved_game_data.saved_ships_stats,
		"saved_ship_order": saved_game_data.saved_ship_order
	}

func load_file(file_path):
	var data = load(file_path)
	return data

func load_details(slot_name: String) -> Dictionary:
	var slot_path = slot_name + ".tres"
	var saved_game_data = load_file(dir_path + slot_path)
	
	return {
		"saved_level_to_load": saved_game_data.saved_level_to_load,
	}

#### Deleters
func delete_performance_slot(slot_name: String) -> void:
	var slot_path = slot_name + ".tres"
	var dir = Directory.new()
	dir.remove(dir_path + slot_path)






