class_name UltimateInterceptor
extends Ultimate

func _ready() -> void:
	._ready()
	create_sfx(
		"res://assets/sounds/sfx/player/shoot/09shoot.wav",
		0.0)

func use_ultimate() -> void:
	get_node("UltSFX").play()
	get_tree().call_group("bullet_enemy", "destroy")
	get_tree().call_group("enemy_shooter", "disabled_shooting")
