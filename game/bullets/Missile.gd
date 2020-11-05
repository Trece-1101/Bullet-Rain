class_name Missile
extends Bullet

func _ready() -> void:
	bullet_sprite.modulate = Color.crimson

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet_enemy"):
		var other_bullet:Bullet = area
		other_bullet.destroy()
		destroy()
	else:
		destroy()
