class_name MidBossBandit
extends EnemyBandit

export var orbitals_stats := {"speed": 1.5, "angle": 0, "distance": 300}

func _on_MinionSpawner_timeout() -> void:
	create_orbital(orbitals_stats.speed, orbitals_stats.angle, orbitals_stats.distance)
	$MinionSpawner.start()

func die() -> void:
	.die()
	$MinionSpawner.stop()
