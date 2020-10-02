class_name ChangeSceneButton
extends Button

#### Variables Export
export var go_to_scene := ""

#### Metodos
func change_menu(menu: String) -> void:
	get_tree().change_scene(menu)
