extends Button

export var is_quitter := false
export var go_to_scene := "res://game/levels/GameLevelOne.tscn"

func _on_button_down() -> void:
	$AudioStreamPlayer.play()

func _on_button_up() -> void:
	yield(get_tree().create_timer(0.2), "timeout")
	if is_quitter:
		get_tree().quit()
	else:
		get_tree().change_scene(go_to_scene)
