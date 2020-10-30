class_name ChangeSceneButton
extends Button

#### Variables Export
export var go_to_scene := ""

#### Metodos
func _ready() -> void:
	add_to_group("change_scene_button")

func change_menu(menu: String) -> void:
	get_tree().change_scene(menu)
