extends Area2D

#### Metodos
func _on_area_entered(area: Area2D) -> void:
	if area is EnemyShooter:
		var can_shoot:bool = area.get_inside_play_screen()
		area.set_inside_play_screen(not can_shoot)
