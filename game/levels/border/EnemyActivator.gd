extends Area2D

#### Metodos
func _on_area_entered(area: Area2D) -> void:	
	if area is EnemyShooter:
		var can_shoot:bool = area.get_inside_play_screen()
		if area.get_is_boss():
			can_shoot = false
		if can_shoot == false:
			yield(get_tree().create_timer(0.3), "timeout")
		area.set_inside_play_screen(not can_shoot)
