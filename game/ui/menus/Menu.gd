class_name Menu
extends Control

onready var video := $Video
onready var animenu := $AnimationMenu

#### Metodos
func _ready() -> void:
	video.play()


func _on_AnimatedSprite_animation_finished():
	animenu.play("playMenu")
