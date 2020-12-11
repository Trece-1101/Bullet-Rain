class_name Menu
extends Control

#### Variables export
export var level_one := "res://game/levels/GameLevelOne.tscn"

#### Variables Onready
onready var video := $VideoPlayer
onready var animenu := $AnimationMenu


#### Metodos
func _ready() -> void:
	video.play()
	GlobalMusic.play_music_obj(GlobalMusic.musics.main_menu)
	GlobalData.set_level_to_load(level_one)
	GlobalData.reset_player_data()

func _on_VideoPlayer_finished():
	animenu.play("playMenu")

func _on_AnimationMenu_animation_finished(anim_name: String) -> void:
	if anim_name == "playMenu":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
