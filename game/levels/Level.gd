class_name Level
extends Node

#### Variables Export
export var debuggeable := false
export var debug_panel: PackedScene
export var scroll_speed := 200.0

#### Variables Onready
onready var parallax_bg := $BackGrounds/ParallaxBackground
onready var parallax_border := $BackGrounds/ParallaxBorder
onready var hud_layer := $HUD

func _ready() -> void:
	if debuggeable:
		hud_layer.add_child(debug_panel.instance())

func _process(delta):
	parallax_bg.scroll_offset += Vector2.DOWN * scroll_speed * delta
	parallax_border.scroll_offset += Vector2.DOWN * scroll_speed * delta
