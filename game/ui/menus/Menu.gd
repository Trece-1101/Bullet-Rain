class_name Menu
extends Control

onready var video := $Video
onready var animenu := $AnimationMenu

#### Metodos
func _ready() -> void:
	video.play()
	GlobalMusic.play_music_obj(GlobalMusic.musics.main_menu)


func _on_AnimatedSprite_animation_finished():
	animenu.play("playMenu")
