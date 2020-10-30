class_name AnimInvulnerable
extends AnimatedSprite

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("get_is_boss"):
		if area.get_is_boss():
			return

	if area.has_method("destroy"):
		area.destroy()
	elif area.has_method("die"):
		area.die()
