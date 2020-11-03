extends Node

onready var can_escape := false setget set_can_scape

func set_can_scape(value: bool) -> void:
	can_escape = value

func _ready() -> void:
	GlobalMusic.play_music("credits")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and can_escape:
		get_tree().change_scene("res://game/ui/menus/Menu.tscn")
