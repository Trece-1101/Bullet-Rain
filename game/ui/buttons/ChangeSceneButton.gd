class_name ChangeSceneButton
extends Button

#### Variables Export
export var go_to_scene := ""

#### Metodos
func change_menu(menu: String) -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene(menu)
