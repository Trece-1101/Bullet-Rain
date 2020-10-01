extends Control

export var next_scene := ""

func change_scene() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene(next_scene)


func _on_VideoPlayer_finished() -> void:
	yield(get_tree().create_timer(2.0), "timeout")
	change_scene()
