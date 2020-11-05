extends Control

export var scene_to_go := "res://game/ui/menus/Menu.tscn"

func change_scene() -> void:
	get_tree().change_scene(scene_to_go)

func reload() -> void:
	get_tree().reload_current_scene()
