class_name BulletPlayer extends Bullet


func _process(delta: float) -> void:
	position += velocity * delta
