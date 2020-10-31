class_name AnimBlank
extends AnimatedSprite

func _ready() -> void:
	scale = Vector2(2.0, 2.0)


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("get_is_boss"):
		if area.get_is_boss():
			return
		
	if area.has_method("die"):
		area.die()
