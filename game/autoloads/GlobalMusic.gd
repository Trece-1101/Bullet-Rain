extends Node

export var transition_time := 4.0

var fader_out_original_volume := 0.0

onready var musics := {
	"presentation": $Presentation,
	"main_menu": $Menu,
	"credits": $Credits,
	"level_one": $LevelOne,
	"level_one_boss": $LevelOneBoss,
	"level_two": $LevelTwo,
	"level_three": $LevelThree,
	"level_two_boss": $LevelTwoBoss,
	"level_three_boss": $LevelThreeBoss
}

onready var transitions := {
	"level_one_to_boss": [$LevelOne, $LevelOneBoss],
	"level_two_to_boss": [$LevelTwo, $LevelTwoBoss],
	"level_three_to_boss": [$LevelThree, $LevelThreeBoss]} setget ,get_transitions

onready var tween_fade_in := $TweenFadeIn
onready var tween_fade_out := $TweenFadeOut

func get_transitions() -> Dictionary:
	return transitions

func play_music(music: String) -> void:
	stop_all_music()
	musics[music].play()

func play_music_obj(music: Object) -> void:
	stop_all_music()
	music.play()

func stop_music(music: Object) -> void:
	music.stop()

func stop_all_music() -> void:
	for child in get_children():
		if child is AudioStreamPlayer:
			child.stop()

func transition(music_transition: String) -> void:
	$AnimationPlayer.play(music_transition)

func music_transition(transition_name: String) -> void:
	fade_in(transitions[transition_name][1])
	fade_out(transitions[transition_name][0])

func fade_in(music_fade_in: AudioStreamPlayer) -> void:
	var original_volume = music_fade_in.volume_db
	music_fade_in.volume_db = -30.0
	music_fade_in.play()
	tween_fade_in.interpolate_property(
		music_fade_in,
		"volume_db",
		-30.0,
		original_volume,
		transition_time * 0.6,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween_fade_in.start()


func fade_out(music_fade_out: AudioStreamPlayer) -> void:
	fader_out_original_volume = music_fade_out.volume_db
	tween_fade_out.interpolate_property(
		music_fade_out,
		"volume_db",
		music_fade_out.volume_db,
		-50,
		transition_time,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween_fade_out.start()


func get_volumes(bus: String) -> float:
	return AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus))

func set_volumes(bus: String, value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), value)

func _on_TweenFadeOut_tween_completed(object: Object, _key: NodePath) -> void:
	object.stop()
	object.volume_db = fader_out_original_volume
