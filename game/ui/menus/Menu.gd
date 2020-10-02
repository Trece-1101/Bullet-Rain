class_name Menu
extends Control


#### Metodos
func _ready() -> void:
	get_button_connection()


func get_button_connection() -> void:
	var button_container := get_tree().get_nodes_in_group("change_scene_button")
	for button in button_container:
		if button is ChangeSceneButton:
	# warning-ignore:return_value_discarded
			button.connect("pressed", self, "change_menu", [button.go_to_scene])


func change_menu(menu: String) -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene(menu)
