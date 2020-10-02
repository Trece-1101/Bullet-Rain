class_name Menu
extends Control

export(Array, String) var containers := []

#### Metodos
func _ready() -> void:
	for container in containers:
		var node_container := get_node_or_null(container)
		if node_container != null:
			for child in node_container.get_children():
				get_button_connection(child)

func get_button_connection(child: Object) -> void:
	if child is ChangeSceneButton:
# warning-ignore:return_value_discarded
		child.connect("pressed", self, "change_menu", [child.go_to_scene])


func change_menu(menu: String) -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene(menu)
