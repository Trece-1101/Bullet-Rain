class_name EnemyShield
extends Area2D

var is_deactivating := false

func _on_area_entered(area: Area2D) -> void:
	area.destroy()


func _on_body_entered(body: Node) -> void:
	body.die()

func disable_with_delay() -> void:
	is_deactivating = true
	yield(get_tree().create_timer(2.0), "timeout")
	queue_free()
