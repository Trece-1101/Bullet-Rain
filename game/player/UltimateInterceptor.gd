class_name UltimateInterceptor
extends Ultimate

#func _ready() -> void:
#	._ready()
#	animation = load("res://game/player/AnimBlank.tscn")
#	create_sfx(
#		"res://assets/sounds/sfx/player/shoot/09shoot.wav",
#		0.0)

func use_ultimate() -> void:
	var new_anim:AnimBlank = animation.instance()
	parent.add_child(new_anim)
	get_node("UltSFX").play()
	get_tree().call_group("bullet_enemy", "destroy")
	get_tree().call_group("bomb", "destroy")
	get_tree().call_group("enemy_shooter", "disabled_shooting")
