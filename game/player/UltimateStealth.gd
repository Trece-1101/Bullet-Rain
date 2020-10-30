class_name UltimateStealth
extends Ultimate

onready var animation := preload("res://game/player/invulnerability.tscn")

func _ready() -> void:
	._ready()
	create_sfx(
		"res://assets/sounds/sfx/player/ultimates/stealth/ultimatestealth4sec.wav",
		-10)

func use_ultimate() -> void:
	parent.set_is_in_god_mode(true)
	var new_anim := animation.instance()
	parent.add_child(new_anim)
	get_node("UltSFX").play()
	ult_timer.start()

func end_ultimate() -> void:
	parent.set_is_in_god_mode(false)
