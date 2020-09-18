extends Node
class_name Level

#### Variables Export
export var debuggeable := false
export var debug_panel: PackedScene
export var scroll_speed := 200.0

#### Variables Onready
onready var parallax := $BackGrounds/ParallaxBackground

func _ready() -> void:
	if debuggeable:
		add_child(debug_panel.instance())

func _process(delta):
	parallax.scroll_offset += Vector2.DOWN * scroll_speed * delta
