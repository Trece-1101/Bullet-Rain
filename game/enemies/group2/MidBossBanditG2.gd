extends EnemyBandit


func _on_MinionSpawner_timeout() -> void:
	create_orbital(1.5, 0, 300)
	$MinionSpawner.start()
