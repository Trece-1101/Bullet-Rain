extends Control


export var next_scene := "res://game/ui/menus/Menu.tscn"

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func change_scene() -> void:
	get_tree().change_scene(next_scene)
