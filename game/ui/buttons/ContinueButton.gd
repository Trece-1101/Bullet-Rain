extends MainButton


func _on_button_up() -> void:
	var parent := owner
	parent.get_node("PauseSFX").play()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	parent.visible = false
