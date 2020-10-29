class_name UltimateInterceptor
extends Ultimate

func use_ultimate() -> void:
	get_tree().call_group("bullet_enemy", "destroy")
	get_tree().call_group("enemy_shooter", "disabled_shooting")

