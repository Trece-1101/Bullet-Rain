extends Control

export var next_scene := "res://game/ui/menus/Menu.tscn"

func change_scene() -> void:
	get_tree().change_scene(next_scene)


func _on_VideoPlayer_finished() -> void:
	yield(get_tree().create_timer(2.0), "timeout")
	change_scene()
