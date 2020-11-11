extends EnemyBossBT



func spawn_minions(critic: bool, type: int) -> void:
	if critic:
		for pos in minions_positions.get_children():
			var new_minion:EnemyBase = critic_minions[type].instance()
			new_minion.global_position = pos.position
			new_minion.set_can_shoot(true)
			new_minion.set_allow_shoot(true)
			new_minion.set_inside_play_screen(true)
			get_parent().add_child(new_minion)
	else:
		for i in range(4):
			var new_minion:EnemyBeamer = normal_minions[i].instance()
			get_parent().add_child(new_minion)
