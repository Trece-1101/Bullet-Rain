extends Area2D


func _on_area_entered(area: Area2D) -> void:
	area.destroy()


func _on_body_entered(body: Node) -> void:
	body.die()
