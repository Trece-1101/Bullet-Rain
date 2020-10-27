extends EnemyBoss

func _ready() -> void:
	is_aimer = false
	toogle_area_shoot(true)
	spawn_shield(0.7)


func _on_EnemyPart_destroyed() -> void:
	pass

func toogle_area_shoot(value: bool) -> void:
	for child in get_children():
		if child.is_in_group("enemy_part"):
			child.set_can_shoot(value)
			child.set_can_shoot_bomb(value)

func die() -> void:
	.die()
	for child in get_children():
		if child.is_in_group("enemy_part"):
			child.die_from_boss()
