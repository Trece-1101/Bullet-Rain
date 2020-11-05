class_name MainButton
extends Button

export var is_quitter := false
export var go_to_scene := "res://game/ui/menus/Menu.tscn"

onready var selection_sound := $Selection
onready var move_sound := $Move

func _on_button_down() -> void:
	$Selection.play()


func _on_button_up() -> void:
	yield(get_tree().create_timer(0.2), "timeout")
	if is_quitter:
		get_tree().quit()
	else:
		if get_tree().paused:
			get_tree().paused = false
		get_tree().change_scene(go_to_scene)


func _on_Button_mouse_entered():
	$Move.play()
