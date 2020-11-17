class_name UltimateStealth
extends Ultimate

#onready var animation := load("res://game/player/AnimInvulnerable.tscn")

func _ready() -> void:
#	._ready()
	animation = load("res://game/player/AnimInvulnerable.tscn")
	create_sfx(
		"res://assets/sounds/sfx/player/ultimates/stealth/ultimatestealth4sec.wav",
		-10)

func use_ultimate() -> void:
	parent.set_is_in_god_mode(true)
	var new_anim:AnimInvulnerable = animation.instance()
	parent.add_child(new_anim)
	get_node("UltSFX").play()
	ult_timer.start()

func end_ultimate() -> void:
	parent.set_is_in_god_mode(false)
