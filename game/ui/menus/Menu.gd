class_name Menu
extends Control

#### Variables export
export var level_one := "res://game/levels/GameLevelOne.tscn"

#### Variables Onready
onready var video := $Video
onready var animenu := $AnimationMenu


#### Metodos
func _ready() -> void:
	video.play()
	GlobalMusic.play_music_obj(GlobalMusic.musics.main_menu)
	GlobalData.set_level_to_load(level_one)
	GlobalData.reset_player_data()
	print(GlobalData.get_ship_stats())


func _on_AnimatedSprite_animation_finished():
	animenu.play("playMenu")
