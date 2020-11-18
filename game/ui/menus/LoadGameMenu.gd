extends Control

onready var slot1 := $VBoxContainer/SlotsContainer/Slot1
onready var slot2 := $VBoxContainer/SlotsContainer/Slot2
onready var slot3 := $VBoxContainer/SlotsContainer/Slot3
onready var slots := [slot1, slot2, slot3]

onready var labels := [$NoSlot1, $NoSlot2, $NoSlot3]
onready var details := {"slot_1": {}, "slot_2": {}, "slot_3": {}}


func _ready() -> void:
	toggle_slot(false, slot1, $NoSlot1, "slot_1")
	toggle_slot(false, slot2, $NoSlot2, "slot_2")
	toggle_slot(false, slot3, $NoSlot3, "slot_3")
	check_data_in_slots()

func check_data_in_slots() -> void:
	for i in range(1, 4):
		var slot := "slot_"
		slot += String(i)
		if GameSaver.check_saved_data(slot):
			details[slot] = GameSaver.load_details(slot)
			toggle_slot(true, slots[i-1], labels[i-1], slot)

func toggle_slot(turn_on: bool, in_slot: Panel, in_label: Label, slot: String) -> void:
	in_label.visible = !turn_on
	if turn_on:
		in_slot.modulate = Color( 1, 1, 1, 1 )
		for child in in_slot.get_children():
			if "LoadGame" in child.name:
				child.disabled = false
			if child.name == "LevelLabel":
				child.text += ": " + details[slot]["saved_level_to_load"]
	else:
		for child in in_slot.get_children():
			if "LoadGame" in child.name:
				child.disabled = true
		in_slot.modulate = Color( 0, 0, 0, 1 )


func _on_LoadGame1_pressed() -> void:
	load_data("slot_1")

func _on_LoadGame2_pressed() -> void:
	load_data("slot_2")

func _on_LoadGame3_pressed() -> void:
	load_data("slot_3")

func load_data(slot: String) -> void:
	var data = GameSaver.load_game_data(slot)
	
	GlobalData.set_points(data["saved_points"])
	GlobalData.set_scrap(data["saved_scrap"])
	GlobalData.set_level_to_load(data["saved_level_to_load"])
	GlobalData.set_ship_stats(data["saved_ships_stats"])
	GlobalData.set_ship_order(data["saved_ship_order"])
	
	get_tree().change_scene(GlobalData.get_level_to_load())

